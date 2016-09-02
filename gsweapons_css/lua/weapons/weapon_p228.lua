DEFINE_BASECLASS( "weapon_csbase_pistol" )

--- GSBase
SWEP.PrintName = "#CStrike_P228"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Sounds = {
	primary = "Weapon_P228.Single"
}

SWEP.Primary = {
	Ammo = "357SIG",
	ClipSize = 13,
	DefaultClip = 65,
	Damage = 40,
	RangeModifier = 0.8,
	Spread = {
		Base = 0.15,
		Air = 1.5,
		Move = 0.255,
		Crouch = 0.075
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'y'
	SWEP.SelectionIcon = 'y'
end

--- CSBase_Pistol
SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.3,
	Time = 0.325,
	Min = 0.6
}
