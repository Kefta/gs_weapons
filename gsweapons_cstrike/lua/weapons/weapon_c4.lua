DEFINE_BASECLASS( "weapon_cs_base" )

--- GSBase
SWEP.PrintName = "#CStrike_C4"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.HoldType = "slam"

SWEP.Primary.Cooldown = 10

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'I'
	SWEP.SelectionIcon = 'C'
	
	SWEP.CSSCrosshair = {
		Min = 6
	}
	
	SWEP.EventStyle = {
		[7001] = "" -- Plays on deploy for no reason
	}
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		self:GetOwner():ChatPrint( "No primary attack implemented!" )
		self:SetNextPrimaryFire( CurTime() + self:GetCooldown( false ))
		
		return true
	end
	
	return false
end
