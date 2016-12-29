SWEP.Base = "basehlcombatweapon"

SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Weight = 7

SWEP.Sounds = {
	empty = "Weapon_Pistol.Empty",
	shoot = "Weapon_357.Single"
}

SWEP.Primary.Ammo = "357"
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Cooldown = 0.75
SWEP.Primary.FireUnderwater = false
SWEP.Primary.Spread = vector_origin

if (CLIENT) then
	SWEP.KillIcon = '.'
	SWEP.SelectionIcon = 'e'
	
	-- https://github.com/Facepunch/garrysmod-issues/issues/2847
	SWEP.EventStyle = {
		[3015] = "hl2_357"
	}
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	// Disorient the player
	local aPlayer = pPlayer:GetLocalAngles()
	aPlayer[1] = aPlayer[1] + code_gs.random:RandomInt(-1, 1)
	aPlayer[2] = aPlayer[2] + code_gs.random:RandomInt(-1, 1)
	aPlayer[3] = 0
	
	pPlayer:SetEyeAngles(aPlayer)
	pPlayer:ViewPunch(Angle(-8, code_gs.random:RandomFloat(-2, 2), 0))
end
