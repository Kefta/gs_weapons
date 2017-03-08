SWEP.Base = "weapon_csbase_rifle"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_sg552.mdl"
SWEP.CModel = "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"

SWEP.Sounds = {
	shoot = "Weapon_SG552.Single"
}

SWEP.Primary.Ammo = "556mm"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 120

SWEP.Primary.Cooldown = function(self)
	return self:GetZoomLevel() == 0 and 0.09 or 0.135
end

SWEP.Primary.Damage = 33
SWEP.Primary.RangeModifier = 0.955
SWEP.Primary.Spread = Vector(0.02, 0.02)
SWEP.Primary.SpreadAir = Vector(0.45, 0.45)
SWEP.Primary.SpreadMove = Vector(0.075, 0.075)
SWEP.Primary.SpreadAdditive = Vector(0.035, 0.035)

SWEP.WalkSpeed = 235/250

SWEP.Accuracy = {
	Divisor = 220,
	Offset = 0.3,
	Max = 1
}

SWEP.Kick = {
	Move = {
		UpBase = 1,
		LateralBase = 0.45,
		UpModifier = 0.28,
		LateralModifier = 0.04,
		UpMax = 4.25,
		LateralMax = 2.5,
		DirectionChange = 7
	},
	Air = {
		UpBase = 1.25,
		LateralBase = 0.45,
		UpModifier = 0.22,
		LateralModifier = 0.18,
		UpMax = 6,
		LateralMax = 4,
		DirectionChange = 5
	},
	Crouch = {
		UpBase = 0.6,
		LateralBase = 0.35,
		UpModifier = 0.2,
		LateralModifier = 0.0125,
		UpMax = 3.7,
		LateralMax = 2,
		DirectionChange = 10
	},
	Base = {
		UpBase = 0.625,
		LateralBase = 0.375,
		UpModifier = 0.25,
		LateralModifier = 0.0125,
		UpMax = 4,
		LateralMax = 2.25,
		DirectionChange = 9
	}
}

if (CLIENT) then
	SWEP.KillIcon = 'A'
	SWEP.SelectionIcon = 'A'
	
	SWEP.CSSCrosshair = {
		Min = 5
	}
	
	SWEP.MuzzleFlashScale = 1.3
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:AdvanceZoom(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end
