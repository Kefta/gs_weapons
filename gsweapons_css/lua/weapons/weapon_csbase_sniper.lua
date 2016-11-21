SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Sniper"
SWEP.Slot = 3

SWEP.HoldType = "ar2"
SWEP.Weight = 30

SWEP.Sounds = {
	zoom = "Default.Zoom"
}

SWEP.Primary = {
	ClipSize = 10,
	Automatic = false,
	Range = 8192,
	SpreadAir = vector_origin,
	SpreadSprint = vector_origin,
	SpreadMove = vector_origin,
	SpreadCrouch = vector_origin,
	SpreadAdditive = vector_origin
}

SWEP.Secondary = {
	SpreadAir = -1,
	SpreadSprint = -1,
	SpreadMove = -1,
	SpreadCrouch = -1,
	SpreadAdditive = vector_origin
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
	HideViewModel = true
}

SWEP.Penetration = 3

SWEP.Accuracy = {
	Sprint = 0,
	Speed = 0
}

SWEP.PunchIntensity = 2

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	
	SWEP.Zoom.DrawOverlay = true
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:AdvanceZoom(0)
		
		return true
	end
	
	return false
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	aPunch[1] = aPunch[1] - self.PunchIntensity 
	pPlayer:SetViewPunchAngles( aPunch )
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:GetSpecialKey( sKey, bSecondary, bNoConVar )
	if ( sKey == "Spread" ) then
		local pPlayer = self:GetOwner()
		
		if ( not pPlayer:OnGround() ) then
			return BaseClass.GetSpecialKey( self, "SpreadAir", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar )
		end
		
		local flLength = pPlayer:_GetAbsVelocity():Length2DSqr()
		local flWalkSpeed = pPlayer:GetWalkSpeed()
		
		if ( flLength > (flWalkSpeed * self.Accuracy.Sprint) ^ 2 ) then
			return BaseClass.GetSpecialKey( self, "SpreadSprint", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar )
		end
		
		if ( flLength > (flWalkSpeed * self.Accuracy.Speed) ^ 2 ) then
			return BaseClass.GetSpecialKey( self, "SpreadMove", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar )
		end
		
		if ( pPlayer:Crouching() ) then
			return BaseClass.GetSpecialKey( self, "SpreadCrouch", bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar )
		end
		
		return BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar ) + BaseClass.GetSpecialKey( self, "SpreadAdditive", bSecondary, bNoConVar )
	end
	
	return BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar )
end
