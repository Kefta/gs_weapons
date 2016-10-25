DEFINE_BASECLASS( "hl1s_basehl1combatweapon" )

--- GSBase
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
	primary = "Weapon_357.Single"
}

SWEP.Primary = {
	Ammo = "357Round",
	ClipSize = 6,
	DefaultClip = 12,
	Automatic = false,
	Cooldown = 0.75,
	FireUnderwater = false,
	PunchAngle = Angle(-10, 0, 0),
	Spread = VECTOR_CONE_1DEGREES
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

function SWEP:CanSecondaryAttack()
	return (bMultiPlayer or sv_cheats:GetBool()) and BaseClass.CanSecondaryAttack( self )
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		self:AdvanceZoom()
		
		return true
	end
	
	return false
end

function SWEP:GetActivitySuffix( sActivity, iIndex )
	if ( sActivity == "idle" ) then
		if ( self.m_tDryFire[iIndex] and BaseClass.GetActivitySuffix( self, sActivity, iIndex ) == "empty" ) then
			return "empty"
		end
		
		random.SetSeed( self:GetOwner():GetMD5Seed() % 0x100 )
		
		if ( random.RandomFloat(0, 1) > 0.9 ) then
			return "alt"
		end
	end
	
	return BaseClass.GetActivitySuffix( self, sActivity, iIndex )
end
