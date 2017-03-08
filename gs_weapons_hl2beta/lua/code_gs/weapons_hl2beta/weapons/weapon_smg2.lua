SWEP.Base = "weapon_hlbase_fireselect"

SWEP.Spawnable = true
SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.ViewModel = "models/code_gs/weapons/hl2beta_2003/v_smg2.mdl"
SWEP.WorldModel = "models/code_gs/weapons/hl2beta_2003/w_smg1.mdl" -- FIXME
SWEP.HoldType = "smg"
SWEP.Weight = 2

SWEP.Sounds = {
	reload = "Weapon_SMG2.Reload",
	shoot = function(self, iIndex)
		if (self:EventActive("burst_" .. iIndex)) then
			local iCurCount = self:GetPredictedVar("BurstCount" .. iIndex, 0)
			
			if (self:GetClip(false, iIndex) >= (self.Burst.Count - iCurCount)) then
				return iCurCount == 0 and "Weapon_SMG2.Burst" or ""
			end
		end
		
		return "Weapon_SMG2.Single"
	end,
	burst = function(self, iIndex)
		return self:GetBurst(iIndex) and "Weapon_SMG2.Special2" or "Weapon_SMG2.Special1"
	end
}

SWEP.Primary.Ammo = "SmallRound"
SWEP.Primary.ClipSize = 60
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Spread = VECTOR_CONE_10DEGREES

SWEP.PunchAngle = {
	VerticalKick = 2,
	SlideLimit = 1
}
