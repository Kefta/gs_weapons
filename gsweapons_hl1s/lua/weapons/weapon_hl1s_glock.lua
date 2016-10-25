DEFINE_BASECLASS( "hl1s_basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL1_Glock"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_9mmhandgun.mdl"
SWEP.WorldModel = "models/w_9mmhandgun.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 10

SWEP.Activities = {
	primary_empty = ACT_GLOCK_SHOOTEMPTY,
	secondary = {
		ACT_VM_PRIMARYATTACK,
		idle = {10, 15} -- FIXME: Is this right?
	},
	reload_empty = ACT_GLOCK_SHOOT_RELOAD
}

SWEP.Sounds = {
	-- The CS:S glock scape has higher priority, so we need to redefine HL1's
	primary = {
		name = "HL_Weapon_Glock.Single",
		level = SNDLEVEL_GUNFIRE,
		pitch = {95, 105},
		sound = "weapons/pl_gun3.wav"
	},
	secondary = "HL_Weapon_Glock.Single"
}

SWEP.Primary = {
	Ammo = "9mmRound",
	ClipSize = 17,
	DefaultClip = 34,
	Cooldown = 0.3,
	PunchAngle = Angle(-2, 0, 0),
	Spread = Vector(0.01, 0.01, 0.01)
}

SWEP.Secondary = {
	Cooldown = 0.2,
	Spread = Vector(0.1, 0.1, 0.1)
}

SWEP.UseClip1ForSecondary = true

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

--- GSBase
function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		self:Shoot( true, 0 )
		
		return true
	end
	
	return false
end
