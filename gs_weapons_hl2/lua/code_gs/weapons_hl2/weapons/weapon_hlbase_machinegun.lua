SWEP.Base = "basehlcombatweapon"

SWEP.PrintName = "HL2Base_MachineGun"

SWEP.Primary.Spread = VECTOR_CONE_3DEGREES

SWEP.PunchAngle = {
	Min = Vector(0.2, 0.2, 0.1), // Degrees
	Clip = Angle(24, 3, 1), -- Angle punch clipping
	Dampening = 0.5, // NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
	VerticalKick = 1, // Degrees
	SlideLimit = 1, // Seconds
	EasyDampening = 0.5, -- Angle multiplier to use for Easy skill level
	PunchResetTolerance = 10
}

function SWEP:ItemFrame()
	for i = 0, self.ViewModelCount - 1 do
		if (self:UseViewModel(i)) then
			if (self:ViewModelInactive(i)) then
				if (self:GetPredictedVar("FireDuration" .. i, 0) ~= 0) then
					self:SetPredictedVar("FireDuration" .. i, 0)
				end
			else
				self:SetPredictedVar("FireDuration" .. i, self:GetPredictedVar("FireDuration" .. i, 0) + FrameTime())
			end
		end
	end
end

function SWEP:ReloadClips(iIndex)
	BaseClass.ReloadClips(self, iIndex)
	
	if (self:GetPredictedVar("FireDuration" .. iIndex, 0) ~= 0) then
		self:SetPredictedVar("FireDuration" .. iIndex, 0)
	end
end

function SWEP:Punch(bSecondary --[[= false]], iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
	
	// Apply this to the view angles as well
	local tPunch = self.PunchAngle
	local vKick = tPunch.Min
	local flSlide = tPunch.SlideLimit
	local flFireDuration = self:GetPredictedVar("FireDuration" .. iIndex, 0)
	local flKick = (flFireDuration > flSlide and flSlide or flFireDuration) / flSlide * tPunch.VerticalKick
	local iMultiplier = game.GetSkillLevel() == 1 and self.PunchAngle.EasyDampening or 1
	
	-- FIXME: Make sure the random seed has been set
	local aPunch = Angle(-(vKick[1] + flKick) * iMultiplier,
		// Wobble left and right
		(vKick[2] + flKick) * (code_gs.random:RandomInt(-1, 1) == -1 and -iMultiplier or iMultiplier) / 3,
		// Wobble up and down
		(vKick[3] + flKick) * (code_gs.random:RandomInt(-1, 1) == -1 and -iMultiplier or iMultiplier) / 8)
	
	// Do this to get a hard discontinuity, clear out anything under 10 degrees punch
	pPlayer:ViewPunchReset(tPunch.PunchResetTolerance)
	
	// Clip this to out desired min/max
	aPunch:ClipPunchAngleOffset(pPlayer:GetPunchAngle(), tPunch.Clip)
	aPunch:Mul(tPunch.Dampening)
	
	// Add it to the view punch
	pPlayer:ViewPunch(aPunch)
end
