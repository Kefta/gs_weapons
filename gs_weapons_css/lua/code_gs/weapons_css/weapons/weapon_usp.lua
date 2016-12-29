SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
SWEP.SilencerModel = "models/weapons/w_pist_usp_silencer.mdl"

SWEP.Sounds = {
	shoot = "Weapon_USP.Single",
	--silence = "Weapon_USP.AttachSilencer",
	s_shoot = "Weapon_USP.SilencedShot",
	--s_silence = "Weapon_USP.DetachSilencer"
}

SWEP.Primary.Ammo = "45acp"
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 112
SWEP.Primary.Damage = 34
SWEP.Primary.RangeModifier = 0.79
SWEP.Primary.Spread = Vector(0.1, 0.1)
SWEP.Primary.SpreadAir = Vector(1.2, 1.2)
SWEP.Primary.SpreadMove = Vector(0.225, 0.225)
SWEP.Primary.SpreadCrouch = Vector(0.08, 0.08)

SWEP.Secondary.Damage = 30
SWEP.Secondary.Spread = Vector(0.15, 0.15)
SWEP.Secondary.SpreadAir = Vector(1.3, 1.3)
SWEP.Secondary.SpreadMove = Vector(0.25, 0.25)
SWEP.Secondary.SpreadCrouch = Vector(0.125, 0.125)

SWEP.Accuracy = {
	Base = 0.92,
	Decay = 0.275,
	Time = 0.3,
	Min = 0.6
}

if (CLIENT) then
	SWEP.KillIcon = 'a'
	SWEP.SelectionIcon = 'a'
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack()) then
		self:Silence(0)
		
		return true
	end
	
	return false
end
