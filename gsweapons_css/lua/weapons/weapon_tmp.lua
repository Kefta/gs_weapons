SWEP.Base = "weapon_csbase_smg"

SWEP.PrintName = "#CStrike_TMP"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tmp.mdl"

SWEP.Sounds = {
	shoot = "Weapon_TMP.Single"
}

SWEP.Primary = {
	Ammo = "45acp",
	ClipSize = 30,
	DefaultClip = 150,
	Damage = 26,
	Cooldown = 0.07,
	RangeModifier = 0.84,
	Spread = Vector(0.03, 0.03),
	SpreadAir = Vector(0.25, 0.25)
}

SWEP.Primary.SpreadMove = SWEP.Primary.Spread

SWEP.Accuracy = {
	Divisor = 200,
	Offset = 0.55,
	Max = 1.4
}

SWEP.Kick = {
	Air = {
		UpBase = 1.1,
		LateralBase = 0.5,
		UpModifier = 0.35,
		LateralModifier = 0.045,
		UpMax = 4.5,
		LateralMax = 3.5,
		DirectionChange = 6
	},
	Move = {
		UpBase = 0.8,
		LateralBase = 0.4,
		UpModifier = 0.2,
		LateralModifier = 0.03,
		UpMax = 3,
		LateralMax = 2.5,
		DirectionChange = 7
	},
	Crouch = {
		UpBase = 0.7,
		LateralBase = 0.35,
		UpModifier = 0.125,
		LateralModifier = 0.025,
		UpMax = 2.5,
		LateralMax = 2,
		DirectionChange = 10
	},
	Base = {
		UpBase = 0.725,
		LateralBase = 0.375,
		UpModifier = 0.15,
		LateralModifier = 0.025,
		UpMax = 2.75,
		LateralMax = 2.25,
		DirectionChange = 9
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'd'
	SWEP.SelectionIcon = 'd'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
	
	SWEP.MuzzleFlashScale = 0.8
	
	-- No muzzle flash
	SWEP.EventStyle = {
		[5001] = "",
		[5003] = "",
		[5011] = "",
		[5013] = "",
		[5021] = "",
		[5023] = "",
		[5031] = "",
		[5033] = ""
	}
end

function SWEP:DoMuzzleFlash()
end
