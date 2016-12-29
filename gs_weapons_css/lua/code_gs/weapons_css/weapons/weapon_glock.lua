SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Sounds = {
	shoot = "Weapon_Glock.Single"
}

SWEP.Activities = {
	burst = ACT_VM_SECONDARYATTACK
}

SWEP.Primary.Ammo = "9mm"
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 140
SWEP.Primary.Damage = 25
SWEP.Primary.RangeModifier = 0.75
SWEP.Primary.Spread = Vector(0.1, 0.1)
SWEP.Primary.SpreadAir = Vector(1, 1)
SWEP.Primary.SpreadMove = Vector(0.165, 0.165)
SWEP.Primary.SpreadCrouch = Vector(0.075, 0.075)

SWEP.Secondary.Cooldown = 0.3
SWEP.Secondary.Damage = 18
SWEP.Secondary.RangeModifier = 0.9
SWEP.Secondary.Spread = Vector(0.3, 0.3)
SWEP.Secondary.SpreadAir = Vector(1.2, 1.2)
SWEP.Secondary.SpreadMove = Vector(0.185, 0.185)
SWEP.Secondary.SpreadCrouch = Vector(0.095, 0.095)

SWEP.Burst = {
	SingleActivity = true
}

SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.275,
	Time = 0.325,
	Min = 0.6
}

if (CLIENT) then
	SWEP.KillIcon = 'c'
	SWEP.SelectionIcon = 'c'
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack(0)) then
		self:ToggleBurst(0)
		
		return true
	end
	
	return false
end
