DEFINE_BASECLASS( "gs_baseentity" )

--- GSBase
ENT.PrintName = "BaseGrenade"

ENT.Sounds = {
	detonate = "BaseGrenade.Explode",
	bounce = "BaseGrenade.BounceSound"
}

--- BaseGrenade
ENT.Force = vector_origin
ENT.ThrowDamage = 1
ENT.Damage = 100
ENT.DamageRadius = 100
ENT.DetonationType = "explode"

// smaller, cube bounding box so we rest on the ground
ENT.Size = {
	Min = vector_origin,
	Max = vector_origin
}

ENT.Shake = { -- Screen shake parameters for explosions. Set Amplitude to 0 to disable
	Amplitude = 25,
	Frequency = 150,
	Duration = 1,
	Radius = 750
}

function ENT:Initialize()
	BaseClass.Initialize( self )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:AddFlags( FL_GRENADE )
	self:SetSolid( SOLID_BBOX ) // So it will collide with physics props!
	self:SetCollisionBounds( self.Size.Min, self.Size.Max )
	
	if ( SERVER ) then
		self:SetTrigger( true )
	end
end

function ENT:StartDetonation( flTime )
	self:AddEvent( "detonate", flTime, function()
		return self:Detonate()
	end )
end

function ENT:Detonate()
	return gsweapons.GetDetonationFunc( self.DetonationType )( self )
end

--[[
function ENT:Touch_Bounce( pOther )
	if ( pOther:IsSolidFlagSet( bit.bor( FSOLID_TRIGGER, FSOLID_VOLUME_CONTENTS ) ) ) then
		return
	end
	
	local vVel = self:GetAbsVelocity()
	local iLen = vVel:Length()
	
	// only do damage if we're moving fairly fast
	-- DAMAGE_NO = 0
	if ( (pOther:GetInternalVariable( "m_takedamage" ) ~= 0) and (self.m_flNextAttack < CurTime() and iLen > 100)) then
		if ( self:GetOwner() ~= NULL ) then -- Fix; should we use this behaviour or fix it to always do damage
			local info = DamageInfo()
			info:SetInflictor( self )
			info:SetAttacker( self:GetOwner() )
			info:SetDamage( self.ThrowDamage )
			info:SetDamageType( DMG_CLUB )
			info:CalculateMeleeDamageForce( vVel, self:GetPos() )
			pOther:DispatchTraceAttack( info, self:GetTouchTrace(), self:GetLocalAngles():Forward() )
		end
		
		self.m_flNextAttack = CurTime() + 1.0 // debounce
	end
	
	// this is my heuristic for modulating the grenade velocity because grenades dropped purely vertical
	// or thrown very far tend to slow down too quickly for me to always catch just by testing velocity. 
	// trimming the Z velocity a bit seems to help quite a bit.
	-- This isn't actually applied to grenades, but rather, only used to anglert the bots
	-- vVel.z = vVel.z * 0.45
	
	if ( not self:OnGround() ) then
		// play bounce sound
		self:BounceSound()
	end
	
	local flNewPlayback = iLen / 200.0
	if ( flNewPlayback > 1.0 ) then
		flNewPlayback = 1
	elseif ( flNewPlayback < 0.5 ) then
		flNewPlayback = 0
	end
	
	self:SetPlaybackRate( flNewPlayback )
end]]
