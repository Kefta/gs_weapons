DEFINE_BASECLASS( "weapon_csbase_gun" )

--- GSBase
SWEP.PrintName = "CSBase_AutoSniper"
SWEP.Spawnable = false
SWEP.Slot = 3

SWEP.HoldType = "ar2"
SWEP.Weight = 20

SWEP.Primary = {
	Range = 8192,
	Cooldown = 0.25,
	WalkSpeed = 210/250,
	Spread = {
		Air = 0.45,
		Move = 0.15,
		Crouch = 0,
		Additive = 0.025
	}
}

SWEP.Secondary = {
	WalkSpeed = 150/250,
	Spread = {
		Air = -1,
		Move = -1,
		Crouch = -1,
		Additive = 0
	}
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
	HideViewModel = true,
	DrawOverlay = CLIENT and true or nil
}

SWEP.SpecialType = SPECIAL_ZOOM

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	
	SWEP.EventStyle = {
		-- CS:S muzzle flash
		[5001] = "css_x",
		[5011] = "css_x",
		[5021] = "css_x",
		[5031] = "css_x"
	}
end

--- CSBase_AutoSniper
SWEP.Accuracy = {
	Base = 0.98,
	Additive = 0,
	Time = 0,
	Speed = 5/250
}

SWEP.Alias = "AutoSniper"

SWEP.Random = {
	XMin = 0,
	XMax = 0,
	YMin = -0.75,
	YMax = 0.75
}

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

function SWEP:ShootBullets( tbl, bSecondary, iClipDeduction )
	BaseClass.ShootBullets( self, tbl, bSecondary, iClipDeduction )
	
	// Mark the time of this shot and determine the accuracy modifier based on the last shot fired...
	local flCurTime = CurTime()
	local flAccuracy = self.Accuracy.Additive + self.Accuracy.Time * (flCurTime - self.m_flLastFire)
	self.m_flLastFire = flCurTime
	
	if ( flAccuracy > self.Accuracy.Base ) then
		self.m_flAccuracy = self.Accuracy.Base
	else
		self.m_flAccuracy = flAccuracy
	end
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetPunchAngle()
	local x = aPunch.x
	
	// Adjust the punch angle.
	aPunch.x = x - (pPlayer:SharedRandomFloat( self.Alias .. "PunchAngleX", self.Random.XMin, self.Random.XMax ) + x / 4)
	aPunch.y = aPunch.y + pPlayer:SharedRandomFloat( self.Alias .. "PunchAngleY", self.Random.YMin, self.Random.YMax )
	pPlayer:SetViewPunchAngles( aPunch )
end

--- CSBase_Gun
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	bSecondary = bSecondary or bSecondary == nil and self:SpecialActive()
	local flAdditive = bSecondary and self.Secondary.Spread.Additive or self.Primary.Spread.Additive
	local pPlayer = self:GetOwner()
	
	if ( not pPlayer:OnGround() ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.Air
			
			if ( flSpecial ~= -1 ) then
				return flSpecial * (1 - self.m_flAccuracy) + flAdditive
			end
		end
		
		return self.Primary.Spread.Air * (1 - self.m_flAccuracy) + flAdditive
	end
	
	if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2 ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.Move
			
			if ( flSpecial ~= -1 ) then
				return flSpecial + flAdditive
			end
		end
		
		return self.Primary.Spread.Move + flAdditive
	end
	
	if ( pPlayer:Crouching() ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.Crouch
			
			if ( flSpecial ~= -1 ) then
				return flSpecial * (1 - self.m_flAccuracy) + flAdditive
			end
		end
		
		return self.Primary.Spread.Crouch * (1 - self.m_flAccuracy) + flAdditive
	end
	
	return BaseClass.GetSpread( self, bSecondary ) * (1 - self.m_flAccuracy) + flAdditive
end
