SWEP.Base = "weapon_hl2mpbase_bludgeon"

SWEP.PrintName = "#HL2MP_Crowbar"
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

SWEP.Primary = {
	Damage = 25,
	Range = 75,
	Cooldown = 0.4
}

SWEP.PunchRand = {
	XMin = 1,
	XMax = 2,
	YMin = -2,
	YMax = -1
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.SelectionIcon = 'c'
	SWEP.KillIcon = 'c'
end

--[[function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local tPunch = self.PunchRand
	
	pPlayer:ViewPunch( Angle( pPlayer:SharedRandomFloat( "crowbarpax", tPunch.XMin, tPunch.XMax ),
		pPlayer:SharedRandomFloat( "crowbarpay", tPunch.YMin, tPunch.YMax ), 0 ))
end]]
