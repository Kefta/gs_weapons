DEFINE_BASECLASS( "weapon_hl2mp_base" )

--- GSBase
SWEP.PrintName = "#HL2MP_Pistol"
SWEP.Spawnable = true
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 2

SWEP.Activities = {
	primary_empty = ACT_INVALID,
	primary2 = ACT_VM_RECOIL1,
	primary3 = ACT_VM_RECOIL2,
	primary4 = ACT_VM_RECOIL3,
	empty = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	reload = "Weapon_Pistol.Reload",
	empty = "Weapon_Pistol.Empty",
	primary = "Weapon_Pistol.Single"
}

SWEP.Primary = {
	Ammo = "Pistol",
	ClipSize = 18,
	DefaultClip = 36,
	Damage = 8,
	Cooldown = 0.5,
	Spread = VECTOR_CONE_1DEGREES
}

SWEP.Secondary.Spread = VECTOR_CONE_6DEGREES

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = '-'
	SWEP.SelectionIcon = 'd'
end

--- HL2MP_Pistol
SWEP.Refire = 0.1
SWEP.AccuracyPenalty = 0.2 // Applied amount of time each shot adds to the time we must recover from
SWEP.MaxAccuracyPenalty = 1.5 // Maximum penalty to deal out

--- GSBase
function SWEP:SetupDataTables()
	BaseClass.SetupDataTables( self )
	
	self:AddNWVar( "Bool", "DryFired", false )
	self:AddNWVar( "Bool", "MouseHeld", false )
	self:AddNWVar( "Int", "AnimLevel", false )
	self:AddNWVar( "Float", "AccuracyPenalty", false )
	self:AddNWVar( "Float", "LastAttackTime", false )
end

local bSinglePlayer = game.SinglePlayer()

function SWEP:SharedDeploy( bDelayed )
	BaseClass.SharedDeploy( self, bDelayed )
	
	if ( not bDelayed and (not bSinglePlayer or SERVER) ) then
		self.dt.DryFired = false
	end
end

function SWEP:ItemFrame()
	if ( (not bSinglePlayer or SERVER) and not self:GetOwner():KeyDown( IN_ATTACK )) then
		self.dt.MouseHeld = false
		local flCurTime = CurTime()
		
		if ( self.dt.LastAttackTime + self.Refire < flCurTime ) then
			local flAccuracyPenalty = self.dt.AccuracyPenalty - FrameTime()
			self.dt.AccuracyPenalty = flAccuracyPenalty < 0 and 0 or flAccuracyPenalty
			
			if ( not self:EventActive( "reload" )) then
				//Allow a refire as fast as the player can click
				self:SetNextPrimaryFire( flCurTime - 0.1 )
			end
		end
	end
end

function SWEP:Shoot( bSecondary --[[= false]], iIndex --[[= 0]], iClipDeduction --[[= 1]] )
	BaseClass.Shoot( self, bSecondary, iIndex, iClipDeduction )
	
	local flCurTime = CurTime()
	
	if ( flCurTime - self.dt.LastAttackTime > self:GetCooldown( bSecondary )) then
		self.dt.AnimLevel = 0
	else
		local iLevel = self.dt.AnimLevel
		
		-- Don't update the networked value if we don't need to
		if ( iLevel ~= 3 ) then
			self.dt.AnimLevel = iLevel + 1
		end
	end
	
	// Add an accuracy penalty which can move past our maximum penalty time if we're really spastic
	local flAccuracyPenalty = self.dt.AccuracyPenalty + self.AccuracyPenalty
	self.dt.AccuracyPenalty = flAccuracyPenalty > self.MaxAccuracyPenalty and self.MaxAccuracyPenalty or flAccuracyPenalty
	self.dt.LastAttackTime = flCurTime
	self.dt.DryFired = false
	self.dt.MouseHeld = true
end

function SWEP:SecondaryAttack()
	local flNextTime = CurTime() + self.Refire
	self.dt.LastAttackTime = flNextTime
	self:SetNextPrimaryFire( flNextTime )
end

function SWEP:Punch()
	local pPlayer = self:GetOwner()
	
	// Add it to the view punch
	pPlayer:ViewPunchReset()
	pPlayer:ViewPunch( Angle( pPlayer:SharedRandomFloat( "pistolpax", 0.25, 0.5 ),
		pPlayer:SharedRandomFloat( "pistolpay", -0.6, 0.6 ), 0 ))
end

function SWEP:HandleFireOnEmpty( bSecondary )
	self.dt.LastAttackTime = CurTime() + self.Refire
	
	if ( self.EmptyCooldown == -1 ) then
		BaseClass.HandleFireOnEmpty( self, bSecondary )
		
		return
	elseif ( self.dt.DryFired or not self.dt.MouseHeld ) then
		local pPlayer = self:GetOwner()
		
		if ( self.SwitchOnEmptyFire and not self:HasAmmo() ) then
			pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
			
			return
		end
		
		if ( bSecondary and self.Secondary.ReloadOnEmptyFire or not bSecondary and self.Primary.ReloadOnEmptyFire ) then
			self:SetNextReload(0)
			self:Reload()
			
			return
		end
	end
	
	self:PlaySound( "empty" )
	local bPlayed = self:PlayActivity( "empty" )
	self.dt.DryFired = true
	
	local flNextTime = CurTime() + (bPlayed and self:SequenceLength() or self.EmptyCooldown)
	self:SetNextPrimaryFire( flNextTime )
	self:SetNextSecondaryFire( flNextTime )
end

function SWEP:PlayActivity( sActivity, iIndex, flRate )
	if ( sActivity == "primary" ) then
		local iShotsFired = self.dt.AnimLevel
		
		return BaseClass.PlayActivity( self, iShotsFired == 0 and "primary" or iShotsFired == 1 and "primary2" or iShotsFired == 2 and "primary3" or "primary4", iIndex, flRate )
	end
	
	return BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
end

--- HL2MPBase
function SWEP:GetSpread()
	// We lerp from very accurate to inaccurate over time
	return LerpVector( math.Remap( self.dt.AccuracyPenalty, 0, self.MaxAccuracyPenalty, 0, 1 ), BaseClass.GetSpread( self, false ), BaseClass.GetSpread( self, true ))
end
