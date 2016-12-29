do return true end

-- FIXME: Add bullet models, bullet rotation, and tracers
AddCSLuaFile()
DEFINE_BASECLASS("gs_baseentity")

ENT.PrintName = "Bullet"
ENT.Model = "models/props_c17/oildrum001.mdl"

local vHullMax = Vector(3, 3, 3)
local vHullMin = -vHullMax

function ENT:Initialize()
	BaseClass.Initialize(self)
	
	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(vHullMin, vHullMax)
	
	if (SERVER) then
		self:SetMoveCollide(MOVECOLLIDE_DEFAULT)
		self:SetTrigger(true)
	end
end

function ENT:SetupBullet(bullet)
	local pPlayer = self:GetOwner()
	local vSrc = bullet.Src
	local bIsValid = pPlayer ~= NULL
	
	if (not (bIsValid or vSrc)) then
		self:Remove()
		ErrorNoHalt(self:GetClass() .. " (gs_bullet) No bullet source specified and owner is invalid! Make sure SetOwner is run on the bullet entity before SetupBullet is called")
	else
		if (not vSrc) then
			vSrc = pPlayer:GetShootPos()
			bullet.Src = vSrc
		end
		
		self:SetPos(vSrc)
		
		bullet.Weapon = bIsValid and pPlayer:GetActiveWeapon() or nil
		self.m_tBullet = bullet
		
		local flHullSize = bullet.HullSize
		
		if (flHullSize) then
			local vBound = Vector(flHullSize, flHullSize, flHullSize)
			self:SetCollisionBounds(-vBound, vBound)
		end
	end
end

local phys_pushscale = GetConVar("phys_pushscale")

function ENT:Touch(pEntity)
	if (not self:ShouldHit(pEntity)) then
		return
	end
	
	local bullet = self.m_tBullet
	local sAmmoType
	local iAmmoType
	
	if (not bullet.AmmoType) then
		sAmmoType = ""
		iAmmoType = -1
	elseif (isstring(bullet.AmmoType)) then
		sAmmoType = bullet.AmmoType
		iAmmoType = game.GetAmmoID(sAmmoType)
	else
		iAmmoType = bullet.AmmoType
		sAmmoType = game.GetAmmoName(iAmmoType)
	end
	
	local iDamage = bullet.Damage or 1
	local iPlayerDamage = bullet.PlayerDamage or 0
	local iNPCDamage = bullet.NPCDamage or 0
	
	local iAmmoFlags = game.GetAmmoFlags(sAmmoType)
	local flAmmoForce = game.GetAmmoForce(sAmmoType)
	local iAmmoDamageType = game.GetAmmoDamageType(sAmmoType)
	local iAmmoPlayerDamage = game.GetAmmoPlayerDamage(sAmmoType)
	local iAmmoMinSplash = game.GetAmmoMinSplash(sAmmoType)
	local iAmmoMaxSplash = game.GetAmmoMaxSplash(sAmmoType)
	
	if (bit.band(iAmmoFlags, AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER) ~= 0) then
		if (iPlayerDamage == 0) then
			iPlayerDamage = iAmmoPlayerDamage
		end
		
		if (iNPCDamage == 0) then
			iNPCDamage = game.GetAmmoNPCDamage(sAmmoType)
		end
	end
	
	local tr = self:GetTouchTrace()
	local iActualDamage = iDamage
	
	if (pEntity:IsPlayer()) then
		if (iPlayerDamage ~= 0) then
			iActualDamage = iPlayerDamage
		end
	elseif (pEntity:IsNPC()) then
		if (iNPCDamage ~= 0) then
			iActualDamage = iNPCDamage
		end
	-- https://github.com/Facepunch/garrysmod-requests/issues/760
	elseif (SERVER and pEntity:IsVehicle()) then
		local pDriver = pEntity:GetDriver()
		
		if (iPlayerDamage ~= 0 and pDriver:IsPlayer()) then
			iActualDamage = iPlayerDamage
		elseif (iNPCDamage ~= 0 and pDriver:IsNPC()) then
			iActualDamage = iNPCDamage
		end
	end
	
	if (iActualDamage == 0) then
		iActualDamage = iAmmoPlayerDamage == 0 and iDamage or iAmmoPlayerDamage -- Only players fire through this
	end
	
	local iActualDamageType = iActualDamage >= (bullet.GibDamage or 16) and bit.bor(iAmmoDamageType, DMG_ALWAYSGIB) or iAmmoDamageType
	local pWeapon = bullet.Weapon
	local pAttacker = bullet.Attacker and bullet.Attacker ~= NULL and bullet.Attacker or bIsValidOwner and pPlayer or self
	local vShotDir = self:_GetAbsVelocity()
	vShotDir:Normalize()
	
	local info = DamageInfo()
		local pPlayer = self:GetOwner()
		local bIsValidOwner = pPlayer ~= NULL
		info:SetAttacker(pAttacker)
		info:SetInflictor(bullet.Inflictor and bullet.Inflictor ~= NULL and bullet.Inflictor or pWeapon or bIsValidOwner and pPlayer or self)
		info:SetDamage(iActualDamage)
		info:SetDamageType(iActualDamageType)
		info:SetDamagePosition(tr.HitPos)
		info:SetDamageForce(vShotDir * flAmmoForce * (bullet.Force or 1) * phys_pushscale:GetFloat())
		info:SetAmmoType(iAmmoType)
		info:SetReportedPosition(bullet.Src or bIsValidOwner and pPlayer:GetShootPos() or vector_origin)
	pEntity:DispatchTraceAttack(info, tr, vShotDir)
	
	if (bullet.Callback) then
		bullet.Callback(pAttacker, tr, info)
	end
	
	-- FIXME: Not always working at high impact angles
	if (not pWeapon or not pWeapon.DoImpactEffect or not pWeapon:DoImpactEffect(tr, iActualDamageType)) then
		local data = EffectData()
			data:SetOrigin(tr.HitPos)
			data:SetStart(tr.StartPos)
			data:SetSurfaceProp(tr.SurfaceProps)
			data:SetDamageType(iActualDamageType)
			data:SetHitBox(tr.HitBox)
			data:SetEntity(tr.Entity)
		util.Effect("Impact", data)
	else
		local data = EffectData()
			data:SetOrigin(tr.HitPos)
			data:SetStart(tr.StartPos)
			data:SetDamageType(iActualDamageType)
		util.Effect("RagdollImpact", data)
	end
	
	self:Remove()
end

function ENT:ShouldHit(pEntity)
	return pEntity ~= self:GetOwner() and pEntity:GetClass() ~= self:GetClass()
end
