DEFINE_BASECLASS( "hl2_basehlcombatweapon" )

--- GSBase
SWEP.PrintName = "#HL2SP_357Handgun"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Weight = 7

-- https://github.com/Facepunch/garrysmod-issues/issues/2847
SWEP.Activities = {
	[3015] = "hl2_357"
}

SWEP.Sounds = {
	empty = "Weapon_Pistol.Empty",
	primary = "Weapon_357.Single"
}

SWEP.Primary = {
	Ammo = "357",
	ClipSize = 6,
	DefaultClip = 12,
	Cooldown = 0.75,
	FireUnderwater = false,
	Spread = vector_origin
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 SP"
	SWEP.KillIcon = '.'
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
