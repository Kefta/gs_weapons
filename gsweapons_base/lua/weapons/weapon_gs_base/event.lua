local function ReturnTrue()
	return true
end

local function ReturnFalse()
	return false
end

local tAnimEvents = {}

local function AddAnimEvent( Event, sName, func )
	if ( istable( Event )) then
		for i = 1, #Event do
			if ( not tAnimEvents[Event[i]] ) then
				tAnimEvents[Event[i]] = {}
			end
		
			tAnimEvents[Event[i]][sName] = func
		end
	else
		if ( not tAnimEvents[Event] ) then
			tAnimEvents[Event] = {}
		end
	
		tAnimEvents[Event][sName] = func
	end
end

-------------------------------Custom Events-------------------------------

AddAnimEvent( {5001, 5011, 5021, 5031}, "css", function( pWeapon, _, _, iEvent )
	if ( not pWeapon:Silenced() ) then
		local pPlayer = pWeapon:GetOwner()
		
		if ( pPlayer == NULL ) then
			return true
		end
		
		local pViewModel = pPlayer:GetViewModel()
		
		if ( pViewModel == NULL ) then
			return true
		end
		
		local data = EffectData()
			data:SetEntity( pViewModel )
			data:SetAttachment( pWeapon:GetMuzzleAttachment( iEvent ))
			data:SetScale( pWeapon:GetMuzzleFlashScale() )
		util.Effect( "CS_MuzzleFlash", data )
	end
	
	return true
end )

AddAnimEvent( {5001, 5011, 5021, 5031}, "css_x", function( pWeapon, _, _, iEvent )
	if ( not pWeapon:Silenced() ) then
		local pPlayer = pWeapon:GetOwner()
		
		if ( pPlayer == NULL ) then
			return true
		end
		
		local pViewModel = pPlayer:GetViewModel()
		
		if ( pViewModel == NULL ) then
			return true
		end
		
		local data = EffectData()
			data:SetEntity( pViewModel )
			data:SetAttachment( pWeapon:GetMuzzleAttachment( iEvent ))
			data:SetScale( pWeapon:GetMuzzleFlashScale() )
		util.Effect( "CS_MuzzleFlash_X", data )
	end
	
	return true
end )

AddAnimEvent( {5003, 5013, 5023, 5033}, "css", function( pWeapon, _, _, iEvent )
	if ( not pWeapon:Silenced() ) then
		local pPlayer = pWeapon:GetOwner()
		
		if ( pPlayer == NULL ) then
			return true
		end
		
		local light = DynamicLight( 0x40000000 + pPlayer:EntIndex() )
		light.pos = pWeapon:GetAttachment( pWeapon:GetMuzzleAttachment( iEvent )).Pos
		light.size = 70
		light.decay = 1400 --light.size / 0.05
		light.dietime = CurTime() + 0.05
		light.r = 255
		light.g = 192
		light.b = 64
		light.style = 5
	end
	
	return true
end )

local cl_ejectbrass = GetConVar( "cl_ejectbrass" )
local sSep = " "
local cRep = string.char( 173 )

AddAnimEvent( 20, "css", function( pWeapon, _, _, _, sOptions )
	if ( not cl_ejectbrass:GetBool() ) then
		return true
	end
	
	local pPlayer = pWeapon:GetOwner()
	
	if ( pPlayer == NULL ) then
		return true
	end
	
	local aEyes = pPlayer:EyeAngles()
	local tOptions = sSep:Explode( sOptions )
	local sEffect = tOptions[1]
	
	if ( sEffect ) then
		-- https://github.com/Facepunch/garrysmod-issues/issues/2789
		local iReplace = sEffect:find( cRep, 1, true )
		
		if ( iReplace ) then
			sEffect = sEffect:SetChar( iReplace, "_" )
		end
	else
		sEffect = "EjectBrass_9mm"
	end
	
	local data = EffectData()
		data:SetOrigin( pWeapon:GetAttachment( tOptions[2] and tonumber( tOptions[2] ) or pWeapon:GetMuzzleAttachment() ).Pos )
		data:SetAngles( (aEyes:Right() * 100 + aEyes:Up() * 20):Angle() )
		data:SetFlags( tOptions[3] and tonumber( tOptions[3] ) or 120 ) -- Velocity
	util.Effect( sEffect, data )
	
	return true
end )

return function( iEvent, sName )
	if ( sName == "" ) then
		return ReturnTrue
	else
		-- Use default event if we can't find the style
		return sName and tAnimEvents[iEvent] and tAnimEvents[iEvent][sName] or ReturnFalse
	end
end
