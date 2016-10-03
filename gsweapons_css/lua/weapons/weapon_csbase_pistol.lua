DEFINE_BASECLASS( "weapon_csbase_gun" )

--- GSBase
SWEP.PrintName = "CSBase_Pistol"
SWEP.Slot = 1

SWEP.Weight = 5

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Pistol"
}

SWEP.Primary = {
	Automatic = false,
	Range = 4096,
	Spread = {
		Air = 0,
		Move = 0,
		Crouch = 0
	}
}

SWEP.Secondary = {
	Spread = {
		Air = -1,
		Move = -1,
		Crouch = -1
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	
	SWEP.CSSCrosshair = {
		Min = 8
	}
end

--- CSBase_Pistol
SWEP.Accuracy = {
	Base = 0,
	Decay = 0,
	Time = 0,
	Min = 0,
	Speed = 5/250
}

SWEP.PunchIntensity = 2

--- GSBase
function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.m_flAccuracy = self.Accuracy.Base
	self.m_flLastFire = CurTime()
end

function SWEP:SharedDeploy( bDelayed )
	BaseClass.SharedDeploy( self, bDelayed )
	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:FinishReload()	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:Shoot( bSecondary, iClipDeduction )
	BaseClass.Shoot( self, bSecondary, iClipDeduction )
	
	// Mark the time of this shot and determine the accuracy modifier based on the last shot fired...
	local flCurTime = CurTime()
	local flAccuracy = self.m_flAccuracy - self.Accuracy.Decay * (self.Accuracy.Time - (flCurTime - self.m_flLastFire))
	self.m_flLastFire = flCurTime
	
	if ( flAccuracy > self.Accuracy.Base ) then
		self.m_flAccuracy = self.Accuracy.Base
	elseif ( flAccuracy < self.Accuracy.Min ) then
		self.m_flAccuracy = self.Accuracy.Min
	else
		self.m_flAccuracy = flAccuracy
	end
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	aPunch.x = aPunch.x - self.PunchIntensity
	pPlayer:SetViewPunchAngles( aPunch )
end

--- CSBase_Gun
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	local pPlayer = self:GetOwner()
	
	if ( not pPlayer:OnGround() ) then
		if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
			local flSpecial = self.Secondary.Spread.Air
			
			if ( flSpecial ~= -1 ) then
				return flSpecial * (1 - self.m_flAccuracy)
			end
		end
		
		return self.Primary.Spread.Air * (1 - self.m_flAccuracy)
	end
	
	if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2 ) then
		if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
			local flSpecial = self.Secondary.Spread.Move
			
			if ( flSpecial ~= -1 ) then
				return flSpecial * (1 - self.m_flAccuracy)
			end
		end
		
		return self.Primary.Spread.Move * (1 - self.m_flAccuracy)
	end
	
	if ( pPlayer:Crouching() ) then
		if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
			local flSpecial = self.Secondary.Spread.Crouch
			
			if ( flSpecial ~= -1 ) then
				return flSpecial * (1 - self.m_flAccuracy)
			end
		end
		
		return self.Primary.Spread.Crouch * (1 - self.m_flAccuracy)
	end
	
	return BaseClass.GetSpread( self, bSecondary ) * (1 - self.m_flAccuracy)
end
