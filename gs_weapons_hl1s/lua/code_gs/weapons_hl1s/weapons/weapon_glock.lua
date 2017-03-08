-- FIXME: Spread isn't working correctly
SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_9mmhandgun.mdl"
SWEP.WorldModel = "models/w_9mmhandgun.mdl"
SWEP.Weight = 10

SWEP.Sounds = {
	-- The CS:S glock scape has higher priority, so we need to redefine HL1's
	shoot = {
		level = SNDLEVEL_GUNFIRE,
		pitch = {95, 105},
		sound = "weapons/pl_gun3.wav"
	}
}

SWEP.Activities = {
	reload_empty = ACT_GLOCK_SHOOT_RELOAD,
	shoot_empty = ACT_GLOCK_SHOOTEMPTY
	--[[shoot2 = {
		ACT_VM_PRIMARYATTACK,
		idle = {10, 15} -- FIXME: Is this right?
	},]]
}

SWEP.Primary.Ammo = "9mmRound"
SWEP.Primary.ClipSize = 17
SWEP.Primary.DefaultClip = 34
SWEP.Primary.Cooldown = 0.3
SWEP.Primary.Spread = Vector(0.01, 0.01)
SWEP.Primary.PunchAngle = Angle(-2, 0, 0)

SWEP.Secondary.Cooldown = 0.2
SWEP.Secondary.Spread = Vector(0.1, 0.1)
SWEP.Secondary.PunchAngle = SWEP.Primary.PunchAngle

function SWEP:Attack(bSeconadry --[[= false]], iIndex --[[= 0]])
	self:Shoot(bSecondary, iIndex)
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

function SWEP:ViewModelInactive(iIndex --[[= 0]])
	if (iIndex == 0 or iIndex == nil) then
		return not (self:GetOwner():KeyDown(IN_ATTACK) or self:GetOwner():KeyDown(IN_ATTACK2)) -- FIXME: Condense
	end
	
	return true
end
