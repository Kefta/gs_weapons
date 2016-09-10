-- FIXME: Lowercase event names?
DEFINE_BASECLASS( "basehl2mpcombatweapon" )

--- GSBase
SWEP.PrintName = "#HL2_Pistol"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 2

SWEP.Activities = {
	primary2 = ACT_VM_RECOIL1,
	primary3 = ACT_VM_RECOIL2,
	primary4 = ACT_VM_RECOIL3,
	dryfire = ACT_VM_DRYFIRE
}

SWEP.Sounds = {
	reload = "Weapon_Pistol.Reload",
	empty = "Weapon_Pistol.Empty",
	primary = "Weapon_Pistol.Single"
}

SWEP.Damage = 8

SWEP.Primary = {
	Ammo = "Pistol",
	ClipSize = 18,
	DefaultClip = 36,
	Cooldown = 0.5,
	Spread = VECTOR_CONE_1DEGREES
}

SWEP.Secondary.Spread = VECTOR_CONE_6DEGREES

if ( CLIENT ) then
	SWEP.Category = "Half-Life 2 MP"
	SWEP.KillIcon = 'd'
	SWEP.SelectionIcon = 'd'
end

--- Pistol
SWEP.Refire = 0.1
SWEP.AccuracyPenalty = 0.2 // Applied amount of time each shot adds to the time we must recover from
SWEP.MaxAccuracyPenalty = 1.5 // Maximum penalty to deal out

--- GSBase
function SWEP:SetupDataTables()
	BaseClass.SetupDataTables( self )
	
	self:DTVar( "Int", 1, "NumShotsFired" )
	self:DTVar( "Float", 5, "LastAttackTime" )
	self:DTVar( "Float", 6, "AccuracyPenalty" )
end

function SWEP:ItemFrame()
	if ( not self:GetOwner():KeyDown( IN_ATTACK )) then
		local flCurTime = CurTime()
		
		if ( self.dt.LastAttackTime + self.Refire < flCurTime ) then
			local flAccuracyPenalty = self.dt.AccuracyPenalty - FrameTime()
			
			if ( flAccuracyPenalty < 0 ) then
				self.dt.AccuracyPenalty = 0
			elseif ( flAccuracyPenalty > self.MaxAccuracyPenalty ) then
				self.dt.AccuracyPenalty = self.MaxAccuracyPenalty
			else
				self.dt.AccuracyPenalty = flAccuracyPenalty
			end
			
			if ( not self:EventActive( "Reload" )) then
				self:SetNextPrimaryFire( flCurTime - self.Refire )
			end
		end
	end
end

function SWEP:ShootBullets( tbl, bSecondary, iClipDeduction )
	BaseClass.ShootBullets( self, tbl, bSecondary, iClipDeduction )
	
	local flCurTime = CurTime()
	
	if ( flCurTime - self.dt.LastAttackTime > self:GetCooldown() ) then
		self:GetOwner():SetShotsFired(1) -- FIX
	end
	
	self.dt.LastAttackTime = flCurTime
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

function SWEP:PlayActivity( sActivity, iIndex, flRate )
	if ( sActivity == "primary" and self:Clip1() ~= 0 ) then
		local iShotsFired = self:GetOwner():GetShotsFired()
		
		return BaseClass.PlayActivity( self, iShotsFired == 1 and "primary" or iShotsFired == 2 and "primary2" or iShotsFired == 3 and "primary3" or "primary4", iIndex, flRate )
	end
	
	return BaseClass.PlayActivity( self, sActivity, iIndex, flRate )
end

--- HL2MPBase
function SWEP:GetSpread()
	return LerpVector( math.Remap( self.dt.AccuracyPenalty, 0, self.MaxAccuracyPenalty, 0, 1 ), BaseClass.GetSpread( self, false ), BaseClass.GetSpread( self, true ))
end
