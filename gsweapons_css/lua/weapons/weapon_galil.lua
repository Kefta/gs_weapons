SWEP.Base = "weapon_csbase_rifle"

SWEP.PrintName = "#CStrike_Galil"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"

SWEP.Sounds = {
	shoot = "Weapon_Galil.Single"
}

SWEP.Primary = {
	Ammo = "556mm",
	ClipSize = 35,
	DefaultClip = 125,
	Damage = 30,
	Cooldown = 0.09,
	WalkSpeed = 215/250,
	FireUnderwater = false,
	Spread = Vector(0.0375, 0.0375),
	SpreadAir = Vector(0.3, 0.3),
	SpreadMove = Vector(0.07, 0.07)
}

SWEP.Accuracy = {
	Divisor = 200,
	Offset = 0.35,
	Max = 1.25,
	Additive = Vector(0.04, 0.04)
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

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'v'
	SWEP.SelectionIcon = 'v'
	
	SWEP.MuzzleFlashScale = 1.6
	
	SWEP.ViewModelFlip = false
end
