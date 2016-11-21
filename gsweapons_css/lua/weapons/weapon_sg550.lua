SWEP.Base = "weapon_csbase_autosniper"

SWEP.PrintName = "#CStrike_SG550"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"

SWEP.Sounds = {
	shoot = "Weapon_SG550.Single"
}

SWEP.Primary = {
	Ammo = "556mm",
	ClipSize = 30,
	DefaultClip = 120,
	Damage = 70,
	Spread = Vector(0.05, 0.05),
	SpreadCrouch = Vector(0.04, 0.04)
}

SWEP.Penetration = 2

SWEP.Accuracy = {
	Additive = 0.65,
	Time = 0.35
}

SWEP.PunchRand = {
	Name = "SG550",
	XMin = 0.75,
	XMax = 1.25
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'o'
	SWEP.SelectionIcon = 'o'
	
	SWEP.CSSCrosshair = {
		Min = 5
	}
	
	SWEP.MuzzleFlashScale = 1.6
end
