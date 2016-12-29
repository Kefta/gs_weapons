SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Activities = {
	shoot_empty = ACT_INVALID -- Animation is broken
}

SWEP.Sounds = {
	shoot = "Weapon_FiveSeven.Single"
}

SWEP.Primary.Ammo = "57mm"
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Damage = 25
SWEP.Primary.RangeModifier = 0.885
SWEP.Primary.Spread = Vector(0.15, 0.15)
SWEP.Primary.SpreadAir = Vector(1.5, 1.5)
SWEP.Primary.SpreadMove = Vector(0.255, 0.255)
SWEP.Primary.SpreadCrouch = Vector(0.075, 0.075)

SWEP.Accuracy = {
	Base = 0.92,
	Decay = 0.25,
	Time = 0.275,
	Min = 0.725
}

if (CLIENT) then
	SWEP.KillIcon = 'u'
	SWEP.SelectionIcon = 'u'
end
