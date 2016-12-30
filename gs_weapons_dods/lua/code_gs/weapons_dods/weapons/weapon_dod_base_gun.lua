SWEP.Base = "weapon_dod_base"

SWEP.PrintName = "DODBase_Gun"

SWEP.Activities = {
	shoot_empty = ACT_VM_PRIMARYATTACK_EMPTY
}

SWEP.Activities = {
	hit = ACT_VM_PRIMARYATTACK,
	hit_alt = ACT_VM_SECONDARYATTACK
}

SWEP.Primary.Force = 8
SWEP.Primary.FireInAir = false

SWEP.Melee = {
	DotRange = 0.95,
	HullRadius = 40,
	TestHull = Vector(16, 16, 18),
	Mask = bit.bor(MASK_SOLID, CONTENTS_HITBOX, CONTENTS_DEBRIS),
	Delay = 0.2
}

SWEP.UnderwaterCooldown = 1

SWEP.Penetration = 6

SWEP.Accuracy = {
	MovePenalty = vector_origin,
	Speed = 45/200 -- FIXME
}

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	self.FireFunction = PLAYER.FireDODBullets or PLAYER.FireCSSBullets
	
	BaseClass.Initialize(self)
end

local phys_pushscale = GetConVar("phys_pushscale")

-- Punch!
function SWEP:Swing(bSecondary, iIndex)	
	local tMelee = self.Melee
	local pPlayer = self:GetOwner()
	pPlayer:LagCompensation(true)
	
	local vSrc = self:GetShootSrc(bSecondary)
	local vForward = self:GetShootDir(bSecondary)
	
	local tbl = {
		start = vSrc,
		endpos = vSrc + vForward * self:GetSpecialKey("Range", bSecondary),
		mask = tMelee.Mask,
		filter = pPlayer
	}
	local tr = util.TraceLine(tbl)
	
	// If the exact forward trace did not hit, try a larger swept box
	if (tr.Fraction == 1) then
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.mask = MASK_SOLID
		tbl.output = tr
		
		util.TraceHull(tbl)
		
		if (tr.Fraction ~= 1) then
			// Calculate the point of intersection of the line (or hull) and the object we hit
			// This is and approximation of the "best" intersection
			if (tr.Entity == NULL or tr.Entity:IsBSPModel()) then
				tbl.mins, tbl.maxs = pPlayer:GetHullDuck()
				util.FindHullIntersection(tbl, tr)
			end
			
			// Make sure it is in front of us
			local vTarget = tr.HitPos - vSrc
			vTarget:Normalize()
			
			// if zero length, always hit
			if (vTarget:LengthSqr() ~= 0 and vForward:Dot(vTarget) < tMelee.DotRange) then
				// fake that we actually missed
				tr.Fraction = 1
				tr.Entity = NULL
				tr.Hit = false
			end
		end
	end
	
	self:PlaySound("miss", iIndex)
	
	if (tr.Fraction ~= 1) then
		self:AddEvent("hit", tMelee.Delay, function()
			pPlayer:LagCompensation(true)
			
			local vSrc = self:GetShootSrc(bSecondary)
			local vForward = self:GetShootDir(bSecondary)
			
			// Check that we are still facing the victim
			tbl.start = vSrc
			tbl.endpos = vSrc + vForward * self:GetSpecialKey("Range", bSecondary)
			tbl.mask = tMelee.Mask
			
			util.TraceLine(tbl)
			
			// If the exact forward trace did not hit, try a larger swept box
			if (tr.Fraction == 1) then
				tbl.mins = -tMelee.TestHull
				tbl.maxs = tMelee.TestHull
				tbl.mask = MASK_SOLID
				tbl.output = tr
				
				util.TraceHull(tbl)
				
				if (tr.Fraction ~= 1 and (tr.Entity == NULL or tr.Entity:IsBSPModel())) then
					// Calculate the point of intersection of the line (or hull) and the object we hit
					// This is and approximation of the "best" intersection
					tbl.mins, tbl.maxs = pPlayer:GetHullDuck()
					util.FindHullIntersection(tbl, tr)
				end
			end
			
			if (tr.Entity == NULL or tr.HitSky) then
				return true
			end
			
			if (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
				local data = EffectData()
					data:SetOrigin(tr.HitPos)
					data:SetStart(tr.StartPos)
					data:SetSurfaceProp(tr.SurfaceProps)
					data:SetHitBox(tr.HitBox)
					data:SetEntity(tr.Entity)
					
					if (SERVER) then
						data:SetEntIndex(tr.Entity:EntIndex())
					end
					
					data:SetAngles(pPlayer:GetAngles())
					data:SetFlags(0x1) // IMPACT_NODECAL
					data:SetDamageType(tMelee.DamageType)
				util.Effect("Impact", data)
				
				self:PlaySound("hit", iIndex)
			else
				code_gs.DevMsg(3, self:GetClass() .. " (weapon_dod_base) Placing decal!")
				util.Decal("ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal, true)
				
				self:PlaySound("hitworld", iIndex)
			end
			
			// if they hit the bounding box, just assume a chest hit
			if (tr.HitGroup == HITGROUP_GENERIC) then
				tr.HitGroup = HITGROUP_CHEST
			end
			
			local info = DamageInfo()
				info:SetAttacker(pPlayer)
				info:SetInflictor(self)
				
				local flDamage = self:GetSpecialKey("Damage", bSecondary)
				info:SetDamage(flDamage)
				info:SetDamageForce(vForward * info:GetBaseDamage() * self:GetSpecialKey("Force", bSecondary) * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat())
				info:SetDamageType(self.Melee.DamageType)
				info:SetDamagePosition(tr.HitPos)
				info:SetReportedPosition(tr.StartPos)
			tr.Entity:DispatchTraceAttack(info, tr, vForward)
			
			pPlayer:LagCompensation(false)
			
			return true
		end)
	end
	
	local bActivity = self:PlayActivity(bSecondary and "hit_alt" or "hit", iIndex)
	--pPlayer:DoAnimationEvent(PLAYERANIMEVENT_SECONDARY_ATTACK)
	
	if (not bSecondary) then
		pPlayer:SetAnimation(PLAYER_ATTACK1)
	end
	
	local flCurTime = CurTime()
	self:SetLastShootTime(flCurTime)
	
	flCurTime = flCurTime + self:GetSpecialKey("Cooldown", bSecondary)
	self:SetNextPrimaryFire(flCurTime)
	self:SetNextSecondaryFire(flCurTime)
	
	pPlayer:LagCompensation(false)
	
	return bActivity
end

function SWEP:GetSpecialKey(sKey, bSecondary, bNoConVar)
	if (sKey == "Spread") then
		local pPlayer = self:GetOwner()
		local tAccuracy = self.Accuracy
		
		if (pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tAccuracy.Speed) ^ 2) then
			return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar) + tAccuracy.MovePenalty
		end
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar)
end

-- DoD:S uses per-frame recoil instead of punching
--[[if (CLIENT) then FIXME
	hook.Add("Think", "GS-Weapons-DoD recoil", function()
	end)
end]]
