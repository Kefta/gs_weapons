DEFINE_BASECLASS( "hl1s_basehl1combatweapon" )

--- GSBase
SWEP.PrintName = "#HL1_Shotgun"
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
	primary = "Weapon_Shotgun.Single",
	secondary = "Weapon_Shotgun.Double", 
	reload = "Weapon_Shotgun.Reload",
	reload_finish = "Weapon_Shotgun.Special1"
}

SWEP.Primary = {
	Ammo = "Buckshot_HL",
	ClipSize = 8,
	DefaultClip = 20,
	Bullets = game.SinglePlayer() and 6 or 4,
	Cooldown = 0.75,
	InterruptReload = true,
	PunchAngle = Angle(-5, 0, 0),
	Spread = game.SinglePlayer() and VECTOR_CONE_10DEGREES or Vector( 0.08716, 0.04362, 0 ) // 10 degrees by 5 degrees
}

SWEP.Secondary = {
	FireUnderwater = false,
	Cooldown = 1.5,
	Bullets = game.SinglePlayer() and 12 or 8,
	InterruptReload = true,
	PunchAngle = Angle(-10, 0, 0)
}

SWEP.SingleReload = {
	Enable = true
}

SWEP.UseClip1ForSecondary = true
SWEP.EmptyCooldown = 0.75

if ( CLIENT ) then
	SWEP.Category = "Half-Life: Source"
end

--- GSBase
function SWEP:GetActivitySuffix( sActivity, iIndex )
	if ( sActivity == "idle" ) then
		if ( self.m_tDryFire[iIndex] and BaseClass.GetActivitySuffix( self, sActivity, iIndex ) == "empty" ) then
			return "empty"
		end
		
		random.SetSeed( self:GetOwner():GetMD5Seed() % 0x100 )
		local flRand = random.RandomFloat(0, 1)
		
		if ( flRand > 0.95 ) then
			return "alt"
		end
		
		if ( flRand > 0.8 ) then
			return ""
		end
		
		return "alt2"
	end
	
	return BaseClass.GetActivitySuffix( self, sActivity, iIndex )
end

function SWEP:SecondaryAttack()
	if ( self:Clip1() == 1 ) then
		self:Reload()
		
		return false
	end
	
	if ( self:CanSecondaryAttack() ) then
		self:Shoot( true, 0, 2 )
		
		return true
	end
	
	return false
end
