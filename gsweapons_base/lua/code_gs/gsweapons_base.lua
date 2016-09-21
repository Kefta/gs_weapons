gsweapons = {}
local Empty = function() end
local ReturnTrue = function() return true end

do
	local tHoldTypes = {}
	
	function gsweapons.RegisterHoldType( sName, tActTable )
		tHoldTypes[sName:lower()] = tActTable
	end
	
	function gsweapons.GetHoldType( sName )
		local tHoldType = tHoldTypes[sName:lower()]
		
		if ( tHoldType ) then
			return tHoldType
		end
		
		DevMsg( 2, string.format( "[GSWeapons] (GetHoldType) HoldType %q not found. Sending back table for 'normal'." ))
		
		return tHoldTypes["normal"] or {}
	end
end

do
	local Default = function( _, _, _, _, vNewPos, aNew ) return vNewPos, aNew end
	local Disable = function( _, _, vPos, ang ) return vPos, ang end
	local tBobTypes = {}
	
	function gsweapons.RegisterBobType( sName, func )
		tBobTypes[sName:lower()] = func
	end
	
	function gsweapons.GetBobType( sName )
		if ( sName == "" ) then
			return Disable
		end
		
		return tBobTypes[sName:lower()] or Default
	end
end

do
	local Empty = Empty
	local ReturnTrue = ReturnTrue
	local tCrosshairTypes = {}
	
	function gsweapons.RegisterCrosshair( sName, func )
		tCrosshairTypes[sName:lower()] = func
	end
	
	function gsweapons.GetCrosshair( sName )
		if ( sName == "" ) then
			return ReturnTrue
		end
		
		return tCrosshairTypes[sName:lower()] or Empty
	end
end

do
	local Empty = Empty
	local ReturnTrue = ReturnTrue
	local tScopeTypes = {}
	
	function gsweapons.RegisterScope( sName, func )
		tScopeTypes[sName:lower()] = func
	end
	
	function gsweapons.GetScope( sName )
		if ( sName == "" ) then
			return ReturnTrue
		end
		
		return tScopeTypes[sName:lower()] or Empty
	end
end

do
	local Empty = Empty
	local ReturnTrue = ReturnTrue
	local tAnimEvents = {}

	function gsweapons.RegisterAnimEvent( Events, sName, func )	
		if ( isnumber( Events )) then
			local tEvent = tAnimEvents[Events]
			
			if ( not tEvent ) then
				tEvent = {}
				tAnimEvents[Events] = tEvent
			end
			
			tEvent[sName:lower()] = func
		else
			for i = 1, #Events do
				local iEvent = Events[i]
				local tEvent = tAnimEvents[iEvent]
				
				if ( not tEvent ) then
					tEvent = {}
					tAnimEvents[iEvent] = tEvent
				end
				
				tEvent[sName:lower()] = func
			end
		end
	end

	function gsweapons.GetAnimEvent( iEvent, sName )
		if ( sName == "" ) then
			return ReturnTrue
		end
		
		local tEvent = tAnimEvents[iEvent]
		
		if ( tEvent ) then
			return tEvent[sName:lower()] or Empty
		end
		
		return Empty
	end
end

local function RegisterDefaultHoldType( sName, iStartIndex )
	gsweapons.RegisterHoldType( sName, {
		[ACT_MP_STAND_IDLE] = iStartIndex,
		[ACT_MP_WALK] = iStartIndex + 1,
		[ACT_MP_RUN] = iStartIndex + 2,
		[ACT_MP_CROUCH_IDLE] = iStartIndex + 3,
		[ACT_MP_CROUCHWALK] = iStartIndex + 4,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = iStartIndex + 5,
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = iStartIndex + 5,
		[ACT_MP_RELOAD_STAND] = iStartIndex + 6,
		[ACT_MP_RELOAD_CROUCH] = iStartIndex + 6,
		[ACT_MP_JUMP] = iStartIndex == ACT_HL2MP_IDLE and ACT_HL2MP_JUMP_SLAM or iStartIndex + 7,
		[ACT_RANGE_ATTACK1] = iStartIndex + 8,
		[ACT_MP_SWIM] = iStartIndex + 9
	})
end

RegisterDefaultHoldType( "pistol", ACT_HL2MP_IDLE_PISTOL )
RegisterDefaultHoldType( "smg", ACT_HL2MP_IDLE_SMG1 )
RegisterDefaultHoldType( "grenade", ACT_HL2MP_IDLE_GRENADE )
RegisterDefaultHoldType( "ar2", ACT_HL2MP_IDLE_AR2 )
RegisterDefaultHoldType( "shotgun", ACT_HL2MP_IDLE_SHOTGUN )
RegisterDefaultHoldType( "rpg", ACT_HL2MP_IDLE_RPG )
RegisterDefaultHoldType( "physgun", ACT_HL2MP_IDLE_PHYSGUN )
RegisterDefaultHoldType( "crossbow", ACT_HL2MP_IDLE_CROSSBOW )
RegisterDefaultHoldType( "melee", ACT_HL2MP_IDLE_MELEE )
RegisterDefaultHoldType( "slam", ACT_HL2MP_IDLE_SLAM )
RegisterDefaultHoldType( "normal", ACT_HL2MP_IDLE )
RegisterDefaultHoldType( "fist", ACT_HL2MP_IDLE_FIST )
RegisterDefaultHoldType( "melee2", ACT_HL2MP_IDLE_MELEE2 )
RegisterDefaultHoldType( "passive", ACT_HL2MP_IDLE_PASSIVE )
RegisterDefaultHoldType( "knife", ACT_HL2MP_IDLE_KNIFE )
RegisterDefaultHoldType( "duel", ACT_HL2MP_IDLE_DUEL )
RegisterDefaultHoldType( "camera", ACT_HL2MP_IDLE_CAMERA )
RegisterDefaultHoldType( "magic", ACT_HL2MP_IDLE_MAGIC )
RegisterDefaultHoldType( "revolver", ACT_HL2MP_IDLE_REVOLVER )

local pi = math.pi
local flLateral = 0
local flVertical = 0
local flBobTime = 0
local flLastBob = 0

gsweapons.RegisterBobType( "hl", function( pWeapon, _, vOrigin, ang )
	local pPlayer = pWeapon:GetOwner()
	local flBobCycle = pWeapon.BobScale
	local flBobUp = pWeapon.SwayScale
	
	if ( flBobCycle and flBobUp and flBobCycle > 0 and flBobUp > 0 and flBobUp ~= 1 and FrameTime() ~= 0 ) then
		local flCurTime = CurTime()
		local flBobSpeed = pWeapon.BobSpeed * pPlayer:GetWalkSpeed()
		local flSpeed = math.Clamp( pPlayer:_GetLocalVelocity():Length2D(), -flBobSpeed, flBobSpeed )
		flBobTime = flBobTime + (flCurTime - flLastBob) * (flSpeed / flBobSpeed)
		flLastBob = flCurTime
		local flTimeByCycle = flBobTime/flBobCycle
		local flCycle = (flBobTime - math.floor( flTimeByCycle ) * flBobCycle) / flBobCycle
		local flInvBobUp = 1 - flBobUp
		local flCycleDiff = flCycle - flBobUp
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flSpeed = flSpeed * 0.005
		flVertical = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )
		
		local flDoubleCycle = flBobCycle * 2
		flCycle = (flBobTime - math.floor( flTimeByCycle * 2 ) * flDoubleCycle) / flDoubleCycle
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flLateral = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )
	end
	
	// Apply bob, but scaled down to 40%
	-- Really 10%
	vOrigin = vOrigin + ang:Forward() * flVertical * 0.1

	// Z bob a bit more
	vOrigin.z = vOrigin.z + flVertical * 0.1
	
	// bob the angles
	ang.r = ang.r + flVertical * 0.5
	ang.p = ang.p - flVertical * 0.4
	ang.y = ang.y - flLateral * 0.3
	
	vOrigin = vOrigin + ang:Right() * flLateral * 0.8
	
	return vOrigin, ang
end )

local flLateral = 0
local flVertical = 0
local flBobTime = 0
local flLastBob = 0

gsweapons.RegisterBobType( "hl2", function( pWeapon, _, vOrigin, ang )
	local pPlayer = pWeapon:GetOwner()
	
	//NOTENOTE: For now, let this cycle continue when in the air, because it snaps badly without it
	local flBobCycle = pWeapon.BobScale
	local flBobUp = pWeapon.SwayScale
	
	if ( flBobCycle and flBobUp and flBobCycle > 0 and flBobUp > 0 and flBobUp ~= 1 and FrameTime() ~= 0 ) then
		// Find the speed of the player
		local flCurTime = CurTime()
		local flBobSpeed = pWeapon.BobSpeed * pPlayer:GetWalkSpeed()
		
		// don't allow too big speed changes
		local flSpeed = math.Clamp( pPlayer:_GetLocalVelocity():Length2D(), -flBobSpeed, flBobSpeed )
		flBobTime = flBobTime + (flCurTime - flLastBob) * (flSpeed / flBobSpeed)
		flLastBob = flCurTime
		
		//FIXME: This maximum speed value must come from the server.
		//		 MaxSpeed() is not sufficient for dealing with sprinting - jdw
		
		// Calculate the vertical bob
		local flTimeByCycle = flBobTime/flBobCycle
		local flCycle = (flBobTime - math.floor( flTimeByCycle ) * flBobCycle) / flBobCycle
		local flInvBobUp = 1 - flBobUp
		local flCycleDiff = flCycle - flBobUp
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flSpeed = flSpeed * 0.005
		flVertical = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )

		// Calculate the lateral bob
		local flDoubleCycle = flBobCycle * 2
		flCycle = (flBobTime - math.floor( flTimeByCycle * 2 ) * flDoubleCycle) / flDoubleCycle
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flLateral = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )
	end
	
	// Apply bob, but scaled down to 40%
	-- Really 10%
	vOrigin = vOrigin + ang:Forward() * flVertical * 0.1

	// Z bob a bit more
	vOrigin.z = vOrigin.z + flVertical * 0.1
	
	// bob the angles
	ang.r = ang.r + flVertical * 0.5
	ang.p = ang.p - flVertical * 0.4
	ang.y = ang.y - flLateral * 0.3
	
	vOrigin = vOrigin + ang:Right() * flLateral * 0.8
	
	return vOrigin, ang
end )

local flLateral = 0
local flVertical = 0
local flBobTime = 0
local flLastBob = 0
local flLastSpeed = 0

gsweapons.RegisterBobType( "css", function( pWeapon, _, vOrigin, ang )
	local pPlayer = pWeapon:GetOwner()
	
	//NOTENOTE: For now, let this cycle continue when in the air, because it snaps badly without it
	local flBobCycle = pWeapon.BobScale
	local flBobUp = pWeapon.SwayScale
	
	if ( flBobCycle and flBobUp and flBobCycle > 0 and flBobUp > 0 and flBobUp ~= 1 and FrameTime() ~= 0 ) then
		// Find the speed of the player
		local flCurTime = CurTime()
		local flBobSpeed = pWeapon.BobSpeed * pPlayer:GetWalkSpeed()
		
		// don't allow too big speed changes
		local flDelta = math.max( 0, (flCurTime - flLastBob) * flBobSpeed )
		local flSpeed = math.Clamp( math.Clamp( pPlayer:_GetLocalVelocity():Length2D(), flLastSpeed - flDelta, flLastSpeed + flDelta ), -flBobSpeed, flBobSpeed )
		flLastSpeed = flSpeed
		flBobTime = flBobTime + (flCurTime - flLastBob) * (flSpeed / flBobSpeed)
		flLastBob = flCurTime
		
		//FIXME: This maximum speed value must come from the server.
		//		 MaxSpeed() is not sufficient for dealing with sprinting - jdw
		
		//Calculate the vertical bob
		local flTimeByCycle = flBobTime/flBobCycle
		local flCycle = (flBobTime - math.floor( flTimeByCycle ) * flBobCycle) / flBobCycle
		local flInvBobUp = 1 - flBobUp
		local flCycleDiff = flCycle - flBobUp
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flSpeed = flSpeed * 0.005
		flVertical = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )

		// Calculate the lateral bob
		local flDoubleCycle = flBobCycle * 2
		flCycle = (flBobTime - math.floor( flTimeByCycle * 2 ) * flDoubleCycle) / flDoubleCycle
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flLateral = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )
	end
	
	// Apply bob, but scaled down to 40%
	vOrigin = vOrigin + ang:Forward() * flVertical * 0.4

	// Z bob a bit more
	vOrigin.z = vOrigin.z + flVertical * 0.1
	
	// bob the angles
	ang.r = ang.r + flVertical * 0.5
	ang.p = ang.p - flVertical * 0.4
	ang.y = ang.y - flLateral * 0.3
	
	--vOrigin = vOrigin + ang:Right() * flLateral * 0.8
	
	return vOrigin, ang
end )

local flLateral = 0
local flVertical = 0
local flBobTime = 0
local flLastBob = 0
local flLastSpeed = 0

gsweapons.RegisterBobType( "dod", function( pWeapon, _, vOrigin, ang )
	local pPlayer = pWeapon:GetOwner()
	
	//NOTENOTE: For now, let this cycle continue when in the air, because it snaps badly without it
	local flBobCycle = pWeapon.BobScale
	local flBobUp = pWeapon.SwayScale
	
	if ( flBobCycle and flBobUp and flBobCycle > 0 and flBobUp > 0 and flBobUp ~= 1 and FrameTime() ~= 0 ) then
		// Find the speed of the player
		local flCurTime = CurTime()
		local flBobSpeed = pWeapon.BobSpeed * pPlayer:GetWalkSpeed()
		
		// don't allow too big speed changes
		local flDelta = math.max( 0, (flCurTime - flLastBob) * flBobSpeed )
		local flSpeed = math.Clamp( pPlayer:_GetLocalVelocity():Length2D(), flLastSpeed - flDelta, flLastSpeed + flDelta )
		flLastSpeed = flSpeed
		flBobTime = flBobTime + (flCurTime - flLastBob) * (flSpeed / flBobSpeed)
		flLastBob = flCurTime
		
		//FIXME: This maximum speed value must come from the server.
		//		 MaxSpeed() is not sufficient for dealing with sprinting - jdw
		
		//Calculate the vertical bob
		local flTimeByCycle = flBobTime/flBobCycle
		local flCycle = (flBobTime - math.floor( flTimeByCycle ) * flBobCycle) / flBobCycle
		local flInvBobUp = 1 - flBobUp
		local flCycleDiff = flCycle - flBobUp
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flSpeed = flSpeed * 0.005
		flVertical = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )

		// Calculate the lateral bob
		local flDoubleCycle = flBobCycle * 2
		flCycle = (flBobTime - math.floor( flTimeByCycle * 2 ) * flDoubleCycle) / flDoubleCycle
		
		if ( flCycle < flBobUp ) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flLateral = math.Clamp( flSpeed * 0.3 + flSpeed * 0.7 * math.sin( flCycle ), -7, 4 )
	end
	
	// Apply bob, but scaled down to 40%
	vOrigin = vOrigin + ang:Forward() * flVertical * 0.4

	// Z bob a bit more
	vOrigin.z = vOrigin.z + flVertical * 0.1
	
	// bob the angles
	ang.r = ang.r + flVertical * 0.5
	ang.p = ang.p - flVertical * 0.4
	ang.y = ang.y - flLateral * 0.3
	
	--vOrigin = vOrigin + ang:Right() * flLateral * 0.8
	
	return vOrigin, ang
end )

local tColPreset = {
	[0] = {50, 250, 50},
	{250, 50, 50},
	{50, 50, 250},
	{250, 250, 50},
	{50, 250, 250}
}

local cl_crosshaircolor = CreateConVar( "cl_crosshaircolor", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_dynamiccrosshair = CreateConVar( "cl_dynamiccrosshair", "1", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_scalecrosshair = CreateConVar( "cl_scalecrosshair", "1", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_crosshairscale = CreateConVar( "cl_crosshairscale", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_crosshairalpha = CreateConVar( "cl_crosshairalpha", "200", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
local cl_crosshairusealpha = CreateConVar( "cl_crosshairusealpha", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })

gsweapons.RegisterCrosshair( "css", function( pWeapon, x, y )
	local pPlayer = pWeapon:GetOwner()
	local iDistance = pWeapon.CSSCrosshair.Min
	
	if ( cl_dynamiccrosshair:GetBool() ) then
		if ( not pPlayer:OnGround() ) then
			iDistance = iDistance * 2
		elseif ( pPlayer:Crouching() ) then
			iDistance = math.floor( iDistance * 0.5 )
		elseif ( pPlayer:_GetAbsVelocity():LengthSqr() > (pPlayer:GetWalkSpeed() * pWeapon.CSSCrosshair.Vel) ^ 2 ) then
			iDistance = math.floor( iDistance * 1.5 )
		end
	end
	
	local iShotsFired = pWeapon:GetShotsFired()
	
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
	local flScale
	
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
	else
		flScale = 1
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

gsweapons.RegisterScope( "css", function()
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

gsweapons.RegisterAnimEvent( {5001, 5011, 5021, 5031}, "css", function( pWeapon, _, _, iEvent )
	if ( not pWeapon:Silenced() ) then
		local pPlayer = pWeapon:GetOwner()
		
		if ( pPlayer == NULL ) then
			return true
		end
		
		local pViewModel = pPlayer:GetViewModel()
		
		if ( pViewModel == NULL ) then
			return true
		end
		
		local data = EffectData()
			data:SetEntity( pViewModel )
			data:SetAttachment( pWeapon:GetMuzzleAttachment( iEvent ))
			data:SetScale( pWeapon:GetMuzzleFlashScale() )
		util.Effect( "CS_MuzzleFlash", data )
	end
	
	return true
end )

gsweapons.RegisterAnimEvent( {5001, 5011, 5021, 5031}, "css_x", function( pWeapon, _, _, iEvent )
	if ( not pWeapon:Silenced() ) then
		local pPlayer = pWeapon:GetOwner()
		
		if ( pPlayer == NULL ) then
			return true
		end
		
		local pViewModel = pPlayer:GetViewModel()
		
		if ( pViewModel == NULL ) then
			return true
		end
		
		local data = EffectData()
			data:SetEntity( pViewModel )
			data:SetAttachment( pWeapon:GetMuzzleAttachment( iEvent ))
			data:SetScale( pWeapon:GetMuzzleFlashScale() )
		util.Effect( "CS_MuzzleFlash_X", data )
	end
	
	return true
end )

gsweapons.RegisterAnimEvent( {5003, 5013, 5023, 5033}, "css", function( pWeapon, _, _, iEvent )
	if ( not pWeapon:Silenced() ) then
		local pPlayer = pWeapon:GetOwner()
		
		if ( pPlayer == NULL ) then
			return true
		end
		
		local light = DynamicLight( 0x40000000 + pPlayer:EntIndex() )
		light.pos = pWeapon:GetAttachment( pWeapon:GetMuzzleAttachment( iEvent )).Pos
		light.size = 70
		light.decay = 1400 --light.size / 0.05
		light.dietime = CurTime() + 0.05
		light.r = 255
		light.g = 192
		light.b = 64
		light.style = 5
	end
	
	return true
end )

local cl_ejectbrass = GetConVar( "cl_ejectbrass" )
local sSep = " "
local cRep = string.char( 173 )

gsweapons.RegisterAnimEvent( 20, "css", function( pWeapon, _, _, _, sOptions )
	if ( not cl_ejectbrass:GetBool() ) then
		return true
	end
	
	local pPlayer = pWeapon:GetOwner()
	
	if ( pPlayer == NULL ) then
		return true
	end
	
	local aEyes = pPlayer:EyeAngles()
	local tOptions = sSep:Explode( sOptions )
	local sEffect = tOptions[1]
	
	if ( sEffect ) then
		-- https://github.com/Facepunch/garrysmod-issues/issues/2789
		local iReplace = sEffect:find( cRep, 1, true )
		
		if ( iReplace ) then
			sEffect = sEffect:SetChar( iReplace, "_" )
		end
	else
		sEffect = "EjectBrass_9mm"
	end
	
	local data = EffectData()
		data:SetOrigin( pWeapon:GetAttachment( tOptions[2] and tonumber( tOptions[2] ) or pWeapon:GetMuzzleAttachment() ).Pos )
		data:SetAngles( (aEyes:Right() * 100 + aEyes:Up() * 20):Angle() )
		data:SetFlags( tOptions[3] and tonumber( tOptions[3] ) or 120 ) -- Velocity
	util.Effect( sEffect, data )
	
	return true
end )
