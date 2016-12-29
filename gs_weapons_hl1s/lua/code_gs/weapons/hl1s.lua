code_gs.LoadAddon("weapons_hl1s", true) -- Load language
code_gs.weapons.RegisterOverrideConVar("hl1s")
code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_hl1s/weapons/", "GS Half-Life: Source", "hl1s")
code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_hl1s/entities/", "GS Half-Life: Source", "hl1s")
