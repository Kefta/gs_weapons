SWEP.Base = "weapon_basesdkgrenade"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Weight = 1

SWEP.Primary.Ammo = "Grenade_SDK"

if (CLIENT) then
	SWEP.SelectionIcon = 'h'
else
	SWEP.Grenade = {
		Class = "grenade_sdk_projectile",
		Radius = 350
	}
end
