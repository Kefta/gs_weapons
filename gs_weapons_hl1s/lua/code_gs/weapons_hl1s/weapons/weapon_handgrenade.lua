SWEP.Base = "basehl1combatweapon"

SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

SWEP.Activities = {
	idle = function(self, iIndex)
		return code_gs.random:SharedRandomFloat(self:GetOwner(), self:GetClass() .. "-Activity" .. iIndex .. "-idle", 0, 1) > 0.75
			and ACT_VM_FIDGET or ACT_VM_IDLE
	end,
	pullback = ACT_VM_PRIMARYATTACK,
	throw = ACT_INVALID, -- Disable default throw anim
	throw1 = ACT_HANDGRENADE_THROW1,
	throw2 = ACT_HANDGRENADE_THROW2,
	throw3 = ACT_HANDGRENADE_THROW3
}

SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

if (SERVER) then
	SWEP.Grenade = {
		Class = "grenade_hand",
		Damage = 150,
		Radius = 375,
		Timer = 1.5
	}
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (not bSecondary) then
		self:Throw(code_gs.weapons.GRENADE_THROW, iIndex)
	end
end

function SWEP:EmitGrenade()
	local pPlayer = self:GetOwner()
	local aThrow = pPlayer:EyeAngles()
	
	// player is pitching up
	aThrow.p = aThrow.p > 180 and -15 - (360 - aThrow.p) * 8/9
		// player is pitching down
		or -15 + aThrow.p * 10/9
	
	local flVel = (90 - aThrow.p) * 4
	
	-- Set activity based on the throw velocity
	-- HL1 actually clamped the velocity before checking here
	-- So the other animations were never played
	if (flVel < 500) then
		self:PlayActivity("throw1")
	elseif (flVel < 1000) then
		self:PlayActivity("throw2")
	else
		self:PlayActivity("throw3")
	end
	
	if (SERVER) then
		--[[local vForward = aThrow:Forward()
		-- Fixme
		local pGrenade = ents.Create(self.Entity)
		pGrenade:SetPos(pPlayer:EyePos() + vForward * 16)
		pGrenade:_SetAbsVelocity(vForward * (flVel > 500 and 500 or flVel) + pPlayer:_GetAbsVelocity())
		pGrenade:ApplyLocalAngularVelocityImpulse(Vector(code_gs.random:RandomInt(-1200, 1200), 0, 600))
		pGrenade:Spawn()
		pGrenade:SetOwner(pPlayer)
		pGrenade:StartDetonation(tGrenade.Timer)]]
		
		return NULL
	end
end
