DEFINE_BASECLASS( "hl2_basehlcombatweapon" )

SWEP.PrintName = "#HL2SP_Grenade"
SWEP.Spawnable = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/items/grenadeammo.mdl"
SWEP.HoldType = "grenade"

SWEP.Primary = {
	Ammo = "grenade",
	DefaultClip = 1,
	Automatic = false
}

SWEP.Weight = 1

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 SP"
	SWEP.SelectionIcon = 'k'
end

function SWEP:PrimaryAttack()
	if ( not self:CanPrimaryAttack() ) then
		return false
	end
	
	self:Throw()
	
	return true
end
