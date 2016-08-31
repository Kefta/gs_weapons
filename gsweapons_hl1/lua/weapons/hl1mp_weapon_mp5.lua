DEFINE_BASECLASS( "basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL_MP5"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/v_9mmAR.mdl"
SWEP.ViewModelFOV = 90
SWEP.WorldModel = "models/w_9mmAR.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 15

SWEP.Sounds = {
	primary = "Weapon_MP5.Single",
	secondary = "Weapon_MP5.Double",
	empty = "Weapons.Empty"
}

SWEP.Primary = {
	Ammo = "9mmRound",
	ClipSize = 50,
	DefaultClip = 75,
	Cooldown = 0.1
}

SWEP.Secondary = {
	Ammo = "MP5_Grenade",
	DefaultClip = 2,
	Cooldown = 1
}

SWEP.PenaliseBothOnInvalid = true
SWEP.EmptyCooldown = 0.15

if ( CLIENT ) then
	SWEP.Category = "Half-Life 1"
end

--- MP5
SWEP.Spread = game.SinglePlayer() and VECTOR_CONE_3DEGREES or VECTOR_CONE_6DEGREES
SWEP.GrenadePunchAngle = Angle(-10, 0, 0)

SWEP.PunchBounds = {
	Min = -2,
	Max = 2
}

--- GSBase
function SWEP:Precache()
	BaseClass.Precache( self )
	
	util.PrecacheModel( "models/grenade.mdl" )
end

function SWEP:PlayIdle()
	local bRet = self:PlayActivity( "idle" )
	
	if ( bRet ) then
		-- We need to re-seed since Think runs clientside in single-player
		random.SetSeed( math.MD5Random( self:GetOwner():GetCurrentCommand():CommandNumber() ) % 0x100 )
		self:SetNextIdle( CurTime() + random.RandomFloat(3, 5) )
	end
	
	return bRet
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		local pPlayer = self:GetOwner()
		
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage(),
			Dir = self:GetShootAngles():Forward(),
			Distance = self:GetRange(),
			Spread = self.Spread,
			Src = self:GetShootSrc(),
			TracerFreq = 2
		})
		
		self:SetNextSecondaryFire(0)
		
		-- Random seed is already set from ShootBullets
		self:SetNextIdle( CurTime() + random.RandomFloat(10, 15) )
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		self:PlayActivity( "secondary" )
		self:PlaySound( "secondary" )
		self:DoMuzzleFlash()
		
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		pPlayer:ViewPunch( self.GrenadePunchAngle )
		pPlayer:RemoveAmmo( 1, self:GetSecondaryAmmoName() )
		
		local flNextTime = CurTime()
		self:SetNextIdle( flNextTime + 5 )
		
		flNextTime = flNextTime + self:GetCooldown( true )
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
		
		if ( SERVER ) then
			local pGrenade = ents.Create( "grenade_mp5" )
			pGrenade:SetPos( self:GetShootSrc() )
			local vThrow = self:GetShootAngles():Forward() * 800
			pGrenade:SetAngles( vThrow:Angle() )
			pGrenade:_SetAbsVelocity( vThrow )
			pGrenade:SetOwner( pPlayer )
			
			-- Don't need to set the seed here since it's serverside only
			pGrenade:SetLocalAngularVelocity( Angle( random.RandomFloat(-100, -500), 0, 0 ))
			pGrenade:Spawn()
			pGrenade:SetMoveType( MOVETYPE_FLYGRAVITY )
		end
	end
end

function SWEP:Punch()
	local tBounds = self.PunchBounds
	self:GetOwner():ViewPunch( Angle( random.RandomFloat( tBounds.Min, tBounds.Max ), 0, 0 ))
end
