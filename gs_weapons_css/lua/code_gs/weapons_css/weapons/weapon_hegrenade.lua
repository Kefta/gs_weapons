SWEP.Base = "weapon_basecsgrenade"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Primary.Ammo = "HEGrenade"

if (CLIENT) then
	SWEP.SelectionIcon = 'h'
	
	SWEP.CSSCrosshair = {
		Min = 8
	}
else
	SWEP.Grenade = {
		Class = "hegrenade_projectile",
		Radius = 350
	}
end
