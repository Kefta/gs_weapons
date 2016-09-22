DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "CSBase"
SWEP.Spawnable = false

SWEP.ViewModelFlip = true

SWEP.Primary = {
	BobScale = CLIENT and 0.8 or nil,
	SwayScale = CLIENT and 0.5 or nil
}

SWEP.UnderwaterCooldown = 0.15

if ( CLIENT ) then
	SWEP.KillIcon = 'C'
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIconFont = "CSSKillIcon"
	SWEP.SelectionIcon = 'D'
	SWEP.SelectionFont = "CSSSelection"
	
	SWEP.BobStyle = "css"
	SWEP.CrosshairStyle = "css"
	
	surface.CreateFont( "CSSKillIcon", { font = "csd", size = ScreenScale(30), weight = 500, additive = true })
	surface.CreateFont( "CSSSelection", { font = "cs", size = ScreenScale(120), weight = 500, additive = true })
end

local PLAYER = _R.Player

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
	self.FireFunction = PLAYER.FireCSBullets
	self.PunchDecayFunction = PLAYER.CSDecayPunchAngle
end

function SWEP:CanPrimaryAttack()
	if ( self:GetNextPrimaryFire() == -1 ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return false
	end
	
	if ( self:EventActive( "reload" )) then
		if ( self.SingleReload.Enabled and self.SingleReload.QueuedFire ) then
			local flNextTime = self:SequenceEnd()
			self:RemoveEvent( "reload" )
			
			self:AddEvent( "fire", flNextTime, function()
				self:PrimaryAttack()
				
				return true
			end )
			
			flNextTime = CurTime() + flNextTime + 0.1
			self:SetNextPrimaryFire( flNextTime )
			self:SetNextSecondaryFire( flNextTime )
			self:SetNextReload( flNextTime )
			
			return false
		elseif ( self.Primary.InterruptReload ) then
			self:SetNextReload( CurTime() - 0.1 )
			self:RemoveEvent( "reload" )
		else
			return false
		end
	end
	
	-- In CS:S weapons, water has priority over the clip
	if ( not self.Primary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( false )
		
		return false
	end
	
	local iClip = self:Clip1()
	
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip1() ~= -1 and pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( false )
		
		return false
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
	
	if ( self:EventActive( "reload" )) then
		if ( self.SingleReload.Enabled and self.SingleReload.QueuedFire ) then
			local flNextTime = self:SequenceEnd()
			self:RemoveEvent( "reload" )
			
			self:AddEvent( "fire", flNextTime, function()
				self:SecondaryAttack()
				
				return true
			end )
			
			flNextTime = CurTime() + flNextTime + 0.1
			self:SetNextPrimaryFire( flNextTime )
			self:SetNextSecondaryFire( flNextTime )
			self:SetNextReload( flNextTime )
			
			return false
		elseif ( self.Secondary.InterruptReload ) then
			self:SetNextReload( CurTime() - 0.1 )
			self:RemoveEvent( "reload" )
		else
			return false
		end
	end
	
	if ( not self.Secondary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( true )
		
		return false
	end
	
	local iClip = self:Clip2()
	
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip2() ~= -1 and pPlayer:GetAmmoCount( self:GetSecondaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( true )
		
		return false
	end
	
	return true
end
