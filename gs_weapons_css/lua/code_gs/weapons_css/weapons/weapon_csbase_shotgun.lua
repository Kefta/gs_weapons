SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Shotgun"
SWEP.Slot = 3

SWEP.HoldType = "shotgun"
SWEP.Weight = 20

SWEP.Primary.Range = 3000
SWEP.Primary.FireUnderwater = false
SWEP.Primary.InterruptReload = true
SWEP.Primary.ReloadOnEmptyFire = true
SWEP.Primary.RangeModifier = 0.7

SWEP.SingleReload = {
	Enable = true,
	FireStall = true,
	InitialRound = false
}

SWEP.PunchRand = {
	Alias = "Shotgun", -- CRC string
	GroundMin = 0, -- Min random pitch on ground
	GroundMax = 0, -- Max random pitch on ground
	AirMin = 0, -- Min random pitch in air
	AirMax = 0 -- Max random pitch in air
}

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	// Update punch angles.
	local aPunch = pPlayer:GetViewPunchAngles()
	local tRandom = self.PunchRand
	
	aPunch[1] = aPunch[1] - (pPlayer:OnGround() and code_gs.random:SharedRandomInt(pPlayer, tRandom.Alias .. "PunchAngleGround", tRandom.GroundMin, tRandom.GroundMax)
		or code_gs.random:SharedRandomInt(pPlayer, tRandom.Alias .. "PunchAngleAir", tRandom.AirMin, tRandom.AirMax))
	
	pPlayer:SetViewPunchAngles(aPunch)
end
