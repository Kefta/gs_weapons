SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "HL2Base"
SWEP.Author = "code_gs & Valve"

SWEP.Primary.Damage = 0 -- FIXME: I think damage is managed by the ammo?
SWEP.Primary.ReloadOnEmptyFire = true

SWEP.EmptyCooldown = 0.15
SWEP.HolsterReloadTime = 3

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
