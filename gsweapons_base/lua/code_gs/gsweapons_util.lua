SNDLVL_NONE = 0
SNDLVL_20dB = 20 // rustling leaves
SNDLVL_25dB = 25 // whispering
SNDLVL_30dB = 30 // library
SNDLVL_35dB = 35
SNDLVL_40dB = 40
SNDLVL_45dB = 45 // refrigerator
SNDLVL_50dB = 50 // 3.9 // average home
SNDLVL_55dB = 55 // 3.0
SNDLVL_IDLE = 60 // 2.0	
SNDLVL_60dB = 60 // 2.0 // normal conversation, clothes dryer
SNDLVL_65dB = 65 // 1.5 // washing machine, dishwasher
SNDLVL_STATIC = 66 // 1.25
SNDLVL_70dB = 70 // 1.0 // car, vacuum cleaner, mixer, electric sewing machine
SNDLVL_NORM = 75
SNDLVL_75dB = 75 // 0.8 // busy traffic
SNDLVL_80dB = 80 // 0.7 // mini-bike, alarm clock, noisy restaurant, office tabulator, outboard motor, passing snowmobile
SNDLVL_TALKING = 80 // 0.7
SNDLVL_85dB = 85 // 0.6 // average factory, electric shaver
SNDLVL_90dB = 90 // 0.5 // screaming child, passing motorcycle, convertible ride on frw
SNDLVL_95dB = 95
SNDLVL_100dB = 100 // 0.4 // subway train, diesel truck, woodworking shop, pneumatic drill, boiler shop, jackhammer
SNDLVL_105dB = 105 // helicopter, power mower
SNDLVL_110dB = 110 // snowmobile drvrs seat, inboard motorboat, sandblasting
SNDLVL_120dB = 120 // auto horn, propeller aircraft
SNDLVL_130dB = 130 // air raid siren
SNDLVL_GUNFIRE = 140 // 0.27 // THRESHOLD OF PAIN, gunshot, jet engine
SNDLVL_140dB = 140 // 0.2
SNDLVL_150dB = 150 // 0.2
SNDLVL_180dB = 180 // rocket launching

-- Weapon secondary/special type enums
SPECIAL_SILENCE = 1
SPECIAL_BURST = 2
SPECIAL_ZOOM = 3
SPECIAL_IRONSIGHTS = 4

-- Grenade throw type enums
GRENADE_THROW = 1
GRENADE_TOSS = 2
GRENADE_LOB = 3
GRENADE_COUNT = 4 -- Number of throw types

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

local WEAPON = FindMetaTable( "Weapon" )
local fLastShootTime = WEAPON.LastShootTime

-- https://github.com/Facepunch/garrysmod-requests/issues/825
function WEAPON:LastShootTime()
	if ( self.GetLastShootTime ) then
		return self:GetLastShootTime()
	end
	
	return fLastShootTime( self )
end

if ( CLIENT ) then
	surface.CreateFont( "HL2KillIcon", { font = "HL2MP", size = ScreenScale(30), weight = 500, additive = true })
	surface.CreateFont( "HL2Selection", { font = "HalfLife2", size = ScreenScale(120), weight = 500, additive = true })
	surface.CreateFont( "CSSKillIcon", { font = "csd", size = ScreenScale(30), weight = 500, additive = true })
	surface.CreateFont( "CSSSelection", { font = "cs", size = ScreenScale(120), weight = 500, additive = true })
end
