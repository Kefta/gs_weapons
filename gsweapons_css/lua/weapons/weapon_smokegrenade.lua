DEFINE_BASECLASS( "weapon_basecsgrenade" )

--- GSBase
SWEP.PrintName = "#CStrike_SmokeGrenade"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Primary = {
	Ammo = "SmokeGrenade",
	WalkSpeed = 245/250
}

if ( SERVER ) then
	SWEP.Grenade = {
		Class = "smokegrenade_projectile"
	}
else
	SWEP.Category = "Counter-Strike: Source"
	SWEP.SelectionIcon = 'p'
end
