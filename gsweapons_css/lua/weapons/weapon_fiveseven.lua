DEFINE_BASECLASS( "weapon_csbase_pistol" )

--- GSBase
SWEP.PrintName = "#CStrike_FiveSeven"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Activities = {
	dryfire = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	primary = "Weapon_FiveSeven.Single"
}

SWEP.Primary = {
	Ammo = "57mmRound",
	ClipSize = 20,
	DefaultClip = 120,
	Damage = 25,
	RangeModifier = 0.885,
	Spread = {
		Base = 0.15,
		Air = 1.5,
		Move = 0.255,
		Crouch = 0.075
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'u'
	SWEP.SelectionIcon = 'u'
end

--- CSBase_Pistol
SWEP.Accuracy = {
	Base = 0.92,
	Decay = 0.25,
	Time = 0.275,
	Min = 0.725
}
