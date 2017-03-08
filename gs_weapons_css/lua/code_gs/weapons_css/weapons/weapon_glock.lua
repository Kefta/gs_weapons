SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl"
SWEP.CModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Sounds = {
	shoot = "Weapon_Glock.Single"
}

SWEP.Activities = {
	shoot = function(self, iIndex)
		return self:EventActive("burst_" .. iIndex) and (self:GetPredictedVar("BurstCount" .. iIndex, 1) == 1
			and ACT_VM_SECONDARYATTACK or ACT_INVALID) or ACT_VM_PRIMARYATTACK
	end
}

SWEP.Primary.Ammo = "9mm"
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 140

SWEP.Primary.Cooldown = function(self, iIndex)
	return self:GetBurst(iIndex) and 0.3 or 0.15
end

SWEP.Primary.Damage = function(self, iIndex)
	return self:GetBurst(iIndex) and 18 or 25
end

SWEP.Primary.RangeModifier = function(self, iIndex)
	return self:GetBurst(iIndex) and 0.9 or 0.75
end

local vSpread = Vector(0.1, 0.1)
local vBurstSpread = vSpread * 3
SWEP.Primary.Spread = function(self, iIndex)
	return self:GetBurst(iIndex) and vBurstSpread or vSpread
end

local vSpreadAir = Vector(1, 1)
local vBurstSpreadAir = vSpreadAir * (6/5)
SWEP.Primary.SpreadAir = function(self, iIndex)
	return self:GetBurst(iIndex) and vBurstSpreadAir or vSpreadAir
end

local vSpreadMove = Vector(0.165, 0.165)
local vBurstSpreadMove = vSpreadMove * (37/33)
SWEP.Primary.SpreadMove = function(self, iIndex)
	return self:GetBurst(iIndex) and vBurstSpreadMove or vSpreadMove
end

local vSpreadCrouch = Vector(0.075, 0.075)
local vBurstSpreadCrouch = vSpreadCrouch * (19/15)
SWEP.Primary.SpreadCrouch = function(self, iIndex)
	return self:GetBurst(iIndex) and vBurstSpreadCrouch or vSpreadCrouch
end

SWEP.Burst = {
	SingleActivity = true
}

SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.275,
	Time = 0.325,
	Min = 0.6
}

if (CLIENT) then
	SWEP.KillIcon = 'c'
	SWEP.SelectionIcon = 'c'
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:ToggleBurst(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end
