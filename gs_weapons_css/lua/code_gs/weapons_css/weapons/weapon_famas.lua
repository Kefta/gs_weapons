SWEP.Base = "weapon_csbase_rifle"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_famas.mdl"
SWEP.CModel = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.Weight = 75

SWEP.Sounds = {
	shoot = "Weapon_FAMAS.Single"
}

SWEP.Primary.Ammo = "556mm"
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 115

SWEP.Primary.Cooldown = function(self, iIndex)
	return 0.09 * (self:GetBurst(iIndex) and 35/9 or 1)
end

SWEP.Primary.Damage = 30
SWEP.Primary.RangeModifier = 0.96
SWEP.Primary.Spread = Vector(0.02, 0.02)
SWEP.Primary.SpreadAir = Vector(0.3, 0.3)
SWEP.Primary.SpreadMove = Vector(0.07, 0.07)
SWEP.Primary.SpreadAdditive = Vector(0.03, 0.03)

-- Extra spread if burst is disabled
local vSpreadExtraAdditive = Vector(0.01, 0.01)
SWEP.Primary.SpreadExtraAdditive = function(self, iIndex)
	return self:GetBurst(iIndex) and vector_origin or vSpreadExtraAdditive
end

SWEP.Primary.FireUnderwater = false

SWEP.Secondary.SpreadAdditive = SWEP.Primary.SpreadAdditive

SWEP.Burst = {
	Times = {
		0.05,
		0.1
	}
}

SWEP.WalkSpeed = 220/250

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
	
	SWEP.ViewModelFlip = false
	SWEP.MuzzleFlashScale = 1.3
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:ToggleBurst(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:GetSpecialKey(sKey, bSecondary --[[= false]], iIndex --[[= 0]])
	if (sKey == "Spread") then
		return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex) + BaseClass.GetSpecialKey(self, "SpreadExtraAdditive", bSecondary, iIndex)
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex)
end
