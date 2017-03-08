-- Episodic ammo types
game.AddAmmoType({
	name = "StriderMinigun_Episodic",
	displayname = "Episodic Strider Minigun Ammo",
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

CreateConVar("sk_max_hopwire", "3", FCVAR_REPLICATED)

game.AddAmmoType({
	name = "Hopwire",
	displayname = "Hopwire Ammo",
	dmgtype = DMG_BLAST,
	tracer = TRACER_NONE,
	plydmg = "sk_plr_dmg_grenade",
	npcdmg = "sk_npc_dmg_grenade",
	maxcarry = "sk_max_hopwire",
	force = 0,
	flags = 0,
	minsplash = 4,
	maxsplash = 8
})

game.AddAmmoType({
	name = "ammo_proto1",
	displayname = "Proto Ammo",
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
