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
	Spread = vector_origin,
	PunchAngle = vector_origin
}

SWEP.Secondary = {
	Spread = NULL, -- Set to NULL to disable
	PunchAngle = NULL
}

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

function SWEP:GetShotTable( bSecondary )
	local tbl = BaseClass.GetShotTable( self, bSecondary )
	tbl.Spread = self:GetSpread( bSecondary )
	
	return tbl
end

--- HLBase
function SWEP:GetPunchAngle( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.PunchAngle
		
		if ( flSpecial ~= NULL ) then
			return flSpecial
		end
	end
	
	return self.Primary.PunchAngle
end

function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Spread
		
		if ( flSpecial ~= NULL ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread
end
