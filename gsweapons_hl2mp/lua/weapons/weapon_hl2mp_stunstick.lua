DEFINE_BASECLASS( "weapon_hl2mpbase_bludgeon" )

SWEP.Primary = {
	Damage = 40,
	Range = 75,
	Cooldown = 0.8
}

function SWEP:DoImpactEffect( tr )
	local data = EffectData()
		data:SetNormal( tr.HitNormal )
		data:SetOrigin( tr.HitPos + tr.HitNormal * 4 )
	util.Effect( "StunstickImpact", data )
end
