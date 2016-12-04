AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

util.AddNetworkString( "GSWeapons-Holster" )
util.AddNetworkString( "GSWeapons-Holster animation" )
util.AddNetworkString( "GSWeapons-Player DTVars" )

local bSinglePlayer = game.SinglePlayer()

if ( bSinglePlayer ) then
	util.AddNetworkString( "GSWeapons-OnDrop" )
	util.AddNetworkString( "GSWeapons-Reload" )
	util.AddNetworkString( "GSWeapons-Finish reload" )
	util.AddNetworkString( "GSWeapons-BipodDeploy" )
	util.AddNetworkString( "GSWeapons-BipodDeploy update" )
end

--- Weapon behaviour
SWEP.DisableDuplicator = false -- Block spawning weapon with the duplicator

SWEP.Grenade.Damage = 125 -- Damage value of the grenade
SWEP.Grenade.Radius = 250 -- Damage radius value of the grenade
SWEP.Grenade.Class = "npc_grenade_frag" -- Grenade class to throw
SWEP.Grenade.Timer = 2.5 -- Grenade timer until detonation

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
			pPhysObj:AddAngleVelocity( Vector( 600, gsrand:RandomInt(-1200, 1200), 0 ))
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
	hideweapon = function( pWeapon )
		pWeapon:SetVisible( false ) -- FIXME
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
	local fInput = self.Inputs[sName:lower()]
	
	if ( fInput ) then
		fInput( self, pActivator, pCaller, sData )
	else
		DevMsg( 2, string.format( "%s (weapon_gs_base) Unhandled input %q", self:GetClass(), sName ))
	end
end

function SWEP:OnDrop()
	self:Holster( NULL )
	
	if ( bSinglePlayer ) then
		net.Start( "GSWeapons-OnDrop" )
			net.WriteEntity( self )
		net.Send( Entity(1) )
	end
	
	if ( self.DroppedModel ~= "" ) then
		self.WorldModel = self.DroppedModel
	end
end

--- Player functions
hook.Add( "PlayerInitialSpawn", "GSWeapons-Player DTVars", function( pPlayer )
	timer.Simple( 0, function()
		pPlayer:InstallDataTable()
		pPlayer:GS_SetupDataTables()
		
		net.Start( "GSWeapons-Player DTVars" )
		net.Send( pPlayer )
	end )
end )
