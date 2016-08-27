DEFINE_BASECLASS( "basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL_357"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_357.mdl"
SWEP.ViewModelFOV = 100
SWEP.WorldModel = "models/w_357.mdl"
SWEP.HoldType = "revolver"
SWEP.Weight = 15

SWEP.Activities = {
	idle2 = ACT_VM_FIDGET
}

SWEP.Sounds = {
	primary = "Weapon_357.Single",
	empty = "Weapons.Empty"
}

SWEP.Primary = {
	Ammo = "357Round",
	ClipSize = 6,
	DefaultClip = 12,
	Automatic = false,
	Cooldown = 0.75,
	FireUnderwater = false
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
	SWEP.Category = "Half-Life 1"
end

--- 357
SWEP.PunchAngle = Angle(-10, 0, 0)
SWEP.Spread = VECTOR_CONE_1DEGREES

--- GSBase
function SWEP:PlayIdle()
	random.SetSeed( self:GetOwner():GetPredictionSeed() % 0x100 )
	
	return self:PlayActivity( random.RandomFloat(0, 1) > 0.9 and "idle2" or "idle" )
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		local pPlayer = self:GetOwner()
		
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage(),
			Dir = self:GetShootAngles():Forward(),
			Distance = self:GetRange(),
			Spread = self.Spread
		})
		
		return true
	end
	
	return false
end

local sv_cheats = GetConVar( "sv_cheats" )
local bMultiPlayer = not game.SinglePlayer()

function SWEP:CanSecondaryAttack()
	return (bMultiPlayer or sv_cheats:GetBool()) and BaseClass.CanSecondaryAttack( self )
end

function SWEP:Punch()
	self:GetOwner():ViewPunch( self.PunchAngle )
end
