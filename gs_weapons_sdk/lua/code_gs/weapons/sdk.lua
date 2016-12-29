code_gs.LoadAddon("weapons_sdk", true) -- Load language
code_gs.weapons.RegisterOverrideConVar("sdk")
code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_sdk/weapons/", "GS Source", "sdk")
code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_sdk/entities/", "GS Source", "sdk")
