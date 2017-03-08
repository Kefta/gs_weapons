SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Pistol"
SWEP.Slot = 1

SWEP.HoldType = "revolver"
SWEP.Weight = 5

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Pistol"
}

SWEP.Primary.Range = 4096
SWEP.Primary.SpreadAir = vector_origin -- Spread in the air
SWEP.Primary.SpreadMove = vector_origin -- Spread while moving
SWEP.Primary.SpreadCrouch = vector_origin -- Spread while crouching
SWEP.Primary.Automatic = false

SWEP.Secondary.SpreadAir = SWEP.Primary.SpreadAir
SWEP.Secondary.SpreadMove = SWEP.Primary.SpreadMove
SWEP.Secondary.SpreadCrouch = SWEP.Primary.SpreadCrouch

SWEP.Accuracy = {
	Base = 0, -- Initial accuracy
	Decay = 0, -- Decay of accuracy over time
	Time = 0, -- Time to fully restore accuracy
	Min = 0, -- Worst accuracy
	Speed = 5/250 -- Speed for SpreadMove to take affect
}

SWEP.PunchIntensity = -2 -- Magnitude of pitch in punch

if (CLIENT) then
	SWEP.CSSCrosshair = {
		Min = 8
	}
end

code_gs.weapons.PredictedAccessorFunc(SWEP, false, "Float", "Accuracy", 0, true)

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	for i = 0, self.ViewModelCount - 1 do
		self:SetAccuracy(self.Accuracy.Base, iIndex)
	end
end

function SWEP:SharedHolster()
	for i = 0, self.ViewModelCount - 1 do
		self:SetAccuracy(self.Accuracy.Base, iIndex)
	end
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	// Mark the time of this shot and determine the accuracy modifier based on the last shot fired...
	local flAccuracy = self:GetAccuracy(iIndex) - self.Accuracy.Decay * (self.Accuracy.Time - (CurTime() - self:GetLastAttackTime(iIndex)))
	
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	self:SetAccuracy(flAccuracy > self.Accuracy.Base and self.Accuracy.Base or flAccuracy < self.Accuracy.Min and self.Accuracy.Min or flAccuracy, iIndex)
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	
	aPunch[1] = aPunch[1] + self.PunchIntensity
	pPlayer:SetViewPunchAngles(aPunch)
end

function SWEP:FinishReload(iIndex --[[= 0]])
	self:SetAccuracy(self.Accuracy.Base, iIndex)
end

function SWEP:GetSpecialKey(sKey, bSecondary --[[= false]], iIndex --[[= 0]])
	if (sKey == "Spread") then
		local pPlayer = self:GetOwner()
		
		if (not pPlayer:OnGround()) then
			sKey = "SpreadAir"
		elseif (pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2) then
			sKey = "SpreadMove"
		elseif (pPlayer:Crouching()) then
			sKey = "SpreadCrouch"
		end
		
		return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex) * (1 - self:GetAccuracy(iIndex))
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex)
end
