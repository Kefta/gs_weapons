SWEP.Base = "weapon_csbase_pistol"

SWEP.PrintName = "#CStrike_FiveSeven"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Activities = {
	shoot_empty = ACT_INVALID -- Animation is broken
}

SWEP.Sounds = {
	shoot = "Weapon_FiveSeven.Single"
}

SWEP.Primary = {
	Ammo = "57mm",
	ClipSize = 20,
	DefaultClip = 120,
	Damage = 25,
	RangeModifier = 0.885,
	Spread = Vector(0.15, 0.15),
	SpreadAir = Vector(1.5, 1.5),
	SpreadMove = Vector(0.255, 0.255),
	SpreadCrouch = Vector(0.075, 0.075)
}

SWEP.Accuracy = {
	Base = 0.92,
	Decay = 0.25,
	Time = 0.275,
	Min = 0.725
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'u'
	SWEP.SelectionIcon = 'u'
end
