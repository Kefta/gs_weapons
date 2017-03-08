include("code_gs/gs.lua")

code_gs.LoadAddon("code_gs/lib", "gslib") -- Optional

if (not code_gs.LoadAddon("code_gs/weapons", "gsweapons", true)) then
	error("[GS] GSWeapons failed to load!")
end
