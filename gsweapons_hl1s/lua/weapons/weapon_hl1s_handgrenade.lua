SWEP.Base = "hl1s_basehl1combatweapon"

SWEP.PrintName = "#HL1_HandGrenade"
SWEP.Slot = 4

SWEP.HoldType = "grenade"
SWEP.Weight = 2

SWEP.Activities = {
	idle = {
		ACT_VM_IDLE,
		idle = {10, 15}
	},
	idle_alt = ACT_VM_FIDGET,
	pullback = ACT_VM_PRIMARYATTACK,
	throw = ACT_INVALID, -- Disable default throw anim
	throw1 = ACT_HANDGRENADE_THROW1,
	throw2 = ACT_HANDGRENADE_THROW2,
	throw3 = ACT_HANDGRENADE_THROW3
}

SWEP.Primary = {
	DefaultClip = 1,
	Automatic = false
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
else
	SWEP.Grenade = {
		--Delay = 0.5,
		Class = "grenade_hand",
		Timer = 1.5,
		Damage = 150,
		Radius = 375,
		Angle = Angle(0, 0, 60),
		Gravity = 400,
		Friction = 0.8
	}
end

function SWEP:PrimaryAttack()
	if ( not self:CanPrimaryAttack(0) ) then
		return false
	end
	
	self:Throw( GRENADE_THROW, 0 )
	
	return true
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:GetActivitySuffix( sActivity, iIndex )
	local sSuffix = BaseClass.GetActivitySuffix( self, sActivity, iIndex )
	
	if ( sActivity == "idle" ) then
		if ( self.m_tDryFire[iIndex] and sSuffix == "empty" ) then
			return sSuffix
		end
		
		gsrand:SetSeed( pPlayer:GetMD5Seed() % 0x100 )
		
		if ( gsrand:RandomFloat(0, 1) > 0.75 ) then
			return "alt"
		end
	end
	
	return sSuffix
end

local flThrowUp = 8/9
local flThrowDown = 10/9

function SWEP:EmitGrenade()
	local pPlayer = self:GetOwner()
	local aThrow = pPlayer:EyeAngles()
	
	// player is pitching up
	aThrow.p = aThrow.p > 180 and -15 - (360 - aThrow.p) * flThrowUp
		// player is pitching down
		or -15 + aThrow.p * flThrowDown
	
	local flVel = (90 - aThrow.p) * 4
	
	-- Set activity based on the throw velocity
	-- HL1 actually clamped the velocity before checking here
	-- So the other animations were never played
	if ( flVel < 500 ) then
		self:PlayActivity( "throw1" )
	elseif ( flVel < 1000 ) then
		self:PlayActivity( "throw2" )
	else
		self:PlayActivity( "throw3" )
	end
	
	if ( SERVER ) then
		--[[local vForward = aThrow:Forward()
		-- Fix
		local pGrenade = ents.Create( self.Entity )
		pGrenade:SetPos( pPlayer:EyePos() + vForward * 16 )
		pGrenade:_SetAbsVelocity( vForward * (flVel > 500 and 500 or flVel) + pPlayer:_GetAbsVelocity() )
		pGrenade:ApplyLocalAngularVelocityImpulse( Vector( gsrand:RandomInt(-1200, 1200), 0, 600 ))
		pGrenade:Spawn()
		pGrenade:SetOwner( pPlayer )
		pGrenade:StartDetonation( tGrenade.Timer )]]
		
		return NULL
	end
end
