SWEP.Base = "weapon_csbase_pistol"

SWEP.PrintName = "#CStrike_Elites"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"
SWEP.DroppedModel = "models/weapons/w_pist_elite_dropped.mdl"
-- Single version: "models/weapons/w_pist_elite_single.mdl"
SWEP.HoldType = "duel"

SWEP.Activities = {
	shoot_empty_left = ACT_VM_DRYFIRE_LEFT,
	idle_empty_left = ACT_VM_IDLE_EMPTY_LEFT
}

SWEP.Sounds = {
	shoot = "Weapon_Elite.Single"
}

SWEP.Primary = {
	Ammo = "9mm",
	ClipSize = 30,
	DefaultClip = 150,
	Damage = 45,
	Cooldown = 0.12,
	RangeModifier = 0.75,
	Spread = Vector(0.1, 0.1),
	SpreadAir = Vector(1.3, 1.3),
	SpreadMove = Vector(0.175, 0.175),
	SpreadCrouch = Vector(0.08, 0.08)
}

SWEP.Accuracy = {
	Base = 0.88,
	Decay = 0.275,
	Time = 0.325,
	Min = 0.55
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 's'
	SWEP.SelectionIcon = 's'
	
	SWEP.CSSCrosshair = {
		Min = 4
	}
end

local BaseClass = baseclass.Get( SWEP.Base )

-- Right and left pistols
function SWEP:PlayActivity( Activity, iIndex --[[= 0]], flRate --[[= 1]], bStrictPrefix --[[= false]], bStrictSuffix --[[= false]] )
	if ( iIndex == 0 and Activity == "shoot" ) then
		local iClip = self:GetShootClip( self:SpecialActive() )
		
		return BaseClass.PlayActivity( self, iClip ~= 0 and iClip % 2 == 0 and "altfire" or Activity, iIndex, flRate )
	end
	
	return BaseClass.PlayActivity( self, Activity, iIndex, flRate, bStrictPrefix, bStrictSuffix )
end

function SWEP:GetActivitySuffix( sActivity, iIndex )
	if ( iIndex == 0 and self:GetShootClip( self:SpecialActive() ) == 1 ) then
		return "empty_left"
	end
	
	return BaseClass.GetActivitySuffix( self, sActivity, iIndex )
end

function SWEP:GetMuzzleAttachment( iEvent --[[= 5001]] )
	return self:GetShootClip( self:SpecialActive() ) % 2 == 0 and BaseClass.GetMuzzleAttachment( self, iEvent ) or BaseClass.GetMuzzleAttachment( self, iEvent ) + 1
end
	