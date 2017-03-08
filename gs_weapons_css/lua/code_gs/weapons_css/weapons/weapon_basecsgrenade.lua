SWEP.Base = "weapon_cs_base"

SWEP.PrintName = "CSBase_Grenade"
SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

SWEP.Sounds = {
	shoot = "Radio.FireInTheHole"
}

SWEP.Activities = {
	pullback = ACT_VM_PULLPIN
}

SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Grenade = {
	Delay = 0.1
}

SWEP.RemoveOnEmpty = true

if (SERVER) then
	SWEP.Grenade.Class = "basecsgrenade"
	SWEP.Grenade.Damage = 100
	SWEP.Grenade.Radius = 100
	SWEP.Grenade.Timer = 1.5
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (not bSecondary) then
		self:Throw(code_gs.weapons.GRENADE_THROW, iIndex)
	end
end

if (SERVER) then
	local vHullMax = Vector(2, 2, 2)
	local vHullMin = -vHullMax
	local vRand = Vector(600, 0, 0)

	function SWEP:EmitGrenade()
		local tGrenade = self.Grenade
		local pGrenade = ents.Create(tGrenade.Class)
		
		if (pGrenade:IsValid()) then
			local pPlayer = self:GetOwner()
			local aThrow = pPlayer:LocalEyeAngles()
			aThrow.p = aThrow.p < 90 and -10 + aThrow.p * 10/9
				or -10 + (360.0 - aThrow.p) * -8/9
			
			local flVel = (90 - aThrow.p) * 6
			local vForward = aThrow:Forward()
			local vSrc = pPlayer:GetPos() + pPlayer:GetViewOffset() -- FIXME
			
			pGrenade:SetPos(util.TraceHull({
					start = vSrc,
					endpos = vSrc + vForward * 16,
					mins = vHullMin,
					maxs = vHullMax,
					mask = MASK_SOLID,
					filter = pPlayer
				}).HitPos)
			pGrenade:SetOwner(pPlayer)
			pGrenade:_SetAbsVelocity(vForward * (flVel > 750 and 750 or flVel) + pPlayer:_GetAbsVelocity())
			
			vRand[2] = code_gs.random:RandomInt(-1200, 1200)
			pGrenade:ApplyLocalAngularVelocityImpulse(vRand)
			
			pGrenade:Spawn()
			-- FIXME
			--pGrenade:SetDamage(tGrenade.Damage)
			--pGrenade:SetDamageRadius(tGrenade.Radius)
			--pGrenade:StartDetonation(tGrenade.Timer)
		end
		
		return pGrenade
	end
end
