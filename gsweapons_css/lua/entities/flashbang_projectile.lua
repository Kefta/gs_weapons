AddCSLuaFile()
DEFINE_BASECLASS( "basecsgrenade" )

--- GSBase
ENT.PrintName = "#CStrike_Flashbang"
ENT.Model = "models/weapons/w_eq_flashbang_thrown.mdl"

if ( CLIENT ) then
	ENT.KillIcon = 'g'
end

--- BaseGrenade
ENT.DetonationType = "flash"
