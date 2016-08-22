DEFINE_BASECLASS( "weapon_csbase_smg" )

--- GSBase
SWEP.PrintName = "#CStrike_MP5Navy"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.Sounds = {
	primary = "Weapon_MP5Navy.Single"
}

SWEP.Primary = {
	Ammo = "9mmRound_CStrike",
	ClipSize = 30,
	DefaultClip = 150,
	Cooldown = 0.08,
	Damage = 26,
	RangeModifier = 0.84,
	Spread = {
		Base = 0.04,
		Air = 0.2,
		Move = 0.04
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'x'
	SWEP.SelectionIcon = 'x'
	
	SWEP.CSSCrosshair = {
		Min = 6,
		Delta = 2
	}
	
	SWEP.MuzzleFlashScale = 1.1
end

--- CSBase_SMG
SWEP.Accuracy = {
	Base = 0,
	Divisor = 220,
	Offset = 0.45,
	Max = 0.75
}

SWEP.Kick = {
	Air = {
		UpBase = 0.9,
		LateralBase = 0.475,
		UpModifier = 0.35,
		LateralModifier = 0.0425,
		UpMax = 5,
		LateralMax = 3,
		DirectionChange = 6
	},
	Move = {
		UpBase = 0.5,
		LateralBase = 0.275,
		UpModifier = 0.2,
		LateralModifier = 0.03,
		UpMax = 3,
		LateralMax = 2,
		DirectionChange = 10
	},
	Crouch = {
		UpBase = 0.225,
		LateralBase = 0.15,
		UpModifier = 0.1,
		LateralModifier = 0.015,
		UpMax = 2,
		LateralMax = 1,
		DirectionChange = 10
	},
	Base = {
		UpBase = 0.25,
		LateralBase = 0.175,
		UpModifier = 0.125,
		LateralModifier = 0.02,
		UpMax = 2.25,
		LateralMax = 1.25,
		DirectionChange = 10
	}
}
