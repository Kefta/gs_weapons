DEFINE_BASECLASS( "basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL1_Shotgun"
SWEP.Spawnable = true
SWEP.Slot = 3

SWEP.ViewModel = "models/v_shotgun.mdl"
SWEP.ViewModelFOV = 90
SWEP.WorldModel = "models/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Weight = 15

SWEP.Activities = {
	reload_finish = ACT_SHOTGUN_PUMP,
	idle2 = ACT_SHOTGUN_IDLE_DEEP,
	idle3 = ACT_SHOTGUN_IDLE4
}

SWEP.Sounds = {
	primary = "Weapon_Shotgun.Single",
	secondary = "Weapon_Shotgun.Double", 
	reload = "Weapon_Shotgun.Reload",
	reload_finish = "Weapon_Shotgun.Special1"
}

SWEP.Primary = {
	Ammo = "Buckshot_HL",
	ClipSize = 8,
	DefaultClip = 20,
	Bullets = game.SinglePlayer() and 6 or 4,
	Cooldown = 0.75,
	InterruptReload = true,
	PunchAngle = Angle(-5, 0, 0),
	Spread = game.SinglePlayer() and VECTOR_CONE_10DEGREES or Vector( 0.08716, 0.04362, 0 ) // 10 degrees by 5 degrees
}

SWEP.Secondary = {
	FireUnderwater = false,
	Cooldown = 1.5,
	Bullets = game.SinglePlayer() and 12 or 8,
	InterruptReload = true,
	PunchAngle = Angle(-10, 0, 0)
}

SWEP.ReloadSingly = true
SWEP.ReloadOnEmptyFire = true
SWEP.PenaliseBothOnInvalid = true
SWEP.EmptyCooldown = 0.75

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

--- GSBase
function SWEP:PlayActivity( sActivity, iIndex, flRate )
	if ( sActivity == "idle" ) then	
		random.SetSeed( math.MD5Random( self:GetOwner():GetCurrentCommand():CommandNumber() ) % 0x100 )
		local flRand = random.RandomFloat(0, 1)
		
		return BaseClass.PlayActivity( flRand > 0.95 and "idle3" or flRand > 0.8 and sActivity or "idle2", iIndex, flRate )
	end
	
	return BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
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
	
	if ( iClip == 0 ) then
		self:HandleFireOnEmpty( true )
		
		return false
	end
	
	if ( iClip == 1 ) then
		self:Reload()
		
		return false
	end
	
	if ( not self.Secondary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( true )
		
		return false
	end
	
	local flCurTime = CurTime()
	local flNextReload = self:GetNextReload()
	
	if ( flNextReload == -1 or flNextReload > flCurTime ) then
		if ( self.Secondary.InterruptReload ) then
			self:SetNextReload( flCurTime )
			self:RemoveEvent( "Reload" )
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
		
		--self:PlaySound( "primary" )
		
		return true
	end
	
	return false
end
