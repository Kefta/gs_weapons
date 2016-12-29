SWEP.Base = "weapon_hl2mp_base"

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

SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 14
SWEP.Primary.Bullets = 7
SWEP.Primary.Damage = 9
SWEP.Primary.Spread = VECTOR_CONE_10DEGREES

SWEP.Secondary.Bullets = 12
SWEP.Secondary.FireUnderwater = false
SWEP.Secondary.Cooldown = 0.15
SWEP.Secondary.Deduction = 2

SWEP.SingleReload = {
	Enable = true
}

SWEP.DoPump = true
SWEP.CheckClip1ForSecondary = true

SWEP.PunchRand = {
	XMin = -2,
	XMax = -1,
	YMin = -2,
	YMax = 2,
	SecXMin = -5,
	SecXMax = 5
}

if (CLIENT) then
	SWEP.KillIcon = '0'
	SWEP.SelectionIcon = 'b'
end

function SWEP:SharedDeploy(bDelayed)
	BaseClass.SharedDeploy(self, bDelayed)
	
	self:SetBodygroup(1, 1)
end

function SWEP:ReloadClips()
	BaseClass.ReloadClips(self)
	
	// Make shotgun shell visible
	self:SetBodygroup(0, 1)
end

function SWEP:FinishReload()
	// Make shotgun shell invisible
	self:SetBodygroup(1, 1)
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack(0)) then
		self:Shoot(false, 0)
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if (self:Clip1() == 1) then
		return self:PrimaryAttack()
	end
	
	if (self:CanSecondaryAttack(0)) then
		self:Shoot(true, 0)
		
		return true
	end
	
	return false
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	-- If the reload was interrupted
	self:SetBodygroup(1, 1)
end

function SWEP:Punch(bSecondary)
	local pPlayer = self:GetOwner()
	local tPunch = self.PunchRand
	
	pPlayer:ViewPunch(bSecondary and Angle(code_gs.random:SharedRandomFloat(pPlayer, "shotgunsax", tPunch.SecXMin, tPunch.SecXMax), 0, 0)
		or Angle(code_gs.random:SharedRandomFloat(pPlayer, "shotgunpax", tPunch.XMin, tPunch.XMax),
		code_gs.random:SharedRandomFloat(pPlayer, "shotgunpay", tPunch.YMin, tPunch.YMax), 0))
end
