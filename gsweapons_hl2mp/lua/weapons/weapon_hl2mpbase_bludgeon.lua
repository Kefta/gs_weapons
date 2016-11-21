SWEP.Base = "weapon_hl2mp_base"

SWEP.Primary = {
	Damage = 1,
	Cooldown = 0.2,
	Range = 32
}

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack(0) ) then
		self:Swing( false, 0 )
		
		return true
	end
	
	return false
end

function SWEP:GetShootAngles()
	return self:GetOwner():ActualEyeAngles()
end
