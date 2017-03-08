hook.Add("GS-Weapons-Load", "GS-Weapons-Load DoD:S", function()
	code_gs.LoadAddon("code_gs/weapons_dods", "gsweapons_dods", true) -- Load language
	code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_dods/weapons/", "GS Day of Defeat: Source", "gsweapons_dods")
	code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_dods/entities/", "GS Day of Defeat: Source", "gsweapons_dods")
end)
