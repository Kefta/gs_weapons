DEFINE_BASECLASS( "basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL1_HandGrenade"
SWEP.Spawnable = false
SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
end

SWEP.Activities = {
	idle2 = ACT_VM_FIDGET,
	pull = ACT_VM_PRIMARYATTACK,
	throw = ACT_HANDGRENADE_THROW1,
	throw2 = ACT_HANDGRENADE_THROW2,
	throw3 = ACT_HANDGRENADE_THROW3
}

SWEP.Primary = {
	DefaultClip = 1,
	Automatic = false
}

--- CSBase_Grenade
SWEP.ThrowDelay = 0.5
SWEP.GrenadeClass = "grenade_hand"
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
		
		self:AddEvent( "Throw", self.ThrowDelay, function()
			local flVel = self:Throw()
			pPlayer:SetAnimation( PLAYER_ATTACK1 )
			pPlayer:RemoveAmmo( 1, self:GetPrimaryAmmoName() )
			self:PlaySound( "primary" )
			
			if ( flVel < 500 ) then
				self:PlayActivity( "throw" )
			elseif ( flVel < 1000 ) then
				self:PlayActivity( "throw2" )
			else
				self:PlayActivity( "throw3" )
			end
			
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
				self:SetNextIdle( flNewTime )
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

function SWEP:PlayActivity( sActivity, iIndex, flRate )
	if ( sActivity == "idle" ) then
		random.SetSeed( math.MD5Random( self:GetOwner():GetCurrentCommand():CommandNumber() ) % 0x100 )
		
		if ( random.RandomFloat(0, 1) > 0.75 ) then
			return BaseClass.PlayActivity( self, "idle2", iIndex, flRate )
		else
			local bRet = BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
			
			if ( bRet ) then
				self:SetNextIdle( CurTime() + random.RandomFloat(10, 15) ) // how long till we do this again.
			end
			
			return bRet
		end
	end
	
	return BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
end

local flThrowUp = 8/9
local flThrowDown = 10/9

--- Hand Grenade
function SWEP:Throw()
	local pPlayer = self:GetOwner()
	local aThrow = pPlayer:GetShootAngles()
	
	// player is pitching up
	aThrow.p = aThrow.p > 180 and -15 - (360 - aThrow.p) * flThrowUp
		// player is pitching down
		or -15 + aThrow.p * flThrowDown
	
	local flVel = (90 - aThrow.p) * 4
	
	if ( SERVER ) then
		local vForward = aThrow:Forward()
		-- Fix
		local pGrenade = ents.Create( self.GrenadeClass )
		pGrenade:SetPos( pPlayer:EyePos() + vForward * 16 )
		pGrenade:_SetAbsVelocity( vForward * (flVel > 500 and 500 or flVel) + pPlayer:_GetAbsVelocity() )
		--[[pGrenade:ApplyLocalAngularVelocityImpulse( Vector( random.RandomInt(-1200, 1200), 0, 600 ))
		pGrenade:Spawn()
		pGrenade:SetOwner( pPlayer )
		pGrenade:StartDetonation( self.DetonationTime )]]
	end
	
	return flVel
end

function SWEP:GetShouldThrow()
	return self.dt.ShouldThrow
end

function SWEP:SetShouldThrow( bThrow )
	self.dt.ShouldThrow = bThrow
end
