-- Add Util override and ammo stuff
-- Weapon secondary/special type enums
SPECIAL_SILENCE = 1
SPECIAL_BURST = 2
SPECIAL_ZOOM = 3

// -----------------------------------------
//	Vector cones
// -----------------------------------------
// VECTOR_CONE_PRECALCULATED - this resolves to vec3_origin, but adds some
// context indicating that the person writing the code is not allowing
// FireBullets() to modify the direction of the shot because the shot direction
// being passed into the function has already been modified by another piece of
// code and should be fired as specified. See GetActualShotTrajectory(). 

// NOTE: The way these are calculated is that each component == sin (degrees/2)
--VECTOR_CONE_PRECALCULATED = vec3_origin
VECTOR_CONE_1DEGREES = Vector(0.00873, 0.00873, 0.00873)
VECTOR_CONE_2DEGREES = Vector(0.01745, 0.01745, 0.01745)
VECTOR_CONE_3DEGREES = Vector(0.02618, 0.02618, 0.02618)
VECTOR_CONE_4DEGREES = Vector(0.03490, 0.03490, 0.03490)
VECTOR_CONE_5DEGREES = Vector(0.04362, 0.04362, 0.04362)
VECTOR_CONE_6DEGREES = Vector(0.05234, 0.05234, 0.05234)
VECTOR_CONE_7DEGREES = Vector(0.06105, 0.06105, 0.06105)
VECTOR_CONE_8DEGREES = Vector(0.06976, 0.06976, 0.06976)
VECTOR_CONE_9DEGREES = Vector(0.07846, 0.07846, 0.07846)
VECTOR_CONE_10DEGREES = Vector(0.08716, 0.08716, 0.08716)
VECTOR_CONE_15DEGREES = Vector(0.13053, 0.13053, 0.13053)
VECTOR_CONE_20DEGREES = Vector(0.17365, 0.17365, 0.17365)

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
