SWEP.Base = "weapon_csbase_smg"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.CModel = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.Sounds = {
	shoot = "Weapon_MP5Navy.Single"
}

SWEP.Primary.Ammo = "9mm"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Cooldown = 0.08
SWEP.Primary.Damage = 26
SWEP.Primary.RangeModifier = 0.84
SWEP.Primary.Spread = Vector(0.04, 0.04)
SWEP.Primary.SpreadAir = Vector(0.2, 0.2)
SWEP.Primary.SpreadMove = SWEP.Primary.Spread

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

if (CLIENT) then
	SWEP.KillIcon = 'x'
	SWEP.SelectionIcon = 'x'
	
	SWEP.CSSCrosshair = {
		Min = 6,
		Delta = 2
	}
	
	SWEP.MuzzleFlashScale = 1.1
end
