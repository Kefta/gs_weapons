local tDetonationTypes = {}

if (CLIENT) then
	local ReturnTrue = function() return true end
	
	function code_gs.weapons.RegisterDetonationFunc(sName, func)
		tDetonationTypes[sName:lower()] = func
	end
	
	function code_gs.weapons.GetDetonationFunc(sName)
		sName = sName:lower()
		
		return tDetonationTypes[sName] or ReturnTrue
	end
	
	local explosion_dlight = GetConVar("explosion_dlight")
	
	code_gs.weapons.RegisterDetonationFunc("flash", function(pGrenade)
		if (explosion_dlight:GetBool()) then
			-- Can't create DLights serverside from the Lua state
			local dlight = DynamicLight(pGrenade:EntIndex())
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
	end)
else
	local Remove = function(pGrenade) pGrenade:Remove() return true end
	
	function code_gs.weapons.RegisterDetonationFunc(sName, func, bNetworked)
		tDetonationTypes[sName:lower()] = {func, bNetworked or false}
	end
	
	function code_gs.weapons.GetDetonationFunc(sName)
		sName = sName:lower()
		
		return tDetonationTypes[sName] and tDetonationTypes[sName][1] or Remove
	end
	
	function code_gs.weapons.DetonationNetworked(sName)
		sName = sName:lower()
		
		return tDetonationTypes[sName] and tDetonationTypes[sName][2] or false
	end

	local vOffset = Vector(0, 0, 8)
	local vRange = Vector(0, 0, -32)

	local function ExplosionEffects(pGrenade)
		local vAbsOrigin = pGrenade:GetPos()
		local vSpot = vAbsOrigin + vOffset
		
		local tr = util.TraceLine({
			start = vSpot,
			endPos = vSpot + vRange,
			mask = MASK_SHOT_HULL,
			filter = pGrenade
		})
		
		if (tr.StartSolid) then
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
		pGrenade:AddSolidFlags(FSOLID_NOT_SOLID)
		pGrenade:SetSaveValue("m_takedamage", 0)
		
		if (tr.Fraction ~= 1) then
			vAbsOrigin = tr.HitPos + tr.HitNormal * 0.6
			pGrenade:SetPos(vAbsOrigin)
		end
		
		local pOwner = pGrenade:GetOwner()
		local bInvalid = pOwner == NULL
		local iDamage = pGrenade:GetDamage()
		
		local data = EffectData()
			data:SetOrigin(vAbsOrigin)
			data:SetMagnitude(iDamage)
			data:SetScale(pGrenade:GetDamageRadius() * 0.03)
			data:SetFlags(TE_EXPLFLAG_NOSOUND)
		util.Effect("Explosion", data)
		util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		
		pGrenade:PlaySound("detonate")
		
		local tShake = pGrenade.Shake
		local flAmplitude = tShake.Amplitude
		
		if (flAmplitude ~= 0) then
			util.ScreenShake(vAbsOrigin, flAmplitude, tShake.Frequency, tShake.Duration, tShake.Radius)
		end
		
		local info = DamageInfo()
			info:SetAttacker(bInvalid and pGrenade or pOwner)
			info:SetDamage(iDamage)
			info:SetDamageForce(pGrenade.Force)
			info:SetDamagePosition(vAbsOrigin)
			info:SetDamageType(DMG_BLAST)
			info:SetInflictor(pGrenade)
			
			// Use the thrower's position as the reported position
			info:SetReportedPosition(bInvalid and vAbsOrigin or pOwner:GetPos())
		return info
	end

	code_gs.weapons.RegisterDetonationFunc("explode", function(pGrenade)
		local info = ExplosionEffects(pGrenade)
		util.RadiusDamage(info, info:GetDamagePosition(), pGrenade:GetDamageRadius(), pGrenade) -- FIXME
		pGrenade:Remove()
		
		return true
	end)

	code_gs.weapons.RegisterDetonationFunc("explode_css", function(pGrenade)
		local info = ExplosionEffects(pGrenade)
		util.CSRadiusDamage(info, info:GetDamagePosition(), pGrenade:GetDamageRadius(), pGrenade)
		pGrenade:Remove()
		
		return true
	end)

	code_gs.weapons.RegisterDetonationFunc("explode_sdk", function(pGrenade)
		local info = ExplosionEffects(pGrenade)
		util.SDKRadiusDamage(info, info:GetDamagePosition(), pGrenade:GetDamageRadius(), pGrenade)
		pGrenade:Remove()
		
		return true
	end)

	code_gs.weapons.RegisterDetonationFunc("smoke", function(pGrenade)
		if (pGrenade:_GetAbsVelocity():LengthSqr() > 0.01) then
			// Still moving. Don't detonate yet.
			return 0.2
		end
		
		// Ok, we've stopped rolling or whatever. Now detonate.
		local pSmoke = Smoke()
		pSmoke:SetPos(pGrenade:GetPos())
		pSmoke:Spawn()
		pSmoke:FillVolume()
		pSmoke:SetFadeTime(17, 22)
		pSmoke:DeleteOnRemove(pGrenade)
		
		pGrenade:PlaySound("main")
		pGrenade:SetRenderMode(RENDERMODE_TRANSALPHA)
		
		// Fade the projectile out over time before making it disappear
		pGrenade:AddEvent("fade", 5, function()
			local col = pGrenade:GetColor()
			col.a = col.a - 1
			pGrenade:SetColor(col)
			
			if (col.a <= 0) then
				//invisible
				pGrenade:SetModelName('\0')
				pGrenade:SetSolid(SOLID_NONE)
				
				-- We've hid the grenade, now wait for the smoke
				// Spit out smoke for 10 seconds.
				pGrenade:AddEvent("remove", 20, function()
					pGrenade:Remove()
					
					return true
				end)
				
				return true
			end
			
			return 0
		end)
		
		return true
	end)

	local MASK_FLASHBANG = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER)

	-- This one's a doozy; 7 traces, a point contents check, a FindInSphere loop, and a DynamicLight (clientside)
	code_gs.weapons.RegisterDetonationFunc("flash", function(pGrenade)
		local vSrc = pGrenade:GetPos()
		vSrc[3] = vSrc[3] + 1 // in case grenade is lying on the ground
		
		local iDamage = pGrenade:GetDamage()
		local flRadius = pGrenade:GetDamageRadius()
		local tEnts = ents.FindInSphere(vSrc, flRadius)
		local bInWater = util.PointContents(vSrc) == CONTENTS_WATER
		local flFalloff = iDamage / flRadius
		
		// iterate on all entities in the vicinity.
		for i = 1, #tEnts do
			local pPlayer = tEnts[i]
			
			if (not pPlayer:IsPlayer()) then
				continue
			end
			
			// blasts don't travel into or out of water
			if (bInWater) then
				if (pPlayer:WaterLevel() == 0) then
					continue
				end
			elseif (pPlayer:WaterLevel() == 3) then
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

			if (tr.Fraction == 1 or tr.Entity == pPlayer) then
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
				
				if (tr.Fraction == 1 or tr.Entity == pPlayer) then
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
				
				if (tr.Fraction == 1 or tr.Entity == pPlayer) then
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
				
				if (tr.Fraction == 1 or tr.Entity == pPlayer) then
					flPercentage = flPercentage + 0.167
				end
			end
			
			if (flPercentage) then
				local vLOS = vSrc - vEyePos
				local flDistance = vLOS:Length()
				
				// decrease damage for an ent that's farther from the grenade
				local flAdjustedDamage = iDamage - flDistance * flFalloff
				
				if (flAdjustedDamage > 0) then
					vLOS:Normalize()
					
					// See if we were facing the flash
					// Normalize both vectors so the dotproduct is in the range -1.0 <= x <= 1.0 
					local flDot = vLOS:Dot(pPlayer:EyeAngles():Forward())

					local flAlpha
					local flTime
					local flHold
		
					// if target is facing the bomb, the effect lasts longer
					if (flDot >= 0.5) then
						// looking at the flashbang
						flTime = flAdjustedDamage * 2.5
						flHold = flAdjustedDamage * 1.25
						flAlpha = 255
					elseif (flDot >= -0.5) then
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
					pPlayer:Blind(flHold * flPercentage, flTime * flPercentage, flAlpha)

					// deafen players and bots
					pPlayer:Deafen(flDistance)
				end
			end
		end
		
		pGrenade:PlaySound("main")
		pGrenade:Remove()
		
		return true
	end, true)
end