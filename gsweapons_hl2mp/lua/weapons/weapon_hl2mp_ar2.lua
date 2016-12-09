SWEP.Base = "weapon_hl2mp_machinegun"

SWEP.PrintName = "#HL2MP_Pulse_Rifle"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"

SWEP.Weight = 5

SWEP.Activities = {
	shoot_empty = ACT_INVALID,
	empty = ACT_VM_DRYFIRE,
	charge = ACT_VM_FIDGET
}

SWEP.Sounds = {
	reload = "Weapon_AR2.Reload",
	empty = "Weapon_IRifle.Empty",
	shoot = "Weapon_AR2.Single",
	altfire = "Weapon_IRifle.Single",
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
	Cooldown = 0.5,
	FireUnderwater = false
}

SWEP.TracerName = "AR2Tracer"

SWEP.PunchAngle = {
	VerticalKick = 8,
	SlideLimit = 5
}

SWEP.PunchRand = {
	XMin = -8,
	XMax = -12,
	YMin = 1,
	YMax = 2
}

SWEP.GrenadeClass = "prop_combine_ball"

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = '2'
	SWEP.SelectionIcon = 'l'
end

local BaseClass = baseclass.Get( SWEP.Base )

--[[function SWEP:ItemFrame()
	BaseClass.ItemFrame( self )
	
	local pViewModel = self:GetOwner():GetViewModel(0)
	
	if ( pViewModel ~= NULL ) then
		-- Fix; replace all Lerps, Remaps, Clamps, maxs, and mins
		pViewModel:SetPoseParameter( "VentPoses", math.Remap( self.dt.AnimLevel, 0, 5, 0, 1 ))
	end
end]]

function SWEP:SecondaryAttack()
	if ( not self:CanSecondaryAttack() ) then
		return false
	end
	
	self:PlaySound( "charge" )
	self:PlayActivity( "charge" )
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	
	local flCooldown = self:GetSpecialKey( "Cooldown", true )
	
	self:AddEvent( "charge", flCooldown, function()
		local pPlayer = self:GetOwner()
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		pPlayer:RemoveAmmo( 1, self:GetSecondaryAmmoName() )
		
		// Register a muzzleflash for the AI
		self:DoMuzzleFlash()
		self:PlaySound( "altfire" )
		self:PlayActivity( "altfire" )
		self:Punch( true )
		
		local flNextTime = CurTime() + flCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime + flCooldown )
		self:SetNextReload( flNextTime )
		
		if ( SERVER ) then
			pPlayer:ScreenFade( SCREENFADE.IN, color_white, 0.1, 0 )
			
			// Create the grenade
			local pBall = ents.Create( self.GrenadeClass )
			
			if ( pBall ~= NULL ) then
				pBall:SetPos( self:GetShootSrc() )
				pBall:_SetAbsVelocity( self:GetShootAngles():Forward() * 1000 )
				pBall:SetOwner( pPlayer )
				pBall:Spawn()
				pBall:EmitSound( "NPC_CombineBall.Launch" )
				
				local pPhysObj = pBall:GetPhysicsObject()
				
				if ( pPhysObj:IsValid() ) then
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
		
		aPunch.x = aPunch.x + gsrand:RandomInt(-4, 4)
		aPunch.y = aPunch.y + gsrand:RandomInt(-4, 4)
		aPunch.z = 0
		
		pPlayer:SetEyeAngles( aPunch )]]
		
		-- Yes, the min/max are out of order on the pitch in the original weapon, too
		local tPunch = self.PunchRand
		pPlayer:ViewPunch( Angle( pPlayer:SharedRandomInt( "ar2pax", tPunch.XMin, tPunch.XMax ), pPlayer:SharedRandomInt( "ar2pay", tPunch.YMin, tPunch.YMax ), 0 ))
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
