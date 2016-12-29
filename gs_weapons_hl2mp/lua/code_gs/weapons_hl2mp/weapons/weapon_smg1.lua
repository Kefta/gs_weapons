SWEP.Base = "weapon_hlbase_machinegun"

SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"

SWEP.Weight = 3

SWEP.Activities = {
	shoot_empty = ACT_INVALID,
	empty = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	reload = "Weapon_SMG1.Reload",
	empty = "Weapon_SMG1.Empty",
	shoot = "Weapon_SMG1.Single",
	altfire = "Weapon_SMG1.Double"
}

SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Cooldown = 0.075 // 13.3hz
SWEP.Primary.Damage = 5
SWEP.Primary.Spread = VECTOR_CONE_5DEGREES
SWEP.Primary.FireUnderwater = false

SWEP.Secondary.Ammo = "SMG1_Grenade"
SWEP.Secondary.DefaultClip = 2 -- Fix
SWEP.Secondary.Cooldown = 0.5
SWEP.Secondary.InterruptReload = true
SWEP.Secondary.FireUnderwater = false

SWEP.PunchAngle = {
	VerticalKick = 1,
	SlideLimit = 2
}

SWEP.GrenadeClass = "grenade_ar2"

if (CLIENT) then
	SWEP.KillIcon = '/'
	SWEP.SelectionIcon = 'a'
end

-- FIXME: Test empty times

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack(0)) then
		self:Shoot(false, 0)
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if (not self:CanSecondaryAttack(0)) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	pPlayer:RemoveAmmo(self:GetSpecialKey("Deduction", true), self:GetSecondaryAmmoName())
	self:PlaySound("altfire")
	self:PlayActivity("altfire")
	
	local flCooldown = self:GetSpecialKey("Cooldown", true)
	local flNextTime = CurTime() + flCooldown
	self:SetNextPrimaryFire(flNextTime + flCooldown)
	self:SetNextSecondaryFire(flNextTime)
	self:SetNextReload(flNextTime)
	
	if (SERVER) then
		// Create the grenade
		local pGrenade = ents.Create(self.GrenadeClass)
		
		if (pGrenade ~= NULL) then
			pGrenade:SetPos(self:GetShootSrc(true))
			pGrenade:_SetAbsVelocity(self:GetShootAngles(true):Forward() * 1000) -- FIXME: Force key
			pGrenade:SetOwner(pPlayer)
			pGrenade:SetLocalAngularVelocity(AngleRand(-400, 400))
			pGrenade:Spawn()
			pGrenade:SetMoveType(MOVETYPE_FLYGRAVITY)
			pGrenade:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
		end
	end
	
	return true
end

function SWEP:HandleFireOnEmpty(bSecondary)
	BaseClass.HandleFireOnEmpty(self, bSecondary)
	
	if (bSecondary and self.EmptyCooldown ~= -1) then
		local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", true) * 2
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
	end
end

function SWEP:HandleFireUnderwater(bSecondary)
	BaseClass.HandleFireUnderwater(self, bSecondary)
	
	if (bSecondary and self.UnderwaterCooldown ~= -1) then
		local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", true) * 2
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
	end
end
