DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "HL2Base"

SWEP.ViewModelFOV = 75

SWEP.Primary = {
	Damage = 0, -- FIXME: I think damage is managed by the ammo?
	ReloadOnEmptyFire = true,
	Spread = vector_origin
}

SWEP.Secondary.Spread = NULL -- Set to NULL to disable
SWEP.EmptyCooldown = 0.15
SWEP.HolsterReloadTime = 3

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 SP"
	
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

--- HL2Base
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Spread
		
		if ( flSpecial ~= NULL ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread
end
