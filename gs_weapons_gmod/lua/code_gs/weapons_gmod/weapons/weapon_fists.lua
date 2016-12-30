SWEP.Base = "gs_baseweapon"

SWEP.Author = "code_gs, robotboy655, Tenrys, & MaxOfS2D (model)"
SWEP.Spawnable = true
SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.UseHands = true
SWEP.WorldModel = ""
SWEP.HoldType = "fist"

SWEP.Activities = {
	draw = "fists_draw",
	holster = "fists_holster",
	idle = {{"fists_idle_01", "fists_idle_02"}},
	hit = "fists_left",
	miss = "fists_left",
	hit_alt = "fists_right",
	miss_alt = "fists_right",
	critical = "fists_uppercut",
	admire = "seq_admire"
}

SWEP.Sounds = {
	hit = "Flesh.ImpactHard",
	hitworld = "Flesh.ImpactHard",
	miss = "WeaponFrag.Throw"
}

SWEP.Primary.Damage = function() return code_gs.random:RandomInt(8, 12) end
SWEP.Primary.Force = 80
SWEP.Primary.Range = 48
SWEP.Primary.Cooldown = 0.9
SWEP.Primary.Delay = 0.2
SWEP.Primary.ComboDamage = function() return code_gs.random:RandomInt(12, 24) end

SWEP.Secondary.MaxDamage = -1
SWEP.Secondary.ComboDamage = -1

SWEP.Melee = {
	AlwaysPlaySwing = true,
	TestHull = Vector(10, 10, 8),
	ComboCount = 2
}

if (CLIENT) then
	SWEP.ViewModelFOV = 54
end

if (SERVER or not game.SinglePlayer()) then
	function SWEP:Initialize()
		BaseClass.Initialize(self)
		
		self:SetupPredictedVar("m_iCombo", 0)
	end
	
	function SWEP:ItemFrame()
		if (self:GetOwner():MouseLifted() and self:GetNextPrimaryFire() < CurTime()) then
			self:SetPredictedVar("m_iCombo", 0)
		end
	end
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack(0)) then
		self:Swing(false, 0)
		self:SetNextSecondaryFire(CurTime() + self:GetSpecialKey("Cooldown", false))
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack(0)) then
		self:Swing(true, 0)
		self:SetNextSecondaryFire(CurTime() + self:GetSpecialKey("Cooldown", true))
		
		return true
	end
	
	return false
end

function SWEP:CanReload()
	local flNextReload = self:GetNextReload()
	
	if (flNextReload == -1 or flNextReload > CurTime()) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		return false
	end
	
	return true
end

function SWEP:Reload()
	if (self:CanReload()) then
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
		
		local bAdmired = false
		
		self:AddEvent("admire", self:PlayActivity("holster", 0) and self:SequenceLength(0) or 0, function()
			if (bAdmired) then
				local flNextTime = CurTime() + (self:PlayActivity("draw") and self:SequenceLength(0) or 0)
				self:SetNextPrimaryFire(flNextTime)
				self:SetNextSecondaryFire(flNextTime)
				self:SetNextReload(flNextTime)
				
				return true
			end
			
			bAdmired = true
			
			return self:PlayActivity("admire") and self:SequenceLength(0) or 0
		end)
	end
end

function SWEP:Smack(tr, vForward, bSecondary, iIndex)
	BaseClass.Smack(self, tr, vForward, bSecondary, iIndex)
	
	if (tr.Fraction == 1 or self:GetPredictedVar("m_iCombo") == 2) then
		self:SetPredictedVar("m_iCombo", 0)
	end
end

local phys_pushscale = GetConVar("phys_pushscale")

function SWEP:SmackDamage(tr, vForward, bSecondary)
	local pPlayer = self:GetOwner()
	local pEntity = tr.Entity
	
	local info = DamageInfo()
		code_gs.random:SetSeed(self:GetOwner():GetMD5Seed() % 0x100)
		
		if (self:GetPredictedVar("m_iCombo") == self.Melee.ComboCount) then
			info:SetDamage(self:GetSpecialKey("ComboDamage", bSecondary))
			info:SetDamageForce(vForward:Up() * 5158 + vForward * 10012)
		else
			info:SetDamage(self:GetSpecialKey("Damage", bSecondary))
			
			if (bSecondary) then
				info:SetDamageForce(vForward:Right() * -4912 + vForward * 9989)
			else
				info:SetDamageForce(vForward:Right() * 4912 + vForward * 9998)
			end
		end
		
		info:SetAttacker(pPlayer)
		info:SetInflictor(self)
		info:SetDamageType(self.Melee.DamageType)
		info:SetDamagePosition(tr.HitPos)
		info:SetReportedPosition(tr.StartPos)
	pEntity:DispatchTraceAttack(info, tr, vForward)
	
	local pPhysObj = pEntity:GetPhysicsObject()
	
	if (pPhysObj:IsValid()) then
		pPhysObj:ApplyForceOffset(vForward * pPhysObj:GetMass() * self:GetSpecialKey("Force", bSecondary) * phys_pushscale:GetFloat(), tr.HitPos)
	end
end

local tCriticalActs = {
	hit = true,
	miss = true,
	hit_alt = true,
	miss_alt = true
}
-- FIXME: Change all PlayActivity overrides to lowercase cases
function SWEP:PlayActivity(Activity, iIndex --[[= 0]], flRate --[[= 1]], bStrictPrefix --[[= false]], bStrictSuffix --[[= false]])
	return BaseClass.PlayActivity(self, isstring(Activity) and tCriticalActs[Activity:lower()] and self:GetPredictedVar("m_iCombo") == 2 and "critical" or Activity, iIndex, flRate, bStrictPrefix, bStrictSuffix)
end

function SWEP:DoImpactEffect()
	return true
end
