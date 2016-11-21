SWEP.Base = "weapon_csbase_shotgun"

SWEP.PrintName = "#CStrike_XM1014"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.Sounds = {
	shoot = "Weapon_XM1014.Single"
}

SWEP.EmptyCooldown = 0.25

SWEP.Primary = {
	Ammo = "Buckshot_CSS",
	ClipSize = 7,
	DefaultClip = 39,
	Bullets = 6,
	Damage = 22,
	Cooldown = 0.25,
	WalkSpeed = 240/250,
	Spread = Vector(0.0725, 0.0725)
}

SWEP.PunchRand = {
	Name = "XM1014",
	GroundMin = 3,
	GroundMax = 5,
	AirMin = 7,
	AirMax = 10
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'B'
	SWEP.SelectionIcon = 'B'
	
	SWEP.CSSCrosshair = {
		Min = 9,
		Delta = 4
	}
	
	SWEP.MuzzleFlashScale = 1.3
end
