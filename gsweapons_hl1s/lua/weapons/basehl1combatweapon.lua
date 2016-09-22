DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "HLBase"
SWEP.Spawnable = false

SWEP.ViewModelFOV = 100

SWEP.Sounds = {
	empty = "Weapons.Empty"
}

SWEP.Primary = {
	Spread = vector_origin,
	PunchAngle = vector_origin
}

SWEP.Secondary = {
	Spread = -1, -- -1 = off
	PunchAngle = -1
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
	SWEP.BobStyle = "hl"
	SWEP.CrosshairStyle = "hl"
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
			Dir = self:GetShootAngles():Forward(),
			Distance = self:GetRange(),
			--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
			Num = self:GetBulletCount(),
			Spread = self:GetSpread(),
			Src = self:GetShootSrc(),
			Tracer = 2
		})
		
		return true
	end
	
	return false
end

function SWEP:Punch( bSecondary )
	self:GetOwner():ViewPunch( self:GetPunchAngle( bSecondary ))
end

--- HLBase
function SWEP:GetPunchAngle( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.PunchAngle
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.PunchAngle
end

function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Spread
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread
end
