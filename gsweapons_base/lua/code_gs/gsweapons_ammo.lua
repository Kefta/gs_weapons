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
