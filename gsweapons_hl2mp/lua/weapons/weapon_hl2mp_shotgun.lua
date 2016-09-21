DEFINE_BASECLASS( "weapon_hl2mp_base" )

--- GSBase
SWEP.PrintName = "#HL2_Shotgun"
SWEP.Spawnable = true
SWEP.Slot = 3

SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Weight = 4

SWEP.Activities = {
	pump = ACT_SHOTGUN_PUMP
}

SWEP.Sounds = {
	empty = "Weapon_Shotgun.Empty",
	reload = "Weapon_Shotgun.Reload",
	primary = "Weapon_Shotgun.Single",
	secondary = "Weapon_Shotgun.Double",
	pump = "Weapon_Shotgun.Special"
}

SWEP.Primary = {
	Ammo = "Buckshot",
	ClipSize = 6,
	DefaultClip = 14,
	Bullets = 7,
	Damage = 9,
	Spread = VECTOR_CONE_10DEGREES
}

SWEP.Secondary = {
	Bullets = 14,
	FireUnderwater = false,
	Cooldown = 0.15
}

SWEP.SingleReload = {
	Enabled = true
}

SWEP.ReloadOnEmptyFire = true

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = 'b'
	SWEP.SelectionIcon = 'b'
end

--- GSBase
function SWEP:SharedDeploy( bDelayed )
	BaseClass.SharedDeploy( self, bDelayed )
	
	self:SetBodygroup(1, 1)
end

-- StartReload
function SWEP:CanReload()
	if ( BaseClass.CanReload( self )) then
		// Make shotgun shell visible
		self:SetBodygroup(0, 1)
		
		return true
	end
	
	return false
end

function SWEP:FinishReload()
	// Make shotgun shell invisible
	self:SetBodygroup(1, 1)
end

function SWEP:CanSecondaryAttack()
	if ( self:GetNextSecondaryFire() == -1 ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return false
	end
	
	local iClip = self:Clip1()
	
	if ( iClip == 1 ) then
		self:PrimaryAttack()
		
		return false
	end
	
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip1() ~= -1 and pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( true )
		
		return false
	end
	
	if ( not self.Secondary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( true )
		
		return false
	end
	
	if ( self:EventActive( "reload" )) then
		if ( self.Secondary.InterruptReload ) then
			self:SetNextReload( CurTime() - 0.1 )
			self:RemoveEvent( "reload" )
		elseif ( self.SingleReload.Enabled and self.SingleReload.QueuedFire ) then
			self:RemoveEvent( "reload" )
			local flNextTime = self:SequenceLength()
			
			self:AddEvent( "fire", flNextTime, function()
				self:SecondaryAttack()
				
				return true
			end )
			
			flNextTime = CurTime() + flNextTime + 0.1
			self:SetNextPrimaryFire( flNextTime )
			self:SetNextSecondaryFire( flNextTime )
			self:SetNextReload( flNextTime )
			
			return false
		else
			return false
		end
	end
	
	return true
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage( true ),
			Dir = self:GetShootAngles():Forward(),
			Distance = self:GetRange( true ),
			Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
			Num = self:GetBulletCount( true ),
			Spread = self:GetSpread( true ),
			Src = self:GetShootSrc(),
			TracerFreq = self.TracerFreq
		}, true, 2 )
		
		return true
	end
	
	return false
end

function SWEP:ShootBullets( tbl --[[{}]], bSecondary --[[= false]], iClipDeduction --[[= 1]] )
	BaseClass.ShootBullets( self, tbl, bSecondary, iClipDeduction )
	
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	
	-- Pump it up
	self:AddEvent( "pump", self:SequenceLength(), function() 
		self:PlaySound( "pump" )
		self:PlayActivity( "pump" )
		
		-- Cooldown is sequence based
		local flNextTime = CurTime() + self:SequenceLength()
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
		
		return true
	end )
	
	-- If the reload was interrupted
	self:SetBodygroup(1, 1)
end

function SWEP:Punch( bSecondary )
	local pPlayer = self:GetOwner()
	pPlayer:ViewPunch( bSecondary and Angle( pPlayer:SharedRandomFloat( "shotgunsax", -5, 5 ), 0, 0 )
		or Angle( pPlayer:SharedRandomFloat( "shotgunpax", -2, -1 ),
		pPlayer:SharedRandomFloat( "shotgunpay", -2, 2 ), 0 ))
end
