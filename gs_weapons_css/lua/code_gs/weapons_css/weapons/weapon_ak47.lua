SWEP.Base = "weapon_csbase_rifle"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.Sounds = {
	shoot = "Weapon_AK47.Single"
}

SWEP.Primary.Ammo = "762mm"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Damage = 36
SWEP.Primary.Cooldown = 0.1
SWEP.Primary.WalkSpeed = 221/250
SWEP.Primary.Spread = Vector(0.0275, 0.0275)
SWEP.Primary.SpreadAir = Vector(0.4, 0.4)
SWEP.Primary.SpreadMove = Vector(0.07, 0.07)

SWEP.Accuracy = {
	Divisor = 200,
	Offset = 0.35,
	Max = 1.25,
	Additive = Vector(0.04, 0.04)
}

SWEP.Kick = {
	Move = {
		UpBase = 1.5,
		LateralBase = 0.45,
		UpModifier = 0.225,
		LateralModifier = 0.05,
		UpMax = 6.5,
		LateralMax = 2.5,
		DirectionChange = 7
	},
	Air = {
		UpBase = 2,
		LateralBase = 1,
		UpModifier = 0.5,
		LateralModifier = 0.35,
		UpMax = 9,
		LateralMax = 6,
		DirectionChange = 5
	},
	Crouch = {
		UpBase = 0.9,
		LateralBase = 0.35,
		UpModifier = 0.15,
		LateralModifier = 0.025,
		UpMax = 5.5,
		LateralMax = 1.5,
		DirectionChange = 9
	},
	Base = {
		UpBase = 1,
		LateralBase = 0.375,
		UpModifier = 0.175,
		LateralModifier = 0.0375,
		UpMax = 5.75,
		LateralMax = 1.75,
		DirectionChange = 8
	}
}

if (CLIENT) then
	SWEP.KillIcon = 'b'
	SWEP.SelectionIcon = 'b'
	
	SWEP.CSSCrosshair = {
		Delta = 4
	}
	
	SWEP.MuzzleFlashScale = 1.6
end
