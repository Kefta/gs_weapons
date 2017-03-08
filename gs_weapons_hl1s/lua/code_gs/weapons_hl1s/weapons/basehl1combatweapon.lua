SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "HLBase"
SWEP.Author = "code_gs & Valve"

// Make weapons easier to pick up in MP.
-- FIXME: Convert these to multiplayer versions
SWEP.TriggerBoundSize = game.SinglePlayer() and 24 or 36

SWEP.Sounds = {
	empty = "Weapons.Empty"
}

SWEP.Primary.Damage = 0 -- Damage is handled by the ammo
SWEP.Primary.PunchAngle = vector_origin
SWEP.Primary.ReloadOnEmptyFire = true

SWEP.Secondary.PunchAngle = SWEP.Primary.PunchAngle

if (CLIENT) then
	SWEP.ViewModelFOV = 90
	
	SWEP.BobStyle = "hls"
	SWEP.CrosshairStyle = "hl1s"
end

local PLAYER = FindMetaTable("Player")

function SWEP:Initialize()
	BaseClass.Initialize(self)
	
	self.FireFunction = PLAYER.FireLuaBullets
end

function SWEP:Punch(bSecondary --[[= false]], iIndex --[[= 0]])
	self:GetOwner():ViewPunch(self:GetSpecialKey("PunchAngle", bSecondary, iIndex))
end
