SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "CSBase"
SWEP.Author = "code_gs & Valve"

SWEP.UnderwaterCooldown = 0.15

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
	
	SWEP.Primary.BobCycle = 0.8
	SWEP.Primary.BobUp = 0.5
end

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	self.PunchDecayFunction = PLAYER.CSDecayPunchAngle
end

function SWEP:CanPrimaryAttack(iIndex)
	if (self:EventActive("fire") or self:GetNextPrimaryFire() == -1) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		return false
	end
	
	local iWaterLevel = pPlayer:WaterLevel()
	
	if (iWaterLevel == 0 and not (self.Primary.FireInAir or pPlayer:OnGround())) then
		return false
	end
	
	local iClip = self:Clip1()
	local bEmpty
	
	if (iClip == -1) then
		if (self:GetDefaultClip1() == -1) then
			bEmpty = false
		else
			bEmpty = pPlayer:GetAmmoCount(self:GetPrimaryAmmoName()) == 0
		end
	else
		bEmpty = iClip == 0
	end
	
	if (self:EventActive("reload")) then
		if (bEmpty) then
			return false
		end
		
		if (self.SingleReload.Enable and self.SingleReload.QueuedFire) then
			self:AddEvent("fire", self:SequenceEnd(iIndex), function()
				self:PrimaryAttack()
				self:RemoveEvent("reload")
				self:SetNextReload(0)
				
				if (bSinglePlayer) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				return true
			end)
			
			return false
		end
		
		if (not self.Primary.InterruptReload or not self.Primary.FireUnderwater and iWaterLevel == 3) then
			return false
		end
		
		self:RemoveEvent("reload")
		self:SetNextReload(0)
		
		if (bSinglePlayer) then
			net.Start("GS-Weapons-Finish reload")
			net.Send(pPlayer)
		end
	end
	
	-- CS:S gives priority to underwater over empty clip
	if (not self.Primary.FireUnderwater and iWaterLevel == 3) then
		self:HandleFireUnderwater(false, iIndex)
		
		return false
	end
	
	if (bEmpty) then
		self:HandleFireOnEmpty(false, iIndex)
		
		return false
	end
	
	return true
end

function SWEP:CanSecondaryAttack(iIndex)
	if (self:EventActive("fire") or self:GetNextSecondaryFire() == -1) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		return false
	end
	
	local iWaterLevel = pPlayer:WaterLevel()
	
	if (iWaterLevel == 0 and not (self.Secondary.FireInAir or pPlayer:OnGround())) then
		return false
	end
	
	local iClip = self.CheckClip1ForSecondary and self:Clip1() or self:Clip2()
	local bEmpty
	
	if (iClip == -1) then
		if (self:GetDefaultClip2() == -1) then
			bEmpty = false
		else
			bEmpty = pPlayer:GetAmmoCount(self.CheckClip1ForSecondary and self:GetPrimaryAmmoName() or self:GetSecondaryAmmoName()) == 0
		end
	else
		bEmpty = iClip == 0
	end
	
	if (self:EventActive("reload")) then
		if (bEmpty) then
			return false
		end
		
		if (self.SingleReload.Enable and self.SingleReload.QueuedFire) then
			self:AddEvent("fire", self:SequenceEnd(iIndex), function()
				self:SecondaryAttack()
				self:RemoveEvent("reload")
				self:SetNextReload(0)
				
				if (bSinglePlayer) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				return true
			end)
			
			return false
		end
		
		if (not self.Secondary.InterruptReload or not self.Secondary.FireUnderwater and iWaterLevel == 3) then
			return false
		end
		
		self:RemoveEvent("reload")
		self:SetNextReload(0)
		
		if (bSinglePlayer) then
			net.Start("GS-Weapons-Finish reload")
			net.Send(pPlayer)
		end
	end
	
	if (bEmpty) then
		self:HandleFireOnEmpty(true, iIndex)
		
		return false
	end
	
	if (not self.Secondary.FireUnderwater and iWaterLevel == 3) then
		self:HandleFireUnderwater(true, iIndex)
		
		return false
	end
	
	return true
end

-- Punch angles get more influence with CS:S weapons
function SWEP:GetShootAngles()
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + 2 * pPlayer:GetViewPunchAngles()
end
