DEFINE_BASECLASS( "weapon_csbase_pistol" )

--- GSBase
SWEP.PrintName = "#CStrike_Glock"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Activities = {
	burst = ACT_INVALID -- The glock plays the burst activity once
}

SWEP.Sounds = {
	primary = "Weapon_Glock.Single"
}

SWEP.Primary = {
	Ammo = "9mmRound_CSS",
	ClipSize = 20,
	DefaultClip = 140,
	Damage = 25,
	RangeModifier = 0.75,
	Spread = {
		Base = 0.1,
		Air = 1,
		Move = 0.165,
		Crouch = 0.075
	}
}

SWEP.Secondary = {
	Cooldown = 0.3,
	Damage = 18,
	RangeModifier = 0.9,
	Spread = {
		Base = 0.3,
		Air = 1.2,
		Move = 0.185,
		Crouch = 0.095
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'c'
	SWEP.SelectionIcon = 'c'
end

--- CSBase_Pistol
SWEP.Accuracy = {
	Base = 0.9,
	Decay = 0.275,
	Time = 0.325,
	Min = 0.6
}
-- FIXME: Fix burst activities -- merge with primary? This is messy
--- GSBase
function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:ToggleBurst(0)
		
		return true
	end
	
	return false
end

function SWEP:PlayActivity( sActivity, iIndex, flRate )
	return BaseClass.PlayActivity( self, sActivity == "primary" and self:BurstEnabled() and self:Clip1() ~= 0 and "secondary" or sActivity, iIndex, flRate )
end
