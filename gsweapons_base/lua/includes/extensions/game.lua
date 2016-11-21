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
		MsgN( string.format( "BuildAmmoTypes already called! Ammo type %q will not be registered", tAmmo.name or "No Name" ))
	elseif ( not tAmmo.name ) then
		MsgN( "Ammo attempted to be registered with no name!" )
	else
		local sAmmo = tAmmo.name:lower()
		
		if ( isstring( tAmmo.plydmg )) then
			tAmmo.plydmg = GetConVarNumber( tAmmo.plydmg )
		end
		
		if ( isstring( tAmmo.npcdmg )) then
			tAmmo.npcdmg = GetConVarNumber( tAmmo.npcdmg )
		end
		
		if ( isstring( tAmmo.maxcarry )) then
			tAmmo.maxcarry = GetConVarNumber( tAmmo.maxcarry )
		end
		
		if ( tAmmoNames[sAmmo] ) then
			MsgN( string.format( "Ammo %q registered twice; giving priority to later registration", tAmmo.name ))
			tAmmo.num = tAmmoNames[sAmmo].num or #tAmmoTypes + 1
			tAmmoTypes[tAmmo.num] = tAmmo
			tAmmoNames[sAmmo] = tAmmo
		else
			local i = #tAmmoTypes + 1
			tAmmo.num = i
			tAmmoTypes[i] = tAmmo
			tAmmoNames[sAmmo] = tAmmo
		end
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
	sAmmo = sAmmo:lower()
	return tAmmoNames[sAmmo] and (tAmmoNames[sAmmo].dmgtype or DMG_BULLET) or 0
end

function game.GetAmmoFlags( sAmmo )
	sAmmo = sAmmo:lower()
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].flags or 0
end

function game.GetAmmoForce( sAmmo )
	sAmmo = sAmmo:lower()
	return tAmmoNames[sAmmo] and (tAmmoNames[sAmmo].force or 1000) or 0
end

function game.GetAmmoMaxCarry( sAmmo )
	local tAmmo = tAmmoNames[sAmmo:lower()]
	
	if ( tAmmo ) then
		tAmmo = tAmmo.maxcarry
		
		if ( tAmmo ) then
			if ( isstring( tAmmo )) then
				return GetConVarNumber( tAmmo )
			end
			
			return tAmmo
		end
		
		return 9999
	end
	
	return 0
end

function game.GetAmmoMaxSplash( sAmmo )
	sAmmo = sAmmo:lower()
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].maxsplash or 0
end

function game.GetAmmoMinSplash( sAmmo )
	sAmmo = sAmmo:lower()
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].minsplash or 0
end

function game.GetAmmoNPCDamage( sAmmo )
	local tAmmo = tAmmoNames[sAmmo:lower()]
	
	if ( tAmmo ) then
		tAmmo = tAmmo.npcdmg
		
		if ( tAmmo ) then
			if ( isstring( tAmmo )) then
				return GetConVarNumber( tAmmo )
			end
			
			return tAmmo
		end
		
		return 10
	end
	
	return 0
end

function game.GetAmmoPlayerDamage( sAmmo )
	local tAmmo = tAmmoNames[sAmmo:lower()]
	
	if ( tAmmo ) then
		tAmmo = tAmmo.plydmg
		
		if ( tAmmo ) then
			if ( isstring( tAmmo )) then
				return GetConVarNumber( tAmmo )
			end
			
			return tAmmo
		end
		
		return 10
	end
	
	return 0
end

function game.GetAmmoTracerType( sAmmo )
	sAmmo = sAmmo:lower()
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo].tracer or TRACER_NONE
end

-- For custom ammo keys!
function game.GetAmmoKey( sAmmo, sKey, Default --[[= 0]] )
	sAmmo = sAmmo:lower()
	return tAmmoNames[sAmmo] and tAmmoNames[sAmmo][sKey] or Default or 0
end

local function AddDefaultAmmoType( sAmmo, iDamageType, iTracer, iPlayerDamage, iNPCDamage, iMaxCarry, flForce, iFlags, iMinSplash, iMaxSplash )
	tAmmoNames[sAmmo:lower()] = {
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

-- Half-Life 2: Episodic ammo type
AddDefaultAmmoType("CombineHeavyCannon",DMG_BULLET,TRACER_LINE,40,40, 0, 10 * 750 * 12, AMMO_FORCE_DROP_IF_CARRIED) // hit like a 10 kg weight at 750 ft/s
