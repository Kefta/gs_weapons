SWEP.Base = "weapon_hl2mp_base"

SWEP.PrintName = "HL2MPBase_MachineGun"

SWEP.Activities = {
	shoot_alt = ACT_VM_RECOIL1,
	shoot_alt2 = ACT_VM_RECOIL2,
	shoot_alt3 = ACT_VM_RECOIL3
}

SWEP.Primary.Spread = VECTOR_CONE_3DEGREES

SWEP.PunchAngle = {
	Min = Vector(0.2, 0.2, 0.1), // Degrees
	Clip = Angle(24, 3, 1),
	Dampening = 0.5, // NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
	VerticalKick = 1, // Degrees
	SlideLimit = 1 // Seconds
}

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	
	self:AddNWVar("Int", "AnimLevel") // Number of consecutive shots fired
	self:AddNWVar("Float", "FireDuration")
end

function SWEP:ItemFrame()
	if (self:GetOwner():KeyDown(IN_ATTACK)) then
		self.dt.FireDuration = self.dt.FireDuration + FrameTime()
	else
		self.dt.FireDuration = 0
		
		// Debounce the recoiling counter
		self.dt.AnimLevel = 0
	end
end

function SWEP:ReloadClips()
	BaseClass.ReloadClips(self)
	
	self.dt.FireDuration = 0
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	local iLevel = self.dt.AnimLevel
	
	-- Don't update the networked value if we don't need to
	if (iLevel ~= 5) then
		self.dt.AnimLevel = iLevel + 1
	end
end

function SWEP:Punch(bSecondary)
	local pPlayer = self:GetOwner()
	
	// Do this to get a hard discontinuity, clear out anything under 10 degrees punch
	pPlayer:ViewPunchReset(10)
	
	-- Random seed is reset here
	-- The "iSeed" var is actually incremented after the first RandomInt
	-- But RandomSeed isn't called again. Probably an oversight
	code_gs.random:SetSeed(pPlayer:GetMD5Seed() % 0x100)
	
	// Apply this to the view angles as well
	local tPunch = self.PunchAngle
	local vKick = tPunch.Min
	local flSlide = tPunch.SlideLimit
	local flKick = (self.dt.FireDuration > flSlide and flSlide or self.dt.FireDuration) / flSlide * tPunch.VerticalKick
	local aPunch = Angle(-(vKick[1] + flKick),
		// Wobble left and right
		(vKick[2] + flKick) * (code_gs.random:RandomInt(-1, 1) == -1 and -1 or 1) / 3,
		// Wobble up and down
		(vKick[3] + flKick) * (code_gs.random:RandomInt(-1, 1) == -1 and -1 or 1) / 8)
	
	// Clip this to out desired min/max
	aPunch:ClipPunchAngleOffset(pPlayer:GetPunchAngle(), tPunch.Clip)
	
	// Add it to the view punch
	pPlayer:ViewPunch(aPunch * tPunch.Dampening)
end

function SWEP:PlayActivity(sActivity, iIndex, flRate, bStrictPrefix, bStrictSuffix)
	if (sActivity == "shoot" and self:GetShootClip(self:SpecialActive()) ~= 0) then
		local iShotsFired = self.dt.AnimLevel
		
		return BaseClass.PlayActivity(self, (iShotsFired == 0 or iShotsFired == 1) and "shoot" or iShotsFired == 2 and "shoot_alt" or iShotsFired == 3 and "shoot_alt2" or "shoot_alt3", iIndex, flRate)
	end
	
	return BaseClass.PlayActivity(self, sActivity, iIndex, flRate)
end
