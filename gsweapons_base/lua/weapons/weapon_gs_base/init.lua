AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

if ( game.SinglePlayer() ) then
	util.AddNetworkString( "GSWeapons - Holster Animation" )
	util.AddNetworkString( "GSWeapons - Holster" )
end

--- Weapon demeanour
SWEP.DisableDuplicator = false -- Block spawning weapon with the duplicator
SWEP.DropOnDie = false -- Drop the weapon on death. Player:ShouldDropWeapon() must be set to true

--- Utilities
SWEP.KeyValues = {} -- key = function( pWeapon, sValue ) end

function SWEP:KeyValue( sKey, sValue )
	local fInput = self.KeyValues[string.lower( sKey )]
	
	if ( fInput ) then
		return fInput( self, sValue )
	end
	
	DevMsg( 2, string.format( "%s (weapon_gs_base) Unhandled key-value %q %q", self:GetClass(), sKey, sValue ))
	
	return false
end

SWEP.Inputs = { -- key = function( pWeapon, pActivator, pCaller, sData ) end
	hideweapon = function( pWeapon ) -- Fix; find a map that uses this and test if it's default
		pWeapon:SetWeaponVisible( false )
	end,
	
	ammo = function( pWeapon, _, _, iValue )
		iValue = tonumber( iValue )
		
		if ( iValue > 0 ) then
			-- https://github.com/Facepunch/garrysmod-requests/issues/703
			--pWeapon:SetPrimaryAmmoCount( wep:GetPrimaryAmmoCount() + iValue )
		end
	end
}

function SWEP:AcceptInput( sName, pActivator, pCaller, sData )
	local fInput = self.Inputs[string.lower( sName )]
	
	if ( fInput ) then
		fInput( self, pActivator, pCaller, sData )
	else
		DevMsg( 2, string.format( "%s (weapon_gs_base) Unhandled input %q", self:GetClass(), sName ))
	end
end

--- Accessors/Modifiers
function SWEP:ShouldDropOnDie()
	return self.DropOnDie
end

--- Player functions
-- Creates DTVars attached to the player
hook.Add( "PlayerInitialSpawn", "GSWeapons-Player DTVars", function( pPlayer )
	timer.Simple( 0, function()
		if ( pPlayer ~= NULL ) then
			pPlayer:SetupWeaponDataTables()
		end
	end )
end )
