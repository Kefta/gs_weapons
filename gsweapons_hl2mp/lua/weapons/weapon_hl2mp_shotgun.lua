SWEP.Base = "weapon_hl2mp_base"

SWEP.PrintName = "#HL2MP_Shotgun"
SWEP.Spawnable = true
SWEP.Slot = 3

SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "shotgun"

SWEP.Weight = 4

SWEP.Sounds = {
	empty = "Weapon_Shotgun.Empty",
	reload = "Weapon_Shotgun.Reload",
	shoot = "Weapon_Shotgun.Single",
	altfire = "Weapon_Shotgun.Double",
	pump = "Weapon_Shotgun.Special"
}

SWEP.Primary = {
	Ammo = "Buckshot",
	ClipSize = 6,
	DefaultClip = 14,
	Bullets = 7,
	Damage = 9,
	Spread = VECTOR_CONE_10DEGREES
}

SWEP.Secondary = {
	Bullets = 12,
	FireUnderwater = false,
	Cooldown = 0.15
}

SWEP.SingleReload = {
	Enable = true
}

SWEP.DoPump = true
SWEP.UseClip1ForSecondary = true

SWEP.PunchRand = {
	XMin = -2,
	XMax = -1,
	YMin = -2,
	YMax = 2,
	SecXMin = -5,
	SecXMax = 5
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = '0'
	SWEP.SelectionIcon = 'b'
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:SharedDeploy( bDelayed )
	BaseClass.SharedDeploy( self, bDelayed )
	
	self:SetBodygroup(1, 1)
end

function SWEP:ReloadClips()
	BaseClass.ReloadClips( self )
	
	// Make shotgun shell visible
	self:SetBodygroup(0, 1)
end

function SWEP:FinishReload()
	// Make shotgun shell invisible
	self:SetBodygroup(1, 1)
end

function SWEP:SecondaryAttack()
	if ( self:Clip1() == 1 ) then
		self:Shoot( false, 0 )
		
		return true
	end
	
	if ( self:CanSecondaryAttack() ) then
		self:Shoot( true, 0, "altfire", 2 )
		
		return true
	end
	
	return false
end

function SWEP:Shoot( bSecondary --[[= false]], iIndex --[[= 0]], sPlay, iClipDeduction --[[= 1]] )
	BaseClass.Shoot( self, bSecondary, iIndex, sPlay, iClipDeduction )
	
	-- If the reload was interrupted
	self:SetBodygroup(1, 1)
end

function SWEP:Punch( bSecondary )
	local pPlayer = self:GetOwner()
	local tPunch = self.PunchRand
	
	pPlayer:ViewPunch( bSecondary and Angle( pPlayer:SharedRandomFloat( "shotgunsax", tPunch.SecXMin, tPunch.SecXMax ), 0, 0 )
		or Angle( pPlayer:SharedRandomFloat( "shotgunpax", tPunch.XMin, tPunch.XMax ),
		pPlayer:SharedRandomFloat( "shotgunpay", tPunch.YMin, tPunch.YMax ), 0 ))
end
