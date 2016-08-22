DEFINE_BASECLASS( "weapon_csbase_autosniper" )

--- GSBase
SWEP.PrintName = "#CStrike_SG550"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"

SWEP.Sounds = {
	primary = "Weapon_SG550.Single"
}

SWEP.Primary = {
	Ammo = "556mmRound",
	ClipSize = 30,
	DefaultClip = 120,
	Damage = 70,
	Spread = {
		Base = 0.05,
		Crouch = 0.04
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'o'
	SWEP.SelectionIcon = 'o'
	
	SWEP.CSSCrosshair = {
		Min = 5
	}
	
	SWEP.MuzzleFlashScale = 1.6
end

--- CSBase_Gun
SWEP.Penetration = 2

--- CSBase_AutoSniper
SWEP.Accuracy = {
	Additive = 0.65,
	Time = 0.35
}

SWEP.Alias = "SG550"

SWEP.Random = {
	XMin = 0.75,
	XMax = 1.25
}
