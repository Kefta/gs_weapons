SWEP.Base = "weapon_csbase_smg"

SWEP.PrintName = "#CStrike_UMP45"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"

SWEP.Sounds = {
	shoot = "Weapon_UMP45.Single"
}

SWEP.Primary = {
	Ammo = "45acp",
	ClipSize = 25,
	DefaultClip = 125,
	Damage = 30,
	Cooldown = 0.105,
	RangeModifier = 0.82,
	Spread = Vector(0.04, 0.04),
	SpreadAir = Vector(0.24, 0.24)
}

SWEP.Primary.SpreadMove = SWEP.Primary.Spread

SWEP.Accuracy = {
	Base = 0,
	Divisor = 210,
	Offset = 0.5,
	Max = 1,
	Quadratic = true
}

SWEP.Kick = {
	Air = {
		UpBase = 0.125,
		LateralBase = 0.65,
		UpModifier = 0.55,
		LateralModifier = 0.0475,
		UpMax = 5.5,
		LateralMax = 4,
		DirectionChange = 10
	},
	Move = {
		UpBase = 0.55,
		LateralBase = 0.3,
		UpModifier = 0.225,
		LateralModifier = 0.03,
		UpMax = 3.5,
		LateralMax = 2.5,
		DirectionChange = 10
	},
	Crouch = {
		UpBase = 0.25,
		LateralBase = 0.175,
		UpModifier = 0.125,
		LateralModifier = 0.02,
		UpMax = 2.25,
		LateralMax = 1.25,
		DirectionChange = 10
	},
	Base = {
		UpBase = 0.275,
		LateralBase = 0.2,
		UpModifier = 0.15,
		LateralModifier = 0.0225,
		UpMax = 2.5,
		LateralMax = 1.5,
		DirectionChange = 10
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'q'
	SWEP.SelectionIcon = 'q'
	
	SWEP.CSSCrosshair = {
		Min = 6
	}
	
	SWEP.MuzzleFlashScale = 1.15
end
