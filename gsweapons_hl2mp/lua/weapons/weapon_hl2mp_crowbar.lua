DEFINE_BASECLASS( "weapon_hl2mpbase_bludgeon" )

--- GSBase
SWEP.PrintName = "#HL2MP_Crowbar"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"

SWEP.Primary = {
	Damage = 25,
	Range = 75,
	Cooldown = 0.4
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	
	SWEP.SelectionIcon = 'c'
	SWEP.KillIcon = 'c'
end

--[[function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	pPlayer:ViewPunch( Angle( pPlayer:SharedRandomFloat( "crowbarpax", 1, 2 ),
		pPlayer:SharedRandomFloat( "crowbarpay", -2, -1 ), 0 ))
end]]
