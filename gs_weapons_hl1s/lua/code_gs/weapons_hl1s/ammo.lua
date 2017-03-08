CreateConVar("sk_plr_dmg_357round", "40", FCVAR_REPLICATED)
CreateConVar("sk_max_357round", "36", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "357Round",
	displayname = "HL:S .357 Ammo",
	dmgtype = bit.bor(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_357round",
	npcdmg = 0,
	maxcarry = "sk_max_357round",
	force = math.GrainFeetForce(650, 6000, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_buckshot_hl", "5", FCVAR_REPLICATED)
CreateConVar("sk_max_buckshot_hl", "125", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Buckshot_HL",
	displayname = "HL:S Shotgun Ammo",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_buckshot_hl",
	npcdmg = 0,
	maxcarry = "sk_max_buckshot_hl",
	force = math.GrainFeetForce(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_crossbow_hl", "10", FCVAR_REPLICATED)
CreateConVar("sk_max_crossbow_hl", "50", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "XBowBolt_HL",
	displayname = "HL:S Crossbow Bolts",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_crossbow_hl",
	npcdmg = 0,
	maxcarry = "sk_max_crossbow_hl",
	force = math.GrainFeetForce(200, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_rpg_rocket", "100", FCVAR_REPLICATED)
CreateConVar("sk_max_rpg_rocket", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "RPG_Rocket",
	displayname = "HL:S Rockets",
	dmgtype = bit.bor(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_rpg_rocket",
	npcdmg = 0,
	maxcarry = "sk_max_rpg_rocket",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_max_uranium", "100", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Uranium",
	displayname = "Uranium",
	dmgtype = DMG_ENERGYBEAM,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "sk_max_uranium",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_grenade_hl", "100", FCVAR_REPLICATED)
CreateConVar("sk_max_grenade_hl", "10", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Grenade_HL",
	displayname = "HL:S Grenades",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_grenade_hl",
	npcdmg = 0,
	maxcarry = "sk_max_grenade_hl",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_max_snark", "15", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Snark",
	displayname = "Snarks",
	dmgtype = DMG_SLASH,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "sk_max_snark",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_tripmine", "150", FCVAR_REPLICATED)
CreateConVar("sk_max_tripmine", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "TripMine",
	displayname = "Trip Mines",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_tripmine",
	npcdmg = 0,
	maxcarry = "sk_max_tripmine",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_satchel", "150", FCVAR_REPLICATED)
CreateConVar("sk_max_satchel", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Satchel",
	displayname = "Satchel Mines",
	dmgtype = bit.band(DMG_BURN, DMG_BLAST),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_satchel",
	npcdmg = 0,
	maxcarry = "sk_max_satchel",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_npc_dmg_12mmround", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_npc_dmg_12mmround", "8", "10", "10")
end

game.AddAmmoType({
	name = "12mmRound",
	displayname = ".12 Ammo",
	dmgtype = bit.band(DMG_BULLET, DMG_NEVERGIB),
	tracer = TRACER_LINE,
	plydmg = 0, -- FIXME
	npcdmg = "sk_npc_dmg_12mmround",
	maxcarry = 0,
	force = math.GrainFeetForce(300, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})
