SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/v_9mmAR.mdl"
SWEP.WorldModel = "models/w_9mmAR.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 15

SWEP.Sounds = {
	shoot = "Weapon_MP5.Single",
	shoot2 = "Weapon_MP5.Double"
}

SWEP.Primary.Ammo = "9mmRound"
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 75
SWEP.Primary.Cooldown = 0.1
SWEP.Primary.EmptyCooldown = 0.15
SWEP.Primary.Spread = game.SinglePlayer() and VECTOR_CONE_3DEGREES or VECTOR_CONE_6DEGREES

SWEP.Primary.PunchAngle = function(self, iIndex)
	local tPunch = self.PunchRand
	
	return Angle(code_gs.random:SharedRandomFloat(self:GetOwner(), self:GetClass() .. "-Punch" .. iIndex, tPunch.Min, tPunch.Max), 0, 0)
end

SWEP.Secondary.Ammo = "MP5_Grenade"
SWEP.Secondary.DefaultClip = 2
SWEP.Secondary.Cooldown = 1
SWEP.Secondary.EmptyCooldown = 0.15
SWEP.Secondary.Force = 800
SWEP.Secondary.PunchAngle = Angle(-10, 0, 0)

SWEP.GrenadeClass = "grenade_mp5"

SWEP.PunchRand = {
	Min = -2,
	Max = 2
}

function SWEP:Precache()
	BaseClass.Precache(self)
	
	-- Secondary fire grenade model
	util.PrecacheModel("models/grenade.mdl")
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
	
	self:SetNextAttack(0, true, iIndex) -- Don't penalise secondary time
end

function SWEP:Launch(bSecondary --[[= false]], iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
	
	if (SERVER) then
		local pGrenade = ents.Create(self.GrenadeClass)
		pGrenade:SetPos(self:GetShootSrc(iIndex))
		
		local vThrow = self:GetShootDir(iIndex) * self:GetSpecialKey("Force", bSecondary, iIndex)
		pGrenade:SetAngles(vThrow:Angle())
		pGrenade:_SetAbsVelocity(vThrow)
		pGrenade:SetOwner(pPlayer)
		
		-- Don't need to set the seed here since it's serverside only
		pGrenade:SetLocalAngularVelocity(Angle(code_gs.random:RandomFloat(-100, -500), 0, 0))
		pGrenade:Spawn()
		pGrenade:SetMoveType(MOVETYPE_FLYGRAVITY)
	end
	
	pPlayer:RemoveAmmo(self:GetSpecialKey("Deduction", bSecondary, iIndex), self:GetAmmoType(bSecondary, iIndex))
	
	local bActivity = self:PlayActivity("shoot2", iIndex) ~= -1
	
	if (not self:DoMuzzleFlash(iIndex)) then
		pPlayer:MuzzleFlash()
	end
	
	self:Punch(bSecondary, iIndex)
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	
	self:PlaySound("shoot2", iIndex)
	
	local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", bSecondary, iIndex)
	self:SetNextAttack(flNextTime, false, iIndex)
	self:SetNextAttack(flNextTime, true, iIndex)
	self:SetNextReload(flNextTime, iIndex)
	
	return self:PlayActivity("shoot2", iIndex) ~= -1
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
