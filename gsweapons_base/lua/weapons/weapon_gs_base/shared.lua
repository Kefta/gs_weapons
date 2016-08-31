-- TODO: Lowering, ironsights, multiple view models expansion
-- http://wiki.garrysmod.com/page/Structures/SWEP

--- Base; this is the superclass
SWEP.Base = "weapon_gs_base"

--- Selection/Menu
SWEP.PrintName = "GSBase" -- Display name
SWEP.Author = "code_gs and Valve" -- This isn't used by default for weapon selection panels

SWEP.Spawnable = false -- Displays the weapon in the spawn menu. This must be defined in every weapon!
SWEP.AdminOnly = false -- Restricts weapon spawning to admin+

SWEP.Slot = 0 -- Key (minus one) to press to get to the weapon's category in the weapon selection 
SWEP.SlotPos = 0 -- Category in the weapon selection (minus one) this weapon appears in

--- Weapon demeanour
SWEP.ViewModel = "models/weapons/v_pistol.mdl" -- First-person model of the weapon
SWEP.ViewModelFlip = false -- Move the view model to the other side of the screen
SWEP.ShouldIdle = true -- Play idle animations on the first view model
SWEP.ViewModelFOV = 75 -- Field-of-view of the view model (how much the screen is stretched)
SWEP.UseHands = false -- If the gamemode supports it, show player model hands on the weapon (c_models only)

SWEP.ViewModel1 = "" -- Second first-person model: chaing this to anything besides an empty string will display it
SWEP.ViewModelFlip1 = false
SWEP.ShouldIdle1 = false

SWEP.ViewModel2 = ""
SWEP.ViewModelFlip2 = false
SWEP.ShouldIdle2 = false

SWEP.WorldModel = "models/weapons/w_pistol.mdl" -- Third-person view of the weapon
SWEP.SilencerModel = "" -- World model to use when the weapon is silenced
SWEP.HoldType = "pistol" -- How the player should hold the weapon in third-person http://wiki.garrysmod.com/page/Hold_Types
SWEP.m_WeaponDeploySpeed = 1 -- Speed of deployment. Can be negative
SWEP.HolsterAnimation = false -- Play an animation when the weapon is being holstered. Only works if the weapon has a holster animation

SWEP.Weight = 0 -- Weight in automatic weapon selection
-- There are two weapon switching algorithms:
-- *Singleplay (true) - Switch to the weapon with the highest weight
-- *Multiplay (false) - Try and find a weapon with the same weight, otherwise, fallback to highest
SWEP.HighWeightPriority = false

SWEP.Activities = { -- Default activity events
	primary = ACT_VM_PRIMARYATTACK,
	--dryfire = ACT_VM_DRYFIRE, -- Used when the last bullet in the clip is fired. Implement activity to use
	secondary = ACT_VM_SECONDARYATTACK,
	reload = ACT_VM_RELOAD,
	deploy = ACT_VM_DRAW,
	holster = ACT_VM_HOLSTER,
	idle = ACT_VM_IDLE,
	burst = ACT_VM_PRIMARYATTACK,
	-- For silencers
	s_primary = ACT_VM_PRIMARYATTACK_SILENCED,
	--s_dryfire = ACT_VM_DRYFIRE_SILENCED, -- Implement activity to use
	s_secondary = ACT_VM_DETACH_SILENCER,
	s_reload = ACT_VM_RELOAD_SILENCED,
	s_deploy = ACT_VM_DRAW_SILENCED,
	s_idle = ACT_VM_IDLE_SILENCED,
	-- For single reloading
	reload_start = ACT_SHOTGUN_RELOAD_START,
	reload_finish = ACT_SHOTGUN_RELOAD_FINISH,
	-- For melee weapons
	hit = ACT_VM_HITCENTER,
	miss = ACT_VM_MISSCENTER,
	-- For grenades
	pull = ACT_VM_PULLPIN,
	throw = ACT_VM_THROW
}

-- https://github.com/Facepunch/garrysmod-issues/issues/2346
SWEP.Sounds = { -- Default sound events
	--deploy = "sound.wav",
	--[[primary = {
		pitch = { 50, 100 },
		sound = "sound2.wav"
	}]]
	--secondary = "",
	--reload = "",
	--empty = "",
	--holster = "",
	-- For silencers
	--s_deploy = "",
	--s_primary = "",
	--s_secondary = "",
	--s_reload = "",
	--s_empty = "",
	--s_holster = "",
	-- For single reloading
	--reload_start = "",
	--reload_finish = "",
}

--- Weapon behaviour
SWEP.Primary = {
	Ammo = "", -- Ammo type declared by game.GetAmmoType or exists by default http://wiki.garrysmod.com/page/Default_Ammo_Types
	ClipSize = -1, -- Max amount of ammo in clip
	DefaultClip = -1, -- Amount of ammo weapon spawns with
	Automatic = true, -- Continously runs PrimaryAttack with the mouse held down
	Damage = 42, -- Bullet/melee damage // Douglas Adams 1952 - 2001
	Range = MAX_TRACE_LENGTH, -- Bullet/melee distance
	Cooldown = 0.15, -- Time between firing
	WalkSpeed = 1, -- Walk speed multiplier to use when the weapon is deployed
	RunSpeed = 1, -- Run speed multiplier to use when the weapon is deployed
	FireUnderwater = true, -- Allows firing underwater
	InterruptReload = false, -- Allows interrupting a reload to shoot
	BobScale = CLIENT and 1 or nil, -- Magnitude of the weapon bob
	SwayScale = CLIENT and 1 or nil -- Sway deviation
}

SWEP.Secondary = {
	Ammo = "",
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Damage = -1, -- -1 = off. Change to alter damage when the special fire is enabled
	Range = -1,
	Cooldown = -1,
	WalkSpeed = -1,
	RunSpeed = -1,
	FireUnderwater = true,
	InterruptReload = false,
	BobScale = CLIENT and -1 or nil,
	SwayScale = CLIENT and -1 or nil
}

SWEP.Burst = {
	Times = { -- Times between burst shots
		0.1, -- Time until first extra shot
		--0.1 -- Time until second extra shot; leave nil to fallback to the previous specified time
	},
	Count = 2, -- Number of extra shots to fire when burst is enabled
	Cooldown = 0.3 -- Cooldown between toggling bursts
}

SWEP.Zoom = {
	FOV = { -- FOVs for each zoom level
		55 -- FOV for first zoom level
	},
	Times = { -- Times betweeen zoom levels
		Fire = 0.1, -- Time to unzoom after firing
		Rezoom = 0.05, -- Time to rezoom after unzooming from fire
		[0] = 0.15, -- Time to reach the first zoom level
		0.2 -- Time to loop back to being unzoomed; leave nil to fallback to the zoom time in index 0
	},
	Levels = 1, -- Number of zoom levels
	Cooldown = 0.3, -- Cooldown between zooming
	UnzoomOnFire = false, -- Unzoom when the weapon is fired; rezooms after Primary/Secondary cooldown if the clip is not 0
	HideViewModel = false, -- Hide view model when zoomed
	DrawOverlay = CLIENT and false or nil, -- (Clientside) Draw scope overlay when zoomed
	ScopeStyle = "scope_cstrike" -- (Clientside) Style defined in crosshair.lua to use if DrawOverlay is set to true
}

SWEP.IronSights = {
	Pos = vector_origin, -- Position of the viewmodel in ironsights
	Ang = angle_zero, -- Angle of the viewmodel in ironsights
	ZoomTime = 1, -- Time it takes to move viewmodel in
	UnzoomTime = 1, -- Time it takes to move viewmodel out
	Hold = false, -- Require secondary fire key to be held to use ironsights as opposed to just toggling the state
	DrawCrosshair = false -- Draw crosshair when ironsights is active
}

SWEP.FireFunction = _R.Player.LuaFireBullets -- Fire function to use with ShootBullets when PhysicalBullets is false. Args are ( pPlayer, tFireBulletsInfo )
SWEP.PhysicalBullets = false -- Instead of using traces to simulate bullet firing, shoot a physical entity
SWEP.PhysicalBulletSpeed = 5000 -- Speed of bullet entity when fired
SWEP.SpecialType = 0 -- Sets what the secondary fire should do. Uses SPECIAL enums:
-- SPECIAL_SILENCE: Attaches silencer. Changes all sounds and animations to use the s_param version if available
-- SPECIAL_BURST: Toggles between single-shot and burst fire modes
-- SPECIAL_ZOOM: Zooms in the weapon by setting the player's FOV. Can have multiple levels
-- SPECIAL_IRONSIGHTS: "Zooms" in the weapon by moving the viewmodel

SWEP.AutoReloadOnEmpty = true -- Automatically reload if the clip is empty and the mouse is not being held
SWEP.AutoSwitchOnEmpty = false -- Automatically switch away if the weapon has no ammo, the mouse is not being held, and AutoSwitchFrom is true
SWEP.ReloadOnEmptyFire = false -- Reload if the weapon is fired with an empty clip
SWEP.SwitchOnEmptyFire = false -- Switch away if the weapon is fired with no ammo
SWEP.PenaliseBothOnInvalid = false -- Penalise both primary and secondary fire times for shooting while empty or underwater (if applies)
SWEP.ReloadSingly = false // True if this weapon reloads 1 round at a time (shotguns) 

SWEP.AutoSwitchFrom = true -- Allows auto-switching away from the weapon. This is only checked for engine switching and is ignored when AutoSwitchOnEmpty
SWEP.AutoSwitchTo = true -- Allows auto-switching to the weapon
SWEP.RestrictAmmoSwitch = false -- Do not allow switching to this weapon if it has no ammo

SWEP.UnderwaterCooldown = 0.2 -- Time between empty sound if the weapon cannot fire underwater. Set to -1 to only play once per mouse press
SWEP.EmptyCooldown = -1 -- Time between empty sound. Set to -1 to only play once per mouse press
SWEP.ShotDecreaseTime = 0.0225 -- (CS:S crosshair) How fast the shot count should decrease per shot
SWEP.ShotInitialDecreaseTime = 0.4 -- (CS:S crosshair) How long until the shot decrement starts after the mouse is lifter

--- Spawn/Constructor
local static_precached = {} -- Persists through all weapon instances -- acts like static keyword in C++

function SWEP:Initialize()
	local sClass = self:GetClass()
	DevMsg( 2, sClass .. " (weapon_gs_base) Initialize" )
	
	self.m_bInitialized = true
	self.m_bDeployed = false
	self.m_bDeployedNoAmmo = false
	self.m_bHolstered = false
	self.m_bInHolsterAnim = false
	self.m_bHolsterAnimDone = false
	self.m_bPlayedEmptySound = false
	self.m_flNextEmptySoundTime = 0
	self.m_flDecreaseShotsFired = 0
	self.m_flZoomActiveTime = 0
	self.m_sWorldModel = self.WorldModel
	self.m_tEvents = {}
	self.m_tEventHoles = {}
	self.m_tSpecialTypes = {
		[SPECIAL_SILENCE] = self.Silence,
		[SPECIAL_BURST] = self.ToggleBurst,
		[SPECIAL_ZOOM] = self.AdvanceZoom,
		[SPECIAL_IRONSIGHTS] = self.ToggleIronsights
	}
	
	self:SetHoldType( self.HoldType )
	
	if ( CLIENT ) then
		self.BobScale = self.Primary.BobScale
		self.SwayScale = self.Primary.SwaScale
		
		-- For CS:S crosshair
		self.m_iAmmoLastCheck = 0
		self.m_flCrosshairDistance = 0
	end
	
	if ( not static_precached[sClass] ) then
		static_precached[sClass] = true
		self:Precache()
	end
end

function SWEP:Precache()
	local sClass = self:GetClass()
	local tWeapon = weapons.GetStored( sClass )
	DevMsg( 2, sClass .. " (weapon_gs_base) Precache" )
	
	if ( CLIENT ) then
		-- Add KillIcon
		killicon.AddFont( sClass, self.KillIconFont, self.KillIcon, self.KillIconColor )
	end
	
	-- Precache all weapon models
	util.PrecacheModel( self.ViewModel )
	util.PrecacheModel( self.ViewModel1 )
	util.PrecacheModel( self.ViewModel2 )
	util.PrecacheModel( self.WorldModel )
	util.PrecacheModel( self.SilencerModel )
	
	-- Setup and precache all weapon sounds
	for k, s in pairs( self.Sounds ) do
		if ( k ~= "BaseClass" ) then -- Stupid pseudo-inheritance
			-- Register sound table
			if ( istable( s )) then
				if ( not s.name ) then
					s.name = sClass .. "." .. k
				end
				
				if ( not s.channel ) then
					s.channel = CHAN_WEAPON
				end
				
				sound.Add( s )
				self.Sounds[k] = s.name
				
				if ( not tWeapon.Sounds ) then
					tWeapon.Sounds = {}
				end
				
				tWeapon.Sounds[k] = s.name
				util.PrecacheSound( s.name )
			-- Create a new sound table from a file
			elseif ( string.IsSoundFile( s )) then
				local sName = sClass .. "." .. k
				
				sound.Add({
					name = sName,
					channel = CHAN_WEAPON,
					sound = s
				})
				
				self.Sounds[k] = sName
				
				if ( not tWeapon.Sounds ) then
					tWeapon.Sounds = {}
				end
				
				tWeapon.Sounds[k] = sName
				util.PrecacheSound( sName )
			-- Assume the sound table already exists
			else
				util.PrecacheSound( s )
			end
		end
	end
end

function SWEP:SetupDataTables()
	self:DTVar( "Bool", 0, "ReduceShots" ) -- For CS:S crosshair/weapons
	self:DTVar( "Int", 0, "SpecialLevel" )
	self:DTVar( "Float", 0, "NextThink" )
	self:DTVar( "Float", 1, "NextReload" )
	
	-- These could be removed with https://github.com/Facepunch/garrysmod-requests/issues/704
	self:DTVar( "Float", 2, "NextIdle" )
	self:DTVar( "Float", 3, "NextIdle1" )
	self:DTVar( "Float", 4, "NextIdle2" )
	
	-- Below are the default CNetworkVars in the engine for reference
	--self:DTVar( "Entity", 0, "Owner" )
	--self:DTVar( "Float", 5, "NextPrimaryAttack" )
	--self:DTVar( "Float", 6, "NextSecondaryAttack" )
	--self:DTVar( "Int", 0, "ViewModelIndex" )
	--self:DTVar( "Int", 1, "WorldModelIndex" )
	--self:DTVar( "Int", 2, "State" )
	--self:DTVar( "Int", 3, "PrimaryAmmoType" )
	--self:DTVar( "Int", 4, "SecondaryAmmoType" )
	--self:DTVar( "Int", 5, "Clip1" )
	--self:DTVar( "Int", 6, "Clip2" )
end

--- Deploy
function SWEP:CanDeploy()
	return true
end

function SWEP:Deploy()
	-- Do not deploy again
	if ( self.m_bDeployed ) then
		return true
	end
	
	local pPlayer = self:GetOwner()
	
	// Dead men deploy no weapons
	-- Player:Alive() will return true on the frame the death occured but the health will be less than or equal to 0
	if ( pPlayer == NULL or pPlayer:Health() < 1 or not pPlayer:Alive() or (self.RestrictAmmoSwitch and not self:HasAnyAmmo()) ) then
		return false
	end
	
	if ( self:CanDeploy() ) then
		self:SharedDeploy( false )
		
		return true
	end
	
	return false
end

local bSinglePlayer = game.SinglePlayer()

function SWEP:SharedDeploy( bDelayed )
	-- Clientside does not initialize sometimes
	if ( not self.m_bInitialized ) then
		self:Initialize()
	end
	
	DevMsg( 2, string.format( "%s (weapon_gs_base) Deployed %s", self:GetClass(), bDelayed and "late" or "on time" ))
	
	self.m_flNextEmptySoundTime = 0
	self.m_bPlayedEmptySound = false
	self.m_bDeployed = true
	self.m_bHolstered = false
	self.m_bInHolsterAnim = false
	self.m_bHolsterAnimDone = false
	
	if ( not self:HasAnyAmmo() ) then
		self.m_bDeployedNoAmmo = true
	end
	
	if ( self:GetZoomLevel() ~= 0 ) then
		self:SetSpecialLevel(0)
	end
	
	-- Only client can be delayed
	if ( not bDelayed ) then
		self:PlaySound( "deploy" )
		self:SetReduceShots( false )
		
		local pPlayer = self:GetOwner()
		pPlayer:SetFOV(0, 0)
		pPlayer:SetShotsFired(0)
		
		if ( SERVER or not bSinglePlayer ) then
			-- Wait for all viewmodels to deploy
			local flSequenceDuration = self:PlayActivity( "deploy" ) and self:SequenceLength() or 0
			
			if ( self.ViewModel1 ~= "" and self:PlayActivity( "deploy", 1 )) then
				flSequenceDuration = math.max( self:SequenceLength(1), flSequenceDuration )
			end
				
			if ( self.ViewModel2 ~= "" and self:PlayActivity( "deploy", 2 )) then
				flSequenceDuration = math.max( self:SequenceLength(2), flSequenceDuration )
			end
			
			// Can't shoot again until we've finished deploying
			self:SetNextPrimaryFire( flSequenceDuration )
			self:SetNextSecondaryFire( flSequenceDuration )
			self:SetNextReload( flSequenceDuration )
			self:SetNextIdle( flSequenceDuration )
			self:SetNextIdle1( flSequenceDuration )
			self:SetNextIdle2( flSequenceDuration )
		end
	end
end

--- Holster/Remove
function SWEP:CanHolster()
	return true
end

function SWEP:Holster( pSwitchingTo )
	if ( self.m_bHolstered ) then
		return true
	end
	
	local pPlayer = self:GetOwner()
	
	-- Holster is called when the player dies with it active but nothing should be done
	if ( pPlayer ~= NULL and (pPlayer:Health() < 1 or not pPlayer:Alive()) ) then
		return true
	end
	
	if ( not self.m_bInHolsterAnim ) then
		local bCanHolster = self:CanHolster()
		
		if ( bCanHolster ) then
			if ( self.HolsterAnimation and not self.m_bHolsterAnimDone ) then
				self:DoHolsterAnim( pSwitchingTo )
				
				-- Run this clientside to reset the viewmodels and set the variables for a full holster
				if ( bSinglePlayer ) then
					net.Start( "GSWeaponBase - Holster Animation" )
						net.WriteEntity( self )
						net.WriteEntity( pSwitchingTo )
					net.Send( pPlayer )
				end
			else
				self:SharedHolster( pSwitchingTo )
				
				-- Clientside does not run Holster in single-player
				if ( bSinglePlayer ) then
					net.Start( "GSWeaponBase - Holster" )
						net.WriteEntity( self )
						net.WriteEntity( pSwitchingTo )
					net.Send( pPlayer )
				end
				
				return true
			end
		else
			DevMsg( 2, string.format( "%s (weapon_gs_base) Holster invalid to %s", self:GetClass(), tostring( pSwitchingTo )))
		end
	end
	
	return false
end

function SWEP:DoHolsterAnim( pSwitchingTo )
	DevMsg( 2, string.format( "%s (weapon_gs_base) Holster animation to %s", self:GetClass(), tostring( pSwitchingTo )))
	
	-- https://github.com/Facepunch/garrysmod-requests/issues/739
	table.Empty( self.m_tEvents )
	table.Empty( self.m_tEventHoles )
	
	-- Disable all events during Holster animation
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	
	self.m_bInHolsterAnim = true
	
	if ( self:GetZoomLevel() ~= 0 ) then
		self:SetSpecialLevel(0)
	end
	
	-- The client state is purged too early in single-player for the event to run on time
	if ( SERVER or not bSinglePlayer ) then
		self:PlaySound( "holster" )
		
		-- Wait for all viewmodels to holster
		local flSequenceDuration = self:PlayActivity( "holster" ) and self:SequenceLength() or 0
		
		if ( self.ViewModel1 ~= "" and self:PlayActivity( "holster", 1 )) then
			flSequenceDuration = math.max( self:SequenceLength(1), flSequenceDuration )
		end
			
		if ( self.ViewModel2 ~= "" and self:PlayActivity( "holster", 2 )) then
			flSequenceDuration = math.max( self:SequenceLength(2), flSequenceDuration )
		end
		
		local bIsNULL = pSwitchingTo == NULL
		
		self:AddEvent( "Holster", flSequenceDuration, function()
			self.m_bInHolsterAnim = false
			self.m_bHolsterAnimDone = true
			
			if ( bIsNULL ) then -- Switching to NULL to begin with
				self:GetOwner().m_pNewWeapon = NULL
			elseif ( pSwitchingTo ~= NULL ) then -- Weapon being swapped to is still on the player
				self:GetOwner().m_pNewWeapon = pSwitchingTo
			else -- Weapon disappeared; find a new one or come back to the same weapon
				self:GetOwner().m_pNewWeapon = self:GetOwner():GetNextBestWeapon( self.HighWeightPriority )
			end
			
			return true
		end )
	end
end

function SWEP:SharedHolster( pSwitchingTo )
	DevMsg( 2, string.format( "%s (weapon_gs_base) Holster to %s", self:GetClass(), tostring( pSwitchingTo )))
	
	-- These are already set if there was a holster animation
	if ( not self.HolsterAnimation ) then
		-- https://github.com/Facepunch/garrysmod-requests/issues/739
		table.Empty( self.m_tEvents )
		table.Empty( self.m_tEventHoles )
		
		-- Disable all actions during holster
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
		self:SetNextIdle(-1)
		self:SetNextIdle1(-1)
		self:SetNextIdle2(-1)
		
		self:PlaySound( "holster" )
		
		if ( self:GetZoomLevel() ~= 0 ) then
			self:SetSpecialLevel(0)
		end
	end
	
	-- Hide the extra viewmodels
	if ( self.ViewModel1 ~= "" ) then
		self:SetViewModel( nil, 1 )
	end
	
	if ( self.ViewModel2 ~= "" ) then
		self:SetViewModel( nil, 2 )
	end
	
	self.m_bHolstered = true
	
	-- Don't let Think re-deploy after Holster
	timer.Simple( 0, function()
		if ( self ~= NULL ) then
			self.m_bDeployed = false
			self.m_bDeployedNoAmmo = false
		end
	end )
	
	local pPlayer = self:GetOwner()
	
	if ( pPlayer ~= NULL ) then
		pPlayer:SetFOV(0, 0) // reset the default FOV
	end
end

function SWEP:OnRemove()
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		DevMsg( 2, self:GetClass() .. " (weapon_gs_base) Remove invalid" )
	else
		pPlayer:SetFOV(0, 0) // reset the default FOV
		pPlayer:SetShotsFired(0)
		
		if ( pPlayer:Health() > 0 and pPlayer:Alive() and self:IsActiveWeapon() ) then
			-- The weapon was removed while it was active and the player was alive, so find a new one
			pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority, true )
			DevMsg( 2, string.format( "%s (weapon_gs_base) Remove to %s", self:GetClass(), tostring( pPlayer.m_pNewWeapon )))
		else
			DevMsg( 2, self:GetClass() .. " (weapon_gs_base) Remove invalid" )
		end
	end
end

--- Think
function SWEP:Think()
	-- For clientside deployment in single-player or by use of Player:SelectWeapon()
	if ( not self.m_bDeployed ) then
		if ( self:CanDeploy() ) then
			self:SharedDeploy( true )
		end
		
		-- Weapon is already deployed; CanDeploy should not return differently per realm
		-- But in-case it does, do not check every Think
		self.m_bDeployed = true
	end
	
	-- Do not think if there is no owner
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return
	end
	
	-- Events have priority over main think function
	local flCurTime = CurTime()
	
	for key, tbl in pairs( self.m_tEvents ) do
		if ( tbl[2] <= flCurTime ) then
			local RetVal = tbl[3]()
			
			if ( RetVal == true ) then
				self.m_tEvents[key] = nil
				
				if ( isnumber( key )) then
					self.m_tEventHoles[key] = true
				end
			else
				-- Update interval
				if ( isnumber( RetVal )) then
					tbl[1] = RetVal
				end
				
				tbl[2] = flCurTime + tbl[1]
			end
		end
	end
	
	if ( not (pPlayer:KeyDown( IN_ATTACK ) or pPlayer:KeyDown( IN_ATTACK2 )) ) then
		self:MouseLifted()
	end
	
	local flNextThink = self:GetNextThink()
	
	if ( flNextThink ~= -1 and flNextThink <= flCurTime ) then
		self:ItemFrame()
	end
	
	-- The default bobbing algorithm calls upon the set variables BobScale and SwayScale
	-- So instead of using a conditional accessor, these have to be set as soon as SpecialActive changes
	if ( CLIENT ) then
		local bSecondary = self:SpecialActive()
		self.BobScale = bSecondary and self.Secondary.BobScale ~= -1 and self.Secondary.BobScale or self.Primary.BobScale
		self.SwayScale = bSecondary and self.Secondary.SwayScale ~= -1 and self.Secondary.SwayScale or self.Primary.SwayScale
	end
	
	if ( (SERVER or not bSinglePlayer) and (self:Clip1() ~= 0 or self:LookupActivity( "dryfire" ) == ACT_INVALID) ) then 
		local flCurTime = CurTime()
		
		if ( self.ShouldIdle ) then
			local flNextIdle = self:GetNextIdle()
			
			if ( flNextIdle ~= -1 and flNextIdle <= flCurTime ) then
				self:PlayIdle()
			end
		end
		
		if ( self.ShouldIdle1 ) then
			local flNextIdle = self:GetNextIdle1()
			
			if ( flNextIdle ~= -1 and flNextIdle <= flCurTime ) then
				self:PlayIdle(1)
			end
		end
		
		if ( self.ShouldIdle2 ) then
			local flNextIdle = self:GetNextIdle2()
			
			if ( flNextIdle ~= -1 and flNextIdle <= flCurTime ) then
				self:PlayIdle(2)
			end
		end
	end
end

-- Normal think function replacement
function SWEP:ItemFrame()
end

function SWEP:MouseLifted()
	local pPlayer = self:GetOwner()
	self.m_bPlayedEmptySound = false
	
	if ( self:Clip1() == 0 ) then
		-- Reload is still called serverside only in single-player
		if ( self.AutoReloadOnEmpty and (SERVER or not bSinglePlayer) ) then
			self:Reload()
		-- Just ran out of ammo and the mouse has been lifted, so switch away
		elseif ( self.AutoSwitchOnEmpty and not self.m_bDeployedNoAmmo and not self:HasAnyAmmo() ) then
			pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
		end
	end
	
	// The following code prevents the player from tapping the firebutton repeatedly 
	// to simulate full auto and retaining the single shot accuracy of single fire
	local flCurTime = CurTime()
	local iShotsFired = pPlayer:GetShotsFired()
	
	if ( self:GetReduceShots() ) then
		self:SetReduceShots( false )
		
		if ( iShotsFired > 15 ) then
			pPlayer:SetShotsFired(15)
		end
		
		self.m_flDecreaseShotsFired = flCurTime + self.ShotInitialDecreaseTime
	elseif ( iShotsFired > 0 and self.m_flDecreaseShotsFired < flCurTime ) then
		self.m_flDecreaseShotsFired = flCurTime + self.ShotDecreaseTime
		pPlayer:SetShotsFired( iShotsFired - 1 )
	end
end

function SWEP:PlayIdle( iIndex )
	return self:PlayActivity( "idle", iIndex )
end

--- Attack
function SWEP:CanPrimaryAttack()
	if ( self:GetNextPrimaryFire() == -1 ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	-- Make sure player is at least valid for the methods below
	if ( pPlayer == NULL ) then
		return false
	end
	
	-- By default, clip has priority over water
	local iClip = self:Clip1()
	
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip1() ~= -1 and pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( false )
		
		return false
	end
	
	if ( not self.Primary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( false )
		
		return false
	end
	
	local flCurTime = CurTime()
	local flNextReload = self:GetNextReload()
	
	-- In the middle of a reload
	if ( flNextReload == -1 or flNextReload > flCurTime ) then
		-- Interrupt the reload to fire
		if ( self.Primary.InterruptReload ) then
			-- Stop the reload
			self:SetNextReload( flCurTime )
			self:RemoveEvent( "Reload" )
		else
			return false
		end
	end
	
	return true
end

-- Will only be called serverside in single-player
function SWEP:PrimaryAttack()
	return self:CanPrimaryAttack()
end

function SWEP:CanSecondaryAttack()
	if ( self:GetNextSecondaryFire() == -1 ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return false
	end
	
	local iClip = self:Clip2()
	
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip2() ~= -1 and pPlayer:GetAmmoCount( self:GetSecondaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( true )
		
		return false
	end
	
	if ( not self.Secondary.FireUnderwater and pPlayer:WaterLevel() == 3 ) then
		self:HandleFireUnderwater( true )
		
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

-- Will only be called serverside in single-player
function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		local func = self.m_tSpecialTypes[self.SpecialType]
		
		if ( func ) then
			func( self )
		end
		
		return true
	end
	
	return false
end

function SWEP:ShootBullets( tbl, bSecondary, iClipDeduction )
	if ( not iClipDeduction ) then
		iClipDeduction = 1
	end
	
	local iClip = self:Clip1()
	
	-- Check just in-case the weapon's CanPrimary/SecondaryAttack doesn't
	-- Do NOT let the clip overflow
	if ( iClipDeduction > iClip ) then
		return
	end
	
	local pPlayer = self:GetOwner()
	
	if ( self.PhysicalBullets ) then
		if ( SERVER ) then
			local bullet = ents.Create( "gs_bullet" )
			bullet:_SetAbsVelocity( (tbl.Dir and tbl.Dir:GetNormal() or pPlayer:GetAimVector()) * self.PhysicalBulletSpeed )
			bullet:SetOwner( pPlayer )
			bullet:SetupBullet( tbl )
			bullet:Spawn()
		end
	else
		self.FireFunction( pPlayer, tbl )
	end
	
	if ( iClip >= iClipDeduction * 2 and self:BurstEnabled() ) then
		iClip = iClip - iClipDeduction
		local tBurst = self.Burst
		local tTimes = tBurst.Times
		local flLastTime = tTimes[1]
		local iCount = tBurst.Count
		local iCurCount = 1
		
		self:SetClip1( iClip )
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
		
		self:AddEvent( "Burst", flLastTime, function()
			iClip = iClip - iClipDeduction
			self:SetClip1( iClip )
			tbl.ShootAngles = self:GetShootAngles() -- For FireCSBullets
			tbl.Src = self:GetShootSrc()
			
			if ( self.PhysicalBullets ) then
				if ( SERVER ) then
					local bullet = ents.Create( "gs_bullet" )
					bullet:_SetAbsVelocity( (tbl.Dir and tbl.Dir:GetNormal() or pPlayer:GetAimVector()) * 3000 )
					bullet:SetOwner( pPlayer )
					bullet:SetupBullet( tbl )
					bullet:Spawn()
				end
			else
				self.FireFunction( pPlayer, tbl )
			end
			
			self:PlayActivity( "burst" )
			self:PlaySound( bSecondary and "secondary" or "primary" )
			self:DoMuzzleFlash()
			
			pPlayer:SetAnimation( PLAYER_ATTACK1 )
			
			if ( iCurCount == iCount or iClip < iClipDeduction ) then
				local flNewTime = CurTime() + self:GetCooldown( true )
				self:SetNextPrimaryFire( flNewTime )
				self:SetNextSecondaryFire( flNewTime )
				self:SetNextReload( flNewTime )
				self:SetReduceShots( true )
				
				return true
			end
			
			iCurCount = iCurCount + 1
			flLastTime = tTimes[iCurCount] or flLastTime
			
			return flLastTime
		end )
	else
		iClip = iClip - iClipDeduction
		local flCooldown = self:GetCooldown()
		local flNextTime = CurTime() + flCooldown
		local tZoom = self.Zoom
		
		if ( tZoom.UnzoomOnFire ) then
			local iLevel = self:GetZoomLevel()
			
			if ( iLevel ~= 0 ) then
				self:SetSpecialLevel(0) -- Disable scope overlay
				self.m_flZoomActiveTime = flNextTime -- For CS:S spread
				pPlayer:SetFOV( 0, tZoom.Times.Fire )
				
				if ( tZoom.HideViewModel ) then
					pPlayer:GetViewModel():SetVisible( true )
						
					if ( self.ViewModel1 ~= "" ) then
						pPlayer:GetViewModel(1):SetVisible( true )
					end
						
					if ( self.ViewModel2 ~= "" ) then
						pPlayer:GetViewModel(2):SetVisible( true )
					end
				end
				
				-- Don't rezoom if the clip is empty
				if ( iClip ~= 0 ) then
					self:AddEvent( "Rezoom", flCooldown, function()
						self:SetSpecialLevel( iLevel )
						pPlayer:SetFOV( tZoom.FOV[iLevel], tZoom.Times.Rezoom )
						
						if ( tZoom.HideViewModel ) then
							local pPlayer = self:GetOwner()
							pPlayer:GetViewModel():SetVisible( false )
								
							if ( self.ViewModel1 ~= "" ) then
								pPlayer:GetViewModel(1):SetVisible( false )
							end
								
							if ( self.ViewModel2 ~= "" ) then
								pPlayer:GetViewModel(2):SetVisible( false )
							end
						end
						
						return true
					end )
				end
			end
		end
		
		self:SetClip1( iClip )
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
		self:SetReduceShots( true )
	end
	
	self:PlayActivity( bSecondary and "secondary" or "primary" )
	self:PlaySound( bSecondary and "secondary" or "primary" )
	self:DoMuzzleFlash()
	self:Punch( bSecondary )
	
	pPlayer:SetAnimation( PLAYER_ATTACK1 )
	pPlayer:SetShotsFired( pPlayer:GetShotsFired() + 1 )
end

function SWEP:Silence()
	self:PlayActivity( "secondary" )
	
	local flNewTime = self:SequenceLength()
	
	self:AddEvent( "Silence", flNewTime, function()
		self:SetSpecialLevel( self:Silenced() and 0 or 1 )
		
		return true
	end )
	
	flNewTime = flNewTime + CurTime()
	self:SetNextPrimaryFire( flNewTime )
	self:SetNextSecondaryFire( flNewTime )
	self:SetNextReload( flNewTime )
end

function SWEP:ToggleBurst()
	self:SetNextSecondaryFire( CurTime() + self.Burst.Cooldown )
	
	local bInBurst = self:BurstEnabled()
	self:SetSpecialLevel( bInBurst and 0 or 1 )
	self:GetOwner():PrintMessage( HUD_PRINTCENTER, bInBurst and "#GSWeaponBase_FromBurstFire" or "#GSWeaponBase_ToBurstFire" )
end

function SWEP:AdvanceZoom()
	local tZoom = self.Zoom
	local iLevel = (self:GetZoomLevel() + 1) % (tZoom.Levels + 1)
	local iFOV = iLevel == 0 and 0 or tZoom.FOV[iLevel]
	local flTime = tZoom.Times[iLevel] or tZoom.Times[0]
	
	if ( iFOV and flTime ) then
		self:SetSpecialLevel( iLevel )
		self:GetOwner():SetFOV( iFOV, flTime )
		
		if ( tZoom.HideViewModel and iLevel < 2 ) then
			local pPlayer = self:GetOwner()
			local bVisible = iLevel == 0
			pPlayer:GetViewModel():SetVisible( bVisible )
				
			if ( self.ViewModel1 ~= "" ) then
				pPlayer:GetViewModel(1):SetVisible( bVisible )
			end
				
			if ( self.ViewModel2 ~= "" ) then
				pPlayer:GetViewModel(2):SetVisible( bVisible )
			end
		end
	else
		ErrorNoHalt( string.format( "%s (weapon_gs_base) Zoom level %u not defined! Zooming out..", self:GetClass(), iLevel ))
		self:SetSpecialLevel(0)
		self:GetOwner():SetFOV(0, 0)
		
		if ( tZoom.HideViewModel ) then
			local pPlayer = self:GetOwner()
			pPlayer:GetViewModel():SetVisible( true )
				
			if ( self.ViewModel1 ~= "" ) then
				pPlayer:GetViewModel(1):SetVisible( true )
			end
				
			if ( self.ViewModel2 ~= "" ) then
				pPlayer:GetViewModel(2):SetVisible( true )
			end
		end
	end
	
	local flCurTime = CurTime()
	self.m_flZoomActiveTime = flCurTime + flTime
	self:SetNextSecondaryFire( flCurTime + tZoom.Cooldown )
end

function SWEP:ToggleIronsights()
	-- TODO
end

-- Using this instead of Player:MuzzleFlash() allows all viewmodels to use muzzle flash
function SWEP:DoMuzzleFlash( iIndex )
	if ( not self:Silenced() ) then
		if ( iIndex ) then
			-- https://github.com/Facepunch/garrysmod-issues/issues/2552
			if ( SERVER ) then
				self:SetSaveValue( "m_nMuzzleFlashParity", bit.band( self:GetInternalVariable( "m_nMuzzleFlashParity" ) + 1, 3 ))
				
				local pPlayer = self:GetOwner()
				pPlayer:SetSaveValue( "m_nMuzzleFlashParity", bit.band( pPlayer:GetInternalVariable( "m_nMuzzleFlashParity" ) + 1, 3 ))
				
				local pViewModel = pPlayer:GetViewModel( iIndex )
				
				-- Always check if the viewmodel is valid
				if ( pViewModel ~= NULL ) then
					pViewModel:SetSaveValue( "m_nMuzzleFlashParity", bit.band( pViewModel:GetInternalVariable( "m_nMuzzleFlashParity" ) + 1, 3 ))
				end
			end
		else
			self:GetOwner():MuzzleFlash()
		end
	end
end

function SWEP:Punch()
end

function SWEP:HandleFireOnEmpty( bSecondary )
	-- Only play empty sound per mouse press
	if ( self.EmptyCooldown == -1 ) then
		if ( not self.m_bPlayedEmptySound ) then
			self.m_bPlayedEmptySound = true
			self:PlaySound( "empty" )
		end
	else
		local flNextTime = CurTime()
		
		-- To prevent stacking empty sounds from primary and secondary fires
		if ( self.m_flNextEmptySoundTime <= flNextTime ) then
			self:PlaySound( "empty" )
			
			flNextTime = flNextTime + self.EmptyCooldown
			self.m_flNextEmptySoundTime = flNextTime
			
			if ( bSecondary ) then
				self:SetNextSecondaryFire( flNextTime )
			elseif ( self.PenaliseBothOnInvalid ) then
				self:SetNextPrimaryFire( flNextTime )
			end
		end
	end
	
	local pPlayer = self:GetOwner()
	
	if ( self.ReloadOnEmptyFire and pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) > 0 ) then
		self:Reload()
	elseif ( self.SwitchOnEmptyFire and not self:HasAnyAmmo() ) then
		pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
	end
end

function SWEP:HandleFireUnderwater( bSecondary )
	if ( self.UnderWaterCooldown == -1 ) then
		if ( not self.m_bPlayedEmptySound ) then
			self.m_bPlayedEmptySound = true
			self:PlaySound( "empty" )
		end
	else
		local flNextTime = CurTime()
		
		-- To prevent stacking empty sounds from primary and secondary fires
		if ( self.m_flNextEmptySoundTime <= flNextTime ) then
			self:PlaySound( "empty" )
			
			flNextTime = flNextTime + self.UnderwaterCooldown
			self.m_flNextEmptySoundTime = flNextTime
			
			if ( bSecondary ) then
				self:SetNextSecondaryFire( flNextTime )
			elseif ( self.PenaliseBothOnInvalid ) then
				self:SetNextPrimaryFire( flNextTime )
			end
		end
	end
end

--- Reload
function SWEP:CanReload()
	if ( self:EventActive( "Reload" )) then
		return false
	end
	
	local flNextReload = self:GetNextReload()
	
	-- Do not reload if both clips are already full
	if ( flNextReload == -1 or flNextReload > CurTime() or (self:Clip1() == self:GetMaxClip1() and self:Clip2() == self:GetMaxClip2()) ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	// If I don't have any spare ammo, I can't reload
	return pPlayer ~= NULL and ( pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) ~= 0 or pPlayer:GetAmmoCount( self:GetSecondaryAmmoName() ) ~= 0 )
end

-- Will only be called serverside in single-player
-- Prediction is really messed up here in multi-player
-- The method can be called twice more with the previous Clip1 value AFTER the weapon has finished reloading
-- This causes a slight hiccup where the reload anim/sound is replayed for a second
-- I have yet to find a solution without tossing prediction out the window completely here
function SWEP:Reload()
	if ( not self:CanReload() ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if ( self:GetZoomLevel() ~= 0 ) then
		self:SetSpecialLevel(0)
		pPlayer:SetFOV(0, 0)
		
		if ( self.Zoom.HideViewModel ) then
			pPlayer:GetViewModel():SetVisible( true )
				
			if ( self.ViewModel1 ~= "" ) then
				pPlayer:GetViewModel(1):SetVisible( true )
			end
				
			if ( self.ViewModel2 ~= "" ) then
				pPlayer:GetViewModel(2):SetVisible( true )
			end
		end
	end
	
	if ( self.ReloadSingly ) then
		local iMaxClip1 = self:GetMaxClip1()
		local iMaxClip2 = self:GetMaxClip2()
		local sAmmo1
		local sAmmo2
		local iClip1
		local iClip2
		local iAmmoCount1
		local iAmmoCount2
		
		if ( iMaxClip1 ~= -1 ) then
			sAmmo1 = self:GetPrimaryAmmoName()
			iClip1 = self:Clip1()
			iAmmoCount1 = pPlayer:GetAmmoCount( sAmmo1 )
		end
		
		if ( iMaxClip2 ~= -1 ) then
			sAmmo2 = self:GetSecondaryAmmoName()
			iClip2 = self:Clip2()
			iAmmoCount2 = pPlayer:GetAmmoCount( sAmmo2 )
		end
		
		// Play the player's reload animation
		--pPlayer:SetAnimation( PLAYERANIMEVENT_RELOAD )
		self:PlayActivity( "reload_start" )
		self:PlaySound( "reload_start" )
		
		local flSeqTime = self:SequenceLength()
		local flNewTime = flSeqTime + CurTime()
		self:SetNextPrimaryFire( flNewTime )
		self:SetNextSecondaryFire( flNewTime )
		self:SetNextReload(-1)
		
		local bFirst = true
		
		self:AddEvent( "Reload", flSeqTime, function()
			if ( bFirst ) then
				bFirst = false
				pPlayer:SetAnimation( PLAYER_RELOAD )
				self:PlayActivity( "reload" )
				self:PlaySound( "reload" )
				
				-- Start anim times are different than mid reload
				return self:SequenceLength()
			else
				if ( iMaxClip1 ~= -1 ) then
					iClip1 = iClip1 + 1
					self:SetClip1( iClip1 )
					iAmmoCount1 = iAmmoCount1 - 1
					pPlayer:RemoveAmmo( 1, sAmmo1 )
					
					if ( iAmmoCount1 == 0 or iClip1 == iMaxClip1 ) then
						iMaxClip1 = -1
					end
				end
				
				if ( iMaxClip2 ~= -1 ) then
					iClip2 = iClip2 + 1
					self:SetClip2( iClip2 )
					iAmmoCount2 = iAmmoCount2 - 1
					pPlayer:RemoveAmmo( 1, sAmmo2 )
					
					if ( iAmmoCount2 == 0 or iClip2 == iMaxClip2 ) then
						iMaxClip2 = -1
					end
				end
				
				if ( iMaxClip1 == -1 and iMaxClip2 == -1 ) then	
					--pPlayer:DoAnimationEvent( PLAYERANIMEVENT_RELOAD_END )
					pPlayer:SetShotsFired(0)
					self:PlayActivity( "reload_finish" )
					self:PlaySound( "reload_finish" )
					self:SetNextReload( CurTime() + self:SequenceLength() )
					self:FinishReload()
					
					return true
				else
					--pPlayer:DoAnimationEvent( PLAYERANIMEVENT_RELOAD_LOOP )
					self:PlayActivity( "reload" )
					self:PlaySound( "reload" )
				end
			end
		end )
	else
		// Play the player's reload animation
		pPlayer:SetAnimation( PLAYER_RELOAD )
		self:PlayActivity( "reload" )
		self:PlaySound( "reload" )
		
		local flSeqTime = self:SequenceLength()
		self:SetNextReload( CurTime() + flSeqTime )
		
		-- Finish reloading after the animation is finished
		self:AddEvent( "Reload", flSeqTime, function()
			local iMaxClip = self:GetMaxClip1()
			
			// If I use primary clips, reload primary
			if ( iMaxClip ~= -1 ) then
				local iClip = self:Clip1()
				local sAmmoType = self:GetPrimaryAmmoName()
				
				-- Only reload what is available
				local iAmmo = math.min( iMaxClip - iClip, pPlayer:GetAmmoCount( sAmmoType ))
				
				-- Add to the clip
				self:SetClip1( iClip + iAmmo )
				
				-- Take from the player's reserve
				pPlayer:RemoveAmmo( iAmmo, sAmmoType )
			end
			
			iMaxClip = self:GetMaxClip2()
			
			// If I use secondary clips, reload secondary
			if ( iMaxClip ~= -1 ) then
				local iClip = self:Clip2()
				local sAmmoType = self:GetSecondaryAmmoName()
				local iAmmo = math.min( iMaxClip - iClip, pPlayer:GetAmmoCount( sAmmoType ))
				self:SetClip2( iClip + iAmmo )
				pPlayer:RemoveAmmo( iAmmo, sAmmoType )
			end
			
			pPlayer:SetShotsFired(0)
			self:FinishReload()
			
			return true
		end )
	end
	
	return true
end

function SWEP:FinishReload()
end

--- Utilities
function SWEP:AddEvent( sName, iTime, fCall )
	-- Do not add to the event table multiple times
	if ( IsFirstTimePredicted() ) then
		if ( fCall ) then
			self.m_tEvents[sName] = { iTime, CurTime() + iTime, fCall }
		else
			self.m_tEvents[next( self.m_tEventHoles ) or #self.m_tEvents] = { sName, CurTime() + sName, iTime }
		end
	end
end

function SWEP:EventActive( sName )
	return self.m_tEvents[sName] ~= nil
end

function SWEP:RemoveEvent( sName )
	self.m_tEvents[sName] = nil
end

-- Will only be called serverside in single-player
function SWEP:DoImpactEffect( tr, iDamageType )
	return false
end

function SWEP:PlaySound( sSound )
	local sSound = self:LookupSound( self:Silenced() and "s_" .. sSound or sSound )
	
	if ( sSound ~= "" ) then
		self:EmitSound( sSound )
	end
end

function SWEP:PlayActivity( sActivity, iIndex, flRate --[[= 1]] )
	if ( sActivity == "primary" and self:Clip1() == 0 and self:LookupActivity( "dryfire" ) ~= ACT_INVALID ) then
		sActivity = "dryfire"
	end
	
	local bRet = self:SetIdealActivity( self:LookupActivity( self:Silenced() and "s_" .. sActivity or sActivity ), iIndex, flRate )
	
	if ( bRet and (not flRate or flRate > 0 )) then
		local flTime = self:SequenceLength()
		
		if ( flRate ) then
			flTime = flTime / flRate
		end
		
		if ( iIndex == 1 ) then
			self:SetNextIdle1( flTime + CurTime() )
		elseif ( iIndex == 2 ) then
			self:SetNextIdle2( flTime + CurTime() )
		else
			self:SetNextIdle( flTime + CurTime() )
		end
	end
	
	return bRet
end

function SWEP:TranslateActivity( iAct )
	return self.m_tActivityTranslate[iAct] or -1
end

--- Accessors/Modifiers
-- The functions commented out are already in the weapon metatable
--[[function SWEP:AllowsAutoSwtichFrom()
	return self.AutoSwitchFrom
end

function SWEP:AllowsAutoSwitchTo()
	return self.AutoSwitchTo
end]]

function SWEP:BurstEnabled()
	return self.SpecialType == SPECIAL_BURST and self.dt.SpecialLevel ~= 0
end

function SWEP:GetCurrentHoldType()
	return self.m_sCurrentHoldType
end

local tHoldTypes = {
	pistol = ACT_HL2MP_IDLE_PISTOL,
	smg = ACT_HL2MP_IDLE_SMG1,
	grenade = ACT_HL2MP_IDLE_GRENADE,
	ar2 = ACT_HL2MP_IDLE_AR2,
	shotgun = ACT_HL2MP_IDLE_SHOTGUN,
	rpg = ACT_HL2MP_IDLE_RPG,
	physgun = ACT_HL2MP_IDLE_PHYSGUN,
	crossbow = ACT_HL2MP_IDLE_CROSSBOW,
	melee = ACT_HL2MP_IDLE_MELEE,
	slam = ACT_HL2MP_IDLE_SLAM,
	normal = ACT_HL2MP_IDLE,
	fist = ACT_HL2MP_IDLE_FIST,
	melee2 = ACT_HL2MP_IDLE_MELEE2,
	passive = ACT_HL2MP_IDLE_PASSIVE,
	knife = ACT_HL2MP_IDLE_KNIFE,
	duel = ACT_HL2MP_IDLE_DUEL,
	camera = ACT_HL2MP_IDLE_CAMERA,
	magic = ACT_HL2MP_IDLE_MAGIC,
	revolver = ACT_HL2MP_IDLE_REVOLVER
}

function SWEP:SetWeaponHoldType( sHold )
	sHold = string.lower( sHold )
	local iStartIndex = tHoldTypes[sHold]
	
	if ( not iStartIndex ) then
		DevMsg( 2, string.format( "%s (weapon_gs_base) HoldType %q isn't valid! Defaulting to \"normal\"", self:GetClass(), sHold ))
		sHold = "normal"
		iStartIndex = tHoldTypes[sHold]
	end
	
	self.m_sCurrentHoldType = sHold
	self.m_tActivityTranslate = {
		[ACT_MP_STAND_IDLE] = iStartIndex,
		[ACT_MP_WALK] = iStartIndex + 1,
		[ACT_MP_RUN] = iStartIndex + 2,
		[ACT_MP_CROUCH_IDLE] = iStartIndex + 3,
		[ACT_MP_CROUCHWALK] = iStartIndex + 4,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = iStartIndex + 5,
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = iStartIndex + 5,
		[ACT_MP_RELOAD_STAND] = iStartIndex + 6,
		[ACT_MP_RELOAD_CROUCH] = iStartIndex + 6,
		[ACT_MP_JUMP] = iStartIndex == ACT_HL2MP_IDLE and ACT_HL2MP_JUMP_SLAM or iStartIndex + 7,
		[ACT_RANGE_ATTACK1] = iStartIndex + 8,
		[ACT_MP_SWIM] = iStartIndex + 9
	}
end

function SWEP:FlipsViewModel( iIndex )
	return iIndex == 1 and self.ViewModelFlip1 or iIndex == 2 and self.ViewModelFlip2 or self.ViewModelFlip
end

function SWEP:GetCooldown( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Cooldown
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Cooldown
end

function SWEP:GetDamage( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Damage
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Damage
end

function SWEP:GetDefaultClip1()
	return self.Primary.DefaultClip
end

function SWEP:GetDefaultClip2()
	return self.Secondary.DefaultClip
end

--[[function SWEP:GetMaxClip1()
	return self.Primary.ClipSize
end

function SWEP:GetMaxClip2()
	return self.Secondary.ClipSize
end]]

function SWEP:GetMuzzleAttachment( iEvent )
	-- Assume first attachment
	return ((iEvent or 5001) - 4991) / 10
end

function SWEP:GetNextIdle()
	return self.dt.NextIdle
end

function SWEP:SetNextIdle( flTime )
	self.dt.NextIdle = flTime
end

function SWEP:GetNextIdle1()
	return self.dt.NextIdle1
end

function SWEP:SetNextIdle1( flTime )
	self.dt.NextIdle1 = flTime
end

function SWEP:GetNextIdle2()
	return self.dt.NextIdle2
end

function SWEP:SetNextIdle2( flTime )
	self.dt.NextIdle2 = flTime
end

function SWEP:GetNextReload()
	return self.dt.NextReload
end

function SWEP:SetNextReload( flTime )
	self.dt.NextReload = flTime
end

function SWEP:GetNextThink()
	return self.dt.NextThink
end

function SWEP:SetNextThink( flTime )
	self.dt.NextThink = flTime
end

--[[function SWEP:GetOwner()
	return self.Owner -- Will always be an entity (NULL included)
end

function SWEP:GetPrimaryAmmoType()
	return game.GetAmmoID( self.Primary.Ammo )
end

function SWEP:GetSecondaryAmmoType()
	return game.GetAmmoID( self.Secondary.Ammo )
end]]

function SWEP:GetPrimaryAmmoName()
	return self.Primary.Ammo
end

function SWEP:GetSecondaryAmmoName()
	return self.Secondary.Ammo
end

--[[function SWEP:GetPrintName()
	return self.PrintName
end]]

function SWEP:GetRange( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Range
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Range
end

function SWEP:GetReduceShots()
	return self.dt.ReduceShots
end

function SWEP:SetReduceShots( bReduce )
	self.dt.ReduceShots = bReduce
end

function SWEP:GetRunSpeed( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.RunSpeed
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.RunSpeed
end

function SWEP:GetShootAngles()
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + pPlayer:GetPunchAngle()
end

function SWEP:GetShootSrc()
	return self:GetOwner():GetShootPos()
end

--[[function SWEP:GetSlot()
	return self.Slot
end

function SWEP:GetSlotPos()
	return self.SlotPos
end]]

-- Returns the viewmodel variable per index
function SWEP:GetViewModel( iIndex )
	return iIndex == 1 and self.ViewModel1 or iIndex == 2 and self.ViewModel2 or self.ViewModel
end

-- Sets the variable and model
function SWEP:SetViewModel( sModel, iIndex )
	local vm = self:GetOwner():GetViewModel( iIndex )
	
	if ( vm == NULL ) then
		return
	end
	
	if ( sModel == NULL ) then
		sModel = nil
	end
	
	if ( sModel ) then
		if ( iIndex == 1 ) then
			self.ViewModel1 = sModel
		elseif ( iIndex == 2 ) then
			self.ViewModel2 = sModel
		else
			self.ViewModel = sModel
		end
	end
	
	vm:SetWeaponModel( sModel or self:GetViewModel( iIndex ), sModel and sModel ~= "" and self or nil )
end

function SWEP:GetWalkSpeed( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.WalkSpeed
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.WalkSpeed
end

--[[function SWEP:GetWeaponWorldModel()
	return self.WorldModel
end

function SWEP:GetWeight()
	return self.Weight
end]]

function SWEP:GetZoomLevel()
	return self.SpecialType == SPECIAL_ZOOM and self.dt.SpecialLevel or 0
end

function SWEP:IronSightsEnabled()
	return self.SpecialType == SPECIAL_IRONSIGHTS and self.dt.SpecialLevel or 0
end

function SWEP:LookupActivity( sName )
	return self.Activities[sName] or ACT_INVALID
end

function SWEP:LookupSound( sName )
	return self.Sounds[sName] or ""
end

function SWEP:SetSpecialLevel( iLevel )
	self.dt.SpecialLevel = iLevel
end

function SWEP:Silenced()
	return self.SpecialType == SPECIAL_SILENCE and self.dt.SpecialLevel ~= 0
end

function SWEP:SpecialActive()
	-- Instead of setting the FOV in an event, 
	return self.dt.SpecialLevel ~= 0 or self.m_flZoomActiveTime > CurTime()
end

function SWEP:UsesHands()
	return self.UseHands
end
