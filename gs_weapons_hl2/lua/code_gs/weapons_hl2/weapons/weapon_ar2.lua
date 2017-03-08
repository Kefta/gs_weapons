SWEP.Base = "weapon_hlbase_machinegun"

SWEP.Spawnable = true
SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.CModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 5

SWEP.Sounds = {
	empty = "Weapon_IRifle.Empty",
	reload = "Weapon_AR2.Reload",
	shoot = "Weapon_AR2.Single",
	shoot2 = "Weapon_IRifle.Single",
	charge = "Weapon_CombineGuard.Special1"
}

SWEP.Activities = {
	shoot = function(self, iIndex)
		local iShots = self:GetPredictedVar("AnimLevel" .. iIndex, 0)
		
		if (iShots == 0 or iShots == 1) then
			return ACT_VM_PRIMARYATTACK
		end
		
		if (iShots == 2) then
			return ACT_VM_RECOIL1
		end
		
		if (iShots == 3) then
			return ACT_VM_RECOIL2
		end
		
		return ACT_VM_RECOIL3
	end,
	charge = ACT_VM_FIDGET
}

SWEP.Primary.Ammo = "AR2"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Cooldown = 0.1
SWEP.Primary.Spread = VECTOR_CONE_3DEGREES
SWEP.Primary.TracerName = "AR2Tracer"
SWEP.Primary.FireUnderwater = false

SWEP.Secondary.Ammo = "AR2AltFire"
SWEP.Secondary.DefaultClip = 2
SWEP.Secondary.Cooldown = 0.5
SWEP.Secondary.Force = 1000
SWEP.Secondary.FireUnderwater = false

SWEP.GrenadeClass = "prop_combine_ball"

SWEP.PunchAngle = {
	VerticalKick = 8,
	SlideLimit = 5
}

SWEP.PunchRand = {
	XMin = -8,
	XMax = -12,
	YMin = 1,
	YMax = 2,
	EyeMin = -4,
	EyeMax = 4
}

if (CLIENT) then
	SWEP.KillIcon = '2'
	SWEP.SelectionIcon = 'l'
end

local vLaunch = Vector(500, 500, 500)
local cFlash = Color(255, 255, 255, 64)
local sk_weapon_ar2_alt_fire_radius = GetConVar("sk_weapon_ar2_alt_fire_radius")
local sk_weapon_ar2_alt_fire_duration = GetConVar("sk_weapon_ar2_alt_fire_duration")
local sk_weapon_ar2_alt_fire_mass = GetConVar("sk_weapon_ar2_alt_fire_mass")

-- The anim level/shots fired aren't reset in the original AR2
-- And instead relied on the user to lift their mouse
-- This would cause jumpy animations
-- So I handled it like CS:S' shot counter and reset it on Deploy and Reload completion
function SWEP:SharedDeploy()
	for i = 0, self.ViewModelCount - 1 do
		if (self:GetPredictedVar("AnimLevel" .. i, 0) ~= 0) then
			self:SetPredictedVar("AnimLevel" .. i, 0)
		end
	end
end

if (SERVER or not game.SinglePlayer()) then
	function SWEP:ItemFrame()
		BaseClass.ItemFrame(self)
		
		for i = 0, self.ViewModelCount - 1 do
			if (self:UseViewModel(i)) then
				self:GetOwner():GetViewModel(i):SetPoseParameter("VentPoses", math.Remap(self:GetPredictedVar("AnimLevel" .. i, 0), 0, 5, 0, 1))
			end
		end
	end
end

function SWEP:MouseLifted(iIndex)
	BaseClass.MouseLifted(self, iIndex)
	
	if (self:GetPredictedVar("AnimLevel" .. iIndex, 0) ~= 0) then
		self:SetPredictedVar("AnimLevel" .. iIndex, 0)
	end
end

function SWEP:CanAttack(bSecondary --[[= false]], iIndex --[[= 0]])
	return not self:EventActive("charge_" .. (iIndex or 0)) and BaseClass.CanAttack(self, bSecondary, iIndex)
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:Launch(true, iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	local iLevel = self:GetPredictedVar("AnimLevel" .. iIndex, 0)
	
	if (iLevel ~= 5) then
		self:SetPredictedVar("AnimLevel" .. (iIndex or 0), iLevel + 1)
	end
end

function SWEP:Launch(bSecondary --[[= false]], iIndex --[[= 0]])
	local flCooldown = self:GetSpecialKey("Cooldown", bSecondary, iIndex)
	
	self:AddEvent("charge_" .. (iIndex or 0), flCooldown, function()
		local pPlayer = self:GetOwner()
		
		if (SERVER) then
			pPlayer:ScreenFade(SCREENFADE.IN, cFlash, 0.1, 0)
			
			// Create the grenade
			local pBall = ents.Create(self.GrenadeClass)
			
			if (pBall:IsValid()) then
				pBall:SetSaveValue("m_flRadius", sk_weapon_ar2_alt_fire_radius:GetFloat())
				
				pBall:SetPos(self:GetShootSrc(iIndex))
				pBall:SetOwner(pPlayer)
				
				local vVelocity = self:GetShootDir(iIndex)
				vVelocity:Mul(self:GetSpecialKey("Force", bSecondary, iIndex))
				pBall:_SetAbsVelocity(vVelocity)
				pBall:Spawn()
				
				local flTime = CurTime()
				pBall:SetSaveValue("m_flLastCaptureTime", flTime)
				pBall:SetSaveValue("m_nState", 2) -- STATE_THROWN
				pBall:SetSaveValue("m_flSpeed", vVelocity:Length())
				
				pBall:EmitSound("NPC_CombineBall.Launch")
				
				local pPhysObj = pBall:GetPhysicsObject()
				
				if (pPhysObj:IsValid()) then
					pPhysObj:AddGameFlag(FVPHYSICS_WAS_THROWN)
					pPhysObj:SetMass(sk_weapon_ar2_alt_fire_mass:GetFloat())
					pPhysObj:SetInertia(vLaunch)
				end
				
				-- WizzSoundThink seems to be set automatically, luckily!
				-- Otherwise, the entity would have to be pseudo-simulated by a grav gun
				-- And have all the values reset
				
				local sName = "GS-Weapons-HL2-Combine Ball Explode-" .. pBall:EntIndex()
				flTime = flTime + sk_weapon_ar2_alt_fire_duration:GetFloat()
				
				hook.Add("Tick", sName, function()
					if (not (pBall:IsValid() and pBall:GetSaveTable()["m_nState"] == 2)) then
						hook.Remove("Tick", sName)
					elseif (flTime <= CurTime()) then
						pBall:Fire("Explode")
						hook.Remove("Tick", sName)
					end
				end)
				
				pBall:SetSaveValue("m_bWeaponLaunched", true)
			end
		end
		
		pPlayer:RemoveAmmo(self:GetSpecialKey("Deduction", bSecondary, iIndex), self:GetAmmoType(bSecondary, iIndex))
		
		// Register a muzzleflash for the AI
		if (not self:DoMuzzleFlash(iIndex)) then
			pPlayer:MuzzleFlash()
		end
		
		pPlayer:SetAnimation(PLAYER_ATTACK1)
		
		local flNextTime = CurTime() + flCooldown
		self:SetNextAttack(flNextTime, iIndex)
		self:SetNextAttack(flNextTime + flCooldown, iIndex) -- Double the penalty
		self:SetNextReload(flNextTime, iIndex)
		
		self:Punch(bSecondary, iIndex)
		self:PlaySound("shoot2", iIndex)
		self:PlayActivity("shoot2", iIndex)
		
		return true
	end)
	
	self:PlaySound("charge", iIndex)
	
	return self:PlayActivity("charge", iIndex) ~= -1
end

function SWEP:Punch(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		//Disorient the player
		local pPlayer = self:GetOwner()
		local aPunch = pPlayer:GetLocalAngles()
		local tPunch = self.PunchRand
		
		-- FIXME: Make sure the random seed has been set
		aPunch[1] = aPunch[1] + code_gs.random:RandomInt(tPunch.EyeMin, tPunch.EyeMax)
		aPunch[2] = aPunch[2] + code_gs.random:RandomInt(tPunch.EyeMin, tPunch.EyeMax)
		aPunch[3] = 0
		
		pPlayer:SetEyeAngles(aPunch)
		
		-- Yes, the min/max are out of order on the pitch in the original weapon, too
		pPlayer:ViewPunch(Angle(code_gs.random:SharedRandomInt(pPlayer, "ar2pax", tPunch.XMin, tPunch.XMax), code_gs.random:SharedRandomInt(pPlayer, "ar2pay", tPunch.YMin, tPunch.YMax), 0))
	else
		BaseClass.Punch(self, false, iIndex)
	end
end

function SWEP:DoImpactEffect(tr)
	if (IsFirstTimePredicted()) then
		local data = EffectData()
			data:SetOrigin(tr.HitPos + tr.HitNormal)
			data:SetNormal(tr.HitNormal)
		util.Effect("AR2Impact", data)
	end
end

function SWEP:FinishReload(iIndex)
	if (self:GetPredictedVar("AnimLevel" .. iIndex, 0) ~= 0) then
		self:SetPredictedVar("AnimLevel" .. iIndex, 0)
	end
end

function SWEP:GetAmmoType(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:GetSecondaryAmmoType() or self:GetPrimaryAmmoType()) or -1
end

function SWEP:GetDefaultClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:GetDefaultClip2() or self:GetDefaultClip1()) or -1
end

function SWEP:GetMaxClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:GetMaxClip2() or self:GetMaxClip1()) or -1
end

function SWEP:GetClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:Clip2() or self:Clip1()) or -1
end

function SWEP:SetClip(iAmmo, bSecondary --[[= false]], iIndex --[[= 0]])
	if (iIndex == nil or iIndex == 0) then
		if (bSecondary) then
			self:SetClip2(iAmmo)
		else
			self:SetClip1(iAmmo)
		end
	end
end
