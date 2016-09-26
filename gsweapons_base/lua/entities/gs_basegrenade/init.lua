include( "shared.lua" )
AddCSLuaFile( "shared.lua" )

--- GSBase
ENT.CanPickup = true

--- BaseGrenade
ENT.DetonateOnDamage = false

function ENT:OnTakeDamage( info )
	if ( self.DetonateOnDamage and info:GetDamage() > 0 ) then
		self:Detonate()
	end
end
