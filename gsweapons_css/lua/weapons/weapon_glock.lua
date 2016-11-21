SWEP.Base = "weapon_csbase_pistol"

SWEP.PrintName = "#CStrike_Glock"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Activities = {
	burst = ACT_INVALID -- The glock plays the burst activity once
}

SWEP.Sounds = {
	shoot = "Weapon_Glock.Single"
}

SWEP.Primary = {
	Ammo = "9mm",
	ClipSize = 20,
	DefaultClip = 140,
	Damage = 25,
	RangeModifier = 0.75,
	Spread = Vector(0.1, 0.1),
	SpreadAir = Vector(1, 1),
	SpreadMove = Vector(0.165, 0.165),
	SpreadCrouch = Vector(0.075, 0.075)
}

SWEP.Secondary = {
	Cooldown = 0.3,
	Damage = 18,
	RangeModifier = 0.9,
	Spread = Vector(0.3, 0.3),
	SpreadAir = Vector(1.2, 1.2),
	SpreadMove = Vector(0.185, 0.185),
	SpreadCrouch = Vector(0.095, 0.095)
}

SWEP.Burst = {
	SingleActivity = true
}

SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.275,
	Time = 0.325,
	Min = 0.6
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'c'
	SWEP.SelectionIcon = 'c'
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:ToggleBurst(0)
		
		return true
	end
	
	return false
end

local BaseClass = baseclass.Get( SWEP.Base )

function SWEP:PlayActivity( sActivity, iIndex, flRate, bStrictPrefix, bStrictSuffix )
	return BaseClass.PlayActivity( self, sActivity == "shoot" and self:BurstEnabled( iIndex ) and self:GetShootClip( true ) ~= 0 and "altfire" or sActivity, iIndex, flRate, bStrictPrefix, bStrictSuffix )
end
