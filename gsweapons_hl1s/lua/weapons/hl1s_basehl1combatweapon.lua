DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "HLBase"

SWEP.ViewModelFOV = 90

// Make weapons easier to pick up in MP.
SWEP.TriggerBoundSize = game.SinglePlayer() and 24 or 36

SWEP.Sounds = {
	empty = "Weapons.Empty"
}

SWEP.Primary = {
	Damage = 0, -- HL1 uses ammo damage
	ReloadOnEmptyFire = true,
	PunchAngle = vector_origin
}

SWEP.Secondary.PunchAngle = NULL -- Set to NULL to disable

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl1s"
end

local PLAYER = FindMetaTable( "Player" )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireLuaBullets
end

function SWEP:Punch( bSecondary )
	self:GetOwner():ViewPunch( self:GetPunchAngle( bSecondary ))
end

--- HLBase
function SWEP:GetPunchAngle( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.PunchAngle
		
		if ( flSpecial ~= NULL ) then
			return flSpecial
		end
	end
	
	return self.Primary.PunchAngle
end
