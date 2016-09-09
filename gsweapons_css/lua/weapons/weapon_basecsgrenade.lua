DEFINE_BASECLASS( "weapon_cs_base" )

--- GSBase
SWEP.PrintName = "CSBase_Grenade"
SWEP.Spawnable = false
SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

SWEP.Sounds = {
	primary = "Radio.FireInTheHole"
}

SWEP.Primary = {
	DefaultClip = 1,
	Automatic = false
}

--- CSBase_Grenade
SWEP.ThrowDelay = 0.1
SWEP.GrenadeClass = "basegrenade"
SWEP.DetonationTime = 1.5

--- GSBase
function SWEP:SetupDataTables()
	BaseClass.SetupDataTables( self )
	
	self:DTVar( "Bool", 1, "ShouldThrow" )
end

function SWEP:Holster()
	-- No escape
	local bCanHolster = BaseClass.Holster( self )
	local pPlayer = self:GetOwner()
	self:SetShouldThrow( false )
	
	if ( pPlayer == NULL or pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
		if ( SERVER ) then
			self:Remove()
		end
		
		return true
	end
	
	return bCanHolster
end

function SWEP:MouseLifted()
	if ( self:GetShouldThrow() ) then
		self:SetShouldThrow( false )
		
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		self:PlayActivity( "throw" )
		
		self:AddEvent( "Throw", self.ThrowDelay, function()
			if ( SERVER ) then
				self:Throw()
			end
			
			self:PlaySound( "primary" )
			pPlayer:RemoveAmmo( 1, self:GetPrimaryAmmoName() )
			
			return true
		end )
		
		self:AddEvent( "Reload", self:SequenceLength(), function()
			if ( self:EventActive( "Throw" )) then
				return 0
			end
			
			if ( pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
				if ( SERVER ) then
					self:Remove()
				end
			else
				self:PlayActivity( "deploy" )
				
				local flNewTime = CurTime() + self:SequenceLength()
				self:SetNextPrimaryFire( flNewTime )
				self:SetNextSecondaryFire( flNewTime )
				self:SetNextReload( flNewTime )
			end
			
			return true
		end )
	end
end

function SWEP:PrimaryAttack()
	if ( not self:CanPrimaryAttack() ) then
		return false
	end
	
	self:SetShouldThrow( true )
	self:PlayActivity( "pull" )
	
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	self:SetNextIdle(-1)
	
	return true
end

--- CSBase_Grenade
function SWEP:GetShouldThrow()
	return self.dt.ShouldThrow
end

function SWEP:SetShouldThrow( bThrow )
	self.dt.ShouldThrow = bThrow
end

if ( SERVER ) then
	local flThrowDown = 10/9
	local flThrowUp = -8/9
	local vHullMax = Vector(2, 2, 2)
	local vHullMin = -vHullMax
	
	function SWEP:Throw()
		local pPlayer = self:GetOwner()
		local aThrow = pPlayer:LocalEyeAngles()
		aThrow.p = aThrow.p < 90 and -10 + aThrow.p * flThrowDown
			or -10 + (360.0 - aThrow.p) * flThrowUp

		local vForward = aThrow:Forward()
		local flVel = (90 - aThrow.p) * 6
		local vSrc = pPlayer:EyePos()
		
		local pGrenade = ents.Create( self.GrenadeClass )
		pGrenade:SetPos( util.TraceHull( {
				start = vSrc,
				endpos = vSrc + vForward * 16,
				mins = vHullMin,
				maxs = vHullMax,
				mask = MASK_SOLID,
				filter = pPlayer
			}).HitPos )
		pGrenade:_SetAbsVelocity( vForward * (flVel > 750 and 750 or flVel) + pPlayer:_GetAbsVelocity() )
		pGrenade:ApplyLocalAngularVelocityImpulse( Vector( random.RandomInt(-1200, 1200), 0, 600 ))
		pGrenade:Spawn()
		pGrenade:SetOwner( pPlayer )
		pGrenade:StartDetonation( self.DetonationTime )
	end
end
