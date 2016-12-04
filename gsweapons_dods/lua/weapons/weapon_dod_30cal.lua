SWEP.Base = "weapon_dod_base_bipod"

SWEP.PrintName = "#DOD_30cal"
SWEP.Spawnable = true

SWEP.Sounds = {
	shoot = "Weapon_30cal.Shoot",
	reload = "Weapon_30cal.WorldReload"
}

SWEP.ViewModel = "models/weapons/v_30cal.mdl"
SWEP.WorldModel = "models/weapons/w_30cal.mdl"
SWEP.ReloadModel = "models/weapons/w_30calsr.mdl"

SWEP.Weight = 20

SWEP.Primary = {
	Ammo = "30cal",
	ClipSize = 150,
	DefaultClip = 300,
	Damage = 85,
	Cooldown = 0.1,
	Spread = Vector(0.2, 0.2)
}

SWEP.Secondary.Spread = Vector(0.01, 0.01)

SWEP.Accuracy = {
	MovePenalty = Vector(0.1, 0.1)
}

--SWEP.Penetration = 1
-- Recoil = 20

if ( CLIENT ) then
	SWEP.Category = "Day of Defeat: Source"
	
	SWEP.ViewModelFOV = 45
	SWEP.ViewModelTransform = {
		Pos = Vector(1.5, -0.5, 0)
	}
	
	SWEP.MuzzleFlashScale = 0.3
end
