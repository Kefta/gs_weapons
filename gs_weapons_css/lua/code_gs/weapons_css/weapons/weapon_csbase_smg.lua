SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_SMG"
SWEP.Slot = 2

SWEP.HoldType = "smg"
SWEP.Weight = 25

SWEP.Primary.Range = 4096
SWEP.Primary.SpreadAir = vector_origin -- Spread in the air
SWEP.Primary.SpreadMove = vector_origin -- Spread while moving

SWEP.Secondary.SpreadAir = SWEP.Primary.SpreadAir
SWEP.Secondary.SpreadMove = SWEP.Primary.SpreadMove

SWEP.Accuracy = {
	Base = 0.2, -- Initial inaccuracy
	Divisor = 0, -- Accuracy function divisor. Setting to 0 will disable all accuracy modifications
	Offset = 0, -- Additive to divided accuracy value
	Max = 0, -- Worst inaccuracy
	Quadratic = false, -- Shots fired takes a quadratic influence on the accuracy instead of cubic
	Speed = 170/250 -- Speed for SpreadMove to take effect
}

-- Weapon punch values
SWEP.Kick = {
	Air = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Move = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Crouch = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Base = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Speed = 5/250
}

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
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	local tAccuracy = self.Accuracy
	
	// These modifications feed back into flSpread eventually.
	if (tAccuracy.Divisor ~= 0) then
		local flAccuracy = self:GetShotsFired(iIndex) ^ (tAccuracy.Quadratic and 2 or 3) / tAccuracy.Divisor + tAccuracy.Offset
		self:SetAccuracy(flAccuracy > tAccuracy.Max and tAccuracy.Max or flAccuracy, iIndex)
	end
end

// GOOSEMAN : Kick the view..
function SWEP:Punch(bSecondary --[[= false]], iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
	local tKick = self.Kick
	
	// Kick the gun based on the state of the player.
	-- Ground first, speed second
	if (not pPlayer:OnGround()) then
		tKick = tKick.Air
	elseif (pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tKick.Speed) ^ 2) then
		tKick = tKick.Move
	elseif (pPlayer:Crouching()) then
		tKick = tKick.Crouch
	else
		tKick = tKick.Base
	end
	
	local iShotsFired = self:GetShotsFired(iIndex)
	local aPunch = pPlayer:GetViewPunchAngles()
	
	aPunch[1] = aPunch[1] - (tKick.UpBase + iShotsFired * tKick.UpModifier)
	local flUpMin = -tKick.UpMax
	
	if (aPunch[1] < flUpMin) then
		aPunch[1] = flUpMin
	end
	
	local bDirection = code_gs.weapons.GetNWVar(pPlayer, "Bool", "PunchDirection")
	
	if (bDirection) then
		aPunch[2] = aPunch[2] + (tKick.LateralBase + iShotsFired * tKick.LateralModifier)
		local flLateralMax = tKick.LateralMax
		
		if (aPunch[2] > flLateralMax) then
			aPunch[2] = flLateralMax
		end
	else
		aPunch[2] = aPunch[2] - (tKick.LateralBase + iShotsFired * tKick.LateralModifier)
		local flLateralMin = -tKick.LateralMax
		
		if (aPunch[2] < flLateralMin) then
			aPunch[2] = flLateralMin
		end
	end
	
	if (code_gs.random:SharedRandomInt(pPlayer, "KickBack", 0, tKick.DirectionChange) == 0) then
		code_gs.weapons.SetNWVar(pPlayer, "Bool", "PunchDirection", not bDirection)
	end
	
	pPlayer:SetViewPunchAngles(aPunch)
end

function SWEP:FinishReload(iIndex --[[= 0]])
	self:SetAccuracy(self.Accuracy.Base, iIndex)
end

function SWEP:GetSpecialKey(sKey, bSecondary --[[= false]], iIndex --[[= 0]])
	if (sKey == "Spread") then
		local pPlayer = self:GetOwner()
		
		-- We're jumping; takes accuracy priority
		if (not pPlayer:OnGround()) then
			sKey = "SpreadAir"
		elseif (pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2) then
			sKey = "SpreadMove"
		end
		
		return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex) * self:GetAccuracy(iIndex)
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex)
end
