game.AddAmmoType({
	name = "Health",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
})

SWEP.Base = "gs_baseweapon"

SWEP.Author = "code_gs, robotboy655, & MaxOfS2D (model)"
SWEP.Spawnable = true
SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.HoldType = "slam"

SWEP.Sounds = {
	heal = "HealthKit.Touch",
	empty = "WallHealth.Deny"
}

SWEP.Activities = {
	heal = ACT_VM_PRIMARYATTACK
}

SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Health"
SWEP.Primary.Deduction = 20
SWEP.Primary.Cooldown = 0.5

SWEP.Secondary.Automatic = false
SWEP.Secondary.Deduction = 20

SWEP.EmptyCooldown = 1

SWEP.RegenRate = 1
SWEP.RegenAmount = 2

if (CLIENT) then
	SWEP.ViewModelFOV = 54
end

function SWEP:CanPrimaryAttack(iIndex)
	if (BaseClass.CanPrimaryAttack(self, iIndex)) then
		local tr = self:GetOwner():GetEyeTrace()
		local pEntity = tr.Entity
		
		if ((pEntity:IsPlayer() or pEntity:IsNPC()) and self:GetShootSrc():DistToSqr(tr.HitPos) <= self:GetSpecialKey("Range", false) ^ 2
		and pEntity:Health() < pEntity:GetMaxHealth()) then
			return true
		end
		
		self:HandleFireOnEmpty(false, iIndex)
	end
	
	return false
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack()) then
		local pPlayer = self:GetOwner()
		local pEntity = pPlayer:GetEyeTrace().Entity
		local iHealth = pEntity:Health()
		
		local iDeduct = math.min(self:GetSpecialKey("Deduction", false), pEntity:GetMaxHealth() - iHealth)
		pEntity:SetHealth(iHealth + iDeduct)
		pPlayer:RemoveAmmo(iDeduct, self:GetPrimaryAmmoName())
		
		self:PlaySound("heal")
		self:PlayActivity("heal")
		pPlayer:SetAnimation(PLAYER_ATTACK1)
		
		local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", false)
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
		
		return true
	end
	
	return false
end

function SWEP:CanSecondaryAttack(bSecondary, iIndex)
	if (BaseClass.CanSecondaryAttack(self, bSecondary, iIndex)) then
		local pPlayer = self:GetOwner()
		
		if (pPlayer:Health() < pPlayer:GetMaxHealth()) then
			return true
		end
		
		self:HandleFireOnEmpty(true, iIndex)
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack()) then
		local pPlayer = self:GetOwner()
		local iHealth = pPlayer:Health()
		
		local iDeduct = math.min(self:GetSpecialKey("Deduction", true), pPlayer:GetMaxHealth() - iHealth)
		pPlayer:SetHealth(iHealth + iDeduct)
		pPlayer:RemoveAmmo(iDeduct, self:GetPrimaryAmmoName())
		
		self:PlaySound("heal")
		self:PlayActivity("heal")
		pPlayer:SetAnimation(PLAYER_ATTACK1)
		
		local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", true)
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
		
		return true
	end
	
	return false
end

if (SERVER) then
	function SWEP:ItemFrame()
		local pPlayer = self:GetOwner()
		
		if (pPlayer:MouseLifted()) then
			local sAmmo = self:GetPrimaryAmmoName()
			local iAmmoCount = pPlayer:GetAmmoCount(sAmmo)
			local iDefaultClip = self:GetDefaultClip1()
			
			if (iAmmoCount < iDefaultClip) then
				pPlayer:GiveAmmo(math.min(self.RegenAmount, iDefaultClip - iAmmoCount), sAmmo, true)
			end
		end
		
		self:SetNextItemFrame(CurTime() + self.RegenRate)
	end
end
