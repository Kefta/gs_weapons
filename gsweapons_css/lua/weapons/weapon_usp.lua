SWEP.Base = "weapon_csbase_pistol"

SWEP.PrintName = "#CStrike_USP"
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

SWEP.Primary = {
	Ammo = "45acp",
	ClipSize = 12,
	DefaultClip = 112,
	Damage = 34,
	RangeModifier = 0.79,
	Spread = Vector(0.1, 0.1),
	SpreadAir = Vector(1.2, 1.2),
	SpreadMove = Vector(0.225, 0.225),
	SpreadCrouch = Vector(0.08, 0.08)
}

SWEP.Secondary = {
	Damage = 30,
	Spread = Vector(0.15, 0.15),
	SpreadAir = Vector(1.3, 1.3),
	SpreadMove = Vector(0.25, 0.25),
	SpreadCrouch = Vector(0.125, 0.125)
}

SWEP.Accuracy = {
	Base = 0.92,
	Decay = 0.275,
	Time = 0.3,
	Min = 0.6
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'a'
	SWEP.SelectionIcon = 'a'
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:Silence(0)
		
		return true
	end
	
	return false
end
