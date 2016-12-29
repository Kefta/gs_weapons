SWEP.Base = "weapon_csbase_rifle"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.SilencerModel = "models/weapons/w_rif_m4a1_silencer.mdl"

SWEP.Sounds = {
	shoot = "Weapon_M4A1.Single",
	--silence = "Weapon_M4A1.Silencer_On",
	s_shoot = "Weapon_M4A1.Silenced",
	--s_silence = "Weapon_M4A1.Silencer_Off"
}

SWEP.Primary.Ammo = "556mm"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Damage = 33
SWEP.Primary.Cooldown = 0.09
SWEP.Primary.WalkSpeed = 230/250
SWEP.Primary.RangeModifier = 0.97
SWEP.Primary.Spread = Vector(0.02, 0.02)
SWEP.Primary.SpreadAir = Vector(0.4, 0.4)
SWEP.Primary.SpreadMove = Vector(0.07, 0.07)

SWEP.Secondary.Spread = Vector(0.025, 0.025)

SWEP.Accuracy = {
	Divisor = 220,
	Offset = 0.3,
	Max = 1,
	Additive = Vector(0.035, 0.035)
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

if (CLIENT) then
	SWEP.KillIcon = 'w'
	SWEP.SelectionIcon = 'w'
	
	SWEP.MuzzleFlashScale = 1.6
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack()) then
		self:Silence(0)
		
		return true
	end
	
	return false
end
