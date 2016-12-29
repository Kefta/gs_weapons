SWEP.Base = "weapon_hlbase_bludgeon"

SWEP.Spawnable = true
SWEP.Slot = 0

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"

SWEP.Sounds = {
	miss = "Weapon_Crowbar.Single",
	hit = "Weapon_Crowbar.Melee_Hit",
	hitworld = "Weapon_Crowbar.Melee_HitWorld"
}

SWEP.Primary.Damage = 25
SWEP.Primary.Range = 75
SWEP.Primary.Cooldown = 0.4

SWEP.PunchRand = {
	XMin = 1,
	XMax = 2,
	YMin = -2,
	YMax = -1
}

if (CLIENT) then
	SWEP.SelectionIcon = 'c'
	SWEP.KillIcon = 'c'
end

--[[function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local tPunch = self.PunchRand
	
	pPlayer:ViewPunch(Angle(code_gs.random:SharedRandomFloat(pPlayer, "crowbarpax", tPunch.XMin, tPunch.XMax),
		code_gs.random:SharedRandomFloat(pPlayer, "crowbarpay", tPunch.YMin, tPunch.YMax), 0))
end]]
