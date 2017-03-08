include("shared.lua")

--- Selection/Menu
SWEP.Category = "GS Source" -- Category in the spawn menu the weapon should appear in
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

--SWEP.RenderGroup = RENDERGROUP_OPAQUE -- April 2016: "RenderGroup of SENTs and SWEPs is now defaulted to engine default unless overridden (instead of defaulting to RG_OPAQUE)"

--- Weapon behaviour
-- These are seperated by primary/secondary so ironsights can lower it
SWEP.BobCycle = 0.45 -- Magnitude of the weapon bob
SWEP.BobUp = 0.5 -- Sway deviation

SWEP.Zoom.HideViewModel = false -- Hide view model when zoomed
SWEP.Zoom.DrawOverlay = false -- Draw scope overlay when zoomed

SWEP.IronSights.Pos = vector_origin -- Local positional translation of the viewmodel
SWEP.IronSights.Ang = angle_zero -- Local angular translation of the viewmodel

--- Holster
if (game.SinglePlayer()) then
	net.Receive("GS-Weapons-Reload", function()
		local pWeapon = LocalPlayer():GetActiveWeapon()
		pWeapon:AddEvent("reload_" .. pWeapon:GetWorldModelIndex(), -1)
	end)
	
	net.Receive("GS-Weapons-Finish reload", function()
		local pWeapon = LocalPlayer():GetActiveWeapon()
		pWeapon:RemoveReload(pWeapon:GetWorldModelIndex()) -- Remove immediately
	end)
	
	net.Receive("GS-Weapons-Bipod deploy", function()
		local pActiveWeapon = LocalPlayer():GetActiveWeapon()
		pActiveWeapon:SetPredictedVar("DeployYawStart", net.ReadDouble())
		pActiveWeapon:SetPredictedVar("DeployYawLeft", net.ReadDouble())
		pActiveWeapon:SetPredictedVar("DeployYawRight", net.ReadDouble())
	end)
	
	net.Receive("GS-Weapons-Bipod deploy update", function()
		local pActiveWeapon = LocalPlayer():GetActiveWeapon()
		pActiveWeapon:SetPredictedVar("DeployYawLeft", net.ReadDouble())
		pActiveWeapon:SetPredictedVar("DeployYawRight", net.ReadDouble())
	end)
end

--- HUD
function SWEP:DoDrawCrosshair(x, y)
	local pPlayer = self:GetOwner()
	
	if (pPlayer:IsValid()) then
		return self.Zoom.DrawOverlay and self:GetZoomLevel() ~= 0 and not pPlayer:ShouldDrawLocalPlayer()
			and code_gs.weapons.GetScope(self.ScopeStyle)(self, x, y)
			or code_gs.weapons.GetCrosshair(self.CrosshairStyle)(self, x, y)
	end
end

function SWEP:DrawWeaponSelection(x, y, flWide, flTall)
	draw.SimpleText(self.SelectionIcon, self.SelectionFont, x + flWide / 2, y + flTall * 0.1, self.SelectionColor, TEXT_ALIGN_CENTER)
end

function SWEP:PrintWeaponInfo(x, y, flAlpha)
	-- FIXME
end

--- Viewmodel
function SWEP:CalcViewModelView(pViewModel, vPos, aRot, vNewPos, aNewRot)
	if (self:GetOwner():IsValid()) then
		local vTemp, aTemp = self:CalcViewModelOffset(pViewModel)
		vPos, aRot = LocalToWorld(vTemp, aTemp, vPos, aRot)
		-- FIXME: Is that right? Also, make it work for post-bob values
		return code_gs.weapons.GetBobType(self.BobStyle)(self, pViewModel, vPos, aRot, vNewPos, aNewRot)
	end
end

function SWEP:CalcViewModelOffset(pViewModel)
	local iIndex = pViewModel:ViewModelIndex()
	local tTransform = iIndex == 0 and self.ViewModelTransform or self["ViewModelTransform" .. iIndex]
	
	--[[if (self:GetIronSights(iIndex)) then
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
	end]]
	
	return tTransform.Pos, tTransform.Ang
end

function SWEP:PreDrawViewModel(pViewModel)
	-- https://github.com/Facepunch/garrysmod-issues/issues/3024
	if (pViewModel) then
		local iIndex = pViewModel:ViewModelIndex()
		local sViewModel = self:GetViewModel(iIndex)
		pViewModel:SetModel(sViewModel)
		
		-- FIXME: NULL viewmodels aren't sent in?
		if (sViewModel == "" or self:GetHideWeapon(iIndex) or (self.Zoom.HideViewModel and self:GetZoomLevel() > 0)) then
			return true
		end
	end
end

--- Worldmodel
local function DrawWorldModel(self)
	local iIndex = self:GetWorldModelIndex()
	
	if (not (self.WorldModel == "" or self:GetHideWeapon(iIndex))) then
		if (self.SilencerModel ~= "" and self:GetSilenced(iIndex)) then
			self:SetModel(self.SilencerModel)
		elseif (self.DroppedModel ~= "" and self:GetOwner() == NULL) then
			self:SetModel(self.DroppedModel)
		elseif (self.ReloadModel ~= "" and self:EventActive("reload_" .. iIndex)) then
			self:SetModel(self.ReloadModel)
		end
		
		self:DrawModel()
	end
end

SWEP.DrawWorldModel = DrawWorldModel
SWEP.DrawWorldModelTranslucent = DrawWorldModel

--- Attack
-- Shared for the HL1 grenade
function SWEP:EmitGrenade()
end

--- Hooks
local deployed_mg_sensitivity = CreateConVar("gs_weapons_deployed_mg_sensitivity", "0.9", FCVAR_CHEAT, "Mouse sensitivity while deploying a machine gun")

function SWEP:AdjustMouseSensitivity()
	if (self:GetBipodDeployed()) then
		return deployed_mg_sensitivity:GetFloat()
	end
end

--- Accessors/Modifiers
code_gs.weapons.PredictedAccessorFunc(SWEP, false, "Int", "ClientState", 1)

function SWEP:GetMuzzleFlashScale()
	return self.MuzzleFlashScale
end
