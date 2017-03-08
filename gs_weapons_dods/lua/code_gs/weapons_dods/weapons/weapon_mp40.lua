SWEP.Base = "weapon_dod_base_gun"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_mp40.mdl"
SWEP.WorldModel = "models/weapons/w_mp40.mdl"
SWEP.Weight = 20

SWEP.Sounds = {
	shoot = "Weapon_MP40.Shoot",
	--reload = "Weapon_MP40.WorldReload"
}

SWEP.Primary.Ammo = "SubMG"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30*7 -- FIXME
SWEP.Primary.Cooldown = 0.09
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
		Pos = Vector(-1, 0.6, 0)
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
