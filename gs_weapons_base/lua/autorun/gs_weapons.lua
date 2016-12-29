include("code_gs/gs.lua")
AddCSLuaFile("code_gs/gs.lua")

code_gs.LoadAddon("lib", false) -- Optional

if (not code_gs.LoadAddon("weapons", true)) then
	error("[GS] Weapons failed to load!")
end
