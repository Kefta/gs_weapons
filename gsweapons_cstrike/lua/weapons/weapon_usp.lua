DEFINE_BASECLASS( "weapon_csbase_pistol" )

--- GSBase
SWEP.PrintName = "#CStrike_USP"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.SilencerModel = "models/weapons/w_pist_usp_silencer.mdl"

SWEP.Activities = {
	dryfire = ACT_VM_DRYFIRE,
	secondary = ACT_VM_ATTACH_SILENCER,
	s_dryfire = ACT_VM_DRYFIRE_SILENCED
}

SWEP.Sounds = {
	primary = "Weapon_USP.Single",
	secondary = "Weapon_USP.AttachSilencer",
	s_primary = "Weapon_USP.SilencedShot",
	s_secondary = "Weapon_USP.DetachSilencer"
}

SWEP.Primary = {
	Ammo = "45ACP",
	ClipSize = 12,
	DefaultClip = 112,
	Damage = 34,
	RangeModifier = 0.79,
	Spread = {
		Base = 0.1,
		Air = 1.2,
		Move = 0.225,
		Crouch = 0.08
	}
}

SWEP.Secondary = {
	Damage = 30,
	Spread = {
		Base = 0.15,
		Air = 1.3,
		Move = 0.25,
		Crouch = 0.125
	}
}

SWEP.SpecialType = SPECIAL_SILENCE

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'a'
	SWEP.SelectionIcon = 'a'
end

--- CSBase_Pistol
SWEP.Accuracy = {
	Base = 0.92,
	Decay = 0.275,
	Time = 0.3,
	Min = 0.6
}
