AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.DisableDuplicator = false -- Should the entity not be copied with the duplicator tool
ENT.CanPickup = false -- Can the entity be picked up

function ENT:Use( _, pCaller )
	if ( self.CanPickup and pCaller:IsPlayer() and not self:IsPlayerHolding() ) then
		pCaller:PickupObject( self )
	end
end
