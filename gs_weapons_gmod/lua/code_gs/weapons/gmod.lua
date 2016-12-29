code_gs.LoadAddon("weapons_gmod", true) -- Load language
code_gs.weapons.RegisterOverrideConVar("gmod")
code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_gmod/weapons/", "GS Garry's Mod", "gmod")
code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_gmod/entities/", "GS Garry's Mod", "gmod")
