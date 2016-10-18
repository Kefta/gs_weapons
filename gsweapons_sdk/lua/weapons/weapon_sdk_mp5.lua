DEFINE_BASECLASS( "weapon_sdk_base" )

--- GSBase
SWEP.PrintName = "#SDK_MP5"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
SWEP.HoldType = "smg"

SWEP.Weight = 25

SWEP.Activities = {
	primary = {
		ACT_VM_PRIMARYATTACK,
		idle = 5
	}
}

SWEP.Sounds = {
	primary = "Weapon_MP5Navy.Single"
}

SWEP.Primary = {
	ClipSize = 30,
	DefaultClip = 60,
	Damage = 26,
	Cooldown = 0.075,
	Spread = {
		Base = 0.01,
		Air = 0.05
	}
}

SWEP.EmptyCooldown = 0.2

if ( CLIENT ) then
	SWEP.Category = "Source"
	SWEP.KillIcon = 'x'
	SWEP.SelectionIcon = 'x'
end

--- SDKBase
function SWEP:GetSpread( bSecondary )
	if ( not self:GetOwner():OnGround() ) then
		if ( bSecondary ) then
			local flSpecial = self.Secondary.Spread.Air
			
			if ( flSpecial ~= -1 ) then
				return flSpecial
			end
		end
		
		return self.Primary.Spread.Air
	end
	
	return BaseClass.GetSpread( self, bSecondary )
end
