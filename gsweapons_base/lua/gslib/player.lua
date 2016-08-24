local PLAYER = _R.Player

function PLAYER:SetupWeaponDataTables()
	self:DTVar( "Int", 0, "ShotsFired" )
end

function PLAYER:GetShotsFired()
	return self.dt and self.dt.ShotsFired or 0
end

function PLAYER:SetShotsFired( iShots )
	if ( self.dt ) then
		self.dt.ShotsFired = iShots
	end
end

-- Shared version of SelectWeapon
function PLAYER:SwitchWeapon( weapon )
	if ( isstring( weapon )) then
		local pWeapon = self:GetWeapon( weapon )
		
		if ( pWeapon ~= NULL ) then
			self.m_pNewWeapon = pWeapon
		end
	elseif ( weapon:GetOwner() == self ) then
		self.m_pNewWeapon = weapon
	end
end

-- Handles weapon switching
hook.Add( "StartCommand", "GSBase-Shared SelectWeapon", function( pPlayer, cmd )
	if ( pPlayer.m_pNewWeapon ) then
		if ( pPlayer.m_pNewWeapon == NULL or pPlayer.m_pNewWeapon == pPlayer:GetActiveWeapon() ) then
			pPlayer.m_pNewWeapon = nil
		else
			cmd:SelectWeapon( pPlayer.m_pNewWeapon )
		end
	end
end )

-- Fix; check with prediction
-- Scales the player's movement speeds based on their weapon
hook.Add( "Move", "GSBase-Weapon speed", function( pPlayer, mv )
	local pActiveWeapon = pPlayer:GetActiveWeapon()
	
	if ( pActiveWeapon.GetWalkSpeed ) then
		local flOldSpeed = mv:GetMaxSpeed() *
			(pPlayer:KeyDown( IN_SPEED ) and pActiveWeapon:GetRunSpeed() or pActiveWeapon:GetWalkSpeed())
		
		mv:SetMaxSpeed( flOldSpeed )
		mv:SetMaxClientSpeed( flOldSpeed )
	end
end )

function PLAYER:SharedRandomFloat( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetPredictionSeed(), sName, iAdditionalSeed ))
	
	return random.RandomFloat( flMin, flMax )
end

function PLAYER:SharedRandomInt( sName, iMin, iMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetPredictionSeed(), sName, iAdditionalSeed ))
	
	return random.RandomInt( iMin, iMax )
end

function PLAYER:SharedRandomVector( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetPredictionSeed(), sName, iAdditionalSeed ))

	return Vector( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ) )
end

function PLAYER:SharedRandomAngle( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetPredictionSeed(), sName, iAdditionalSeed ))

	return Angle( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

function PLAYER:SharedRandomColor( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetPredictionSeed(), sName, iAdditionalSeed ))
	
	return Color( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

local PseudoRandom = hash.PseudoRandom
local CommandNumber = _R.CUserCmd.CommandNumber

-- Only supports players
PLAYER.m_iPredictionRandomSeed = -1

hook.Add( "StartCommand", "GSBase-Prediction seed", function( _, cmd )
	PLAYER.m_iPredictionRandomSeed = PseudoRandom( CommandNumber( cmd )) % 0x80000000
end )

function PLAYER:GetPredictionSeed()
	return self.m_iPredictionRandomSeed
end

local ai_shot_bias_min = GetConVar( "ai_shot_bias_min" )
local ai_shot_bias_max = GetConVar( "ai_shot_bias_max" )
local ai_debug_shoot_positions = GetConVar( "ai_debug_shoot_positions" )
local phys_pushscale = GetConVar( "phys_pushscale" )
local sv_showimpacts = CreateConVar( "sv_showimpacts", "0", FCVAR_REPLICATED, "Shows client (red) and server (blue) bullet impact point (1=both, 2=client-only, 3=server-only)" )
local sv_showpenetration = CreateConVar( "sv_showpenetration", "0", FCVAR_REPLICATED, "Shows penetration trace (if applicable) when the weapon fires" )
local sv_showplayerhitboxes = CreateConVar( "sv_showplayerhitboxes", "0", FCVAR_REPLICATED, "Show lag compensated hitboxes for the specified player index whenever a player fires." )

local iTracerCount = 0 -- Global to interact with FireCSBullets

-- Player only as NPCs could not be overrided to use this function
function PLAYER:LuaFireBullets( bullets )
	if ( hook.Run( "EntityFireBullets", self, bullets ) == false ) then
		return
	end
	
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
	local vDir = bullets.Dir or self:GetAimVector()
	local flDistance = bullets.Distance or MAX_TRACE_LENGTH
	local tFilter = bullets.Filter or self
	local iFlags = bullets.Flags or 0
	local flForce = bullets.Force or 1
	local iGibDamage = bullets.GibDamage or 16
	local flHullSize = bullets.HullSize or 3
	local pInflictor = bullets.Inflictor and bullets.Inflictor ~= NULL and bullets.Inflictor or bWeaponInvalid and self or pWeapon
	local iMask = bullets.Mask or MASK_SHOT
	local iNPCDamage = bullets.NPCDamage or 0
	local iNum = bullets.Num or 1
	local iPlayerDamage = bullets.PlayerDamage or 0
	local vSpread = bullets.Spread or vector_origin
	local flSpreadBias = bullets.SpreadBias or 1
	
	if ( flSpreadBias > 1 ) then
		flSpreadBias = 1
	elseif ( flSpreadBias < 0 ) then
		flSpreadBias = 0
	end
	
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
	local bDebugShoot = ai_debug_shoot_positions:GetBool()
	local bFirstShotInaccurate = bit.band( iFlags, FIRE_BULLETS_FIRST_SHOT_ACCURATE ) == 0
	local flPhysPush = phys_pushscale:GetFloat()
	local bShowPenetration = sv_showpenetration:GetBool()
	local bStartedInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
	local bFirstTimePredicted = IsFirstTimePredicted()
	local flShotBias, flFlatness, flSpreadX, flSpreadY, vFireBulletMax, vFireBulletMin, vSpreadRight, vSpreadUp
	
	// Wrap it for network traffic so it's the same between client and server
	local iSeed = self:GetPredictionSeed() % 0x100 - 1
	
	-- Don't calculate stuff we won't end up using
	if ( bFirstShotInaccurate or iNum ~= 1 ) then
		local flBiasMin = ai_shot_bias_min:GetFloat()
		flShotBias = (ai_shot_bias_max:GetFloat() - flBiasMin) * flSpreadBias + flBiasMin
		flFlatness = flShotBias / (flShotBias < 0 and -2 or 2)
		flSpreadX = vSpread.x
		flSpreadY = vSpread.y
		vFireBulletMax = Vector( flHullSize, flHullSize, flHullSize )
		vFireBulletMin = -vFireBulletMax
		vSpreadRight = vSpread:Right()
		vSpreadUp = vSpread:Up()
	end
	
	//Adrian: visualize server/client player positions
	//This is used to show where the lag compesator thinks the player should be at.
	local iHitNum = sv_showplayerhitboxes:GetInt()
	
	if ( iHitNum > 0 ) then
		local pLagPlayer = Player( iHitNum )
		
		if ( pLagPlayer ~= NULL ) then
			pLagPlayer:DrawHitBoxes(DEBUG_LENGTH)
		end
	end
	
	iHitNum = sv_showimpacts:GetInt()
	
	self:LagCompensation( true )
	
	for iShot = 1, iNum do
		local vShotDir
		iSeed = iSeed + 1 // use new seed for next bullet
		random.SetSeed( iSeed ) // init random system with this seed
		
		// If we're firing multiple shots, and the first shot has to be ba on target, ignore spread
		if ( iShot ~= 1 or bFirstShotInaccurate ) then
			local x
			local y
			local z

			repeat
				x = random.RandomFloat(-1, 1) * flFlatness + random.RandomFloat(-1, 1) * (1 - flFlatness)
				y = random.RandomFloat(-1, 1) * flFlatness + random.RandomFloat(-1, 1) * (1 - flFlatness)

				if ( flShotBias < 0 ) then
					x = x < 0 and -1 - x or 1 - x
					y = y < 0 and -1 - y or 1 - y
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
					filter = tFilter
				})
			or
				util.TraceLine({
					start = vNewSrc,
					endpos = vEnd,
					mask = iMask,
					filter = tFilter
				})
			
			--[[if ( SERVER ) then
				if ( bHitWater ) then
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
			local bHitWater = bStartedInWater
			local bEndNotWater = bit.band( util.PointContents( tr.HitPos ), MASK_WATER ) == 0
			
			-- The bullet left the water
			if ( bHitWater and bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vEnd,
							endpos = vNewSrc,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
				end
			// See if the bullet ended up underwater + started out of the water
			elseif ( not bHitWater and not bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vNewSrc,
							endpos = vEnd,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
					
					--[[local pWaterBullet = ents.Create( "waterbullet" )
					
					if ( pWaterBullet ~= NULL ) then
						pWaterBullet:SetPos( trWater.HitPos )
						pWaterBullet:_SetAbsVelocity( vDir * 1500 )
						
						-- Re-use EffectData
							data:SetStart( trWater.HitPos )
							data:SetOrigin( trWater.HitPos + vDir * 400 )
							data:SetFlags( TRACER_TYPE_WATERBULLET )
						util.Effect( "TracerSound", data )
					end]]
				end
			
				bHitWater = true
			end
			
			if ( tr.HitSky or tr.Fraction == 1 or pEntity == NULL ) then
				break // we didn't hit anything, stop tracing shoot
			end
			
			// draw server impact markers
			if ( iHitNum == 1 or (CLIENT and iHitNum == 2) or (SERVER and iHitNum == 3) ) then
				debugoverlay.Box( vHitPos, vector_debug_min, vector_debug_max, DEBUG_LENGTH, color_debug )
			end
			
			// do damage, paint decals
			-- https://github.com/Facepunch/garrysmod-issues/issues/2741
			bHitGlass = --[[tr.MatType == MAT_GLASS]] pEntity:GetClass():find( "func_breakable", 1, true ) and not pEntity:HasSpawnFlags( SF_BREAK_NO_BULLET_PENETRATION )
			local iActualDamageType = iAmmoDamageType
			
			if ( not bHitWater or bit.band( iFlags, FIRE_BULLETS_DONT_HIT_UNDERWATER ) == 0 ) then
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
				
				if ( iActualDamage >= iGibDamage ) then
					iActualDamageType = bit.bor( iAmmoDamageType, DMG_ALWAYSGIB )
				end
				
				// Damage specified by function parameter
				local info = DamageInfo()
					info:SetAttacker( pAttacker )
					info:SetInflictor( pInflictor )
					info:SetDamage( iActualDamage )
					info:SetDamageType( iActualDamageType )
					info:SetDamagePosition( vHitPos )
					info:SetDamageForce( vShotDir * flAmmoForce * flForce * flPhysPush )
					info:SetAmmoType( iAmmoType )
					info:SetReportedPosition( vSrc )
				pEntity:DispatchTraceAttack( info, tr, vShotDir )
				
				tr.StartPos = vSrc
				
				if ( fCallback ) then
					fCallback( pAttacker, tr, info )
				end
				
				if ( bFirstTimePredicted ) then
					if ( not bHitWater or bStartedInWater or bit.band( iFlags, FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS ) ~= 0 ) then
						if ( bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType )) then
							local data = EffectData()
								data:SetOrigin( tr.HitPos )
								data:SetStart( tr.StartPos )
								data:SetSurfaceProp( tr.SurfaceProps )
								data:SetDamageType( iActualDamageType )
								data:SetHitBox( tr.HitBox )
								data:SetEntity( tr.Entity )
							util.Effect( "Impact", data )
						end	
					else
						// We may not impact, but we DO need to affect ragdolls on the client
						local data = EffectData()
							data:SetOrigin( tr.HitPos )
							data:SetStart( tr.StartPos )
							data:SetDamageType( iActualDamageType )
						util.Effect( "RagdollImpact", data )
					end
				end
			end
			
			if ( SERVER and bit.band( iAmmoFlags, AMMO_FORCE_DROP_IF_CARRIED ) ~= 0 ) then
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
				if ( bFirstTimePredicted and (bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType ))) then
					local data = EffectData()
						data:SetOrigin( tr.HitPos )
						data:SetStart( tr.StartPos )
						data:SetSurfaceProp( tr.SurfaceProps )
						data:SetDamageType( iActualDamageType )
						data:SetHitBox( tr.HitBox )
						data:SetEntity( tr.Entity )
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
					data:SetStart( self:ComputeTracerStartPosition( vSrc ))
					data:SetOrigin( vFinalHit )
					data:SetScale(0)
					data:SetEntity( bWeaponInvalid and self or pWeapon )
					data:SetAttachment( bWeaponInvalid and 1 or pWeapon.GetMuzzleAttachment and pWeapon:GetMuzzleAttachment() or 1 )
					
					local iFlags = TRACER_FLAG_USEATTACHMENT
					
					if ( iAmmoTracerType == TRACER_LINE_AND_WHIZ ) then
						iFlags = bit.bor( iFlags, TRACER_FLAG_WHIZ )
					end
					
					data:SetFlags( iFlags )
				util.Effect( sTracerName, data )
			end
			
			iTracerCount = iTracerCount + 1
		end
	end
	
	self:LagCompensation( false )
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
	},
}

local tDoublePenetration = {
	[MAT_WOOD] = true,
	[MAT_METAL] = true,
	[MAT_GRATE] = true,
	[MAT_GLASS] = true
}

local CS_MASK_HITBOX = bit.bor( bit.bor( MASK_SOLID, CONTENTS_DEBRIS ), CONTENTS_HITBOX )

function PLAYER:FireCSBullets( bullets )
	if ( hook.Run( "EntityFireCSBullets", self, bullets ) == false ) then
		return
	end
	
	local pWeapon = self:GetActiveWeapon()
	local bWeaponInvalid = pWeapon == NULL
	
	-- FireCSBullets info
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
	local flDistance = bullets.Distance or 56756
	local flExitMaxDistance = bullets.ExitMaxDistance or 128
	local flExitStepSize = bullets.ExitStepSize or 24
	local tFilter = bullets.Filter or { self }
	
	if ( not istable( tFilter )) then
		tFilter = { tFilter }
	end
	
	local iFlags = bullets.Flags or 0
	local flForce = bullets.Force or 1
	local iGibDamage = bullets.GibDamage or 16
	--local flHitboxTolerance = bullets.HitboxTolerance or 40
	local pInflictor = bullets.Inflictor and bullets.Inflictor ~= NULL and bullets.Inflictor or bWeaponInvalid and self or pWeapon
	local iMask = bullets.Mask or CS_MASK_HITBOX
	local iNum = bullets.Num or 1
	local iPenetration = bullets.Penetration or 0
	local flRangeModifier = bullets.RangeModifier or 0
	local aShootAngles = bullets.ShootAngles or angle_zero
	local flSpread = bullets.Spread or 0
	local flSpreadBias = bullets.SpreadBias or 0
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
	local flPenetrationDistance = game.GetAmmoPenetrationDistance( sAmmoType )
	local flPenetrationPower = game.GetAmmoPenetrationPower( sAmmoType )
	
	-- Loop values
	local bDebugShoot = ai_debug_shoot_positions:GetBool()
	local iFilterEnd = #tFilter
	local bFirstShotInaccurate = bit.band( iFlags, FIRE_BULLETS_FIRST_SHOT_ACCURATE ) == 0
	local iNewFilterEnd = iFilterEnd - 1
	local flPhysPush = phys_pushscale:GetFloat()
	local vShootForward = aShootAngles:Forward()
	local bShowPenetration = sv_showpenetration:GetBool()
	local bStartedInWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
	local bFirstTimePredicted = IsFirstTimePredicted()
	local vShootRight, vShootUp
	
	// Wrap it for network traffic so it's the same between client and server
	local iSeed = self:GetPredictionSeed() % 0x100
	
	-- Don't calculate stuff we won't end up using
	if ( bFirstShotInaccurate or iNum ~= 1 ) then
		vShootRight = flSpread * aShootAngles:Right()
		vShootUp = flSpread * aShootAngles:Up()
	end
	
	//Adrian: visualize server/client player positions
	//This is used to show where the lag compesator thinks the player should be at.
	local iHitNum = sv_showplayerhitboxes:GetInt()
	
	if ( iHitNum > 0 ) then
		local pLagPlayer = Player( iHitNum )
		
		if ( pLagPlayer ~= NULL ) then
			pLagPlayer:DrawHitBoxes(3)
		end
	end
	
	iHitNum = sv_showimpacts:GetInt()
	
	self:LagCompensation( true )
	
	for iShot = 1, iNum do
		local vShotDir
		iSeed = iSeed + 1 // use new seed for next bullet
		random.SetSeed( iSeed ) // init random system with this seed
		
		-- Loop values
		local flCurrentDamage = iDamage	// damage of the bullet at it's current trajectory
		local flCurrentDistance = 0	// distance that the bullet has traveled so far
		local vNewSrc = vSrc
		local vFinalHit
		
		// add the spray 
		if ( iShot ~= 1 or bFirstShotInaccurate ) then
			vShotDir = vShootForward + vShootRight * (random.RandomFloat( -flSpreadBias, flSpreadBias ) + random.RandomFloat( -flSpreadBias, flSpreadBias ))
			+ vShootUp * (random.RandomFloat( -flSpreadBias, flSpreadBias ) + random.RandomFloat( -flSpreadBias, flSpreadBias ))
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
				filter = tFilter
			})
			
			// Check for player hitboxes extending outside their collision bounds
			--util.ClipTraceToPlayers( tr, vNewSrc, vEnd + vShotDir * flHitboxTolerance, tFilter, iMask )
			
			local pEntity = tr.Entity
			local vHitPos = tr.HitPos
			vFinalHit = vHitPos
			local bHitWater = bStartedInWater
			local bEndNotWater = bit.band( util.PointContents( vHitPos ), MASK_WATER ) == 0
			
			-- The bullet left the water
			if ( bHitWater and bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vEnd,
							endpos = vNewSrc,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
				end
			// See if the bullet ended up underwater + started out of the water
			elseif ( not bHitWater and not bEndNotWater ) then
				if ( bFirstTimePredicted ) then
					local data = EffectData()
						local vSplashPos = util.TraceLine({
							start = vNewSrc,
							endpos = vEnd,
							mask = MASK_WATER
						}).HitPos
						
						data:SetOrigin( vSplashPos )
						data:SetScale( random.RandomFloat( iAmmoMinSplash, iAmmoMaxSplash ))
						
						if ( bit.band( util.PointContents( vSplashPos ), CONTENTS_SLIME ) ~= 0 ) then
							data:SetFlags( FX_WATER_IN_SLIME )
						end
						
					util.Effect( "gunshotsplash", data )
					
					--[[local pWaterBullet = ents.Create( "waterbullet" )
					
					if ( pWaterBullet ~= NULL ) then
						pWaterBullet:SetPos( trWater.HitPos )
						pWaterBullet:_SetAbsVelocity( vDir * 1500 )
						
						-- Re-use EffectData
							data:SetStart( trWater.HitPos )
							data:SetOrigin( trWater.HitPos + vDir * 400 )
							data:SetFlags( TRACER_TYPE_WATERBULLET )
						util.Effect( "TracerSound", data )
					end]]
				end
			
				bHitWater = true
			end
			
			if ( tr.HitSky or tr.Fraction == 1 or pEntity == NULL ) then
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
			
			local iActualDamageType = flCurrentDamage < iGibDamage and iAmmoDamageType
			or bit.bor( iAmmoDamageType, DMG_ALWAYSGIB )
			
			if ( not bHitWater or bit.band( iFlags, FIRE_BULLETS_DONT_HIT_UNDERWATER ) == 0 ) then
				// add damage to entity that we hit
				local info = DamageInfo()
					info:SetAttacker( pAttacker )
					info:SetInflictor( pInflictor )
					info:SetDamage( flCurrentDamage )
					info:SetDamageType( iActualDamageType )
					info:SetDamagePosition( vHitPos )
					info:SetDamageForce( vShotDir * flAmmoForce * flForce * flPhysPush )
					info:SetAmmoType( iAmmoType )
					info:SetReportedPosition( vSrc )
				pEntity:DispatchTraceAttack( info, tr, vShotDir )
				
				tr.StartPos = vSrc
				
				if ( fCallback ) then
					fCallback( pAttacker, tr, info )
				end
				
				if ( bFirstTimePredicted ) then
					if ( not bHitWater or bStartedInWater or bit.band( iFlags, FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS ) ~= 0 ) then
						if ( bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType )) then
							local data = EffectData()
								data:SetOrigin( tr.HitPos )
								data:SetStart( tr.StartPos )
								data:SetSurfaceProp( tr.SurfaceProps )
								data:SetDamageType( iActualDamageType )
								data:SetHitBox( tr.HitBox )
								data:SetEntity( tr.Entity )
							util.Effect( "Impact", data )
						end	
					else
						// We may not impact, but we DO need to affect ragdolls on the client
						local data = EffectData()
							data:SetOrigin( tr.HitPos )
							data:SetStart( tr.StartPos )
							data:SetDamageType( iActualDamageType )
						util.Effect( "RagdollImpact", data )
					end
				end
			end
			
			if ( SERVER and bit.band( iAmmoFlags, AMMO_FORCE_DROP_IF_CARRIED ) ~= 0 ) then
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
					debugoverlay.Line( vPenetrationEnd, vHitPos, DEBUG_LENGTH, color_red )
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
			if ( bFirstTimePredicted and (bWeaponInvalid or not pWeapon:DoImpactEffect( tr, iActualDamageType ))) then
				local data = EffectData()
					data:SetOrigin( tr.HitPos )
					data:SetStart( tr.StartPos )
					data:SetSurfaceProp( tr.SurfaceProps )
					data:SetDamageType( iActualDamageType )
					data:SetHitBox( tr.HitBox )
					data:SetEntity( tr.Entity )
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
				iNewFilterEnd = iNewFilterEnd + 1
				tFilter[iNewFilterEnd] = pEntity
			end
		until ( flCurrentDamage < FLT_EPSILON ) -- Account for float handling; very rare case
		
		for i = iFilterEnd, iNewFilterEnd do
			tFilter[i] = nil -- Restore the table
		end
		
		if ( bDebugShoot ) then
			debugoverlay.Line( vSrc, vFinalHit, DEBUG_LENGTH, color_debug )
		end
		
		if ( bFirstTimePredicted and iTracerFreq > 0 ) then
			if ( iTracerCount % iTracerFreq == 0 ) then
				local data = EffectData()
					data:SetStart( self:ComputeTracerStartPosition( vSrc ))
					data:SetOrigin( vFinalHit )
					data:SetScale(0)
					data:SetEntity( bWeaponInvalid and self or pWeapon )
					data:SetAttachment( bWeaponInvalid and 1 or pWeapon.GetMuzzleAttachment and pWeapon:GetMuzzleAttachment() or 1 )
					
					local iFlags = TRACER_FLAG_USEATTACHMENT
					
					if ( iAmmoTracerType == TRACER_LINE_AND_WHIZ ) then
						iFlags = bit.bor( iFlags, TRACER_FLAG_WHIZ )
					end
					
					data:SetFlags( iFlags )
				util.Effect( sTracerName, data )
			end
			
			iTracerCount = iTracerCount + 1
		end
	end
	
	self:LagCompensation( false )
end

// GOOSEMAN : Kick the view..
function PLAYER:KickBack( tKickTable )
	if ( not IsFirstTimePredicted() ) then
		return 
	end
	
	local flKickUp = tKickTable.UpBase
	local flKickLateral = tKickTable.LateralBase
	local iShotsFired = self:GetShotsFired()
	
	-- Not the first round fired
	if ( iShotsFired > 1 ) then
		flKickUp = flKickUp + iShotsFired * tKickTable.UpModifier
		flKickLateral = flKickLateral + iShotsFired * tKickTable.LateralModifier
	end
	
	local ang = self:GetPunchAngle()
	
	ang.p = ang.p - flKickUp
	
	if ( ang.p < -1 * tKickTable.UpMax ) then
		ang.p = -1 * tKickTable.UpMax
	end
	
	if ( self.m_bDirection ) then
		ang.y = ang.y + flKickLateral
		
		if ( ang.y > tKickTable.LateralMax ) then
			ang.y = tKickTable.LateralMax
		end
	else
		ang.y = ang.y - flKickLateral
		
		if ( ang.y < -1 * tKickTable.LateralMax ) then
			ang.y = -1 * tKickTable.LateralMax
		end
	end
	
	if ( self:SharedRandomInt( "KickBack", 0, tKickTable.DirectionChange ) == 0 ) then
		self.m_bDirection = not self.m_bDirection
	end
	
	self:SetViewPunchAngles( ang )
end
