DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "HL2MPBase"

SWEP.Primary = {
	ReloadOnEmptyFire = true,
	Spread = vector_origin
}

SWEP.Secondary.Spread = NULL -- Set to NULL to disable
SWEP.EmptyCooldown = 0.75

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl2"
end

local PLAYER = FindMetaTable( "Player" )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireLuaBullets
end

function SWEP:GetShotTable( bSecondary )
	local tbl = BaseClass.GetShotTable( self, bSecondary )
	tbl.Spread = self:GetSpread( bSecondary )
	
	return tbl
end

--- HL2MPBase
function SWEP:GetSpread( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.Spread
		
		if ( flSpecial ~= NULL ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread
end
