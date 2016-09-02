local function ReturnFalse()
	return false
end

local tCrosshairs = {}

local function AddCrosshair( sName, func )
	tCrosshairs[sName] = func
end

-------------------------------Custom Crosshairs-------------------------------

local tColPreset = {
	[0] = { 50, 250, 50 },
	{ 250, 50, 50 },
	{ 50, 50, 250 },
	{ 250, 250, 50 },
	{ 50, 250, 250 }
}

local cl_crosshaircolor = CreateConVar( "cl_crosshaircolor", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_dynamiccrosshair = CreateConVar( "cl_dynamiccrosshair", "1", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_scalecrosshair = CreateConVar( "cl_scalecrosshair", "1", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_crosshairscale = CreateConVar( "cl_crosshairscale", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_crosshairalpha = CreateConVar( "cl_crosshairalpha", "200", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_crosshairusealpha = CreateConVar( "cl_crosshairusealpha", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })

AddCrosshair( "css", function( pWeapon, x, y )
	local pPlayer = pWeapon:GetOwner()
	local iDistance = pWeapon.CSSCrosshair.Min
	
	if ( cl_dynamiccrosshair:GetBool() ) then
		if ( not pPlayer:OnGround() ) then
			iDistance = iDistance * 2.0
		elseif ( pPlayer:Crouching() ) then
			iDistance = math.floor( iDistance * 0.5 )
		elseif ( pPlayer:_GetAbsVelocity():LengthSqr() > (pPlayer:GetWalkSpeed() * pWeapon.CSSCrosshair.Vel) ^ 2 ) then
			iDistance = math.floor( iDistance * 1.5 )
		end
	end
	
	local iShotsFired = pPlayer:GetShotsFired()
	
	if ( iShotsFired > pWeapon.m_iAmmoLastCheck ) then
		-- FIXME: Doesn't look right in-game
		local flNewDist = pWeapon.m_flCrosshairDistance + pWeapon.CSSCrosshair.Delta
		pWeapon.m_flCrosshairDistance = flNewDist > 15 and 15 or flNewDist
	elseif ( pWeapon.m_flCrosshairDistance > iDistance ) then
		pWeapon.m_flCrosshairDistance = pWeapon.m_flCrosshairDistance - (0.1 + pWeapon.m_flCrosshairDistance * 0.013)
	end
	
	if ( pWeapon.m_flCrosshairDistance < iDistance ) then
		pWeapon.m_flCrosshairDistance = iDistance
	end
	
	pWeapon.m_iAmmoLastCheck = iShotsFired
	
	//scale bar size to the resolution
	local flScale = 1
	
	if ( cl_scalecrosshair:GetBool() ) then
		flScale = cl_crosshairscale:GetInt()
		local iHeight = ScrH()
		
		if ( flScale < 1 ) then
			if ( iHeight <= 600 ) then
				flScale = iHeight / 600
			elseif ( iHeight <= 768 ) then
				flScale = iHeight / 768
			else
				flScale = iHeight / 1200
			end
		else
			flScale = iHeight / flScale
		end
	end
	
	local tCrosshairColor = cl_crosshaircolor:GetInt()
	
	if ( tCrosshairColor < 0 or tCrosshairColor > 4 ) then
		tCrosshairColor = tColPreset[0]
	else
		tCrosshairColor = tColPreset[tCrosshairColor]
	end
	
	local bUseAlpha = cl_crosshairusealpha:GetBool()
	
	local iCrosshairDistance = math.ceil( pWeapon.m_flCrosshairDistance * flScale )
	local iBarSize = math.floor( math.floor( ScreenScale(5) + (iCrosshairDistance - iDistance) / 2 ) * flScale )
	
	if ( iBarSize < 1 ) then
		iBarSize = 1
	end
	
	local iBarThickness = math.floor( flScale + 0.5 )
	
	if ( iBarThickness < 1 ) then
		iBarThickness = 1
	end
	
	local iSize = iCrosshairDistance + iBarSize
	local iThickness = iCrosshairDistance + iBarThickness
	
	if ( bUseAlpha ) then
		-- FIXME: Find CS:S texture
		local iAlpha = cl_crosshairalpha:GetInt()
		surface.SetDrawColor( tCrosshairColor[1], tCrosshairColor[2], tCrosshairColor[3], iAlpha < 0 and 0 or iAlpha > 255 and 255 or iAlpha )
		
		// Alpha-blended crosshair
		surface.DrawRect( x - iSize, y, iBarSize, iBarThickness )
		surface.DrawRect( x + iThickness, y, iBarSize, iBarThickness )
		surface.DrawRect( x, y - iSize, iBarThickness, iBarSize )
		surface.DrawRect( x, y + iThickness, iBarThickness, iBarSize )
	else
		draw.NoTexture()
		surface.SetDrawColor( tCrosshairColor[1], tCrosshairColor[2], tCrosshairColor[3], 200 )
		
		// Additive crosshair
		surface.DrawTexturedRect( x - iSize, y, iBarSize, iBarThickness )
		surface.DrawTexturedRect( x + iThickness, y, iBarSize, iBarThickness )
		surface.DrawTexturedRect( x, y - iSize, iBarThickness, iBarSize )
		surface.DrawTexturedRect( x, y + iThickness, iBarThickness, iBarSize )
	end

	return true
end )

local matArc = Material( "sprites/scope_arc" )
local matLens = Material( "overlays/scope_lens" )
local matScope = Material( "gmod/scope" )
local matScopeRef = Material( "gmod/scope-refract" )

AddCrosshair( "scope_css", function()
	local iWidth = ScrW()
	local iHeight = ScrH()
	local flHalfWidth = iWidth / 2
	local flHalfHeight = iHeight / 2
	local flWidthRad = iHeight / 3 * 4
	local flHalfWidthRad = flWidthRad / 2
	
	surface.SetMaterial( matLens )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, iWidth, iHeight )
	
	surface.SetMaterial( matScope )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( flHalfWidth - flHalfWidthRad, 0, flWidthRad, iHeight )
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, flHalfWidth - flHalfWidthRad, iHeight )
	surface.DrawRect( flHalfWidth + flHalfWidthRad, 0, iWidth - (flHalfWidth + flHalfWidthRad), iHeight )
	
	surface.DrawLine( 0, flHalfHeight, iWidth, flHalfHeight )
	surface.DrawLine( flHalfWidth, 0, flHalfWidth, iHeight )
	
	return true
end )

return function( sName )
	-- Fallback on engine crosshair
	return tCrosshairs[sName] or ReturnFalse
end
