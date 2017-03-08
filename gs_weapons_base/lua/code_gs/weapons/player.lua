code_gs.weapons.NewWeapons = {}
code_gs.weapons.LastWeapon = {}

if (SERVER or not game.SinglePlayer()) then
	-- Handles weapon switching
	hook.Add("StartCommand", "GS-Weapons-Shared SelectWeapon", function(pPlayer, cmd)
		local pNewWeapon = code_gs.weapons.NewWeapons[pPlayer]
		
		if (pNewWeapon) then
			local pActiveWeapon = pPlayer:GetActiveWeapon()
			
			if (pNewWeapon == pActiveWeapon or not (code_gs.weapons.LastWeapon[pPlayer] == pActiveWeapon and pNewWeapon:IsValid() and pNewWeapon:GetOwner() == pPlayer)) then
				code_gs.weapons.NewWeapons[pPlayer] = nil
				code_gs.weapons.LastWeapon[pPlayer] = nil
			else
				-- Sometimes does not work the first time
				cmd:SelectWeapon(pNewWeapon)
			end
		end
	end)
	
	local nNoJump = bit.bnot(IN_JUMP)
	
	hook.Add("SetupMove", "GS-Weapons-Deployed eye offset", function(pPlayer, mv)
		local pWeapon = pPlayer:GetActiveWeapon()
		
		if (pWeapon.GSWeapon) then
			if (pWeapon:GetBipodDeployed()) then
				mv:SetMaxClientSpeed(1) -- PLAYER_SPEED_FROZEN is 1, not 0. Don't know why
				mv:SetButtons(bit.band(mv:GetButtons(), nNoJump))
				pPlayer:RemoveFlags(FL_DUCKING) -- FIXME: Not working properly. Store the crouch state pre-deploy
				
				// anim to deployed
				if (pWeapon:GetPredictedVar("DeployUpdateViewAnim", false)) then
					// Deployed height
					local vOffsetZ = pPlayer:GetCurrentViewOffset()[3] -- Only interested in the height
					pWeapon:SetPredictedVar("DeployViewStartHeight", vOffsetZ)
					pWeapon:SetPredictedVar("DeployViewEndHeight", math.Clamp(pWeapon:GetPredictedVar("DeployHeight", 0), 28, 58)) -- FIXME: Scale to player height
					
					pWeapon:SetPredictedVar("DeployUpdateViewAnim", false)
				end
			// anim to undeployed
			elseif (pWeapon:GetPredictedVar("DeployUpdateViewAnim", false)) then
				pWeapon:SetPredictedVar("DeployViewStartHeight", pPlayer:GetCurrentViewOffset()[3])
				pWeapon:SetPredictedVar("DeployViewEndHeight", pPlayer:IsFlagSet(FL_DUCKING) and pPlayer:GetViewOffsetDucked()[3] or pPlayer:GetViewOffset()[3])
				
				pWeapon:SetPredictedVar("DeployUpdateViewAnim", false)
			end
		end
	end)
	
	-- https://github.com/Facepunch/garrysmod-issues/issues/2887
	-- Scales the player's movement speeds based on their weapon
	hook.Add("Move", "GS-Weapons-Punch decay and move speed", function(pPlayer, mv)
		local pWeapon = pPlayer:GetActiveWeapon()
		
		if (pWeapon.GSWeapon) then
			if (pWeapon:GetBipodDeployed()) then
				local flEndTime = pWeapon:GetPredictedVar("DeployEndTime", 0)
				local flCurTime = CurTime()
				
				if (flEndTime > CurTime()) then
					local flFraction = (flEndTime - flCurTime) / pWeapon:GetPredictedVar("DeployLength", 1) -- FIXME
					local vCurrentView = pPlayer:GetCurrentViewOffset()
					vCurrentView[3] = flFraction * pWeapon:GetPredictedVar("DeployViewStartHeight", 0) + (1 - flFraction) * pWeapon:GetPredictedVar("DeployViewEndHeight", 0)
					pPlayer:SetCurrentViewOffset(vCurrentView)
				else
					local vCurrentView = pPlayer:GetCurrentViewOffset()
					vCurrentView[3] = pWeapon:GetPredictedVar("DeployViewEndHeight", 0)
					pPlayer:SetCurrentViewOffset(vCurrentView)
				end
			else
				local flOldSpeed = mv:GetMaxSpeed()
				* (pPlayer:KeyDown(IN_SPEED) and pWeapon:GetRunSpeed() or pWeapon:GetWalkSpeed())
				
				mv:SetMaxSpeed(flOldSpeed)
				mv:SetMaxClientSpeed(flOldSpeed)
			end
			
			if (pWeapon.PunchDecayFunction) then
				code_gs.weapons.SetNWVar(pPlayer, "Angle", "LastPunchAngle", pPlayer:GetViewPunchAngles())
			end
		end
	end)
	
	hook.Add("FinishMove", "GS-Weapons-Punch decay and deploy pose", function(pPlayer)
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		local fPunchDecay = pActiveWeapon.GSWeapon and pActiveWeapon.PunchDecayFunction
		
		if (fPunchDecay) then
			local aLastPunch = code_gs.weapons.GetNWVar(pPlayer, "Angle", "LastPunchAngle")
			pPlayer:SetViewPunchAngles(fPunchDecay(pPlayer, aLastPunch))
		end
		
		-- Can be done in PlayerPostThink, but no need to create another hook for this case
		--[[if (pActiveWeapon:GetBipodDeployed()) then
			pPlayer:SetPoseParameter("body_height", pActiveWeapon:GetPredictedVar("DeployHeight", 0) - 4)
		end]]
	end)
end

-- Shared version of SelectWeapon
function code_gs.weapons.SelectWeapon(pPlayer, Weapon)
	if (isstring(Weapon)) then
		local pWeapon = pPlayer:GetWeapon(Weapon)
		
		if (pWeapon:IsValid()) then
			code_gs.weapons.NewWeapons[pPlayer] = pWeapon
			code_gs.weapons.LastWeapon[pPlayer] = pPlayer:GetActiveWeapon()
		end
	elseif (Weapon:IsValid() and Weapon:GetOwner() == pPlayer) then
		code_gs.weapons.NewWeapons[pPlayer] = Weapon
		code_gs.weapons.LastWeapon[pPlayer] = pPlayer:GetActiveWeapon()
	end
end

local PLAYER = FindMetaTable("Player")
PLAYER.SelectWeapon = code_gs.weapons.SelectWeapon

function code_gs.weapons.CSDecayPunchAngle(aPunch)
	local flLen = aPunch:NormalizeInPlace()
	flLen = flLen - (10 + flLen * 0.5) * FrameTime()
	
	return aPunch * (flLen < 0 and 0 or flLen)
end

if (SERVER) then
	local mp_fadetoblack = GetConVar("mp_fadetoblack")
	local cSpec = Color(255, 255, 255, 150)
	
	-- FIXME: Don't make these meta functions
	function PLAYER:IsBlind()
		return CurTime() < (self.gs_m_flBlindUntilTime or 0)
	end

	function PLAYER:Blind(flHoldTime, flFadeTime, iAlpha)
		// Don't flash a spectator
		local flCurTime = CurTime()
		local nMode = self:GetObserverMode()
		
		// estimate when we can see again
		local flOldBlindStart = self.gs_m_flBlindStartTime or 0
		local flOldBlindUntil = self.gs_m_flBlindUntilTime or 0
		
		// adjust the hold time to match the fade time.
		local flHalfFade = flFadeTime * 0.5
		local flNewBlindUntil = flCurTime + flHoldTime + flHalfFade
		self.gs_m_flBlindStartTime = flCurTime
		self.gs_m_flBlindUntilTime = flNewBlindUntil > flOldBlindUntil and flNewBlindUntil or flOldBlindUntil
		
		// Spectators get a lessened flash
		if (nMode == OBS_MODE_NONE or nMode == OBS_MODE_IN_EYE) then
			if (flCurTime > flOldBlindUntil) then
				// The previous flashbang is wearing off, or completely gone
				code_gs.weapons.SetNWVar(self, "Float", "FlashDuration", flFadeTime / 1.4)
				code_gs.weapons.SetNWVar(self, "Float", "FlashMaxAlpha", iAlpha)
			else
				// The previous flashbang is still going strong - only extend the duration
				local flRemaining = flOldBlindStart + code_gs.weapons.GetNWVar(self, "Float", "FlashDuration", 0) - flCurTime
				code_gs.weapons.SetNWVar(self, "Float", "FlashDuration", flRemaining > flFadeTime and flRemaining or flFadeTime)
				
				local iMaxAlpha = code_gs.weapons.GetNWVar(self, "Float", "FlashMaxAlpha", 0)
				code_gs.weapons.SetNWVar(self, "Float", "FlashMaxAlpha", iMaxAlpha > iAlpha and iMaxAlpha or iAlpha)
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
else
	code_gs.weapons.CS_NewWeapons = {}
	code_gs.weapons.CS_LastWeapon = {}
	
	hook.Add("CreateMove", "GS-Weapons-Deploy limits", function(mv)
		local pPlayer = LocalPlayer()
		
		if (pPlayer == NULL) then
			return
		end
		
		local pWeapon = pPlayer:GetActiveWeapon()
		local pNewWeapon = code_gs.weapons.CS_NewWeapons[pPlayer]
		
		if (pNewWeapon) then
			if (code_gs.weapons.CS_LastWeapon[pPlayer] ~= pWeapon or pNewWeapon == NULL or pNewWeapon:GetOwner() ~= pPlayer) then
				code_gs.weapons.CS_NewWeapons[pPlayer] = nil
				code_gs.weapons.CS_LastWeapon[pPlayer] = nil
			else
				-- Sometimes does not work the first time
				cmd:SelectWeapon(pNewWeapon)
			end
		end
		
		if (pWeapon.GSWeapon and pWeapon:GetBipodDeployed()) then
			local aView = mv:GetViewAngles()
			local tDeploy = pWeapon.BipodDeploy
			
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
			
			local flYawStart = self:GetPredictedVar("DeployYawStart", 0)
			flDelta = math.NormalizeAngle(aView[2] - flYawStart)
			local flYawLimit = pWeapon:GetPredictedVar("DeployYawRight", 0)
			
			if (flDelta < flYawLimit) then
				aView[2] = flYawStart + flYawLimit
				bSet = true
			else
				local flYawLimit = pWeapon:GetPredictedVar("DeployYawLeft", 0)
				
				if (flDelta > flYawLimit) then
					aView[2] = flYawStart + flYawLimit
					bSet = true
				end
			end
			
			if (bSet) then
				mv:SetViewAngles(aView)
			end
		end
	end)
	
	hook.Add("PrePlayerDraw", "GS-Weapons-Deploy pose parameters", function(pPlayer)
		local pWeapon = pPlayer:GetActiveWeapon()
		
		if (pWeapon.GSWeapon and pWeapon:GetBipodDeployed()) then
			// Set the 9-way blend movement pose parameters.
			pPlayer:SetPoseParameter("move_x", 0)
			pPlayer:SetPoseParameter("move_y", 0)
			pPlayer:InvalidateBoneCache() -- FIXME: Needed?
		end
	end)
	
	function code_gs.weapons.CS_SelectWeapon(pPlayer, Weapon)
		if (isstring(Weapon)) then
			local pWeapon = pPlayer:GetWeapon(sClass)
			
			if (pWeapon:IsValid()) then
				code_gs.weapons.CS_NewWeapons[pPlayer] = pWeapon
				code_gs.weapons.CS_LastWeapon[pPlayer] = pPlayer:GetActiveWeapon()
			end
		elseif (Weapon:IsValid() and Weapon:GetOwner() == pPlayer) then
			code_gs.weapons.CS_NewWeapons[pPlayer] = pWeapon
			code_gs.weapons.CS_LastWeapon[pPlayer] = pPlayer:GetActiveWeapon()
		end
	end
end
