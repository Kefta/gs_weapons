SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "HL2MPBase"
SWEP.Author = "code_gs & Valve"

SWEP.Primary.ReloadOnEmptyFire = true

SWEP.EmptyCooldown = 0.75

if (CLIENT) then
	SWEP.ViewModelFOV = 54
	
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl2"
end

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	self.FireFunction = PLAYER.FireLuaBullets
end
