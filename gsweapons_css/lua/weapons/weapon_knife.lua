DEFINE_BASECLASS( "weapon_cs_base" )

--- GSBase
SWEP.PrintName = "#CStrike_Knife"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.HoldType = "knife"

SWEP.Sounds = {
	deploy = "Weapon_Knife.Deploy",
	hit = "Weapon_Knife.Hit",
	hit_alt = "Weapon_Knife.Stab",
	hitworld = "Weapon_Knife.HitWall",
	miss = "Weapon_Knife.Slash"
}

SWEP.Primary = {
	Damage = 15,
	Range = 48,
	Cooldown = 0.4,
	HitCooldown = 0.5,
	SmackTime = 0.1,
	InitialDamage = 20,
	BackMultiplier = 1
}

SWEP.Secondary = {
	Damage = 65,
	Range = 32,
	Cooldown = 1,
	HitCooldown = 1.1,
	SmackTime = 0.2,
	InitialDamage = 65,
	BackMultiplier = 3
}

SWEP.Melee = {
	DotRange = 0.8,
	HullRadius = 1.732, -- sqrt(3)
	TestHull = Vector(16, 16, 18),
	DamageType = bit.bor( DMG_BULLET, DMG_NEVERGIB ),
	Force = 300,
	Mask = MASK_SOLID
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'j'
	SWEP.SelectionIcon = 'j'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack(0) ) then
		self:Swing( false, 0 )
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:Swing( true, 0 )
		
		return true
	end
	
	return false
end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:Swing( bSecondary, iIndex )
	local tMelee = self.Melee
	local pPlayer = self:GetOwner()
	pPlayer:LagCompensation( true )
	
	local vSrc = self:GetShootSrc()
	local vForward = self:GetShootAngles():Forward()
	local vEnd = vSrc + vForward * self:GetRange( bSecondary )
	
	local tbl = {
		start = vSrc,
		endpos = vEnd,
		mask = self.Melee.Mask,
		filter = pPlayer
	}
	local tr = util.TraceLine( tbl )
	local bMiss = tr.Fraction == 1
	
	//check for hitting glass - TODO - fix this hackiness, doesn't always line up with what FindHullIntersection returns
	--[[if ( SERVER ) then
		local glassDamage = DamageInfo()
		glassDamage:SetAttacker( pPlayer )
		glassDamage:SetInflictor( self )
		glassDamage:SetDamage( 42 )
		glassDamage:SetDamageType( iDamageTypeKnife )
		self:TraceAttackToTriggers( info, tr.StartPos, tr.HitPos, vForward )
	end]]
	
	if ( bMiss ) then
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.output = tr
		
		util.TraceHull( tbl )
		
		// Calculate the point of intersection of the line (or hull) and the object we hit
		// This is and approximation of the "best" intersection
		if ( tr.Fraction ~= 1 ) then
			if ( tr.Entity == NULL or tr.Entity:IsBSPModel() ) then
				tbl.mins, tbl.maxs = pPlayer:GetHullDuck()
				util.FindHullIntersection( tbl, tr )
				bMiss = tr.Fraction == 1 or tr.Entity == NULL
			else
				bMiss = false
			end
		end
	end
	
	pPlayer:SetAnimation( PLAYER_ATTACK1 )
	self:PlaySound( "miss", iIndex )
	local bActivity
	
	if ( bMiss ) then
		bActivity = self:PlayActivity( "miss", iIndex )
	else
		bActivity = self:PlayActivity( "hit", iIndex )
		self:Hit( bSecondary, tr, vForward, iIndex )
	end
	
	local flDelay = self:GetCooldown( bSecondary, bMiss )
	local flCurTime = CurTime()
	self:SetNextPrimaryFire( flCurTime + flDelay )
	self:SetNextSecondaryFire( flCurTime + (bSecondary and flDelay or self:GetCooldown( false, true )))
	
	self:Punch( bSecondary )
	pPlayer:LagCompensation( false )
	
	return bActivity
end

function SWEP:Hit( bSecondary, tr, vForward, iIndex )
	local pPlayer = self:GetOwner()
	local flDamage
	
	if ( bSecondary ) then
		flDamage = self:GetNextSecondaryFire() + self:GetCooldown( true, false ) < CurTime()
			and self.Secondary.InitialDamage or self:GetDamage( true )
	else
		flDamage = self:GetNextPrimaryFire() + self:GetCooldown( false, false ) < CurTime()
			and self.Primary.InitialDamage or self:GetDamage( false )
	end
	
	local pEntity = tr.Entity
	local bPlayer = pEntity:IsPlayer() or pEntity:IsNPC()
	
	if ( bPlayer ) then
		local vTargetForward = pEntity:GetAngles():Forward() -- FIXME: Not correctly returning on client
		vTargetForward.z = 0
		
		local vLOS = pEntity:GetPos() - pPlayer:GetPos()
		vLOS.z = 0
		vLOS:Normalize()
		
		//Triple the damage if we are stabbing them in the back.
		if ( vLOS:Dot( vTargetForward ) > self.Melee.DotRange ) then
			flDamage = flDamage * (bSecondary and self.Secondary.BackMultiplier or self.Primary.BackMultiplier)
		end
	end
	
	local info = DamageInfo()
		info:SetAttacker( pPlayer )
		info:SetInflictor( self )
		info:SetDamage( flDamage )
		info:SetDamageType( self.Melee.DamageType )
		info:SetDamagePosition( tr.HitPos )
		info:SetReportedPosition( tr.StartPos )
		
		// Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
		-- FIXME: This is exactly how the CS:S knife calculates force, but the 1/Damage doesn't make much sense
		info:SetDamageForce( vForward * info:GetBaseDamage() * self.Melee.Force * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat() )
	pEntity:DispatchTraceAttack( info, tr, vForward )
	
	// delay the decal a bit
	self:AddEvent( "smack", bSecondary and self.Secondary.SmackTime or self.Primary.SmackTime, function()
		--[[if ( pEntity == NULL ) then
			return true
		end]]
		
		if ( bPlayer ) then
			self:PlaySound( bSecondary and "hit_alt" or "hit", iIndex )
		else
			self:PlaySound( "hitworld", iIndex )
		end
		
		if ( IsFirstTimePredicted() and not self:DoImpactEffect( tr, self.Melee.DamageType )) then
			-- https://github.com/Facepunch/garrysmod-requests/issues/779
			--[[local data = EffectData()
				data:SetOrigin( tr.HitPos )
				data:SetStart( tr.StartPos )
				data:SetSurfaceProp( tr.SurfaceProps )
				data:SetDamageType( DMG_SLASH )
				data:SetHitBox( tr.HitBox )
				data:SetAngles( pPlayer:GetAngles() )
				data:SetFlags(0x1) // IMPACT_NODECAL
				data:SetEntity( tr.Entity )
			util.Effect( "KnifeSlash", data )]]
			
			DevMsg( 1, self:GetClass() .. " (weapon_knife) Placing decal!" )
			util.Decal( "ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal, true )
		end
		
		return true
	end )
end

function SWEP:GetCooldown( bSecondary, bMiss )
	if ( bMiss ) then
		return BaseClass.GetCooldown( self, bSecondary )
	end
	
	return bSecondary and self.Secondary.HitCooldown or self.Primary.HitCooldown
end
