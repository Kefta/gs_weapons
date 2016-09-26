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

do
	local Remove = function( pGrenade ) pGrenade:Remove() return true end
	local tDetonationTypes = {}
	
	function gsweapons.RegisterDetonationFunc( sName, func )
		tDetonationTypes[sName:lower()] = func
	end
	
	function gsweapons.GetDetonationFunc( sName )
		return tDetonationTypes[sName:lower()] or Remove
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
local flLastSpeed = 0

gsweapons.RegisterBobType( "hls", function( pWeapon, _, vOrigin, ang )
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

local vOffset = Vector(0, 0, 8)
local vRange = Vector(0, 0, -32)

local function ExplosionEffects( pGrenade )
	local vAbsOrigin = pGrenade:GetPos()
	local vSpot = vAbsOrigin + vOffset
	
	local tr = util.TraceLine({
		start = vSpot,
		endPos = vSpot + vRange,
		mask = MASK_SHOT_HULL,
		filter = pGrenade
	})
	
	if ( tr.StartSolid ) then
		// Since we blindly moved the explosion origin vertically, we may have inadvertently moved the explosion into a solid,
		// in which case nothing is going to be harmed by the grenade's explosion because all subsequent traces will startsolid.
		// If this is the case, we do the downward trace again from the actual origin of the grenade. (sjb) 3/8/2007  (for ep2_outland_09)
		util.TraceLine({
			start = vAbsOrigin,
			endPos = vAbsOrigin + vRange,
			mask = MASK_SHOT_HULL,
			filter = pGrenade,
			output = tr
		})
	end
	
	pGrenade:SetModelName( '\0' )
	pGrenade:AddSolidFlags( FSOLID_NOT_SOLID )
	pGrenade:SetSaveValue( "m_takedamage", 0 )
	
	if ( tr.Fraction ~= 1 ) then
		vAbsOrigin = tr.HitPos + tr.HitNormal * 0.6
		pGrenade:SetPos( vAbsOrigin )
	end
	
	local pOwner = pGrenade:GetOwner()
	local bInvalid = pOwner == NULL
	local flDamage = pGrenade.Damage
	
	if ( IsFirstTimePredicted() ) then
		local data = EffectData()
			data:SetOrigin( vAbsOrigin )
			data:SetMagnitude( flDamage )
			data:SetScale( pGrenade.DamageRadius * 0.03 )
			data:SetFlags( TE_EXPLFLAG_NOSOUND )
		util.Effect( "Explosion", data )
		
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	end
	
	pGrenade:PlaySound( "detonate" )
	
	local tShake = pGrenade.Shake
	local flAmplitude = tShake.Amplitude
	
	if ( flAmplitude ~= 0 ) then
		util.ScreenShake( vAbsOrigin, flAmplitude, tShake.Frequency, tShake.Duration, tShake.Radius )
	end
	
	if ( SERVER ) then
		local info = DamageInfo()
			info:SetAttacker( bInvalid and pGrenade or pOwner )
			info:SetDamage( flDamage )
			info:SetDamageForce( pGrenade.Force )
			info:SetDamagePosition( vAbsOrigin )
			info:SetDamageType( DMG_BLAST )
			info:SetInflictor( pGrenade )
			
			// Use the thrower's position as the reported position
			info:SetReportedPosition( bInvalid and vAbsOrigin or pOwner:GetPos() )
		
		return info
	end
end

gsweapons.RegisterDetonationFunc( "explode", function( pGrenade )
	if ( SERVER ) then
		local info = ExplosionEffects( pGrenade )
		util.RadiusDamage( info, info:GetDamagePosition(), pGrenade.DamageRadius, pGrenade ) -- FIXME
	else
		ExplosionEffects( pGrenade )
	end
			
	pGrenade:Remove()
	
	return true
end )

gsweapons.RegisterDetonationFunc( "explode_css", function( pGrenade )
	if ( SERVER ) then
		local info = ExplosionEffects( pGrenade )
		util.CSRadiusDamage( info, info:GetDamagePosition(), pGrenade.DamageRadius, pGrenade )
	else
		ExplosionEffects( pGrenade )
	end
			
	pGrenade:Remove()
	
	return true
end )

gsweapons.RegisterDetonationFunc( "smoke", function( pGrenade )
	if ( pGrenade:GetAbsVelocity():Length() > 0.1 ) then
		// Still moving. Don't detonate yet.
		return 0.2
	end
	
	// Ok, we've stopped rolling or whatever. Now detonate.
	local pSmoke = Smoke()
	pSmoke:SetPos( pGrenade:GetPos() )
	pSmoke:Spawn()
	pSmoke:FillVolume()
	pSmoke:SetFadeTime( 17, 22 ) -- Already the default values
	
	pGrenade.m_pSmokeEffect = pSmoke
	pGrenade.m_bDidSmokeEffect = true
	pGrenade:PlaySound( "main" )
	pGrenade:SetRenderMode( RENDERMODE_TRANSALPHA )
	pGrenade:SetNextThink( CurTime() + 5 )
	
	// Fade the projectile out over time before making it disappear
	pGrenade:AddEvent( "fade", 5, function()
		local col = pGrenade:GetColor()
		col.a = col.a - 1
		pGrenade:SetColor( col )
		
		if ( col.a <= 0 ) then
			//invisible
			pGrenade:SetModelName( '\0' )
			pGrenade:SetSolid( SOLID_NONE )
			
			-- We've hid the grenade, now wait for the smoke
			// Spit out smoke for 10 seconds.
			pGrenade:AddEvent( "remove", 20, function()
				if ( pGrenade.m_pSmokeEffect ~= NULL ) then
					pGrenade.m_pSmokeEffect:Remove()
				end
				
				pGrenade:Remove()
			end )
			
			return true
		end
		
		return 0
	end )
	
	return true
end )

local MASK_FLASHBANG = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER )

-- This one's a doozy; 7 traces, a point contents check, a FindInSphere loop, and a DynamicLight
gsweapons.RegisterDetonationFunc( "flash", function( pGrenade )
	local vSrc = pGrenade:GetPos()
	vSrc.z = vSrc.z + 1 // in case grenade is lying on the ground
	
	// iterate on all entities in the vicinity.
	local pEnts = ents.FindInSphere( vSrc, pGrenade:GetDamageRadius() )
	local bInWater = util.PointContents( vSrc ) == CONTENTS_WATER
	local vEyePos
	local pEntity
	local flAdjustedDamage
	local flDot
	local startingAlpha
	local fadeTime
	local fadeHold
	for i = 0, #pEnts do
		pEntity = pEnts[i]
		
		if ( not pEntity:IsPlayer() ) then return end
		
		vEyePos = pEntity:EyePos()
		
		// blasts don't travel into or out of water
		if ( bInWater and pEntity:WaterLevel() == 0 or 
			not bInWater and pEntity:WaterLevel() == 3 ) then
			continue
		end
		
		local percentageOfFlash = 0.0

		local tempAngle = ( vEyePos - vSrc ):Angle()
	
		local vRight = tempAngle:Right()
		local vUp = tempAngle:Up()

		local tr = util.TraceLine( {
			start = vSrc,
			endpos = vEyePos,
			mask = MASK_FLASHBANG,
			filter = pGrenade
		} )

		if ( tr.Fraction == 1.0 or tr.Entity == pEntity ) then
			percentageOfFlash = 1.0
		else
			// check the point straight up.
			tr = util.TraceLine( {
				start = vSrc,
				endpos = vSrc + vUp * 50,
				mask = MASK_FLASHBANG,
				filter = pGrenade
			} )
			
			tr = util.TraceLine( {
				start = tr.HitPos,
				endpos = vEyePos,
				mask = MASK_FLASHBANG,
				filter = pGrenade
			} )
			
			if ( tr.Fraction == 1.0 or tr.Entity == pEntity ) then
				percentageOfFlash = 0.167
			end
			
			// check the point up and right
			tr = util.TraceLine( {
				start = vSrc,
				endpos = flashPos + vRight * 75 + vUp * 10,
				mask = MASK_FLASHBANG,
				filter = pGrenade
			} )
			
			tr = util.TraceLine( {
				start = tr.HitPos,
				endpos = vEyePos,
				mask = MASK_FLASHBANG,
				filter = pGrenade
			} )
			
			if ( tr.Fraction == 1.0 or tr.Entity == pEntity ) then
				percentageOfFlash = percentageOfFlash + 0.167
			end
			
			tr = util.TraceLine( {
				start = vSrc,
				endpos = flashPos - vRight * 75 + vUp * 10,
				mask = MASK_FLASHBANG,
				filter = pGrenade
			} )
			
			tr = util.TraceLine( {
				start = tr.HitPos,
				endpos = vEyePos,
				mask = MASK_FLASHBANG,
				filter = pGrenade
			} )
			
			if ( tr.Fraction == 1.0 or tr.Entity == pEntity ) then
				percentageOfFlash = percentageOfFlash + 0.167
			end
		end
		
		if ( percentageOfFlash > 0.0 ) then
			// decrease damage for an ent that's farther from the grenade
			flAdjustedDamage = pGrenade:GetDamage() - ( vSrc - vEyePos ):Length() * (pGrenade:GetDamage()/pGrenade:GetDamageRadius())
			
			if ( flAdjustedDamage > 0 ) then
				// See if we were facing the flash
				// Normalize both vectors so the dotproduct is in the range -1.0 <= x <= 1.0 
				local vFaceDir = vSrc - vEyePos
				local flDot = vFaceDir:GetNormal():Dot( pEntity:GetAimVector() )

				startingAlpha = 255
	
				// if target is facing the bomb, the effect lasts longer
				if( flDot >= 0.5 ) then
					// looking at the flashba
					fadeTime = flAdjustedDamage * 2.5
					fadeHold = flAdjustedDamage * 1.25
				elseif( flDot >= -0.5 ) then
					// looking to the side
					fadeTime = flAdjustedDamage * 1.75
					fadeHold = flAdjustedDamage * 0.8
				else
					// facing away
					fadeTime = flAdjustedDamage * 1.0
					fadeHold = flAdjustedDamage * 0.75
					startingAlpha = 200
				end

				// blind players and bots
				pEntity:Blind( fadeHold * percentageOfFlash, fadeTime * percentageOfFlash, startingAlpha )

				// deafen players and bots
				pEntity:Deafen( vFaceDir:Length() )
			end
		end
	end
	
	local dlight = DynamicLight( pGrenade:EntIndex() )
	dlight.pos = vSrc
	dlight.r = 255
	dlight.g = 255
	dlight.b = 255
	dlight.brightness = 2
	dlight.size = 400
	dlight.dietime = CurTime() + 0.1
	dlight.decay = 768
	
	pGrenade:PlaySound( "main" )
	pGrenade:Remove()
	
	return true
end )
