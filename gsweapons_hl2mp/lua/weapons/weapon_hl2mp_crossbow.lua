DEFINE_BASECLASS( "weapon_hl2mp_base" )

SWEP.PrintName = "HL2MP_Crossbow"
SWEP.Spawnable = true

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.HoldType = "crossbow"

SWEP.Activities = {
	idle_empty = ACT_VM_FIDGET
}

SWEP.Sounds = {
	primary = "Weapon_Crossbow.Single",
	reload = "Weapon_Crossbow.Reload",
	zoom = ""
	-- "Weapon_Crossbow.BoltElectrify"
	-- "Weapon_Crossbow.BoltFly"
}

SWEP.Weight = 6

SWEP.Primary = {
	Ammo = "XBowBolt",
	ClipSize = 1,
	DefaultClip = 6,
	Damage = 100,
	PunchAngle = Angle(-2, 0, 0)
}

SWEP.Secondary.Automatic = false

SWEP.Zoom = {
	FOV = {
		20
	},
	Times = {
		[0] = 0.2,
		0.1
	},
	Levels = 1,
	Cooldown = 0,
	UnzoomOnReload = false
}

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	
	SWEP.SelectionIcon = 'g'
	SWEP.KillIcon = 'g'
end

function SWEP:SharedDeploy( bDelayed )
	if ( self:Clip1() == 0 ) then
		local pViewModel = self:GetOwner():GetViewModel(0)
		
		if ( pViewModel ~= NULL ) then
			pViewModel:SetSkin(1)
		end
	end
	
	BaseClass.SharedDeploy( self, bDelayed )
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack(0) ) then
		self:FireBolt( false, 0 )
		
		local pViewModel = self:GetOwner():GetViewModel(0)
		
		if ( pViewModel ~= NULL ) then
			pViewModel:SetSkin(0)
		end
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		self:AdvanceZoom(0)
		
		return true
	end
	
	return false
end

function SWEP:SharedHolster( pSwitchingTo, bDelayed )
	BaseClass.SharedHolster( self, pSwitchingTo, bDelayed )
	
	local pPlayer = self:GetOwner()
	
	if ( pPlayer ~= NULL ) then
		local pViewModel = pPlayer:GetViewModel(0)
		
		if ( pViewModel ~= NULL ) then
			pViewModel:SetSkin(0)
		end
	end
end
