-- This is the only machine gun in CS:S. It spreads like a rifle but kicks like an SMG
SWEP.Base = "weapon_csbase_rifle"

SWEP.PrintName = "#CStrike_M249"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.Sounds = {
	shoot = "Weapon_M249.Single"
}

SWEP.Primary = {
	Ammo = "556mm_Box",
	ClipSize = 100,
	DefaultClip = 300,
	Damage = 35,
	Range = 8192,
	Cooldown = 0.08,
	WalkSpeed = 220/250,
	RangeModifier = 0.97,
	Spread = Vector(0.03, 0.03),
	SpreadAir = Vector(0.5, 0.5),
	SpreadMove = Vector(0.095, 0.095)
}

SWEP.Accuracy = {
	Divisor = 175,
	Offset = 0.4,
	Max = 0.9,
	Additive = Vector(0.045, 0.045)
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

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'z'
	SWEP.SelectionIcon = 'z'
	
	SWEP.CSSCrosshair = {
		Min = 6
	}
	
	SWEP.MuzzleFlashScale = 1.5
	
	SWEP.ViewModelFlip = false
end

// GOOSEMAN : Kick the view..
function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local tKick = self.Kick
	
	// Kick the gun based on the state of the player.
	-- Ground first, speed second
	if ( not pPlayer:OnGround() ) then
		tKick = tKick.Air
	elseif ( pPlayer:_GetAbsVelocity():Length2DSqr() > (pPlayer:GetWalkSpeed() * tKick.Speed) ^ 2 ) then
		tKick = tKick.Move
	elseif ( pPlayer:Crouching() ) then
		tKick = tKick.Crouch
	else
		tKick = tKick.Base
	end
	
	local iShotsFired = self:GetShotsFired()
	local aPunch = pPlayer:GetViewPunchAngles()
	
	aPunch[1] = aPunch[1] - (tKick.UpBase + iShotsFired * tKick.UpModifier)
	local flUpMin = -tKick.UpMax
	
	if ( aPunch[1] < flUpMin ) then
		aPunch[1] = flUpMin
	end
	
	local bDirection = pPlayer.dt.PunchDirection
	
	if ( bDirection ) then
		aPunch[2] = aPunch[2] + (tKick.LateralBase + iShotsFired * tKick.LateralModifier)
		local flLateralMax = tKick.LateralMax
		
		if ( aPunch[2] > flLateralMax ) then
			aPunch[2] = flLateralMax
		end
	else
		aPunch[2] = aPunch[2] - (tKick.LateralBase + iShotsFired * tKick.LateralModifier)
		local flLateralMin = -tKick.LateralMax
		
		if ( aPunch[2] < flLateralMin ) then
			aPunch[2] = flLateralMin
		end
	end
	
	if ( pPlayer:SharedRandomInt( "KickBack", 0, tKick.DirectionChange ) == 0 ) then
		pPlayer.dt.PunchDirection = not bDirection
	end
	
	pPlayer:SetViewPunchAngles( aPunch )
end
