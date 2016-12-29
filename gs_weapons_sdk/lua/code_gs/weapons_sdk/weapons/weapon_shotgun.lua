SWEP.Base = "weapon_sdk_base"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.HoldType = "shotgun"
SWEP.Weight = 20

SWEP.Activities = {
	shoot = {
		ACT_VM_PRIMARYATTACK,
		idle = 2.5
	}
}

SWEP.Sounds = {
	shoot = "Weapon_M3.Single"
}

SWEP.Primary.Damage = 22
SWEP.Primary.Bullets = 9
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Cooldown = 0.875
SWEP.Primary.ReloadOnEmptyFire = true
SWEP.Primary.InterruptReload = true
SWEP.Primary.Spread = Vector(0.0675, 0.0675)

SWEP.SingleReload = {
	Enable = true,
	QueuedFire = false,
	InitialRound = false
}

SWEP.EmptyCooldown = 0.2
SWEP.UnderwaterCooldown = 0.15

SWEP.PunchRand = {
	GroundMin = 4,
	GroundMax = 8,
	AirMin = 8,
	AirMax = 11
}

if (CLIENT) then
	SWEP.KillIcon = 'k'
	SWEP.SelectionIcon = 'k'
end

function SWEP:Shoot(bSecondary, iIndex)
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	if (self:GetShootClip() == 0) then
		self:SetNextIdle(CurTime() + self:GetSpecialKey("Cooldown", bSecondary))
	end
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	local tPunch = self.PunchRand
	
	aPunch[1] = aPunch[1] - (pPlayer:OnGround() and code_gs.random:SharedRandomInt(pPlayer, "ShotgunPunchAngleGround", tPunch.GroundMin, tPunch.GroundMax)
		or code_gs.random:SharedRandomInt(pPlayer, "ShotgunPunchAngleAir", tPunch.AirMin, tPunch.AirMax))
	
	pPlayer:SetViewPunchAngles(aPunch)
end

function SWEP:GetShootAngles()
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + 2 * pPlayer:GetViewPunchAngles()
end
