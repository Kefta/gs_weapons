DEFINE_BASECLASS( "basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL_Shotgun"
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
	empty = "Weapons.Empty",
	reload = "Weapon_Shotgun.Reload",
	reload_finish = "Weapon_Shotgun.Special1"
}

SWEP.Primary = {
	Ammo = "Buckshot_HL",
	ClipSize = 8,
	DefaultClip = 20,
	Cooldown = 0.75,
	InterruptReload = true
}

SWEP.Secondary = {
	FireUnderwater = false,
	Cooldown = 1.5,
	InterruptReload = true
}

SWEP.ReloadSingly = true
SWEP.ReloadOnEmptyFire = true
SWEP.PenaliseBothOnInvalid = true
SWEP.EmptyCooldown = 0.75

if ( CLIENT ) then
	SWEP.Category = "Half-Life 1"
end

--- Shotgun
SWEP.Bullets = game.SinglePlayer() and 6 or 4
SWEP.Spread = game.SinglePlayer() and VECTOR_CONE_10DEGREES or Vector( 0.08716, 0.04362, 0 ) // 10 degrees by 5 degrees
SWEP.PunchAngle = Angle(-5, 0, 0)

--- GSBase
function SWEP:PlayIdle()
	random.SetSeed( math.MD5Random( self:GetOwner():GetCurrentCommand():CommandNumber() ) % 0x100 )
	local flRand = random.RandomFloat(0, 1)
	
	return self:PlayActivity( flRand > 0.95 and "idle3" or flRand > 0.8 and "idle" or "idle2" )
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		local pPlayer = self:GetOwner()
		
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage(),
			Dir = self:GetShootAngles():Forward(),
			Distance = self:GetRange(),
			Num = self.Bullets,
			Spread = self.Spread,
			Src = self:GetShootSrc(),
			TracerFreq = 2
		})
		
		-- Play sound twice!
		self:PlaySound( "primary" )
		
		return true
	end
	
	return false
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
		local pPlayer = self:GetOwner()
		
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage(),
			Dir = self:GetShootAngles():Forward(),
			Distance = self:GetRange(),
			Num = self.Bullets * 2,
			Spread = self.Spread,
			Src = self:GetShootSrc(),
			TracerFreq = 2
		}, true, 2 )
		
		self:PlaySound( "primary" )
		
		return true
	end
	
	return false
end

function SWEP:Punch( bSecondary )
	self:GetOwner():ViewPunch( bSecondary and self.PunchAngle * 2 or self.PunchAngle )
end
