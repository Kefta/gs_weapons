SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Pistol"
SWEP.Slot = 1

SWEP.Weight = 5

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Pistol"
}

SWEP.Primary = {
	Automatic = false,
	Range = 4096,
	SpreadAir = vector_origin,
	SpreadMove = vector_origin,
	SpreadCrouch = vector_origin
}

SWEP.Secondary = {
	SpreadAir = -1,
	SpreadMove = -1,
	SpreadCrouch = -1
}

SWEP.Accuracy = {
	Base = 0,
	Decay = 0,
	Time = 0,
	Min = 0,
	Speed = 5/250
}

SWEP.PunchIntensity = -2

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	
	SWEP.CSSCrosshair = {
		Min = 8
	}
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:SharedDeploy( bDelayed )
	BaseClass.SharedDeploy( self, bDelayed )
	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:FinishReload()	
	self.m_flAccuracy = self.Accuracy.Base
end

function SWEP:Shoot( bSecondary, iIndex, sPlay, iClipDeduction )
	
	// Mark the time of this shot and determine the accuracy modifier based on the last shot fired...
	local flAccuracy = self.m_flAccuracy - self.Accuracy.Decay * (self.Accuracy.Time - (CurTime() - self:GetLastShootTime()))
	
	BaseClass.Shoot( self, bSecondary, iIndex, sPlay, iClipDeduction )
	
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
	aPunch[1] = aPunch[1] + self.PunchIntensity
	pPlayer:SetViewPunchAngles( aPunch )
end

function SWEP:GetSpecialKey( sKey, bSecondary, bNoConVar )
	if ( sKey == "Spread" ) then
		local pPlayer = self:GetOwner()
		
		if ( not pPlayer:OnGround() ) then
			return BaseClass.GetSpecialKey( self, "SpreadAir", bSecondary, bNoConVar ) * (1 - self.m_flAccuracy)
		end
		
		if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2 ) then
			return BaseClass.GetSpecialKey( self, "SpreadMove", bSecondary, bNoConVar ) * (1 - self.m_flAccuracy)
		end
		
		if ( pPlayer:Crouching() ) then
			return BaseClass.GetSpecialKey( self, "SpreadCrouch", bSecondary, bNoConVar ) * (1 - self.m_flAccuracy)
		end
		
		return BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar ) * (1 - self.m_flAccuracy)
	end
	
	return BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar )
end
