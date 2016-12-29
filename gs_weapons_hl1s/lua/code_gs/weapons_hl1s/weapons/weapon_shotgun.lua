SWEP.Base = "basehl1combatweapon"

SWEP.Spawnable = true
SWEP.Slot = 3

SWEP.ViewModel = "models/v_shotgun.mdl"
SWEP.WorldModel = "models/w_shotgun.mdl"
SWEP.HoldType = "shotgun"
SWEP.Weight = 15

SWEP.Activities = {
	reload_finish = ACT_SHOTGUN_PUMP,
	idle_alt = ACT_SHOTGUN_IDLE_DEEP,
	idle_alt2 = ACT_SHOTGUN_IDLE4
}

SWEP.Sounds = {
	shoot = "Weapon_Shotgun.Single",
	altfire = "Weapon_Shotgun.Double", 
	reload = "Weapon_Shotgun.Reload",
	reload_finish = "Weapon_Shotgun.Special1"
}

SWEP.Primary.Ammo = "Buckshot_HL"
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Bullets = game.SinglePlayer() and 6 or 4
SWEP.Primary.Cooldown = 0.75
SWEP.Primary.InterruptReload = true
SWEP.Primary.PunchAngle = Angle(-5, 0, 0)
SWEP.Primary.Spread = game.SinglePlayer() and VECTOR_CONE_10DEGREES or Vector(0.08716, 0.04362) // 10 degrees by 5 degrees

SWEP.Secondary.FireUnderwater = false
SWEP.Secondary.Cooldown = 1.5
SWEP.Secondary.Bullets = game.SinglePlayer() and 12 or 8
SWEP.Secondary.Deduction = 2
SWEP.Secondary.InterruptReload = true
SWEP.Secondary.PunchAngle = Angle(-10, 0, 0)

SWEP.SingleReload = {
	Enable = true
}

SWEP.CheckClip1ForSecondary = true
SWEP.EmptyCooldown = 0.75

function SWEP:GetActivitySuffix(sActivity, iIndex)
	local sSuffix = BaseClass.GetActivitySuffix(self, sActivity, iIndex)
	
	if (sActivity == "idle") then
		if (self.m_tDryFire[iIndex] and sSuffix == "empty") then
			return "empty"
		end
		
		code_gs.random:SetSeed(self:GetOwner():GetMD5Seed() % 0x100)
		local flRand = code_gs.random:RandomFloat(0, 1)
		
		if (flRand > 0.95) then
			return "alt"
		end
		
		if (flRand > 0.8) then
			return ""
		end
		
		return "alt2"
	end
	
	return sSuffix
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
		return self:Reload()
	end
	
	if (self:CanSecondaryAttack(0)) then
		self:Shoot(true, 0)
		
		return true
	end
	
	return false
end
