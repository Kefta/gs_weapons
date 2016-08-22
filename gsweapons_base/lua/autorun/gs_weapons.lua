-- Weapon secondary/special type enums
SPECIAL_SILENCE = 1
SPECIAL_BURST = 2
SPECIAL_ZOOM = 3

local developer = GetConVar( "developer" )

function DevMsg( iLevel, ... )
	if ( developer:GetInt() >= iLevel ) then
		print( ... )
	end
end

if ( CLIENT ) then
	local sLang = "gslib/lang/" .. GetConVar( "gmod_language" ):GetString():sub(-2):lower() .. ".lua"

	if ( file.Exists( sLang, "LUA" )) then
		local tLang = include( sLang )
			
		for k, v in pairs( include( "gslib/lang/en.lua" )) do
			language.Add( k, tLang[k] or v ) -- Restore default to english
		end
	else
		for k, v in pairs( include( "gslib/lang/en.lua" )) do
			language.Add( k, v )
		end
	end
	
	DevMsg( 1, string.format( "[GSLib] " .. language.GetPhrase( "GSLib_LanguageLoaded" ), language.GetPhrase( "language" )))
else
	local sLang = "gslib/lang/"
	local tFiles = file.Find( sLang .. "*.lua", "LUA" )
	
	for i = 1, #tFiles do
		AddCSLuaFile( sLang .. tFiles[i] )
	end
	
	AddCSLuaFile( "gslib/player.lua" )
	
	if ( not plib ) then
		AddCSLuaFile( "gslib/plib.lua" )
	end
end

require( "hash" )
require( "random" )
include( "gslib/player.lua" )

if ( not plib ) then
	include( "gslib/plib.lua" )
end
