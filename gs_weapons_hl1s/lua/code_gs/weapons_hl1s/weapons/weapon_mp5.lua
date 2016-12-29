SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/v_9mmAR.mdl"
SWEP.WorldModel = "models/w_9mmAR.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 15

SWEP.Activities = {
	priamry = {
		ACT_VM_PRIMARYATTACK,
		idle = {10, 15} -- FIXME: Not working
	},
	altfire = {
		ACT_VM_SECONDARYATTACK,
		idle = 5
	},
	idle = {
		ACT_VM_IDLE,
		idle = {3, 5}
	}
}

SWEP.Sounds = {
	shoot = "Weapon_MP5.Single",
	altfire = "Weapon_MP5.Double"
}

SWEP.Primary.Ammo = "9mmRound"
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 75
SWEP.Primary.Cooldown = 0.1
SWEP.Primary.Spread = game.SinglePlayer() and VECTOR_CONE_3DEGREES or VECTOR_CONE_6DEGREES

SWEP.Secondary.Ammo = "MP5_Grenade"
SWEP.Secondary.DefaultClip = 2
SWEP.Secondary.Cooldown = 1
SWEP.Secondary.PunchAngle = Angle(-10, 0, 0)
SWEP.Secondary.Force = 800

SWEP.EmptyCooldown = 0.15

SWEP.GrenadeClass = "grenade_mp5"

SWEP.PunchRand = {
	Min = -2,
	Max = 2
}

function SWEP:Precache()
	BaseClass.Precache(self)
	
	-- Secondary fire grenade model
	util.PrecacheModel("models/grenade.mdl")
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack(0)) then
		self:Shoot(false, 0)
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack(0)) then
		self:DoMuzzleFlash()
		self:Punch(true)
		
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation(PLAYER_ATTACK1)
		pPlayer:RemoveAmmo(1, self:GetSecondaryAmmoName())
		self:PlaySound("altfire")
		self:PlayActivity("altfire")
		
		local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", true)
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
		self:SetNextReload(flNextTime)
		
		if (SERVER) then
			local pGrenade = ents.Create(self.GrenadeClass)
			pGrenade:SetPos(self:GetShootSrc())
			local vThrow = self:GetShootAngles():Forward() * 800 -- FIXME: Force
			pGrenade:SetAngles(vThrow:Angle())
			pGrenade:_SetAbsVelocity(vThrow)
			pGrenade:SetOwner(pPlayer)
			
			-- Don't need to set the seed here since it's serverside only
			pGrenade:SetLocalAngularVelocity(Angle(code_gs.random:RandomFloat(-100, -500), 0, 0))
			pGrenade:Spawn()
			pGrenade:SetMoveType(MOVETYPE_FLYGRAVITY)
		end
	end
end

function SWEP:GetShootAmmoName(bSecondary)
	return bSecondary and self:GetSecondaryAmmoName() or self:GetPrimaryAmmoName()
end

function SWEP:Launch(bSecondary, iIndex)
	self:DoMuzzleFlash(bSecondary)
	self:Punch(bSecondary)
	
	local pPlayer = self:GetOwner()
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	pPlayer:RemoveAmmo(self:GetSpecialKey("Deduction", bSecondary), self:GetShootAmmoName(bSecondary))
	self:PlaySound("altfire")
	self:PlayActivity("altfire")
	
	local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", true)
	self:SetNextPrimaryFire(flNextTime)
	self:SetNextSecondaryFire(flNextTime)
	self:SetNextReload(flNextTime)
	
	if (SERVER) then
		local pGrenade = ents.Create(self.GrenadeClass)
		pGrenade:SetPos(self:GetShootSrc(bSecondary))
		local vThrow = self:GetShootDir(bSecondary) * self:GetSpecialKey("Force", bSecondary)
		pGrenade:SetAngles(vThrow:Angle())
		pGrenade:_SetAbsVelocity(vThrow)
		pGrenade:SetOwner(pPlayer)
		
		-- Don't need to set the seed here since it's serverside only
		pGrenade:SetLocalAngularVelocity(Angle(code_gs.random:RandomFloat(-100, -500), 0, 0))
		pGrenade:Spawn()
		pGrenade:SetMoveType(MOVETYPE_FLYGRAVITY)
	end
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	self:SetNextSecondaryFire(0) -- Don't penalise secondary time
end

function SWEP:GetSpecialKey(sKey, bSecondary, bNoConVar)
	if (not bSecondary and sKey == "PunchAngle") then
		local tBounds = self.PunchRand
		
		return Angle(code_gs.random:RandomFloat(tBounds.Min, tBounds.Max), 0, 0)
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar)
end
