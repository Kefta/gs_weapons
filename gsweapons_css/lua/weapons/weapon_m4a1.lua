DEFINE_BASECLASS( "weapon_csbase_rifle" )

--- GSBase
SWEP.PrintName = "#CStrike_M4A1"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.SilencerModel = "models/weapons/w_rif_m4a1_silencer.mdl"

SWEP.Activities = {
	secondary = ACT_VM_ATTACH_SILENCER
}

SWEP.Sounds = {
	primary = "Weapon_M4A1.Single",
	secondary = "Weapon_M4A1.Silencer_On",
	s_primary = "Weapon_M4A1.Silenced",
	s_secondary = "Weapon_M4A1.Silencer_Off"
}

SWEP.Primary = {
	Ammo = "556mmRound",
	ClipSize = 30,
	DefaultClip = 120,
	Damage = 33,
	Cooldown = 0.09,
	WalkSpeed = 230/250,
	RangeModifier = 0.97,
	Spread = {
		Base = 0.02,
		Air = 0.4,
		Move = 0.07
	}
}

SWEP.Secondary.Spread = {
	Base = 0.025
}

SWEP.SpecialType = SPECIAL_SILENCE

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'w'
	SWEP.SelectionIcon = 'w'
	
	SWEP.MuzzleFlashScale = 1.6
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
		LateralModifier = 0.045,
		UpMax = 3.75,
		LateralMax = 3,
		DirectionChange = 7
	},
	Air = {
		UpBase = 1.2,
		LateralBase = 0.5,
		UpModifier = 0.23,
		LateralModifier = 0.15,
		UpMax = 5.5,
		LateralMax = 3.5,
		DirectionChange = 6
	},
	Crouch = {
		UpBase = 0.6,
		LateralBase = 0.3,
		UpModifier = 0.2,
		LateralModifier = 0.0125,
		UpMax = 3.25,
		LateralMax = 2,
		DirectionChange = 7
	},
	Base = {
		UpBase = 0.65,
		LateralBase = 0.35,
		UpModifier = 0.25,
		LateralModifier = 0.015,
		UpMax = 3.5,
		LateralMax = 2.25,
		DirectionChange = 7
	}
}
