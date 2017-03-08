--[[ Portal ammo type
game.AddAmmoType({
	name = "HunterGun",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = "sk_hunter_dmg",
	npcdmg = "sk_hunter_dmg",
	maxcarry = "sk_hunter_max_round",
	force = math.GrainFeetForce(200, 1225, 3.5),
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})]]

-- SDK ammo types
game.AddAmmoType({
	name = "Grenade_SDK",
	displayname = "SDK Grenade",
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
	name = "Bullets_SDK",
	displayname = "SDK Bullets",
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
