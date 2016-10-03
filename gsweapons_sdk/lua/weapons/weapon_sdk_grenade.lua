DEFINE_BASECLASS( "weapon_basesdkgrenade" )

--- GSBase
SWEP.PrintName = "#SDK_Grenade"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Primary.Ammo = "Grenade_SDK"
SWEP.Weight = 1

if ( SERVER ) then
	SWEP.Grenade = {
		Class = "grenade_sdk_projectile",
		Radius = 350
	}
else
	SWEP.Category = "Source"
	SWEP.SelectionIcon = 'h'
end
