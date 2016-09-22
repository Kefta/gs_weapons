DEFINE_BASECLASS( "basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL1_Glock"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/v_9mmhandgun.mdl"
SWEP.WorldModel = "models/w_9mmhandgun.mdl"
SWEP.HoldType = "pistol"
SWEP.Weight = 10

SWEP.Activities = {
	dryfire = ACT_GLOCK_SHOOTEMPTY,
	secondary = ACT_VM_PRIMARYATTACK,
	reload_empty = ACT_GLOCK_SHOOT_RELOAD
}

SWEP.Sounds = {
	-- The CS:S glock scape has higher priority, so we need to redefine HL1's
	primary = {
		name = "HL_Weapon_Glock.Single",
		level = SNDLEVEL_GUNFIRE,
		pitch = {95, 105},
		sound = "weapons/pl_gun3.wav"
	},
	secondary = "HL_Weapon_Glock.Single"
}

SWEP.Primary = {
	Ammo = "9mmRound",
	ClipSize = 17,
	DefaultClip = 34,
	Cooldown = 0.3,
	PunchAngle = Angle(-2, 0, 0),
	Spread = Vector(0.01, 0.01, 0.01)
}

SWEP.Secondary = {
	Cooldown = 0.2,
	Spread = Vector(0.1, 0.1, 0.1)
}

SWEP.ReloadOnEmptyFire = true

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

--- GSBase
function SWEP:CanSecondaryAttack()
	if ( self:CanPrimaryAttack() ) then
		self:ShootBullets({
			AmmoType = self:GetPrimaryAmmoName(),
			Damage = self:GetDamage( true ),
			Dir = self:GetShootAngles():Forward(),
			Distance = self:GetRange( true ),
			--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
			Num = self:GetBulletCount( true ),
			Spread = self:GetSpread( true ),
			Src = self:GetShootSrc(),
			Tracer = 2
		}, true )
		
		-- Random seed is already set from ShootBullets
		-- FIXME: Does prediction screw this up? Check results
		self:SetNextIdle( CurTime() + random.RandomFloat(10, 15) )
		
		return true
	end
	
	return false
end

function SWEP:ShootBullets( tbl --[[{}]], bSecondary --[[= false]], iClipDeduction --[[= 1]] )
	BaseClass.ShootBullets( self, tbl, bSecondary, iClipDeduction )
	
	self:SetNextIdle( CurTime() + random.RandomFloat(10, 15) )
end
