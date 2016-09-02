DEFINE_BASECLASS( "weapon_csbase_shotgun" )

--- GSBase
SWEP.PrintName = "#CStrike_M3"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.Sounds = {
	primary = "Weapon_M3.Single"
}

SWEP.EmptyCooldown = 0.2

SWEP.Primary = {
	Ammo = "Buckshot_CSS",
	ClipSize = 8,
	DefaultClip = 40,
	Bullets = 9,
	Damage = 26,
	Cooldown = 0.88, -- The C++ file hardcodes this to 0.875, which I'm sure has been fixed since 2007
	WalkSpeed = 220/250,
	Spread = {
		Base = 0.0675
	}
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

--- CSBase_Shotgun
SWEP.Alias = "M3"

SWEP.Random = {
	GroundMin = 4,
	GroundMax = 6,
	AirMin = 8,
	AirMax = 11
}
