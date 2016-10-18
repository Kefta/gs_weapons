DEFINE_BASECLASS( "weapon_cs_base" )

--- GSBase
SWEP.PrintName = "CSBase_Grenade"
SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

SWEP.Activities = {
	pullback = ACT_VM_PULLPIN
}

SWEP.Sounds = {
	primary = "Radio.FireInTheHole"
}

SWEP.Primary = {
	DefaultClip = 1,
	Automatic = false
}

SWEP.Grenade = {
	Delay = 0.1,
	Damage = SERVER and 100 or nil,
	Radius = SERVER and 100 or nil,
	Class = SERVER and "basecsgrenade" or nil,
	Timer = SERVER and 1.5 or nil
}

SWEP.RemoveOnEmpty = true

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

function SWEP:PrimaryAttack()
	if ( not self:CanPrimaryAttack() ) then
		return false
	end
	
	self:Throw( GRENADE_THROW, 0 )
	
	return true
end

if ( SERVER ) then
	local flThrowDown = 10/9
	local flThrowUp = -8/9
	local vHullMax = Vector(2, 2, 2)
	local vHullMin = -vHullMax

	function SWEP:EmitGrenade()
		local tGrenade = self.Grenade
		local pGrenade = ents.Create( tGrenade.Class )
		
		if ( pGrenade ~= NULL ) then
			local pPlayer = self:GetOwner()
			local aThrow = pPlayer:EyeAngles() -- FIXME: LocalEyeAngles
			aThrow.p = aThrow.p < 90 and -10 + aThrow.p * flThrowDown
				or -10 + (360.0 - aThrow.p) * flThrowUp
			
			local flVel = (90 - aThrow.p) * 6
			local vForward = aThrow:Forward()
			local vSrc = pPlayer:GetPos() + pPlayer:GetViewOffset()
			
			pGrenade:SetPos( util.TraceHull( {
					start = vSrc,
					endpos = vSrc + vForward * 16,
					mins = vHullMin,
					maxs = vHullMax,
					mask = MASK_SOLID,
					filter = pPlayer
				}).HitPos )
			pGrenade:SetOwner( pPlayer )
			pGrenade:_SetAbsVelocity( vForward * (flVel > 750 and 750 or flVel) + pPlayer:_GetAbsVelocity() )
			pGrenade:ApplyLocalAngularVelocityImpulse( Vector( 600, random.RandomInt(-1200, 1200), 0 ))
			pGrenade:Spawn()
			pGrenade:SetDamage( tGrenade.Damage )
			pGrenade:SetDamageRadius( tGrenade.Radius )
			pGrenade:StartDetonation( tGrenade.Timer )
		end
		
		return pGrenade
	end
end
