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
	primary = "Weapon_Knife.Hit",
	secondary = "Weapon_Knife.Stab",
	hit = "Weapon_Knife.HitWall",
	miss = "Weapon_Knife.Slash"
}

SWEP.Primary = {
	Damage = 15,
	Range = 48,
	Cooldown = 0.4,
	HitCooldown = 0.5,
	SmackTime = 0.1
}

SWEP.Secondary = {
	Damage = 65,
	Range = 32,
	Cooldown = 1,
	HitCooldown = 1.1,
	SmackTime = 0.2
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'j'
	SWEP.SelectionIcon = 'j'
	
	SWEP.CSSCrosshair = {
		Min = 7
	}
end

--- Knife
SWEP.FirstSwingDamage = 20
SWEP.BackMultiplier = 3
SWEP.BackMargin = 0.8
SWEP.Force = 300

--- GSBase
local phys_pushscale = GetConVar( "phys_pushscale" )
local iDamageTypeKnife = bit.bor( DMG_BULLET, DMG_NEVERGIB )
local vHeadMax = Vector( 16, 16, 18 )
local vHeadMin = -vHeadMax

function SWEP:PrimaryAttack( bStab )
	if ( not bStab and not self:CanPrimaryAttack() ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	pPlayer:SetAnimation( PLAYER_ATTACK1 )
	pPlayer:LagCompensation( true )
	
	local vForward = self:GetShootAngles():Forward()
	local vSrc = self:GetShootSrc()
	local vEnd = vSrc + vForward * self:GetRange( bStab )
	
	local tr = util.TraceLine({
		start = vSrc,
		endpos = vEnd,
		mask = MASK_SOLID,
		filter = pPlayer
	})
	
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
		local tbl = {
			start = vSrc,
			endpos = vEnd,
			mins = vHeadMin,
			maxs = vHeadMax,
			mask = MASK_SOLID,
			filter = pPlayer,
			output = tr
		}
		
		util.TraceHull( tbl )
		pEntity = tr.Entity
		
		// Calculate the point of intersection of the line (or hull) and the object we hit
		// This is and approximation of the "best" intersection
		if ( tr.Fraction ~= 1 ) then
			if ( pEntity == NULL or pEntity:IsBSPModel() ) then
				tbl.mins, tbl.maxs = pPlayer:GetHullDuck()
				util.FindHullIntersection( tbl, tr )
				pEntity = tr.Entity
			end
		end
	end
	
	local bDidHit = tr.Fraction < 1 and pEntity ~= NULL
	self:PlayActivity( bDidHit and "hit" or "miss" )
	
	if ( bDidHit ) then
		local flDamage = self:GetDamage( bStab )
		local bHitBack = false
		
		if ( bStab ) then
			if ( pEntity:IsPlayer() or pEntity:IsNPC() ) then
				local vTargetForward = pEntity:GetAngles():Forward() -- FIXME: Not correctly returning on client
				vTargetForward.z = 0
				
				local vLOS = pEntity:GetPos() - pPlayer:GetPos()
				vLOS.z = 0
				vLOS:Normalize()
				
				//Triple the damage if we are stabbing them in the back.
				if ( vLOS:Dot( vTargetForward ) > self.BackMargin ) then
					bHitBack = true
				end
			end
		end
		
		if ( bHitBack ) then
			flDamage = flDamage * self.BackMultiplier
		end
		
		local info = DamageInfo()
			info:SetAttacker( pPlayer )
			info:SetInflictor( self )
			info:SetDamage( flDamage )
			info:SetDamageType( iDamageTypeKnife )
			info:SetDamagePosition( tr.HitPos )
			info:SetReportedPosition( vSrc )
			
			--[[if ( bHitBack ) then
				-- FIXME: This doesn't work?
				info:SetDamageBonus( flDamage * self.BackMultiplier - flDamage ) -- Fix; not working?
				flDamage = flDamage * self.BackMultiplier
			end]]
			
			// Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
			-- FIXME: This is exactly how the CS:S knife calculates force, but the 1/Damage doesn't make much sense
			info:SetDamageForce( vForward * info:GetBaseDamage() * self.Force * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat() )
		pEntity:DispatchTraceAttack( info, tr, vForward )
		
		if ( not tr.HitSky ) then
			// delay the decal a bit
			self:AddEvent( "Smack", bStab and self.Secondary.SmackTime or self.Primary.SmackTime, function()
				if ( pEntity == NULL ) then
					return true
				end
				
				if ( pEntity:IsPlayer() or pEntity:IsNPC() ) then
					self:PlaySound( bStab and "secondary" or "primary" )
				else
					self:PlaySound( "hit" )
				end
				
				if ( IsFirstTimePredicted() ) then
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
					
					util.Decal( "ManhackCut", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal, true )
				end
				
				return true
			end )
		end
	else
		self:PlaySound( "miss" )
	end
	
	pPlayer:LagCompensation( false )
	
	local flPrimDelay = self:GetCooldown( bStab, bDidHit )
	local flCurTime = CurTime()
	self:SetNextPrimaryFire( flCurTime + flPrimDelay )
	self:SetNextSecondaryFire( flCurTime + (bStab and flPrimDelay or self:GetCooldown( false, true )))
	
	return true
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		return self:PrimaryAttack( true )
	end
	
	return false
end

function SWEP:GetCooldown( bStab, bHit )
	if ( bHit ) then
		return bStab and self.Secondary.HitCooldown or self.Primary.HitCooldown
	end
	
	return BaseClass.GetCooldown( self, bStab )
end
