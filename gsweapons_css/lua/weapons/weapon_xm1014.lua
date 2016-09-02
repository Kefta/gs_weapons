DEFINE_BASECLASS( "weapon_csbase_shotgun" )

--- GSBase
SWEP.PrintName = "#CStrike_XM1014"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.Sounds = {
	primary = "Weapon_XM1014.Single"
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
	Spread = {
		Base = 0.0725
	}
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

--- CSBase_Shotgun
SWEP.Alias = "XM1014"

SWEP.Random = {
	GroundMin = 3,
	GroundMax = 5,
	AirMin = 7,
	AirMax = 10
}
