SWEP.Base = "weapon_basecsgrenade"

SWEP.PrintName = "#CStrike_SmokeGrenade"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Primary = {
	Ammo = "SmokeGrenade",
	WalkSpeed = 245/250
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.SelectionIcon = 'p'
else
	SWEP.Grenade = {
		Class = "smokegrenade_projectile"
	}
end
