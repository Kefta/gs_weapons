SWEP.Base = "weapon_hlbase_machinegun"

SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"

SWEP.Weight = 5

SWEP.Activities = {
	shoot_empty = ACT_INVALID,
	empty = ACT_VM_DRYFIRE,
	charge = ACT_VM_FIDGET
}

SWEP.Sounds = {
	reload = "Weapon_AR2.Reload",
	empty = "Weapon_IRifle.Empty",
	shoot = "Weapon_AR2.Single",
	altfire = "Weapon_IRifle.Single",
	charge = "Weapon_CombineGuard.Special1"
}

SWEP.Primary.Ammo = "AR2"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Cooldown = 0.1
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = VECTOR_CONE_3DEGREES
SWEP.Primary.FireUnderwater = false

SWEP.Secondary.Ammo = "AR2AltFire"
SWEP.Secondary.DefaultClip = 2 -- Fix
SWEP.Secondary.Cooldown = 0.5
SWEP.Secondary.FireUnderwater = false

SWEP.TracerName = "AR2Tracer"

SWEP.PunchAngle = {
	VerticalKick = 8,
	SlideLimit = 5
}

SWEP.PunchRand = {
	XMin = -8,
	XMax = -12,
	YMin = 1,
	YMax = 2
}

SWEP.GrenadeClass = "prop_combine_ball"

if (CLIENT) then
	SWEP.KillIcon = '2'
	SWEP.SelectionIcon = 'l'
end

--[[function SWEP:ItemFrame()
	BaseClass.ItemFrame(self)
	
	local pViewModel = self:GetOwner():GetViewModel(0)
	
	if (pViewModel ~= NULL) then
		pViewModel:SetPoseParameter("VentPoses", math.Remap(self.dt.AnimLevel, 0, 5, 0, 1))
	end
end]]

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack(0)) then
		self:Shoot(false, 0)
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if (not self:CanSecondaryAttack(0)) then
		return false
	end
	
	self:PlaySound("charge")
	self:PlayActivity("charge")
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	
	local flCooldown = self:GetSpecialKey("Cooldown", true)
	
	self:AddEvent("charge", flCooldown, function()
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation(PLAYER_ATTACK1)
		pPlayer:RemoveAmmo(self:GetSpecialKey("Deduction", true), self:GetSecondaryAmmoName())
		
		// Register a muzzleflash for the AI
		self:DoMuzzleFlash()
		self:PlaySound("altfire")
		self:PlayActivity("altfire")
		self:Punch(true)
		
		local flNextTime = CurTime() + flCooldown
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime + flCooldown)
		self:SetNextReload(flNextTime)
		
		if (SERVER) then
			pPlayer:ScreenFade(SCREENFADE.IN, color_white, 0.1, 0)
			
			// Create the grenade
			local pBall = ents.Create(self.GrenadeClass)
			
			if (pBall ~= NULL) then
				pBall:SetPos(self:GetShootSrc())
				pBall:_SetAbsVelocity(self:GetShootAngles():Forward() * 1000) -- FIXME: Force key
				pBall:SetOwner(pPlayer)
				pBall:Spawn()
				pBall:EmitSound("NPC_CombineBall.Launch")
				
				local pPhysObj = pBall:GetPhysicsObject()
				
				if (pPhysObj:IsValid()) then
					pPhysObj:AddGameFlag(FVPHYSICS_WAS_THROWN)
				end
			end
		end
		
		return true
	end)
	
	return true
end

function SWEP:Punch(bSecondary)
	if (bSecondary) then
		local pPlayer = self:GetOwner()
		--[[local aPunch = pPlayer:GetLocalAngles()
		
		aPunch.x = aPunch.x + code_gs.random:RandomInt(-4, 4)
		aPunch.y = aPunch.y + code_gs.random:RandomInt(-4, 4)
		aPunch.z = 0
		
		pPlayer:SetEyeAngles(aPunch)]]
		
		-- Yes, the min/max are out of order on the pitch in the original weapon, too
		local tPunch = self.PunchRand
		pPlayer:ViewPunch(Angle(code_gs.random:SharedRandomInt(pPlayer, "ar2pax", tPunch.XMin, tPunch.XMax), code_gs.random:SharedRandomInt(pPlayer, "ar2pay", tPunch.YMin, tPunch.YMax), 0))
	else
		BaseClass.Punch(self, false)
	end
end

function SWEP:DoImpactEffect(tr)
	if (IsFirstTimePredicted()) then
		local data = EffectData()
			data:SetOrigin(tr.HitPos + tr.HitNormal)
			data:SetNormal(tr.HitNormal)
		util.Effect("AR2Impact", data)
	end
end
