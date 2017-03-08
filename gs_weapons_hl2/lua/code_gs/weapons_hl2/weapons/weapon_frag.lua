SWEP.Base = "basehlcombatweapon"

SWEP.Spawnable = true
SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.CModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl" -- "models/items/grenadeAmmo.mdl" doesn't attach to the player correctly
SWEP.HoldType = "grenade"
SWEP.Weight = 1

SWEP.Primary.Ammo = "grenade"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

if (CLIENT) then
	SWEP.SelectionIcon = 'k'
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (not bSecondary) then
		self:Throw(code_gs.weapons.GRENADE_THROW, iIndex)
	end
end

function SWEP:GetAmmoType(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and self:GetPrimaryAmmoType() or -1
end

function SWEP:GetGrenadeAmmoType(iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and self:GetPrimaryAmmoType() or -1
end

function SWEP:GetDefaultClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and self:GetDefaultClip1() or -1
end

function SWEP:GetMaxClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and self:GetMaxClip1() or -1
end

function SWEP:GetClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and self:Clip1() or -1
end
