SWEP.Base = "weapon_dod_base"

SWEP.Primary = {
	Damage = 60,
	Cooldown = 0.4
}

SWEP.Melee = {
	DotRange = 0.95,
	HullRadius = 40,
	TestHull = Vector(16, 16, 18),
	Mask = bit.bor( MASK_SOLID, CONTENTS_HITBOX, CONTENTS_DEBRIS ),
	ForceScale = 8,
	Delay = 0.2
}

function SWEP:GetMeleeTrace( tbl, vForward, bNoMiss )
	local tr
	
	if ( tbl.output ) then
		tr = tbl.output
	else
		tr = {}
		tbl.output = tr
	end
	
	util.TraceLine( tbl )
	
	// If the exact forward trace did not hit, try a larger swept box
	if ( tr.Fraction == 1 ) then
		local tMelee = self.Melee
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.mask = MASK_SOLID
		tbl.output = tr
		
		util.TraceHull( tbl )
		
		if ( tr.Fraction ~= 1 ) then
			// Calculate the point of intersection of the line (or hull) and the object we hit
			// This is and approximation of the "best" intersection
			if ( tr.Entity == NULL or tr.Entity:IsBSPModel() ) then
				tbl.mins, tbl.maxs = pPlayer:GetHullDuck()
				util.FindHullIntersection( tbl, tr )
			end
			
			if ( not bNoMiss ) then
				// Make sure it is in front of us
				local vTarget = tr.HitPos - vSrc
				vTarget:Normalize()
				
				// if zero length, always hit
				if ( vTarget:LengthSqr() ~= 0 and vForward:Dot( vTarget ) < tMelee.DotRange ) then
					// fake that we actually missed
					tr.Fraction = 1
					tr.Entity = NULL
					tr.Hit = false
				end
			end
		end
	end
	
	return tr
end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:Swing( bSecondary, iIndex )	
	self:PlaySound( "miss", iIndex )
	
	if ( tr.Fraction ~= 1 ) then
		self:AddEvent( "hit", tMelee.Delay, function()			
			return true
		end )
	end
	
	local bActivity = self:PlayActivity( bSecondary and "miss" or "hit", iIndex )
	--pPlayer:DoAnimationEvent( PLAYERANIMEVENT_SECONDARY_ATTACK )
	
	if ( not bSecondary ) then
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
	end
	
	local flCurTime = CurTime()
	self:SetLastShootTime( flCurTime )
	
	flCurTime = flCurTime + self:GetSpecialKey( "Cooldown", bSecondary )
	self:SetNextPrimaryFire( flCurTime )
	self:SetNextSecondaryFire( flCurTime )
	
	pPlayer:LagCompensation( false )
	
	return bActivity
end

function SWEP:Smack( tr, vForward, bDelayed, bSecondary, iIndex )
	pPlayer:LagCompensation( true )
	
	local vSrc = self:GetShootSrc( bSecondary )
	local vForward = self:GetShootAngles( bSecondary ):Forward()
	
	// Check that we are still facing the victim
	tbl.start = vSrc
	tbl.endpos = vSrc + vForward * self:GetSpecialKey( "Range", bSecondary )
	tbl.mask = tMelee.Mask
	
	util.TraceLine( tbl )
	
	// If the exact forward trace did not hit, try a larger swept box
	if ( tr.Fraction == 1 ) then
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.mask = MASK_SOLID
		tbl.output = tr
		
		util.TraceHull( tbl )
		
		if ( tr.Fraction ~= 1 and (tr.Entity == NULL or tr.Entity:IsBSPModel()) ) then
			// Calculate the point of intersection of the line (or hull) and the object we hit
			// This is and approximation of the "best" intersection
			tbl.mins, tbl.maxs = pPlayer:GetHullDuck()
			util.FindHullIntersection( tbl, tr )
		end
	end
	
	if ( tr.Entity == NULL or tr.HitSky ) then
		return true
	end
	
	if ( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) then
		local data = EffectData()
			data:SetOrigin( tr.HitPos )
			data:SetStart( tr.StartPos )
			data:SetSurfaceProp( tr.SurfaceProps )
			data:SetHitBox( tr.HitBox )
			data:SetEntity( tr.Entity )
			
			if ( SERVER ) then
				data:SetEntIndex( tr.Entity:EntIndex() )
			end
			
			data:SetAngles( pPlayer:GetAngles() )
			data:SetFlags( 0x1 ) // IMPACT_NODECAL
			data:SetDamageType( tMelee.DamageType )
		util.Effect( "Impact", data )
		
		self:PlaySound( "hit", iIndex )
	else
		DevMsg( 3, self:GetClass() .. " (weapon_dod_base) Placing decal!" )
		util.Decal( "ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal, true )
		
		self:PlaySound( "hitworld", iIndex )
	end
	
	// if they hit the bounding box, just assume a chest hit
	if ( tr.HitGroup == HITGROUP_GENERIC ) then
		tr.HitGroup = HITGROUP_CHEST
	end

end

function SWEP:GetMeleeTrace( tbl, vForward, bNoMiss )
	local tr
	
	if ( tbl.output ) then
		tr = tbl.output
	else
		tr = {}
		tbl.output = tr
	end
	
	util.TraceLine( tbl )
	
	if ( tr.Fraction == 1 ) then
		local tMelee = self.Melee
		
		// hull is +/- 16, so use cuberoot of 2 to determine how big the hull is from center to the corner point
		-- Comment is wrong; it's actually the sqrt(3)
		tbl.endpos = vEnd - vForward * tMelee.HullRadius
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		
		util.TraceHull( tbl )
		
		if ( not (tr.Fraction == 1 or tr.Entity == NULL) ) then
			local vTarget = tr.Entity:GetPos() - vSrc
			vTarget:Normalize()
			
			// YWB:  Make sure they are sort of facing the guy at least...
			if ( not bNoMiss and vTarget:Dot( vForward ) < tMelee.DotRange ) then
				// Force amiss
				tr.Fraction = 1
				tr.Entity = NULL
				tr.Hit = false
				bMiss = true
			else
				util.FindHullIntersection( tbl, tr )
			end
		end
	end
	
	return tr
end

function SWEP:Swing( bSecondary, iIndex )
	local pPlayer = self:GetOwner()
	pPlayer:LagCompensation( true )
	
	local vSrc = self:GetShootSrc( bSecondary )
	local vForward = self:GetShootAngles( bSecondary ):Forward()
	local tr = self:GetMeleeTrace({
		start = vSrc,
		endpos = vSrc + vForward * self:GetSpecialKey( "Range", bSecondary ),
		mask = tMelee.Mask,
		filter = pPlayer
	})
	
	local flDelay = self:GetSpecialKey( "Delay", bSecondary, vForward )
	
	if ( flDelay == -1 ) then
		self:Smack( tr, vForward, false, bSecondary, iIndex )
	else
		self:AddEvent( "smack", flDelay, function()
			self:Smack( tr, vForward, true, bSecondary, iIndex )
			
			return true
		end )
	end
	
	if ( tr.Fraction == 1 ) then
		self:PlaySound( "miss", iIndex )
		bActivity = self:PlayActivity( bSecondary and "miss_alt" or "miss", iIndex )
	else
		if ( tMelee.AlwaysPlaySwing ) then
			self:PlaySound( "miss", iIndex )
		end
		
		bActivity = self:PlayActivity( bSecondary and "hit_alt" or "hit", iIndex )
	end
	
	// Setup out next attack times
	local flCurTime = CurTime()
	self:SetLastShootTime( flCurTime )
	self:SetNextPrimaryFire( flCurTime + self:GetSpecialKey( "Cooldown", bSecondary ))
	self:SetNextSecondaryFire( flCurTime + (bActivity and self:SequenceLength( iIndex ) or 0))
	
	pPlayer:LagCompensation( false )
	
	return bActivity
end

function SWEP:Smack( tr, vForward, bDelayed, bSecondary, iIndex )
	local tMelee = self.Melee
	local pPlayer = self:GetOwner()
	
	if ( bDelayed and not (tMelee.StrictTrace and tr.Fraction == 1) ) then
		pPlayer:LagCompensation( true )
		vForward = self:GetShootAngles( bSecondary ):Forward()
		
		self:GetMeleeTrace({
			start = vSrc,
			endpos = vSrc + vForward * self:GetSpecialKey( "Range", bSecondary ),
			mask = tMelee.Mask,
			filter = pPlayer,
			output = tr
		})
	end
	
	local bFirstTimePredicted = IsFirstTimePredicted()
	local bNoWater = true
	
	if ( bFirstTimePredicted ) then
		local bHitWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
		local bEndNotWater = bit.band( util.PointContents( tr.HitPos ), MASK_WATER ) == 0
		local trSplash
		tbl.mask = MASK_WATER
		tbl.output = nil
		
		if ( bHitWater and bEndNotWater ) then
			tbl.start = tr.HitPos
			tbl.endpos = vSrc
			trSplash = util.TraceLine( tbl )
		elseif ( not (bHitWater or bEndNotWater) ) then
			bNoWater = false
			tbl.start = vSrc
			tbl.endpos = tr.HitPos
			trSplash = util.TraceLine( tbl )
		end
		
		if ( trSplash and not self:DoSplashEffect( trSplash )) then
			local data = EffectData()
				data:SetOrigin( trSplash.HitPos )
				data:SetScale(8)
				
				if ( bit.band( util.PointContents( trSplash.HitPos ), CONTENTS_SLIME ) ~= 0 ) then
					data:SetFlags( FX_WATER_IN_SLIME )
				end
				
			util.Effect( "watersplash", data )
		end
	end
	
	// Send the anim
	pPlayer:SetAnimation( PLAYER_ATTACK1 )
		
	if ( tr.Fraction ~= 1 ) then
		self:PlaySound( (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) and "hit" or "hitworld", iIndex )
		self:Hit( tr, vForward, bSecondary, iIndex )
		
		if ( bNoWater and not self:DoImpactEffect( tr, tMelee.DamageType ) and bFirstTimePredicted ) then
			local data = EffectData()
				data:SetOrigin( tr.HitPos )
				data:SetStart( vSrc )
				data:SetSurfaceProp( tr.SurfaceProps )
				data:SetDamageType( tMelee.DamageType )
				data:SetHitBox( tr.HitBox )
				data:SetEntity( tr.Entity )
			util.Effect( "Impact", data )
		end
	end
	
	if ( bDelayed ) then
		pPlayer:LagCompensation( false )
	end
end

function SWEP:Hit( tr, vForward, bSecondary )
	local flDamage = self:GetSpecialKey( "Damage", bSecondary )
	local info = DamageInfo()
		info:SetAttacker( self:GetOwner() )
		info:SetInflictor( self )
		info:SetDamage( flDamage )
		info:SetDamageType( self.Melee.DamageType )
		info:SetDamagePosition( tr.HitPos )
		info:SetReportedPosition( tr.StartPos )
		info:SetDamageForce( vForward * info:GetBaseDamage() * self:GetSpecialKey( "Force", bSecondary ) * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat() ) -- FIXME
	tr.Entity:DispatchTraceAttack( info, tr, vForward )
end
