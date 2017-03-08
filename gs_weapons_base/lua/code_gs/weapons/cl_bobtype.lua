local Default = function(_, _, _, _, vNewPos, aNew) return vNewPos, aNew end
local Disable = function(_, _, vPos, ang) return vPos, ang end
local tBobTypes = {}

function code_gs.weapons.RegisterBobType(sName, func)
	tBobTypes[sName:lower()] = func
end

function code_gs.weapons.GetBobType(sName)
	if (sName == "") then
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

code_gs.weapons.RegisterBobType("hls", function(pWeapon, pViewModel, vOrigin, ang)
	local pPlayer = pWeapon:GetOwner()
	local flBobCycle = pWeapon.BobCycle
	local flBobUp = pWeapon.BobUp
	
	if (flBobCycle and flBobUp and flBobCycle > 0 and flBobUp > 0 and flBobUp ~= 1 and FrameTime() ~= 0) then
		local flCurTime = CurTime()
		local flBobSpeed = pWeapon.BobSpeed * pPlayer:GetWalkSpeed()
		local flSpeed = math.Clamp(pPlayer:_GetLocalVelocity():Length2D(), -flBobSpeed, flBobSpeed)
		flBobTime = flBobTime + (flCurTime - flLastBob) * (flSpeed / flBobSpeed)
		flLastBob = flCurTime
		local flTimeByCycle = flBobTime/flBobCycle
		local flCycle = (flBobTime - math.floor(flTimeByCycle) * flBobCycle) / flBobCycle
		local flInvBobUp = 1 - flBobUp
		local flCycleDiff = flCycle - flBobUp
		
		if (flCycle < flBobUp) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flSpeed = flSpeed * 0.005
		flVertical = math.Clamp(flSpeed * 0.3 + flSpeed * 0.7 * math.sin(flCycle), -7, 4)
		
		local flDoubleCycle = flBobCycle * 2
		flCycle = (flBobTime - math.floor(flTimeByCycle * 2) * flDoubleCycle) / flDoubleCycle
		
		if (flCycle < flBobUp) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flLateral = math.Clamp(flSpeed * 0.3 + flSpeed * 0.7 * math.sin(flCycle), -7, 4)
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
end)

code_gs.weapons.RegisterBobType("css", function(pWeapon, pViewModel, vOrigin, ang)
	local pPlayer = pWeapon:GetOwner()
	
	//NOTENOTE: For now, let this cycle continue when in the air, because it snaps badly without it
	local flBobCycle = pWeapon.BobCycle
	local flBobUp = pWeapon.BobUp
	
	if (flBobCycle and flBobUp and flBobCycle > 0 and flBobUp > 0 and flBobUp ~= 1 and FrameTime() ~= 0) then
		// Find the speed of the player
		local flCurTime = CurTime()
		local flBobSpeed = pWeapon.BobSpeed * pPlayer:GetWalkSpeed()
		
		// don't allow too big speed changes
		local flDelta = math.max(0, (flCurTime - flLastBob) * flBobSpeed)
		local flSpeed = math.Clamp(math.Clamp(pPlayer:_GetLocalVelocity():Length2D(), flLastSpeed - flDelta, flLastSpeed + flDelta), -flBobSpeed, flBobSpeed)
		flLastSpeed = flSpeed
		flBobTime = flBobTime + (flCurTime - flLastBob) * (flSpeed / flBobSpeed)
		flLastBob = flCurTime
		
		//FIXME: This maximum speed value must come from the server.
		//		 MaxSpeed() is not sufficient for dealing with sprinting - jdw
		
		//Calculate the vertical bob
		local flTimeByCycle = flBobTime/flBobCycle
		local flCycle = (flBobTime - math.floor(flTimeByCycle) * flBobCycle) / flBobCycle
		local flInvBobUp = 1 - flBobUp
		local flCycleDiff = flCycle - flBobUp
		
		if (flCycle < flBobUp) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flSpeed = flSpeed * 0.005
		flVertical = math.Clamp(flSpeed * 0.3 + flSpeed * 0.7 * math.sin(flCycle), -7, 4)

		// Calculate the lateral bob
		local flDoubleCycle = flBobCycle * 2
		flCycle = (flBobTime - math.floor(flTimeByCycle * 2) * flDoubleCycle) / flDoubleCycle
		
		if (flCycle < flBobUp) then
			flCycle = pi * flCycle / flBobUp
		else
			flCycle = pi + pi * flCycleDiff / flInvBobUp
		end
		
		flLateral = math.Clamp(flSpeed * 0.3 + flSpeed * 0.7 * math.sin(flCycle), -7, 4)
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
end)
