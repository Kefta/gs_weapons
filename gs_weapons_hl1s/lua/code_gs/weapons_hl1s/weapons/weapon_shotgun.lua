-- FIXME: Different finish animation?
SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 3

SWEP.ViewModel = "models/v_shotgun.mdl"
SWEP.WorldModel = "models/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Weight = 15

SWEP.Sounds = {
	shoot = "Weapon_Shotgun.Single",
	shoot2 = "Weapon_Shotgun.Double", 
	reload = "Weapon_Shotgun.Reload",
	reloadfinish = "Weapon_Shotgun.Special1"
}

SWEP.Activities = {
	idle = function(self, iIndex)
		local flRand = code_gs.random:SharedRandomFloat(self:GetOwner(), self:GetClass() .. "-Activity" .. iIndex .. "-idle", 0, 1)
		
		if (flRand > 0.95) then
			return ACT_SHOTGUN_IDLE_DEEP
		end
		
		if (flRand > 0.8) then
			return ACT_VM_IDLE
		end
		
		return ACT_SHOTGUN_IDLE4
	end,
	reload_finish = ACT_SHOTGUN_PUMP
}

SWEP.Primary.Ammo = "Buckshot_HL"
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Cooldown = 0.75
SWEP.Primary.EmptyCooldown = 0.75
SWEP.Primary.Bullets = game.SinglePlayer() and 6 or 4
SWEP.Primary.PunchAngle = Angle(-5, 0, 0)
SWEP.Primary.Spread = game.SinglePlayer() and VECTOR_CONE_10DEGREES or Vector(0.08716, 0.04362) // 10 degrees by 5 degrees
SWEP.Primary.InterruptReload = true

SWEP.Secondary.Cooldown = 1.5
SWEP.Secondary.EmptyCooldown = 0.75
SWEP.Secondary.Bullets = game.SinglePlayer() and 12 or 8
SWEP.Secondary.Deduction = 2
SWEP.Secondary.PunchAngle = Angle(-10, 0, 0)
SWEP.Secondary.Spread = SWEP.Primary.Spread -- FIXME
SWEP.Secondary.FireUnderwater = false
SWEP.Secondary.InterruptReload = true

SWEP.SingleReload = {
	Enable = true
}

function SWEP:SecondaryAttack()
	local iClip = self:GetClip(true, 0)
	
	if (iClip ~= -1 and iClip < self:GetSpecialKey("Deduction", true, 0)) then
		return self:DoReloadFunction(0)
	end
	
	return self:DoAttack(true, 0)
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
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

function SWEP:SetClip(iAmmo, bSecondary --[[= false]], iIndex --[[= 0]])
	if (iIndex == nil or iIndex == 0) then
		self:SetClip1(iAmmo)
	end
end

function SWEP:ViewModelInactive(iIndex --[[= 0]])
	if (iIndex == 0 or iIndex == nil) then
		return not (self:GetOwner():KeyDown(IN_ATTACK) or self:GetOwner():KeyDown(IN_ATTACK2)) -- FIXME: Condense
	end
	
	return true
end
