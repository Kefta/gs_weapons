DEFINE_BASECLASS( "weapon_csbase_pistol" )

--- GSBase
SWEP.PrintName = "#CStrike_DEagle"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
SWEP.Weight = 7

SWEP.Activities = {
	dryfire = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	primary = "Weapon_DEagle.Single"
}

SWEP.Primary = {
	Ammo = "50AE",
	ClipSize = 7,
	DefaultClip = 42,
	Damage = 54,
	Cooldown = 0.225,
	RangeModifier = 0.81,
	Spread = {
		Base = 0.13,
		Air = 1.5,
		Move = 0.25,
		Crouch = 0.115
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'f'
	SWEP.SelectionIcon = 'f'
	
	SWEP.MuzzleFlashScale = 1.2
end

--- CSBase_Gun
SWEP.Penetration = 2

--- CSBase_Pistol
SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.35,
	Time = 0.4,
	Min = 0.55
}
