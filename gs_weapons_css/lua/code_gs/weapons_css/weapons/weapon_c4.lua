SWEP.Base = "weapon_cs_base"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.CModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.HoldType = "slam"

-- Gets the text to draw on the C4 while arming!
SWEP.EventStyle = {
	[7001] = "css_c4"
}

SWEP.Primary.Cooldown = 10

SWEP.Secondary.Cooldown = 10

if (CLIENT) then
	SWEP.KillIcon = 'I'
	SWEP.SelectionIcon = 'C'
	
	SWEP.ViewModelFlip = false
	
	SWEP.CSSCrosshair = {
		Min = 6
	}
end

if (CLIENT) then
	function SWEP:Initialize()
		BaseClass.Initialize(self)
		
		self.m_sScreenText = ""
	end
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	self:GetOwner():ChatPrint("No attack implemented!")
	
	local flNextTime = CurTime() + self:GetSpecialKey("Cooldown", bSecondary, iIndex)
	self:SetNextAttack(flNextTime, false, iIndex)
	self:SetNextAttack(flNextTime, true, iIndex)
end
