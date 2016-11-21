SWEP.Base = "weapon_csbase_pistol"

SWEP.PrintName = "#CStrike_P228"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Sounds = {
	shoot = "Weapon_P228.Single"
}

SWEP.Activities = {
	shoot_empty = ACT_INVALID -- Broken animation
}

SWEP.Primary = {
	Ammo = "357sig",
	ClipSize = 13,
	DefaultClip = 65,
	Damage = 40,
	RangeModifier = 0.8,
	Spread = Vector(0.15, 0.15),
	SpreadAir = Vector(1.5, 1.5),
	SpreadMove = Vector(0.255, 0.255),
	SpreadCrouch = Vector(0.075, 0.075)
}

SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.3,
	Time = 0.325,
	Min = 0.6
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'y'
	SWEP.SelectionIcon = 'y'
end
