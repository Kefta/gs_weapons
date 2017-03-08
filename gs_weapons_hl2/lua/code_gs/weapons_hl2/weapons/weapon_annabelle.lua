SWEP.Base = "basehlcombatweapon"

SWEP.Spawnable = true
SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"
SWEP.HoldType = "shotgun"
SWEP.Weight = 2

SWEP.Sounds = {
	empty = "Weapon_Shotgun.Empty",
	reload = "Weapon_Shotgun.Reload", -- FIXME: Needed?
	shoot = "Weapon_Shotgun.Single",
	pump = "Weapon_Shotgun.Special1"
}

SWEP.Activities = {
	shoot_empty = ACT_INVALID -- Broken
}

SWEP.Primary.Ammo = "357"
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Cooldown = 1.5
SWEP.Primary.TracerFreq = 0
SWEP.Primary.Automatic = false

-- Reloading on the annabelle by default isn't really designed for players
-- It will not call StartReload, then only give one bullet, which seems to be by mistake
-- Since "ERROR: Shotgun Reload called incorrectly!" is output in console
-- I've decided to just make it normal shotgun reloading, instead
SWEP.SingleReload = {
	Enabled = true
}

function SWEP:StartReload(iIndex)
	if (iIndex == 0) then
		// Make shotgun shell visible
		self:SetBodygroup(1, 0)
	end
end

function SWEP:InterruptReload(iIndex)
	if (iIndex == 0) then
		// Make shotgun shell invisible
		self:SetBodygroup(1, 1)
	end
end

function SWEP:FinishReload(iIndex)
	if (iIndex == 0) then
		// Make shotgun shell invisible
		self:SetBodygroup(1, 1)
	end
end
