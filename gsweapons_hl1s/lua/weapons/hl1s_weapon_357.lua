DEFINE_BASECLASS( "basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL1_357"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_357.mdl"
SWEP.WorldModel = "models/w_357.mdl"
SWEP.HoldType = "revolver"
SWEP.Weight = 15

SWEP.Activities = {
	idle2 = ACT_VM_FIDGET
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

SWEP.SpecialType = SPECIAL_ZOOM

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

local sv_cheats = GetConVar( "sv_cheats" )
local bMultiPlayer = not game.SinglePlayer()

function SWEP:CanSecondaryAttack()
	return (bMultiPlayer or sv_cheats:GetBool()) and BaseClass.CanSecondaryAttack( self )
end

function SWEP:PlayActivity( sActivity, iIndex, flRate )
	if ( sActivity == "idle" ) then
		random.SetSeed( math.MD5Random( self:GetOwner():GetCurrentCommand():CommandNumber() ) % 0x100 )
	
		return BaseClass.PlayActivity( self, random.RandomFloat(0, 1) > 0.9 and "idle2" or sActivity, iIndex, flRate )
	end
	
	return BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
end
