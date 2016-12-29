include("shared.lua")

--- Selection/Menu
SWEP.Category = "GS Source" -- Category in the spawn menu the weapon should appear in. This must be defined in every weapon!
SWEP.DrawAmmo = true -- Draw HL2 ammo HUD when the weapon is out

SWEP.KillIcon = '' -- '' = no killicon. Letter from the KillIconFont file to draw for killicon notifications
SWEP.KillIconFont = "HL2KillIcon" -- Font defined by surface.CreateFont to use for killicons
SWEP.KillIconColor = Color(255, 80, 0, 255) -- Color of the font for killicons
SWEP.SelectionIcon = 'V' -- Letter from the SelectionFont file to draw on the weapon selection panel
SWEP.SelectionFont = "HL2Selection" -- Font defined by surface.CreateFont to use for weapon selection icons
SWEP.SelectionColor = Color(255, 210, 0, 255) -- Color of the font for weapon selection icons

--- Weapon demeanour
SWEP.ViewModelFlip = false -- Move the view model to the other side of the screen
SWEP.ViewModelFOV = 74 -- Field-of-view of the view model (how far out the viewmodel is projected)
SWEP.ViewModelTransform = {
	Pos = vector_origin,
	Ang = angle_zero
}

SWEP.ViewModelFlip1 = false
SWEP.ViewModelFOV1 = 74
SWEP.ViewModelTransform1 = {
	Pos = vector_origin,
	Ang = angle_zero
}

SWEP.ViewModelFlip2 = false
SWEP.ViewModelFOV2 = 74
SWEP.ViewModelTransform2 = {
	Pos = vector_origin,
	Ang = angle_zero
}

SWEP.BobScale = 1
SWEP.SwayScale = 1
SWEP.BobStyle = "default" -- Style defined by code_gs.weapons.RegisterBobType. Set to "" to disable all bobbing
SWEP.BobSpeed = 320/250 -- Speed at which the bob is clamped at. Only affects css and hl bob styles

SWEP.CrosshairStyle = "default" -- Style defined by code_gs.weapons.RegisterCrosshair. Set to "" to disable crosshair drawing
SWEP.ScopeStyle = "css" -- Style defined by code_gs.weapons.RegsiterScope. Set to "" to disable scope drawing. Scope style to show if the weapon is zoomed and SWEP.Zoom.DrawOverlay is true
SWEP.DrawCrosshair = true -- Call DoDrawCrosshair or not. This will disable crosshair and scope drawing
SWEP.AccurateCrosshair = false -- Moves crosshair with actual shooting position

SWEP.CSSCrosshair = {
	Min = 4, // The minimum distance the crosshair can achieve...
	Delta = 3, // Distance at which the crosshair shrinks at each step
	Vel = 100/250 -- Velocity at which the crosshair expands
}

SWEP.MuzzleFlashScale = 1 -- Only for non-default muzzle flash

-- Events defined by code_gs.weapons.RegisterAnimEvent. Weapon model anim events. Set to "" to block engine execution
SWEP.EventStyle = {
	-- CS:S bullet ejection
	[20] = "css",
	
	-- HL2 muzzle flashes
	[21] = "default", -- First-person
	[22] = "default", -- Third-person
	
	-- HL2 melee hit
	[3001] = "",
	
	-- Grenades
	-- Throw events are handled by Think events
	[3005] = "",
	[3013] = "",
	[3016] = "",
	
	-- Reload
	[3015] = "default",
	
	-- Sequence end
	-- Sequence lengths are managed by network vars
	[3900] = "",
	
	-- CS:S muzzle flash
	[5001] = "css", -- First-person, Attachment 0
	[5003] = "css", -- Third-person, Attachment 0
	[5011] = "css", -- First-person, Attachment 1
	[5013] = "css", -- Third-person, Attachment 1
	[5021] = "css", -- First-person, Attachment 2
	[5023] = "css", -- Third-person, Attachment 2
	[5031] = "css", -- First-person, Attachment 3
	[5033] = "css", -- Third-person, Attachment 3
	
	-- HL2 bullet ejection
	[6001] = "default",
	
	-- DoD:S bullet ejection
	[6002] = "dod"
}

--SWEP.RenderGroup = RENDERGROUP_OPAQUE -- April 2016: "RenderGroup of SENTs and SWEPs is now defaulted to engine default unless overridden (instead of defaulting to RG_OPAQUE)"

--- Weapon behaviour
-- These are seperated by primary/secondary so ironsights can lower it
-- SWEP.SwayScale and SWEP.BobScale are manipulated internally - do not change them!
SWEP.Primary.BobCycle = 0.45 -- Magnitude of the weapon bob
SWEP.Primary.BobUp = 0.5 -- Sway deviation
SWEP.Secondary.BobCycle = -1
SWEP.Secondary.BobUp = -1

SWEP.Zoom.DrawOverlay = false -- Draw scope overlay when zoomed

SWEP.IronSights.DrawCrosshair = false -- Draw crosshair when IronSights is active
SWEP.IronSights.Pos = vector_origin -- Local positional translation of the viewmodel
SWEP.IronSights.Ang = angle_zero -- Local angular translation of the viewmodel

SWEP.BipodDeploy.DrawCrosshair = false -- Draw crosshair when the weapon is deployed

--- Holster
net.Receive("GSWeapons-Holster", function()
	local pWeapon = net.ReadEntity()
	
	if (pWeapon.SharedHolster and pWeapon.m_bActive) then
		local pSwitchingTo = net.ReadEntity()
		pWeapon:SharedHolster(pSwitchingTo:EntIndex() == 0 and NULL or pSwitchingTo, true)
	end
end)

net.Receive("GSWeapons-Holster animation", function()
	local pWeapon = net.ReadEntity()
	
	if (pWeapon.HolsterAnim and not pWeapon.m_bHolsterAnim and pWeapon.m_bActive) then
		local pSwitchingTo = net.ReadEntity()
		pWeapon:HolsterAnim(pSwitchingTo:EntIndex() == 0 and NULL or pSwitchingTo, true)
	end
end)

if (game.SinglePlayer()) then
	net.Receive("GSWeapons-OnDrop", function()
		local pWeapon = net.ReadEntity()
		
		if (pWeapon.m_bActive) then
			pWeapon.m_bActive = false
		end
	end)
	
	net.Receive("GSWeapons-Reload", function()
		LocalPlayer():GetActiveWeapon():AddEvent("reload", -1)
	end)
	
	net.Receive("GSWeapons-Finish reload", function()
		LocalPlayer():GetActiveWeapon():RemoveEvent("reload", true) -- Remove immediately
	end)
	
	net.Receive("GSWeapons-BipodDeploy", function()
		local pActiveWeapon = LocalPlayer():GetActiveWeapon()
		pActiveWeapon.m_flDeployYawStart = net.ReadDouble()
		pActiveWeapon.m_flDeployYawLeft = net.ReadDouble()
		pActiveWeapon.m_flDeployYawRight = net.ReadDouble()
	end)
	
	net.Receive("GSWeapons-BipodDeploy update", function()
		local pActiveWeapon = LocalPlayer():GetActiveWeapon()
		pActiveWeapon.m_flDeployYawLeft = net.ReadDouble()
		pActiveWeapon.m_flDeployYawRight = net.ReadDouble()
	end)
end

--- HUD/Visual
--[[function SWEP:CalcView(pPlayer, vPos, aRot, flFOV)
end]]

function SWEP:CalcViewModelView(pViewModel, vPos, aRot, vNewPos, aNew)
	if (self.dt.Active or self:GetOwner() ~= NULL) then
		local vTemp, aTemp = self:CalcViewModelOffset(pViewModel)
		vPos, ang = LocalToWorld(vTemp, aTemp, vPos, aRot) -- Faster than calculating each component manually in the Lua state
		
		return code_gs.weapons.GetBobType(self.BobStyle)(self, pViewModel, vPos, aRot, vNewPos, aNew)
	end
end

function SWEP:CalcViewModelOffset(vm)
	local iIndex = vm:ViewModelIndex()
	local tTransform = iIndex == 0 and self.ViewModelTransform or iIndex == 1 and self.ViewModel1Transform or self.ViewModel2Transform
	
	if (self:IronSightsEnabled(iIndex)) then
		local flCurTime = CurTime()
		local flZoomActive = iIndex == 0 and self:GetZoomActiveTime() or iIndex == 1 and self:GetZoomActiveTime1() or iIndex == 2 and self:GetZoomActiveTime2()
		local bZooming = flZoomActive > flCurTime
		local iState = self["m_iIronSightsState" .. iIndex]
		
		if (not (bZooming and iState == 0)) then
			if (iState == 0) then
				iState = 1
				self["m_iIronSightsState" .. iIndex] = 1
			end
			
			if (iState == 1) then
				if (bZooming) then
					local flProgress = (flZoomActive - flCurTime) / self.IronSights.ZoomTime
					local flInvProgress = 1 - flProgress
					
					return self.IronSights.Pos * flProgress + flInvProgress * tTransform.Pos, self.IronSights.Ang * flProgress + flInvProgress * tTransform.Ang
				end
				
				iState = 2
				self["m_iIronSightsState" .. iIndex] = 2
			end
			
			if (iState == 2) then
				if (not bZooming) then
					return self.IronSights.Pos, self.IronSights.Ang
				end
				
				iState = 3
				self["m_iIronSightsState" .. iIndex] = 3
			end
			
			if (bZooming) then
				local flProgress = (flZoomActive - flCurTime) / self.IronSights.ZoomTime
				local flInvProgress = 1 - flProgress
				
				return self.IronSights.Pos * flProgress + flInvProgress * tTransform.Pos, self.IronSights.Ang * flProgress + flInvProgress * tTransform.Ang
			end
			
			self["m_iIronSightsState" .. iIndex] = 0
		end
	end
	
	return tTransform.Pos, tTransform.Ang
end

--[[-- Only return in this hook if you want to move all viewmodels
function SWEP:GetViewModelPosition(vPos, aRot)
end

function SWEP:CustomAmmoDisplay()
end]]
	
function SWEP:DoDrawCrosshair(x, y)
	local pPlayer = self:GetOwner()
	
	if (self.dt.Active or pPlayer ~= NULL) then
		return self.Zoom.DrawOverlay and self:GetZoomLevel() ~= 0 and not pPlayer:ShouldDrawLocalPlayer()
			and code_gs.weapons.GetScope(self.ScopeStyle)(self, x, y) or (self.IronSights.DrawCrosshair or self:GetIronSights() == 0)
			and (self.BipodDeploy.DrawCrosshair or self:GetDeployed() == 0) and code_gs.weapons.GetCrosshair(self.CrosshairStyle)(self, x, y)
	end
end

--[[function SWEP:DrawHUD()
end

function SWEP:DrawHUDBackground()
end]]

function SWEP:DrawWeaponSelection(x, y, flWide, flTall)
	draw.SimpleText(self.SelectionIcon, self.SelectionFont, x + flWide / 2, y + flTall * 0.1, self.SelectionColor, TEXT_ALIGN_CENTER)
end

function SWEP:FireAnimationEvent(vPos, ang, iEvent, sOptions)
	local sStyle = self.EventStyle[iEvent]
	
	if (sStyle) then
		code_gs.DevMsg(3, string.format("%s (gs_baseweapon) Event %u played with %q style", self:GetClass(), iEvent, sStyle))
		
		return code_gs.weapons.GetAnimEvent(iEvent, sStyle:lower())(self, vPos, ang, iEvent, sOptions)
	end
	
	code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Missing event %u: %s", self:GetClass(), iEvent, sOptions))
end

--[[function SWEP:HUDShouldDraw(sElement)
end

function SWEP:PostDrawViewModel(pViewModel, pWeapon, pPlayer)
end

function SWEP:PreDrawViewModel(pViewModel, pWeapon, pPlayer)
end

function SWEP:RenderScreen()
end

function SWEP:ViewModelDrawn(pViewModel)
end]]

--- Utilities
function SWEP:PrintWeaponInfo(x, y, flAlpha)
end

--- Hooks
--[[function SWEP:AdjustMouseSensitivity()
end]]

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
	self:DrawModel()
end

--[[function SWEP:TranslateFOV(flFOV)
end]]

--- Accessors/Modifiers
--[[function SWEP:FreezeMovement()
end]]

function SWEP:GetMuzzleFlashScale()
	return self.MuzzleFlashScale
end

--- Player functions
-- DTVar exists are varying times based on when the player loads in
net.Receive("GSWeapons-Player DTVars", function()
	hook.Add("Think", "GSWeapons-Player DTVars", function()	
		local pPlayer = LocalPlayer()
		
		if (pPlayer ~= NULL) then
			pPlayer:InstallDataTable() -- FIXME
			code_gs.weapons.SetupPlayerDataTables(pPlayer)
			hook.Remove("GSWeapons-Player DTVars")
		end
	end)
end)
