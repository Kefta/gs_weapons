SWEP.Base = "hl1s_basehl1combatweapon"

SWEP.PrintName = "#HL1_357"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_357.mdl"
SWEP.WorldModel = "models/w_357.mdl"
SWEP.HoldType = "revolver"
SWEP.Weight = 15

SWEP.Activities = {
	idle_alt = ACT_VM_FIDGET
}

SWEP.Sounds = {
	shoot = "Weapon_357.Single"
}

SWEP.Primary = {
	Ammo = "357Round",
	ClipSize = 6,
	DefaultClip = 12,
	Automatic = false,
	Cooldown = 0.75,
	FireUnderwater = false,
	Spread = VECTOR_CONE_1DEGREES,
	PunchAngle = Angle(-10, 0, 0)
}

SWEP.Zoom = {
	FOV = {
		40
	},
	Times = {
		[0] = 0,
		0
	},
	Cooldown = 0.5,
	HideViewModel = true
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

local sv_cheats = GetConVar( "sv_cheats" )
local bMultiPlayer = not game.SinglePlayer()
local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:CanSecondaryAttack()
	return (bMultiPlayer or sv_cheats:GetBool()) and BaseClass.CanSecondaryAttack( self )
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		self:AdvanceZoom(0)
		
		return true
	end
	
	return false
end

function SWEP:GetActivitySuffix( sActivity, iIndex )
	local sSuffix = BaseClass.GetActivitySuffix( self, sActivity, iIndex )
	
	if ( sActivity == "idle" ) then
		if ( self.m_tDryFire[iIndex] and sSuffix == "empty" ) then
			return sSuffix
		end
		
		gsrand:SetSeed( self:GetOwner():GetMD5Seed() % 0x100 )
		
		if ( gsrand:RandomFloat(0, 1) > 0.9 ) then
			return "alt"
		end
	end
	
	return sSuffix
end
