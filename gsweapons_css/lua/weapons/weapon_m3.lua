SWEP.Base = "weapon_csbase_shotgun"

SWEP.PrintName = "#CStrike_M3"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.Sounds = {
	shoot = "Weapon_M3.Single"
}

SWEP.EmptyCooldown = 0.2

SWEP.Primary = {
	Ammo = "Buckshot_CSS",
	ClipSize = 8,
	DefaultClip = 40,
	Bullets = 9,
	Damage = 26,
	Cooldown = 0.875, -- The C++ file hardcodes this to 0.875 regardless of script value
	WalkSpeed = 220/250,
	Spread = Vector(0.0675, 0.0675)
}

SWEP.PunchRand = {
	Name = "M3",
	GroundMin = 4,
	GroundMax = 6,
	AirMin = 8,
	AirMax = 11
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'k'
	SWEP.SelectionIcon = 'k'
	
	SWEP.CSSCrosshair = {
		Min = 8,
		Delta = 6
	}
	
	SWEP.MuzzleFlashScale = 1.3
end
