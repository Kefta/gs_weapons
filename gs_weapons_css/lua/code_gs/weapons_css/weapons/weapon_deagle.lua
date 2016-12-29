SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.Weight = 7

SWEP.Sounds = {
	shoot = "Weapon_DEagle.Single"
}

SWEP.Primary.Ammo = "50AE"
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 42
SWEP.Primary.Damage = 54
SWEP.Primary.Cooldown = 0.225
SWEP.Primary.RangeModifier = 0.81
SWEP.Primary.Spread = Vector(0.13, 0.13)
SWEP.Primary.SpreadAir = Vector(1.5, 1.5)
SWEP.Primary.SpreadMove = Vector(0.25, 0.25)
SWEP.Primary.SpreadCrouch = Vector(0.115, 0.115)

SWEP.Penetration = 2

SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.35,
	Time = 0.4,
	Min = 0.55
}

if (CLIENT) then
	SWEP.KillIcon = 'f'
	SWEP.SelectionIcon = 'f'
	
	SWEP.MuzzleFlashScale = 1.2
end
