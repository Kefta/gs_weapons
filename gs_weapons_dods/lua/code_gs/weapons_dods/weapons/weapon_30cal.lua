SWEP.Base = "weapon_dod_base_bipod"

SWEP.Spawnable = true

SWEP.Sounds = {
	reload = "Weapon_30cal.WorldReload",
	shoot = "Weapon_30cal.Shoot"
}

SWEP.ViewModel = "models/weapons/v_30cal.mdl"
SWEP.WorldModel = "models/weapons/w_30cal.mdl"
SWEP.ReloadModel = "models/weapons/w_30calsr.mdl"

SWEP.Weight = 20

SWEP.Primary.Ammo = "30cal"
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 300
SWEP.Primary.Cooldown = 0.1
SWEP.Primary.Damage = 85

local vSpread = Vector(0.2, 0.2)
local vDeploySpread = Vector(0.01, 0.01)
SWEP.Primary.Spread = function(self)
	return self:GetBipodDeployed() and vDeploySpread or vSpread
end

SWEP.Accuracy = {
	MovePenalty = Vector(0.1, 0.1)
}

if (CLIENT) then
	SWEP.ViewModelFOV = 45
	SWEP.ViewModelTransform = {
		Pos = Vector(1.5, -0.5, 0)
	}
	
	SWEP.MuzzleFlashScale = 0.3
end
