SWEP.Base = "weapon_cs_base"

SWEP.PrintName = "CSBase_Grenade"
SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

SWEP.Activities = {
	pullback = ACT_VM_PULLPIN
}

SWEP.Sounds = {
	shoot = "Radio.FireInTheHole"
}

SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Grenade = {
	Delay = 0.1
}

SWEP.RemoveOnEmpty = true

if (SERVER) then
	SWEP.Grenade.Damage = 100
	SWEP.Grenade.Radius = 100
	SWEP.Grenade.Class = "basecsgrenade"
	SWEP.Grenade.Timer = 1.5
	
	local flThrowDown = 10/9
	local flThrowUp = -8/9
	local vHullMax = Vector(2, 2, 2)
	local vHullMin = -vHullMax

	function SWEP:EmitGrenade()
		local tGrenade = self.Grenade
		local pGrenade = ents.Create(tGrenade.Class)
		
		if (pGrenade ~= NULL) then
			local pPlayer = self:GetOwner()
			local aThrow = pPlayer:EyeAngles() -- FIXME: LocalEyeAngles
			aThrow.p = aThrow.p < 90 and -10 + aThrow.p * flThrowDown
				or -10 + (360.0 - aThrow.p) * flThrowUp
			
			local flVel = (90 - aThrow.p) * 6
			local vForward = aThrow:Forward()
			local vSrc = pPlayer:GetPos() + pPlayer:GetViewOffset()
			
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
			pGrenade:ApplyLocalAngularVelocityImpulse(Vector(600, code_gs.random:RandomInt(-1200, 1200), 0))
			pGrenade:Spawn()
			pGrenade:SetDamage(tGrenade.Damage)
			pGrenade:SetDamageRadius(tGrenade.Radius)
			pGrenade:StartDetonation(tGrenade.Timer)
		end
		
		return pGrenade
	end
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack()) then
		self:Throw(code_gs.weapons.GRENADE_THROW, 0)
		
		return true
	end
	
	return false
end
