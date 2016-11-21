SWEP.Base = "weapon_dod_base_gun"

SWEP.PrintName = "#DOD_C96"
SWEP.Spawnable = true

SWEP.Sounds = {
	shoot = "Weapon_C96.Shoot",
	reload = "Weapon_C96.WorldReload"
}

SWEP.ViewModel = "models/weapons/v_c96.mdl"
SWEP.WorldModel = "models/weapons/w_c96.mdl"

SWEP.Weight = 10

SWEP.Primary = {
	Ammo = "C96",
	ClipSize = 20,
	DefaultClip = 60,
	Automatic = false,
	Damage = 40,
	Cooldown = 0.065,
	Spread = Vector(0.065, 0.065)
}

SWEP.Accuracy = {
	MovePenalty = Vector(0.1, 0.1)
}

--SWEP.Penetration = 1
-- Recoil = 3

if ( CLIENT ) then
	SWEP.Category = "Day of Defeat: Source"
	
	SWEP.ViewModelFOV = 45
	SWEP.ViewModelTransform = {
		Pos = Vector(-0.5, -1, 1.2)
	}
	
	SWEP.MuzzleFlashScale = 0.3
end
	