include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

util.AddNetworkString( "GSWeapons-Detonate" )

--- GSBase
ENT.CanPickup = true

--- BaseGrenade
ENT.DetonateOnDamage = false

function ENT:OnTakeDamage( info )
	if ( self.DetonateOnDamage and info:GetDamage() > 0 ) then
		self:Detonate()
		
		if ( gsweapons.DetonationNetworked( self.DetonationType )) then
			net.Start( "GSWeapons-Detonate" )
				net.WriteEntity( self )
			net.Broadcast()
		end
	end
end

function ENT:StartDetonation( flTime )
	self:AddEvent( "detonate", flTime, function()
		local bRet = self:Detonate()
		
		if ( gsweapons.DetonationNetworked( self.DetonationType )) then
			net.Start( "GSWeapons-Detonate" )
				net.WriteEntity( self )
			net.Broadcast()
		end
		
		return bRet
	end )
end
