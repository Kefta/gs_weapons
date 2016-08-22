DEFINE_BASECLASS( "weapon_basecsgrenade" )

--- GSBase
SWEP.PrintName = "#CStrike_Flashbang"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Weight = 1

SWEP.Primary.Ammo = "Flashbang"

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'g'
	SWEP.SelectionIcon = 'g'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
end

--- CSBase_Grenade
SWEP.GrenadeClass = "flashbang_projectile"
