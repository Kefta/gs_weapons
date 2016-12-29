SWEP.Base = "weapon_dod_base_bipod"

SWEP.Spawnable = true

SWEP.Sounds = {
	shoot = "Weapon_30cal.Shoot",
	reload = "Weapon_30cal.WorldReload"
}

SWEP.ViewModel = "models/weapons/v_30cal.mdl"
SWEP.WorldModel = "models/weapons/w_30cal.mdl"
SWEP.ReloadModel = "models/weapons/w_30calsr.mdl"

SWEP.Weight = 20

SWEP.Primary.Ammo = "30cal"
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 300
SWEP.Primary.Damage = 85
SWEP.Primary.Cooldown = 0.1
SWEP.Primary.Spread = Vector(0.2, 0.2)

SWEP.Secondary.Spread = Vector(0.01, 0.01)

SWEP.Accuracy = {
	MovePenalty = Vector(0.1, 0.1)
}

--SWEP.Penetration = 1
-- Recoil = 20

if (CLIENT) then
	SWEP.ViewModelFOV = 45
	SWEP.ViewModelTransform = {
		Pos = Vector(1.5, -0.5, 0)
	}
	
	SWEP.MuzzleFlashScale = 0.3
end
