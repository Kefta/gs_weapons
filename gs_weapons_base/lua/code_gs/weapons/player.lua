if (SERVER or not game.SinglePlayer()) then
	-- Handles weapon switching
	hook.Add("StartCommand", "GSWeapons-Shared SelectWeapon", function(pPlayer, cmd)
		if (pPlayer.m_pNewWeapon) then
			if (pPlayer.m_pNewWeapon == NULL or pPlayer.m_pNewWeapon == pPlayer:GetActiveWeapon()) then
				pPlayer.m_pNewWeapon = nil
			else
				-- Sometimes does not work the first time
				cmd:SelectWeapon(pPlayer.m_pNewWeapon)
			end
		end
	end)
	
	--[[hook.Add("SetupMove", "GSWeapons-Prone eye offset", function(pPlayer, mv)
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		
		if (pActiveWeapon.GSWeapon and pActiveWeapon:GetDeployed() ~= 0) then
			-- FIXME: SetDeployedEyeOffset
		end
	end)]]
	
	-- https://github.com/Facepunch/garrysmod-issues/issues/2887
	-- Scales the player's movement speeds based on their weapon
	hook.Add("Move", "GSWeapons-Punch decay and move speed", function(pPlayer, mv)
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		
		if (pActiveWeapon.GSWeapon) then
			if (pPlayer:Alive() and pActiveWeapon:GetDeployed() ~= 0) then
				--self.m_flDeployTime
			end
			
			if (pActiveWeapon.PunchDecayFunction) then
				pPlayer.dt.LastPunchAngle = pPlayer:GetViewPunchAngles()
			end
			
			local flOldSpeed = mv:GetMaxSpeed()
				* (pPlayer:KeyDown(IN_SPEED) and pActiveWeapon:GetSpecialKey("RunSpeed", pActiveWeapon:SpecialActive()) or pActiveWeapon:GetSpecialKey("WalkSpeed", pActiveWeapon:SpecialActive()))
			
			mv:SetMaxSpeed(flOldSpeed)
			mv:SetMaxClientSpeed(flOldSpeed)
		end
	end)
	
	hook.Add("FinishMove", "GSWeapons-Punch decay and deploy pose", function(pPlayer)
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		local fPunchDecay = pActiveWeapon.GSWeapon and pActiveWeapon.PunchDecayFunction
		
		if (fPunchDecay and pPlayer.dt.LastPunchAngle) then
			pPlayer:SetViewPunchAngles(fPunchDecay(pPlayer, pPlayer.dt.LastPunchAngle))
		end
		
		-- Can be done in PlayerPostThink, but no need to create another hook for this case
		--[[if (pActiveWeapon:GetDeployed()) then
			pPlayer:SetPoseParameter("body_height", pActiveWeapon.m_flDeployHeight - 4)
		end]]
	end)
end

if (CLIENT) then
	hook.Add("CreateMove", "GSWeapons-Deploy limits", function(mv)
		local pActiveWeapon = LocalPlayer():GetActiveWeapon()
		
		if (pActiveWeapon.GSWeapon and pActiveWeapon:GetDeployed() ~= 0) then
			local aView = mv:GetViewAngles()
			local tDeploy = pActiveWeapon.BipodDeploy
			
			-- Not actually delta, just saving a var
			local flDelta = aView[1]
			local bSet = false
			
			if (flDelta < tDeploy.MinPitch) then
				aView[1] = tDeploy.MinPitch
				bSet = true
			elseif (flDelta > tDeploy.MaxPitch) then
				aView[1] = tDeploy.MaxPitch
				bSet = true
			end
			
			flDelta = math.NormalizeAngle(aView[2] - pActiveWeapon.m_flDeployYawStart)
			
			if (flDelta < pActiveWeapon.m_flDeployYawRight) then
				aView[2] = pActiveWeapon.m_flDeployYawStart + pActiveWeapon.m_flDeployYawRight
				bSet = true
			elseif (flDelta > pActiveWeapon.m_flDeployYawLeft) then
				aView[2] = pActiveWeapon.m_flDeployYawStart + pActiveWeapon.m_flDeployYawLeft
				bSet = true
			end
			
			if (bSet) then
				mv:SetViewAngles(aView)
			end
		end
	end)
end

local PLAYER = FindMetaTable("Player")

function code_gs.weapons.SetupPlayerDataTables(pPlayer)
	-- For CS:S ViewPunching
	pPlayer:DTVar("Bool", 0, "PunchDirection")
	pPlayer:DTVar("Angle", 0, "LastPunchAngle")
	
	-- For CS:S flashing
	pPlayer:DTVar("Float", 0, "FlashDuration")
	pPlayer:DTVar("Float", 1, "FlashMaxAlpha")
end

-- Shared version of SelectWeapon
function PLAYER:SwitchWeapon(weapon)
	if (isstring(weapon)) then
		local pWeapon = self:GetWeapon(weapon)
		
		if (pWeapon ~= NULL) then
			self.m_pNewWeapon = pWeapon
		end
	elseif (weapon:GetOwner() == self) then
		self.m_pNewWeapon = weapon
	end
end

function PLAYER:CSDecayPunchAngle(aPunch)
	local flLen = aPunch:NormalizeInPlace()
	flLen = flLen - (10 + flLen * 0.5) * FrameTime()
	
	return aPunch * (flLen < 0 and 0 or flLen)
end

if (SERVER) then
	local mp_fadetoblack = GetConVar("mp_fadetoblack")
	local cSpec = Color(255, 255, 255, 150)

	function PLAYER:IsBlind()
		return CurTime() < (self.m_flBlindUntilTime or 0)
	end

	function PLAYER:Blind(flHoldTime, flFadeTime, iAlpha)
		// Don't flash a spectator
		local flCurTime = CurTime()
		local nMode = self:GetObserverMode()
		
		// estimate when we can see again
		local flOldBlindStart = self.m_flBlindStartTime or 0
		local flOldBlindUntil = self.m_flBlindUntilTime or 0
		
		// adjust the hold time to match the fade time.
		local flHalfFade = flFadeTime * 0.5
		local flNewBlindUntil = flCurTime + flHoldTime + flHalfFade
		self.m_flBlindStartTime = flCurTime
		self.m_flBlindUntilTime = flNewBlindUntil > flOldBlindUntil and flNewBlindUntil or flOldBlindUntil
		
		// Spectators get a lessened flash
		if (nMode == OBS_MODE_NONE or nMode == OBS_MODE_IN_EYE) then
			if (flCurTime > flOldBlindUntil) then
				// The previous flashbang is wearing off, or completely gone
				self.dt.FlashDuration = flFadeTime / 1.4
				self.dt.FlashMaxAlpha = iAlpha
			else
				// The previous flashbang is still going strong - only extend the duration
				local flRemaining = flOldBlindStart + self.dt.FlashDuration - flCurTime
				self.dt.FlashDuration = flRemaining > flFadeTime and flRemaining or flFadeTime
				
				local iMaxAlpha = self.dt.FlashMaxAlpha or 0
				self.dt.FlashMaxAlpha = iMaxAlpha > iAlpha and iMaxAlpha or iAlpha
			end
		elseif (not mp_fadetoblack:GetBool()) then
			// make sure the spectator flashbang time is 1/2 second or less.
			self:ScreenFade(SCREENFADE.IN, cSpec, flFadeTime < 0.5 and flFadeTime or 0.5, flHalfFade < flHoldTime and flHalfFade or flHoldTime)
		end
	end

	function PLAYER:Deafen(flDistance)
		// Spectators don't get deafened
		local nMode = self:GetObserverMode()
		
		if ((nMode == OBS_MODE_NONE or nMode == OBS_MODE_IN_EYE) and flDistance < 1000) then
			// dsp presets are defined in hl2/scripts/dsp_presets.txt
			self:SetDSP(flDistance < 600 and 37 or flDistance < 800 and 36 or 35, false) -- 134, 135, 136
		end
	end
end
