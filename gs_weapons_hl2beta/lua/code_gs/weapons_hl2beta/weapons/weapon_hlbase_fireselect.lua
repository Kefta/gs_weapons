SWEP.Base = "weapon_hlbase_machinegun"

SWEP.PrintName = "HL2BetaBase_FireSelect"

SWEP.Activities = {
	burst = ACT_VM_SECONDARYATTACK
}

SWEP.Primary.Cooldown = function(self, iIndex)
	return self:GetBurst(iIndex) and 0.3 or 0.1
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:ToggleBurst(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end
