DEFINE_BASECLASS( "hl2_basehlcombatweapon" )

--- GSBase
SWEP.PrintName = "HL2Base_MachineGun"

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 SP"
end

SWEP.Activities = {
	primary2 = ACT_VM_RECOIL1,
	primary3 = ACT_VM_RECOIL2,
	primary4 = ACT_VM_RECOIL3
}

SWEP.Primary.Spread = VECTOR_CONE_3DEGREES

--- HL2Base_MachineGun
SWEP.PunchAngle = {
	Min = Vector(0.2, 0.2, 0.1), // Degrees
	Clip = Angle(24, 3, 1),
	Dampening = 0.5, // NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
	VerticalKick = 1, // Degrees
	SlideLimit = 1, // Seconds
	EasyDampening = 0.5 -- Angle multiplier to use for Easy skill level
}

--- GSBase
function SWEP:SetupDataTables()
	BaseClass.SetupDataTables( self )
	
	self:AddNWVar( "Int", "AnimLevel", false ) // Number of consecutive shots fired
	self:AddNWVar( "Float", "FireDuration", false )
end

function SWEP:ItemFrame()
	if ( self:GetOwner():KeyDown( IN_ATTACK )) then
		self.dt.FireDuration = self.dt.FireDuration + FrameTime()
	else
		self.dt.FireDuration = 0
		
		// Debounce the recoiling counter
		self.dt.AnimLevel = 0
	end
end

-- StartReload
function SWEP:Reload()
	if ( BaseClass.Reload( self )) then
		self.dt.FireDuration = 0
		
		return true
	end
	
	return false
end

function SWEP:Shoot( bSecondary --[[= false]], iClipDeduction --[[= 1]] )
	BaseClass.Shoot( self, bSecondary, iClipDeduction )
	
	local iLevel = self.dt.AnimLevel
	
	-- Don't update the networked value if we don't need to
	if ( iLevel ~= 4 ) then
		self.dt.AnimLevel = iLevel + 1
	end
end

function SWEP:Punch( bSecondary )
	local pPlayer = self:GetOwner()
	
	// Do this to get a hard discontinuity, clear out anything under 10 degrees punch
	pPlayer:ViewPunchReset(10)
	
	// Apply this to the view angles as well
	local tPunch = self.PunchAngle
	local vKick = tPunch.Min
	local flSlide = tPunch.SlideLimit
	local flKick = (self.dt.FireDuration > flSlide and flSlide or self.dt.FireDuration) / flSlide * tPunch.VerticalKick
	local iMultiplier = game.GetSkillLevel() == 1 and self.PunchAngle.EasyDampening or 1
	local aPunch = Angle( -(vKick[1] + flKick) * iMultiplier,
		// Wobble left and right
		(vKick[2] + flKick) * (random.RandomInt(-1, 1) == -1 and -iMultiplier or iMultiplier) / 3,
		// Wobble up and down
		(vKick[3] + flKick) * (random.RandomInt(-1, 1) == -1 and -iMultiplier or iMultiplier) / 8 )
	
	// Clip this to out desired min/max
	aPunch:ClipPunchAngleOffset( pPlayer:GetPunchAngle(), tPunch.Clip )
	
	// Add it to the view punch
	pPlayer:ViewPunch( aPunch * tPunch.Dampening )
end

function SWEP:PlayActivity( sActivity, iIndex, flRate )
	if ( sActivity == "primary" and self:Clip1() ~= 0 ) then
		local iShotsFired = self.dt.AnimLevel
		
		return BaseClass.PlayActivity( self, iShotsFired == 0 and "primary" or iShotsFired == 1 and "primary" or iShotsFired == 2 and "primary2" or iShotsFired == 3 and "primary3" or "primary4", iIndex, flRate )
	end
	
	return BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
end
