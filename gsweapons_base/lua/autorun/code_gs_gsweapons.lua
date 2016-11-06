require( "random" )

if ( CLIENT ) then
	local sLang = "code_gs/lang/gsweapons_" .. GetConVar( "gmod_language" ):GetString():sub(-2):lower() .. ".lua"

	if ( file.Exists( sLang, "LUA" )) then
		local tLang = include( sLang )
			
		for k, v in pairs( include( "code_gs/lang/gsweapons_en.lua" )) do
			language.Add( k, tLang[k] or v ) -- Restore default to english
		end
	else
		for k, v in pairs( include( "code_gs/lang/gsweapons_en.lua" )) do
			language.Add( k, v )
		end
	end
	
	-- FIXME: Add loading system
	include( "code_gs/gsweapons_ammo.lua" )
	include( "code_gs/gsweapons_base.lua" )
	include( "code_gs/gsweapons_player.lua" )
	include( "code_gs/gsweapons_util.lua" )
	include( "code_gs/gsweapons_dash.lua" )
	
	DevMsg( 1, string.format( language.GetPhrase( "GSWeapons_Loaded" ), language.GetPhrase( "language" )))
else
	local sLang = "code_gs/lang/"
	local tFiles = file.Find( sLang .. "gsweapons_*.lua", "LUA" )
	
	for i = 1, #tFiles do
		AddCSLuaFile( sLang .. tFiles[i] )
	end
	
	AddCSLuaFile( "code_gs/gsweapons_ammo.lua" )
	include( "code_gs/gsweapons_ammo.lua" )
	AddCSLuaFile( "code_gs/gsweapons_base.lua" )
	include( "code_gs/gsweapons_base.lua" )
	AddCSLuaFile( "code_gs/gsweapons_player.lua" )
	include( "code_gs/gsweapons_player.lua" )
	AddCSLuaFile( "code_gs/gsweapons_util.lua" )
	include( "code_gs/gsweapons_util.lua" )
	AddCSLuaFile( "code_gs/gsweapons_dash.lua" )
	include( "code_gs/gsweapons_dash.lua" )
	
	MsgN( "[GSWeapons] Loaded!" )
end
