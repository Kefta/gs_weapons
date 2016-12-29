code_gs.LoadAddon("weapons_dods", true) -- Load language
code_gs.weapons.RegisterOverrideConVar("dods")
code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_dods/weapons/", "GS Day of Defeat: Source", "dods")
code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_dods/entities/", "GS Day of Defeat: Source", "dods")
