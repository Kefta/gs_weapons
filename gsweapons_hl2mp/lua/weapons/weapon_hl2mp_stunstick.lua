DEFINE_BASECLASS( "weapon_hl2mpbase_bludgeon" )

SWEP.PrintName = "HL2MP_StunBaton"
SWEP.Spawnable = true

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.ViewModel = "models/weapons/v_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunstick.mdl"
SWEP.HoldType = "melee"

SWEP.Activities = {
	idle_empty = ACT_VM_FIDGET
}

SWEP.Sounds = {
	hit = "Weapon_StunStick.Melee_Hit",
	hitworld = "Weapon_StunStick.Melee_HitWorld",
	miss = "Weapon_StunStick.Melee_Miss"
	--"single_shot"		"Weapon_StunStick.Swing"
}

SWEP.Primary = {
	Damage = 40,
	Range = 75,
	Cooldown = 0.8
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	
	SWEP.SelectionIcon = 'n'
	SWEP.KillIcon = 'n'
end

function SWEP:DoImpactEffect( tr )
	local data = EffectData()
		data:SetNormal( tr.HitNormal )
		data:SetOrigin( tr.HitPos + tr.HitNormal * 4 )
	util.Effect( "StunstickImpact", data )
end
