SWEP.Base = "weapon_csbase_pistol"

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_elite.mdl"
SWEP.CModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.DroppedModel = "models/weapons/w_pist_elite_dropped.mdl"
-- Single version: "models/weapons/w_pist_elite_single.mdl"
SWEP.HoldType = "duel"

SWEP.Sounds = {
	shoot = "Weapon_Elite.Single"
}

SWEP.StrictSuffixes = {
	empty_left = function(self, iIndex) return self:GetClip(false, iIndex) == 1 end
}

SWEP.Activities = {
	shoot = function(self, iIndex)
		return self:GetClip(false, iIndex) % 2 == 0 and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK
	end,
	shoot_empty_left = ACT_VM_DRYFIRE_LEFT,
	idle_empty_left = ACT_VM_IDLE_EMPTY_LEFT
}

SWEP.Primary.Ammo = "9mm"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Cooldown = 0.12
SWEP.Primary.Damage = 45
SWEP.Primary.RangeModifier = 0.75
SWEP.Primary.Spread = Vector(0.1, 0.1)
SWEP.Primary.SpreadAir = Vector(1.3, 1.3)
SWEP.Primary.SpreadMove = Vector(0.175, 0.175)
SWEP.Primary.SpreadCrouch = Vector(0.08, 0.08)

SWEP.Accuracy = {
	Base = 0.88,
	Decay = 0.275,
	Time = 0.325,
	Min = 0.55
}

if (CLIENT) then
	SWEP.KillIcon = 's'
	SWEP.SelectionIcon = 's'
	
	SWEP.CSSCrosshair = {
		Min = 4
	}
end

-- Right and left pistols
-- FIXME: Test
-- FIXME: Empty firing isn't working
function SWEP:GetMuzzleAttachment(iEvent --[[= 5001]])
	return self:GetClip(false, iIndex) % 2 == 0 and ((iEvent or 5001) - 4991) / 10 or ((iEvent or 5001) - 4991) / 10 + 1
end
	