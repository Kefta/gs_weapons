-- FIXME: Change the behaviour to be an actual pistol?
-- Add the different firing animations
SWEP.Base = "weapon_hlbase_fireselect"

SWEP.Spawnable = true
SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.ViewModel = "models/code_gs/weapons/hl2beta_2003/v_alyxgun.mdl"
SWEP.WorldModel = "models/code_gs/weapons/hl2beta_2003/w_alyxgun.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 2

SWEP.Sounds = {
	empty = "Weapon_alyxgun.Empty",
	reload = "Weapon_alyxgun.Reload",
	shoot = function(self, iIndex)
		if (self:EventActive("burst_" .. iIndex)) then
			local iCurCount = self:GetPredictedVar("BurstCount" .. iIndex, 0)
			
			if (self:GetClip(false, iIndex) >= (self.Burst.Count - iCurCount)) then
				return iCurCount == 0 and "Weapon_Pistol.Burst" or "" -- FIXME
			end
		end
		
		return "Weapon_alyxgun.Single"
	end,
	burst = function(self, iIndex)
		return self:GetBurst(iIndex) and "Weapon_Pistol.Special2" or "Weapon_Pistol.Special1"
	end
}

SWEP.Primary.Ammo = "MediumRound"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60

-- Since this is a recreation for player use
-- There's no point in checking if Alyx is injured or not
SWEP.Primary.Spread = VECTOR_CONE_2DEGREES
--SWEP.Primary.TracerFreq = 1 -- Episodic only

--SWEP.TriggerBoundSize = -1 // Alyx gun cannot be picked up
