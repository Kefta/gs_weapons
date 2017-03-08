hook.Add("GS-Weapons-Load", "GS-Weapons-Load CS:S", function()
	code_gs.LoadAddon("code_gs/weapons_css", "gsweapons_css", true) -- Load language
	code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_css/weapons/", "GS Counter-Strike: Source", "gsweapons_css")
	code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_css/entities/", "GS Counter-Strike: Source", "gsweapons_css")
end)
