code_gs.LoadAddon("weapons_css", true) -- Load language
code_gs.weapons.RegisterOverrideConVar("css")
code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_css/weapons/", "GS Counter-Strike: Source", "css")
code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_css/entities/", "GS Counter-Strike: Source", "css")
