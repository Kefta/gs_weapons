if ( SERVER ) then
	local fSetSkillLevel = game.SetSkillLevel

	function game.SetSkillLevel( iLevel )
		game.UpdateSkillConVars( iLevel )
		fSetSkillLevel( iLevel )
	end

	local tSkillConVars = {}

	function game.RegisterSkillConVar( sConVar, tVals )
		tSkillConVars[sConVar] = tVals
	end

	function game.UpdateSkillConVars( iLevel )
		for sVar, tVal in pairs( tSkillConVars ) do
			local Val = tVal[iLevel]
			
			while ( Val == nil and iLevel ~= 0 ) do
				iLevel = iLevel - 1
				Val = tVal[iLevel]
			end
			
			RunConsoleCommand( sVar, tostring( Val ))
		end
	end

	hook.Add( "InitPostEntity", "GSLib-Update skill convars", function()
		game.UpdateSkillConVars( game.GetSkillLevel() )
	end )
end

local ENTITY = FindMetaTable( "Entity" )
local PLAYER = FindMetaTable( "Player" )
local WEAPON = FindMetaTable( "Weapon" )
local ANGLE = FindMetaTable( "Angle" )
local VECTOR = FindMetaTable( "Vector" )
local PHYSOBJ = FindMetaTable( "PhysObj" )

FLT_EPSILON = 1.19209290e-07
DEBUG_LENGTH = 3

--- BasePlayer
-- Equivalent of CBasePlayer::EyeVectors() before AngleVecotrs
function PLAYER:ActualEyeAngles()
	local pVehicle = self:GetVehicle()
	
	if ( CLIENT or pVehicle == NULL ) then
		return self:EyeAngles()
	end
	
	// Cache or retrieve our calculated position in the vehicle
	-- https://github.com/Facepunch/garrysmod-requests/issues/782
	local iFrameCount = FrameNumber and FrameNumber() or CurTime()

	// If we've calculated the view this frame, then there's no need to recalculate it
	if ( self.m_iVehicleViewSavedFrame ~= iFrameCount ) then
		self.m_iVehicleViewSavedFrame = iFrameCount
		
		// Get our view for this frame
		-- https://github.com/Facepunch/garrysmod-requests/issues/760
		local _, ang = pVehicle:GetVehicleViewPosition(1)
		self.m_aVehicleViewAngles = ang
	end
	
	return self.m_aVehicleViewAngles
end

local vPlayerOffset = Vector(0, 0, -4)

function PLAYER:ComputeTracerStartPosition( vSrc )
	// adjust tracer position for player
	local aEyes = self:ActualEyeAngles()
	
	return vSrc + vPlayerOffset + aEyes:Right() * 2 + aEyes:Forward() * 16
end

--- GameRules
-- bIgnoreCategory: Switch to weapon based purely on weight, and not the same category
-- bCritical: Emergency! Allow us to switch to a weapon with no ammo or NULL
function PLAYER:GetNextBestWeapon( bIgnoreCategory, bCritical )
	-- Why use a gamerules function for this when we can just do it here?
	-- This is a mix of the multiplay/singleplay algorithms
	local pCurrent = self:GetActiveWeapon()
	local pBestWep
	local pFallbackWep
	
	//Search for the best weapon to use next based on its weight
	for _, pCheck in pairs( self:GetWeapons() ) do -- Discontinous table
		// If we have an active weapon and this weapon doesn't allow autoswitching away
		// from another weapon, skip it.
		if ( pCheck:AllowsAutoSwitchTo() and pCheck ~= pCurrent ) then
			if ( pCheck:HasAmmo() ) then
				local iWeight = pCheck:GetWeight()
		
				if ( not bIgnoreCategory and iWeight == pCurrent:GetWeight() ) then
					return pCheck -- We found a perfect match
				end
		
				if ( not pBestWep or iWeight > pBestWep:GetWeight() ) then
					pBestWep = pCheck
				end
			else
				-- If it's an emergency, have a backup regardless of ammo
				if ( bCritical and not pFallbackWep ) then
					pFallbackWep = pCheck
				end
			end
		end
	end
	
	-- If the weapon is going to be removed, do not re-deploy
	return pBestWep or pFallbackWep or (bCritical and NULL or pCurrent)
end

function PLAYER:MouseLifted()
	return not (self:KeyDown( IN_ATTACK ) or self:KeyDown( IN_ATTACK2 ))
end

FIRE_BULLETS_FIRST_SHOT_ACCURATE = 0x1 // Pop the first shot with perfect accuracy
FIRE_BULLETS_DONT_HIT_UNDERWATER = 0x2 // If the shot hits its target underwater, don't damage it
FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS = 0x4 // If the shot hits water surface, still call DoImpactEffect
-- The engine alerts NPCs by pushing a sound onto a static sound manager
-- However, this cannot be accessed from the Lua state
--FIRE_BULLETS_TEMPORARY_DANGER_SOUND = 0x8 // Danger sounds added from this impact can be stomped immediately if another is queued

local ai_debug_shoot_positions = GetConVar( "ai_debug_shoot_positions" )
local phys_pushscale = GetConVar( "phys_pushscale" )
local sv_showimpacts = CreateConVar( "sv_showimpacts", "0", FCVAR_REPLICATED, "Shows client (red) and server (blue) bullet impact point (1=both, 2=client-only, 3=server-only)" )
local sv_showpenetration = CreateConVar( "sv_showpenetration", "0", FCVAR_REPLICATED, "Shows penetration trace (if applicable) when the weapon fires" )
local sv_showplayerhitboxes = CreateConVar( "sv_showplayerhitboxes", "0", FCVAR_REPLICATED, "Show lag compensated hitboxes for the specified player index whenever a player fires." )

local vDefaultMax = Vector(3, 3, 3)
local vDefaultMin = -vDefaultMax

local nWhizTracer = bit.bor( 0x0002, 0x0001 )
local iTracerCount = 0 -- Instance global to interact with FireBullets functions

-- Player only as NPCs could not be overrided to use this function
function PLAYER:FireLuaBullets( bullets )
	if ( hook.Run( "EntityFireBullets", self, bullets ) == false ) then
		return
	end
	
	self:LagCompensation( true )
	
	local pWeapon = self:GetActiveWeapon()
	local bWeaponInvalid = pWeapon == NULL
	
	-- FireBullets info
	local sAmmoType
	local iAmmoType
	
	if ( not bullets.AmmoType ) then
		sAmmoType = ""
		iAmmoType = -1
	elseif ( isstring( bullets.AmmoType )) then
		sAmmoType = bullets.AmmoType
		iAmmoType = game.GetAmmoID( sAmmoType )
	else
		iAmmoType = bullets.AmmoType
		sAmmoType = game.GetAmmoName( iAmmoType )
	end
	
	local pAttacker = bullets.Attacker and bullets.Attacker ~= NULL and bullets.Attacker or self
	local fCallback = bullets.Callback
	local iDamage = bullets.Damage or 1
	local vDir = bullets.Dir:GetNormal() or self:GetAimVector()
	local flDistance = bullets.Distance or MAX_TRACE_LENGTH
	local Filter = bullets.Filter or self
	local iFlags = bullets.Flags or 0
	local flForce = bullets.Force or 1
	local pInflictor = bullets.Inflictor and bullets.Inflictor ~= NULL and bullets.Inflictor or bWeaponInvalid and self or pWeapon
	local iMask = bullets.Mask or MASK_SHOT
	local iNPCDamage = bullets.NPCDamage or 0
	local iNum = bullets.Num or 1
	local iPlayerDamage = bullets.PlayerDamage or 0
	local vSrc = bullets.Src or self:GetShootPos()
	local iTracerFreq = bullets.Tracer or 1
	local sTracerName = bullets.TracerName or "Tracer"
	
	-- Ammo
	local iAmmoFlags = game.GetAmmoFlags( sAmmoType )
	local flAmmoForce = game.GetAmmoForce( sAmmoType )
	local iAmmoDamageType = game.GetAmmoDamageType( sAmmoType )
	local iAmmoPlayerDamage = game.GetAmmoPlayerDamage( sAmmoType )
	local iAmmoMinSplash = game.GetAmmoMinSplash( sAmmoType )
	local iAmmoMaxSplash = game.GetAmmoMaxSplash( sAmmoType )
	local iAmmoTracerType = game.GetAmmoTracerType( sAmmoType )
	
	if ( bit.band( iAmmoFlags, AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER ) ~= 0 ) then
		if ( iPlayerDamage == 0 ) then
			iPlayerDamage = iAmmoPlayerDamage
		end
		
		if ( iNPCDamage == 0 ) then
			iNPCDamage = game.GetAmmoNPCDamage( sAmmoType )
		end
	end
	
	-- Loop values
	local bDrop = bit.band( iAmmoFlags, AMMO_FORCE_DROP_IF_CARRIED ) ~= 0
	local bDebugShoot = ai_debug_shoot_positions:GetBool()
	local bFirstShotInaccurate = bit.band( iFlags, FIRE_BULLETS_FIRST_SHOT_ACCURATE ) == 0
	local flPhysPush = phys_pushscale:GetFloat()
	local bShowPenetration = sv_showpenetration:GetBool()
	local bStartedInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
	local bFirstTimePredicted = IsFirstTimePredicted()
	local flSpreadBias, flFlatness, flSpreadX, flSpreadY, bNegBias, vFireBulletMax, vFireBulletMin, vSpreadRight, vSpreadUp
	
	// Wrap it for network traffic so it's the same between client and server
	local iSeed = self:GetMD5Seed() % 0x100 - 1
	
	-- Don't calculate stuff we won't end up using
	if ( bFirstShotInaccurate or iNum ~= 1 ) then
		flSpreadBias = bullets.SpreadBias or 0.5
		bNegBias = false
		
		if ( flSpreadBias > 1 ) then
			flSpreadBias = 1
			bNegBias = true
			flSpreadBias = -flSpreadBias
		elseif ( flSpreadBias < -1 ) then
			flSpreadBias = -1
			bNegBias = false
		else
			bNegBias = flSpreadBias < 0
			
			if ( bNegBias ) then
				flSpreadBias = -flSpreadBias
			end
		end
		
		local vSpread = bullets.Spread or vector_origin
		flSpreadX = vSpread[1]
		flSpreadY = vSpread[2]
		vSpreadRight = vSpread:Right()
		vSpreadUp = vSpread:Up()
		
		if ( iNum ~= 1 ) then
			local flHullSize = bullets.HullSize
			
			if ( flHullSize ) then
				vFireBulletMax = Vector( flHullSize, flHullSize, flHullSize )
				vFireBulletMin = -vFireBulletMax
			else
				vFireBulletMax = vDefaultMax
				vFireBulletMin = vDefaultMin
			end
		end
	end
	
	//Adrian: visualize server/client player positions
	//This is used to show where the lag compesator thinks the player should be at.
	local iHitNum = sv_showplayerhitboxes:GetInt()
	
	if ( iHitNum > 0 ) then
		local pLagPlayer = Player( iHitNum )
		
		if ( pLagPlayer ~= NULL ) then
			pLagPlayer:DrawHitBoxes( DEBUG_LENGTH )
		end
	end
	
	iHitNum = sv_showimpacts:GetInt()
	
	for iShot = 1, iNum do
		local vShotDir
		iSeed = iSeed + 1 // use new seed for next bullet
		gsrand:SetSeed( iSeed ) // init random system with this seed
		
		// If we're firing multiple shots, and the first shot has to be ba on target, ignore spread
		if ( bFirstShotInaccurate or iShot ~= 1 ) then
			local x
			local y
			local z

			repeat
				x = gsrand:RandomFloat(-1, 1) * flSpreadBias + gsrand:RandomFloat(-1, 1) * (1 - flSpreadBias)
				y = gsrand:RandomFloat(-1, 1) * flSpreadBias + gsrand:RandomFloat(-1, 1) * (1 - flSpreadBias)

				if ( bNegBias ) then
					x = x < 0 and -(1 + x) or 1 - x
					y = y < 0 and -(1 + y) or 1 - y
				end

				z = x * x + y * y
			until (z <= 1)

			vShotDir = vDir + x * flSpreadX * vSpreadRight + y * flSpreadY * vSpreadUp
			vShotDir:Normalize()
		else
			vShotDir = vDir:GetNormal()
		end
		
		local bHitGlass
		local vEnd = vSrc + vShotDir * flDistance
		local vNewSrc = vSrc
		local vFinalHit
		
		repeat
			local tr = iShot % 2 == 0 and
				// Half of the shotgun pellets are hulls that make it easier to hit targets with the shotgun.
				util.TraceHull({
					start = vNewSrc,
					endpos = vEnd,
					mins = vFireBulletMin,
					maxs = vFireBulletMax,
					mask = iMask,
					filter = Filter
				})
			or
				util.TraceLine({
					start = vNewSrc,
					endpos = vEnd,
					mask = iMask,
					filter = Filter
				})
			
			--[[if ( SERVER ) then
				if ( bStartedInWater ) then
					local flLengthSqr = vSrc:DistToSqr( tr.HitPos )
					
					if ( flLengthSqr > SHOT_UNDERWATER_BUBBLE_DIST * SHOT_UNDERWATER_BUBBLE_DIST ) then
						util.BubbleTrail( self:ComputeTracerStartPosition( vSrc ),
						vSrc + SHOT_UNDERWATER_BUBBLE_DIST * vShotDir,
						WATER_BULLET_BUBBLES_PER_INCH * SHOT_UNDERWATER_BUBBLE_DIST )
					else
						local flLength = math.sqrt( flLengthSqr ) - 0.1
						util.BubbleTrail( self:ComputeTracerStartPosition( vSrc ),
						vSrc + flLength * vShotDir,
						SHOT_UNDERWATER_BUBBLE_DIST * flLength )
					end
				end
				
				// Now hit all triggers along the ray that respond to shots...
				// Clip the ray to the first collided solid returned from traceline
				-- https://github.com/Facepunch/garrysmod-requests/issues/755
				local triggerInfo = DamageInfo()
					triggerInfo:SetAttacker( pAttacker )
					triggerInfo:SetInflictor( pAttacker )
					triggerInfo:SetDamage( iDamage )
					triggerInfo:SetDamageType( iAmmoDamageType )
					triggerInfo:CalculateBulletDamageForce( sAmmoType, vShotDir, tr.HitPos, tr.HitPos, flForce )
					triggerInfo:SetAmmoType( iAmmoType )
				triggerInfo:TraceAttackToTriggers( triggerInfo, vSrc, tr.HitPos, vShotDir )
			end]]
			
			local pEntity = tr.Entity
			local vHitPos = tr.HitPos
			vFinalHit = vHitPos
			
			local bEndNotWater = bit.band( util.PointContents( tr.HitPos ), MASK_WATER ) == 0
			local trSplash = bStartedInWater and bEndNotWater and
				util.TraceLine({
					start = vHitPos,
					endpos = vSrc,
					mask = MASK_WATER
				})
			// See if the bullet ended up underwater + started out of the water
			or not (bStartedInWater or bEndNotWater) and
				util.TraceLine({
					start = vSrc,
					endpos = vHitPos,
					mask = MASK_WATER
				})
			
			if ( trSplash and (bWeaponInvalid or not (pWeapon.DoSplashEffect and pWeapon:DoSplashEffect( trSplash ))) and bFirstTimePredicted ) then
				local data = EffectData()
					data:SetOrigin( trSplash.HitPos )
					data:SetScale( gsrand:RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
					
					if ( bit.band( util.PointContents( trSplash.HitPos ), CONTENTS_SLIME ) ~= 0 ) then
						data:SetFlags( FX_WATER_IN_SLIME )
					end
					
				util.Effect( "gunshotsplash", data )
			end
			
			if ( tr.Fraction == 1 or pEntity == NULL ) then
				break // we didn't hit anything, stop tracing shoot
			end
			
			// draw server impact markers
			if ( iHitNum == 1 or (CLIENT and iHitNum == 2) or (SERVER and iHitNum == 3) ) then
				debugoverlay.Box( vHitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_debug )
			end
			
			// do damage, paint decals
			-- https://github.com/Facepunch/garrysmod-issues/issues/2741
			bHitGlass = --[[tr.MatType == MAT_GLASS]] pEntity:GetClass():find( "func_breakable", 1, true ) and not pEntity:HasSpawnFlags( SF_BREAK_NO_BULLET_PENETRATION )
			
			if ( not bStartedWater and bEndNotWater or bit.band( iFlags, FIRE_BULLETS_DONT_HIT_UNDERWATER ) == 0 ) then
				-- The engine considers this a float
				-- Even though no values assigned to it are
				local iActualDamage = iDamage
				
				// If we hit a player, and we have player damage specified, use that instead
				// Adrian: Make sure to use the currect value if we hit a vehicle the player is currently driving.
				-- We don't check for vehicle passengers since GMod has no C++ vehicles with them
				if ( pEntity:IsPlayer() ) then
					if ( iPlayerDamage ~= 0 ) then
						iActualDamage = iPlayerDamage
					end
				elseif ( pEntity:IsNPC() ) then
					if ( iNPCDamage ~= 0 ) then
						iActualDamage = iNPCDamage
					end
				-- https://github.com/Facepunch/garrysmod-requests/issues/760
				elseif ( SERVER and pEntity:IsVehicle() ) then
					local pDriver = pEntity:GetDriver()
					
					if ( iPlayerDamage ~= 0 and pDriver:IsPlayer() ) then
						iActualDamage = iPlayerDamage
					elseif ( iNPCDamage ~= 0 and pDriver:IsNPC() ) then
						iActualDamage = iNPCDamage
					end
				end
				
				if ( iActualDamage == 0 ) then
					iActualDamage = iAmmoPlayerDamage == 0 and iDamage or iAmmoPlayerDamage -- Only players fire through this
				end
				
				// Damage specified by function parameter
				local info = DamageInfo()
					info:SetAttacker( pAttacker )
					info:SetInflictor( pInflictor )
					info:SetDamage( iActualDamage )
					info:SetDamageType( iAmmoDamageType )
					info:SetDamagePosition( vHitPos )
					info:SetDamageForce( vShotDir * flAmmoForce * flForce * flPhysPush )
					info:SetAmmoType( iAmmoType )
					info:SetReportedPosition( vSrc )
				pEntity:DispatchTraceAttack( info, tr, vShotDir )
				
				if ( fCallback ) then
					fCallback( pAttacker, tr, info )
				end
				
				if ( bEndNotWater or bit.band( iFlags, FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS ) ~= 0 ) then
					if ( bWeaponInvalid or not pWeapon.DoImpactEffect or not pWeapon:DoImpactEffect( tr, iAmmoDamageType )) then
						if ( bFirstTimePredicted ) then
							local data = EffectData()
								data:SetOrigin( tr.HitPos )
								data:SetStart( vSrc )
								data:SetSurfaceProp( tr.SurfaceProps )
								data:SetDamageType( iAmmoDamageType )
								data:SetHitBox( tr.HitBox )
								data:SetEntity( pEntity )
							util.Effect( "Impact", data )
						end
					elseif ( bFirstTimePredicted ) then
						// We may not impact, but we DO need to affect ragdolls on the client
						local data = EffectData()
							data:SetOrigin( tr.HitPos )
							data:SetStart( vSrc )
							data:SetDamageType( iAmmoDamageType )
						util.Effect( "RagdollImpact", data )
					end
				end
			end
			
			if ( bDrop and SERVER ) then
				// Make sure if the player is holding this, he drops it
				DropEntityIfHeld( pEntity )
			end
			
			// See if we hit glass
			// Query the func_breakable for whether it wants to allow for bullet penetration
			if ( bHitGlass ) then
				local tEnts = ents.GetAll()
				local iLen = #tEnts
				
				-- Trace for only the entity we hit
				for i = iLen, 1, -1 do
					if ( tEnts[i] == pEntity ) then
						tEnts[i] = tEnts[iLen]
						tEnts[iLen] = nil
						
						break
					end
				end
				
				util.TraceLine({
					start = vEnd,
					endpos = vHitPos,
					mask = iMask,
					filter = tEnts,
					ignoreworld = true,
					output = tr
				})
				
				if ( bShowPenetration ) then
					debugoverlay.Line( vEnd, vHitPos, DEBUG_LENGTH, color_altdebug )
				end
				
				if ( iHitNum == 1 or ( CLIENT and iHitNum == 2 ) or ( SERVER and iHitNum == 3 )) then
					debugoverlay.Box( tr.HitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_altdebug )
				end
				
				// bullet did penetrate object, exit Decal
				if ( (bWeaponInvalid or not pWeapon.DoImpactEffect or not pWeapon:DoImpactEffect( tr, iAmmoDamageType )) and bFirstTimePredicted ) then
					local data = EffectData()
						data:SetOrigin( tr.HitPos )
						data:SetStart( tr.StartPos )
						data:SetSurfaceProp( tr.SurfaceProps )
						data:SetDamageType( iAmmoDamageType )
						data:SetHitBox( tr.HitBox )
						data:SetEntity( pEntity )
					util.Effect( "Impact", data )
				end
			
				vNewSrc = tr.HitPos
			end
		until ( not bHitGlass )
		
		if ( bDebugShoot ) then
			debugoverlay.Line( vSrc, vFinalHit, DEBUG_LENGTH, color_debug )
		end
		
		if ( bFirstTimePredicted and iTracerFreq > 0 ) then
			if ( iTracerCount % iTracerFreq == 0 ) then
				local data = EffectData()
					local iAttachment
					
					if ( bWeaponInvalid ) then
						data:SetStart( self:ComputeTracerStartPosition( vSrc, 1 ))
						data:SetAttachment(1)
					else
						local iAttachment = pWeapon.GetMuzzleAttachment and pWeapon:GetMuzzleAttachment() or 1
						data:SetStart( pWeapon.GetTracerOrigin and pWeapon:GetTracerOrigin() or self:ComputeTracerStartPosition( vSrc, iAttachment ))
						data:SetAttachment( iAttachment )
					end
					
					data:SetOrigin( vFinalHit )
					data:SetScale(0)
					data:SetEntity( bWeaponInvalid and self or pWeapon )
					data:SetFlags( iAmmoTracerType == TRACER_LINE_AND_WHIZ and nWhizTracer or 0x0002 )
				util.Effect( sTracerName, data )
			end
			
			iTracerCount = iTracerCount + 1
		end
	end
	
	self:LagCompensation( false )
end

function PLAYER:FireEntityBullets( tBullets, sClass )
	if ( SERVER ) then
		local pBullet = ents.Create( sClass or "gs_bullet" )
		
		if ( pBullet ~= NULL ) then
			pBullet:SetupBullet( tBullets )
			pBullet:Spawn()
		end
	end
end

local tMaterialParameters = {
	[MAT_METAL] = {
		Penetration = 0.5,
		Damage = 0.3
	},
	[MAT_DIRT] = {
		Penetration = 0.5,
		Damage = 0.3
	},
	[MAT_CONCRETE] = {
		Penetration = 0.4,
		Damage = 0.25
	},
	[MAT_GRATE] = {
		Penetration = 1,
		Damage = 0.99
	},
	[MAT_VENT] = {
		Penetration = 0.5,
		Damage = 0.45
	},
	[MAT_TILE] = {
		Penetration = 0.65,
		Damage = 0.3
	},
	[MAT_COMPUTER] = {
		Penetration = 0.4,
		Damage = 0.45
	},
	[MAT_WOOD] = {
		Penetration = 1,
		Damage = 0.6
	},
	[MAT_GLASS] = {
		Penetration = 1,
		Damage = 0.99
	}
}

local tDoublePenetration = {
	[MAT_WOOD] = true,
	[MAT_METAL] = true,
	[MAT_GRATE] = true,
	[MAT_GLASS] = true
}

local MASK_HITBOX = bit.bor( MASK_SOLID, CONTENTS_DEBRIS, CONTENTS_HITBOX )

function PLAYER:FireCSSBullets( bullets )
	if ( hook.Run( "EntityFireCSSBullets", self, bullets ) == false ) then
		return
	end
	
	self:LagCompensation( true )
	
	local pWeapon = self:GetActiveWeapon()
	local bWeaponInvalid = pWeapon == NULL
	
	-- FireCSSBullets info
	local sAmmoType
	local iAmmoType
	
	if ( not bullets.AmmoType ) then
		sAmmoType = ""
		iAmmoType = -1
	elseif ( isstring( bullets.AmmoType )) then
		sAmmoType = bullets.AmmoType
		iAmmoType = game.GetAmmoID( sAmmoType )
	else
		iAmmoType = bullets.AmmoType
		sAmmoType = game.GetAmmoName( iAmmoType )
	end
	
	local pAttacker = bullets.Attacker and bullets.Attacker ~= NULL and bullets.Attacker or self
	local fCallback = bullets.Callback
	local iDamage = bullets.Damage or 1
	local flDistance = bullets.Distance or MAX_TRACE_LENGTH
	local flExitMaxDistance = bullets.ExitMaxDistance or 128
	local flExitStepSize = bullets.ExitStepSize or 24
	
	local bFilterIsFunction
	local iFilterEnd
	local Filter = bullets.Filter
	
	-- Yes, this is dirty
	-- But this prevents tables from being created when it's not necessary
	-- Also supports functional filters
	if ( Filter ) then
		local sType = type( Filter )
		
		if ( sType == "function" ) then
			bFilterIsFunction = true
		else
			iFilterEnd = sType ~= "table" and -1 or nil
		end
	else
		Filter = self
		iFilterEnd = -1
		bFilterIsFunction = false
	end
	
	local iFlags = bullets.Flags or 0
	local flForce = bullets.Force or 1
	--local flHitboxTolerance = bullets.HitboxTolerance or 40
	local pInflictor = bullets.Inflictor and bullets.Inflictor ~= NULL and bullets.Inflictor or bWeaponInvalid and self or pWeapon
	local iMask = bullets.Mask or MASK_HITBOX
	local iNum = bullets.Num or 1
	local iPenetration = bullets.Penetration or 0
	local flRangeModifier = bullets.RangeModifier or 1
	local aShootAngles = bullets.ShootAngles or self:EyeAngles()
	local vSrc = bullets.Src or self:GetShootPos()
	local iTracerFreq = bullets.Tracer or 1
	local sTracerName = bullets.TracerName or "Tracer"
	
	-- Ammo
	local iAmmoFlags = game.GetAmmoFlags( sAmmoType )
	local flAmmoForce = game.GetAmmoForce( sAmmoType )
	local iAmmoDamageType = game.GetAmmoDamageType( sAmmoType )
	local iAmmoMinSplash = game.GetAmmoMinSplash( sAmmoType )
	local iAmmoMaxSplash = game.GetAmmoMaxSplash( sAmmoType )
	local iAmmoTracerType = game.GetAmmoTracerType( sAmmoType )
	local flPenetrationDistance = game.GetAmmoKey( sAmmoType, "penetrationdistance", 0 )
	local flPenetrationPower = game.GetAmmoKey( sAmmoType, "penetrationpower", 0 )
	
	-- Loop values
	local bDrop = bit.band( iAmmoFlags, AMMO_FORCE_DROP_IF_CARRIED ) ~= 0
	local bDebugShoot = ai_debug_shoot_positions:GetBool()
	local bFirstShotInaccurate = bit.band( iFlags, FIRE_BULLETS_FIRST_SHOT_ACCURATE ) == 0
	local flPhysPush = phys_pushscale:GetFloat()
	local vShootForward = aShootAngles:Forward()
	local bShowPenetration = sv_showpenetration:GetBool()
	local bStartedInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
	local bFirstTimePredicted = IsFirstTimePredicted()
	local vShootRight, vShootUp, flSpreadBias
	
	// Wrap it for network traffic so it's the same between client and server
	local iSeed = self:GetMD5Seed() % 0x100
	
	-- Don't calculate stuff we won't end up using
	if ( bFirstShotInaccurate or iNum ~= 1 ) then
		local vSpread = bullets.Spread or vector_origin
		flSpreadBias = bullets.SpreadBias or 0.5
		vShootRight = vSpread[1] * aShootAngles:Right()
		vShootUp = vSpread[2] * aShootAngles:Up()
	end
	
	//Adrian: visualize server/client player positions
	//This is used to show where the lag compesator thinks the player should be at.
	local iHitNum = sv_showplayerhitboxes:GetInt()
	
	if ( iHitNum > 0 ) then
		local pLagPlayer = Player( iHitNum )
		
		if ( pLagPlayer ~= NULL ) then
			pLagPlayer:DrawHitBoxes( DEBUG_LENGTH )
		end
	end
	
	iHitNum = sv_showimpacts:GetInt()
	
	for iShot = 1, iNum do
		local vShotDir
		iSeed = iSeed + 1 // use new seed for next bullet
		gsrand:SetSeed( iSeed ) // init random system with this seed
		
		-- Loop values
		local flCurrentDamage = iDamage	// damage of the bullet at it's current trajectory
		local flCurrentDistance = 0	// distance that the bullet has traveled so far
		local vNewSrc = vSrc
		local vFinalHit
		
		// add the spray 
		if ( bFirstShotInaccurate or iShot ~= 1 ) then
			vShotDir = vShootForward + vShootRight * (gsrand:RandomFloat( -flSpreadBias, flSpreadBias ) + gsrand:RandomFloat( -flSpreadBias, flSpreadBias ))
			+ vShootUp * (gsrand:RandomFloat( -flSpreadBias, flSpreadBias ) + gsrand:RandomFloat( -flSpreadBias, flSpreadBias ))
			vShotDir:Normalize()
		else
			vShotDir = vShootForward
		end
		
		local vEnd = vNewSrc + vShotDir * flDistance
		
		repeat
			local tr = util.TraceLine({
				start = vNewSrc,
				endpos = vEnd,
				mask = iMask,
				filter = Filter
			})
			
			// Check for player hitboxes extending outside their collision bounds
			--util.ClipTraceToPlayers( tr, vNewSrc, vEnd + vShotDir * flHitboxTolerance, Filter, iMask )
			
			local pEntity = tr.Entity
			local vHitPos = tr.HitPos
			vFinalHit = vHitPos
			
			local bEndNotWater = bit.band( util.PointContents( tr.HitPos ), MASK_WATER ) == 0
			local trSplash = bStartedInWater and bEndNotWater and
				util.TraceLine({
					start = vHitPos,
					endpos = vSrc,
					mask = MASK_WATER
				})
			// See if the bullet ended up underwater + started out of the water
			or not (bStartedInWater or bEndNotWater) and
				util.TraceLine({
					start = vSrc,
					endpos = vHitPos,
					mask = MASK_WATER
				})
			
			if ( trSplash and (bWeaponInvalid or not (pWeapon.DoSplashEffect and pWeapon:DoSplashEffect( trSplash ))) and bFirstTimePredicted ) then
				local data = EffectData()
					data:SetOrigin( trSplash.HitPos )
					data:SetScale( gsrand:RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
					
					if ( bit.band( util.PointContents( trSplash.HitPos ), CONTENTS_SLIME ) ~= 0 ) then
						data:SetFlags( FX_WATER_IN_SLIME )
					end
					
				util.Effect( "gunshotsplash", data )
			end
			
			if ( tr.Fraction == 1 or pEntity == NULL ) then
				break // we didn't hit anything, stop tracing shoot
			end
			
			// draw server impact markers
			if ( iHitNum == 1 or (CLIENT and iHitNum == 2) or (SERVER and iHitNum == 3) ) then
				debugoverlay.Box( vHitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_debug )
			end
			
			/************* MATERIAL DETECTION ***********/
			-- FIXME: Change this to use SurfaceProps if we can load our own version
			local iEnterMaterial = tr.MatType
			
			-- https://github.com/Facepunch/garrysmod-requests/issues/787
			// since some railings in de_inferno are CONTENTS_GRATE but CHAR_TEX_CONCRETE, we'll trust the
			// CONTENTS_GRATE and use a high damage modifier.
			// If we're a concrete grate (TOOLS/TOOLSINVISIBLE texture) allow more penetrating power.
			local bHitGrate = iEnterMaterial == MAT_GRATE or bit.band( util.PointContents( vHitPos ), CONTENTS_GRATE ) ~= 0
			
			// calculate the damage based on the distance the bullet travelled.
			flCurrentDistance = flCurrentDistance + tr.Fraction * flDistance
			flCurrentDamage = flCurrentDamage * flRangeModifier ^ (flCurrentDistance / 500)
			
			// check if we reach penetration distance, no more penetrations after that
			if ( flCurrentDistance > flPenetrationDistance and iPenetration > 0 ) then
				iPenetration = 0
			end
			
			if ( not bStartedWater and bEndNotWater or bit.band( iFlags, FIRE_BULLETS_DONT_HIT_UNDERWATER ) == 0 ) then
				// add damage to entity that we hit
				local info = DamageInfo()
					info:SetAttacker( pAttacker )
					info:SetInflictor( pInflictor )
					info:SetDamage( flCurrentDamage )
					info:SetDamageType( iAmmoDamageType )
					info:SetDamagePosition( vHitPos )
					info:SetDamageForce( vShotDir * flAmmoForce * flForce * flPhysPush )
					info:SetAmmoType( iAmmoType )
					info:SetReportedPosition( vSrc )
				pEntity:DispatchTraceAttack( info, tr, vShotDir )
				
				if ( fCallback ) then
					fCallback( pAttacker, tr, info )
				end
				
				if ( bEndNotWater or bit.band( iFlags, FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS ) ~= 0 ) then
					if ( bWeaponInvalid or not pWeapon.DoImpactEffect or not pWeapon:DoImpactEffect( tr, iAmmoDamageType )) then
						if ( bFirstTimePredicted ) then
							local data = EffectData()
								data:SetOrigin( tr.HitPos )
								data:SetStart( vSrc )
								data:SetSurfaceProp( tr.SurfaceProps )
								data:SetDamageType( iAmmoDamageType )
								data:SetHitBox( tr.HitBox )
								data:SetEntity( pEntity )
							util.Effect( "Impact", data )
						end
					elseif ( bFirstTimePredicted ) then
						// We may not impact, but we DO need to affect ragdolls on the client
						local data = EffectData()
							data:SetOrigin( tr.HitPos )
							data:SetStart( vSrc )
							data:SetDamageType( iAmmoDamageType )
						util.Effect( "RagdollImpact", data )
					end
				end
			end
			
			if ( bDrop and SERVER ) then
				// Make sure if the player is holding this, he drops it
				DropEntityIfHeld( pEntity )
			end
			
			// check if bullet can penetrate another entity
			// If we hit a grate with iPenetration == 0, stop on the next thing we hit
			if ( iPenetration == 0 and not bHitGrate or iPenetration < 0 or pEntity:GetClass():find( "func_breakable", 1, true ) and pEntity:HasSpawnFlags( SF_BREAK_NO_BULLET_PENETRATION )) then
				break // no, stop
			end
			
			if ( pEntity:IsWorld() ) then
				local flExitDistance = 0
				local vPenetrationEnd
				
				// try to penetrate object, maximum penetration is 128 inch
				while ( flExitDistance <= flExitMaxDistance ) do
					flExitDistance = flExitDistance + flExitStepSize
				
					local vHit = vHitPos + flExitDistance * vShotDir
				
					if ( bit.band( util.PointContents( vHit ), MASK_SOLID ) == 0 ) then
						// found first free point
						vPenetrationEnd = vHit
					end
				end
			
				-- Nowhere to penetrate
				if ( not vPenetrationEnd ) then
					break
				end
				
				util.TraceLine({
					start = vPenetrationEnd,
					endpos = vHitPos,
					mask = CONTENTS_SOLID,
					filter = ents.GetAll(),
					output = tr
				})
				
				if ( bShowPenetration ) then
					debugoverlay.Line( vPenetrationEnd, vHitPos, DEBUG_LENGTH, color_altdebug )
				end
			else
				local tEnts = ents.GetAll()
				local iLen = #tEnts
				
				-- Trace for only the entity we hit
				for i = iLen, 1, -1 do
					if ( tEnts[i] == pEntity ) then
						tEnts[i] = tEnts[iLen]
						tEnts[iLen] = nil
						
						break
					end
				end
				
				util.TraceLine({
					start = vEnd,
					endpos = vHitPos,
					mask = iMask,
					filter = tEnts,
					ignoreworld = true,
					output = tr
				})
				
				if ( bShowPenetration ) then
					debugoverlay.Line( vEnd, vHitPos, DEBUG_LENGTH, color_altdebug )
				end
			end
			
			local iExitMaterial = tr.MatType
			local tMatParams = tMaterialParameters[iEnterMaterial]
			local flPenetrationModifier = bHitGrate and 1 or tMatParams and tMatParams.Penetration or 1
			local flDamageModifier = bHitGrate and 0.99 or tMatParams and tMatParams.Damage or 0.5
			local flTraceDistance = (tr.HitPos - vHitPos):LengthSqr()
			
			// get material at exit point
			-- https://github.com/Facepunch/garrysmod-requests/issues/787
			if ( bHitGrate ) then
				bHitGrate = iExitMaterial == MAT_GRATE or bit.band( util.PointContents( tr.HitPos ), CONTENTS_GRATE ) ~= 0
			end
			
			// if enter & exit point is wood or metal we assume this is 
			// a hollow crate or barrel and give a penetration bonus
			if ( bHitGrate and (iExitMaterial == MAT_GRATE or bit.band( util.PointContents( tr.HitPos ), CONTENTS_GRATE ) ~= 0) or iEnterMaterial == iExitMaterial and tDoublePenetration[iExitMaterial] ) then
				flPenetrationModifier = flPenetrationModifier * 2	
			end

			// check if bullet has enough power to penetrate this distance for this material
			if ( flTraceDistance > (flPenetrationPower * flPenetrationModifier)^2 ) then
				break // bullet hasn't enough power to penetrate this distance
			end
			
			if ( iHitNum == 1 or ( CLIENT and iHitNum == 2 ) or ( SERVER and iHitNum == 3 )) then
				debugoverlay.Box( tr.HitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_altdebug )
			end
			
			// bullet did penetrate object, exit Decal
			if ( (bWeaponInvalid or not pWeapon.DoImpactEffect or not pWeapon:DoImpactEffect( tr, iAmmoDamageType )) and bFirstTimePredicted ) then
				local data = EffectData()
					data:SetOrigin( tr.HitPos )
					data:SetStart( tr.StartPos )
					data:SetSurfaceProp( tr.SurfaceProps )
					data:SetDamageType( iAmmoDamageType )
					data:SetHitBox( tr.HitBox )
					data:SetEntity( pEntity )
				util.Effect( "Impact", data )
			end	
			
			// penetration was successful
			flTraceDistance = math.sqrt( flTraceDistance )
			
			// setup new start end parameters for successive trace
			flPenetrationPower = flPenetrationPower - flTraceDistance / flPenetrationModifier
			flCurrentDistance = flCurrentDistance + flTraceDistance
			
			// reduce damage power each time we hit something other than a grate
			flCurrentDamage = flCurrentDamage * flDamageModifier
			flDistance = (flDistance - flCurrentDistance) * 0.5
			
			vNewSrc = tr.HitPos
			vEnd = vNewSrc + vShotDir * flDistance
			
			// reduce penetration counter
			iPenetration = iPenetration - 1
			
			-- Can't hit players more than once
			if ( pEntity:IsPlayer() or pEntity:IsNPC() ) then
				if ( bFilterIsFunction ) then
					local fOldFilter = Filter
					Filter = function( pTest )
						return fOldFilter( pTest ) and pTest ~= pEntity
					end
				elseif ( iFilterEnd == -1 ) then
					Filter = { Filter, pEntity }
					iFilterEnd = 2
				else
					iFilterEnd = (iFilterEnd or #Filter) + 1
					Filter[iFilterEnd] = pEntity
				end
			end
		until ( flCurrentDamage < FLT_EPSILON ) -- Account for float handling; very rare case
		
		if ( bDebugShoot ) then
			debugoverlay.Line( vSrc, vFinalHit, DEBUG_LENGTH, color_debug )
		end
		
		if ( bFirstTimePredicted and iTracerFreq > 0 ) then
			if ( iTracerCount % iTracerFreq == 0 ) then
				local data = EffectData()
					local iAttachment
					
					if ( bWeaponInvalid ) then
						data:SetStart( self:ComputeTracerStartPosition( vSrc, 1 ))
						data:SetAttachment(1)
					else
						local iAttachment = pWeapon.GetMuzzleAttachment and pWeapon:GetMuzzleAttachment() or 1
						data:SetStart( pWeapon.GetTracerOrigin and pWeapon:GetTracerOrigin() or self:ComputeTracerStartPosition( vSrc, iAttachment ))
						data:SetAttachment( iAttachment )
					end
					
					data:SetOrigin( vFinalHit )
					data:SetScale(0)
					data:SetEntity( bWeaponInvalid and self or pWeapon )
					data:SetFlags( iAmmoTracerType == TRACER_LINE_AND_WHIZ and nWhizTracer or 0x0002 )
				util.Effect( sTracerName, data )
			end
			
			iTracerCount = iTracerCount + 1
		end
	end
	
	self:LagCompensation( false )
end

-- FireCSSBullets without penetration
function PLAYER:FireSDKBullets( bullets )
	if ( hook.Run( "EntityFireSDKBullets", self, bullets ) == false ) then
		return
	end
	
	self:LagCompensation( true )
	
	local pWeapon = self:GetActiveWeapon()
	local bWeaponInvalid = pWeapon == NULL
	
	local sAmmoType
	local iAmmoType
	
	if ( not bullets.AmmoType ) then
		sAmmoType = ""
		iAmmoType = -1
	elseif ( isstring( bullets.AmmoType )) then
		sAmmoType = bullets.AmmoType
		iAmmoType = game.GetAmmoID( sAmmoType )
	else
		iAmmoType = bullets.AmmoType
		sAmmoType = game.GetAmmoName( iAmmoType )
	end
	
	local pAttacker = bullets.Attacker and bullets.Attacker ~= NULL and bullets.Attacker or self
	local fCallback = bullets.Callback
	local iDamage = bullets.Damage or 1
	local flDistance = bullets.Distance or 8000
	local Filter = bullets.Filter or self
	local iFlags = bullets.Flags or 0
	local flForce = bullets.Force or 1
	local pInflictor = bullets.Inflictor and bullets.Inflictor ~= NULL and bullets.Inflictor or bWeaponInvalid and self or pWeapon
	local iMask = bullets.Mask or MASK_HITBOX
	local iNum = bullets.Num or 1
	local flRangeModifier = bullets.RangeModifier or 0.85
	local aShootAngles = bullets.ShootAngles or self:EyeAngles()
	local vSrc = bullets.Src or self:GetShootPos()
	local iTracerFreq = bullets.Tracer or 1
	local sTracerName = bullets.TracerName or "Tracer"
	
	-- Ammo
	local iAmmoFlags = game.GetAmmoFlags( sAmmoType )
	local flAmmoForce = game.GetAmmoForce( sAmmoType )
	local iAmmoDamageType = game.GetAmmoDamageType( sAmmoType )
	local iAmmoMinSplash = game.GetAmmoMinSplash( sAmmoType )
	local iAmmoMaxSplash = game.GetAmmoMaxSplash( sAmmoType )
	local iAmmoTracerType = game.GetAmmoTracerType( sAmmoType )
	
	-- Loop values
	local bDrop = bit.band( iAmmoFlags, AMMO_FORCE_DROP_IF_CARRIED ) ~= 0
	local bDebugShoot = ai_debug_shoot_positions:GetBool()
	local bFirstShotInaccurate = bit.band( iFlags, FIRE_BULLETS_FIRST_SHOT_ACCURATE ) == 0
	local flPhysPush = phys_pushscale:GetFloat()
	local vShootForward = aShootAngles:Forward()
	local bStartedInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
	local bFirstTimePredicted = IsFirstTimePredicted()
	local vShootRight, vShootUp, flSpreadBias
	
	// Wrap it for network traffic so it's the same between client and server
	local iSeed = self:GetMD5Seed() % 0x100
	
	-- Don't calculate stuff we won't end up using
	if ( bFirstShotInaccurate or iNum ~= 1 ) then
		local vSpread = bullets.Spread or vector_origin
		flSpreadBias = bullets.SpreadBias or 0.5
		vShootRight = vSpread[1] * aShootAngles:Right()
		vShootUp = vSpread[2] * aShootAngles:Up()
	end
	
	//Adrian: visualize server/client player positions
	//This is used to show where the lag compesator thinks the player should be at.
	local iHitNum = sv_showplayerhitboxes:GetInt()
	
	if ( iHitNum > 0 ) then
		local pLagPlayer = Player( iHitNum )
		
		if ( pLagPlayer ~= NULL ) then
			pLagPlayer:DrawHitBoxes( DEBUG_LENGTH )
		end
	end
	
	iHitNum = sv_showimpacts:GetInt()
	
	for iShot = 1, iNum do
		local vShotDir
		iSeed = iSeed + 1 // use new seed for next bullet
		gsrand:SetSeed( iSeed ) // init random system with this seed
		
		// add the spray 
		if ( bFirstShotInaccurate or iShot ~= 1 ) then
			vShotDir = vShootForward + vShootRight * (gsrand:RandomFloat( -flSpreadBias, flSpreadBias ) + gsrand:RandomFloat( -flSpreadBias, flSpreadBias ))
			+ vShootUp * (gsrand:RandomFloat( -flSpreadBias, flSpreadBias ) + gsrand:RandomFloat( -flSpreadBias, flSpreadBias ))
			vShotDir:Normalize()
		else
			vShotDir = vShootForward
		end
		
		local vEnd = vSrc + vShotDir * flDistance
		
		local tr = util.TraceLine({
			start = vSrc,
			endpos = vEnd,
			mask = iMask,
			filter = Filter
		})
		
		local pEntity = tr.Entity
		local vHitPos = tr.HitPos
		
		local bEndNotWater = bit.band( util.PointContents( tr.HitPos ), MASK_WATER ) == 0
		local trSplash = bStartedInWater and bEndNotWater and
			util.TraceLine({
				start = vHitPos,
				endpos = vSrc,
				mask = MASK_WATER
			})
		// See if the bullet ended up underwater + started out of the water
		or not (bStartedInWater or bEndNotWater) and
			util.TraceLine({
				start = vSrc,
				endpos = vHitPos,
				mask = MASK_WATER
			})
		
		if ( trSplash and (bWeaponInvalid or not (pWeapon.DoSplashEffect and pWeapon:DoSplashEffect( trSplash ))) and bFirstTimePredicted ) then
			if ( bFirstTimePredicted ) then
				local data = EffectData()
					data:SetOrigin( trSplash.HitPos )
					data:SetScale( gsrand:RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
					
					if ( bit.band( util.PointContents( trSplash.HitPos ), CONTENTS_SLIME ) ~= 0 ) then
						data:SetFlags( FX_WATER_IN_SLIME )
					end
					
				util.Effect( "gunshotsplash", data )
			end
		end
		
		if ( tr.Fraction == 1 or pEntity == NULL ) then
			break // we didn't hit anything, stop tracing shoot
		end
		
		// draw server impact markers
		if ( iHitNum == 1 or (CLIENT and iHitNum == 2) or (SERVER and iHitNum == 3) ) then
			debugoverlay.Box( vHitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_debug )
		end
		
		if ( not bStartedWater and bEndNotWater or bit.band( iFlags, FIRE_BULLETS_DONT_HIT_UNDERWATER ) == 0 ) then
			// add damage to entity that we hit
			local info = DamageInfo()
				info:SetAttacker( pAttacker )
				info:SetInflictor( pInflictor )
				info:SetDamage( iDamage * flRangeModifier ^ (tr.Fraction * flDistance / 500) )
				info:SetDamageType( iAmmoDamageType )
				info:SetDamagePosition( vHitPos )
				info:SetDamageForce( vShotDir * flAmmoForce * flForce * flPhysPush )
				info:SetAmmoType( iAmmoType )
				info:SetReportedPosition( vSrc )
			pEntity:DispatchTraceAttack( info, tr, vShotDir )
			
			if ( fCallback ) then
				fCallback( pAttacker, tr, info )
			end
			
			if ( bEndNotWater or bit.band( iFlags, FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS ) ~= 0 ) then
				if ( bWeaponInvalid or not pWeapon.DoImpactEffect or not pWeapon:DoImpactEffect( tr, iAmmoDamageType )) then
					if ( bFirstTimePredicted ) then
						local data = EffectData()
							data:SetOrigin( tr.HitPos )
							data:SetStart( vSrc )
							data:SetSurfaceProp( tr.SurfaceProps )
							data:SetDamageType( iAmmoDamageType )
							data:SetHitBox( tr.HitBox )
							data:SetEntity( pEntity )
						util.Effect( "Impact", data )
					end
				elseif ( bFirstTimePredicted ) then
					// We may not impact, but we DO need to affect ragdolls on the client
					local data = EffectData()
						data:SetOrigin( tr.HitPos )
						data:SetStart( vSrc )
						data:SetDamageType( iAmmoDamageType )
					util.Effect( "RagdollImpact", data )
				end
			end
		end
		
		if ( bDrop and SERVER ) then
			// Make sure if the player is holding this, he drops it
			DropEntityIfHeld( pEntity )
		end
		
		if ( bDebugShoot ) then
			debugoverlay.Line( vSrc, vHitPos, DEBUG_LENGTH, color_debug )
		end
		
		if ( bFirstTimePredicted and iTracerFreq > 0 ) then
			if ( iTracerCount % iTracerFreq == 0 ) then
				local data = EffectData()
					local iAttachment
					
					if ( bWeaponInvalid ) then
						data:SetStart( self:ComputeTracerStartPosition( vSrc, 1 ))
						data:SetAttachment(1)
					else
						local iAttachment = pWeapon.GetMuzzleAttachment and pWeapon:GetMuzzleAttachment() or 1
						data:SetStart( pWeapon.GetTracerOrigin and pWeapon:GetTracerOrigin() or self:ComputeTracerStartPosition( vSrc, iAttachment ))
						data:SetAttachment( iAttachment )
					end
					
					data:SetOrigin( vHitPos )
					data:SetScale(0)
					data:SetEntity( bWeaponInvalid and self or pWeapon )
					data:SetFlags( iAmmoTracerType == TRACER_LINE_AND_WHIZ and nWhizTracer or 0x0002 )
				util.Effect( sTracerName, data )
			end
			
			iTracerCount = iTracerCount + 1
		end
	end
	
	self:LagCompensation( false )
end

function PLAYER:GetMD5Seed()
	local iFrameCount = CurTime()
	
	if ( self.m_iMD5SeedSavedFrame ~= iFrameCount ) then
		self.m_iMD5SeedSavedFrame = iFrameCount
		self.m_iMD5Seed = math.MD5Random( self:GetCurrentCommand():CommandNumber() )
	end
	
	return self.m_iMD5Seed
end

function AngleRand( flMin, flMax )	
	return Angle( math.Rand( flMin or -90, flMax or 90 ),
		math.Rand( flMin or -180, flMax or 180 ),
		math.Rand( flMin or -180, flMax or 180 ))
end

function ANGLE:ClipPunchAngleOffset( aPunch, aClip )
	//Clip each component
	local aFinal = self + aPunch
	local fp = aFinal.p
	local fy = aFinal.y
	local fr = aFinal.r
	local cp = aClip.p
	local cy = aClip.y
	local cr = aClip.r
	
	if ( fp > cp ) then
		fp = cp
	elseif ( fp < -cp ) then
		fp = -cp
	end
	
	self.p = fp - aPunch.p
	
	if ( fy > cy ) then
		fy = cy
	elseif ( fy < -cy ) then
		fy = -cy
	end
	
	self.y = fy - aPunch.y
	
	if ( fr > cr ) then
		fr = cr
	elseif ( fr < -cr ) then
		fr = -cr
	end
	
	self.r = fr - aPunch.r
end

function ANGLE:NormalizeInPlace()
	if ( self == angle_zero ) then
		return 0
	end
	
	local x = self[1]
	local y = self[2]
	local z = self[3]
	local flRadius = math.sqrt( x*x + y*y + z*z )
	self[1] = x / flRadius
	self[2] = y / flRadius
	self[3] = z / flRadius
	
	return flRadius
end

vector_normal = Vector( 0, 0, 1 )
vector_debug_max = Vector( 2, 2, 2 )
vector_debug_min = -vector_debug_max

function VectorRand( flMin, flMax )
	if ( not flMin ) then
		flMin = -1
	end
	
	if ( not flMax ) then
		flMax = 1
	end
	
	return Vector( math.Rand( flMin, flMax ),
		math.Rand( flMin, flMax ),
		math.Rand( flMin, flMax ))
end

function VECTOR:NormalizeInPlace()
	if ( self == vector_origin ) then
		return 0
	end
	
	local x = self[1]
	local y = self[2]
	local z = self[3]
	local flRadius = math.sqrt( x*x + y*y + z*z )
	self[1] = x / flRadius
	self[2] = y / flRadius
	self[3] = z / flRadius
	
	return flRadius
end

function VECTOR:DistanceSqrToRay( vStart, vEnd )
	local vTo = self - vStart
	local vDir = vEnd - vStart
	local flLength = vDir:NormalizeInPlace()
	local flRange = (vDir):Dot(vTo)
	
	if ( flRange < 0.0 ) then
		// off start point
		return -vTo:LengthSqr(), flRange, vStart
	end
	
	if ( flRange > flLength ) then
		// off end point
		return -(self - vEnd):LengthSqr(), flRange, vEnd
	end
	
	// within ray bounds
	local vOnRay = vStart + flRange * vDir
	
	return (self - vOnRay):LengthSqr(), flRange, vOnRay
end

function VECTOR:ImpulseAngle()
	return Angle( self.y, self.z, self.x )
end

function VECTOR:Right( vUp --[[= Vector(0, 0, 1)]] )
	if ( self.x == 0 and self.y == 0 )then
		// pitch 90 degrees up/down from identity
		return Vector( 0, -1, 0 )
	else
		local vRet = self:Cross( vUp or vector_normal )
		vRet:Normalize()
		
		return vRet
	end
end

function VECTOR:Up( vUp --[[= Vector(0, 0, 1)]] )
	if ( self.x == 0 and self.y == 0 )then
		return Vector( -self.z, 0, 0 )
	else
		local vRet = self:Cross( vUp or vector_normal )
		vRet = vRet:Cross( self )
		vRet:Normalize()
		
		return vRet
	end
end

color_debug = SERVER and Color( 0, 0, 255, 100 ) or Color( 255, 0, 0, 100 )
color_altdebug = SERVER and Color( 0, 255, 0, 100 ) or Color( 255, 255, 0, 100 )

// Maximum traceable distance ( assumes cubic world and trace from one corner to opposite )
// COORD_EXTENT * sqrt(3)
MAX_TRACE_LENGTH = math.sqrt(3) * 2 * 16384

// entity capabilities
// These are caps bits to indicate what an object's capabilities (currently used for +USE, save/restore and level transitions)
FCAP_MUST_SPAWN = 0x00000001		// Spawn after restore
FCAP_ACROSS_TRANSITION = 0x00000002		// should transfer between transitions 
// UNDONE: This will ignore transition volumes (trigger_transition), but not the PVS!!!
FCAP_FORCE_TRANSITION = 0x00000004		// ALWAYS goes across transitions
FCAP_NOTIFY_ON_TRANSITION = 0x00000008		// Entity will receive Inside/Outside transition inputs when a transition occurs

FCAP_IMPULSE_USE = 0x00000010		// can be used by the player
FCAP_CONTINUOUS_USE = 0x00000020		// can be used by the player
FCAP_ONOFF_USE = 0x00000040		// can be used by the player
FCAP_DIRECTIONAL_USE = 0x00000080		// Player sends +/- 1 when using (currently only tracktrains)
// NOTE: Normally +USE only works in direct line of sight.  Add these caps for additional searches
FCAP_USE_ONGROUND = 0x00000100
FCAP_USE_IN_RADIUS = 0x00000200
FCAP_SAVE_NON_NETWORKABLE = 0x00000400

FCAP_MASTER = 0x10000000		// Can be used to "master" other entities (like multisource)
FCAP_WCEDIT_POSITION = 0x40000000		// Can change position and update Hammer in edit mode
FCAP_DONT_SAVE = 0x80000000		// Don't save this

// Spawnflags for func breakable
SF_BREAK_TRIGGER_ONLY = 0x0001	// may only be broken by trigger
SF_BREAK_TOUCH = 0x0002	// can be 'crashed through' by running player (plate glass)
SF_BREAK_PRESSURE = 0x0004	// can be broken by a player standing on it
SF_BREAK_PHYSICS_BREAK_IMMEDIATELY = 0x0200	// the first physics collision this breakable has will immediately break it
SF_BREAK_DONT_TAKE_PHYSICS_DAMAGE = 0x0400	// this breakable doesn't take damage from physics collisions
SF_BREAK_NO_BULLET_PENETRATION = 0x0800  // don't allow bullets to penetrate

// Spawnflags for func_pushable (it's also func_breakable, so don't collide with those flags)
SF_PUSH_BREAKABLE = 0x0080
SF_PUSH_NO_USE = 0x0100	// player cannot +use pickup this ent

-- Effects
FX_WATER_IN_SLIME = 0x1

--TE_EXPLFLAG_NONE = 0x0	// all flags clear makes default Half-Life explosion
TE_EXPLFLAG_NOADDITIVE = 0x1	// sprite will be drawn opaque (ensure that the sprite you send is a non-additive sprite)
TE_EXPLFLAG_NODLIGHTS = 0x2	// do not render dynamic lights
TE_EXPLFLAG_NOSOUND = 0x4	// do not play client explosion sound
TE_EXPLFLAG_NOPARTICLES = 0x8	// do not draw particles
TE_EXPLFLAG_DRAWALPHA = 0x10	// sprite will be drawn alpha
TE_EXPLFLAG_ROTATE = 0x20	// rotate the sprite randomly
TE_EXPLFLAG_NOFIREBALL = 0x40	// do not draw a fireball
TE_EXPLFLAG_NOFIREBALLSMOKE = 0x80	// do not draw smoke with the fireball

MUZZLEFLASH_FIRSTPERSON = 0x100

function ENTITY:ApplyLocalAngularVelocityImpulse( vImpulse )
	if ( vImpulse ~= vector_origin ) then
		if ( self:GetMoveType() == MOVETYPE_VPHYSICS ) then
			self:GetPhysicsObject():AddAngleVelocity( vImpulse )
		else
			self:SetLocalAngularVelocity( self:GetLocalAngularVelocity() + vImpulse:ImpulseAngle() )
		end
	end
end

function ENTITY:ComputeTracerStartPosition( vSrc, iAttachment )
	local tAttachment = self:GetAttachment( iAttachment or 1 )
	
	if ( tAttachment ) then
		return tAttachment.Pos
	end
	
	return self:EyePos()
end

ENTITY.GetHitBoxSet = ENTITY.GetHitboxSet -- ONLY hitbox method with lower-case b

function ENTITY:DrawHitBoxes( flDuration, bMonoColored )
	local iSet = self:GetHitBoxSet()
	
	if ( iSet ) then
		flDuration = flDuration or 0
		
		for iGroup = 0, self:GetHitBoxGroupCount() - 1 do
			for iHitBox = 0, self:GetHitBoxCount( iGroup ) - 1 do
				local vPos, ang = self:GetBonePosition( self:GetHitBoxBone( iHitBox, iGroup ))
				local vMins, vMaxs = self:GetHitBoxBounds( iHitBox, iGroup )
				debugoverlay.BoxAngles( vPos, vMins, vMaxs, ang, flDuration, bMonoColored and color_white or color_debug )
			end
		end
	end
end

-- https://github.com/Facepunch/garrysmod-requests/issues/660
-- https://github.com/Facepunch/garrysmod-requests/issues/811
ENTITY._GetAbsVelocity = ENTITY.GetVelocity
ENTITY._GetBaseVelocity = ENTITY.GetBaseVelocity
ENTITY._SetBaseVelocity = ENTITY.SetVelocity
ENTITY._GetLocalVelocity = ENTITY.GetAbsVelocity
ENTITY._SetLocalVelocity = ENTITY.SetLocalVelocity

-- BaseAnimating overrides this as well
function ENTITY:_GetVelocity()
	if ( self:GetMoveType() == MOVETYPE_VPHYSICS ) then
		local pPhysicsObject = self:GetPhysicsObject()
		
		if ( pPhysicsObject:IsValid() ) then
			return pPhysicsObject:GetVelocity()
		else
			return self:_GetAbsVelocity()
		end
	end
	
	if ( not self:OnGround() ) then
		return self:_GetAbsVelocity()
	end
	
	-- https://github.com/Facepunch/garrysmod-requests/issues/691
	return self:_GetAbsVelocity()
	
	--[[// Build a rotation matrix from NPC orientation
	Vector	vRawVel;
	
	GetSequenceLinearMotion( GetSequence(), &vRawVel );
	
	// Build a rotation matrix from NPC orientation
	matrix3x4_t fRotateMatrix;
	AngleMatrix(GetLocalAngles(), fRotateMatrix);
	VectorRotate( vRawVel, fRotateMatrix, *vVelocity);]]
end

-- Guessed based on the VPhysics interface comments
function ENTITY:_SetVelocity( vVelocity )
	if ( self:GetMoveType() == MOVETYPE_VPHYSICS ) then
		local pPhysicsObject = self:GetPhysicsObject()
		
		if ( pPhysicsObject:IsValid() ) then
			pPhysicsObject:SetVelocity( vVelocity )
		end
	else
		self:_SetAbsVelocity( vVelocity )
	end
end

-- https://github.com/Facepunch/garrysmod-requests/issues/550
function ENTITY:IsBSPModel()
	return self:GetSolid() == SOLID_BSP -- or self:GetSolid() == SOLID_VPHYSICS
end

function ENTITY:SolidFlagSet( iFlag )
	return bit.band( self:GetSolidFlags(), iFlag ) ~= 0
end

function ENTITY:Standable()
	if ( self:SolidFlagSet( FSOLID_NOT_STANDABLE )) then
		return false
	end
	
	local iSolid = self:GetSolid()
	
	return iSolid == SOLID_BSP or iSolid == SOLID_VPHYSICS or iSolid == SOLID_BBOX
	
	-- The engine calls IsBSPModel here as the fall-through case
	-- However, that always returns false if the above conditions are false
end

--- Lua functions
-- Different than ENTITY:Visible( pEnt )!
function ENTITY:IsVisible()
	return not self:IsEffectActive( EF_NODRAW )
end

function ENTITY:SetVisible( bVisible )
	if ( bVisible ) then
		self:RemoveEffects( EF_NODRAW )
	else
		self:AddEffects( EF_NODRAW )
	end
end

function ENTITY:SequenceEnd()
	return (1 - self:GetCycle()) * self:SequenceDuration()
end

local sv_gravity = GetConVar( "sv_gravity" )

function ENTITY:GetActualGravity()
	local flGravity = self:GetGravity()
	
	return flGravity == 0 and 1 or flGravity * sv_gravity:GetFloat()
end

function ENTITY:PhysicsPushEntity( vPush )
	local tr = self:PhysicsCheckSweep( self:GetPos(), vPush )
	
	if ( tr.Fraction ~= 0 ) then
		self:SetPos( tr.HitPos )
	end
	
	local pEntity = tr.Entity
	
	if ( tr.Entity ~= NULL ) then
		// If either of the entities is flagged to be deleted, 
		//  don't call the touch functions
		if ( not (self:IsFlagSet( FL_KILLME ) or pEntity:IsFlagSet( FL_KILLME ))) then
			self.m_trTouch = tr
			self.m_bTouched = true
		end
	end
	
	return tr
end

function ENTITY:PhysicsClipVelocity( vIn, vNormal, flBounce )
	local flAngle = vNormal.z
	local vRet = vIn - vNormal * vIn:Dot( vNormal ) * flBounce
	local x = vRet.x
	local y = vRet.y
	local z = vRet.z
	
	if ( x > -0.1 and x < 0.1 ) then
		vRet.x = 0
	end
	
	if ( y > -0.1 and y < 0.1 ) then
		vRet.y = 0
	end
	
	if ( z > -0.1 and z < 0.1 ) then
		vRet.z = 0
	end
	
	return vRet
end

if ( SERVER ) then
	--- BaseEntity
	-- For util.RadiusDamage fallback
	function ENTITY:Classify()
		return CLASS_NONE
	end
	
	--- CSGameRules
	// returns the percentage of the player that is visible from the given point in the world.
	// return value is between 0 and 1.
	function ENTITY:GetAmoutVisible( vSrc )
		return util.GetExplosionDamageAdjustment( vSrc, self:BodyTarget( vSrc ), self )
	end
	
	function ENTITY:PhysicsCheckSweep( vAbsStart, vAbsDelta )
		local iMask = MASK_SOLID -- FIXME: Support custom ent masks
		
		// Set collision type
		if ( not self:IsSolid() or self:SolidFlagSet( FSOLID_VOLUME_CONTENTS )) then
			if ( self:GetMoveParent() ~= NULL ) then
				return util.ClearTrace()
			end
			
			// don't collide with monsters
			iMask = bit.band( iMask, bit.bnot( CONTENTS_MONSTER ))
		end
		
		return util.TraceEntity( {
			start = vAbsStart,
			endpos = vAbsStart + vAbsDelta,
			filter = self,
			mask = iMask,
			collisiongroup = self:GetCollisionGroup()
		}, self )
	end
	
		function ENTITY:_SetAbsVelocity( vAbsVelocity )
		if ( self:GetInternalVariable( "m_vecAbsVelocity" ) ~= vAbsVelocity ) then
			// The abs velocity won't be dirty since we're setting it here
			self:RemoveEFlags( EFL_DIRTY_ABSVELOCITY )
			
			// All children are invalid, but we are not
			local tChildren = self:GetChildren()
				
			for i = 1, #tChildren do
				tChildren[i]:AddEFlags( EFL_DIRTY_ABSVELOCITY )
			end
			
			self:SetSaveValue( "m_vecAbsVelocity", vAbsVelocity )
			
			// NOTE: Do *not* do a network state change in this case.
			// m_vVelocity is only networked for the player, which is not manual mode
			local pMoveParent = self:GetMoveParent()
			
			if ( pMoveParent ~= NULL ) then
				// First subtract out the parent's abs velocity to get a relative
				// velocity measured in world space
				// Transform relative velocity into parent space
				--self:SetSaveValue( "m_vecVelocity", (vAbsVelocity - pMoveParent:_GetAbsVelocity()):IRotate( pMoveParent:EntityToWorldTransform() ) )
				self:SetSaveValue( "velocity", vAbsVelocity )
			else
				self:SetSaveValue( "velocity", vAbsVelocity )
			end
		end
	end
	
	--- CSGameRules
	function PLAYER:GetAmountVisible( vSrc )
		local vChest = self:BodyTarget( vSrc )
		local flChestZ = vChest[3]
		local vFeet = self:GetPos()
		local flPosX = vFeet[1]
		local flPosY = vFeet[2]
		local flPosZ = vFeet[3]
		local vMin, vMax = self:GetHull()
		local vHead = Vector( flPosX, flPosY, vMax[3] - vMin[3] + flPosZ )
		local vRightFacing = (vMax[2] - vMin[2]) / 2 * self:GetAngles():Right()
		local flFacingX = vRightFacing[1]
		local flFacingY = vRightFacing[2]
		local flFacingZ = vRightFacing[3]
		local vLeft = Vector( flPosX - flFacingX, flPosY - flFacingY, flChestZ )
		local vRight = Vector( flPosX + flFacingX, flPosY + flFacingY, flChestZ )
		
			// check chest
		return 0.4 * util.GetExplosionDamageAdjustment( vSrc, vChest, self )
			// check top of head
			+ 0.2 * util.GetExplosionDamageAdjustment( vSrc, vHead, self )
			// check feet
			+ 0.2 * util.GetExplosionDamageAdjustment( vSrc, vFeet, self )
			// check left "edge"
			+ 0.1 * util.GetExplosionDamageAdjustment( vSrc, vLeft, self )
			// check right "edge"
			+ 0.1 * util.GetExplosionDamageAdjustment( vSrc, vRight, self )
	end
	
	local vDefaultMax = Vector(50, 50, 50)
	local vDefaultMin = -vDefaultMax

	-- Create a wrapper for env_particlesmokegrenade since we are missing some engine methods
	local SMOKE = {
		FillVolume = function( self, vMin --[[= vDefaultMin]], vMax --[[= vDefaultMax]] )
			self:SetSaveValue( "m_CurrentStage", 1 )
			self:SetCollisionBounds( vMin or vDefaultMin, vMax or vDefaultMax )
		end,
		
		SetFadeTime = function( self, flStartTime, flEndTime )
			self:SetSaveValue( "m_FadeStartTime", flStartTime )
			self:SetSaveValue( "m_FadeEndTime", flEndTime )
		end,
		
		// Fade start and end are relative to current time
		SetRelativeFadeTime = function( self, flStartTime, flEndTime )
			local flTime = CurTime() - self.m_flSpawnTime
			
			self:SetSaveValue( "m_FadeStartTime", flTime + flStartTime )
			self:SetSaveValue( "m_FadeEndTime", flTime + flEndTime )
		end
	}

	local ENTITY = FindMetaTable( "Entity" )

	-- Inherit base entity functions
	function SMOKE.__index( t, k )
		local val = rawget( t, k ) or rawget( SMOKE, k ) or ENTITY[k]
		
		return isfunction( val ) and function( _, ... ) return val( t.m_pEntity, ... ) end or val	
	end

	function Smoke()
		local pEntity = ents.Create( "env_particlesmokegrenade" )
		pEntity.m_flSpawnTime = CurTime()
		pEntity:Spawn()
		
		return setmetatable({ m_pEntity = pEntity }, SMOKE )
	end

	function util.CSRadiusDamage( info, vSrc, flRadius, bIgnoreWorld --[[= false]], Filter --[[= NULL]], iClassIgnore --[[= CLASS_NONE]] )
		local flSrcZ = vSrc.z
		vSrc.z = flSrcZ + 1 // in case grenade is lying on the ground
		
		local bFilterTable = Filter and istable( Filter ) or false
		local iFilterLen = bFilterTable and #Filter or nil
		local flDamage = info:GetDamage()
		local flFalloff = flRadius == 0 and 1 or flDamage / flRadius
		local bInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
		local tEnts = ents.FindInSphere( vSrc, flRadius )
		
		// iterate on all entities in the vicinity.
		for i = 1, #tEnts do
			local pEntity = tEnts[i]
			
			if ( pEntity:GetInternalVariable( "m_takedamage" ) == 0 ) then
				continue
			end
			
			// UNDONE: this should check a damage mask, not an ignore
			if ( iClassIgnore and iClassIgnore ~= CLASS_NONE and pEntity:Classify() == iClassIgnore ) then
				// houndeyes don't hurt other houndeyes with their attack
				continue
			end
			
			if ( Filter ) then
				if ( bFilterTable ) then
					local bPass = false
					
					for i = 1, iFilterLen do
						if ( pEntity == Filter[i] ) then
							bPass = true
							
							break
						end
					end
					
					if ( bPass ) then
						continue
					end
				elseif ( pEntity == Filter ) then
					continue
				end
			end
			
			// blasts don't travel into or out of water
			if ( not bIgnoreWorld ) then
				if ( bInWater ) then
					if ( pEntity:WaterLevel() == 0 ) then
						continue
					end
				else
					if ( pEntity:WaterLevel() == 3 ) then
						continue
					end
				end
			end
			
			// radius damage can only be blocked by the world
			local flDamagePercentage = bIgnoreWorld and 1 or pEntity:GetAmountVisible( vSrc )
			
			if ( flDamagePercentage > 0 ) then
				// the explosion can 'see' this entity, so hurt them!
				local vSpot = pEntity:BodyTarget( vSrc, true )
				local vTarget = vSpot - vSrc
				
				// decrease damage for an ent that's farther from the bomb.
				local flAdjustedDamage = (flDamage - vTarget:Length() * flFalloff) * flDamagePercentage
				
				if ( flAdjustedDamage > 0 ) then
					-- https://github.com/Facepunch/garrysmod-issues/issues/2771
					local infoAdjusted = info --:Copy()
					infoAdjusted:SetDamage( flAdjustedDamage )
					vTarget:Normalize()
					
					local vPos = infoAdjusted:GetDamagePosition()
					local vForce = infoAdjusted:GetDamageForce()
					infoAdjusted:SetDamagePosition( vSrc )
					
					// If we don't have a damage force, manufacture one
					if ( vPos == vector_origin or vForce == vector_origin ) then
						// Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
						local flForceScale = infoAdjusted:GetBaseDamage() * 300
						
						if ( flForceScale > 30000 ) then
							flForceScale = 30000
						end
						
						// Fudge blast forces a little bit, so that each
						// victim gets a slightly different trajectory. 
						// This simulates features that usually vary from
						// person-to-person variables such as bodyweight,
						// which are all indentical for characters using the same model.
						infoAdjusted:SetDamageForce( vTarget * flForceScale * gsrand:RandomFloat(0.85, 1.15) * phys_pushscale:GetFloat() * 1.5 )
					else
						// Assume the force passed in is the maximum force. Decay it based on falloff.
						infoAdjusted:SetDamageForce( vTarget * vForce:Length() * flFalloff )
					end
					
					local tr = util.TraceLine({
						start = vSrc,
						endpos = pEntity:BodyTarget( vSrc ),
						mask = MASK_SHOT
					})
					
					if ( tr.Fraction == 1 ) then
						pEntity:TakeDamageInfo( infoAdjusted )
					else
						pEntity:DispatchTraceAttack( infoAdjusted, tr, vTarget )
					end
					
					-- https://github.com/Facepunch/garrysmod-requests/issues/755
					// Now hit all triggers along the way that respond to damage... 
					--pEntity:TraceAttackToTriggers( infoAdjusted, vSrc, vSpot, vTarget )
				end
			end
		end
		
		-- Restore the vector
		vSrc.z = flSrcZ
	end

	function util.SDKRadiusDamage( info, vSrc, flRadius, bIgnoreWorld --[[= false]], Filter --[[= NULL]], iClassIgnore --[[= CLASS_NONE]] )
		local flSrcZ = vSrc.z
		vSrc.z = flSrcZ + 1 // in case grenade is lying on the ground
		
		local bFilterTable = Filter and istable( Filter ) or false
		local iFilterLen = bFilterTable and #Filter or nil
		local flDamage = info:GetDamage()
		local flFalloff = flRadius == 0 and 1 or flDamage / flRadius
		local bInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
		local tEnts = ents.FindInSphere( vSrc, flRadius )
		
		// iterate on all entities in the vicinity.
		for i = 1, #tEnts do
			local pEntity = tEnts[i]
			
			if ( pEntity:GetInternalVariable( "m_takedamage" ) == 0 ) then
				continue
			end
			
			// UNDONE: this should check a damage mask, not an ignore
			if ( iClassIgnore and iClassIgnore ~= CLASS_NONE and pEntity:Classify() == iClassIgnore ) then
				// houndeyes don't hurt other houndeyes with their attack
				continue
			end
			
			if ( Filter ) then
				if ( bFilterTable ) then
					local bPass = false
					
					for i = 1, iFilterLen do
						if ( pEntity == Filter[i] ) then
							bPass = true
							
							break
						end
					end
					
					if ( bPass ) then
						continue
					end
				elseif ( pEntity == Filter ) then
					continue
				end
			end
			
			// blasts don't travel into or out of water
			if ( not bIgnoreWorld ) then
				if ( bInWater ) then
					if ( pEntity:WaterLevel() == 0 ) then
						continue
					end
				else
					if ( pEntity:WaterLevel() == 3 ) then
						continue
					end
				end
			end
			
			local vSpot
			
			if ( bIgnoreWorld ) then
				vSpot = pEntity:BodyTarget( vSrc, true )
			else
				local tr = util.TraceLine({
					start = vSrc,
					endpos = pEntity:BodyTarget( vSrc, true ),
					mask = MASK_SOLID_BRUSHONLY,
					filter = info:GetInflictor()
				})
				
				if ( not tr.StartSolid and tr.Fraction == 1 or tr.Entity == pEntity ) then
					vSpot = tr.StartSolid and vSrc or tr.HitPos
				end
			end
			
			if ( vSpot ) then
				// the explosion can 'see' this entity, so hurt them!
				local vTarget = vSpot - vSrc
				
				// decrease damage for an ent that's farther from the bomb.
				local flAdjustedDamage = flDamage - vTarget:Length() * flFalloff
				
				if ( flAdjustedDamage > 0 ) then
					-- https://github.com/Facepunch/garrysmod-issues/issues/2771
					local infoAdjusted = info --:Copy()
					infoAdjusted:SetDamage( flAdjustedDamage )
					vTarget:Normalize()
					
					local vPos = infoAdjusted:GetDamagePosition()
					local vForce = infoAdjusted:GetDamageForce()
					infoAdjusted:SetDamagePosition( vSrc )
					
					// If we don't have a damage force, manufacture one
					if ( vPos == vector_origin or vForce == vector_origin ) then
						// Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
						local flForceScale = infoAdjusted:GetBaseDamage() * 300
						
						if ( flForceScale > 30000 ) then
							flForceScale = 30000
						end
						
						// Fudge blast forces a little bit, so that each
						// victim gets a slightly different trajectory. 
						// This simulates features that usually vary from
						// person-to-person variables such as bodyweight,
						// which are all indentical for characters using the same model.
						infoAdjusted:SetDamageForce( vTarget * flForceScale * gsrand:RandomFloat(0.85, 1.15) * phys_pushscale:GetFloat() * 1.5 )
					else
						// Assume the force passed in is the maximum force. Decay it based on falloff.
						infoAdjusted:SetDamageForce( vTarget * vForce:Length() * flFalloff )
					end
					
					pEntity:TakeDamageInfo( infoAdjusted )
					
					-- https://github.com/Facepunch/garrysmod-requests/issues/755
					// Now hit all triggers along the way that respond to damage... 
					--pEntity:TraceAttackToTriggers( infoAdjusted, vSrc, vSpot, vTarget )
				end
			end
		end
		
		-- Restore the vector
		vSrc.z = flSrcZ
	end

	// return a multiplier that should adjust the damage done by a blast at position vecSrc to something at the position
	// vecEnd.  This will take into account the density of an entity that blocks the line of sight from one position to
	// the other.
	//
	// this algorithm was taken from the HL2 version of RadiusDamage.
	local DENSITY_ABSORB_ALL_DAMAGE = 3000

	function util.GetExplosionDamageAdjustment( vSrc, vEnd, Filter )
		local tr = util.TraceLine({
			start = vSrc,
			endpos = vEnd,
			mask = MASK_SHOT,
			filter = Filter
		})
		
		if ( tr.Fraction == 1 ) then
			return 1
		end
		
		if ( tr.HitWorld ) then
			return 0
		end
		
		local pEntity = tr.Entity
		
		if ( pEntity == NULL or isentity( Filter ) and pEntity:GetOwner() == Filter ) then
			return 0
		end
		
		if ( istable( Filter )) then
			for i = 1, #Filter do
				if ( Filter[i] == pEntity ) then
					return 0
				end
			end
		end
		
		// if we didn't hit world geometry perhaps there's still damage to be done here.
		// check to see if this part of the player is visible if entities are ignored.
		util.TraceLine({
			start = vSrc,
			endpos = vEnd,
			mask = CONTENTS_SOLID,
			output = tr
		})
		
		if ( tr.Fraction == 1 ) then
			local pPhysicsObj = pEntity:GetPhysicsObject()
			
			if ( pEntity == NULL or pPhysicsObj:IsValid() ) then
				return 0.75 // we're blocked by something that isn't an entity with a physics module or world geometry, just cut damage in half for now.
			end
			
			local flScale = pPhysicsObj:GetDensity() / DENSITY_ABSORB_ALL_DAMAGE
			
			if ( flScale < 1 ) then
				return 1 - flScale
			end
		end
		
		return 0
	end
else
	--- BaseEntity
	function ENTITY:SetDormant( bDormant )
		self:AddEFlags( EFL_DORMANT )
		self:SetNoDraw( true )
		
		local pParent = self:GetParent()
		
		if ( pParent ~= NULL ) then
			pParent:SetDormant( bDormant ) -- Recursion
		end
	end

	function ENTITY:PhysicsCheckSweep( vAbsStart, vAbsDelta )
		local iMask = MASK_SOLID -- FIXME: Support custom ent masks
		
		// Set collision type
		if ( not self:IsSolid() or self:SolidFlagSet( FSOLID_VOLUME_CONTENTS )) then
			// don't collide with monsters
			iMask = bit.band( iMask, bit.bnot( CONTENTS_MONSTER ))
		end
		
		local vMins, vMaxs = self:WorldSpaceAABB()
		
		return util.TraceHull( {
			start = vAbsStart,
			endpos = vAbsStart + vAbsDelta,
			mins = vMins,
			maxs = vMaxs,
			filter = self,
			mask = iMask,
			collisiongroup = self:GetCollisionGroup()
		}, self )
	end

	function ENTITY:_SetAbsVelocity( vAbsVelocity )
		-- No equivalent; do nothing
	end
	
	function WEAPON:SetDormant( bDormant )
		// If I'm going from active to dormant and I'm carried by another player, holster me.
		if ( bDormant and not self:IsDormant() and not self:IsCarriedByLocalPlayer() ) then
			self:Holster( NULL )
		end
		
		ENTITY.SetDormant( self, bDormant ) -- Weapon metatable baseclass
	end
end

local band = bit.band
local bnot = bit.bnot
local bor = bit.bor
local bxor = bit.bxor
local floor = math.floor

// The four core functions - F1 is optimized somewhat
// local function f1(x, y, z) bit.bor( bit.band( x, y ), bit.band( bit.bnot( x ), z )) end
// This is the central step in the MD5 algorithm.
local function Step1( w, x, y, z, flData, iStep )
	w = w + bxor( z, band( x, bxor( y, z ))) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

local function Step2( w, x, y, z, flData, iStep )
	w = w + bxor( y, band( z, bxor( x, y ))) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

local function Step3( w, x, y, z, flData, iStep )
	w = w + bxor( bxor( x, y ), z ) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

local function Step4( w, x, y, z, flData, iStep )
	w = w + bxor( y, bor( x, bnot( z ))) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

function math.MD5Random( nSeed )
	-- https://github.com/Facepunch/garrysmod-issues/issues/2820
	local bEnabled = jit.status()
	
	if ( bEnabled ) then
		jit.off()
	end
	
	nSeed = nSeed % 0x100000000
	
	local a = Step1(0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, nSeed + 0xd76aa478, 7)
	local d = Step1(0x10325476, a, 0xefcdab89, 0x98badcfe, 0xe8c7b7d6, 12)
	local c = Step1(0x98badcfe, d, a, 0xefcdab89, 0x242070db, 17)
	local b = Step1(0xefcdab89, c, d, a, 0xc1bdceee, 22)
	a = Step1(a, b, c, d, 0xf57c0faf, 7)
	d = Step1(d, a, b, c, 0x4787c62a, 12)
	c = Step1(c, d, a, b, 0xa8304613, 17)
	b = Step1(b, c, d, a, 0xfd469501, 22)
	a = Step1(a, b, c, d, 0x698098d8, 7)
	d = Step1(d, a, b, c, 0x8b44f7af, 12)
	c = Step1(c, d, a, b, 0xffff5bb1, 17)
	b = Step1(b, c, d, a, 0x895cd7be, 22)
	a = Step1(a, b, c, d, 0x6b901122, 7)
	d = Step1(d, a, b, c, 0xfd987193, 12)
	c = Step1(c, d, a, b, 0xa67943ae, 17)
	b = Step1(b, c, d, a, 0x49b40821, 22)
	
	a = Step2(a, b, c, d, 0xf61e25e2, 5)
	d = Step2(d, a, b, c, 0xc040b340, 9)
	c = Step2(c, d, a, b, 0x265e5a51, 14)
	b = Step2(b, c, d, a, nSeed + 0xe9b6c7aa, 20)
	a = Step2(a, b, c, d, 0xd62f105d, 5)
	d = Step2(d, a, b, c, 0x02441453, 9)
	c = Step2(c, d, a, b, 0xd8a1e681, 14)
	b = Step2(b, c, d, a, 0xe7d3fbc8, 20)
	a = Step2(a, b, c, d, 0x21e1cde6, 5)
	d = Step2(d, a, b, c, 0xc33707f6, 9)
	c = Step2(c, d, a, b, 0xf4d50d87, 14)
	b = Step2(b, c, d, a, 0x455a14ed, 20)
	a = Step2(a, b, c, d, 0xa9e3e905, 5)
	d = Step2(d, a, b, c, 0xfcefa3f8, 9)
	c = Step2(c, d, a, b, 0x676f02d9, 14)
	b = Step2(b, c, d, a, 0x8d2a4c8a, 20)

	a = Step3(a, b, c, d, 0xfffa3942, 4)
	d = Step3(d, a, b, c, 0x8771f681, 11)
	c = Step3(c, d, a, b, 0x6d9d6122, 16)
	b = Step3(b, c, d, a, 0xfde5382c, 23)
	a = Step3(a, b, c, d, 0xa4beeac4, 4)
	d = Step3(d, a, b, c, 0x4bdecfa9, 11)
	c = Step3(c, d, a, b, 0xf6bb4b60, 16)
	b = Step3(b, c, d, a, 0xbebfbc70, 23)
	a = Step3(a, b, c, d, 0x289b7ec6, 4)
	d = Step3(d, a, b, c, nSeed + 0xeaa127fa, 11)
	c = Step3(c, d, a, b, 0xd4ef3085, 16)
	b = Step3(b, c, d, a, 0x04881d05, 23)
	a = Step3(a, b, c, d, 0xd9d4d039, 4)
	d = Step3(d, a, b, c, 0xe6db99e5, 11)
	c = Step3(c, d, a, b, 0x1fa27cf8, 16)
	b = Step3(b, c, d, a, 0xc4ac5665, 23)
	
	a = Step4(a, b, c, d, nSeed + 0xf4292244, 6)
	d = Step4(d, a, b, c, 0x432aff97, 10)
	c = Step4(c, d, a, b, 0xab9423c7, 15)
	b = Step4(b, c, d, a, 0xfc93a039, 21)
	a = Step4(a, b, c, d, 0x655b59c3, 6)
	d = Step4(d, a, b, c, 0x8f0ccc92, 10)
	c = Step4(c, d, a, b, 0xffeff47d, 15)
	b = Step4(b, c, d, a, 0x85845e51, 21)
	a = Step4(a, b, c, d, 0x6fa87e4f, 6)
	d = Step4(d, a, b, c, 0xfe2ce6e0, 10)
	c = Step4(c, d, a, b, 0xa3014314, 15)
	b = Step4(b, c, d, a, 0x4e0811a1, 21)
	a = Step4(a, b, c, d, 0xf7537e82, 6)
	d = Step4(d, a, b, c, 0xbd3af235, 10)
	c = Step4(c, d, a, b, 0x2ad7d2bb, 15)
	b = (Step4(b, c, d, a, 0xeb86d391, 21) + 0xefcdab89) % 0x100000000
	
	c = (c + 0x98badcfe) % 0x100000000
	a = floor( b / 0x10000 ) % 0x100 + floor( b / 0x1000000 ) % 0x100 * 0x100 + c % 0x100 * 0x10000 + floor( c / 0x100 ) % 0x100 * 0x1000000
	
	if ( bEnabled ) then
		jit.on()
	end
	
	return a
end

--- Lua functions
function PHYSOBJ:GetDensity()
	return self:GetMass() / self:GetVolume()
end

local tValidSoundExtensions = {
	wav = true,
	mp3 = true,
	ogg = true,
	-- mid = false,
	-- flac = false
}

-- Since only three-letter sound extensions are valid
-- This function can get away with only checking the last three characters of the string
function string.IsSoundFile( str )
	return tValidSoundExtensions[string.sub( str, -3 )] or false
end

local temptbl = {}

local function MergeSort( tbl, iLow, iHigh, bReverse )
	if ( iLow < iHigh ) then
		local iMiddle = math.floor( iLow + (iHigh - iLow) / 2 )
		MergeSort( tbl, iLow, iMiddle, bReverse )
		MergeSort( tbl, iMiddle + 1, iHigh, bReverse )
		
		for i = iLow, iHigh do
			temptbl[i] = tbl[i]
		end
		
		local i = iLow
		local j = iMiddle + 1
		local k = iLow
		
		while ( i <= iMiddle and j <= iHigh ) do
			if ( temptbl[i] <= temptbl[j] ) then
				if ( bReverse ) then
					tbl[k] = temptbl[j]
					j = j + 1
				else
					tbl[k] = temptbl[i]
					i = i + 1
				end
			else
				if ( bReverse ) then
					tbl[k] = temptbl[i]
					i = i + 1
				else
					tbl[k] = temptbl[j]
					j = j + 1
				end
			end
			
			k = k + 1
		end
		
		while ( i <= iMiddle ) do
			tbl[k] = temptbl[i]
			k = k + 1
			i = i + 1
		end
	end
end

local function MergeSortMember( tbl, iLow, iHigh, bReverse, sMember )
	if ( iLow < iHigh ) then
		local iMiddle = math.floor( iLow + (iHigh - iLow) / 2 )
		MergeSortMember( tbl, iLow, iMiddle, bReverse, sMember )
		MergeSortMember( tbl, iMiddle + 1, iHigh, bReverse, sMember )
		
		for i = iLow, iHigh do
			temptbl[i] = tbl[i][sMember]
		end
		
		local i = iLow
		local j = iMiddle + 1
		local k = iLow
		
		while ( i <= iMiddle and j <= iHigh ) do
			if ( temptbl[i] <= temptbl[j] ) then
				tbl[k][sMember] = temptbl[i]
				i = i + 1
			else
				tbl[k][sMember] = temptbl[j]
				j = j + 1
			end
			
			k = k + 1
		end
		
		while ( i <= iMiddle ) do
			tbl[k][sMember] = temptbl[i]
			k = k + 1
			i = i + 1
		end
	end
end

function table.MergeSort( tbl, bReverse, sMember )
	if ( sMember ) then
		MergeSortMember( tbl, 1, #tbl, bReverse, sMember )
	else
		MergeSort( tbl, 1, #tbl, bReverse )
	end
	
	return tbl
end

--- Trace
function util.ClearTrace()
	return {
		Entity = NULL,
		Fraction = 1,
		FractionLeftSolid = 0,
		Hit = false,
		HitBox = 0,
		HitGroup = 0,
		HitNoDraw = false,
		HitNonWorld = false,
		HitNormal = Vector(0, 0, 0),
		HitPos = Vector(0, 0, 0),
		HitSky = false,
		HitTexture = "**empty**",
		HitWorld = false,
		MatType = 0,
		Normal = Vector(0, 0, 0),
		PhysicsBone = 0,
		StartPos = Vector(0, 0, 0),
		SurfaceProps = 0,
		StartSolid = false,
		AllSolid = false
	}
end

--- Util
-- https://github.com/Facepunch/garrysmod-requests/issues/664
function util.ClipRayToEntity( tbl, pEnt )
	return util.TraceEntity( tbl, pEnt )
end

function util.ClipTraceToPlayers( tbl, tr, flMaxRange --[[= 60]] )
	flMaxRange = (flMaxRange or 60) ^ 2
	tbl.output = nil
	local vAbsStart = tbl.start
	local vAbsEnd = tbl.endpos
	local Filter = tbl.filter
	local flSmallestFraction = tr.Fraction
	local tPlayers = player.GetAll()
	local trOutput
	
	for i = 1, #tPlayers do
		local pPlayer = tPlayers[i]
		
		if ( not pPlayer:Alive() or pPlayer:IsDormant() ) then
			continue
		end
		
		-- Don't bother to trace if the player is in the filter
		if ( isentity( Filter )) then
			if ( Filter == pPlayer ) then
				continue
			end
		elseif ( istable( Filter )) then
			local bFound = false
			
			for i = 1, #Filter do
				if ( Filter[i] == pPlayer ) then
					bFound = true
					
					break
				end
			end
			
			if ( bFound ) then
				continue
			end
		end
		
		local flRange = pPlayer:WorldSpaceCenter():DistanceSqrToRay( vAbsStart, vAbsEnd )
		
		if ( flRange < 0 or flRange > flMaxRange ) then
			continue
		end
		
		local trTemp = util.ClipRayToEntity( tbl, pPlayer )
		local flFrac = trTemp.Fraction
		
		if ( flFrac < flSmallestFraction ) then
			// we shortened the ray - save off the trace
			trOutput = trTemp
			flSmallestFraction = flFrac
		end
	end
	
	if ( trOutput ) then
		table.CopyFromTo( trOutput, tr )
	end
	
	return tr
end

--- CS:S/DoD:S melee
function util.FindHullIntersection( tbl, tr )
	local iDist = 1e12
	tbl.output = nil
	local vSrc = tbl.start
	local vHullEnd = vSrc + (tr.HitPos - vSrc) * 2
	tbl.endpos = vHullEnd
	local tBounds = { tbl.mins, tbl.maxs }
	local trTemp = util.TraceLine( tbl )
	
	if ( trTemp.Fraction ~= 1 ) then
		table.CopyFromTo( trTemp, tr )
		
		return tr
	end
	
	local trOutput
	
	for i = 1, 2 do
		for j = 1, 2 do
			for k = 1, 2 do
				tbl.endpos = Vector( vHullEnd.x + tBounds[i].x, 
					vHullEnd.y + tBounds[j].y,
					vHullEnd.z + tBounds[k].z )
				
				local trTemp = util.TraceLine( tbl )
				
				if ( trTemp.Fraction ~= 1 ) then
					local iHitDistSqr = (trTemp.HitPos - vSrc):LengthSqr()
					
					if ( iHitDistSqr < iDist ) then
						trOutput = trTemp
						iDist = iHitDistSqr
					end
				end
			end
		end
	end
	
	if ( trOutput ) then
		table.CopyFromTo( trOutput, tr )
	end
	
	return tr
end

local sCRC = "%i%i%s"

function util.SeedFileLineHash( iSeed, sName, iAdditionalSeed --[[= 0]] )
	return tonumber( util.CRC( sCRC:format( iSeed, iAdditionalSeed or 0, sName )))
end

-- https://github.com/Facepunch/garrysmod-issues/issues/2543
function WEAPON:GetActivityBySequence( iIndex )
	local pViewModel = self:GetOwner():GetViewModel( iIndex )
	
	return pViewModel == NULL and ACT_INVALID or pViewModel:GetSequenceActivity( pViewModel:GetSequence() )
end

-- https://github.com/Facepunch/garrysmod-requests/issues/703
function WEAPON:GetPrimaryAmmoCount()
	return 1
end

function WEAPON:GetSecondaryAmmoCount()
	return 1
end

--[[function WEAPON:HasAmmo()
	return self:HasPrimaryAmmo() or self:HasSecondaryAmmo()
end]]

function WEAPON:HasPrimaryAmmo()
	-- Melee/utility weapons always have ammo
	if ( self:GetMaxClip1() == -1 and self:GetMaxClip2() == -1 ) then
		return true
	end
	
	// If I use a clip, and have some ammo in it, then I have ammo
	if ( self:Clip1() ~= 0 ) then
		return true
	end
	
	// Otherwise, I have ammo if I have some in my ammo counts
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		// No owner, so return how much primary ammo I have along with me
		if ( self:GetPrimaryAmmoCount() > 0 ) then
			return true
		end
	elseif ( pPlayer:GetAmmoCount( self:GetPrimaryAmmoType() ) > 0) then
		return true
	end
	
	return false 
end

function WEAPON:HasSecondaryAmmo()
	if ( self:GetMaxClip2() == -1 and self:GetMaxClip1() == -1 ) then
		return true
	end
	
	if ( self:Clip2() ~= 0 ) then
		return true
	end
		
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		// No owner, so return how much secondary ammo I have along with me
		if ( self:GetSecondaryAmmoCount() > 0 ) then
			return true
		end
	elseif ( pPlayer:GetAmmoCount( self:GetSecondaryAmmoType() ) > 0 ) then
		return true
	end
	
	return false
end

function WEAPON:IsActiveWeapon()
	local pPlayer = self:GetOwner()
	
	return pPlayer ~= NULL and pPlayer:GetActiveWeapon() == self
end

function WEAPON:IsViewModelSequenceFinished( iIndex )
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return false
	end
	
	local vm = pPlayer:GetViewModel( iIndex )
	
	if ( vm == NULL ) then
		return false
	end
	
	local iActivity = self:GetActivityBySequence()
	
	// These are not valid activities and always complete immediately
	if ( iActivity == ACT_RESET or iActivity == ACT_INVALID or vm:GetInternalVariable( "m_bSequenceFinished" )) then
		return true
	end
	
	-- https://github.com/Facepunch/garrysmod-requests/issues/704
	return false
end

function WEAPON:IsVisible( iIndex )
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then 
		return false 
	end
	
	local vm = pPlayer:GetViewModel( iIndex )
	
	return vm ~= NULL and vm:IsVisible()
end

-- https://github.com/Facepunch/garrysmod-issues/issues/2856
function WEAPON:SequenceEnd( iIndex )
	local pPlayer = self:GetOwner()
	
	if ( pPlayer ~= NULL ) then
		local pViewModel = pPlayer:GetViewModel( iIndex )
		
		if ( pViewModel ~= NULL ) then
			return (1 - pViewModel:GetCycle()) * pViewModel:SequenceDuration()
		end
	end
	
	return 0
end

-- Add multiple viewmodel support to SequenceDuration
-- https://github.com/Facepunch/garrysmod-issues/issues/2783
function WEAPON:SequenceLength( iIndex, iSequence )
	local pPlayer = self:GetOwner()
	
	if ( pPlayer ~= NULL ) then
		local pViewModel = pPlayer:GetViewModel( iIndex )
		
		if ( pViewModel ~= NULL ) then
			-- Workaround for "CBaseAnimating::SequenceDuration( 0 ) NULL pstudiohdr on predicted_viewmodel!"
			if ( iSequence ) then
				return pViewModel:SequenceDuration( iSequence )
			else
				return pViewModel:SequenceDuration()
			end
		end
	end
	
	return 0
end
