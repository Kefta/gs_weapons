DEFINE_BASECLASS( "weapon_csbase_sniper" )

--- GSBase
SWEP.PrintName = "#CStrike_AWP"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"

SWEP.Sounds = {
	primary = "Weapon_AWP.Single"
}

SWEP.Primary = {
	Ammo = "338",
	DefaultClip = 40,
	Damage = 115,
	Cooldown = 1.5,
	WalkSpeed = 210/250,
	RangeModifier = 0.99,
	Spread = {
		Base = 0.001,
		Air = 0.85,
		FastMove = 0.25,
		Move = 0.1,
		Additive = 0.08
	}
}

SWEP.Secondary.WalkSpeed = 150/250

SWEP.Zoom = {
	FOV = {
		[2] = 10
	},
	Times = {
		Fire = 0.1,
		[0] = 0.1,
		[2] = 0.08
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'r'
	SWEP.SelectionIcon = 'r'
	
	SWEP.CSSCrosshair = {
		Min = 8 
	}
	
	SWEP.MuzzleFlashScale = 1.35
end

--- CSBase_Sniper
SWEP.Accuracy = {
	FastSpeed = 140/250,
	Speed = 10/250
}
