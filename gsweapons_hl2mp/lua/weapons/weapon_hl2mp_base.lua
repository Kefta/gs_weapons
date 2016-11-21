SWEP.Base = "weapon_gs_base"

SWEP.PrintName = "HL2MPBase"

SWEP.Primary.ReloadOnEmptyFire = true

SWEP.EmptyCooldown = 0.75

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	
	SWEP.ViewModelFOV = 54
	
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl2"
end

local PLAYER = FindMetaTable( "Player" )
local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireLuaBullets
end
