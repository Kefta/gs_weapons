DEFINE_BASECLASS( "weapon_csbase_gun" )

--- GSBase
SWEP.PrintName = "CSBase_Shotgun"
SWEP.Spawnable = false
SWEP.Slot = 3

SWEP.HoldType = "shotgun"
SWEP.Weight = 20

SWEP.ReloadOnEmptyFire = true
SWEP.ReloadSingly = true

SWEP.Primary = {
	Range = 3000,
	FiresUnderwater = false,
	InterruptReload = true,
	RangeModifier = 0.7
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

--- CSBase_Shotgun
SWEP.Alias = "Shotgun"

SWEP.Random = {
	GroundMin = 0,
	GroundMax = 0,
	AirMin = 0,
	AirMax = 0
}

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	// Update punch angles.
	local aPunch = pPlayer:GetPunchAngle()
	
	if ( pPlayer:OnGround() ) then
		aPunch.p = aPunch.p - pPlayer:SharedRandomInt( self.Alias .. "PunchAngleGround", self.Random.GroundMin, self.Random.GroundMax )
	else
		aPunch.p = aPunch.p - pPlayer:SharedRandomInt( self.Alias .. "PunchAngleAir", self.Random.AirMin, self.Random.AirMax )
	end
	
	pPlayer:SetViewPunchAngles( aPunch )
end
