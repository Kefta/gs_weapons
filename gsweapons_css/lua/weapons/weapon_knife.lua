SWEP.Base = "weapon_cs_base"

SWEP.PrintName = "#CStrike_Knife"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.HoldType = "knife"

SWEP.Sounds = {
	draw = "Weapon_Knife.Deploy",
	hit = "Weapon_Knife.Hit",
	stab = "Weapon_Knife.Stab",
	hitworld = "Weapon_Knife.HitWall",
	miss = "Weapon_Knife.Slash"
}

SWEP.Primary = {
	Damage = 15,
	Range = 48,
	Cooldown = 0.4,
	HitCooldown = 0.5,
	SmackTime = 0.1,
	InitialDamage = 20
}

SWEP.Secondary = {
	Damage = 65,
	Range = 32,
	Cooldown = 1,
	HitCooldown = 1.1,
	SmackTime = 0.2,
	InitialDamage = 65
}

SWEP.Melee = {
	DotRange = 0.8,
	TestHull = Vector(16, 16, 18),
	DamageType = bit.bor( DMG_BULLET, DMG_NEVERGIB ),
	Mask = MASK_SOLID,
	ForceScale = 300,
	BackMultiplier = 3
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'j'
	SWEP.SelectionIcon = 'j'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
	
	SWEP.ViewModelFlip = false
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack(0) ) then
		return self:Swing( false )
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		return self:Swing( true )
	end
	
	return false
end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:Swing( bStab, iIndex )
	local pPlayer = self:GetOwner()
	pPlayer:LagCompensation( true )
	
	local tMelee = self.Melee
	local vForward = self:GetShootAngles( bStab ):Forward()
	local vSrc = self:GetShootSrc( bStab )
	local vEnd = vSrc + vForward * self:GetSpecialKey( "Range", bStab )
	local tbl = {
		start = vSrc,
		endpos = vEnd,
		mask = tMelee.Mask,
		filter = pPlayer
	}
	local tr = util.TraceLine( tbl )
	
	//check for hitting glass - TODO - fix this hackiness, doesn't always line up with what FindHullIntersection returns
	--[[if ( SERVER ) then
		local glassDamage = DamageInfo()
		glassDamage:SetAttacker( pPlayer )
		glassDamage:SetInflictor( self )
		glassDamage:SetDamage( 42 )
		glassDamage:SetDamageType( iDamageTypeKnife )
		self:TraceAttackToTriggers( info, tr.StartPos, tr.HitPos, vForward )
	end]]
	
	local pEntity = tr.Entity
	
	if ( tr.Fraction == 1 ) then
		tbl.maxs = self.Melee.TestHull
		tbl.mins = -tbl.maxs
		tbl.output = tr
		
		util.TraceHull( tbl )
		pEntity = tr.Entity
		
		// Calculate the point of intersection of the line (or hull) and the object we hit
		// This is and approximation of the "best" intersection
		if ( tr.Fraction ~= 1 and (pEntity == NULL or pEntity:IsBSPModel()) ) then
			tbl.mins, tbl.maxs = pPlayer:GetHullDuck()
			util.FindHullIntersection( tbl, tr )
			pEntity = tr.Entity
		end
	end
	
	pPlayer:SetAnimation( PLAYER_ATTACK1 )
	
	local bDidHit = tr.Fraction < 1 and pEntity ~= NULL
	local flPrimDelay = self:GetSpecialKey( "Cooldown", bStab )
	local flCurTime = CurTime()
	
	if ( bDidHit ) then
		local flDamage = self:GetSpecialKey( ((bStab and self:GetNextSecondaryFire() or self:GetNextPrimaryFire()) 
			+ flPrimDelay < flCurTime) and "InitialDamage" or "Damage", bStab )
		flPrimDelay = self:GetSpecialKey( "HitCooldown", bStab )
		
		if ( bStab ) then
			if ( pEntity:IsPlayer() or pEntity:IsNPC() ) then
				local vTargetForward = pEntity:GetAngles():Forward() -- FIXME: Not correctly returning on client
				vTargetForward.z = 0
				
				local vLOS = pEntity:GetPos() - pPlayer:GetPos()
				vLOS.z = 0
				vLOS:Normalize()
				
				//Triple the damage if we are stabbing them in the back.
				if ( vLOS:Dot( vTargetForward ) > tMelee.DotRange ) then
					flDamage = flDamage * tMelee.BackMultiplier
				end
			end
		end
		
		local info = DamageInfo()
			info:SetAttacker( pPlayer )
			info:SetInflictor( self )
			info:SetDamage( flDamage )
			info:SetDamageType( tMelee.DamageType )
			info:SetDamagePosition( tr.HitPos )
			info:SetReportedPosition( vSrc )
			
			--[[if ( bHitBack ) then
				-- FIXME: This doesn't work?
				info:SetDamageBonus( flDamage * self.BackMultiplier - flDamage ) -- Fix; not working?
				flDamage = flDamage * self.BackMultiplier
			end]]
			
			// Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
			-- FIXME: This is exactly how the CS:S knife calculates force, but the 1/Damage doesn't make much sense
			info:SetDamageForce( vForward * info:GetBaseDamage() * tMelee.ForceScale * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat() )
		pEntity:DispatchTraceAttack( info, tr, vForward )
		
		if ( not tr.HitSky ) then
			// delay the decal a bit
			self:AddEvent( "smack", self:GetSpecialKey( "SmackTime", bStab ), function()
				if ( pEntity == NULL ) then
					return true
				end
				
				if ( pEntity:IsPlayer() or pEntity:IsNPC() ) then
					self:PlaySound( bStab and "stab" or "hit", 0 )
				else
					self:PlaySound( "hitworld", 0 )
				end
				
				if ( not self:DoImpactEffect( tr, tMelee.DamageType ) and IsFirstTimePredicted() ) then
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
					
					DevMsg( 3, self:GetClass() .. " (weapon_knife) Placing decal!" )
					util.Decal( "ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal, true )
				end
				
				return true
			end )
		end
	else
		self:PlaySound( "miss" )
	end
	
	self:SetNextPrimaryFire( flCurTime + flPrimDelay )
	self:SetNextSecondaryFire( flCurTime + ((bStab or bDidHit) and flPrimDelay or self:GetSpecialKey( "Cooldown", false )))
	
	pPlayer:LagCompensation( false )
	
	return self:PlayActivity( bDidHit and "hit" or "miss", 0 )
end
