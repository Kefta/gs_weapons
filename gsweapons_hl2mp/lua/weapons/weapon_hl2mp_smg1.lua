DEFINE_BASECLASS( "weapon_hl2mp_machinegun" )

--- GSBase
SWEP.PrintName = "#HL2MP_SMG1"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"

SWEP.Weight = 3

SWEP.Activities = {
	primary_empty = ACT_INVALID,
	empty = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	reload = "Weapon_SMG1.Reload",
	empty = "Weapon_SMG1.Empty",
	primary = "Weapon_SMG1.Single",
	secondary = "Weapon_SMG1.Double"
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
	Cooldown = 1,
	InterruptReload = true,
	FireUnderwater = false
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = '/'
	SWEP.SelectionIcon = 'a'
end

-- FIXME: Test empty times

--- HL2MPBase_MachineGun
SWEP.PunchAngle = {
	VerticalKick = 1,
	SlideLimit = 2
}

--- SMG1
SWEP.SecondaryClass = "grenade_ar2"

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		pPlayer:RemoveAmmo( 1, self:GetSecondaryAmmoName() )
		self:PlaySound( "secondary" )
		self:PlayActivity( "secondary" )
		
		local flCooldown = self:GetCooldown( true ) / 2
		local flNextTime = CurTime() + flCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime + flCooldown )
		self:SetNextReload( flNextTime )
		
		if ( SERVER ) then
			// Create the grenade
			local pGrenade = ents.Create( self.SecondaryClass )
			
			if ( pGrenade ~= NULL ) then
				pGrenade:SetPos( self:GetShootSrc() )
				pGrenade:_SetAbsVelocity( self:GetShootAngles():Forward() * 1000 )
				pGrenade:SetOwner( pPlayer )
				pGrenade:SetLocalAngularVelocity( AngleRand( -400, 400 ))
				pGrenade:Spawn()
				pGrenade:SetMoveType( MOVETYPE_FLYGRAVITY )
				pGrenade:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE )
			end
		end
	end
end

function SWEP:HandleFireOnEmpty( bSecondary )
	BaseClass.HandleFireOnEmpty( self, bSecondary )
	
	if ( bSecondary and self.EmptyCooldown ~= -1 ) then
		local flNextTime = CurTime() + self:GetCooldown( true ) / 2
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
	end
end

function SWEP:HandleFireUnderwater( bSecondary )
	BaseClass.HandleFireUnderwater( self, bSecondary )
	
	if ( bSecondary and self.UnderwaterCooldown ~= -1 ) then
		local flNextTime = CurTime() + self:GetCooldown( true ) / 2
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
	end
end
