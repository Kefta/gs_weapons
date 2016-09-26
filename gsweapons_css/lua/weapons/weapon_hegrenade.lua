DEFINE_BASECLASS( "weapon_basecsgrenade" )

--- GSBase
SWEP.PrintName = "#CStrike_HEGrenade"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Primary.Ammo = "HEGrenade"

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'h'
	SWEP.SelectionIcon = 'h'
	
	SWEP.CSSCrosshair = {
		Min = 8
	}
end

--- CSBase_Grenade
SWEP.Entity = "hegrenade_projectile"
