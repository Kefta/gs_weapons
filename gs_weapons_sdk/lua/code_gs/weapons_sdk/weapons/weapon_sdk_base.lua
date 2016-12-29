SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "SDKBase"
SWEP.Author = "code_gs & Valve"
SWEP.AdminOnly = true

SWEP.Sounds = {
	empty = "Default.ClipEmpty_Rifle"
}

SWEP.Primary.Ammo = "Bullets_SDK"
SWEP.Primary.Range = 8000
SWEP.Primary.RangeModifier = 0.85

SWEP.TracerFreq = 0

if (CLIENT) then
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

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	self.FireFunction = PLAYER.FireSDKBullets
	
	BaseClass.Initialize(self)
end

function SWEP:GetShootInfo(bSecondary)
	local tbl = BaseClass.GetShootInfo(self, bSecondary)
	tbl.RangeModifier = self:GetSpecialKey("RangeModifier", bSecondary)
	
	return tbl
end

-- No muzzle flash!
function SWEP:DoMuzzleFlash()
end
