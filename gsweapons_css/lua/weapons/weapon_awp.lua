SWEP.Base = "weapon_csbase_sniper"

SWEP.PrintName = "#CStrike_AWP"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"

SWEP.Sounds = {
	shoot = "Weapon_AWP.Single"
}

SWEP.Primary = {
	Ammo = "338mag",
	DefaultClip = 40,
	Damage = 115,
	Cooldown = 1.5,
	WalkSpeed = 210/250,
	RangeModifier = 0.99,
	Spread = Vector(0.001, 0.001),
	SpreadAir = Vector(0.85, 0.85),
	SpreadSprint = Vector(0.25, 0.25),
	SpreadMove = Vector(0.1, 0.1),
	SpreadAdditive = Vector(0.08, 0.08)
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

SWEP.Accuracy = {
	Sprint = 140/250,
	Speed = 10/250
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
