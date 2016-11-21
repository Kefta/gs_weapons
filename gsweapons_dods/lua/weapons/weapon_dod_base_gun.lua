SWEP.Base = "weapon_dod_base"

SWEP.PrintName = "DODBase_Gun"

SWEP.Activities = {
	shoot_empty = ACT_VM_PRIMARYATTACK_EMPTY
}

SWEP.Primary.FireInAir = false
SWEP.UnderwaterCooldown = 1

SWEP.Penetration = 6

SWEP.Accuracy = {
	MovePenalty = vector_origin,
	Speed = 45/200 -- FIXME
}

local BaseClass = baseclass.Get( SWEP.Base )
local PLAYER = FindMetaTable( "Player" )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireDODBullets or PLAYER.FireCSSBullets
end

function SWEP:GetShotTable( bSecondary )
	local pPlayer = self:GetOwner()
	local tAccuracy = self.Accuracy
	
	return {
		AmmoType = bSecondary and not self.CheckClip1ForSecondary
			and self:GetSecondaryAmmoName() or self:GetPrimaryAmmoName(),
		Damage = self:GetSpecialKey( "Damage", bSecondary ),
		Distance = self:GetSpecialKey( "Range", bSecondary ),
		--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
		Num = self:GetSpecialKey( "Bullets", bSecondary ),
		Penetration = self.Penetration,
		ShootAngles = self:GetShootAngles( bSecondary ),
		Spread = pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tAccuracy.Speed) ^ 2
			and self:GetSpecialKey( "Spread", bSecondary ) + tAccuracy.MovePenalty or self:GetSpecialKey( "Spread", bSecondary ),
		SpreadBias = self:GetSpecialKey( "SpreadBias", bSecondary ),
		Src = self:GetShootSrc( bSecondary ),
		Tracer = self:GetSpecialKey( "TracerFreq", bSecondary ),
		TracerName = self:GetSpecialKey( "TracerName", bSecondary, true )
	}
end
