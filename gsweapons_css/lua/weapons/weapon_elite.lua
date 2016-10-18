DEFINE_BASECLASS( "weapon_csbase_pistol" )

--- GSBase
SWEP.PrintName = "#CStrike_Elites"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.HoldType = "duel"

SWEP.Activities = {
	primary_empty_left = ACT_VM_DRYFIRE_LEFT,
	idle_empty_left = ACT_VM_IDLE_EMPTY_LEFT
}

SWEP.Sounds = {
	primary = "Weapon_Elite.Single"
}

SWEP.Primary = {
	Ammo = "9mmRound_CSS",
	ClipSize = 30,
	DefaultClip = 150,
	Damage = 45,
	Cooldown = 0.12,
	RangeModifier = 0.75,
	Spread = {
		Base = 0.1,
		Air = 1.3,
		Move = 0.175,
		Crouch = 0.08
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 's'
	SWEP.SelectionIcon = 's'
	
	SWEP.CSSCrosshair = {
		Min = 4
	}
end

--- CSBase_Pistol
SWEP.Accuracy = {
	Base = 0.88,
	Decay = 0.275,
	Time = 0.325,
	Min = 0.55
}

--- GSBase
-- Right and left pistols
function SWEP:PlayActivity( sActivity, iIndex, flRate )
	if ( iIndex == 0 and sActivity == "primary" ) then
		return BaseClass.PlayActivity( self, self:Clip1() % 2 == 0 and "secondary" or sActivity, iIndex, flRate )
	end
	
	return BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
end

function SWEP:GetActivitySuffix( sActivity, iIndex )
	if ( iIndex == 0 and self:Clip1() == 1 ) then
		return "empty_left"
	end
	
	return BaseClass.GetActivitySuffix( self, sActivity, iIndex )
end

function SWEP:GetMuzzleAttachment( iEvent --[[= 5001]] )
	return self:Clip1() % 2 == 0 and BaseClass.GetMuzzleAttachment( self, iEvent ) or BaseClass.GetMuzzleAttachment( self, iEvent ) + 1
end
	