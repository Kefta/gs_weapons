SWEP.Base = "hl1s_basehl1combatweapon"

SWEP.PrintName = "#HL1_MP5"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/v_9mmAR.mdl"
SWEP.WorldModel = "models/w_9mmAR.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 15

SWEP.Activities = {
	priamry = {
		ACT_VM_PRIMARYATTACK,
		idle = {10, 15} -- FIXME: Not working
	},
	altfire = {
		ACT_VM_SECONDARYATTACK,
		idle = 5
	},
	idle = {
		ACT_VM_IDLE,
		idle = {3, 5}
	}
}

SWEP.Sounds = {
	shoot = "Weapon_MP5.Single",
	altfire = "Weapon_MP5.Double"
}

SWEP.Primary = {
	Ammo = "9mmRound",
	ClipSize = 50,
	DefaultClip = 75,
	Cooldown = 0.1,
	Spread = game.SinglePlayer() and VECTOR_CONE_3DEGREES or VECTOR_CONE_6DEGREES
}

SWEP.Secondary = {
	Ammo = "MP5_Grenade",
	DefaultClip = 2,
	Cooldown = 1,
	PunchAngle = Angle(-10, 0, 0)
}

SWEP.EmptyCooldown = 0.15

SWEP.GrenadeClass = "grenade_mp5"

SWEP.PunchRand = {
	Min = -2,
	Max = 2
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:Precache()
	BaseClass.Precache( self )
	
	-- Secondary fire grenade model
	util.PrecacheModel( "models/grenade.mdl" )
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:DoMuzzleFlash()
		self:Punch( true )
		
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		pPlayer:RemoveAmmo( 1, self:GetSecondaryAmmoName() )
		self:PlaySound( "altfire" )
		self:PlayActivity( "altfire" )
		
		local flNextTime = CurTime() + self:GetSpecialKey( "Cooldown", true )
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
		
		if ( SERVER ) then
			local pGrenade = ents.Create( self.GrenadeClass )
			pGrenade:SetPos( self:GetShootSrc() )
			local vThrow = self:GetShootAngles():Forward() * 800
			pGrenade:SetAngles( vThrow:Angle() )
			pGrenade:_SetAbsVelocity( vThrow )
			pGrenade:SetOwner( pPlayer )
			
			-- Don't need to set the seed here since it's serverside only
			pGrenade:SetLocalAngularVelocity( Angle( gsrand:RandomFloat(-100, -500), 0, 0 ))
			pGrenade:Spawn()
			pGrenade:SetMoveType( MOVETYPE_FLYGRAVITY )
		end
	end
end

function SWEP:Shoot( bSecondary --[[= false]], iIndex --[[= 0]], sPlay, iClipDeduction --[[= 1]] )
	BaseClass.Shoot( self, bSecondary, iIndex, sPlay, iClipDeduction )
	
	self:SetNextSecondaryFire(0) -- Don't penalise secondary time
end

function SWEP:GetSpecialKey( sKey, bSecondary, bNoConVar )
	if ( not bSecondary and sKey == "PunchAngle" ) then
		local tBounds = self.PunchRand
		
		return Angle( gsrand:RandomFloat( tBounds.Min, tBounds.Max ), 0, 0 )
	end
	
	return BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar )
end
