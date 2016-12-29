SWEP.Base = "weapon_csbase_rifle"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.Weight = 75

SWEP.Sounds = {
	shoot = "Weapon_FAMAS.Single"
}

SWEP.Primary.Ammo = "556mm"
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 115
SWEP.Primary.Damage = 30
SWEP.Primary.Cooldown = 0.09
SWEP.Primary.WalkSpeed = 220/250
SWEP.Primary.FireUnderwater = false
SWEP.Primary.RangeModifier = 0.96
SWEP.Primary.Spread = Vector(0.02, 0.02)
SWEP.Primary.SpreadAir = Vector(0.3, 0.3)
SWEP.Primary.SpreadMove = Vector(0.07, 0.07)
SWEP.Primary.SpreadAdditive = Vector(0.01, 0.01)

SWEP.Secondary.Cooldown = 0.35
SWEP.Secondary.SpreadAdditive = vector_origin

SWEP.Burst = {
	Times = {
		0.05,
		0.1
	}
}

SWEP.Accuracy = {
	Divisor = 215,
	Offset = 0.3,
	Max = 1,
	Additive = Vector(0.03, 0.03)
}

SWEP.Kick = {
	Move = {
		UpBase = 1,
		LateralBase = 0.45,
		UpModifier = 0.275,
		LateralModifier = 0.05,
		UpMax = 4,
		LateralMax = 2.5,
		DirectionChange = 7
	},
	Air = {
		UpBase = 1.25,
		LateralBase = 0.45,
		UpModifier = 0.22,
		LateralModifier = 0.18,
		UpMax = 5.5,
		LateralMax = 4,
		DirectionChange = 5
	},
	Crouch = {
		UpBase = 0.575,
		LateralBase = 0.325,
		UpModifier = 0.2,
		LateralModifier = 0.011,
		UpMax = 3.25,
		LateralMax = 2,
		DirectionChange = 8
	},
	Base = {
		UpBase = 0.625,
		LateralBase = 0.375,
		UpModifier = 0.25,
		LateralModifier = 0.0125,
		UpMax = 3.5,
		LateralMax = 2.25,
		DirectionChange = 8
	}
}

if (CLIENT) then
	SWEP.KillIcon = 't'
	SWEP.SelectionIcon = 't'
	
	SWEP.MuzzleFlashScale = 1.3
	
	SWEP.ViewModelFlip = false
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack(0)) then
		self:ToggleBurst(0)
		
		return true
	end
	
	return false
end

function SWEP:GetSpecialKey(sKey, bSecondary, bNoConVar)
	if (sKey == "Spread") then
		return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar) + BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, bNoConVar)
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar)
end
