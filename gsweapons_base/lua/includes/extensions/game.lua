-- Half-Life/Half-Life 2 damage flags
DMG_SNIPER = bit.lshift( DMG_BUCKSHOT, 1 ) // This is sniper damage
DMG_MISSILEDEFENSE = bit.lshift( DMG_BUCKSHOT, 2 ) // The only kind of damage missiles take. (special missile defense)

-- Counter-Strike: Source damage flag
DMG_HEADSHOT = bit.lshift( DMG_BUCKSHOT, 3 ) -- This is really << 1, but I don't want to create a conflict with DMG_SNIPER

-- Day of Defeat: Source damage flags
DMG_MACHINEGUN = bit.lshift( DMG_BUCKSHOT, 4 ) -- Really << 1
DMG_BOMB = bit.lshift( DMG_BUCKSHOT, 5 ) -- Really << 2

-- Ammo flags
AMMO_FORCE_DROP_IF_CARRIED = 0x1
AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER = 0x2

--[[
	Called by modders to add a new ammo type.
	Ammo types aren't something you can add on the fly. You have one
 	opportunity during loadtime. The ammo types should also be IDENTICAL on 
 	server and client. 
 	If they're not you will receive errors and maybe even crashes.

		game.AddAmmoType({
			name		=	"customammo",
			dmgtype		=	DMG_BULLET,
			tracer		=	TRACER_LINE_AND_WHIZ,
			plydmg		=	20,
			npcdmg		=	20,
			force		=	100,
			minsplash	=	10,
			maxsplash	=	100,
			maxcarry	=	9999,
			flags		=	0
	})
]]

local tAmmoTypes = {}
local tAmmoNames = {}
local bCalled = false

function game.AddAmmoType( tAmmo )
	if ( bCalled ) then
		ErrorNoHalt( string.format( "BuildAmmoTypes already called! Ammo type %q will not be registered", tAmmo.name or "No Name" ))
	elseif ( not tAmmo.name ) then
		ErrorNoHalt( "Ammo attempted to be registered with no name!" )
	elseif ( tAmmoNames[tAmmo.name] ) then
		MsgN( string.format( "Ammo %q registered twice; giving priority to later registration", tAmmo.name ))
		tAmmo.num = tAmmoNames[tAmmo.name].num or #tAmmoTypes + 1
		tAmmoTypes[tAmmo.num] = tAmmo
		tAmmoNames[tAmmo.name] = tAmmo
	else
		local i = #tAmmoTypes + 1
		tAmmo.num = i
		tAmmoTypes[i] = tAmmo
		tAmmoNames[tAmmo.name] = tAmmo
	end
end

-- Called by the engine to retrieve the ammo types
-- You should never have to call this manually
function game.BuildAmmoTypes()
	-- Sort the table by name here to assure that the ammo types
	-- are inserted in the same order on both server and client
	bCalled = true
	table.MergeSort( tAmmoTypes, false, "name" )
	
	return tAmmoTypes
end

function game.GetAmmoDamageType( sAmmo )
	return tAmmoNames[sAmmo] and (tAmmoNames[sAmmo].dmgtype or DMG_BULLET) or 0
end

function game.GetAmmoFlags( sAmmo )
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].flags or 0
end

function game.GetAmmoForce( sAmmo )
	return tAmmoNames[sAmmo] and (tAmmoNames[sAmmo].force or 1000) or 0
end

function game.GetAmmoMaxCarry( sAmmo )
	return tAmmoNames[sAmmo] and (tAmmoNames[sAmmo].maxcarry or 9999) or 0
end

function game.GetAmmoMaxSplash( sAmmo )
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].maxsplash or 0
end

function game.GetAmmoMinSplash( sAmmo )
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].minsplash or 0
end

function game.GetAmmoNPCDamage( sAmmo )
	return tAmmoNames[sAmmo] and (tAmmoNames[sAmmo].npcdmg or 10) or 0
end

function game.GetAmmoPlayerDamage( sAmmo )
	return tAmmoNames[sAmmo] and (tAmmoNames[sAmmo].plydmg or 10) or 0
end

function game.GetAmmoTracerType( sAmmo )
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].tracer or TRACER_NONE
end

-- For custom ammo keys!
function game.GetAmmoKey( sAmmo, sKey, Default --[[= 0]] )
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo][sKey] or Default or 0
end

local function AddDefaultAmmoType( sName, iDamageType, iTracer, iPlayerDamage, iNPCDamage, iMaxCarry, flForce, iFlags, iMinSplash, iMaxSplash )
	tAmmoNames[sName] = {
		dmgtype = iDamageType,
		tracer = iTracer,
		plydmg = iPlayerDamage,
		npcdmg = iNPCDamage,
		maxcarry = 9999, --iMaxCarry, -- Max carry is overwritten in Garry's Mod to always be 9999
		force = flForce,
		flags = iFlags,
		minsplash = iMinSplash or 4,
		maxsplash = iMaxSplash or 8
	}
end

-- This constant is shortened to stick with engine specification
-- flFtPerSec * 12 * 0.002285 * (flGrains / 16) * (1/2.2) * flImpulse
local function BulletImpulse( flGrains, flFtPerSec, flImpulse )
	return flFtPerSec * flGrains * flImpulse * 0.00077897727272727
end

-- Half-Life 2/Deathmatch/Portal ammo types
AddDefaultAmmoType("AR2",DMG_BULLET,TRACER_LINE_AND_WHIZ,0,0,60,BulletImpulse(200, 1225, 3.5),0 )
AddDefaultAmmoType("AR2AltFire",DMG_DISSOLVE,TRACER_NONE,0,0,3,0,0 )
AddDefaultAmmoType("Pistol",DMG_BULLET,TRACER_LINE_AND_WHIZ,0,0,150,BulletImpulse(200, 1225, 3.5),0 )
AddDefaultAmmoType("SMG1",DMG_BULLET,TRACER_LINE_AND_WHIZ,0,0,225,BulletImpulse(200, 1225, 3.5),0 )
AddDefaultAmmoType("357",DMG_BULLET,TRACER_LINE_AND_WHIZ,0,0,12,BulletImpulse(800, 5000, 3.5),0 )
AddDefaultAmmoType("XBowBolt",DMG_BULLET,TRACER_LINE,0,0,10,BulletImpulse(800, 8000, 3.5),0 )
AddDefaultAmmoType("Buckshot",bit.bor(DMG_BULLET,DMG_BUCKSHOT),TRACER_LINE,0,0,30,BulletImpulse(400, 1200, 3.5),0 )
AddDefaultAmmoType("RPG_Round",DMG_BURN,TRACER_NONE,0,0,3,0,0 )
AddDefaultAmmoType("SMG1_Grenade",DMG_BURN,TRACER_NONE,0,0,3,0,0 )
AddDefaultAmmoType("Grenade",DMG_BURN,TRACER_NONE,0,0,5,0,0 )
AddDefaultAmmoType("slam",DMG_BURN,TRACER_NONE,0,0,5,0,0 )

-- Half-Life 2/Portal ammo types
AddDefaultAmmoType("AlyxGun",DMG_BULLET,TRACER_LINE,0,0,0,BulletImpulse(200, 1225, 3.5), 0 )
AddDefaultAmmoType("SniperRound",bit.bor(DMG_BULLET,DMG_SNIPER),TRACER_NONE,0,0,0,BulletImpulse(650, 6000, 3.5), 0 )
AddDefaultAmmoType("SniperPenetratedRound", bit.bor(DMG_BULLET,DMG_SNIPER), TRACER_NONE,0, 0, 0, BulletImpulse(150, 6000, 3.5), 0 )
AddDefaultAmmoType("Thumper",DMG_SONIC,TRACER_NONE,10, 10, 2, 0, 0 )
AddDefaultAmmoType("Gravity",DMG_CLUB,TRACER_NONE,0,0, 8, 0, 0 )
AddDefaultAmmoType("Battery",DMG_CLUB,TRACER_NONE,0, 0, 0, 0, 0 )
AddDefaultAmmoType("GaussEnergy",DMG_SHOCK,TRACER_NONE,15,15, 0, BulletImpulse(650, 8000, 3.5), 0 ) // hit like a 10kg weight at 400 in/s
AddDefaultAmmoType("CombineCannon",DMG_BULLET,TRACER_LINE,0, 0, 0, 1.5 * 750 * 12, 0 ) // hit like a 1.5kg weight at 750 ft/s
AddDefaultAmmoType("AirboatGun",DMG_AIRBOAT,TRACER_LINE,0,0,0,BulletImpulse(10, 600, 3.5), 0 )

//=====================================================================
// STRIDER MINIGUN DAMAGE - Pull up a chair and I'll tell you a tale.
//
// When we shipped Half-Life 2 in 2004, we were unaware of a bug in
// CAmmoDef::NPCDamage() which was returning the MaxCarry field of
// an ammotype as the amount of damage that should be done to a NPC
// by that type of ammo. Thankfully, the bug only affected Ammo Types 
// that DO NOT use ConVars to specify their parameters. As you can see,
// all of the important tAmmoTypes use ConVars, so the effect of the bug
// was limited. The Strider Minigun was affected, though.
//
// According to my perforce Archeology, we intended to ship the Strider
// Minigun ammo type to do 15 points of damage per shot, and we did. 
// To achieve this we, unaware of the bug, set the Strider Minigun ammo 
// type to have a maxcarry of 15, since our observation was that the 
// number that was there before (8) was indeed the amount of damage being
// done to NPC's at the time. So we changed the field that was incorrectly
// being used as the NPC Damage field.
//
// The bug was fixed during Episode 1's development. The result of the 
// bug fix was that the Strider was reduced to doing 5 points of damage
// to NPC's, since 5 is the value that was being assigned as NPC damage
// even though the code was returning 15 up to that point.
//
// Now as we go to ship Orange Box, we discover that the Striders in 
// Half-Life 2 are hugely ineffective against citizens, causing big
// problems in maps 12 and 13. 
//
// In order to restore balance to HL2 without upsetting the delicate 
// balance of ep2_outland_12, I have chosen to build Episodic binaries
// with 5 as the Strider->NPC damage, since that's the value that has
// been in place for all of Episode 2's development. Half-Life 2 will
// build with 15 as the Strider->NPC damage, which is how HL2 shipped
// originally, only this time the 15 is located in the correct field
// now that the AmmoDef code is behaving correctly.
//
//=====================================================================
AddDefaultAmmoType("StriderMinigun",DMG_BULLET,TRACER_LINE,5, 15,15, 1 * 750 * 12, AMMO_FORCE_DROP_IF_CARRIED) // hit like a 1kg weight at 750 ft/s
AddDefaultAmmoType("HelicopterGun",DMG_BULLET,TRACER_LINE_AND_WHIZ,3, 6,0,BulletImpulse(400, 1225, 3.5), bit.bor(AMMO_FORCE_DROP_IF_CARRIED,AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER))

-- Half-Life 1 ammo types
AddDefaultAmmoType("9mmRound",bit.bor(DMG_BULLET,DMG_NEVERGIB),TRACER_LINE, 0,0,0,BulletImpulse(500, 1325, 3), 0)
AddDefaultAmmoType("MP5_Grenade",bit.bor(DMG_BURN,DMG_BLAST),TRACER_NONE, 0,0,0,0, 0)
AddDefaultAmmoType("Hornet",DMG_BULLET,TRACER_NONE, 0,0,0,BulletImpulse(100, 1200, 3), 0)

-- One more Half-Life 2 ammo type
AddDefaultAmmoType("StriderMinigunDirect",DMG_BULLET,TRACER_LINE,2, 2, 15, 1 * 750 * 12, AMMO_FORCE_DROP_IF_CARRIED) // hit like a 1kg weight at 750 ft/s

-- Half-Life 2: Episodic ammo types
AddDefaultAmmoType("CombineHeavyCannon",DMG_BULLET,TRACER_LINE,40,40, 0, 10 * 750 * 12, AMMO_FORCE_DROP_IF_CARRIED) // hit like a 10 kg weight at 750 ft/s

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
	name = "9mmRound_CStrike",
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
	name = "Buckshot_CStrike",
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
