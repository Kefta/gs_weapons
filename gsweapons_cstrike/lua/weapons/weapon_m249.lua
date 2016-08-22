-- This is the only machine gun in CS:S. It spreads like a rifle but kicks like an SMG
-- Which is why I made it inherit from Rifle (since it has extra accuracy variables for GetSpread)
-- But copy the Punch method from SMG
DEFINE_BASECLASS( "weapon_csbase_rifle" )

--- GSBase
SWEP.PrintName = "#CStrike_M249"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.Sounds = {
	primary = "Weapon_M249.Single"
}

SWEP.Primary = {
	Ammo = "556mmRound_Box",
	ClipSize = 100,
	DefaultClip = 300,
	Damage = 35,
	Range = 8192,
	Cooldown = 0.08,
	WalkSpeed = 220/250,
	RangeModifier = 0.97,
	Spread = {
		Base = 0.03,
		Air = 0.5,
		Move = 0.095
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'z'
	SWEP.SelectionIcon = 'z'
	
	SWEP.CSSCrosshair = {
		Min = 6
	}
	
	SWEP.MuzzleFlashScale = 1.5
	
	SWEP.EventStyle = {
		-- CS:S muzzle flash
		[5001] = "cstrike_x",
		[5011] = "cstrike_x",
		[5021] = "cstrike_x",
		[5031] = "cstrike_x"
	}
end

--- CSBase_SMG
SWEP.Accuracy = {
	Divisor = 175,
	Offset = 0.4,
	Max = 0.9,
	Additive = 0.045
}

SWEP.Kick = {
	Air = {
		UpBase = 1.8,
		LateralBase = 0.65,
		UpModifier = 0.45,
		LateralModifier = 0.125,
		UpMax = 5,
		LateralMax = 3.5,
		DirectionChange = 8
	},
	Move = {
		UpBase = 1.1,
		LateralBase = 0.5,
		UpModifier = 0.3,
		LateralModifier = 0.06,
		UpMax = 4,
		LateralMax = 3,
		DirectionChange = 8
	},
	Crouch = {
		UpBase = 0.75,
		LateralBase = 0.325,
		UpModifier = 0.25,
		LateralModifier = 0.025,
		UpMax = 3.5,
		LateralMax = 2.5,
		DirectionChange = 9
	},
	Base = {
		UpBase = 0.8,
		LateralBase = 0.35,
		UpModifier = 0.3,
		LateralModifier = 0.03,
		UpMax = 3.75,
		LateralMax = 3,
		DirectionChange = 9
	}
}

--- GSBase
function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local tKick = self.Kick
	
	// Kick the gun based on the state of the player.
	-- Ground first, speed second
	if ( not pPlayer:OnGround() ) then
		pPlayer:KickBack( tKick.Air )
	elseif ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tKick.Speed) ^ 2 ) then
		pPlayer:KickBack( tKick.Move )
	elseif ( pPlayer:Crouching() ) then
		pPlayer:KickBack( tKick.Crouch )
	else
		pPlayer:KickBack( tKick.Base )
	end
end
