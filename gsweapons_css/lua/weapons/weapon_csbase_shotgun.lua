SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Shotgun"
SWEP.Slot = 3

SWEP.HoldType = "shotgun"
SWEP.Weight = 20

SWEP.Primary = {
	Range = 3000,
	FireUnderwater = false,
	InterruptReload = true,
	ReloadOnEmptyFire = true,
	RangeModifier = 0.7
}

SWEP.SingleReload = {
	Enable = true,
	QueuedFire = false,
	InitialRound = false
}

SWEP.PunchRand = {
	Alias = "Shotgun",
	GroundMin = 0,
	GroundMax = 0,
	AirMin = 0,
	AirMax = 0
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	// Update punch angles.
	local aPunch = pPlayer:GetViewPunchAngles()
	local tRandom = self.PunchRand
	
	aPunch[1] = aPunch[1] - (pPlayer:OnGround() and pPlayer:SharedRandomInt( tRandom.Alias .. "PunchAngleGround", tRandom.GroundMin, tRandom.GroundMax )
		or pPlayer:SharedRandomInt( tRandom.Alias .. "PunchAngleAir", tRandom.AirMin, tRandom.AirMax ))
	
	pPlayer:SetViewPunchAngles( aPunch )
end
