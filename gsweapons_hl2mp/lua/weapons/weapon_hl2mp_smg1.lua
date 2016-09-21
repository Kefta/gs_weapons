DEFINE_BASECLASS( "weapon_hl2mp_machinegun" )

--- GSBase
SWEP.PrintName = "#HL2_SMG1"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"

SWEP.Weight = 3

SWEP.Sounds = {
	reload = "Weapon_SMG1.Reload",
	empty = "Weapon_SMG1.Empty",
	primary = "Weapon_SMG1.Single"
}

SWEP.Primary = {
	Ammo = "SMG1",
	ClipSize = 45,
	DefaultClip = 90,
	Cooldown = 0.075, // 13.3hz
	Damage = 5,
	Spread = VECTOR_CONE_5DEGREES
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = 'a'
	SWEP.SelectionIcon = 'a'
end

--- HL2MPBase_MachineGun
SWEP.PunchAngle = {
	VerticalKick = 1,
	SlideLimit = 2
}
