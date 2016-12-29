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
	idle = {{"fists_idle_01", "fists_idle_02"}},
	hit = "fists_left",
	miss = "fists_left",
	hit_alt = "fists_right",
	miss_alt = "fists_right",
	critical = "fists_uppercut"
}

SWEP.Sounds = {
	hit = "Flesh.ImpactHard",
	hitworld = "Flesh.ImpactHard",
	miss = "WeaponFrag.Throw"
}

SWEP.Primary.Damage = 8
SWEP.Primary.Force = 80
SWEP.Primary.Range = 48
SWEP.Primary.Cooldown = 0.9
SWEP.Primary.Delay = 0.2
SWEP.Primary.MaxDamage = 12

SWEP.Secondary.MaxDamage = -1

SWEP.Melee = {
	AlwaysPlaySwing = true,
	TestHull = Vector(10, 10, 8)
}

if (CLIENT) then
	SWEP.ViewModelFOV = 54
end

if (SERVER or game.SinglePlayer()) then
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
	self:Swing(false, 0)
	self:SetNextSecondaryFire(CurTime() + self:GetSpecialKey("Cooldown", false))
end

function SWEP:SecondaryAttack()
	self:Swing(true, 0)
	self:SetNextSecondaryFire(CurTime() + self:GetSpecialKey("Cooldown", true))
end

function SWEP:Smack(tr, vForward, bSecondary, iIndex)
	BaseClass.Smack(self, tr, vForward, bSecondary, iIndex)
	
	if (tr.Fraction == 1 or self.m_iCombo == 2) then
		self:SetPredictedVar("m_iCombo", 0)
	end
end

local phys_pushscale = GetConVar("phys_pushscale")

function SWEP:SmackDamage(tr, vForward, bSecondary)
	local pPlayer = self:GetOwner()
	local pEntity = tr.Entity
	
	local info = DamageInfo()
		code_gs.random:SetSeed(self:GetOwner():GetMD5Seed() % 0x100)
		
		if (self.m_iCombo == 2) then
			local flDamage = self:GetSpecialKey("MaxDamage", bSecondary)
			info:SetDamage(code_gs.random:RandomInt(flDamage, flDamage * 2))
			--info:SetDamageForce()
			-- Figure out how the exact force numbers are calculated
		else
			info:SetDamage(code_gs.random:RandomInt(self:GetSpecialKey("Damage", bSecondary), self:GetSpecialKey("MaxDamage", bSecondary)))
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
	
	local iCombo = self:GetPredictedVar("m_iCombo")
	
	if (tr.Fraction ~= 1 and iCombo ~= 2) then
		self:SetPredictedVar("m_iCombo", iCombo + 1)
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
