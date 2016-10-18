DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "SDKBase"

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Rifle"
}

SWEP.Primary = {
	Ammo = "Bullets_SDK",
	Range = 8000,
	Spread = {
		Base = 0,
		Bias = 0.5
	},
	RangeModifier = 0.85
}

SWEP.Secondary.Spread = {
	Base = -1,
	Bias = -1
}

SWEP.TracerFreq = 0

if ( CLIENT ) then
	SWEP.Category = "Source"
	SWEP.KillIconFont = "CSSKillIcon"
	SWEP.SelectionFont = "CSSSelection"
	
	-- No additions!
	SWEP.BobStyle = ""
	SWEP.CrosshairStyle = ""
	SWEP.ScopeStyle = ""
	SWEP.DrawCrosshair = false
	
	-- No events!
	SWEP.EventStyle = {
		-- CS:S bullet ejection
		[20] = "",
		
		-- HL2 muzzle flashes
		[21] = "", -- First-person
		[22] = "", -- Third-person
		
		-- Reload
		[3015] = "",
		
		-- CS:S muzzle flash
		[5001] = "", -- First-person, Attachment 0
		[5003] = "", -- Third-person, Attachment 0
		[5011] = "", -- First-person, Attachment 1
		[5013] = "", -- Third-person, Attachment 1
		[5021] = "", -- First-person, Attachment 2
		[5023] = "", -- Third-person, Attachment 2
		[5031] = "", -- First-person, Attachment 3
		[5033] = "", -- Third-person, Attachment 3
		
		-- HL2 bullet ejection
		[6001] = ""
	}
end

local PLAYER = FindMetaTable( "Player" )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireSDKBullets
end

function SWEP:UpdateBurstShotTable( tbl )
	tbl.ShootAngles = self:GetShootAngles()
	tbl.Src = self:GetShootSrc()
end

function SWEP:GetShotTable( bSecondary )
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
	
	return {
		AmmoType = self:GetPrimaryAmmoName(),
		Damage = self:GetDamage( bSecondary ),
		Distance = self:GetRange( bSecondary ),
		--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
		Num = self:GetBulletCount( bSecondary ),
		RangeModifier = flRangeModifier,
		ShootAngles = self:GetShootAngles(),
		Spread = self:GetSpread( bSecondary ),
		SpreadBias = flSpreadBias,
		Src = self:GetShootSrc(),
		Tracer = self.TracerFreq,
		TracerName = self.TracerName
	}
end

function SWEP:DoMuzzleFlash()
end

--- SDKBase
function SWEP:GetSpread( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.Spread.Base
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread.Base
end
