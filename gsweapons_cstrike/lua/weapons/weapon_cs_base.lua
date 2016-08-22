DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "CSBase"
SWEP.Spawnable = false

SWEP.ViewModelFlip = true

SWEP.FireFunction = _R.Player.FireCSBullets
SWEP.UnderwaterCooldown = 0.15

if ( CLIENT ) then
	SWEP.KillIcon = 'C'
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIconFont = "CStrikeKillIcon"
	SWEP.SelectionIcon = 'D'
	SWEP.SelectionFont = "CStrikeSelection"
	
	SWEP.BobStyle = "cstrike"
	SWEP.CrosshairStyle = "cstrike"
	
	surface.CreateFont( "CStrikeKillIcon", { font = "csd", size = ScreenScale(30), weight = 500, additive = true })
	surface.CreateFont( "CStrikeSelection", { font = "cs", size = ScreenScale(120), weight = 500, additive = true })
end

function SWEP:CanPrimaryAttack()
	if ( self:GetNextPrimaryFire() == -1 ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	-- Make sure player is at least valid for the methods below
	if ( pPlayer == NULL ) then
		return false
	end
	
	-- CS:S gives priority to water over empty clip
	if ( not self.Primary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( false )
		
		return false
	end
	
	if ( self:Clip1() == 0 ) then
		self:HandleFireOnEmpty( false )
		
		return false
	end
	
	local flCurTime = CurTime()
	local flNextReload = self:GetNextReload()
	
	if ( flNextReload == -1 or flNextReload > flCurTime ) then
		if ( self.Primary.InterruptReload ) then
			self:SetNextReload( flCurTime )
			self:RemoveEvent( "Reload" )
		else
			return false
		end
	end
	
	return true
end

function SWEP:CanSecondaryAttack()
	if ( self:GetNextSecondaryFire() == -1 ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return false
	end
	
	if ( not self.Secondary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( true )
		
		return false
	end
	
	if ( self:Clip2() == 0 ) then
		self:HandleFireOnEmpty( true )
		
		return false
	end
	
	local flCurTime = CurTime()
	local flNextReload = self:GetNextReload()
	
	if ( flNextReload == -1 or flNextReload > flCurTime ) then
		if ( self.Secondary.InterruptReload ) then
			self:SetNextReload( flCurTime )
			self:RemoveEvent( "Reload" )
		else
			return false
		end
	end
	
	return true
end
