DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "HL2MPBase"
SWEP.Spawnable = false

SWEP.Primary = {
	ReloadOnEmptyFire = true,
	Spread = vector_origin
}

SWEP.Secondary.Spread = NULL -- NULL = off
SWEP.EmptyCooldown = 0.75

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl2"
end

local PLAYER = _R.Player

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.LuaFireBullets
end

function SWEP:GetShotTable( bSecondary )
	local tbl = BaseClass.GetShotTable( self, bSecondary )
	tbl.Spread = self:GetSpread( bSecondary )
	
	return tbl
end

--- HL2MPBase
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Spread
		
		if ( flSpecial ~= NULL ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread
end
