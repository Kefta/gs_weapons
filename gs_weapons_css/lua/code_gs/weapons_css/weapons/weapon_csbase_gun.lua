SWEP.Base = "weapon_cs_base"

SWEP.PrintName = "CSBase_Gun"

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Rifle"
}

SWEP.Primary.TracerFreq = 0 -- No tracers
SWEP.Primary.RangeModifier = 0.98 -- Damage decay over the shot range

SWEP.Secondary.RangeModifier = SWEP.Primary.RangeModifier

SWEP.Penetration = 1

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	self.FireFunction = PLAYER.FireCSSBullets
end

function SWEP:ToggleBurst(iIndex --[[= 0]])
	BaseClass.ToggleBurst(self, iIndex)
	
	self:GetOwner():PrintMessage(HUD_PRINTCENTER, code_gs.GetPhrase(self:GetBurst(iIndex) and "gsweapons_css_toburstfire" or "gsweapons_css_fromburstfire"))
end

function SWEP:GetShootInfo(bSecondary --[[= false]], iIndex --[[= 0]])
	local tbl = BaseClass.GetShootInfo(self, bSecondary, iIndex)
	tbl.RangeModifier = self:GetSpecialKey("RangeModifier", bSecondary, iIndex)
	
	return tbl
end
