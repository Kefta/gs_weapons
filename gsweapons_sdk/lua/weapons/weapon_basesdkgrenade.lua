DEFINE_BASECLASS( "weapon_cs_base" )

--- GSBase
SWEP.PrintName = "SDKBase_Grenade"
SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

SWEP.Primary = {
	DefaultClip = 1,
	Automatic = false
}

SWEP.Grenade = {
	Delay = 0.1,
	Damage = SERVER and 100 or nil,
	Radius = SERVER and 100 or nil,
	Class = SERVER and "basesdkgrenade" or nil,
	Timer = SERVER and 1.5 or nil
}

SWEP.RemoveOnEmpty = true

if ( CLIENT ) then
	SWEP.Category = "Source"
end

function SWEP:PrimaryAttack()
	if ( not self:CanPrimaryAttack() ) then
		return false
	end
	
	self:Throw()
	
	return true
end

if ( SERVER ) then
	local flThrowDown = 10/9
	local flThrowUp = -8/9

	function SWEP:EmitGrenade()
		local tGrenade = self.Grenade
		local pGrenade = ents.Create( tGrenade.Class )
		
		if ( pGrenade ~= NULL ) then
			local pPlayer = self:GetOwner()
			local aThrow = pPlayer:LocalEyeAngles()
			aThrow.p = aThrow.p < 90 and -10 + aThrow.p * flThrowDown
				or -10 + (360.0 - aThrow.p) * flThrowUp
			
			local flVel = (90 - aThrow.p) * 6
			local vForward = aThrow:Forward()
			
			pGrenade:SetPos( pPlayer:GetPos() + pPlayer:GetViewOffset() + vForward * 16 )
			pGrenade:SetOwner( pPlayer )
			pGrenade:_SetAbsVelocity( vForward * (flVel > 750 and 750 or flVel) + pPlayer:_GetAbsVelocity() )
			pGrenade:ApplyLocalAngularVelocityImpulse( Vector( 600, random.RandomInt(-1200, 1200), 0 ))
			pGrenade:Spawn()
			pGrenade:StartDetonation( tGrenade.Timer )
		end
		
		return pGrenade
	end
end
