SWEP.Base = "weapon_gs_base"

SWEP.PrintName = "SDKBase"

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Rifle"
}

SWEP.Primary = {
	Ammo = "Bullets_SDK",
	Range = 8000,
	RangeModifier = 0.85
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
		[20] = "",
		[21] = "",
		[22] = "",
		[3015] = "",
		[5001] = "",
		[5003] = "",
		[5011] = "",
		[5013] = "",
		[5021] = "",
		[5023] = "",
		[5031] = "",
		[5033] = "",
		[6001] = "",
		[6002] = ""
	}
end

local BaseClass = baseclass.Get( SWEP.Base )
local PLAYER = FindMetaTable( "Player" )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireSDKBullets
end

function SWEP:UpdateBurstShotTable( tbl, bSecondary )
	tbl.ShootAngles = self:GetShootAngles( bSecondary )
	tbl.Src = self:GetShootSrc( bSecondary )
end

function SWEP:GetShotTable( bSecondary )
	return {
		AmmoType = bSecondary and not self.CheckClip1ForSecondary
			and self:GetSecondaryAmmoName() or self:GetPrimaryAmmoName(),
		Damage = self:GetSpecialKey( "Damage", bSecondary ),
		Distance = self:GetSpecialKey( "Range", bSecondary ),
		--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
		Num = self:GetSpecialKey( "Bullets", bSecondary ),
		Penetration = self.Penetration,
		RangeModifier = self:GetSpecialKey( "RangeModifier", bSecondary ),
		ShootAngles = self:GetShootAngles( bSecondary ),
		Spread = self:GetSpecialKey( "Spread", bSecondary ),
		SpreadBias = self:GetSpecialKey( "SpreadBias", bSecondary ),
		Src = self:GetShootSrc( bSecondary ),
		Tracer = self:GetSpecialKey( "TracerFreq", bSecondary ),
		TracerName = self:GetSpecialKey( "TracerName", bSecondary, true )
	}
end

-- No muzzle flash!
function SWEP:DoMuzzleFlash()
end
