local function Disable( _, _, vec, ang )
	return vec, ang
end

local function PassThrough( _, _, _, _, vec, ang )
	return vec, ang
end

local tBobbingMethods = {}

local function AddBobbingMethod( sName, func )
	tBobbingMethods[sName] = func
end

-------------------------------Custom Bobbing Types-------------------------------

local pi = math.pi
local flLateral = 0
local flVertical = 0
local flBobTime = 0
local flLastBob = 0
local flLastSpeed = 0

local ran = false

local function OldSourceBob( pWeapon, _, vOrigin, ang )
	local pPlayer = pWeapon:GetOwner()
	
	//NOTENOTE: For now, let this cycle continue when in the air, because it snaps badly without it
	local flBobCycle = pWeapon.BobScale
	local flBobUp = pWeapon.SwayScale
	
	if ( flBobCycle and flBobUp and flBobCycle > 0 and flBobUp > 0 and flBobUp < 1 and FrameTime() ~= 0 ) then
		// Find the speed of the player
		local flCurTime = CurTime()
		local flBobSpeed = pWeapon.BobSpeed * pPlayer:GetWalkSpeed()
		local flDelta = (flCurTime - flLastBob) * flBobSpeed
		
		// don't allow too big speed changes
		local flSpeed = pPlayer:_GetLocalVelocity():Length2D()
		local flSpeedMin = flLastSpeed - flDelta
		
		if ( flSpeed < flSpeedMin ) then
			flSpeed = flSpeedMin > flBobSpeed and flBobSpeed or flSpeedMin < -flBobSpeed and -flBobSpeed or flSpeedMin
		else
			local flSpeedMax = flLastSpeed + flDelta
			
			if ( flSpeed > flSpeedMax ) then
				flSpeed = flSpeedMax > flBobSpeed and flBobSpeed or flSpeedMax < -flBobSpeed and -flBobSpeed or flSpeedMax
			end
		end
		
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
	
	//vOrigin = vOrigin + ang:Right() * flLateral * 0.2
	
	// bob the angles
	ang.r = ang.r + flVertical * 0.5
	ang.p = ang.p - flVertical * 0.4
	ang.y = ang.y - flLateral * 0.3
	
	return vOrigin, ang
end

AddBobbingMethod( "cstrike", OldSourceBob )
AddBobbingMethod( "hl", OldSourceBob )

return function( sName )
	-- Fallback on engine bob
	return sName == "" and Disable or tBobbingMethods[sName] or PassThrough
end
