game.AddAmmoType({
	name = "Health",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
})

SWEP.Base = "weapon_gs_base"

SWEP.PrintName = "#GSMisc_MedKit"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.HoldType = "slam"

-- Giving DefaultClip ammo while leaving the clip as -1 will not display a reserve on the ammo counter
SWEP.Primary = {
	Ammo = "Health",
	DefaultClip = 100,
	Range = 90,
	Cooldown = 0.2
}

SWEP.Secondary.Cooldown = 0.5

SWEP.Sounds = {
	primary = "hl1/fvox/boop.wav",
	reload = {
		sound = {
			"npc_citizen.health01",
			"npc_citizen.health02",
			"npc_citizen.health03",
			"npc_citizen.health04",
			"npc_citizen.health05"
		}
	}
}

SWEP.CheckClip1ForSecondary = true

SWEP.TauntTime = 2
SWEP.RegenRate = 0.5

if ( CLIENT ) then
	SWEP.Category = "GSWeapons Miscellaneous"
else
	SWEP.MaxClip = 100
end

function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack() ) then
		local pPlayer = self:GetOwner()
		--pPlayer:LagCompensation( true )
		local tr = pPlayer:GetEyeTrace()
		--pPlayer:LagCompensation( false )
		
		local pEntity = tr.Entity
		
		if ( (pEntity:IsPlayer() or pEntity:IsNPC()) and self:GetShootSrc():DistToSqr( tr.HitPos ) <= self:GetSpecialKey( "Range", false ) ^ 2 ) then
			local iHealth = pEntity:Health()
			
			if ( iHealth < pEntity:GetMaxHealth() ) then
				pEntity:SetHealth( iHealth + 1 )
				self:PlaySound( "primary" )
				pPlayer:RemoveAmmo( 1, self:GetPrimaryAmmoName() )
			end
		end
		
		local flNextTime = CurTime() + self:GetSpecialKey( "Cooldown", false )
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		
		return true
	end
	
	return false
end

function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack(0) ) then
		local pPlayer = self:GetOwner()
		local iHealth = pPlayer:Health()
		
		if ( iHealth < pPlayer:GetMaxHealth() ) then
			pPlayer:SetHealth( iHealth + 1 )
			self:PlaySound( "primary" )
			pPlayer:RemoveAmmo( 1, self:GetPrimaryAmmoName() )
		end
		
		local flNextTime = CurTime() + self:GetSpecialKey( "Cooldown", true )
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		
		return true
	end
	
	return false
end

function SWEP:CanReload()
	local flNextReload = self:GetNextReload()
	
	return not (flNextReload == -1 or flNextReload > CurTime())
end

function SWEP:Reload()
	if ( self:CanReload() ) then
		self:PlaySound( "reload" )
		self:SetNextReload(-1)
		
		self:AddEvent( "taunt", 0, function()
			if ( not self:GetOwner():KeyDown( IN_RELOAD )) then
				self:SetNextReload( CurTime() + self.TauntTime )
				
				return true
			end
		end )
		
		return true
	end
	
	return false
end

if ( SERVER ) then
	function SWEP:ItemFrame()
		local pPlayer = self:GetOwner()
		
		if ( pPlayer:MouseLifted() ) then
			local sAmmo = self:GetPrimaryAmmoName()
			
			if ( pPlayer:GetAmmoCount( sAmmo ) < self.MaxClip ) then
				pPlayer:GiveAmmo( 1, sAmmo, true )
			end
		end
		
		self:SetNextItemFrame( CurTime() + self.RegenRate )
	end
end
