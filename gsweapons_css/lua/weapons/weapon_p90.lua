DEFINE_BASECLASS( "weapon_csbase_smg" )

--- GSBase
SWEP.PrintName = "#CStrike_P90"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"
SWEP.Weight = 26

SWEP.Sounds = {
	primary = "Weapon_P90.Single"
}

SWEP.Primary = {
	Ammo = "57mmRound",
	ClipSize = 50,
	DefaultClip = 150,
	Cooldown = 0.07,
	Damage = 26,
	WalkSpeed = 245/250,
	RangeModifier = 0.84,
	Spread = {
		Base = 0.045,
		Air = 0.3,
		Move = 0.115
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'm'
	SWEP.SelectionIcon = 'm'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
	
	SWEP.MuzzleFlashScale = 1.2
	
	SWEP.EventStyle = {
		-- CS:S muzzle flash
		[5001] = "css_x",
		[5011] = "css_x",
		[5021] = "css_x",
		[5031] = "css_x"
	}
end

--- CSBase_SMG
SWEP.Accuracy = {
	Divisor = 175,
	Offset = 0.45,
	Max = 1,
	Quadratic = true
}

SWEP.Kick = {
	Air = {
		UpBase = 0.9,
		LateralBase = 0.45,
		UpModifier = 0.35,
		LateralModifier = 0.04,
		UpMax = 5.25,
		LateralMax = 3.5,
		DirectionChange = 4
	},
	Move = {
		UpBase = 0.45,
		LateralBase = 0.3,
		UpModifier = 0.2,
		LateralModifier = 0.0275,
		UpMax = 4,
		LateralMax = 2.25,
		DirectionChange = 7
	},
	Crouch = {
		UpBase = 0.275,
		LateralBase = 0.2,
		UpModifier = 0.125,
		LateralModifier = 0.002,
		UpMax = 3,
		LateralMax = 1,
		DirectionChange = 9
	},
	Base = {
		UpBase = 0.3,
		LateralBase = 0.225,
		UpModifier = 0.125,
		LateralModifier = 0.02,
		UpMax = 3.25,
		LateralMax = 1.25,
		DirectionChange = 8
	}
}
