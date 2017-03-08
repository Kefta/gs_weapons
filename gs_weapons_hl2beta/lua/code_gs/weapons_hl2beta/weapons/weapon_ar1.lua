SWEP.Base = "weapon_hlbase_machinegun"

SWEP.Spawnable = true
SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.ViewModel = "models/code_gs/weapons/hl2beta_2003/v_ar1.mdl"
SWEP.WorldModel = "models/code_gs/weapons/hl2beta_2003/w_ar1.mdl"
SWEP.HoldType = "ar2"

SWEP.Sounds = {
	empty = "Weapon_AR1.Empty",
	reload = "Weapon_AR1.Reload",
	shoot = "Weapon_AR1.Single",
	shoot2 = "Weapon_AR1.Double"
}

SWEP.Primary.Ammo = "MediumRound"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60

local tRateOfFire = {0.1, 0.2, 0.5, 0.7, 1}
SWEP.Primary.Cooldown = function(self, iIndex)
	return tRateOfFire[self:GetPredictedVar("ROF" .. iIndex, 1)]
end

SWEP.Primary.Spread = VECTOR_CONE_10DEGREES

SWEP.Secondary.Cooldown = 0.1
SWEP.Secondary.Automatic = false

local iRateCount = #tRateOfFire
local iRateMod = iRateCount + 1

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:ChangeRateOfFire(true, iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:ChangeRateOfFire(bSecondary --[[= false]], iIndex --[[= 0]])
	self:SetNextAttack(CurTime() + self:GetSpecialKey("Cooldown", bSecondary, iIndex), bSecondary, iIndex)
	
	local sKey = "ROF" .. (iIndex or 0)
	local iNewROF = (self:GetPredictedVar(sKey, 1) % iRateCount) + 1
	self:SetPredictedVar(sKey, iNewROF)
	
	-- Whatever man, don't say I never made a faithful recreation
	Msg("\n")
	
	for i = 1, iRateCount do
		Msg(i == iNewROF and "|" or "-")
	end
	
	Msg("\n")
end
