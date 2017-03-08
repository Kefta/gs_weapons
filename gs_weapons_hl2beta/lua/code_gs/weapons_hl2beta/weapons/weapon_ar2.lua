-- FIXME: Add sounds
-- FIXME: Check what to do for the dryfire activities

SWEP.Base = "weapon_hlbase_machinegun"

SWEP.Spawnable = true
SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.ViewModel = "models/code_gs/weapons/hl2beta_2003/v_ar2.mdl"
SWEP.WorldModel = "models/code_gs/weapons/hl2beta_2003/w_ar2.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 5

SWEP.Sounds = {
	empty = "Weapon_AR2.Empty",
	reload = "Weapon_AR2.Reload",
	shoot = "Weapon_AR2.Single",
	zoom = function(self, iIndex) return self:GetZoomLevel() == 0 and "" or "Weapon_AR2.Special1" end,
	zoomout = "Weapon_AR2.Special2"
}

SWEP.Activities = {
	shoot = function(self, iIndex)
		local iShots = self:GetPredictedVar("AnimLevel" .. iIndex, 0)
		
		if (iShots < 2) then
			return ACT_VM_PRIMARYATTACK
		end
		
		if (iShots == 2) then
			return ACT_VM_HITLEFT
		end
		
		if (iShots == 3) then
			return ACT_VM_HITLEFT2
		end
		
		return ACT_VM_HITRIGHT
	end
}

SWEP.Primary.Ammo = "MediumRound"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60

SWEP.Primary.Cooldown = function(self)
	return self:GetZoomLevel() == 0 and 0.1 or 0.3
end

SWEP.Primary.Spread = function(self)
	return self:GetOwner():IsPlayer() and (self:GetZoomLevel() == 0 and VECTOR_CONE_3DEGREES
		or VECTOR_CONE_1DEGREES) or VECTOR_CONE_8DEGREES
end

SWEP.Secondary.Automatic = false

SWEP.Zoom = {
	Cooldown = 0,
	FOV = {
		35
	},
	Times = {
		Reload = 0.1,
		Holster = 0.1,
		[0] = 0.1,
		0.1
	},
	FadeColor = Color(50, 255, 170, 32),
	FadeTime = 0.2
}

SWEP.PunchAngle = {
	VerticalKick = 24, //Degrees
	SlideLimit = 3 //Seconds
}

if (CLIENT) then
	SWEP.KillIcon = '2'
	SWEP.SelectionIcon = 'l'
	
	SWEP.Zoom.HideViewModel = true
end

function SWEP:SharedDeploy()
	for i = 0, self.ViewModelCount - 1 do
		if (self:GetPredictedVar("AnimLevel" .. i, 0) ~= 0) then
			self:SetPredictedVar("AnimLevel" .. i, 0)
		end
	end
end

function SWEP:ItemFrame()
	if (self:GetZoomLevel() == 0) then
		BaseClass.ItemFrame(self)
	else
		for i = 0, self.ViewModelCount - 1 do
			if (self:UseViewModel(i)) then
				if (self:ViewModelInactive(i)) then
					if (self:GetPredictedVar("FireDuration" .. i, 0) ~= 0) then
						self:SetPredictedVar("FireDuration" .. i, 0)
					end
				else
					self:SetPredictedVar("FireDuration" .. i, 0.05 + FrameTime())
				end
			end
		end
	end
end

function SWEP:MouseLifted(iIndex)
	BaseClass.MouseLifted(self, iIndex)
	
	if (self:GetPredictedVar("AnimLevel" .. iIndex, 0) ~= 0) then
		self:SetPredictedVar("AnimLevel" .. iIndex, 0)
	end
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:AdvanceZoom(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	local iLevel = self:GetPredictedVar("AnimLevel" .. iIndex, 0)
	
	if (iLevel ~= 5) then
		self:SetPredictedVar("AnimLevel" .. (iIndex or 0), iLevel + 1)
	end
end

function SWEP:FinishReload(iIndex)
	if (self:GetPredictedVar("AnimLevel" .. iIndex, 0) ~= 0) then
		self:SetPredictedVar("AnimLevel" .. iIndex, 0)
	end
end

if (SERVER) then
	local nZoomIn = bit.bor(SCREENFADE.OUT, SCREENFADE.PURGE, SCREENFADE.STAYOUT)
	local nZoomOut = bit.bor(SCREENFADE.IN, SCREENFADE.PURGE)
	
	-- FIXME: Sort of hack, fade-in screen to zoom, even after holster and reload
	function SWEP:SetZoomLevel(iLevel)
		if (self:GetZoomLevel() ~= iLevel) then
			if (iLevel == 0) then
				local pPlayer = self:GetOwner()
				
				if (pPlayer:IsValid()) then
					self:PlaySound("zoomout")
					
					local tZoom = self.Zoom
					pPlayer:ScreenFade(nZoomOut, tZoom.FadeColor, tZoom.FadeTime, 0)
				end
			elseif (iLevel == 1) then
				local pPlayer = self:GetOwner()
				
				if (pPlayer:IsValid()) then
					local tZoom = self.Zoom
					pPlayer:ScreenFade(nZoomIn, tZoom.FadeColor, tZoom.FadeTime, 0)
				end
			end
		end
		
		BaseClass.SetZoomLevel(self, iLevel)
	end
end
