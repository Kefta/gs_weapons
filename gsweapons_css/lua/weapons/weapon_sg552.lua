DEFINE_BASECLASS( "weapon_csbase_rifle" )

--- GSBase
SWEP.PrintName = "#CStrike_SG552"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"

SWEP.Sounds = {
	primary = "Weapon_SG552.Single"
}

SWEP.Primary = {
	Ammo = "556mmRound",
	ClipSize = 30,
	DefaultClip = 120,
	Damage = 33,
	Cooldown = 0.09,
	WalkSpeed = 235/250,
	RangeModifier = 0.955,
	Spread = {
		Base = 0.02,
		Air = 0.45,
		Move = 0.075
	}
}

SWEP.Secondary.Cooldown = 0.135

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'A'
	SWEP.SelectionIcon = 'A'
	
	SWEP.CSSCrosshair = {
		Min = 5
	}
	
	SWEP.MuzzleFlashScale = 1.3
end

--- CSBase_SMG
SWEP.Accuracy = {
	Divisor = 220,
	Offset = 0.3,
	Max = 1,
	Additive = 0.035
}

SWEP.Kick = {
	Move = {
		UpBase = 1,
		LateralBase = 0.45,
		UpModifier = 0.28,
		LateralModifier = 0.04,
		UpMax = 4.25,
		LateralMax = 2.5,
		DirectionChange = 7
	},
	Air = {
		UpBase = 1.25,
		LateralBase = 0.45,
		UpModifier = 0.22,
		LateralModifier = 0.18,
		UpMax = 6,
		LateralMax = 4,
		DirectionChange = 5
	},
	Crouch = {
		UpBase = 0.6,
		LateralBase = 0.35,
		UpModifier = 0.2,
		LateralModifier = 0.0125,
		UpMax = 3.7,
		LateralMax = 2,
		DirectionChange = 10
	},
	Base = {
		UpBase = 0.625,
		LateralBase = 0.375,
		UpModifier = 0.25,
		LateralModifier = 0.0125,
		UpMax = 4,
		LateralMax = 2.25,
		DirectionChange = 9
	}
}

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:AdvanceZoom()
		
		return true
	end
	
	return false
end
