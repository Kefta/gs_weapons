SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "CSBase"
SWEP.Author = "code_gs & Valve"

SWEP.Primary.UnderwaterCooldown = 0.15

// Override the bloat that our base class sets as it's a little bit bigger than we want.
// If it's too big, you drop a weapon and its box is so big that you're still touching it
// when it falls and you pick it up again right away.
SWEP.TriggerBoundSize = 30

if (CLIENT) then
	SWEP.KillIconFont = "CSSKillIcon"
	SWEP.SelectionFont = "CSSSelection"
	
	SWEP.ViewModelFlip = true
	SWEP.ViewModelFOV = 74
	SWEP.BobStyle = "css"
	SWEP.CrosshairStyle = "css"
	
	SWEP.BobCycle = 0.8
	SWEP.BobUp = 0.5
end

local bSinglePlayerPredicted = SERVER and game.SinglePlayer()
local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	self.PunchDecayFunction = PLAYER.CSDecayPunchAngle
end

-- Reverse the water/clip checks to give firing underwater priority in handling the empty sound time
function SWEP:CanAttack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (self:GetLowered(iIndex) or self:GetHideWeapon(iIndex) or self:GetShouldThrow(iIndex) ~= 0) then
		return false
	end
	
	if (not iIndex) then
		iIndex = 0
	end
	
	-- If the weapon has played its empty sound or is in a burst fire
	if (self:EventActive("empty_" .. (bSecondary and "secondary_" or "primary_") .. iIndex) or self:EventActive("burst_" .. iIndex)) then
		return false
	end
	
	local flCurTime = CurTime()
	
	-- If the viewmodel is in the middle of an important sequence
	if (self:GetHardSequenceEnd(iIndex) > flCurTime or self:GetNWVar("Float", "HolsterAnimEnd") > flCurTime
	-- No quick-scoping!
	or not self.Zoom.AllowFire and self:GetZoomActiveTime() > flCurTime) then
		return false
	end
	
	local bDelayedFire = self["m_bFireEvent" .. iIndex]
	local flNextAttack = self:GetNextAttack(bSecondary, iIndex)
	
	-- If there's already a queued fire, or the weapon can't fire yet
	if (not bDelayedFire and (self:EventActive("fire_" .. iIndex) or flNextAttack == -1 or flNextAttack > flCurTime)) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		return false
	end
	
	local iWaterLevel = pPlayer:WaterLevel()
	
	if (iWaterLevel == 0 and not (self:GetSpecialKey("FireInAir", bSecondary, iIndex) or pPlayer:OnGround())) then
		return false
	end
	
	local iClip = self:GetClip(bSecondary, iIndex)
	local bEmpty
	
	if (iClip <= -1) then
		if (self:GetDefaultClip(bSecondary, iIndex) <= -1) then
			bEmpty = false
		else
			bEmpty = pPlayer:GetAmmoCount(self:GetAmmoType(bSecondary, iIndex)) == 0
		end
	else
		bEmpty = iClip == 0
	end
	
	local bInReload = self:EventActive("reload_" .. iIndex)
	local bDoEmptyEvent = not (bInReload or bDelayedFire)
	
	if (iWaterLevel == 3 and not self:GetSpecialKey("FireUnderwater", bSecondary, iIndex)) then
		if (bDoEmptyEvent) then
			self:HandleFireUnderwater(bSecondary, iIndex)
		end
		
		return false
	end
	
	if (bEmpty) then
		if (bDoEmptyEvent) then
			self:HandleFireOnEmpty(bSecondary, iIndex)
		end
		
		return false
	end
	
	-- In the middle of a reload
	if (bInReload and not bDelayedFire) then
		-- Interrupt the reload to fire
		if (self:GetSpecialKey("InterruptReload", bSecondary, iIndex)) then
			-- Stop the reload
			self:RemoveReload(iIndex)
			
			if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
				net.Start("GS-Weapons-Finish reload")
				net.Send(pPlayer)
			end
		elseif (self:GetSpecialKey("FireAfterReload", bSecondary, iIndex)) then
			self:AddEvent("fire_" .. iIndex, self:SequenceEnd(iIndex), function()
				self["m_bFireEvent" .. iIndex] = true
				local flNextReload = self:GetNextReload(iIndex)
				
				self:Attack(bSecondary, iIndex)
				self:RemoveReload(iIndex)
				
				if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				self["m_bFireEvent" .. iIndex] = false
				
				return true
			end)
			
			return false
		end
	end
	
	return true
end

-- Punch angles get more influence with CS:S weapons
function SWEP:GetShootAngles()
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + 2 * pPlayer:GetViewPunchAngles()
end
