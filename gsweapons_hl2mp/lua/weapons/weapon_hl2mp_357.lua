DEFINE_BASECLASS( "basehl2mpcombatweapon" )

--- GSBase
SWEP.PrintName = "#HL2_357Handgun"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Weight = 7

SWEP.Sounds = {
	empty = "Weapon_Pistol.Empty",
	primary = "Weapon_357.Single"
}

SWEP.Primary = {
	Ammo = "357",
	ClipSize = 6,
	DefaultClip = 12,
	Cooldown = 0.75,
	Damage = 75,
	FireUnderwater = false,
	Spread = vector_origin
}

SWEP.ReloadOnEmptyFire = true

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = 'e'
	SWEP.SelectionIcon = 'e'
end

--- GSBase
function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	// Disorient the player
	local aPlayer = pPlayer:GetLocalAngles()
	aPlayer.p = aPlayer.p + random.RandomInt(-1, 1)
	aPlayer.y = aPlayer.y + random.RandomInt(-1, 1)
	aPlayer.r = 0
	
	pPlayer:SetEyeAngles( aPlayer )
	pPlayer:ViewPunch( Angle( -8, random.RandomFloat(-2, 2), 0 ))
end
