game.AddAmmoType({
	name = "Colt",
	displayname = "Colt Ammo",
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
	displayname = "P38 Ammo",
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
	displayname = "C96 Ammo",
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
	displayname = "Garand Rounds",
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
	displayname = "K98 Ammo",
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
	displayname = "M1 Carbine Ammo",
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
	displayname = "Springfield Rounds",
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
	displayname = "Sub Machine Gun Ammo",
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
	displayname = "Browning Automatic Rifle Ammo",
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
	name = "30cal",
	displayname = ".30 Ammo",
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
	displayname = "Maschinengewehr 42 Ammo",
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
	displayname = "DoD:S Rockets",
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
	displayname = "Hand Grenades",
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
	displayname = "Sticky Grenades",
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
	displayname = "Exploding Hand Grenades",
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
	displayname = "Exploding Sticky Grenades",
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
	displayname = "American Smoke Grenades",
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
	displayname = "German Smoke Grenades",
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
	displayname = "Live American Smoke Grenades",
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
	displayname = "Live German Smoke Grenades",
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
	displayname = "American Rifle Grenades",
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
	displayname = "German Rifle Grenades",
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
	displayname = "Live American Rifle Grenades",
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
	displayname = "Live German Rifle Grenades",
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
