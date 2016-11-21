SWEP.Base = "weapon_csbase_pistol"

SWEP.PrintName = "#CStrike_DEagle"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.Weight = 7

SWEP.Sounds = {
	shoot = "Weapon_DEagle.Single"
}

SWEP.Primary = {
	Ammo = "50AE",
	ClipSize = 7,
	DefaultClip = 42,
	Damage = 54,
	Cooldown = 0.225,
	RangeModifier = 0.81,
	Spread = Vector(0.13, 0.13),
	SpreadAir = Vector(1.5, 1.5),
	SpreadMove = Vector(0.25, 0.25),
	SpreadCrouch = Vector(0.115, 0.115)
}

SWEP.Penetration = 2

SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.35,
	Time = 0.4,
	Min = 0.55
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'f'
	SWEP.SelectionIcon = 'f'
	
	SWEP.MuzzleFlashScale = 1.2
end
