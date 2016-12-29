SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "HLBase"
SWEP.Author = "code_gs & Valve"

// Make weapons easier to pick up in MP.
SWEP.TriggerBoundSize = game.SinglePlayer() and 24 or 36

SWEP.Sounds = {
	empty = "Weapons.Empty"
}

SWEP.Primary.Damage = 0 -- Damage is handled by the ammo
SWEP.Primary.ReloadOnEmptyFire = true
SWEP.Primary.PunchAngle = vector_origin

SWEP.Secondary.PunchAngle = -1

if (CLIENT) then
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl1s"
	
	SWEP.ViewModelFOV = 90
end

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	self.FireFunction = PLAYER.FireLuaBullets
end

function SWEP:Punch(bSecondary)
	self:GetOwner():ViewPunch(self:GetSpecialKey("PunchAngle", bSecondary))
end
