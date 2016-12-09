-- FIXME: Netowrk holdtype changes in single-player?
SWEP.Base = "weapon_gsrp_base"

SWEP.PrintName = "StickBase"

SWEP.ViewModel = "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.HoldType = "normal"

SWEP.Sounds = {
	swing = "Weapon_StunStick.Swing"
}

SWEP.Primary = {
	Range = 90,
	Cooldown = 0.51
}

SWEP.StickColor = color_white

if ( CLIENT ) then
	SWEP.ViewModelFOV = 62
	SWEP.DrawCrosshair = false
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.m_bUpdateSwingHoldType = false
end

function SWEP:Precache()
	BaseClass.Precache( self )
	
	util.PrecacheModel( self.StickMaterial )
	
	if ( CLIENT ) then
		CreateMaterial("darkrp/" .. self:GetClass(), "VertexLitGeneric", {
			["$basetexture"] = "models/debug/debugwhite",
			["$surfaceprop"] = "metal",
			["$envmap"] = "env_cubemap",
			["$envmaptint"] = "[ .5 .5 .5 ]",
			["$selfillum"] = 0,
			["$model"] = 1
		}):SetVector("$color2", self.StickColor:ToVector())
	end
end

function SWEP:SharedDeploy( bDelayed )
	BaseClass.SharedDeploy( self, bDelayed )
	
	self:SetMaterial( "!darkrp/" .. self:GetClass() )
	
	return true
end

function SWEP:PrimaryAttack( bSecondary )
	if ( self:CanPrimaryAttack(0) ) then
		self:GetNextPrimaryFire( CurTime()
			+ (self:Swing( false, 0 ) and self:SequenceLength(0) or self:GetSpecialKey( "Cooldown" )))
		self:SetHoldType( "melee" )
		self.m_bUpdateSwingHoldType = true
		
		return true
	end
	
	return false
end

function SWEP:SharedHolster( pSwitchingTo, bDelayed )
	BaseClass.SharedHolster( self, pSwitchingTo, bDelayed )
	
	self:SetMaterial("")
end

function SWEP:DoImpactEffect()
	return true
end

if ( SERVER or not game.SinglePlayer() ) then
	function SWEP:ItemFrame()
		if ( self.m_bUpdateSwingHoldType and self:CanIdle(0) ) then
			self:SetHoldType( self.m_sHoldType )
		end
	end
end

if ( CLIENT ) then
	function SWEP:PreDrawViewModel( pViewModel )
		for i = 9, 15 do
			pViewModel:SetSubMaterial( i, "!darkrp/" .. self:GetClass() )
		end
	end
	
	function SWEP:ViewModelDrawn( pViewModel )
		pViewModel:SetSubMaterial()
	end
end
