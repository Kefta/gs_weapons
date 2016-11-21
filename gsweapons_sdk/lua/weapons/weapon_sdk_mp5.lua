SWEP.Base = "weapon_sdk_base"

SWEP.PrintName = "#SDK_MP5"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
SWEP.HoldType = "smg"
SWEP.Weight = 25

SWEP.Activities = {
	shoot = {
		ACT_VM_PRIMARYATTACK,
		idle = 5
	}
}

SWEP.Sounds = {
	shoot = "Weapon_MP5Navy.Single"
}

SWEP.Primary = {
	ClipSize = 30,
	DefaultClip = 60,
	Damage = 26,
	Cooldown = 0.075,
	Spread = Vector(0.01, 0.01),
	SpreadAir = Vector(0.05, 0.05)
}

SWEP.EmptyCooldown = 0.2

if ( CLIENT ) then
	SWEP.Category = "Source"
	SWEP.KillIcon = 'x'
	SWEP.SelectionIcon = 'x'
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:GetSpecialKey( sKey, bSecondary, bNoConVar )
	if ( sKey == "Spread" and not self:GetOwner():OnGround() ) then
		return BaseClass.GetSpecialKey( self, "SpreadAir", bSecondary, bNoConVar )
	end
	
	return BaseClass.GetSpecialKey( self, sKey, bSecondary, bNoConVar )
end
