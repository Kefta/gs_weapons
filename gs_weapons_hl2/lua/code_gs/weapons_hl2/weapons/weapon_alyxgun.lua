SWEP.Base = "weapon_hlbase_fireselect"

SWEP.Spawnable = true
SWEP.Slot = 1
SWEP.SlotPos = 4

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.CModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_alyx_gun.mdl"
SWEP.HoldType = "revolver"
SWEP.Weight = 2

SWEP.Sounds = {
	empty = "Weapon_Pistol.Empty",
	reload = "Weapon_Pistol.Reload",
	shoot = function(self, iIndex)
		if (self:EventActive("burst_" .. iIndex)) then
			local iCurCount = self:GetPredictedVar("BurstCount" .. iIndex, 0)
			
			if (self:GetClip(false, iIndex) >= (self.Burst.Count - iCurCount)) then
				return iCurCount == 0 and "Weapon_Pistol.Burst" or ""
			end
		end
		
		return "Weapon_Pistol.Single"
	end,
	burst = function(self, iIndex)
		return self:GetBurst(iIndex) and "Weapon_Pistol.Special2" or "Weapon_Pistol.Special1"
	end
}

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60

-- Since this is a recreation for player use
-- There's no point in checking if Alyx is injured or not
SWEP.Primary.Spread = VECTOR_CONE_2DEGREES
--SWEP.Primary.TracerFreq = 1 -- Episodic only

--SWEP.TriggerBoundSize = -1 // Alyx gun cannot be picked up
