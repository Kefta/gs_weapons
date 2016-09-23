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
	--dryfire = ACT_VM_DRYFIRE, -- Used when the last bullet in the clip is fired. Implement activity to use; otherwise defaults to "primary"
	secondary = ACT_VM_SECONDARYATTACK,
	reload = ACT_VM_RELOAD,
	--reload_empty = ACT_VM_RELOAD_EMPTY, -- Used when the weapon is reloaded with an empty clip. Implement activity to use; otherwise defaults to "reload"
	--empty = ACT_VM_DRYFIRE, -- Used when the weapon fires with no ammo in the clip. Implement activity to use; otherwise doesn't play at all
	deploy = ACT_VM_DRAW,
	holster = ACT_VM_HOLSTER,
	idle = ACT_VM_IDLE,
	burst = ACT_VM_PRIMARYATTACK,
	-- For silencers. If a silenced activity isn't available, the weapon will fallback to the non-silenced version
	s_primary = ACT_VM_PRIMARYATTACK_SILENCED,
	--s_dryfire = ACT_VM_DRYFIRE_SILENCED, -- Silenced dryfire. Implement activity to use; defaults to "s_primary"
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
SWEP.Sounds = {
	-- Default sound events. If a sound isn't available, nothing will play
	--deploy = "sound.wav",
	--[[primary = {
		pitch = {50, 100},
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
	Bullets = 1, -- How many bullets are shot by FireBullets
	Damage = 42, -- Bullet/melee damage // Douglas Adams 1952 - 2001
	Range = MAX_TRACE_LENGTH, -- Bullet/melee distance
	Cooldown = 0.15, -- Time between firing
	WalkSpeed = 1, -- Walk speed multiplier to use when the weapon is deployed
	RunSpeed = 1, -- Run speed multiplier to use when the weapon is deployed
	FireUnderwater = true, -- Allows firing underwater
	InterruptReload = false, -- Allows interrupting a reload to shoot
	-- These are seperated by primary/secondary so ironsights can lower it
	BobScale = CLIENT and 0.45 or nil, -- Magnitude of the weapon bob
	SwayScale = CLIENT and 0.5 or nil -- Sway deviation
}

SWEP.Secondary = {
	Ammo = "",
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Bullets = -1, -- -1 = off. Change for this variable to be returned by the accessor when bSecondary (IsSpecialActive by default) is true
	Damage = -1,
	Range = -1,
	Cooldown = -1,
	WalkSpeed = -1,
	RunSpeed = -1,
	FireUnderwater = true,
	InterruptReload = false,
	BobScale = CLIENT and -1 or nil,
	SwayScale = CLIENT and -1 or nil
}

SWEP.SingleReload = {
	Enabled = false,  // True if this weapon reloads 1 round at a time (shotguns)
	QueuedFire = true, -- Queue a primary/secondary fire to activate once the next bullet is put in the chamber
	InitialRound = true -- Give round for the first reload (HL2) or subsequent reloads only (CS:S)
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
	FireDuringZoom = true, -- Allow fire during zoom/unzoom
	DrawOverlay = CLIENT and false or nil -- (Clientside) Draw scope overlay when zoomed
}

SWEP.IronSights = {
	Pos = vector_origin, -- Position of the viewmodel in IronSights
	Ang = angle_zero, -- Angle of the viewmodel in IronSights
	ZoomTime = 1, -- Time it takes to move viewmodel in
	UnzoomTime = 1, -- Time it takes to move viewmodel out
	Hold = false, -- Require secondary fire key to be held to use IronSights as opposed to just toggling the state
	DrawCrosshair = false, -- Draw crosshair when IronSights is active
	FireInZoom = false -- Allow fire during zoom/unzoom
}

SWEP.SpecialType = 0 -- Sets what the secondary fire should do. Uses SPECIAL enums:
-- SPECIAL_SILENCE: Attaches silencer. Changes all sounds and animations to use the s_param version if available
-- SPECIAL_BURST: Toggles between single-shot and burst fire modes
-- SPECIAL_ZOOM: Zooms in the weapon by setting the player's FOV. Can have multiple levels
-- SPECIAL_IRONSIGHTS: "Zooms" in the weapon by moving the viewmodel

SWEP.PhysicalBullets = false -- Instead of using traces to simulate bullet firing, shoot a physical entity
SWEP.PhysicalBulletSpeed = 5000 -- Speed of bullet entity when fired

SWEP.AutoReloadOnEmpty = true -- Automatically reload if the clip is empty and the mouse is not being held
SWEP.AutoSwitchOnEmpty = false -- Automatically switch away if the weapon has no ammo, the mouse is not being held, and AutoSwitchFrom is true
SWEP.ReloadOnEmptyFire = false -- Reload if the weapon is fired with an empty clip
SWEP.SwitchOnEmptyFire = false -- Switch away if the weapon is fired with no ammo
SWEP.CheckPrimaryClipForSecondary = false -- Check Clip1 instead of Clip2 in CanSecondaryAttack

SWEP.AutoSwitchFrom = true -- Allows auto-switching away from the weapon. This is only checked for engine switching and is ignored when AutoSwitchOnEmpty
SWEP.AutoSwitchTo = true -- Allows auto-switching to the weapon
SWEP.BlockDeployOnEmpty = false -- Block deploying the weapon if it has no ammo

SWEP.UnderwaterCooldown = 0.2 -- Time between empty sound if the weapon cannot fire underwater. Set to -1 to only play once per mouse press
SWEP.EmptyCooldown = -1 -- Time between empty sound. Set to -1 to only play once per mouse press
SWEP.ShotDecreaseTime = 0.0225 -- (CS:S crosshair) How fast the shot count should decrease per shot
SWEP.ShotInitialDecreaseTime = 0.4 -- (CS:S crosshair) How long until the shot decrement starts after the mouse is lifter

--- Spawn/Constructor
local PLAYER = _R.Player
local static_precached = {} -- Persists through all weapon instances -- acts like static keyword in C++

function SWEP:Initialize()
	local sClass = self:GetClass()
	DevMsg( 2, sClass .. " (weapon_gs_base) Initialize" )
	
	--self.FireFunction = nil -- Fire function to use with ShootBullets when PhysicalBullets is false. Args are ( pPlayer, tFireBulletsInfo ). nil = Default FireBullets
	--self.PunchDecayFunction = nil -- Function to decay the punch angle manually. Args are ( pPlayer, aPunchAngle ). The function should modify aPunchAngle and return it. nil = Default decaying
	
	self.SpecialTypes = { -- Secondary/special methods. Set SWEP.SpecialType to which function you want to call
		[SPECIAL_SILENCE] = self.Silence,
		[SPECIAL_BURST] = self.ToggleBurst,
		[SPECIAL_ZOOM] = self.AdvanceZoom,
		[SPECIAL_IRONSIGHTS] = self.ToggleIronSights
	}
	
	self.m_bInitialized = true
	self.m_bDeployed = false
	self.m_bDeployedNoAmmo = false
	self.m_bHolstered = false
	self.m_bInHolsterAnim = false
	self.m_bHolsterAnimDone = false
	self.m_tEvents = {}
	self.m_tEventHoles = {}
	
	self:SetHoldType( self.HoldType )
	
	if ( CLIENT ) then
		self.BobScale = self.Primary.BobScale
		self.SwayScale = self.Primary.SwaScale
		self.m_sWorldModel = self.WorldModel
		
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
	self:DTVar( "Int", 0, "SpecialLevel" )
	self:DTVar( "Int", 1, "ShotsFired" )
	self:DTVar( "Float", 0, "NextThink" )
	self:DTVar( "Float", 1, "NextReload" )
	self:DTVar( "Float", 2, "ReduceShotTime" )
	self:DTVar( "Float", 3, "ZoomActiveTime" )
	
	-- These could be removed with https://github.com/Facepunch/garrysmod-requests/issues/704
	self:DTVar( "Float", 4, "NextIdle" )
	self:DTVar( "Float", 5, "NextIdle1" )
	self:DTVar( "Float", 6, "NextIdle2" )
	
	-- Below are the default CNetworkVars in the engine for reference
	--self:DTVar( "Entity", 0, "Owner" )
	--self:DTVar( "Float", 7, "NextPrimaryAttack" )
	--self:DTVar( "Float", 8, "NextSecondaryAttack" )
	--self:DTVar( "Int", 2, "ViewModelIndex" )
	--self:DTVar( "Int", 3, "WorldModelIndex" )
	--self:DTVar( "Int", 4, "State" )
	--self:DTVar( "Int", 5, "PrimaryAmmoType" )
	--self:DTVar( "Int", 6, "SecondaryAmmoType" )
	--self:DTVar( "Int", 7, "Clip1" )
	--self:DTVar( "Int", 8, "Clip2" )
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
	if ( pPlayer == NULL or not pPlayer:Alive() or (self.BlockDeployOnEmpty and not self:HasAnyAmmo()) ) then
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
	
	self.m_bDeployed = true
	self.m_bHolstered = false
	self.m_bInHolsterAnim = false
	self.m_bHolsterAnimDone = false
	
	if ( not self:HasAnyAmmo() ) then
		self.m_bDeployedNoAmmo = true
	end
	
	-- Only client can be delayed
	if ( not bDelayed and (not bSinglePlayer or SERVER) ) then
		if ( self:GetZoomLevel() ~= 0 ) then
			self:SetSpecialLevel(0)
		end
		
		self:PlaySound( "deploy" )
		self:SetReduceShotTime(0)
		self:SetShotsFired(0)
		
		local pPlayer = self:GetOwner()
		pPlayer:SetFOV(0, 0)
		
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
	-- Player:Alive() will return true on the frame the death occured but the health will be less than or equal to 0
	if ( pPlayer ~= NULL and (pPlayer:Health() < 1 or not pPlayer:Alive()) ) then
		return true
	end
	
	if ( not self.m_bInHolsterAnim ) then
		local bCanHolster = self:CanHolster()
		
		if ( bCanHolster ) then
			if ( self.HolsterAnimation and not self.m_bHolsterAnimDone ) then
				self:HolsterAnim( pSwitchingTo )
				
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

function SWEP:HolsterAnim( pSwitchingTo )
	DevMsg( 2, string.format( "%s (weapon_gs_base) Holster animation to %s", self:GetClass(), tostring( pSwitchingTo )))
	
	-- https://github.com/Facepunch/garrysmod-requests/issues/739
	table.Empty( self.m_tEvents )
	table.Empty( self.m_tEventHoles )
	self.m_bInHolsterAnim = true
	
	-- The client state is purged too early in single-player for the event to run on time
	if ( not bSinglePlayer or SERVER ) then
		if ( self:GetZoomLevel() ~= 0 ) then
			self:SetSpecialLevel(0)
		end
		
		-- Disable all events during Holster animation
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
		
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
		
		self:AddEvent( "holster", flSequenceDuration, function()
			self.m_bInHolsterAnim = false
			self.m_bHolsterAnimDone = true
			
			if ( bIsNULL ) then -- Switching to NULL to begin with
				self:GetOwner().m_pNewWeapon = NULL
			elseif ( pSwitchingTo == NULL ) then -- Weapon disappeared; find a new one or come back to the same weapon
				self:GetOwner().m_pNewWeapon = self:GetOwner():GetNextBestWeapon( self.HighWeightPriority )
			else -- Weapon being swapped to is still on the player
				self:GetOwner().m_pNewWeapon = pSwitchingTo
			end
			
			return true
		end )
	end
end

function SWEP:SharedHolster( pSwitchingTo )
	DevMsg( 2, string.format( "%s (weapon_gs_base) Holster to %s", self:GetClass(), tostring( pSwitchingTo )))
	
	local bRun = not bSinglePlayer or SERVER
	
	-- These are already set if there was a holster animation
	if ( not self.HolsterAnimation ) then
		-- https://github.com/Facepunch/garrysmod-requests/issues/739
		table.Empty( self.m_tEvents )
		table.Empty( self.m_tEventHoles )
		
		if ( bRun ) then
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
	end
	
	self.m_bHolstered = true
	
	-- Don't let Think re-deploy after Holster
	timer.Simple( 0, function()
		if ( self ~= NULL ) then
			self.m_bDeployed = false
			self.m_bDeployedNoAmmo = false
		end
	end )
	
	if ( bRun ) then
		-- Hide the extra viewmodels
		if ( self.ViewModel1 ~= "" ) then
			self:SetViewModel( nil, 1 )
		end
		
		if ( self.ViewModel2 ~= "" ) then
			self:SetViewModel( nil, 2 )
		end
		
		local pPlayer = self:GetOwner()
		
		if ( pPlayer ~= NULL ) then
			pPlayer:SetFOV(0, 0) // reset the default FOV
		end
	end
end

function SWEP:OnRemove()
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		DevMsg( 2, self:GetClass() .. " (weapon_gs_base) Remove invalid" )
	else
		if ( not bSinglePlayer or SERVER ) then
			pPlayer:SetFOV(0, 0) // reset the default FOV
		end
		
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
	
	if ( (SERVER or not bSinglePlayer) and (self:Clip1() ~= 0 or self:LookupActivity( "dryfire" ) == ACT_INVALID) and (not self:Silenced() or self:LookupActivity( "s_idle" ) ~= ACT_INVALID) ) then 
		local flCurTime = CurTime()
		
		if ( self.ShouldIdle ) then
			local flNextIdle = self:GetNextIdle()
			
			if ( flNextIdle ~= -1 and flNextIdle <= flCurTime ) then
				self:PlayActivity( "idle" )
			end
		end
		
		if ( self.ShouldIdle1 ) then
			local flNextIdle = self:GetNextIdle1()
			
			if ( flNextIdle ~= -1 and flNextIdle <= flCurTime ) then
				self:PlayActivity( "idle", 1 )
			end
		end
		
		if ( self.ShouldIdle2 ) then
			local flNextIdle = self:GetNextIdle2()
			
			if ( flNextIdle ~= -1 and flNextIdle <= flCurTime ) then
				self:PlayActivity( "idle", 2 )
			end
		end
	end
end

-- Normal think function replacement
function SWEP:ItemFrame()
end

function SWEP:MouseLifted()
	local pPlayer = self:GetOwner()
	
	if ( self:Clip1() == 0 ) then
		-- Just ran out of ammo and the mouse has been lifted, so switch away
		if ( self.AutoSwitchOnEmpty and not self.m_bDeployedNoAmmo and not self:HasAnyAmmo() ) then
			pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
		-- Reload is still called serverside only in single-player
		elseif ( self.AutoReloadOnEmpty and (not bSinglePlayer or SERVER) ) then
			self:Reload()
		end
	end
	
	if ( not bSinglePlayer or SERVER and not self:EventActive( "burst" )) then
		// The following code prevents the player from tapping the firebutton repeatedly 
		// to simulate full auto and retaining the single shot accuracy of single fire
		local iShotsFired = self:GetShotsFired()
		local flShotTime = self:GetReduceShotTime()
		
		if ( flShotTime == -1 ) then
			if ( iShotsFired > 15 ) then
				self:SetShotsFired(15)
			end
			
			self:SetReduceShotTime( CurTime() + self.ShotInitialDecreaseTime )
		elseif ( iShotsFired > 0 ) then
			local flCurTime = CurTime()
			
			if ( flShotTime < flCurTime ) then
				self:SetShotsFired( iShotsFired - 1 )
				self:SetReduceShotTime( flCurTime + self.ShotDecreaseTime )
			end
		end
	end
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
	
	local iClip = self:Clip1()
	local iWaterLevel = pPlayer:WaterLevel()
	
	-- In the middle of a reload
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
		-- Interrupt the reload to fire
		elseif ( self.Primary.InterruptReload and iClip ~= 0 and (self.Primary.FireUnderwater or iWaterLevel ~= 3) ) then
			-- Stop the reload
			self:SetNextReload( CurTime() - 0.1 )
			self:RemoveEvent( "reload" )
		else
			return false
		end
	end
	
	-- By default, clip has priority over water
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip1() ~= -1 and pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( false )
		
		return false
	end
	
	if ( not self.Primary.FireUnderwater and iWaterLevel == 3 ) then
		self:HandleFireUnderwater( false )
		
		return false
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
	
	local iClip = self.CheckPrimaryClipForSecondary and self:Clip1() or self:Clip2()
	local iWaterLevel = pPlayer:WaterLevel()
	
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
		elseif ( self.Secondary.InterruptReload and iClip ~= 0 and (self.Secondary.FireUnderwater or iWaterLevel ~= 3) ) then
			self:SetNextReload( CurTime() - 0.1 )
			self:RemoveEvent( "reload" )
		else
			return false
		end
	end
	
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip2() ~= -1 and pPlayer:GetAmmoCount( self:GetSecondaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( true )
		
		return false
	end
	
	if ( not self.Secondary.FireUnderwater and iWaterLevel == 3 ) then
		self:HandleFireUnderwater( true )
		
		return false
	end
	
	return true
end

-- Will only be called serverside in single-player
function SWEP:SecondaryAttack()
	if ( self:CanSecondaryAttack() ) then
		local func = self.SpecialTypes[self.SpecialType]
		
		if ( func ) then
			func( self )
		end
		
		return true
	end
	
	return false
end

function SWEP:ShootBullets( tbl --[[{}]], bSecondary --[[= false]], iClipDeduction --[[= 1]] )
	if ( not tbl ) then
		tbl = {}
	end
	
	if ( not iClipDeduction ) then
		iClipDeduction = 1
	end
	
	local iClip = self:Clip1()
	
	-- Check just in-case the weapon's CanPrimary/SecondaryAttack doesn't check properly
	-- Do NOT let the clip overflow
	if ( iClipDeduction > iClip ) then
		error( self:GetClass() .. " (weapon_gs_base) Clip overflowed in ShootBullets! Add check to CanPrimary/SecondaryAttack" )
	end
	
	local bBurst = iClip >= iClipDeduction * 2 and self:BurstEnabled()
	local flCooldown = bBurst and nil or self:GetCooldown( bSecondary )
	local pPlayer = self:GetOwner()
	
	if ( bBurst ) then
		iClip = iClip - iClipDeduction
		local tBurst = self.Burst
		local tTimes = tBurst.Times
		local flLastTime = tTimes[1]
		local iCount = tBurst.Count
		local iCurCount = 1
		
		self:SetClip1( iClip )
		
		self:AddEvent( "burst", flLastTime, function()
			iClip = iClip - iClipDeduction
			self:SetClip1( iClip )
			
			local aShoot = self:GetShootAngles()
			tbl.Dir = aShoot:Forward()
			tbl.ShootAngles = aShoot -- For FireCSBullets
			tbl.Src = self:GetShootSrc()
			
			if ( self.PhysicalBullets ) then
				if ( SERVER ) then
					local pBullet = ents.Create( "gs_bullet" )
					pBullet:_SetAbsVelocity( (tbl.Dir and tbl.Dir:GetNormal() or pPlayer:GetAimVector()) * 3000 )
					pBullet:SetOwner( pPlayer )
					pBullet:SetupBullet( tbl )
					pBullet:Spawn()
				end
			elseif ( self.FireFunction ) then
				self.FireFunction( pPlayer, tbl )
			else
				pPlayer:FireBullets( tbl )
			end
				
			
			pPlayer:SetAnimation( PLAYER_ATTACK1 )
			self:DoMuzzleFlash()
			self:PlaySound( bSecondary and "secondary" or "primary" )
			self:PlayActivity( "burst" )
			
			if ( iCurCount == iCount or iClip < iClipDeduction ) then
				local flNewTime = CurTime() + self:GetCooldown( true )
				self:SetNextPrimaryFire( flNewTime )
				self:SetNextSecondaryFire( flNewTime )
				self:SetNextReload( flNewTime )
				self:SetReduceShotTime(-1)
				
				return true
			end
			
			iCurCount = iCurCount + 1
			flLastTime = tTimes[iCurCount] or flLastTime
			
			return flLastTime
		end )
	else
		iClip = iClip - iClipDeduction
		self:SetClip1( iClip )
		self:SetReduceShotTime(-1)
		
		local tZoom = self.Zoom
		
		if ( tZoom.UnzoomOnFire ) then
			local iLevel = self:GetZoomLevel()
			
			if ( iLevel ~= 0 ) then
				self:SetSpecialLevel(0) -- Disable scope overlay
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
					self:AddEvent( "rezoom", flCooldown, function()
						local flRezoom = tZoom.Times.Rezoom
						self:SetZoomActiveTime( flRezoom )
						self:SetSpecialLevel( iLevel )
						self:SetNextSecondaryFire( flRezoom )
						pPlayer:SetFOV( tZoom.FOV[iLevel], flRezoom )
						
						if ( not tZoom.FireDuringZoom ) then
							self:SetNextPrimaryFire( flRezoom )
						end
						
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
	end
	
	pPlayer:SetAnimation( PLAYER_ATTACK1 )
	
	self:SetShotsFired( self:GetShotsFired() + 1 )
	self:DoMuzzleFlash()
	self:Punch( bSecondary )
	self:PlaySound( bSecondary and "secondary" or "primary" )
	self:PlayActivity( bSecondary and "secondary" or "primary" )
	
	-- The zoom level needs to be set before PlayActivity but the times need to be set after
	-- So do two seperate burst blocks
	if ( bBurst ) then
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
	else
		local flNextTime = CurTime() + flCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
	end
	
	-- Run FireBullets at the end to give it a chance to change all of these values
	if ( self.PhysicalBullets ) then
		if ( SERVER ) then
			local bullet = ents.Create( "gs_bullet" )
			bullet:_SetAbsVelocity( (tbl.Dir and tbl.Dir:GetNormal() or pPlayer:GetAimVector()) * self.PhysicalBulletSpeed )
			bullet:SetOwner( pPlayer )
			bullet:SetupBullet( tbl )
			bullet:Spawn()
		end
	elseif ( self.FireFunction ) then
		self.FireFunction( pPlayer, tbl )
	else
		pPlayer:FireBullets( tbl )
	end
end

function SWEP:Silence()
	local flNewTime = self:SequenceLength()
	
	self:AddEvent( "silence", flNewTime, function()
		self:SetSpecialLevel( self:Silenced() and 0 or 1 )
		
		return true
	end )
	
	self:PlayActivity( "secondary" )
	
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
		ErrorNoHalt( string.format( "%s (weapon_gs_base) Zoom level or time %u not defined! Zooming out..", self:GetClass(), iLevel ))
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
	
	local flNextTime = CurTime()
	self:SetNextSecondaryFire( flNextTime + tZoom.Cooldown )
	
	flNextTime = flNextTime + flTime
	self:SetZoomActiveTime( flNextTime )
	
	if ( not tZoom.FireDuringZoom ) then
		self:SetNextPrimaryFire( flNextTime )
	end
end

function SWEP:ToggleIronSights()
	self:SetSpecialLevel( self:IronSightsEnabled() and 0 or 1 )
	--self.m_flZoomActiveTime = CurTime() + 
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
	self:PlaySound( "empty" )
	self:PlayActivity( "empty" )
	
	local pPlayer = self:GetOwner()
	
	if ( self.EmptyCooldown == -1 ) then
		self:AddEvent( "empty_" .. (bSecondary and "secondary" or "primary"), 0, function()
			if ( bSecondary ) then
				if ( not pPlayer:KeyDown( IN_ATTACK2 )) then
					self:SetNextSecondaryFire(0)
				end
			elseif ( not pPlayer:KeyDown( IN_ATTACK )) then
				self:SetNextPrimaryFire(0)
			end
			
			return true
		end )
		
		if ( bSecondary ) then
			self:SetNextSecondaryFire(-1)
		else
			self:SetNextPrimaryFire(-1)
		end
	else
		local flNextTime = CurTime() + self.EmptyCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
	end
	
	if ( self.SwitchOnEmptyFire and not self:HasAnyAmmo() ) then
		pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
	elseif ( self.ReloadOnEmptyFire and pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) > 0 ) then
		self:SetNextReload(0)
		self:Reload()
	end
end

function SWEP:HandleFireUnderwater( bSecondary )
	self:PlaySound( "empty" )
	self:PlayActivity( "empty" )
	
	if ( self.UnderwaterCooldown == -1 ) then
		local pPlayer = self:GetOwner()
		
		self:AddEvent( "empty_" .. (bSecondary and "secondary" or "primary"), 0, function()
			if ( bSecondary ) then
				if ( not pPlayer:KeyDown( IN_ATTACK2 )) then
					self:SetNextSecondaryFire(0)
				end
			elseif ( not pPlayer:KeyDown( IN_ATTACK )) then
				self:SetNextPrimaryFire(0)
			end
			
			return true
		end )
		
		if ( bSecondary ) then
			self:SetNextSecondaryFire(-1)
		else
			self:SetNextPrimaryFire(-1)
		end
	else
		local flNextTime = CurTime() + self.UnderwaterCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
	end
end

--- Reload
function SWEP:CanReload()
	if ( self:EventActive( "reload" )) then
		return false
	end
	
	local flNextReload = self:GetNextReload()
	
	-- Do not reload if both clips are already full
	if ( flNextReload == -1 or flNextReload > CurTime() ) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return false
	end
	
	// If I don't have any spare ammo, I can't reload
	local iMaxClip1 = self:GetMaxClip1()
	
	if ( iMaxClip1 == -1 or self:Clip1() == iMaxClip1 or pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
		local iMaxClip2 = self:GetMaxClip2()
		
		if ( iMaxClip2 == -1 or self:Clip2() == iMaxClip2 or pPlayer:GetAmmoCount( self:GetSecondaryAmmoName() ) == 0 ) then
			return false
		end
	end
	
	return true
end

-- Will only be called serverside in single-player
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
	
	local tSingleReload = self.SingleReload
	
	if ( tSingleReload.Enabled ) then
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
		self:PlaySound( "reload_start" )
		self:PlayActivity( "reload_start" )
		
		local flSeqTime = self:SequenceLength()
		local bFirst = true
		
		self:AddEvent( "reload", flSeqTime, function()
			-- HACK: Don't reload with primary fire underwater
			if ( (pPlayer:KeyDown( IN_ATTACK ) and not self.Primary.FireUnderwater and pPlayer:WaterLevel() == 3 or pPlayer:KeyDown( IN_ATTACK2 )) and not tSingleReload.QueuedFire ) then
				self:SetNextIdle(-1)
				
				-- Start reloading when the mouse is lifted
				return 0
			elseif ( self:GetNextIdle() == -1 ) then
				-- Re-enable idling
				self:SetNextIdle(0)
				
				-- Skip one tick for PrimaryAttack to have priority
				return 0
			end
			
			if ( not bFirst or tSingleReload.InitialRound ) then
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
					self:SetShotsFired(0)
					self:PlaySound( "reload_finish" )
					self:PlayActivity( "reload_finish" )
					
					local flNextTime = CurTime() + self:SequenceLength()
					self:SetNextPrimaryFire( flNextTime )
					self:SetNextSecondaryFire( flNextTime )
					self:SetNextReload( flNextTime )
					self:FinishReload()
					
					return true
				end
			end
			
			if ( bFirst ) then
				bFirst = false
				pPlayer:SetAnimation( PLAYER_RELOAD )
				self:SetNextPrimaryFire(0)
				self:SetNextSecondaryFire(0)
			end
			
			self:PlaySound( "reload" )
			self:PlayActivity( "reload" )
			
			-- Start anim times are different than mid reload
			return self:SequenceLength()
		end )
		
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
	else
		// Play the player's reload animation
		pPlayer:SetAnimation( PLAYER_RELOAD )
		self:PlaySound( "reload" )
		self:PlayActivity( "reload" )
		
		local flSeqTime = self:SequenceLength()
		self:SetNextReload( CurTime() + flSeqTime )
		
		-- Finish reloading after the animation is finished
		self:AddEvent( "reload", flSeqTime, function()
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
			
			self:SetShotsFired(0)
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
		if ( fCall ) then -- Added by name
			self.m_tEvents[sName:lower()] = { iTime, CurTime() + iTime, fCall }
		else
			self.m_tEvents[next( self.m_tEventHoles ) or #self.m_tEvents] = { sName, CurTime() + sName, iTime }
		end
	end
end

function SWEP:EventActive( sName )
	return self.m_tEvents[sName:lower()] ~= nil
end

function SWEP:RemoveEvent( sName )
	self.m_tEvents[sName:lower()] = nil
end

-- Will only be called serverside in single-player
function SWEP:DoImpactEffect( tr, iDamageType )
	return false
end

-- FIXME: Play from weapon or owner?
function SWEP:PlaySound( sSound )
	local sPlay
	
	if ( self:Silenced() ) then
		sPlay = self:LookupSound( "s_" .. sSound )
		
		if ( sPlay == "" ) then
			sPlay = self:LookupSound( sSound )
		end
	else
		sPlay = self:LookupSound( sSound )
	end
	
	if ( sPlay ~= "" ) then
		self:EmitSound( sPlay )
		
		return true
	end
	
	return false
end

function SWEP:PlayActivity( sActivity, iIndex --[[= nil]], flRate --[[= 1]] )
	if ( sActivity == "primary" ) then
		if ( self:LookupActivity( "dryfire" ) ~= ACT_INVALID and self:Clip1() == 0 ) then
			sActivity = "dryfire"
		end
	elseif ( sActivity == "reload" ) then
		if ( self:LookupActivity( "reload_empty" ) ~= ACT_INVALID and self:Clip1() == 0 ) then
			sActivity = "reload_empty"
		end
	end
	
	local iActivity
	
	if ( self:Silenced() ) then
		iActivity = self:LookupActivity( "s_" .. sActivity )
		
		if ( iActivity == ACT_INVALID ) then
			iActivity = self:LookupActivity( sActivity )
		end
	else
		iActivity = self:LookupActivity( sActivity )
	end
	
	if ( iActivity ~= ACT_INVALID ) then
		local bRet = self:SetIdealActivity( iActivity, iIndex, flRate )
		
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
	
	return false
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

function SWEP:GetBulletCount( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Bullets
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Bullets
end

function SWEP:GetWeaponHoldType()
	return self.m_sCurrentHoldType
end

function SWEP:SetWeaponHoldType( sHold )
	sHold = sHold:lower()
	self.m_sCurrentHoldType = sHold
	self.m_tActivityTranslate = gsweapons.GetHoldType( sHold )
end

function SWEP:FlipsViewModel( iIndex --[[= 0]] )
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

function SWEP:GetReduceShotTime()
	return self.dt.ReduceShotTime
end

function SWEP:SetReduceShotTime( flTime )
	self.dt.ReduceShotTime = flTime
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
	
	return pPlayer:EyeAngles() + pPlayer:GetViewPunchAngles()
end

function SWEP:GetShootSrc()
	return self:GetOwner():GetShootPos()
end

function SWEP:GetShotsFired()
	return self.dt.ShotsFired
end

function SWEP:SetShotsFired( iShots )
	self.dt.ShotsFired = iShots
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

function SWEP:GetZoomActiveTime()
	return self.dt.ZoomActiveTime
end

function SWEP:SetZoomActiveTime( flTime )
	self.dt.ZoomActiveTime = flTime
end

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
	local sSound = self.Sounds[sName] or ""
	
	-- Auto-refresh fix
	if ( istable( sSound ) or string.IsSoundFile( sSound )) then
		self:Precache()
		
		return self.Sounds[sName] or ""
	else
		return sSound
	end
end

function SWEP:SetSpecialLevel( iLevel )
	self.dt.SpecialLevel = iLevel
end

function SWEP:Silenced()
	return self.SpecialType == SPECIAL_SILENCE and self.dt.SpecialLevel ~= 0
end

-- The player is considered to be in-zoom to variable modifiers if they are fully zoomed
-- This prevents quick-scoping for the spread/damage/cooldown benfits
function SWEP:SpecialActive()
	return self.dt.SpecialLevel ~= 0 and self:GetZoomActiveTime() <= CurTime()
end

function SWEP:UsesHands()
	return self.UseHands
end
