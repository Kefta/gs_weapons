DEFINE_BASECLASS( "weapon_hl2mp_machinegun" )

--- GSBase
SWEP.PrintName = "#HL2_Pulse_Rifle"
SWEP.Spawnable = true
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.HoldType = "ar2"

SWEP.Weight = 5

SWEP.Sounds = {
	reload = "Weapon_AR2.Reload",
	empty = "Weapon_AR2.Empty",
	primary = "Weapon_AR2.Single"
}

SWEP.Primary = {
	Ammo = "AR2",
	ClipSize = 30,
	DefaultClip = 90,
	Cooldown = 0.1,
	Damage = 11,
	Spread = VECTOR_CONE_3DEGREES
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = 'l'
	SWEP.SelectionIcon = 'l'
end

--- HL2MPBase_MachineGun
SWEP.PunchAngle = {
	VerticalKick = 8,
	SlideLimit = 5
}

function SWEP:ItemFrame()
	BaseClass.ItemFrame( self )
	
	local pViewModel = self:GetOwner():GetViewModel()
	
	if ( pViewModel ~= NULL ) then
		-- Fix; replace all Lerps, Remaps, Clamps, maxs, and mins
		pViewModel:SetPoseParameter( "VentPoses", math.Remap( self.dt.ShotsFired, 0, 5, 0, 1 ))
	end
end

function SWEP:DoImpactEffect( tr )
	if ( IsFirstTimePredicted() ) then
		local data = EffectData()
			data:SetOrigin( tr.HitPos + tr.HitNormal )
			data:SetNormal( tr.HitNormal )
		util.Effect( "AR2Impact", data )
	end
end
