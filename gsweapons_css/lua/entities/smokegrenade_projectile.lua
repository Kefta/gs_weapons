AddCSLuaFile()
DEFINE_BASECLASS( "basecsgrenade" )

--- GSBase
ENT.PrintName = "#CStrike_SmokeGrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"

if ( CLIENT ) then
	ENT.KillIcon = 'p'
end

--- BaseGrenade
ENT.DetonationType = "smoke"
