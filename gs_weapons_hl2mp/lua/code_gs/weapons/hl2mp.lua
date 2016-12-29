code_gs.LoadAddon("weapons_hl2mp", true) -- Load language
code_gs.weapons.RegisterOverrideConVar("hl2mp")
code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_hl2mp/weapons/", "GS Half-Life 2: Deathmatch", "hl2mp")
code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_hl2mp/entities/", "GS Half-Life 2: Deathmatch", "hl2mp")
