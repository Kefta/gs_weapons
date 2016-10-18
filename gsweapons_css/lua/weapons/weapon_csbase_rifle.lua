DEFINE_BASECLASS( "weapon_csbase_gun" )

--- GSBase
SWEP.PrintName = "CSBase_Rifle"
SWEP.Slot = 2

SWEP.HoldType = "ar2"
SWEP.Weight = 25

SWEP.Primary = {
	Range = 8192,
	Spread = {
		Air = 0,
		Move = 0
	}
}

SWEP.Secondary = {
	Spread = {
		Air = -1,
		Move = -1
	}
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
end

--- CSBase_Gun
SWEP.Penetration = 2

--- CSBase_SMG
SWEP.Accuracy = {
	Base = 0.2,
	Divisor = 0, // 0 = off
	Offset = 0,
	Max = 0,
	Quadratic = false,
	Speed = 140/250,
	Additive = 0
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

--- GSBase
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

function SWEP:Shoot( bSecondary, iIndex, iClipDeduction )
	BaseClass.Shoot( self, bSecondary, iIndex, iClipDeduction )
	
	// These modifications feed back into flSpread eventually.
	if ( self.Accuracy.Divisor ~= 0 ) then
		local pPlayer = self:GetOwner()
		local flAccuracy = ( (self.Accuracy.Quadratic and self:GetShotsFired() ^ 2 or self:GetShotsFired() ^ 3) / self.Accuracy.Divisor ) + self.Accuracy.Offset
		
		if ( flAccuracy > self.Accuracy.Max ) then
			self.m_flAccuracy = self.Accuracy.Max
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
	if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tKick.Speed) ^ 2 ) then
		tKick = tKick.Move
	elseif ( not pPlayer:OnGround() ) then
		tKick = tKick.Air
	elseif ( pPlayer:Crouching() ) then
		tKick = tKick.Crouch
	else
		tKick = tKick.Base
	end
	
	local flKickUp = tKick.UpBase
	local flKickLateral = tKick.LateralBase
	local iShotsFired = self:GetShotsFired()
	
	-- Not the first round fired
	if ( iShotsFired > 1 ) then
		flKickUp = flKickUp + iShotsFired * tKick.UpModifier
		flKickLateral = flKickLateral + iShotsFired * tKick.LateralModifier
	end
	
	local ang = pPlayer:GetViewPunchAngles()
	
	ang.p = ang.p - flKickUp
	local flUpMax = tKick.UpMax
	
	if ( ang.p < -1 * flUpMax ) then
		ang.p = -1 * flUpMax
	end
	
	local bDirection = pPlayer.dt.PunchDirection
	
	if ( bDirection ) then
		ang.y = ang.y + flKickLateral
		local flLateralMax = tKick.LateralMax
		
		if ( ang.y > flLateralMax ) then
			ang.y = flLateralMax
		end
	else
		ang.y = ang.y - flKickLateral
		local flLateralMax = tKick.LateralMax
		
		if ( ang.y < -1 * flLateralMax ) then
			ang.y = -1 * flLateralMax
		end
	end
	
	if ( pPlayer:SharedRandomInt( "KickBack", 0, tKick.DirectionChange ) == 0 ) then
		pPlayer.dt.PunchDirection = not bDirection
	end
	
	pPlayer:SetViewPunchAngles( ang )
end

--- CSBase_Gun
function SWEP:GetSpread( bSecondary )
	local pPlayer = self:GetOwner()
	
	-- We're jumping; takes accuracy priority
	if ( not pPlayer:OnGround() ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.Air
			
			if ( flSpecial ~= -1 ) then
				return self.Accuracy.Additive + flSpecial * self.m_flAccuracy
			end
		end
		
		return self.Accuracy.Additive + self.Primary.Spread.Air * self.m_flAccuracy
	end
	
	if ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * self.Accuracy.Speed) ^ 2 ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.Move
			
			if ( flSpecial ~= -1 ) then
				return self.Accuracy.Additive + flSpecial * self.m_flAccuracy
			end
		end
		
		return self.Accuracy.Additive + self.Primary.Spread.Move * self.m_flAccuracy
	end
	
	return BaseClass.GetSpread( self, bSecondary ) * self.m_flAccuracy
end
