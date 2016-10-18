DEFINE_BASECLASS( "weapon_sdk_base" )

--- GSBase
SWEP.PrintName = "#SDK_Shotgun"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.HoldType = "shotgun"

SWEP.Weight = 20

SWEP.Activities = {
	primary = {
		ACT_VM_PRIMARYATTACK,
		idle = 2.5
	}
}

SWEP.Primary = {
	Damage = 22,
	Bullets = 9,
	ClipSize = 8,
	DefaultClip = 16,
	Cooldown = 0.875,
	ReloadOnEmptyFire = true,
	InterruptReload = true,
	Spread = {
		Base = 0.0675
	}
}

SWEP.SingleReload = {
	Enable = true,
	QueuedFire = false,
	InitialRound = false
}

SWEP.EmptyCooldown = 0.2
SWEP.UnderwaterCooldown = 0.15

if ( CLIENT ) then
	SWEP.Category = "Source"
	SWEP.KillIcon = 'k'
	SWEP.SelectionIcon = 'k'
end

function SWEP:Shoot( bSecondary, iIndex, iClipDeduction )
	BaseClass.Shoot( self, bSecondary, iIndex, iClipDeduction )
	
	if ( self:Clip1() == 0 ) then
		self:SetNextIdle( CurTime() + self:GetCooldown() )
	end
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	local ang = pPlayer:GetViewPunchAngles()
	
	ang[1] = ang[1] - (pPlayer:OnGround() and pPlayer:SharedRandomInt( "ShotgunPunchAngleGround", 4, 6 )
		or pPlayer:SharedRandomInt( "ShotgunPunchAngleAir", 8, 11 ))
	
	pPlayer:SetViewPunchAngles( ang )
end

function SWEP:GetShootAngles()
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + 2 * pPlayer:GetViewPunchAngles()
end
