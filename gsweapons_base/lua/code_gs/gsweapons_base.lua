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
		
		DevMsg( 2, string.format( "[GSWeapons] (GetHoldType) HoldType %q not found. Sending back table for \"normal\".", sName ))
		
		return tHoldTypes["normal"] or {}
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
end

do
	local tDetonationTypes = {}
	
	if ( CLIENT ) then
		local ReturnTrue = ReturnTrue
		
		function gsweapons.RegisterDetonationFunc( sName, func )
			tDetonationTypes[sName:lower()] = func
		end
		
		function gsweapons.GetDetonationFunc( sName )
			sName = sName:lower()
			
			return tDetonationTypes[sName] or ReturnTrue
		end
		
		local explosion_dlight = GetConVar( "explosion_dlight" )
		
		gsweapons.RegisterDetonationFunc( "flash", function( pGrenade )
			if ( explosion_dlight:GetBool() ) then
				-- Can't create DLights serverside from the Lua state
				local dlight = DynamicLight( pGrenade:EntIndex() )
					local vSrc = pGrenade:GetPos()
					vSrc[3] = vSrc[3] + 1 // in case grenade is lying on the ground
					dlight.pos = vSrc
					
					dlight.r = 255
					dlight.g = 255
					dlight.b = 255
					dlight.brightness = 2
					dlight.size = 400
					dlight.dietime = CurTime() + 0.1
					dlight.decay = 768
			end
			
			return true
		end )
	else
		local Remove = function( pGrenade ) pGrenade:Remove() return true end
		
		function gsweapons.RegisterDetonationFunc( sName, func, bNetworked )
			tDetonationTypes[sName:lower()] = { func, bNetworked or false }
		end
		
		function gsweapons.GetDetonationFunc( sName )
			sName = sName:lower()
			
			return tDetonationTypes[sName] and tDetonationTypes[sName][1] or Remove
		end
		
		function gsweapons.DetonationNetworked( sName )
			sName = sName:lower()
			
			return tDetonationTypes[sName] and tDetonationTypes[sName][2] or false
		end
	
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
			local iDamage = pGrenade:GetDamage()
			
			local data = EffectData()
				data:SetOrigin( vAbsOrigin )
				data:SetMagnitude( iDamage )
				data:SetScale( pGrenade:GetDamageRadius() * 0.03 )
				data:SetFlags( TE_EXPLFLAG_NOSOUND )
			util.Effect( "Explosion", data )
			util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
			
			pGrenade:PlaySound( "detonate" )
			
			local tShake = pGrenade.Shake
			local flAmplitude = tShake.Amplitude
			
			if ( flAmplitude ~= 0 ) then
				util.ScreenShake( vAbsOrigin, flAmplitude, tShake.Frequency, tShake.Duration, tShake.Radius )
			end
			
			local info = DamageInfo()
				info:SetAttacker( bInvalid and pGrenade or pOwner )
				info:SetDamage( iDamage )
				info:SetDamageForce( pGrenade.Force )
				info:SetDamagePosition( vAbsOrigin )
				info:SetDamageType( DMG_BLAST )
				info:SetInflictor( pGrenade )
				
				// Use the thrower's position as the reported position
				info:SetReportedPosition( bInvalid and vAbsOrigin or pOwner:GetPos() )
			return info
		end

		gsweapons.RegisterDetonationFunc( "explode", function( pGrenade )
			local info = ExplosionEffects( pGrenade )
			util.RadiusDamage( info, info:GetDamagePosition(), pGrenade:GetDamageRadius(), pGrenade ) -- FIXME
			pGrenade:Remove()
			
			return true
		end )

		gsweapons.RegisterDetonationFunc( "explode_css", function( pGrenade )
			local info = ExplosionEffects( pGrenade )
			util.CSRadiusDamage( info, info:GetDamagePosition(), pGrenade:GetDamageRadius(), pGrenade )
			pGrenade:Remove()
			
			return true
		end )

		gsweapons.RegisterDetonationFunc( "explode_sdk", function( pGrenade )
			local info = ExplosionEffects( pGrenade )
			util.SDKRadiusDamage( info, info:GetDamagePosition(), pGrenade:GetDamageRadius(), pGrenade )
			pGrenade:Remove()
			
			return true
		end )

		gsweapons.RegisterDetonationFunc( "smoke", function( pGrenade )
			if ( pGrenade:_GetAbsVelocity():LengthSqr() > 0.01 ) then
				// Still moving. Don't detonate yet.
				return 0.2
			end
			
			// Ok, we've stopped rolling or whatever. Now detonate.
			local pSmoke = Smoke()
			pSmoke:SetPos( pGrenade:GetPos() )
			pSmoke:Spawn()
			pSmoke:FillVolume()
			pSmoke:SetFadeTime(17, 22)
			pSmoke:DeleteOnRemove( pGrenade )
			
			pGrenade:PlaySound( "main" )
			pGrenade:SetRenderMode( RENDERMODE_TRANSALPHA )
			
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
						pGrenade:Remove()
						
						return true
					end )
					
					return true
				end
				
				return 0
			end )
			
			return true
		end )

		local MASK_FLASHBANG = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER )

		-- This one's a doozy; 7 traces, a point contents check, a FindInSphere loop, and a DynamicLight (clientside)
		gsweapons.RegisterDetonationFunc( "flash", function( pGrenade )
			local vSrc = pGrenade:GetPos()
			vSrc[3] = vSrc[3] + 1 // in case grenade is lying on the ground
			
			local iDamage = pGrenade:GetDamage()
			local flRadius = pGrenade:GetDamageRadius()
			local tEnts = ents.FindInSphere( vSrc, flRadius )
			local bInWater = util.PointContents( vSrc ) == CONTENTS_WATER
			local flFalloff = iDamage / flRadius
			
			// iterate on all entities in the vicinity.
			for i = 1, #tEnts do
				local pPlayer = tEnts[i]
				
				if ( not pPlayer:IsPlayer() ) then
					continue
				end
				
				// blasts don't travel into or out of water
				if ( bInWater ) then
					if ( pPlayer:WaterLevel() == 0 ) then
						continue
					end
				elseif ( pPlayer:WaterLevel() == 3 ) then
					continue
				end
				
				local vEyePos = pPlayer:EyePos()
				local flPercentage

				local tr = util.TraceLine({
					start = vSrc,
					endpos = vEyePos,
					mask = MASK_FLASHBANG,
					filter = pGrenade
				})

				if ( tr.Fraction == 1 or tr.Entity == pPlayer ) then
					flPercentage = 1
				else
					local aTemp = (vEyePos - vSrc):Angle()
					local vRight = aTemp:Right()
					local vUp = aTemp:Up()
					
					// check the point straight up.
					util.TraceLine({
						start = vSrc,
						endpos = vSrc + vUp * 50,
						mask = MASK_FLASHBANG,
						filter = pGrenade,
						output = tr
					})
					
					util.TraceLine({
						start = tr.HitPos,
						endpos = vEyePos,
						mask = MASK_FLASHBANG,
						filter = pGrenade,
						output = tr
					})
					
					if ( tr.Fraction == 1 or tr.Entity == pPlayer ) then
						flPercentage = 0.167
					end
					
					// check the point up and right
					util.TraceLine({
						start = vSrc,
						endpos = vSrc + vRight * 75 + vUp * 10,
						mask = MASK_FLASHBANG,
						filter = pGrenade,
						output = tr
					})
					
					util.TraceLine({
						start = tr.HitPos,
						endpos = vEyePos,
						mask = MASK_FLASHBANG,
						filter = pGrenade,
						output = tr
					})
					
					if ( tr.Fraction == 1 or tr.Entity == pPlayer ) then
						flPercentage = flPercentage + 0.167
					end
					
					-- Up and to the left
					util.TraceLine({
						start = vSrc,
						endpos = vSrc - vRight * 75 + vUp * 10,
						mask = MASK_FLASHBANG,
						filter = pGrenade,
						output = tr
					})
					
					util.TraceLine({
						start = tr.HitPos,
						endpos = vEyePos,
						mask = MASK_FLASHBANG,
						filter = pGrenade,
						output = tr
					})
					
					if ( tr.Fraction == 1 or tr.Entity == pPlayer ) then
						flPercentage = flPercentage + 0.167
					end
				end
				
				if ( flPercentage ) then
					local vLOS = vSrc - vEyePos
					local flDistance = vLOS:Length()
					
					// decrease damage for an ent that's farther from the grenade
					local flAdjustedDamage = iDamage - flDistance * flFalloff
					
					if ( flAdjustedDamage > 0 ) then
						vLOS:Normalize()
						
						// See if we were facing the flash
						// Normalize both vectors so the dotproduct is in the range -1.0 <= x <= 1.0 
						local flDot = vLOS:Dot( pPlayer:EyeAngles():Forward() )

						local flAlpha
						local flTime
						local flHold
			
						// if target is facing the bomb, the effect lasts longer
						if ( flDot >= 0.5 ) then
							// looking at the flashbang
							flTime = flAdjustedDamage * 2.5
							flHold = flAdjustedDamage * 1.25
							flAlpha = 255
						elseif ( flDot >= -0.5 ) then
							// looking to the side
							flTime = flAdjustedDamage * 1.75
							flHold = flAdjustedDamage * 0.8
							flAlpha = 255
						else
							// facing away
							flTime = flAdjustedDamage
							flHold = flAdjustedDamage * 0.75
							flAlpha = 200
						end

						// blind players and bots
						pPlayer:Blind( flHold * flPercentage, flTime * flPercentage, flAlpha )

						// deafen players and bots
						pPlayer:Deafen( flDistance )
					end
				end
			end
			
			pGrenade:PlaySound( "main" )
			pGrenade:Remove()
			
			return true
		end, true )
	end
end

if ( CLIENT ) then
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
		
		local pi = math.pi
		local flLateral = 0
		local flVertical = 0
		local flBobTime = 0
		local flLastBob = 0
		local flLastSpeed = 0

		gsweapons.RegisterBobType( "hls", function( pWeapon, pViewModel, vOrigin, ang )
			local pPlayer = pWeapon:GetOwner()
			local bSecondary = pWeapon:SpecialActive( pViewModel:ViewModelIndex() )
			local flBobCycle = pWeapon:GetSpecialKey( "BobCycle", bSecondary )
			local flBobUp = pWeapon:GetSpecialKey( "BobUp", bSecondary )
			
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

		gsweapons.RegisterBobType( "css", function( pWeapon, pViewModel, vOrigin, ang )
			local pPlayer = pWeapon:GetOwner()
			
			//NOTENOTE: For now, let this cycle continue when in the air, because it snaps badly without it
			local bSecondary = pWeapon:SpecialActive( pViewModel:ViewModelIndex() )
			local flBobCycle = pWeapon:GetSpecialKey( "BobCycle", bSecondary )
			local flBobUp = pWeapon:GetSpecialKey( "BobUp", bSecondary )
			
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
		
		local tColPreset = {
			[0] = {50, 250, 50},
			{250, 50, 50},
			{50, 50, 250},
			{250, 250, 50},
			{50, 250, 250}
		}

		local cl_crosshaircolor = CreateConVar( "cl_css_crosshaircolor", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
		local cl_dynamiccrosshair = CreateConVar( "cl_css_dynamiccrosshair", "1", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
		local cl_scalecrosshair = CreateConVar( "cl_css_scalecrosshair", "1", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
		local cl_crosshairscale = CreateConVar( "cl_css_crosshairscale", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
		local cl_crosshairalpha = CreateConVar( "cl_css_crosshairalpha", "200", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
		local cl_crosshairusealpha = CreateConVar( "cl_css_crosshairusealpha", "0", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })
		local matWhite = Material( "vgui/white_additive" )
		
		gsweapons.RegisterCrosshair( "css", function( pWeapon, x, y )
			local pPlayer = pWeapon:GetOwner()
			local iDistance = pWeapon.CSSCrosshair.Min
			
			if ( cl_dynamiccrosshair:GetBool() ) then
				if ( not pPlayer:OnGround() ) then
					iDistance = iDistance * 2
				elseif ( pPlayer:Crouching() ) then
					iDistance = iDistance * 0.5
				elseif ( pPlayer:_GetAbsVelocity():LengthSqr() > (pPlayer:GetWalkSpeed() * pWeapon.CSSCrosshair.Vel) ^ 2 ) then
					iDistance = iDistance * 1.5
				end
			end
			
			local iShotsFired = pWeapon:GetShotsFired()
			
			if ( iShotsFired > pWeapon.m_iAmmoLastCheck ) then
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
			local iBarSize = ScreenScale(5) + (iCrosshairDistance - iDistance) / 2 * flScale
			
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
				local iAlpha = cl_crosshairalpha:GetInt()
				surface.SetDrawColor( tCrosshairColor[1], tCrosshairColor[2], tCrosshairColor[3], iAlpha < 0 and 0 or iAlpha > 255 and 255 or iAlpha )
				
				// Alpha-blended crosshair
				surface.DrawRect( x - iSize, y, iBarSize, iBarThickness )
				surface.DrawRect( x + iThickness, y, iBarSize, iBarThickness )
				surface.DrawRect( x, y - iSize, iBarThickness, iBarSize )
				surface.DrawRect( x, y + iThickness, iBarThickness, iBarSize )
			else
				surface.SetMaterial( matWhite )
				surface.SetDrawColor( tCrosshairColor[1], tCrosshairColor[2], tCrosshairColor[3], 200 )
				
				// Additive crosshair
				surface.DrawTexturedRect( x - iSize, y, iBarSize, iBarThickness )
				surface.DrawTexturedRect( x + iThickness, y, iBarSize, iBarThickness )
				surface.DrawTexturedRect( x, y - iSize, iBarThickness, iBarSize )
				surface.DrawTexturedRect( x, y + iThickness, iBarThickness, iBarSize )
			end

			return true
		end )
		
		local cl_crosshair_red = CreateConVar( "cl_dod_crosshairred", "200", FCVAR_ARCHIVE )
		local cl_crosshair_green = CreateConVar( "cl_dod_crosshairgreen", "200", FCVAR_ARCHIVE )
		local cl_crosshair_blue = CreateConVar( "cl_dod_crosshairblue", "200", FCVAR_ARCHIVE )
		local cl_crosshair_alpha = CreateConVar( "cl_dod_crosshairalpha", "200", FCVAR_ARCHIVE )
		local cl_crosshair_texture = CreateConVar( "cl_dod_crosshairtexture", "1", FCVAR_ARCHIVE )
		local cl_crosshair_scale = CreateConVar( "cl_dod_crosshairscale", "32", FCVAR_ARCHIVE )
		local cl_crosshair_approach_speed = CreateConVar( "cl_dod_approachspeed", "0.015", FCVAR_ARCHIVE )
		local cl_dynamic_crosshair = CreateConVar( "cl_dod_dynamiccrosshair", "1", FCVAR_ARCHIVE )
		
		local matCross = {
			Material( "vgui/crosshairs/crosshair1" ),
			Material( "vgui/crosshairs/crosshair2" ),
			Material( "vgui/crosshairs/crosshair3" ),
			Material( "vgui/crosshairs/crosshair4" ),
			Material( "vgui/crosshairs/crosshair5" ),
			Material( "vgui/crosshairs/crosshair6" ),
			Material( "vgui/crosshairs/crosshair7" )
		}
		
		gsweapons.RegisterCrosshair( "dod", function( pWeapon, x, y )
			local mat = matCross[cl_crosshair_texture:GetInt()]
			--print(matCross[8]) -- FIXME: Table leak??
			
			if ( mat ) then
				mat:SetInt( "$frame", 0 )
				
				if ( cl_dynamic_crosshair:GetBool() ) then
					local flAccuracy = pWeapon:GetSpecialKey( "Spread", pWeapon:SpecialActive() ).x -- FIXME: Select average between x and y?
					
					if ( flAccuracy < 0.02 ) then
						flAccuracy = 0.02
					elseif ( flAccuracy > 0.125 ) then
						flAccuracy = 0.125
					end
					
					// approach this accuracy from our current accuracy
					pWeapon.m_flCrosshairDistance = math.Approach( flAccuracy, pWeapon.m_flCrosshairDistance, cl_crosshair_approach_speed:GetFloat() )
				end
				
				local iScale = cl_crosshair_scale:GetInt() * 2
				-- FIXME: Go over all of this DrawRect stuff
				surface.SetDrawColor( cl_crosshair_red:GetInt(), cl_crosshair_green:GetInt(), cl_crosshair_blue:GetInt(), cl_crosshair_alpha:GetInt() )
				surface.SetMaterial( mat )
				surface.DrawTexturedRect( x - iScale / 2, y - iScale / 2, iScale, iScale )
			end
			
			return true
		end )
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
		
		local matDust = Material( "overlays/scope_lens" )
		local matArc = Material( "sprites/scope_arc" )
		local uv1 = 1/512
		local uv2 = 1 - uv1
		local vert4 = {{}, {}, {}, {}}

		gsweapons.RegisterScope( "css", function()
			local iHeight = ScrH()
			local iWidth = ScrW()
			
			// calculate the bounds in which we should draw the scope
			local y = iHeight / 2
			local x = iWidth / 2
			local y1 = iHeight / 16
			local x1 = (iWidth - iHeight) / 2 + y1
			local y2 = iHeight - y1
			local x2 = iWidth - x1
			
			surface.SetMaterial( matDust )
			surface.SetDrawColor(255, 255, 255, 255)
			
			local tVert = vert4[1]
			tVert.x = iWidth
			tVert.y = iHeight
			tVert.u = uv2
			tVert.v = uv1
			
			tVert = vert4[2]
			tVert.x = 0
			tVert.y = iHeight
			tVert.u = uv1
			tVert.v = uv1
			
			tVert = vert4[3]
			tVert.x = 0
			tVert.y = 0
			tVert.u = uv1
			tVert.v = uv2
			
			tVert = vert4[4]
			tVert.x = iWidth
			tVert.y = 0
			tVert.u = uv2
			tVert.v = uv2
			
			surface.DrawPoly( vert4 )
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			
			//Draw the reticle with primitives
			surface.DrawLine( x, 0, x, iHeight )
			surface.DrawLine( 0, y, iWidth, y )
			
			// Draw the outline
			surface.SetMaterial( matArc )
			
			-- Major table conservation
			
			-- First quandrant
			--tVert = vect4[4]
			tVert.x = x - 1
			tVert.y = y + 1
			tVert.u = uv1
			tVert.v = uv1
			
			tVert = vert4[1]
			tVert.x = x - 1
			tVert.y = y1 - 1
			tVert.u = uv1
			tVert.v = uv2
			
			tVert = vert4[2]
			tVert.x = x2
			tVert.y = y1 - 1
			tVert.u = uv2
			tVert.v = uv2
			
			tVert = vert4[3]
			tVert.x = x2
			tVert.y = y + 1
			tVert.u = uv2
			tVert.v = uv1
			
			surface.DrawPoly( vert4 )
			
			-- Second quandrant
			--tVert = vect4[3]
			tVert.x = x
			tVert.y = y
			tVert.u = uv1
			tVert.v = uv1
			
			tVert = vert4[1]
			tVert.x = x1 - 1
			tVert.y = y1 - 1
			tVert.u = uv2
			tVert.v = uv2
			
			tVert = vert4[2]
			tVert.x = x
			tVert.y = y1 - 1
			tVert.u = uv1
			tVert.v = uv2
			
			tVert = vert4[4]
			tVert.x = x1 - 1
			tVert.y = y
			tVert.u = uv2
			tVert.v = uv1
			
			surface.DrawPoly( vert4 )
			
			-- Third quadrant
			--tVert = vect4[4]
			tVert.x = x1 - 1
			tVert.y = y2
			tVert.u = uv2
			tVert.v = uv2
			
			tVert = vert4[1]
			tVert.x = x1 - 1
			tVert.y = y
			tVert.u = uv2
			tVert.v = uv1
			
			tVert = vert4[2]
			tVert.x = x
			tVert.y = y
			tVert.u = uv1
			tVert.v = uv1
			
			tVert = vert4[3]
			tVert.x = x
			tVert.y = y2
			tVert.u = uv1
			tVert.v = uv2
			
			surface.DrawPoly( vert4 )
			
			-- Fourth quadrant
			--tVert = vert4[3]
			tVert.x = x2
			tVert.y = y2
			tVert.u = uv2
			tVert.v = uv2
			
			tVert = vert4[1]
			tVert.x = x
			tVert.y = y
			tVert.u = uv1
			tVert.v = uv1
			
			tVert = vert4[2]
			tVert.x = x2
			tVert.y = y
			tVert.u = uv2
			tVert.v = uv1
			
			tVert = vert4[4]
			tVert.x = x
			tVert.y = y2
			tVert.u = uv1
			tVert.v = uv2
			
			surface.DrawPoly( vert4 )
			
			surface.DrawRect( 0, y1, x1, iHeight ) -- Left
			surface.DrawRect( x2, y1, iWidth, iHeight ) -- Right
			surface.DrawRect( 0, 0, iWidth, y1 ) -- Top
			surface.DrawRect( 0, y2, iWidth, iHeight ) -- Bottom
			
			return true
		end )
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
		
		local cl_ejectbrass = GetConVar( "cl_ejectbrass" )
		
		gsweapons.RegisterAnimEvent( 3015, "hl2_357", function( pWeapon )
			if ( not cl_ejectbrass:GetBool() ) then
				return true
			end
			
			local vWorld = pWeapon:GetOwner():WorldSpaceCenter()
			local aRand = Angle(90, 0, 0)
			local data = EffectData()
				data:SetEntIndex( pWeapon:EntIndex() )
			
			// Emit six spent shells
			for i = 1, 6 do
					data:SetOrigin( vWorld + VectorRand( -4, 4 ))
					aRand[2] = gsrand:RandomInt(0, 360)
					data:SetAngles( aRand )
				util.Effect( "ShellEject", data )
			end	
			
			return true
		end )
		
		local cl_muzzleeffect = CreateConVar( "cl_muzzleeffect", "1", { FCVAR_CLIENTDLL, FCVAR_ARCHIVE })

		gsweapons.RegisterAnimEvent( {5001, 5011, 5021, 5031}, "css", function( pWeapon, _, _, iEvent )
			if ( not pWeapon:Silenced() and cl_muzzleeffect:GetBool() ) then
				local data = EffectData()
					data:SetEntity( pWeapon:GetOwner():GetViewModel(0) )
					data:SetAttachment( pWeapon:GetMuzzleAttachment( iEvent ))
					data:SetScale( pWeapon:GetMuzzleFlashScale() )
				util.Effect( "CS_MuzzleFlash", data )
			end
			
			return true
		end )

		gsweapons.RegisterAnimEvent( {5001, 5011, 5021, 5031}, "css_x", function( pWeapon, _, _, iEvent )
			if ( not pWeapon:Silenced() and cl_muzzleeffect:GetBool() ) then
				local data = EffectData()
					data:SetEntity( pWeapon:GetOwner():GetViewModel(0) )
					data:SetAttachment( pWeapon:GetMuzzleAttachment( iEvent ))
					data:SetScale( pWeapon:GetMuzzleFlashScale() )
				util.Effect( "CS_MuzzleFlash_X", data )
			end
			
			return true
		end )
		
		local muzzleflash_light = GetConVar( "muzzleflash_light" )
		
		gsweapons.RegisterAnimEvent( {5003, 5013, 5023, 5033}, "css", function( pWeapon, _, _, iEvent )
			if ( not pWeapon:Silenced() and muzzleflash_light:GetBool() ) then
				local dlight = DynamicLight( 0x40000000 + pWeapon:GetOwner():EntIndex() )
				dlight.pos = pWeapon:GetAttachment( pWeapon:GetMuzzleAttachment( iEvent )).Pos
				dlight.size = 70
				dlight.decay = 1400 --dlight.size / 0.05
				dlight.dietime = CurTime() + 0.05
				dlight.r = 255
				dlight.g = 192
				dlight.b = 64
				dlight.style = 5
			end
			
			return true
		end )
		
		local sSep = string.char(32)
		local cRep = string.char(173)

		gsweapons.RegisterAnimEvent( 20, "css", function( pWeapon, _, _, _, sOptions )
			if ( not cl_ejectbrass:GetBool() ) then
				return true
			end
			
			local aEyes = pWeapon:GetOwner():EyeAngles()
			local tOptions = sSep:Explode( sOptions )
			local sEffect = tOptions[1]
			
			if ( sEffect ) then
				-- https://github.com/Facepunch/garrysmod-issues/issues/2789
				local iReplace = sEffect:find( cRep, 1, true )
				
				if ( iReplace ) then
					sEffect = sEffect:sub( 1, iReplace - 1 ) .. "_" .. sEffect:sub( iReplace + 1 )
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
	end
end
