CreateConVar("sk_plr_dmg_small_round", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_plr_dmg_small_round", "3", "5", "5")
end

CreateConVar("sk_npc_dmg_small_round", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_npc_dmg_small_round", "1", "2", "5")
end

CreateConVar("sk_max_small_round", "150", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "SmallRound",
	displayname = "Small Rounds",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_small_round",
	npcdmg = "sk_npc_dmg_small_round",
	maxcarry = "sk_max_small_round",
	force = math.GrainFeetForce(125, 1325, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_medium_round", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_plr_dmg_medium_round", "10", "8", "8")
end

CreateConVar("sk_npc_dmg_medium_round", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_npc_dmg_medium_round", "3", "4", "7")
end

CreateConVar("sk_max_medium_round", "150", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "MediumRound",
	displayname = "Medium Rounds",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_medium_round",
	npcdmg = "sk_npc_dmg_medium_round",
	maxcarry = "sk_max_medium_round",
	force = math.GrainFeetForce(200, 1225, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_large_round", "15", FCVAR_REPLICATED)
CreateConVar("sk_npc_dmg_large_round", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_npc_dmg_large_round", "5", "6", "10")
end

CreateConVar("sk_max_large_round", "60", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "LargeRound",
	displayname = "Large Rounds",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_large_round",
	npcdmg = "sk_npc_dmg_large_round",
	maxcarry = "sk_max_large_round",
	force = math.GrainFeetForce(250, 1180, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_flare_round", "12", FCVAR_REPLICATED)
CreateConVar("sk_npc_dmg_flare_round", "2", FCVAR_REPLICATED)
CreateConVar("sk_max_flare_round", "20", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "FlareRound",
	displayname = "Flare Rounds",
	dmgtype = DMG_BURN,
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_flare_round",
	npcdmg = "sk_npc_dmg_flare_round",
	maxcarry = "sk_max_flare_round",
	force = math.GrainFeetForce(1500, 600, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_buckshot_beta", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_plr_dmg_buckshot_beta", "5", "8", "8")
end

CreateConVar("sk_npc_dmg_buckshot_beta", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_npc_dmg_buckshot_beta", "3", "2", "3")
end

CreateConVar("sk_max_buckshot_beta", "30", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Buckshot_Beta",
	displayname = "Beta Shotgun Ammo",
	dmgtype = bit.bor(DMG_BULLET, DMG_BUCKSHOT),
	tracer = TRACER_LINE,
	plydmg = "sk_plr_dmg_buckshot_beta",
	npcdmg = "sk_npc_dmg_buckshot_beta",
	maxcarry = "sk_max_buckshot_beta",
	force = math.GrainFeetForce(100, 1200, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_ml_grenade", "100", FCVAR_REPLICATED)
CreateConVar("sk_npc_dmg_ml_grenade", "50", FCVAR_REPLICATED)
CreateConVar("sk_max_ml_grenade", "3", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "ML_Grenade",
	displayname = "ML Grenades",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_ml_grenade",
	npcdmg = "sk_npc_dmg_ml_grenade",
	maxcarry = "sk_max_ml_grenade",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_ar2_grenade", "100", FCVAR_REPLICATED)
CreateConVar("sk_npc_dmg_ar2_grenade", "50", FCVAR_REPLICATED)
CreateConVar("sk_max_ar2_grenade", "3", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "AR2_Grenade",
	displayname = "AR2 Grenades",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_ar2_grenade",
	npcdmg = "sk_npc_dmg_ar2_grenade",
	maxcarry = "sk_max_ar2_grenade",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_sniper_round_beta", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_plr_dmg_sniper_round_beta", "20", "50", "50")
end

CreateConVar("sk_npc_dmg_sniper_round_beta", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_npc_dmg_sniper_round_beta", "100", "25", "25")
end

CreateConVar("sk_max_sniper_round_beta", "30", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "SniperRound_Beta",
	displayname = "Beta Sniper Rounds",
	dmgtype = bit.bor(DMG_BULLET, DMG_SNIPER),
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_sniper_round_beta",
	npcdmg = "sk_npc_dmg_sniper_round_beta",
	maxcarry = "sk_max_sniper_round_beta",
	force = math.GrainFeetForce(650, 8000, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_dmg_sniper_penetrate_plr_beta", "0", FCVAR_REPLICATED)

if (SERVER) then
	game.RegisterSkillConVar("sk_dmg_sniper_penetrate_plr_beta", "10", "35", "35")
end

CreateConVar("sk_dmg_sniper_penetrate_npc_beta", "100", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "SniperPenetratedRound_Beta",
	displayname = "Beta Sniper Penetrated Rounds",
	dmgtype = bit.bor(DMG_BULLET, DMG_SNIPER),
	tracer = TRACER_NONE,
	plydmg = "sk_dmg_sniper_penetrate_plr_beta",
	npcdmg = "sk_dmg_sniper_penetrate_npc_beta",
	maxcarry = "sk_max_sniper_round_beta",
	force = math.GrainFeetForce(150, 6000, 3),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_max_slam", "20", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Slam_Beta",
	displayname = "Beta SLAM Ammo",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "sk_max_slam",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_max_tripwire", "0", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Tripwire",
	displayname = "Tripwire Ammo",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = "sk_max_tripwire",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_molotov", "100", FCVAR_REPLICATED)
CreateConVar("sk_npc_dmg_molotov", "50", FCVAR_REPLICATED)
CreateConVar("sk_max_molotov", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Molotov",
	displayname = "Molotov Ammo",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_molotov",
	npcdmg = "sk_npc_dmg_molotov",
	maxcarry = "sk_max_molotov",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_grenade_beta", "150", FCVAR_REPLICATED)
CreateConVar("sk_npc_dmg_grenade_beta", "75", FCVAR_REPLICATED)
CreateConVar("sk_max_grenade_beta", "5", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Grenade_Beta",
	displayname = "Grenades",
	dmgtype = DMG_BURN,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_grenade_beta",
	npcdmg = "sk_npc_dmg_grenade_beta",
	maxcarry = "sk_max_grenade_beta",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

CreateConVar("sk_plr_dmg_brickbat", "3", FCVAR_REPLICATED)
CreateConVar("sk_npc_dmg_brickbat", "2", FCVAR_REPLICATED)
CreateConVar("sk_max_brickbat", "8", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Brickbat",
	displayname = "Brickbat Ammo",
	dmgtype = DMG_CLUB,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_brickbat",
	npcdmg = "sk_npc_dmg_brickbat",
	maxcarry = "sk_max_brickbat",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Rock",
	displayname = "Rocks",
	dmgtype = DMG_CLUB,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_brickbat",
	npcdmg = "sk_npc_dmg_brickbat",
	maxcarry = "sk_max_brickbat",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Extinguisher",
	displayname = "Potassium Bicarbonate",
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

game.AddAmmoType({
	name = "GaussEnergy_Beta",
	displayname = "Beta Gauss Energy",
	dmgtype = DMG_SHOCK,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	maxcarry = 150,
	force = 10 * 400, // hit like a 10kg weight at 400 in/s
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "Hopwire_Beta",
	displayname = "Beta Hopwire Ammo",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = 1,
	npcdmg = 1,
	maxcarry = 5,
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "CombineCannon_Beta",
	displayname = "Beta Combine Cannon Rounds",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 5,
	npcdmg = 5,
	maxcarry = 15,
	force = 1.5 * 750 * 12, // hit like a 1.5kg weight at 750 ft/s
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})
