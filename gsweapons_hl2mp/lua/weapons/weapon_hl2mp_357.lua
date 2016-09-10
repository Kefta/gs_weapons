-- FIXME: Lowercase event names?
DEFINE_BASECLASS( "basehl2mpcombatweapon" )

--- GSBase
SWEP.PrintName = "#HL2_357Handgun"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Weight = 7

SWEP.Sounds = {
	empty = "Weapon_Pistol.Empty",
	primary = "Weapon_357.Single"
}

SWEP.Damage = 75

SWEP.Primary = {
	Ammo = "357",
	ClipSize = 6,
	DefaultClip = 12,
	Cooldown = 0.75,
	FireUnderwater = false,
	Spread = vector_origin
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = 'e'
	SWEP.SelectionIcon = 'e'
end

--- GSBase
function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	// Add it to the view punch
	-- FIX
	pPlayer:ViewPunchReset()
	pPlayer:ViewPunch( Angle( -8, random.RandomFloat(-2, 2), 0 ))
end
