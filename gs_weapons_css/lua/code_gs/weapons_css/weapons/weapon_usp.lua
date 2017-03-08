SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_usp.mdl"
SWEP.CModel = "models/weapons/cstrike/c_pist_usp.mdl"
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
SWEP.Primary.Cooldown = 0.15

SWEP.Primary.Damage = function(self, iIndex)
	return self:GetSilenced(iIndex) and 30 or 34
end

SWEP.Primary.RangeModifier = 0.79

local vSpread = Vector(0.1, 0.1)
local vSpreadSilenced = Vector(0.15, 0.15)
SWEP.Primary.Spread = function(self, iIndex)
	return self:GetSilenced(iIndex) and vSpreadSilenced or vSpread
end

local vSpreadAir = Vector(1.2, 1.2)
local vSpreadAirSilenced = Vector(1.3, 1.3)
SWEP.Primary.SpreadAir = function(self, iIndex)
	return self:GetSilenced(iIndex) and vSpreadAirSilenced or vSpreadAir
end

local vSpreadMove = Vector(0.225, 0.225)
local vSpreadMoveSilenced = Vector(0.25, 0.25)
SWEP.Primary.SpreadMove = function(self, iIndex)
	return self:GetSilenced(iIndex) and vSpreadMoveSilenced or vSpreadMove
end

local vSpreadCrouch = Vector(0.08, 0.08)
local vSpreadCrouchSilenced = Vector(0.125, 0.125)
SWEP.Primary.SpreadCrouch = function(self, iIndex)
	return self:GetSilenced(iIndex) and vSpreadCrouchSilenced or vSpreadCrouch
end

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

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:ToggleSilenced(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end
