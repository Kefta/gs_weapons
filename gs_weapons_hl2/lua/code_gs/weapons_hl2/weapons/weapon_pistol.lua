do return true end

SWEP.Base = "basehlcombatweapon"

SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 2

SWEP.Activities = {
	shoot_empty = ACT_INVALID,
	shoot_alt = ACT_VM_RECOIL1,
	shoot_al2 = ACT_VM_RECOIL2,
	shoot_alt3 = ACT_VM_RECOIL3,
	empty = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	reload = "Weapon_Pistol.Reload",
	empty = "Weapon_Pistol.Empty",
	shoot = "Weapon_Pistol.Single"
}

SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Damage = 8
SWEP.Primary.Cooldown = 0.5
SWEP.Primary.Spread = VECTOR_CONE_1DEGREES
SWEP.Primary.OldSpread = VECTOR_CONE_4DEGREES

SWEP.Secondary.Spread = VECTOR_CONE_6DEGREES
SWEP.Secondary.OldSpread = -1

SWEP.PunchRand = {
	XMin = 0.25,
	XMax = 0.5,
	YMin, -0.6,
	YMax = 0.6
}

SWEP.Refire = 0.1 -- Fastest refire time after lifting mouse
SWEP.AccuracyPenalty = 0.2 // Applied amount of time each shot adds to the time we must recover from
SWEP.MaxAccuracyPenalty = 1.5 // Maximum penalty to deal out

if (CLIENT) then
	SWEP.KillIcon = '-'
	SWEP.SelectionIcon = 'd'
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	
	self:AddNWVar("Bool", "DryFired", false)
	self:AddNWVar("Bool", "MouseHeld", false)
	self:AddNWVar("Int", "AnimLevel", false)
	self:AddNWVar("Float", "AccuracyPenalty", false)
	self:AddNWVar("Float", "LastAttackTime", false)
end

local bSinglePlayer = game.SinglePlayer()

function SWEP:SharedDeploy(bDelayed, bNoPrediction)
	BaseClass.SharedDeploy(self, bDelayed, bNoPrediction)
	
	if (not bDelayed and (not bSinglePlayer or SERVER)) then
		self.dt.DryFired = false
	end
end

function SWEP:ItemFrame()
	if (not (bSinglePlayer and CLIENT or self:GetOwner():KeyDown(IN_ATTACK))) then
		self.dt.MouseHeld = false
		local flCurTime = CurTime()
		
		if (self.dt.LastAttackTime + self.Refire < flCurTime) then
			local flAccuracyPenalty = self.dt.AccuracyPenalty - FrameTime()
			self.dt.AccuracyPenalty = flAccuracyPenalty < 0 and 0 or flAccuracyPenalty
			
			if (not self:EventActive("reload")) then
				//Allow a refire as fast as the player can click
				self:SetNextPrimaryFire(flCurTime)
			end
		end
	end
end

function SWEP:ReloadClips()
	BaseClass.ReloadClips(self)
	
	self.dt.AccuracyPenalty = 0
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	self:SetNextSecondaryFire(0)
	
	local flCurTime = CurTime()
	
	if (flCurTime - self.dt.LastAttackTime > self:GetSpecialKey("Cooldown", bSecondary)) then
		self.dt.AnimLevel = 0
	else
		local iLevel = self.dt.AnimLevel
		
		-- Don't update the networked value if we don't need to
		if (iLevel ~= 3) then
			self.dt.AnimLevel = iLevel + 1
		end
	end
	
	// Add an accuracy penalty which can move past our maximum penalty time if we're really spastic
	local flAccuracyPenalty = self.dt.AccuracyPenalty + self.AccuracyPenalty
	self.dt.AccuracyPenalty = flAccuracyPenalty > self.MaxAccuracyPenalty and self.MaxAccuracyPenalty or flAccuracyPenalty
	self.dt.LastAttackTime = flCurTime
	self.dt.DryFired = false
	self.dt.MouseHeld = true
end

function SWEP:SecondaryAttack()
	local flNextTime = CurTime() + 0.1
	self.dt.LastAttackTime = flNextTime
	self:SetNextPrimaryFire(flNextTime)
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local tPunch = self.PunchRand
	
	// Each time the player fires the pistol, reset the view punch. This prevents
	// the aim from 'drifting off' when the player fires very quickly. This may
	// not be the ideal way to achieve this, but it's cheap and it works, which is
	// great for a feature we're evaluating. (sjb)
	pPlayer:ViewPunchReset()
	pPlayer:ViewPunch(Angle(code_gs.random:RandomFloat(tPunch.XMin, tPunch.XMax), code_gs.random:RandomFloat(tPunch.YMin, tPunch.YMax), 0))
end

function SWEP:HandleFireOnEmpty(bSecondary)
	self.dt.LastAttackTime = CurTime()
	
	if (self.EmptyCooldown == -1) then
		BaseClass.HandleFireOnEmpty(self, bSecondary)
		
		return
	end
	
	if (self.dt.DryFired or not self.dt.MouseHeld) then
		local pPlayer = self:GetOwner()
		
		if (self.SwitchOnEmptyFire and not self:HasAmmo()) then
			pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon(self.HighWeightPriority)
			
			return
		end
		
		if (bSecondary and self.Secondary.ReloadOnEmptyFire or not bSecondary and self.Primary.ReloadOnEmptyFire) then
			self:SetNextReload(0)
			self:Reload()
			
			return
		end
	end
	
	self:PlaySound("empty")
	local bPlayed = self:PlayActivity("empty")
	self.dt.DryFired = true
	
	local flNextTime = CurTime() + (bPlayed and self:SequenceLength() or self.EmptyCooldown)
	self:SetNextPrimaryFire(flNextTime)
end

function SWEP:PlayActivity(sActivity, iIndex, flRate, bStrictPrefix, bStrictSuffix)
	if (sActivity == "shoot") then
		local iShotsFired = self.dt.AnimLevel
		
		return BaseClass.PlayActivity(self, iShotsFired == 0 and "shoot" or iShotsFired == 1 and "shoot_alt" or iShotsFired == 2 and "shoot_alt2" or "shoot_alt3", iIndex, flRate, bStrictPrefix, bStrictSuffix)
	end
	
	return BaseClass.PlayActivity(self, sActivity, iIndex, flRate, bStrictPrefix, bStrictSuffix)
end

local pistol_use_new_accuracy = GetConVar("pistol_use_new_accuracy")

function SWEP:GetSpecialKey(sKey, bSecondary, bNoConVar)
	if (sKey == "Spread") then
		// We lerp from very accurate to inaccurate over time
		return pistol_use_new_accuracy:GetBool()
			and LerpVector(math.Remap(self.dt.AccuracyPenalty, 0, self.MaxAccuracyPenalty, 0, 1), BaseClass.GetSpecialKey(self, sKey, false, bNoConVar), BaseClass.GetSpecialKey(self, sKey, true, bNoConVar))
			or BaseClass.GetSpecialKey(self, "OldSpread", bSecondary)
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar)
end
