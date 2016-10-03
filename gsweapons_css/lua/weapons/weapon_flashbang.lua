DEFINE_BASECLASS( "weapon_basecsgrenade" )

--- GSBase
SWEP.PrintName = "#CStrike_Flashbang"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"
SWEP.Weight = 1

SWEP.Primary.Ammo = "Flashbang"

if ( SERVER ) then
	SWEP.Grenade = {
		Class = "flashbang_projectile",
		Damage = 4,
		Radius = 1500
	}
else
	SWEP.Category = "Counter-Strike: Source"
	SWEP.SelectionIcon = 'g'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
end
