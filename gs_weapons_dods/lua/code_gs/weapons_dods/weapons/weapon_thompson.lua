SWEP.Base = "weapon_dod_base_gun"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_thompson.mdl"
SWEP.WorldModel = "models/weapons/w_thompson.mdl"
SWEP.Weight = 20

SWEP.Sounds = {
	shoot = "Weapon_Thompson.Shoot",
	--reload = "Weapon_Thompson.WorldReload"
}

SWEP.Primary.Ammo = "SubMG"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30*7 -- FIXME
SWEP.Primary.Cooldown = 0.085
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = Vector(0.055, 0.055)

SWEP.Secondary.Cooldown = 0.4
SWEP.Secondary.Damage = 60
SWEP.Secondary.Range = 48
SWEP.Secondary.InterruptReload = true

SWEP.Accuracy = {
	MovePenalty = Vector(0.1, 0.1)
}

if (CLIENT) then
	SWEP.ViewModelFOV = 45
	SWEP.ViewModelTransform = {
		Pos = Vector(1.5, -0.4, 0.35)
	}
	
	SWEP.MuzzleFlashScale = 0.3
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:Swing(true, iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

-- Ally gun
function SWEP:GetViewModelSkin(iIndex --[[= 0]])
	if (iIndex == nil or iIndex == 0) then
		return 1
	end
	
	return 0
end
