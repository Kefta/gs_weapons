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

-- Handles weapon switching
hook.Add( "StartCommand", "GSWeapons-Shared SelectWeapon", function( pPlayer, cmd )
	if ( pPlayer.m_pNewWeapon ) then
		if ( pPlayer.m_pNewWeapon == NULL or pPlayer.m_pNewWeapon == pPlayer:GetActiveWeapon() ) then
			pPlayer.m_pNewWeapon = nil
		else
			-- Sometimes does not work the first time
			cmd:SelectWeapon( pPlayer.m_pNewWeapon )
		end
	end
end )

-- Scales the player's movement speeds based on their weapon
hook.Add( "Move", "GSWeapons-Punch decay and Move speed", function( pPlayer, mv )
	local pActiveWeapon = pPlayer:GetActiveWeapon()
	
	if ( pActiveWeapon.PunchDecayFunction ) then
		pPlayer.dt.LastPunchAngle = pPlayer:GetViewPunchAngles()
	end
	
	if ( pActiveWeapon.GetWalkSpeed ) then
		local flOldSpeed = mv:GetMaxSpeed() *
			(pPlayer:KeyDown( IN_SPEED ) and pActiveWeapon:GetRunSpeed() or pActiveWeapon:GetWalkSpeed())
		
		mv:SetMaxSpeed( flOldSpeed )
		mv:SetMaxClientSpeed( flOldSpeed )
	end
end )

hook.Add( "FinishMove", "GSWeapons-Punch decay", function( pPlayer )
	local fPunchDecay = pPlayer:GetActiveWeapon().PunchDecayFunction
	
	if ( fPunchDecay ) then
		pPlayer:SetViewPunchAngles( fPunchDecay( pPlayer, pPlayer.dt.LastPunchAngle ))
	end
end )

local PLAYER = _R.Player

function PLAYER:SetupWeaponDataTables()
	-- For CS:S ViewPunching
	self:DTVar( "Bool", 0, "PunchDirection" )
	self:DTVar( "Angle", 0, "LastPunchAngle" )
end

-- Shared version of SelectWeapon
function PLAYER:SwitchWeapon( weapon )
	if ( isstring( weapon )) then
		local pWeapon = self:GetWeapon( weapon )
		
		if ( pWeapon ~= NULL ) then
			self.m_pNewWeapon = pWeapon
		end
	elseif ( weapon:GetOwner() == self ) then
		self.m_pNewWeapon = weapon
	end
end

function PLAYER:CSDecayPunchAngle( aPunch )
	local flLen = aPunch:NormalizeInPlace()
	flLen = flLen - (10 + flLen * 0.5) * FrameTime()
	
	return aPunch * (flLen < 0 and 0 or flLen)
end

function PLAYER:SharedRandomFloat( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomFloat( flMin, flMax )
end

function PLAYER:SharedRandomInt( sName, iMin, iMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomInt( iMin, iMax )
end

function PLAYER:SharedRandomVector( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))

	return Vector( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ) )
end

function PLAYER:SharedRandomAngle( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))

	return Angle( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

function PLAYER:SharedRandomColor( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return Color( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

local function BulletImpulse( flGrains, flFtPerSec, flImpulse )
	return flFtPerSec * flGrains * flImpulse * 0.00077897727272727
end

game.AddAmmoType({
	name = "StriderMinigun_Episodic",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 5,
	npcdmg = 5,
	maxcarry = 15,
	force = 1 * 750 * 12,
	flags = AMMO_FORCE_DROP_IF_CARRIED,
	minsplash = 4,
	maxsplash = 8
}) // hit like a 1kg weight at 750 ft/s

game.AddAmmoType({
	name = "Hopwire",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 3,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "ammo_proto1",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 10,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- More Half-Life 1 ammo types
-- FIXME: Look at the cfg files for actual carries
game.AddAmmoType({
	name = "357Round",
	dmgtype = bit.bor(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = BulletImpulse(650, 6000, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Buckshot_HL",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = BulletImpulse(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "XBowBolt_HL",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = BulletImpulse(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RPG_Rocket",
	dmgtype = bit.bor(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Uranium",
	dmgtype = DMG_ENERGYBEAM,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Grenade_HL",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Snark",
	dmgtype = DMG_SLASH,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "TripMine",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Satchel",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "12mmRound",
	dmgtype = bit.band(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 0,
	force = BulletImpulse(300, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- Half-Life 2: Beta ammo type
game.AddAmmoType({
	name = "Extinguisher",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 100,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- SDK ammo types
game.AddAmmoType({
	name = "Grenade_SDK",
	dmgtype = DMG_BLAST,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Bullets",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- Counter-Strike: Source ammo types
game.AddAmmoType({
	name = "50AE",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 35,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 30,
	penetrationdistance = 1000
})

game.AddAmmoType({
	name = "762mmRound",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 90,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 39,
	penetrationdistance = 5000
})

game.AddAmmoType({
	name = "556mmRound",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 90,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

game.AddAmmoType({
	name = "556mmRound_Box",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 200,
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

game.AddAmmoType({
	name = "338",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 30,
	force = 2800 * 1,
	flags = 0,
	minsplash = 12,
	maxsplash = 16,
	penetrationpower = 45,
	penetrationdistance = 8000
})

game.AddAmmoType({
	name = "9mmRound_CSS",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 120,
	force = 2000 * 1,
	flags = 0,
	minsplash = 5,
	maxsplash = 10,
	penetrationpower = 21,
	penetrationdistance = 800
})

game.AddAmmoType({
	name = "Buckshot_CSS",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 32,
	force = 600 * 1,
	flags = 0,
	minsplash = 3,
	maxsplash = 6,
	penetrationpower = 0,
	penetrationdistance = 0
})

game.AddAmmoType({
	name = "45ACP",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 100,
	force = 2100 * 1,
	flags = 0,
	minsplash = 6,
	maxsplash = 10,
	penetrationpower = 15,
	penetrationdistance = 500
})

game.AddAmmoType({
	name = "357SIG",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 52,
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 25,
	penetrationdistance = 800
})

game.AddAmmoType({
	name = "57mmRound",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 100,
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 30,
	penetrationdistance = 2000
})

game.AddAmmoType({
	name = "HEGrenade",
	dmgtype = DMG_BLAST,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Flashbang",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

-- Day of Defeat: Source ammo types
game.AddAmmoType({
	name = "Colt",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 21,
	force = 5000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "P38",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 24,
	force = 5000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "C96",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 60,
	force = 5000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "Garand",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 88,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "K98",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 65,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "M1Carbine",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 165,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "Spring",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 55,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "SubMG",
	dmgtype = DMG_BULLET,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 210,
	force = 7000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "BAR",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 260,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "30Cal",
	dmgtype = bit.bor(DMG_BULLET, DMG_MACHINEGUN),
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 300,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "MG42",
	dmgtype = bit.bor(DMG_BULLET, DMG_MACHINEGUN),
	tracer = TRACER_LINE_AND_WHIZ,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 500,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "Rocket",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 5,
	force = 9000,
	flags = 0,
	minsplash = 10,
	maxsplash = 14
})

game.AddAmmoType({
	name = "HandGrenade",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "StickGrenade",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "HandGrenade_Ex", // the EX is for EXploding! :)
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "StickGrenade_Ex",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 1,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_US",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_Ger",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_US_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "SmokeGrenade_Ger_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_US",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_Ger",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_US_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "RifleGrenade_Ger_Live",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 2,
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})
