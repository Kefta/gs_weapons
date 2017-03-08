SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_AutoSniper"
SWEP.Slot = 3

SWEP.HoldType = "ar2"
SWEP.Weight = 20

SWEP.Sounds = {
	zoom = "Default.Zoom"
}

SWEP.EventStyle = {
	-- CS:S muzzle flash
	[5001] = "css_x",
	[5011] = "css_x",
	[5021] = "css_x",
	[5031] = "css_x"
}

SWEP.Primary.Cooldown = 0.25
SWEP.Primary.Range = 8192
SWEP.Primary.SpreadAir = Vector(0.45, 0.45) -- Spread in the air
SWEP.Primary.SpreadMove = Vector(0.15, 0.15) -- Spread while moving
SWEP.Primary.SpreadCrouch = vector_origin -- Spread while crouching

local vSpreadAdditive = Vector(0.025, 0.025) -- Spread amount to add
SWEP.Primary.SpreadAdditive = function(self)
	return self:GetZoomLevel() == 0 and vSpreadAdditive or vector_origin
end

SWEP.Secondary.Cooldown = SWEP.Primary.Cooldown
SWEP.Secondary.Range = SWEP.Primary.Range
SWEP.Secondary.SpreadAir = SWEP.Primary.SpreadAir
SWEP.Secondary.SpreadMove = SWEP.Primary.SpreadMove
SWEP.Secondary.SpreadCrouch = SWEP.Primary.SpreadCrouch
SWEP.Secondary.SpreadAdditive = SWEP.Primary.SpreadAdditive

SWEP.Zoom = {
	FOV = { -- FOVs for each zoom level
		40,
		15
	},
	Levels = 2,
	Times = {
		[0] = 0.1,
		0.3,
		0.05
	}
}

SWEP.Accuracy = {
	Base = 0.98, -- Initial accuracy
	Additive = 0, -- Inaccuracy to add
	Time = 0, -- Time to fully restore accuracy
	Speed = 5/250 -- Speed for SpreadMove to take affect
}

SWEP.PunchRand = {
	Name = "AutoSniper", -- CRC string
	XMin = 0, -- Min random pitch
	XMax = 0, -- Max random pitch
	YMin = -0.75, -- Min random yaw
	YMax = 0.75 -- Max random yaw
}

if (CLIENT) then
	SWEP.Zoom.HideViewModel = true
	SWEP.Zoom.DrawOverlay = true
end

-- Can't make the default the accuracy base since its different per weapon
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

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:AdvanceZoom(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	// Mark the time of this shot and determine the accuracy modifier based on the last shot fired...
	local flAccuracy = self.Accuracy.Additive + self.Accuracy.Time * (CurTime() - self:GetLastAttackTime(iIndex))
	
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	self:SetAccuracy(flAccuracy > self.Accuracy.Base and self.Accuracy.Base or flAccuracy, iIndex)
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	local tRandom = self.PunchRand
	local flPitch = aPunch[1]
	
	// Adjust the punch angle.
	aPunch[1] = flPitch - (code_gs.random:SharedRandomFloat(pPlayer, tRandom.Name .. "PunchAngleX", tRandom.XMin, tRandom.XMax) + flPitch / 4)
	aPunch[2] = aPunch[2] + code_gs.random:SharedRandomFloat(pPlayer, tRandom.Name .. "PunchAngleY", tRandom.YMin, tRandom.YMax)
	pPlayer:SetViewPunchAngles(aPunch)
end

function SWEP:FinishReload(iIndex --[[= 0]])
	self:SetAccuracy(self.Accuracy.Base, iIndex)
end

function SWEP:GetWalkSpeed()
	return self.WalkSpeed * (self:GetZoomLevel() == 0 and 1 or 5/7)
end

function SWEP:GetSpecialKey(sKey, bSecondary --[[= false]], iIndex --[[= 0]])
	if (sKey == "Spread") then
		local pPlayer = self:GetOwner()
		local bAccuracy = true
		
		if (not pPlayer:OnGround()) then
			sKey = "SpreadAir"
		elseif (pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2) then
			sKey = "SpreadMove"
			bAccuracy = false
		elseif (pPlayer:Crouching()) then
			sKey = "SpreadCrouch"
		end
		
		local vSpread = BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex) * (bAccuracy and (1 - self:GetAccuracy(iIndex)) or 1)		
		vSpread:Add(BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, iIndex))
		
		return vSpread
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex)
end
