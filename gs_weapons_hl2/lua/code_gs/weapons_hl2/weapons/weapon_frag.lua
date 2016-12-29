SWEP.Base = "basehlcombatweapon"

SWEP.Spawnable = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/items/grenadeammo.mdl"
SWEP.HoldType = "grenade"

SWEP.Primary.Ammo = "grenade"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Weight = 1

if (CLIENT) then
	SWEP.SelectionIcon = 'k'
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack(0)) then
		self:Throw(GRENADE_THROW, 0)
		
		return true
	end
	
	return false
end
