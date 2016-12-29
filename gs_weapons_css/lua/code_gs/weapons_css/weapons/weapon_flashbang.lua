SWEP.Base = "weapon_basecsgrenade"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"
SWEP.Weight = 1

SWEP.Primary.Ammo = "Flashbang"

if (CLIENT) then
	SWEP.SelectionIcon = 'g'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
else
	SWEP.Grenade = {
		Class = "flashbang_projectile",
		Damage = 4,
		Radius = 1500
	}
end
