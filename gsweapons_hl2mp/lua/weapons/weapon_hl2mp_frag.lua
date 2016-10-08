DEFINE_BASECLASS( "weapon_hl2mp_base" )

SWEP.PrintName = "#HL2MP_Grenade"
SWEP.Spawnable = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.HoldType = "grenade"

SWEP.Primary = {
	Ammo = "grenade",
	DefaultClip = 1,
	Automatic = false
}

SWEP.Weight = 1

if ( SERVER ) then
	SWEP.Grenade = {
		Radius = 250
	}
else
	SWEP.Category = "Half-Life 2 MP"
	SWEP.SelectionIcon = 'k'
end

function SWEP:PrimaryAttack()
	if ( not self:CanPrimaryAttack() ) then
		return false
	end
	
	self:Throw()
	
	return true
end

if ( SERVER ) then
	function SWEP:EmitGrenade( iLevel )
		local pGrenade = BaseClass.EmitGrenade( self, iLevel )
		
		if ( pGrenade ~= NULL ) then
			local tGrenade = self.Grenade
			local pPhysObj = pGrenade:GetPhysicsObject()
		
			if ( pPhysObj ~= NULL ) then
				local pPlayer = self:GetOwner()
				
				if ( pPlayer:GetSaveTable()["m_lifeState"] ~= 0 ) then
					pPhysObj:AddVelocity( pPlayer:_GetVelocity() )
				end
			end
		end
		
		return pGrenade
	end
end
