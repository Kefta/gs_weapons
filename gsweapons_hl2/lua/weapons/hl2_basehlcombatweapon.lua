SWEP.Base = "weapon_gs_base"

SWEP.PrintName = "HL2Base"

SWEP.Primary = {
	Damage = 0, -- FIXME: I think damage is managed by the ammo?
	ReloadOnEmptyFire = true
}

SWEP.EmptyCooldown = 0.15
SWEP.HolsterReloadTime = 3

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 SP"
	
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
