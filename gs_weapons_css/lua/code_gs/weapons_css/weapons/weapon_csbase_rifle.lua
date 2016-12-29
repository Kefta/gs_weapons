SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Rifle"
SWEP.Slot = 2

SWEP.HoldType = "ar2"
SWEP.Weight = 25

SWEP.Primary.Range = 8192
SWEP.Primary.SpreadAir = vector_origin
SWEP.Primary.SpreadMove = vector_origin

SWEP.Secondary.SpreadAir = -1
SWEP.Secondary.SpreadMove = -1

SWEP.Penetration = 2

SWEP.Accuracy = {
	Base = 0.2,
	Divisor = 0, -- 0 = off
	Offset = 0,
	Max = 0,
	Quadratic = false,
	Speed = 140/250,
	Additive = vector_origin
}

SWEP.Kick = {
	Move = {
		UpBase = 0,
		LateralBase = 0,
		UpModifier = 0,
		LateralModifier = 0,
		UpMax = 0,
		LateralMax = 0,
		DirectionChange = 0
	},
	Air = {
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

if (CLIENT) then
	SWEP.EventStyle = {
		-- CS:S muzzle flash
		[5001] = "css_x",
		[5011] = "css_x",
		[5021] = "css_x",
		[5031] = "css_x"
	}
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:SharedDeploy(bDelayed)
	BaseClass.SharedDeploy(self, bDelayed)
	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:FinishReload()
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:Shoot(bSecondary, iIndex, iClipDeduction)
	BaseClass.Shoot(self, bSecondary, iIndex, iClipDeduction)
	local tAccuracy = self.Accuracy
	
	// These modifications feed back into flSpread eventually.
	if (tAccuracy.Divisor ~= 0) then
		local pPlayer = self:GetOwner()
		local flAccuracy = self:GetShotsFired() ^ (tAccuracy.Quadratic and 2 or 3) / tAccuracy.Divisor + tAccuracy.Offset
		
		if (flAccuracy > tAccuracy.Max) then
			self.m_flAccuracy = tAccuracy.Max
		else
			self.m_flAccuracy = flAccuracy
		end
	end
end

// GOOSEMAN : Kick the view..
function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local tKick = self.Kick
	
	// Kick the gun based on the state of the player.
	-- Speed first, ground second
	if (pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tKick.Speed) ^ 2) then
		tKick = tKick.Move
	elseif (not pPlayer:OnGround()) then
		tKick = tKick.Air
	elseif (pPlayer:Crouching()) then
		tKick = tKick.Crouch
	else
		tKick = tKick.Base
	end
	
	local iShotsFired = self:GetShotsFired()
	local aPunch = pPlayer:GetViewPunchAngles()
	
	aPunch[1] = aPunch[1] - (tKick.UpBase + iShotsFired * tKick.UpModifier)
	local flUpMin = -tKick.UpMax
	
	if (aPunch[1] < flUpMin) then
		aPunch[1] = flUpMin
	end
	
	local bDirection = pPlayer.dt.PunchDirection
	
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
		pPlayer.dt.PunchDirection = not bDirection
	end
	
	pPlayer:SetViewPunchAngles(aPunch)
end

function SWEP:GetSpecialKey(sKey, bSecondary, bNoConVar)
	if (sKey == "Spread") then
		local pPlayer = self:GetOwner()
		
		-- We're jumping; takes accuracy priority
		if (not pPlayer:OnGround()) then
			return self.Accuracy.Additive + BaseClass.GetSpecialKey(self, "SpreadAir", bSecondary, bNoConVar) * self.m_flAccuracy
		end
		
		if (pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2) then
			return self.Accuracy.Additive + BaseClass.GetSpecialKey(self, "SpreadMove", bSecondary, bNoConVar) * self.m_flAccuracy
		end
		
		return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar) * self.m_flAccuracy
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar)
end
