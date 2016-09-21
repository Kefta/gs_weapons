include( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "detonation.lua" )

--- GSBase
ENT.CanPickup = true

--- BaseGrenade
ENT.DetonateOnDamage = false

function ENT:OnTakeDamage( info )
	if ( self.DetonateOnDamage and info:GetDamage() > 0 ) then
		self:Detonate()
	end
end
