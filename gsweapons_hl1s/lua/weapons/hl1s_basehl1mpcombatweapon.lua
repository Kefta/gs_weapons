-- In HL1, there's two weapon bases for prediction matters that don't apply to Garry's Mod
-- However, both are defined as entities so it has to still be registered anyway
DEFINE_BASECLASS( "hl1s_basehl1combatweapon" )

SWEP.PrintName = "HLMPBase"
SWEP.Spawnable = false

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end
