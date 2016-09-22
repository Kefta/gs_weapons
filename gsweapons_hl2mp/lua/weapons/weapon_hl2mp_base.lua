DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "HL2MPBase"
SWEP.Spawnable = false

SWEP.Primary.Spread = vector_origin
SWEP.Secondary.Spread = NULL -- NULL = off
SWEP.EmptyCooldown = 0.75

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	
	SWEP.BobStyle = "hl2"
end

local PLAYER = _R.Player

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.LuaFireBullets
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage(),
			Distance = self:GetRange(),
			Dir = self:GetShootAngles():Forward(),
			--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
			Num = self:GetBulletCount(),
			Penetration = self.Penetration,
			RangeModifier = flRangeModifier,
			Spread = self:GetSpread(),
			Src = self:GetShootSrc(),
			Tracer = 2
		})
		
		return true
	end
	
	return false
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
