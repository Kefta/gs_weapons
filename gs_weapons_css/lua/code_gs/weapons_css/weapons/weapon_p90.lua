SWEP.Base = "weapon_csbase_smg"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"
SWEP.Weight = 26

SWEP.Sounds = {
	shoot = "Weapon_P90.Single"
}

SWEP.Primary.Ammo = "57mm"
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Cooldown = 0.07
SWEP.Primary.Damage = 26
SWEP.Primary.WalkSpeed = 245/250
SWEP.Primary.RangeModifier = 0.84
SWEP.Primary.Spread = Vector(0.045, 0.045)
SWEP.Primary.SpreadAir = Vector(0.3, 0.3)
SWEP.Primary.SpreadMove = Vector(0.115, 0.115)

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

if (CLIENT) then
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
