if (DarkRP) then
	code_gs.LoadAddon("weapons_darkrp", true) -- Load language
	code_gs.weapons.RegisterOverrideConVar("darkrp")
	code_gs.weapons.RegisterWeaponsFromFolder("code_gs/weapons_darkrp/weapons/", "GS DarkRP (Utility)", "darkrp")
	code_gs.weapons.RegisterEntitiesFromFolder("code_gs/weapons_darkrp/entities/", "GS DarkRP (Utility)", "darkrp")
end
