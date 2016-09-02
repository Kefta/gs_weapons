DEFINE_BASECLASS( "weapon_csbase_sniper" )

--- GSBase
SWEP.PrintName = "#CStrike_Scout"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.Sounds = {
	primary = "Weapon_Scout.Single"
}

SWEP.Primary = {
	Ammo = "762mmRound",
	DefaultClip = 100,
	Damage = 75,
	Cooldown = 1.25,
	WalkSpeed = 260/250,
	Spread = {
		Base = 0.007,
		Air = 0.2,
		FastMove = 0.075,
		Move = 0.075,
		Additive = 0.025
	}
}

SWEP.Secondary.WalkSpeed = 220/250

SWEP.Zoom = {
	FOV = {
		[2] = 15
	},
	Times = {
		Fire = 0.05,
		[0] = 0.05,
		[2] = 0.05
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'n'
	SWEP.SelectionIcon = 'n'
	
	SWEP.CSSCrosshair = {
		Min = 5
	}
	
	SWEP.MuzzleFlashScale = 1.1
end

--- CSBase_Sniper
SWEP.Accuracy = {
	FastSpeed = 170/250,
	Speed = 170/250
}
