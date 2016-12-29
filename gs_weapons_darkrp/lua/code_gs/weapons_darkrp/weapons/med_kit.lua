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

SWEP.Base = "weapon_rp_base"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_medkit.mdl" -- FIXME
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.HoldType = "slam"

-- Giving DefaultClip ammo while leaving the clip as -1 will not display a reserve on the ammo counter
SWEP.Primary.Ammo = "Health"
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Range = 90
SWEP.Primary.Cooldown = 0.2

SWEP.Secondary.Cooldown = 0.5

SWEP.Sounds = {
	heal = "hl1/fvox/boop.wav",
	reload = {
		sound = {
			"npc_citizen.health01",
			"npc_citizen.health02",
			"npc_citizen.health03",
			"npc_citizen.health04",
			"npc_citizen.health05"
		}
	}
}

SWEP.CheckClip1ForSecondary = true

SWEP.TauntTime = 2
SWEP.RegenRate = 0.5 -- FIXME
SWEP.RegenAmount = 1

function SWEP:CanPrimaryAttack(iIndex)
	if (BaseClass.CanPrimaryAttack(self, iIndex)) then
		local tr = self:GetOwner():GetEyeTrace()
		local pEntity = tr.Entity
		
		if ((pEntity:IsPlayer() or pEntity:IsNPC()) and self:GetShootSrc():DistToSqr(tr.HitPos) <= self:GetSpecialKey("Range", false) ^ 2
		and pEntity:Health() < pEntity:GetMaxHealth()) then
			return true
		end
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
		
		local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", true)
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
		
		return true
	end
	
	return false
end

function SWEP:CanReload()
	local flNextReload = self:GetNextReload()
	
	return not (flNextReload == -1 or flNextReload > CurTime())
end

function SWEP:Reload()
	if (self:CanReload()) then
		self:PlaySound("reload")
		self:SetNextReload(-1)
		
		self:AddEvent("taunt", 0, function()
			if (not self:GetOwner():KeyDown(IN_RELOAD)) then
				self:SetNextReload(CurTime() + self.TauntTime)
				
				return true
			end
		end)
		
		return true
	end
	
	return false
end

if (SERVER) then
	function SWEP:ItemFrame()
		local pPlayer = self:GetOwner()
		
		if (pPlayer:MouseLifted()) then
			local sAmmo = self:GetPrimaryAmmoName()
			
			if (pPlayer:GetAmmoCount(sAmmo) < self:GetDefaultClip1()) then
				pPlayer:GiveAmmo(self.RegenAmount, sAmmo, true)
			end
		end
		
		self:SetNextItemFrame(CurTime() + self.RegenRate)
	end
end
