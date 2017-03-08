SWEP.Base = "weapon_csbase_autosniper"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_sg550.mdl"
SWEP.CModel = "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"

SWEP.Sounds = {
	shoot = "Weapon_SG550.Single"
}

SWEP.Primary.Ammo = "556mm"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Damage = 70
SWEP.Primary.Spread = Vector(0.05, 0.05)
SWEP.Primary.SpreadCrouch = Vector(0.04, 0.04)

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

if (CLIENT) then
	SWEP.KillIcon = 'o'
	SWEP.SelectionIcon = 'o'
	
	SWEP.CSSCrosshair = {
		Min = 5
	}
	
	SWEP.MuzzleFlashScale = 1.6
end
