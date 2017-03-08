-- FIXME: Event 5001

SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_357.mdl"
SWEP.WorldModel = "models/w_357.mdl"
SWEP.HoldType = "revolver"
SWEP.Weight = 15

SWEP.Sounds = {
	shoot = "Weapon_357.Single" -- FIXME: Wrong sound
}

SWEP.Activities = {
	idle = function(self, iIndex)
		return code_gs.random:SharedRandomFloat(self:GetOwner(), self:GetClass() .. "-Activity" .. iIndex .. "-idle", 0, 1) > 0.9
			and ACT_VM_FIDGET or ACT_VM_IDLE
	end
}

SWEP.Primary.Ammo = "357Round"
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Cooldown = 0.75
SWEP.Primary.Spread = VECTOR_CONE_1DEGREES
SWEP.Primary.PunchAngle = Angle(-10, 0, 0)
SWEP.Primary.Automatic = false
SWEP.Primary.FireUnderwater = false

SWEP.Zoom = {
	Cooldown = 0.5,
	FOV = {
		40
	},
	Times = {
		[0] = 0,
		0
	}
}

if (CLIENT) then
	SWEP.Zoom.HideViewModel = true
end

local bMultiPlayer = not game.SinglePlayer()
local sv_cheats = GetConVar("sv_cheats")

function SWEP:CanAttack(bSecondary --[[= false]], iIndex --[[= 0]])
	return (not bSecondary or bMultiPlayer or sv_cheats:GetBool()) and BaseClass.CanAttack(self, bSecondary, iIndex)
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:AdvanceZoom(iIndex)
	else
		self:Shoot(false, iIndex)
	end
end
