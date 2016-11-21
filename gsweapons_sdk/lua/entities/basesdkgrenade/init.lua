include( "shared.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

--- GSBase
function ENT:ItemFrame()
	if ( self:IsInWorld() ) then
		self:SetNextItemFrame( CurTime() + 0.2 )
		
		if ( self:WaterLevel() ~= 0 ) then
			self:_SetAbsVelocity( self:_GetAbsVelocity() / 2 )
		end
	else
		self:Remove()
	end
end

function ENT:Touch( pEnt )
	if ( pEnt == self:GetOwner() ) then
		return
	end
	
	local vAbsVelocity = self:_GetAbsVelocity()
	local vBaseVelocity = self:_GetBaseVelocity()
	local iFrameTime = FrameTime()
	local vMove = (vAbsVelocity + vBaseVelocity) * iFrameTime
	
	if ( not self:IsFlagSet( FL_FLY )) then
		if ( self:IsFlagSet( FL_ONGROUND )) then
			vMove.z = vBaseVelocity.z * iFrameTime
		else
			local flAbsZ = vAbsVelocity.z
			
			// linear acceleration due to gravity
			vMove.z = ((flAbsZ + (flAbsZ - self:GetActualGravity() * iFrameTime)) / 2 + vBaseVelocity.z) * iFrameTime	
		end
	end
	
	local tr = self:PhysicsCheckSweep( self:GetPos(), vMove )
	
	// Assume all surfaces have the same elasticity
	// Don't bounce off of players with perfect elasticity
	local pEntity = tr.Entity
	local bValid = pEntity ~= NULL
	local vAbsVelocity = self:_GetAbsVelocity()
	
	// if its breakable glass and we kill it, don't bounce.
	// give some damage to the glass, and if it breaks, pass 
	// through it.
	if ( bValid and pEntity:GetClass():find( "func_breakable", 1, true )) then
		local info = DamageInfo()
			local pOwner = self:GetOwner()
			info:SetAttacker( pOwner == NULL and self or pOwner )
			info:SetInflictor( self )
			info:SetDamage( 10 )
			info:SetDamageType( DMG_CLUB )
			--info:SetDamageForce()
			local vPos = self:GetPos()
			info:SetDamagePosition( vPos )
			info:SetReportedPosition( vPos )
		pEntity:DispatchTraceAttack( info, tr, vAbsVelocity )
		
		if ( pEntity:Health() < 1 ) then
			// slow our flight a little bit
			self:_SetAbsVelocity( vAbsVelocity * 0.4 )
			
			return
		end
	end
	
	// NOTE: A backoff of 2.0f is a reflection
	vAbsVelocity = self:PhysicsClipVelocity( vAbsVelocity, tr.HitNormal, 2 ) * math.min( self:GetElasticity() * ((bValid and pEntity:IsPlayer() or pEntity:IsNPC()) and 0.3 or 1), 0.9 )
	local vBaseVelocity = self:_GetBaseVelocity()
	local vVelocity = vAbsVelocity + vBaseVelocity
	
	// Stop if on ground.
	if ( tr.Normal.z > 0.7 ) then // Floor
		// Verify that we have an entity.
		self:_SetAbsVelocity( vAbsVelocity )
		
		if ( vVelocity:Dot( vVelocity ) < 900 ) then
			if ( pEntity:Standable() ) then
				self:SetGroundEntity( pEntity )
			end
			
			// Reset velocities.
			self:_SetAbsVelocity( vector_origin )
			self:SetLocalAngularVelocity( angle_zero )
			
			//align to the ground so we're not standing on end
			local ang = tr.HitNormal:Angle()
			
			// rotate randomly in yaw
			ang.y = gsrand:RandomFloat(0, 360)
			
			// TODO: rotate around trace.plane.normal
			
			self:SetAngles( ang )
		else
			vBaseVelocity:Normalize()
			local flFracDiff = (1 - tr.Fraction) * FrameTime()
			self:PhysicsPushEntity( vAbsVelocity * flFracDiff + flFracDiff * vBaseVelocity * (vBaseVelocity - vAbsVelocity):Dot( vBaseVelocity:GetNormal() ))
		end
	else
		// If we get *too* slow, we'll stick without ever coming to rest because
		// we'll get pushed down by gravity faster than we can escape from the wall.
		if ( vVelocity:Dot( vVelocity ) < 900 ) then
			// Reset velocities
			self:_SetAbsVelocity( vector_origin )
			self:SetLocalAngularVelocity( angle_zero )
		else
			self:_SetAbsVelocity( vAbsVelocity )
		end
	end
	
	self:PlaySound( "bounce" )
end
