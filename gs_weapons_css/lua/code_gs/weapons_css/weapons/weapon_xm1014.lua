SWEP.Base = "weapon_csbase_shotgun"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.CModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.Sounds = {
	shoot = "Weapon_XM1014.Single"
}

SWEP.Primary.Ammo = "Buckshot_CSS"
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 39
SWEP.Primary.Cooldown = 0.25
SWEP.Primary.Damage = 22
SWEP.Primary.EmptyCooldown = 0.25
SWEP.Primary.Bullets = 6
SWEP.Primary.Spread = Vector(0.0725, 0.0725)

SWEP.WalkSpeed = 240/250

SWEP.PunchRand = {
	Name = "XM1014",
	GroundMin = 3,
	GroundMax = 5,
	AirMin = 7,
	AirMax = 10
}

if (CLIENT) then
	SWEP.KillIcon = 'B'
	SWEP.SelectionIcon = 'B'
	
	SWEP.CSSCrosshair = {
		Min = 9,
		Delta = 4
	}
	
	SWEP.MuzzleFlashScale = 1.3
end
