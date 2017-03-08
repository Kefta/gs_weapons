local Empty = function() end
local ReturnTrue = function() return true end
local tCrosshairTypes = {}

function code_gs.weapons.RegisterCrosshair(sName, func)
	tCrosshairTypes[sName:lower()] = func
end

function code_gs.weapons.GetCrosshair(sName)
	if (sName == "") then
		return ReturnTrue
	end
	
	return tCrosshairTypes[sName:lower()] or Empty
end

local tColPreset = {
	[0] = {50, 250, 50},
	{250, 50, 50},
	{50, 50, 250},
	{250, 250, 50},
	{50, 250, 250}
}

local cl_crosshaircolor = CreateConVar("gs_weapons_css_crosshaircolor", "0", {FCVAR_CLIENTDLL, FCVAR_ARCHIVE})
local cl_dynamiccrosshair = CreateConVar("gs_weapons_css_dynamiccrosshair", "1", {FCVAR_CLIENTDLL, FCVAR_ARCHIVE})
local cl_scalecrosshair = CreateConVar("gs_weapons_css_scalecrosshair", "1", {FCVAR_CLIENTDLL, FCVAR_ARCHIVE})
local cl_crosshairscale = CreateConVar("gs_weapons_css_crosshairscale", "0", {FCVAR_CLIENTDLL, FCVAR_ARCHIVE})
local cl_crosshairalpha = CreateConVar("gs_weapons_css_crosshairalpha", "200", {FCVAR_CLIENTDLL, FCVAR_ARCHIVE})
local cl_crosshairusealpha = CreateConVar("gs_weapons_css_crosshairusealpha", "0", {FCVAR_CLIENTDLL, FCVAR_ARCHIVE})
local matWhite = Material("vgui/white_additive")
-- FIXME: Doesn't scale properly. Shoot, walk, shoot
code_gs.weapons.RegisterCrosshair("css", function(pWeapon, x, y)
	local pPlayer = pWeapon:GetOwner()
	local iDistance = pWeapon.CSSCrosshair.Min
	
	if (cl_dynamiccrosshair:GetBool()) then
		if (not pPlayer:OnGround()) then
			iDistance = iDistance * 2
		elseif (pPlayer:Crouching()) then
			iDistance = iDistance * 0.5
		elseif (pPlayer:_GetAbsVelocity():LengthSqr() > (pPlayer:GetWalkSpeed() * pWeapon.CSSCrosshair.Vel) ^ 2) then
			iDistance = iDistance * 1.5
		end
	end
	
	local iShotsFired = 0
	
	for i = 0, pWeapon.ViewModelCount - 1 do
		iShotsFired = math.max(iShotsFired, pWeapon:GetShotsFired(i))
	end
	
	if (iShotsFired > pWeapon.m_iAmmoLastCheck) then
		local flNewDist = pWeapon.m_flCrosshairDistance + pWeapon.CSSCrosshair.Delta
		pWeapon.m_flCrosshairDistance = flNewDist > 15 and 15 or flNewDist -- FIXME
	elseif (pWeapon.m_flCrosshairDistance > iDistance) then
		pWeapon.m_flCrosshairDistance = pWeapon.m_flCrosshairDistance - (0.1 + pWeapon.m_flCrosshairDistance * 0.013)
	end
	
	if (pWeapon.m_flCrosshairDistance < iDistance) then
		pWeapon.m_flCrosshairDistance = iDistance
	end
	
	pWeapon.m_iAmmoLastCheck = iShotsFired
	
	//scale bar size to the resolution
	local flScale = 1
	
	if (cl_scalecrosshair:GetBool()) then
		flScale = cl_crosshairscale:GetInt()
		local iHeight = ScrH()
		
		if (flScale < 1) then
			if (iHeight <= 600) then
				flScale = iHeight / 600
			elseif (iHeight <= 768) then
				flScale = iHeight / 768
			else
				flScale = iHeight / 1200
			end
		else
			flScale = iHeight / flScale
		end
	end
	
	local tCrosshairColor = cl_crosshaircolor:GetInt()
	
	if (tCrosshairColor < 0 or tCrosshairColor > 4) then
		tCrosshairColor = tColPreset[0]
	else
		tCrosshairColor = tColPreset[tCrosshairColor]
	end
	
	local bUseAlpha = cl_crosshairusealpha:GetBool()
	
	local iCrosshairDistance = math.ceil(pWeapon.m_flCrosshairDistance * flScale)
	local iBarSize = ScreenScale(5) + (iCrosshairDistance - iDistance) / 2 * flScale
	
	if (iBarSize < 1) then
		iBarSize = 1
	end
	
	local iBarThickness = math.floor(flScale + 0.5)
	
	if (iBarThickness < 1) then
		iBarThickness = 1
	end
	
	local iSize = iCrosshairDistance + iBarSize
	local iThickness = iCrosshairDistance + iBarThickness
	
	if (bUseAlpha) then
		local iAlpha = cl_crosshairalpha:GetInt()
		surface.SetDrawColor(tCrosshairColor[1], tCrosshairColor[2], tCrosshairColor[3], iAlpha < 0 and 0 or iAlpha > 255 and 255 or iAlpha)
		
		// Alpha-blended crosshair
		surface.DrawRect(x - iSize, y, iBarSize, iBarThickness)
		surface.DrawRect(x + iThickness, y, iBarSize, iBarThickness)
		surface.DrawRect(x, y - iSize, iBarThickness, iBarSize)
		surface.DrawRect(x, y + iThickness, iBarThickness, iBarSize)
	else
		surface.SetMaterial(matWhite)
		surface.SetDrawColor(tCrosshairColor[1], tCrosshairColor[2], tCrosshairColor[3], 200)
		
		// Additive crosshair
		surface.DrawTexturedRect(x - iSize, y, iBarSize, iBarThickness)
		surface.DrawTexturedRect(x + iThickness, y, iBarSize, iBarThickness)
		surface.DrawTexturedRect(x, y - iSize, iBarThickness, iBarSize)
		surface.DrawTexturedRect(x, y + iThickness, iBarThickness, iBarSize)
	end

	return true
end)

local cl_crosshair_red = CreateConVar("gs_weapons_dod_crosshairred", "200", FCVAR_ARCHIVE)
local cl_crosshair_green = CreateConVar("gs_weapons_dod_crosshairgreen", "200", FCVAR_ARCHIVE)
local cl_crosshair_blue = CreateConVar("gs_weapons_dod_crosshairblue", "200", FCVAR_ARCHIVE)
local cl_crosshair_alpha = CreateConVar("gs_weapons_dod_crosshairalpha", "200", FCVAR_ARCHIVE)
local cl_crosshair_texture = CreateConVar("gs_weapons_dod_crosshairtexture", "1", FCVAR_ARCHIVE)
local cl_crosshair_scale = CreateConVar("gs_weapons_dod_crosshairscale", "32", FCVAR_ARCHIVE)
local cl_crosshair_approach_speed = CreateConVar("gs_weapons_dod_approachspeed", "0.015", FCVAR_ARCHIVE)
local cl_dynamic_crosshair = CreateConVar("gs_weapons_dod_dynamiccrosshair", "1", FCVAR_ARCHIVE)

local tCrossMat = {}

for i = 1, 7 do
	-- Material is a silly function that provides the time it took to execute as a second return
	-- I was going crazy thinking I had a table corruption since the element after the last would appear to be garbage
	tCrossMat[i] = Material("vgui/crosshairs/crosshair" .. i)
end

code_gs.weapons.RegisterCrosshair("dod", function(pWeapon, x, y)
	local mat = tCrossMat[cl_crosshair_texture:GetInt()]
	
	if (mat) then
		mat:SetInt("$frame", 0)
		
		if (cl_dynamic_crosshair:GetBool()) then
			local flAccuracy = pWeapon:GetSpecialKey("Spread").x -- FIXME: Select average between x and y?
			
			if (flAccuracy < 0.02) then
				flAccuracy = 0.02
			elseif (flAccuracy > 0.125) then
				flAccuracy = 0.125
			end
			
			// approach this accuracy from our current accuracy
			pWeapon.m_flCrosshairDistance = math.Approach(flAccuracy, pWeapon.m_flCrosshairDistance, cl_crosshair_approach_speed:GetFloat())
		end
		
		local iScale = cl_crosshair_scale:GetInt() * 2
		-- FIXME: Go over all of this DrawRect stuff
		surface.SetDrawColor(cl_crosshair_red:GetInt(), cl_crosshair_green:GetInt(), cl_crosshair_blue:GetInt(), cl_crosshair_alpha:GetInt())
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(x - iScale / 2, y - iScale / 2, iScale, iScale)
	end
	
	return true
end)
