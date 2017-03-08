CreateConVar("ammo_50ae_max", "35", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "50AE",
	displayname = ".50 AE Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_50ae_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 30,
	penetrationdistance = 1000
})

CreateConVar("ammo_762mm_max", "90", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "762mm",
	displayname = ".762 Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_762mm_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 39,
	penetrationdistance = 5000
})

CreateConVar("ammo_556mm_max", "90", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "556mm",
	displayname = ".556 Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_556mm_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

CreateConVar("ammo_556mm_box_max", "200", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "556mm_Box",
	displayname = ".556 Box Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_556mm_box_max",
	force = 2400 * 1,
	flags = 0,
	minsplash = 10,
	maxsplash = 14,
	penetrationpower = 35,
	penetrationdistance = 4000
})

CreateConVar("ammo_338mag_max", "30", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "338mag",
	displayname = ".338 Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_338mag_max",
	force = 2800 * 1,
	flags = 0,
	minsplash = 12,
	maxsplash = 16,
	penetrationpower = 45,
	penetrationdistance = 8000
})

CreateConVar("ammo_9mm_max", "120", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "9mm",
	displayname = ".9 Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_9mm_max",
	force = 2000 * 1,
	flags = 0,
	minsplash = 5,
	maxsplash = 10,
	penetrationpower = 21,
	penetrationdistance = 800
})

CreateConVar("ammo_buckshot_max", "32", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Buckshot_CSS",
	displayname = "CS:S Shotgun Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_buckshot_max",
	force = 600 * 1,
	flags = 0,
	minsplash = 3,
	maxsplash = 6,
	penetrationpower = 0,
	penetrationdistance = 0
})

CreateConVar("ammo_45acp_max", "100", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "45ACP",
	displayname = ".45 ACP Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_45acp_max",
	force = 2100 * 1,
	flags = 0,
	minsplash = 6,
	maxsplash = 10,
	penetrationpower = 15,
	penetrationdistance = 500
})

CreateConVar("ammo_357sig_max", "52", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "357SIG",
	displayname = ".357 SIG Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_357sig_max",
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 25,
	penetrationdistance = 800
})

CreateConVar("ammo_57mm_max", "100", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "57mm",
	displayname = ".57 Ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_57mm_max",
	force = 2000 * 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8,
	penetrationpower = 30,
	penetrationdistance = 2000
})

CreateConVar("ammo_hegrenade_max", "1", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "HEGrenade",
	displayname = "High Explosive Grenades",
	dmgtype = DMG_BLAST,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_hegrenade_max",
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("ammo_flashbang_max", "2", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Flashbang",
	displayname = "Flashbang Grenades",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_flashbang_max",
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("ammo_smokegrenade_max", "1", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "SmokeGrenade",
	displayname = "Smoke Grenades",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "ammo_smokegrenade_max",
	force = 1,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})
