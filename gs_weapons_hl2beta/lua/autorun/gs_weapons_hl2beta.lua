hook.Add("GS-Weapons-Load", "GS-Weapons-Load HL2 Beta", function()
	code_gs.LoadAddon("code_gs/weapons_hl2beta", "gsweapons_hl2beta", true) -- Load language
	code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_hl2beta/weapons/", "GS Half-Life 2 Beta", "gsweapons_hl2beta")
	code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_hl2beta/entities/", "GS Half-Life 2 Beta", "gsweapons_hl2beta")
end)
