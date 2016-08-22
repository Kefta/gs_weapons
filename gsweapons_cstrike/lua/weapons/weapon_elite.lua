DEFINE_BASECLASS( "weapon_csbase_pistol" )

--- GSBase
SWEP.PrintName = "#CStrike_Elites"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.HoldType = "duel"

SWEP.Activities = {
	dryfire = ACT_VM_DRYFIRE,
	secondary_dryfire = ACT_VM_DRYFIRE_LEFT,
	secondary_idle = ACT_VM_IDLE_EMPTY_LEFT
}

SWEP.Sounds = {
	primary = "Weapon_Elite.Single"
}

SWEP.Primary = {
	Ammo = "9mmRound_CStrike",
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
function SWEP:PlayIdle()
	return self:PlayActivity( self:Clip1() == 1 and "secondary_idle" or "idle" )
end

-- Right and left pistols
function SWEP:PlayActivity( sActivity )
	if ( sActivity == "primary" ) then
		local iClip = self:Clip1()
		
		return BaseClass.PlayActivity( self, iClip == 1 and "secondary_dryfire" or iClip == 0 and "dryfire" or iClip % 2 == 0 and "secondary" or sActivity )
	end
	
	return BaseClass.PlayActivity( self, sActivity )
end

function SWEP:GetMuzzleAttachment( iEvent --[[= 5001]] )
	return self:Clip1() % 2 == 0 and BaseClass.GetMuzzleAttachment( self, iEvent ) or BaseClass.GetMuzzleAttachment( self, iEvent ) + 1
end
	