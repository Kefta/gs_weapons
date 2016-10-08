DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.PrintName = "CSBase"

SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 90

SWEP.Primary = {
	BobScale = CLIENT and 0.8 or nil,
	SwayScale = CLIENT and 0.5 or nil
}

SWEP.UnderwaterCooldown = 0.15

// Override the bloat that our base class sets as it's a little bit bigger than we want.
// If it's too big, you drop a weapon and its box is so big that you're still touching it
// when it falls and you pick it up again right away.
SWEP.TriggerBoundSize = 30

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIconFont = "CSSKillIcon"
	SWEP.SelectionFont = "CSSSelection"
	
	SWEP.BobStyle = "css"
	SWEP.CrosshairStyle = "css"
end

local PLAYER = FindMetaTable( "Player" )

function SWEP:Initialize()
	BaseClass.Initialize( self )
	
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
	
	local iClip = self:Clip1()
	local iWaterLevel = pPlayer:WaterLevel()
	
	if ( self:EventActive( "reload" )) then
		if ( self.SingleReload.Enable and self.SingleReload.QueuedFire ) then
			local flNextTime = self:SequenceEnd(0)
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
		elseif ( self.Primary.InterruptReload and iClip ~= 0 and (self.Primary.FireUnderwater or iWaterLevel ~= 3) ) then
			self:SetNextReload( CurTime() - 0.1 )
			self:RemoveEvent( "reload" )
		else
			return false
		end
	end
	
	-- In CS:S weapons, water has priority over the clip
	if ( not self.Primary.FireUnderwater and iWaterLevel == 3 ) then
		self:HandleFireUnderwater( false )
		
		return false
	end
	
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
	
	local iClip = self.UseClip1ForSecondary and self:Clip1() or self:Clip2()
	local iWaterLevel = pPlayer:WaterLevel()
	local bEmpty = pPlayer:GetAmmoCount( self.UseClip1ForSecondary and self:GetPrimaryAmmoName() or self:GetSecondaryAmmoName() ) == 0
	
	if ( self:EventActive( "reload" )) then
		if ( self.SingleReload.Enable and self.SingleReload.QueuedFire ) then
			local flNextTime = self:SequenceEnd(0)
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
		elseif ( self.Secondary.InterruptReload and iClip ~= 0 and (iClip ~= -1 or not bEmpty)
		and (self.Secondary.FireUnderwater or iWaterLevel ~= 3) ) then
			self:SetNextReload( CurTime() - 0.1 )
			self:RemoveEvent( "reload" )
		else
			return false
		end
	end
	
	if ( not self.Secondary.FireUnderwater and iWaterLevel == 3 ) then
		self:HandleFireUnderwater( true )
		
		return false
	end
	
	if ( iClip == 0 or iClip == -1 and bEmpty and (self.UseClip1ForSecondary and self:GetDefaultClip1() or self:GetDefaultClip2()) ~= -1 ) then
		self:HandleFireOnEmpty( true )
		
		return false
	end
	
	return true
end

-- Punch angles get more influence with CS:S weapons
function SWEP:GetShootAngles()
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + 2 * pPlayer:GetViewPunchAngles()
end
