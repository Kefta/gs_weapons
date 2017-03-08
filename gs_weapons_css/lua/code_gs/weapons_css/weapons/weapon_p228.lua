SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.CModel = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Sounds = {
	shoot = "Weapon_P228.Single"
}

SWEP.Activities = {
	shoot_empty = ACT_INVALID -- Broken animation
}

SWEP.Primary.Ammo = "357sig"
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 65
SWEP.Primary.Cooldown = 0.15
SWEP.Primary.Damage = 40
SWEP.Primary.RangeModifier = 0.8
SWEP.Primary.Spread = Vector(0.15, 0.15)
SWEP.Primary.SpreadAir = Vector(1.5, 1.5)
SWEP.Primary.SpreadMove = Vector(0.255, 0.255)
SWEP.Primary.SpreadCrouch = Vector(0.075, 0.075)

SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.3,
	Time = 0.325,
	Min = 0.6
}

if (CLIENT) then
	SWEP.KillIcon = 'y'
	SWEP.SelectionIcon = 'y'
end
