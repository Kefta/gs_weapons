include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "detonationtype.lua" )

function ENT:OnTakeDamage( info )
	if ( info:GetDamage() > 0 ) then
		self:Detonate()
	end
end
