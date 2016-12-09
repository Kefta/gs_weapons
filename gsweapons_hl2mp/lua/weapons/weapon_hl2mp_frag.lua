SWEP.Base = "weapon_hl2mp_base"

SWEP.PrintName = "#HL2MP_Grenade"
SWEP.Spawnable = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.HoldType = "grenade"

SWEP.Weight = 1

SWEP.Primary = {
	Ammo = "grenade",
	DefaultClip = 1,
	Automatic = false
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.SelectionIcon = 'k'
else
	SWEP.Grenade = {
		Radius = 250
	}
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then	
		self:Throw( GRENADE_THROW, 0 )
		
		return true
	end
	
	return false
end

local BaseClass = baseclass.Get( SWEP.Base )

if ( SERVER ) then
	function SWEP:EmitGrenade( iLevel )
		local pGrenade = BaseClass.EmitGrenade( self, iLevel )
		
		if ( pGrenade ~= NULL ) then
			local tGrenade = self.Grenade
			local pPhysObj = pGrenade:GetPhysicsObject()
		
			if ( pPhysObj:IsValid() ) then
				local pPlayer = self:GetOwner()
				
				if ( pPlayer:GetSaveTable()["m_lifeState"] ~= 0 ) then
					pPhysObj:AddVelocity( pPlayer:_GetVelocity() )
				end
			end
		end
		
		return pGrenade
	end
end
