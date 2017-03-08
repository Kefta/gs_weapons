SWEP.Base = "weapon_csbase_gun"

SWEP.PrintName = "CSBase_Sniper"
SWEP.Slot = 3

SWEP.HoldType = "ar2"
SWEP.Weight = 30

SWEP.Sounds = {
	zoom = "Default.Zoom"
}

SWEP.Primary.ClipSize = 10
SWEP.Primary.Range = 8192
SWEP.Primary.SpreadAir = vector_origin -- Spread in the air
SWEP.Primary.SpreadSprint = vector_origin -- Spread while sprinting
SWEP.Primary.SpreadMove = vector_origin -- Spread while moving
SWEP.Primary.SpreadCrouch = vector_origin -- Spread while crouching
SWEP.Primary.SpreadAdditive = vector_origin -- Spread amount to add
SWEP.Primary.Automatic = false

SWEP.Secondary.SpreadAir = SWEP.Primary.SpreadAir
SWEP.Secondary.SpreadSprint = SWEP.Primary.SpreadSprint
SWEP.Secondary.SpreadMove = SWEP.Primary.SpreadMove
SWEP.Secondary.SpreadCrouch = SWEP.Primary.SpreadCrouch
SWEP.Secondary.SpreadAdditive = SWEP.Primary.SpreadAdditive

SWEP.Zoom = {
	Cooldown = 0.3,
	FOV = {
		40
	},
	Levels = 2,
	Times = {
		0.15
	},
	UnzoomOnFire = true
}

SWEP.Penetration = 3

SWEP.Accuracy = {
	Sprint = 0, -- Speed for SpreadSprint to take affect
	Speed = 0 -- Speed for SpreadMove to take affect
}

SWEP.PunchIntensity = 2 -- Magnitude of pitch in punch

if (CLIENT) then
	SWEP.Zoom.HideViewModel = true
	SWEP.Zoom.DrawOverlay = true
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:AdvanceZoom(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local aPunch = pPlayer:GetViewPunchAngles()
	aPunch[1] = aPunch[1] - self.PunchIntensity 
	pPlayer:SetViewPunchAngles(aPunch)
end

function SWEP:GetSpecialKey(sKey, bSecondary --[[= false]], iIndex --[[= 0]])
	if (sKey == "Spread") then
		local pPlayer = self:GetOwner()
		
		if (not pPlayer:OnGround()) then
			sKey = "SpreadAir"
		else
			local flLength = pPlayer:_GetAbsVelocity():Length2DSqr()
			local flWalkSpeed = pPlayer:GetWalkSpeed()
			
			if (flLength > (flWalkSpeed * self.Accuracy.Sprint) ^ 2) then
				sKey = "SpreadSprint"
			elseif (flLength > (flWalkSpeed * self.Accuracy.Speed) ^ 2) then
				sKey = "SpreadMove"
			elseif (pPlayer:Crouching()) then
				sKey = "SpreadCrouch"
			end
		end
		
		return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex) + BaseClass.GetSpecialKey(self, "SpreadAdditive", bSecondary, iIndex)
	end
	
	return BaseClass.GetSpecialKey(self, sKey, bSecondary, iIndex)
end
