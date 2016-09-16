DEFINE_BASECLASS( "weapon_cs_base" )

--- GSBase
SWEP.PrintName = "CSBase_Gun"
SWEP.Spawnable = false

SWEP.Sounds = {
	secondary = "Default.Zoom",
	empty = "Default.ClipEmpty_Rifle"
}

SWEP.Primary = {
	RangeModifier = 0.98,
	Spread = {
		Base = 0,
		Bias = 0.5
	}
}

SWEP.Secondary = {
	RangeModifier = -1,
	Spread = {
		Base = -1,
		Bias = -1
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

--- CSBase_Gun
SWEP.Penetration = 1

--- GSBase
function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		local bSecondary = self:SpecialActive()
		local flRangeModifier
		local flSpreadBias
		
		if ( bSecondary ) then
			local flSpecial = self.Secondary.RangeModifier
			
			if ( flSpecial ~= -1 ) then
				flRangeModifier = flSpecial
			else
				flRangeModifier = self.Primary.RangeModifier
			end
			
			flSpecial = self.Secondary.Spread.Bias
			
			if ( flSpecial ~= -1 ) then
				flSpreadBias = flSpecial
			else
				flSpreadBias = self.Primary.Spread.Bias
			end
		else
			flRangeModifier = self.Primary.RangeModifier
			flSpreadBias = self.Primary.Spread.Bias
		end
		
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage( bSecondary ),
			Distance = self:GetRange( bSecondary ),
			Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
			Num = self:GetBulletCount( bSecondary ),
			Penetration = self.Penetration,
			RangeModifier = flRangeModifier,
			ShootAngles = self:GetShootAngles(),
			Spread = self:GetSpread( bSecondary ),
			SpreadBias = flSpreadBias,
			Src = self:GetShootSrc(),
			TracerFreq = self.TracerFreq
		})
		
		return true
	end
	
	return false
end

-- Punch angles get more influence with CS:S weapons
function SWEP:GetShootAngles()
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + 2 * pPlayer:GetViewPunchAngles()
end

--- CSBase_Gun
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Spread.Base
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread.Base
end
