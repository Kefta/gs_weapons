SWEP.Base = "weapon_csbase_sniper"

SWEP.PrintName = "#CStrike_Scout"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.Sounds = {
	shoot = "Weapon_Scout.Single"
}

SWEP.Primary = {
	Ammo = "762mm",
	DefaultClip = 100,
	Damage = 75,
	Cooldown = 1.25,
	WalkSpeed = 260/250,
	Spread = Vector(0.007, 0.007),
	SpreadAir = Vector(0.2, 0.2),
	SpreadSprint = Vector(0.075, 0.075),
	SpreadMove = Vector(0.075, 0.075),
	SpreadAdditive = Vector(0.025, 0.025)
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

SWEP.Accuracy = {
	Sprint = 170/250,
	Speed = 170/250
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
