code_gs.LoadAddon("weapons_hl2", true) -- Load language
code_gs.weapons.RegisterOverrideConVar("hl2")
code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_hl2/weapons/", "GS Half-Life 2", "hl2")
code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_hl2/entities/", "GS Half-Life 2", "hl2")
