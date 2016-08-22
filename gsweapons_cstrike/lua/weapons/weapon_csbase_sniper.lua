DEFINE_BASECLASS( "weapon_csbase_gun" )

--- GSBase
SWEP.PrintName = "CSBase_Sniper"
SWEP.Spawnable = false
SWEP.Slot = 3

SWEP.HoldType = "ar2"
SWEP.Weight = 30

SWEP.Primary = {
	ClipSize = 10,
	Automatic = false,
	Range = 8192,
	Spread = {
		Air = 0,
		FastMove = 0,
		Move = 0,
		Crouch = 0,
		Additive = 0
	}
}

SWEP.Secondary = {
	Spread = {
		Air = -1,
		FastMove = -1,
		Move = -1,
		Crouch = -1,
		Additive = 0
	}
}

SWEP.Zoom = {
	FOV = {
		40
	},
	Times = {
		0.15
	},
	Levels = 2, -- Number of zoom levels
	Cooldown = 0.3, -- Cooldown between zooming
	UnzoomOnFire = true,
	HideViewModel = true,
	DrawOverlay = CLIENT and true or nil
}

SWEP.SpecialType = SPECIAL_ZOOM

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

--- CSBase_Gun
SWEP.Penetration = 3

--- CSBase_Sniper
SWEP.Accuracy = {
	FastSpeed = 0,
	Speed = 0
}

SWEP.PunchIntensity = 2

--- GSBase
function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetPunchAngle()
	aPunch.x = aPunch.x - self.PunchIntensity 
	pPlayer:SetViewPunchAngles( aPunch )
end

--- CSBase_Gun
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	bSecondary = bSecondary or bSecondary == nil and (self:SpecialActive() or CurTime() < self.m_zoomActiveTime)
	local flAdditive = bSecondary and self.Secondary.Spread.Additive or self.Primary.Spread.Additive
	local pPlayer = self:GetOwner()
	
	if ( not pPlayer:OnGround() ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.Air
			
			if ( flSpecial ~= -1 ) then
				return flSpecial + flAdditive
			end
		end
		
		return self.Primary.Spread.Air + flAdditive
	end
	
	local flLength = pPlayer:_GetAbsVelocity():Length2DSqr()
	local flSpeed = pPlayer:GetWalkSpeed()
	
	if ( flLength > (flSpeed * self.Accuracy.FastSpeed) ^ 2 ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.FastMove
			
			if ( flSpecial ~= -1 ) then
				return flSpecial + flAdditive
			end
		end
		
		return self.Primary.Spread.FastMove + flAdditive
	end
	
	if ( flLength > (flSpeed * self.Accuracy.Speed) ^ 2 ) then
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
				return flSpecial + flAdditive
			end
		end
		
		return self.Primary.Spread.Crouch + flAdditive
	end
	
	return BaseClass.GetSpread( self, bSecondary ) + flAdditive
end
