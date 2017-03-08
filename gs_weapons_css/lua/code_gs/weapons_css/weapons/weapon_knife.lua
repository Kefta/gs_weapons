-- FIXME: Check activities
SWEP.Base = "weapon_cs_base"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.CModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.HoldType = "knife"

SWEP.Sounds = {
	draw = "Weapon_Knife.Deploy",
	hit = "Weapon_Knife.Hit",
	hit2 = "Weapon_Knife.Stab",
	hitworld = "Weapon_Knife.HitWall",
	hitworld2 = "Weapon_Knife.HitWall",
	miss = "Weapon_Knife.Slash",
	miss2 = "Weapon_Knife.Slash"
}

SWEP.Activities = {
	hit2 = ACT_VM_HITCENTER,
	miss2 = ACT_VM_MISSCENTER
}

SWEP.Primary.Cooldown = 0.4
SWEP.Primary.HitCooldown = 0.5
SWEP.Primary.Damage = 15
SWEP.Primary.InitialDamage = 20
SWEP.Primary.Force = 300
SWEP.Primary.Range = 48
SWEP.Primary.SmackDelay = 0.1

SWEP.Secondary.Cooldown = 1
SWEP.Secondary.HitCooldown = 1.1
SWEP.Secondary.Damage = 65
SWEP.Secondary.InitialDamage = 65
SWEP.Secondary.Range = 32
SWEP.Secondary.SmackDelay = 0.2

SWEP.Melee = {
	BackMultiplier = 3,
	DamageType = DMG_SLASH,
	DotRange = 0.8,
	Mask = MASK_SOLID,
	TestHull = Vector(16, 16, 18)
}

if (CLIENT) then
	SWEP.KillIcon = 'j'
	SWEP.SelectionIcon = 'j'
	
	SWEP.ViewModelFlip = false
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
end

local phys_pushscale = GetConVar("phys_pushscale")

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	self:Swing(bSecondary, iIndex)
end

function SWEP:Swing(bSecondary --[[= false]], iIndex --[[= 0]])
	local flCurTime = CurTime()
	self:SetPredictedVar("FirstSwing" .. iIndex, not bSecondary and self:GetNextAttack(false, iIndex) + self:GetSpecialKey("Cooldown", false, iIndex) < flCurTime)
	
	local bActivity, bHit = BaseClass.Swing(self, bSecondary, iIndex)
	local flPrimaryCooldown, flSecondaryCooldown
	
	if (bSecondary or bHit) then
		flPrimaryCooldown = self:GetSpecialKey(bHit and "HitCooldown" or "Cooldown", bSecondary, iIndex)
		flSecondaryCooldown = flPrimaryCooldown
	else
		flPrimaryCooldown = self:GetSpecialKey("Cooldown", false, iIndex)
		
		-- I have no idea why CS:S does this.. I guess 0.1 seconds must make a huge difference!
		flSecondaryCooldown = self:GetSpecialKey("HitCooldown", false, iIndex)
	end
	
	flPrimaryCooldown = flCurTime + flPrimaryCooldown
	self:SetNextAttack(flPrimaryCooldown, false, iIndex)
	self:SetNextAttack(flCurTime + flSecondaryCooldown, true, iIndex)
	self:SetNextReload(flPrimaryCooldown, iIndex)
	
	return bActivity, bHit
end

function SWEP:DoImpactEffect(tr, nDamageType)
	if (IsFirstTimePredicted()) then
		-- https://github.com/Facepunch/garrysmod-requests/issues/779
		--[[local data = EffectData()
			data:SetOrigin(tr.HitPos)
			data:SetStart(tr.StartPos)
			data:SetSurfaceProp(tr.SurfaceProps)
			data:SetDamageType(nDamageType)
			data:SetHitBox(tr.HitBox)
			data:SetAngles(pPlayer:GetAngles())
			data:SetFlags(0x1) // IMPACT_NODECAL
			data:SetEntity(tr.Entity)
		util.Effect("KnifeSlash", data)]]
		
		if (SERVER) then
			util.Decal("ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal, self:GetOwner())
		end
	end
	
	return true
end

function SWEP:DoSplashEffect()
	return true
end

function SWEP:SmackDamage(tr, vForward, bSecondary, iIndex)
	local flDamage = self:GetSpecialKey(self:GetPredictedVar("FirstSwing" .. iIndex, false) and "InitialDamage" or "Damage", bSecondary, iIndex)
	local pEntity = tr.Entity
	local pPlayer = self:GetOwner()
	local tMelee = self.Melee
	
	if (bSecondary and (pEntity:IsPlayer() or pEntity:IsNPC())) then
		local vTargetForward = pEntity:GetAngles():Forward() -- FIXME: Not correctly returning on client
		vTargetForward[3] = 0
		
		local vLOS = pEntity:GetPos() - pPlayer:GetPos()
		vLOS[3] = 0
		vLOS:Normalize()
		
		// Triple the damage if we are stabbing them in the back.
		if (vLOS:Dot(vTargetForward) > tMelee.DotRange) then
			flDamage = flDamage * tMelee.BackMultiplier
		end
	end
	
	local info = DamageInfo()
		info:SetAttacker(pPlayer)
		info:SetInflictor(self)
		info:SetDamage(flDamage)
		info:SetDamageType(tMelee.DamageType)
		info:SetDamagePosition(tr.HitPos)
		info:SetReportedPosition(tr.StartPos)
		info:SetDamageForce(vForward * info:GetBaseDamage() * self:GetSpecialKey("Force", bSecondary, iIndex) * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat())
	pEntity:DispatchTraceAttack(info, tr, vForward)
end

function SWEP:ViewModelInactive(iIndex --[[= 0]])
	if (iIndex == 0 or iIndex == nil) then
		return not (self:GetOwner():KeyDown(IN_ATTACK) or self:GetOwner():KeyDown(IN_ATTACK2)) -- FIXME: Condense with bitwise
	end
	
	return true
end

function SWEP:GetMeleeTrace(tbl)
	local tr = util.TraceLine(tbl)
	
	if (not tr.Hit or tr.HitSky) then
		local tMelee = self.Melee
		
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.output = tr
		
		util.TraceHull(tbl)
		
		// Calculate the point of intersection of the line (or hull) and the object we hit
		// This is and approximation of the "best" intersection
		if (tr.Hit and not tr.HitSky and tr.Entity:IsBSPModel()) then
			tbl.mins, tbl.maxs = self:GetOwner():GetHullDuck()
			util.FindHullIntersection(tbl, tr)
		end
	end
	
	return tr
end
