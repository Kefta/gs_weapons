SWEP.Base = "weapon_gs_base"

SWEP.PrintName = "HLBase"

// Make weapons easier to pick up in MP.
SWEP.TriggerBoundSize = game.SinglePlayer() and 24 or 36

SWEP.Sounds = {
	empty = "Weapons.Empty"
}

SWEP.Primary = {
	Damage = 0, -- Damage is handled by the ammo
	ReloadOnEmptyFire = true,
	PunchAngle = vector_origin
}

SWEP.Secondary.PunchAngle = -1

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl1s"
	
	SWEP.ViewModelFOV = 90
end

local PLAYER = FindMetaTable( "Player" )
local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireLuaBullets
end

function SWEP:Punch( bSecondary )
	self:GetOwner():ViewPunch( self:GetSpecialKey( "PunchAngle", bSecondary ))
end
