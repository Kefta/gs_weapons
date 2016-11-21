SWEP.Base = "weapon_hl2mp_machinegun"

SWEP.PrintName = "#HL2MP_SMG1"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"

SWEP.Weight = 3

SWEP.Activities = {
	shoot_empty = ACT_INVALID,
	empty = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	reload = "Weapon_SMG1.Reload",
	empty = "Weapon_SMG1.Empty",
	shoot = "Weapon_SMG1.Single",
	altfire = "Weapon_SMG1.Double"
}

SWEP.Primary = {
	Ammo = "SMG1",
	ClipSize = 45,
	DefaultClip = 90,
	Cooldown = 0.075, // 13.3hz
	Damage = 5,
	Spread = VECTOR_CONE_5DEGREES,
	FireUnderwater = false
}

SWEP.Secondary = {
	Ammo = "SMG1_Grenade",
	DefaultClip = 2, -- Fix
	Cooldown = 0.5,
	InterruptReload = true,
	FireUnderwater = false
}

SWEP.PunchAngle = {
	VerticalKick = 1,
	SlideLimit = 2
}

SWEP.GrenadeClass = "grenade_ar2"

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = '/'
	SWEP.SelectionIcon = 'a'
end

-- FIXME: Test empty times

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		pPlayer:RemoveAmmo( 1, self:GetSecondaryAmmoName() )
		self:PlaySound( "altfire" )
		self:PlayActivity( "altfire" )
		
		local flCooldown = self:GetSpecialKey( "Cooldown", true )
		local flNextTime = CurTime() + flCooldown
		self:SetNextPrimaryFire( flNextTime + flCooldown )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
		
		if ( SERVER ) then
			// Create the grenade
			local pGrenade = ents.Create( self.GrenadeClass )
			
			if ( pGrenade ~= NULL ) then
				pGrenade:SetPos( self:GetShootSrc( true ))
				pGrenade:_SetAbsVelocity( self:GetShootAngles( true ):Forward() * 1000 )
				pGrenade:SetOwner( pPlayer )
				pGrenade:SetLocalAngularVelocity( AngleRand( -400, 400 ))
				pGrenade:Spawn()
				pGrenade:SetMoveType( MOVETYPE_FLYGRAVITY )
				pGrenade:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE )
			end
		end
	end
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:HandleFireOnEmpty( bSecondary )
	BaseClass.HandleFireOnEmpty( self, bSecondary )
	
	if ( bSecondary and self.EmptyCooldown ~= -1 ) then
		local flNextTime = CurTime() + self:GetSpecialKey( "Cooldown", true ) * 2
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
	end
end

function SWEP:HandleFireUnderwater( bSecondary )
	BaseClass.HandleFireUnderwater( self, bSecondary )
	
	if ( bSecondary and self.UnderwaterCooldown ~= -1 ) then
		local flNextTime = CurTime() + self:GetSpecialKey( "Cooldown", true ) * 2
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
	end
end
