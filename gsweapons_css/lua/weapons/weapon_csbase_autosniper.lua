SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_AutoSniper"
SWEP.Slot = 3

SWEP.HoldType = "ar2"
SWEP.Weight = 20

SWEP.Sounds = {
	zoom = "Default.Zoom"
}

SWEP.Primary = {
	Range = 8192,
	Cooldown = 0.25,
	WalkSpeed = 210/250,
	SpreadAir = Vector(0.45, 0.45),
	SpreadMove = Vector(0.15, 0.15),
	SpreadCrouch = vector_origin,
	SpreadAdditive = Vector(0.025, 0.025)
}

SWEP.Secondary = {
	WalkSpeed = 150/250,
	SpreadAir = -1,
	SpreadMove = -1,
	SpreadCrouch = -1,
	SpreadAdditive = vector_origin
}

SWEP.Zoom = {
	FOV = { -- FOVs for each zoom level
		40,
		15
	},
	Times = {
		[0] = 0.1,
		0.3,
		0.05
	},
	Levels = 2,
	HideViewModel = true
}

SWEP.Accuracy = {
	Base = 0.98,
	Additive = 0,
	Time = 0,
	Speed = 5/250
}

SWEP.PunchRand = {
	Name = "AutoSniper",
	XMin = 0,
	XMax = 0,
	YMin = -0.75,
	YMax = 0.75
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	
	SWEP.EventStyle = {
		-- CS:S muzzle flash
		[5001] = "css_x",
		[5011] = "css_x",
		[5021] = "css_x",
		[5031] = "css_x"
	}
	
	SWEP.Zoom.DrawOverlay = true
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

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:AdvanceZoom(0)
		
		return true
	end
	
	return false
end

function SWEP:Shoot( bSecondary, iIndex, sPlay, iClipDeduction )
	// Mark the time of this shot and determine the accuracy modifier based on the last shot fired...
	local flAccuracy = self.Accuracy.Additive + self.Accuracy.Time * (CurTime() - self:GetLastShootTime())
	
	BaseClass.Shoot( self, bSecondary, iIndex, sPlay, iClipDeduction )
	
	if ( flAccuracy > self.Accuracy.Base ) then
		self.m_flAccuracy = self.Accuracy.Base
	else
		self.m_flAccuracy = flAccuracy
	end
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	local tRandom = self.PunchRand
	local x = aPunch[1]
	
	// Adjust the punch angle.
	aPunch[1] = x - (pPlayer:SharedRandomFloat( tRandom.Name .. "PunchAngleX", tRandom.XMin, tRandom.XMax ) + x / 4)
	aPunch[2] = aPunch[2] + pPlayer:SharedRandomFloat( tRandom.Name .. "PunchAngleY", tRandom.YMin, tRandom.YMax )
	pPlayer:SetViewPunchAngles( aPunch )
end

function SWEP:GetSpecialKey( sKey, bSecondary, bNoConVar )
	if ( sKey == "Spread" ) then
		local pPlayer = self:GetOwner()
		
		if ( not pPlayer:OnGround() ) then
			return BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadAir", bSecondary, bNoConVar ) * (1 - self.m_flAccuracy)
		end
		
		if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2 ) then
			return BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadMove", bSecondary, bNoConVar )
		end
		
		if ( pPlayer:Crouching() ) then
			return BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadCrouch", bSecondary, bNoConVar ) * (1 - self.m_flAccuracy)
		end
		
		return BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar ) * (1 - self.m_flAccuracy)
	end
	
	return BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar )
end
