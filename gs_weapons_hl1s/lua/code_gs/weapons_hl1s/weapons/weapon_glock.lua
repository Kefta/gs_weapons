SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_9mmhandgun.mdl"
SWEP.WorldModel = "models/w_9mmhandgun.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 10

SWEP.Activities = {
	shoot_empty = ACT_GLOCK_SHOOTEMPTY,
	altfire = {
		ACT_VM_PRIMARYATTACK,
		idle = {10, 15} -- FIXME: Is this right?
	},
	reload_empty = ACT_GLOCK_SHOOT_RELOAD
}

SWEP.Sounds = {
	-- The CS:S glock scape has higher priority, so we need to redefine HL1's
	shoot = {
		name = "HL_Weapon_Glock.Single",
		level = SNDLEVEL_GUNFIRE,
		pitch = {95, 105},
		sound = "weapons/pl_gun3.wav"
	},
	altfire = "HL_Weapon_Glock.Single"
}

SWEP.Primary.Ammo = "9mmRound"
SWEP.Primary.ClipSize = 17
SWEP.Primary.DefaultClip = 34
SWEP.Primary.Cooldown = 0.3
SWEP.Primary.Spread = Vector(0.01, 0.01)
SWEP.Primary.PunchAngle = Angle(-2, 0, 0)

SWEP.Secondary.Cooldown = 0.2
SWEP.Secondary.Spread = Vector(0.1, 0.1)

SWEP.CheckClip1ForSecondary = true

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack(0)) then
		self:Shoot(false, 0)
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack(0)) then
		self:Shoot(true, 0)
		
		return true
	end
	
	return false
end
