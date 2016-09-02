DEFINE_BASECLASS( "weapon_csbase_autosniper" )

--- GSBase
SWEP.PrintName = "#CStrike_G3SG1"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.Sounds = {
	primary = "Weapon_G3SG1.Single"
}

SWEP.Primary = {
	Ammo = "762mmRound",
	ClipSize = 20,
	DefaultClip = 110,
	Damage = 80,
	Spread = {
		Base = 0.055,
		Crouch = 0.035
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'i'
	SWEP.SelectionIcon = 'i'
	
	SWEP.CSSCrosshair = {
		Min = 6,
		Delta = 4
	}
	
	SWEP.MuzzleFlashScale = 1.5
end

--- CSBase_Gun
SWEP.Penetration = 3

--- CSBase_AutoSniper
SWEP.Accuracy = {
	Additive = 0.55,
	Time = 0.3
}

SWEP.Alias = "G3SG1"

SWEP.Random = {
	XMin = 0.75,
	XMax = 1.75
}
