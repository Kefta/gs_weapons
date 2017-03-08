hook.Add("GS-Weapons-Load", "GS-Weapons-Load HL1:S", function()
	code_gs.LoadAddon("code_gs/weapons_hl1s", "gsweapons_hl1s", true) -- Load language
	code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_hl1s/weapons/", "GS Half-Life: Source", "gsweapons_hl1s")
	code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_hl1s/entities/", "GS Half-Life: Source", "gsweapons_hl1s")
end)
