SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_357.mdl"
SWEP.WorldModel = "models/w_357.mdl"
SWEP.HoldType = "revolver"
SWEP.Weight = 15

SWEP.Activities = {
	idle_alt = ACT_VM_FIDGET
}

SWEP.Sounds = {
	shoot = "Weapon_357.Single"
}

SWEP.Primary.Ammo = "357Round"
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Cooldown = 0.75
SWEP.Primary.FireUnderwater = false
SWEP.Primary.Spread = VECTOR_CONE_1DEGREES
SWEP.Primary.PunchAngle = Angle(-10, 0, 0)

SWEP.Zoom = {
	FOV = {
		40
	},
	Times = {
		[0] = 0,
		0
	},
	Cooldown = 0.5,
	HideViewModel = true
}

local sv_cheats = GetConVar("sv_cheats")
local bMultiPlayer = not game.SinglePlayer()

function SWEP:CanSecondaryAttack(iIndex)
	return (bMultiPlayer or sv_cheats:GetBool()) and BaseClass.CanSecondaryAttack(self, iIndex)
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack(0)) then
		self:AdvanceZoom(0)
		
		return true
	end
	
	return false
end

function SWEP:GetActivitySuffix(sActivity, iIndex)
	local sSuffix = BaseClass.GetActivitySuffix(self, sActivity, iIndex)
	
	if (sActivity == "idle") then
		if (self.m_tDryFire[iIndex] and sSuffix == "empty") then
			return sSuffix
		end
		
		code_gs.random:SetSeed(self:GetOwner():GetMD5Seed() % 0x100)
		
		if (code_gs.random:RandomFloat(0, 1) > 0.9) then
			return "alt"
		end
	end
	
	return sSuffix
end
