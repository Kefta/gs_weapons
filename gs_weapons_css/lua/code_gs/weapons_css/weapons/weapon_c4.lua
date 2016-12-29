SWEP.Base = "weapon_cs_base"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.HoldType = "slam"

SWEP.Primary.Cooldown = 10

if (CLIENT) then
	SWEP.KillIcon = 'I'
	SWEP.SelectionIcon = 'C'
	
	SWEP.CSSCrosshair = {
		Min = 6
	}
	
	SWEP.EventStyle = {
		[7001] = "" -- Plays on deploy for no reason
	}
	
	SWEP.ViewModelFlip = false
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack()) then
		self:GetOwner():ChatPrint("No primary attack implemented!")
		self:SetNextPrimaryFire(CurTime() + self:GetSpecialKey("Cooldown", false))
		
		return true
	end
	
	return false
end
