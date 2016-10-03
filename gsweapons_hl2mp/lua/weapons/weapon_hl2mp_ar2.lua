DEFINE_BASECLASS( "weapon_hl2mp_machinegun" )

--- GSBase
SWEP.PrintName = "#HL2MP_Pulse_Rifle"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"

SWEP.Weight = 5

SWEP.Activities = {
	empty = ACT_VM_DRYFIRE,
	charge = ACT_VM_FIDGET
}

SWEP.Sounds = {
	reload = "Weapon_AR2.Reload",
	empty = "Weapon_IRifle.Empty",
	primary = "Weapon_AR2.Single",
	secondary = "Weapon_IRifle.Single",
	charge = "Weapon_CombineGuard.Special1"
}

SWEP.Primary = {
	Ammo = "AR2",
	ClipSize = 30,
	DefaultClip = 90,
	Cooldown = 0.1,
	Damage = 11,
	Spread = VECTOR_CONE_3DEGREES,
	FireUnderwater = false
}

SWEP.Secondary = {
	Ammo = "AR2AltFire",
	DefaultClip = 2, -- Fix
	Cooldown = 1,
	FireUnderwater = false
}

SWEP.TracerName = "AR2Tracer"

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = '2'
	SWEP.SelectionIcon = 'l'
end

--- HL2MPBase_MachineGun
SWEP.PunchAngle = {
	VerticalKick = 8,
	SlideLimit = 5
}

--- AR2
SWEP.SecondaryClass = "prop_combine_ball"

function SWEP:ItemFrame()
	BaseClass.ItemFrame( self )
	
	local pViewModel = self:GetOwner():GetViewModel()
	
	if ( pViewModel ~= NULL ) then
		-- Fix; replace all Lerps, Remaps, Clamps, maxs, and mins
		pViewModel:SetPoseParameter( "VentPoses", math.Remap( self.dt.ShotsFired, 0, 5, 0, 1 ))
	end
end

function SWEP:SecondaryAttack()
	if ( not self:CanSecondaryAttack() ) then
		return false
	end
	
	self:PlaySound( "charge" )
	self:PlayActivity( "charge" )
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	
	local flCooldown = self:GetCooldown( true ) / 2
	
	self:AddEvent( "charge", flCooldown, function()
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		pPlayer:RemoveAmmo( 1, self:GetSecondaryAmmoName() )
		
		// Register a muzzleflash for the AI
		self:DoMuzzleFlash()
		self:PlaySound( "secondary" )
		self:PlayActivity( "secondary" )
		self:Punch( true )
		
		local flNextTime = CurTime() + flCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime + flCooldown )
		self:SetNextReload( flNextTime )
		
		if ( SERVER ) then
			pPlayer:ScreenFade( SCREENFADE.IN, color_white, 0.1, 0 )
			
			// Create the grenade
			local pBall = ents.Create( self.SecondaryClass )
			
			if ( pBall ~= NULL ) then
				pBall:SetPos( self:GetShootSrc() )
				pBall:_SetAbsVelocity( self:GetShootAngles():Forward() * 1000 )
				pBall:SetOwner( pPlayer )
				pBall:Spawn()
				pBall:EmitSound( "NPC_CombineBall.Launch" )
				
				local pPhysObj = pBall:GetPhysicsObject()
				
				if ( pPhysObj ~= NULL ) then
					pPhysObj:AddGameFlag( FVPHYSICS_WAS_THROWN )
				end
			end
		end
		
		return true
	end )
	
	return true
end

function SWEP:Punch( bSecondary )
	if ( bSecondary ) then
		local pPlayer = self:GetOwner()
		--[[local aPunch = pPlayer:GetLocalAngles()
		
		aPunch.x = aPunch.x + random.RandomInt(-4, 4)
		aPunch.y = aPunch.y + random.RandomInt(-4, 4)
		aPunch.z = 0
		
		pPlayer:SetEyeAngles( aPunch )]]
		
		-- Yes, the min/max are out of order on the pitch in the original weapon, too
		pPlayer:ViewPunch( Angle( pPlayer:SharedRandomInt( "ar2pax", -8, -12 ), pPlayer:SharedRandomInt( "ar2pay", 1, 2 ), 0 ))
	else
		BaseClass.Punch( self, false )
	end
end

function SWEP:DoImpactEffect( tr )
	if ( IsFirstTimePredicted() ) then
		local data = EffectData()
			data:SetOrigin( tr.HitPos + tr.HitNormal )
			data:SetNormal( tr.HitNormal )
		util.Effect( "AR2Impact", data )
	end
end
