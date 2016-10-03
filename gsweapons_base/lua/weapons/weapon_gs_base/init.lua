AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

if ( game.SinglePlayer() ) then
	util.AddNetworkString( "GSWeapons-Holster animation" )
	util.AddNetworkString( "GSWeapons-Holster" )
end

--- Weapon demeanour
SWEP.DisableDuplicator = false -- Block spawning weapon with the duplicator

--- Attack
local vHullMax = Vector(6, 6, 6)
local vHullMin = -vHullMax

-- From the HL2 frag
function SWEP:EmitGrenade()
	local tGrenade = self.Grenade
	local pGrenade = ents.Create( tGrenade.Class )
	
	if ( pGrenade ~= NULL ) then
		local pPlayer = self:GetOwner()
		local vEye = pPlayer:EyePos()
		local aEye = pPlayer:ActualEyeAngles()
		local vForward = aEye:Forward()
		local vSrc = vEye + vForward * 18 + aEye:Right() * 8
		vForward[3] = vForward[3] + 0.1
		
		local tr = util.TraceHull({
			start = vEye,
			endpos = vSrc,
			mins = vHullMins,
			maxs = vHullMaxs,
			mask = MASK_PLAYERSOLID,
			filter = pPlayer,
			collisiongroup = pPlayer:GetCollisionGroup()
		})
		
		if ( tr.Fraction ~= 1 or tr.AllSolid or tr.StartSolid ) then
			vSrc = tr.HitPos
		end
		
		pGrenade:SetPos( vSrc )
		pGrenade:SetOwner( pPlayer )
		pGrenade:Spawn()
		
		pGrenade:SetSaveValue( "m_takedamage", 1 )
		pGrenade:SetSaveValue( "m_flDamage", tGrenade.Damage )
		pGrenade:SetSaveValue( "m_DmgRadius", tGrenade.Radius )
		pGrenade:SetSaveValue( "m_hThrower", pPlayer )
		--pGrenade:SetSaveValue( "m_hOriginalThrower", pPlayer )
		pGrenade:Fire( "SetTimer", tostring( tGrenade.Timer ))
		
		local pPhysObj = pGrenade:GetPhysicsObject()
		
		if ( pPhysObj ~= NULL ) then
			pPhysObj:AddVelocity( pPlayer:_GetVelocity() + vForward * 1200 )
			pPhysObj:AddAngleVelocity( Vector( 600, random.RandomInt(-1200, 1200), 0 ))
		end
	end
	
	return pGrenade 
end

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
	return false
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
