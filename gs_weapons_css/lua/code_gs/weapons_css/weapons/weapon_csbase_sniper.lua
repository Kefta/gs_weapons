SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Sniper"
SWEP.Slot = 3

SWEP.HoldType = "ar2"
SWEP.Weight = 30

SWEP.Sounds = {
	zoom = "Default.Zoom"
}

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Range = 8192
SWEP.Primary.SpreadAir = vector_origin
SWEP.Primary.SpreadSprint = vector_origin
SWEP.Primary.SpreadMove = vector_origin
SWEP.Primary.SpreadCrouch = vector_origin
SWEP.Primary.SpreadAdditive = vector_origin

SWEP.Secondary.SpreadAir = -1
SWEP.Secondary.SpreadSprint = -1
SWEP.Secondary.SpreadMove = -1
SWEP.Secondary.SpreadCrouch = -1
SWEP.Secondary.SpreadAdditive = vector_origin

SWEP.Zoom = {
	FOV = {
		40
	},
	Times = {
		0.15
	},
	Levels = 2, -- Number of zoom levels
	Cooldown = 0.3, -- Cooldown between zooming
	UnzoomOnFire = true,
	HideViewModel = true
}

SWEP.Penetration = 3

SWEP.Accuracy = {
	Sprint = 0,
	Speed = 0
}

SWEP.PunchIntensity = 2

if (CLIENT) then
	SWEP.Zoom.DrawOverlay = true
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack()) then
		self:AdvanceZoom(0)
		
		return true
	end
	
	return false
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	aPunch[1] = aPunch[1] - self.PunchIntensity 
	pPlayer:SetViewPunchAngles(aPunch)
end

function SWEP:GetSpecialKey(sKey, bSecondary, bNoConVar)
	if (sKey == "Spread") then
		local pPlayer = self:GetOwner()
		
		if (not pPlayer:OnGround()) then
			return BaseClass.GetSpecialKey(self, "SpreadAir", bSecondary, bNoConVar) + BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, bNoConVar)
		end
		
		local flLength = pPlayer:_GetAbsVelocity():Length2DSqr()
		local flWalkSpeed = pPlayer:GetWalkSpeed()
		
		if (flLength > (flWalkSpeed * self.Accuracy.Sprint) ^ 2) then
			return BaseClass.GetSpecialKey(self, "SpreadSprint", bSecondary, bNoConVar) + BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, bNoConVar)
		end
		
		if (flLength > (flWalkSpeed * self.Accuracy.Speed) ^ 2) then
			return BaseClass.GetSpecialKey(self, "SpreadMove", bSecondary, bNoConVar) + BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, bNoConVar)
		end
		
		if (pPlayer:Crouching()) then
			return BaseClass.GetSpecialKey(self, "SpreadCrouch", bSecondary, bNoConVar) + BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, bNoConVar)
		end
		
		return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar) + BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, bNoConVar)
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, bNoConVar)
end
