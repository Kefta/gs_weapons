local function Remove( self )
	self:Remove()
end

local tDetonationTypes = {}

local function AddDetonateType( sName, func )
	tDetonationTypes[sName:lower()] = func
end

-------------------------------Custom Detonation Types-------------------------------

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
	
	pGrenade:SetModelName('\0')
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

AddDetonateType( "Explode", function( pGrenade )
	if ( SERVER ) then
		local info = ExplosionEffects( pGrenade )
		util.RadiusDamage( info, info:GetDamagePosition(), pGrenade.DamageRadius, pGrenade )
	else
		ExplosionEffects( pGrenade )
	end
			
	pGrenade:Remove()
end )

AddDetonateType( "explode_css", function( pGrenade )
	if ( SERVER ) then
		local info = ExplosionEffects( pGrenade )
		util.CSRadiusDamage( info, info:GetDamagePosition(), pGrenade.DamageRadius, pGrenade )
	else
		ExplosionEffects( pGrenade )
	end
			
	pGrenade:Remove()
end )

AddDetonateType( "Explode_HL", function( pGrenade )
	local info = ExplosionEffects( pGrenade )
	
	if ( SERVER ) then
		local info = ExplosionEffects( pGrenade )
		util.CSRadiusDamage( info, info:GetDamagePosition(), pGrenade.DamageRadius, pGrenade )
	else
		ExplosionEffects( pGrenade )
	end
			
	pGrenade:Remove()
end )

-- FIX: add ammo lang strings
AddDetonateType( "smoke", function( pGrenade )
	if ( pGrenade:GetAbsVelocity():Length() > 0.1 ) then
		// Still moving. Don't detonate yet.
		pGrenade:SetNextThink( CurTime() + 0.2 )
		return
	end
	
	// Ok, we've stopped rolling or whatever. Now detonate.
	local pGren = SmokeParticle()
	if ( pGren ~= NULL ) then
		pGren:SetLocalPos( pGrenade:GetPos() ) -- Fix?
		pGren:SetLocalAngles( angle_zero )
		pGren:Spawn()
		pGren:FillVolume()
		-- pGren:SetFadeTime( 17, 22 ) -- Already the default values
		pGren:SetPos( pGrenade:GetPos() ) -- Fix??????
	end
	
	pGrenade.m_pSmokeEffect = pGren
	pGrenade.m_bDidSmokeEffect = true
	
	pGrenade:PlaySound( "main" )
	
	pGrenade:SetRenderMode( RENDERMODE_TRANSALPHA )
	pGrenade:SetNextThink( CurTime() + 5 )
	// Fade the projectile out over time before making it disappear
	pGrenade:SetThinkFunction( function( pGrenade ) -- Fade -- Fix this PLEASESESAEASE; what are we trying to do here?
		local c = pGrenade:GetColor()
		c.a = c.a - 1
		pGrenade:SetColor( c )
		
		if ( c.a <= 0 ) then
			pGrenade:SetSolid( SOLID_NONE )
			-- We've hid the grenade, now wait for the smoke
			pGrenade:AddContextThink( function()
				if ( pGrenade.m_pSmokeEffect ~= NULL ) then
					pGrenade.m_pSmokeEffect:Remove()
				end
				
				pGrenade:Remove()
			end, 20 )
		end
	end )
end )

local MASK_FLASHBANG = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER )

-- This one's a doozy; 7 traces, a point contents check, a FindInSphere loop, and a DynamicLight
AddDetonateType( "flash", function( pGrenade )
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
end )

return function( sName )
	return tDetonationTypes[sName:lower()] or Remove
end
