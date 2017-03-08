hook.Add("GS-Weapons-Load", "GS-Weapons-Load HL2", function()
	code_gs.LoadAddon("code_gs/weapons_hl2", "gsweapons_hl2", true) -- Load language
	code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_hl2/weapons/", "GS Half-Life 2", "gsweapons_hl2")
	code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_hl2/entities/", "GS Half-Life 2", "gsweapons_hl2")
end)
