SWEP.Base = "weapon_cs_base"

SWEP.PrintName = "CSBase_Gun"

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Rifle"
}

SWEP.Primary.RangeModifier = 0.98 -- Damage decay over the shot range
SWEP.Primary.TracerFreq = 0

SWEP.Secondary.RangeModifier = -1

SWEP.Penetration = 1

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	self.FireFunction = PLAYER.FireCSSBullets
	
	BaseClass.Initialize(self)
end

function SWEP:GetShootInfo(bSecondary)
	local tbl = BaseClass.GetShootInfo(self, bSecondary)
	tbl.RangeModifier = self:GetSpecialKey("RangeModifier", bSecondary)
	
	return tbl
end
