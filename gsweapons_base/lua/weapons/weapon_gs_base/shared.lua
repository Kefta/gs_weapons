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
SWEP.ShouldIdle1 = true

SWEP.ViewModel2 = ""
SWEP.ViewModelFlip2 = false
SWEP.ShouldIdle2 = true

SWEP.WorldModel = "models/weapons/w_pistol.mdl" -- Third-person view of the weapon
SWEP.SilencerModel = "" -- World model to use when the weapon is silenced
SWEP.EmptyModel = "" -- World model to use when the grenades are depleted
SWEP.HoldType = "pistol" -- How the player should hold the weapon in third-person http://wiki.garrysmod.com/page/Hold_Types
SWEP.HolsterAnimation = false -- Play an animation when the weapon is being holstered. Only works if the weapon has a holster animation

SWEP.Weight = 0 -- Weight in automatic weapon selection
-- There are two weapon switching algorithms:
-- *Singleplay (true) - Switch to the weapon with the highest weight
-- *Multiplay (false) - Try and find a weapon with the same weight, otherwise, fallback to highest
SWEP.HighWeightPriority = false
-- FIXME: Activity searching system?
-- FIXME: Support sequences
SWEP.Activities = { -- Default activity events
	-- event = ACT_VM_EVENT,
	--[[event2 = {
		ACT_VM_EVENT1, -- Event to use for the first viewmodel
		ACT_VM_EVENT2, -- Event to use for the second viewmodel
		-- Third viewmodel will use ACT_VM_EVENT1 (fallback to viewmodel one) since a third key is not defined
		rate = 0.7, -- Playback rate for the first and second viewmodels
		rate3 = 2, -- Playback rate for the third viewmodel. The "rate#" key has priority over the "rate" key for a specific viewmodel
		idle1 = 5, -- Time until idle for the first view model
		idle2 = {6, 10} -- Time until idle for the second view model. A float is randomly selected in the provided range
		-- The third viewmodel will use the sequence duration of its activity for its idle time
		-- Setting the "idle" key, like "rate", will set the idle time for all viewmodels unless "idle#" is defined
	}]]
	primary = ACT_VM_PRIMARYATTACK,
	primary_empty = ACT_VM_DRYFIRE, -- Used when the last bullet in the clip is fired
	secondary = ACT_VM_SECONDARYATTACK,
	silence = ACT_VM_ATTACH_SILENCER,
	reload = ACT_VM_RELOAD,
	reload_empty = ACT_VM_RELOAD_EMPTY, -- Used when the weapon is reloaded with an empty clip
	empty = ACT_INVALID, -- Used when the weapon fires with no ammo in the clip
	deploy = ACT_VM_DRAW,
	deploy_empty = ACT_VM_DRAW_EMPTY,
	holster = ACT_VM_HOLSTER,
	holster_empty = ACT_VM_HOLSTER_EMPTY,
	idle = ACT_VM_IDLE,
	idle_empty = ACT_VM_IDLE_EMPTY,
	burst = ACT_VM_PRIMARYATTACK,
	pump = ACT_SHOTGUN_PUMP,
	-- For silencers. If a silenced activity isn't available, the weapon will fallback to the non-silenced version
	s_primary = ACT_VM_PRIMARYATTACK_SILENCED,
	s_primary_empty = ACT_VM_DRYFIRE_SILENCED,
	s_silence = ACT_VM_DETACH_SILENCER,
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
	pullback = ACT_VM_PULLBACK_HIGH,
	throw = ACT_VM_THROW
}

-- https://github.com/Facepunch/garrysmod-issues/issues/2346
SWEP.Sounds = { -- Default sound events. If a sound isn't available, nothing will play
	--event = "Sound.Scape",
	--[[event2 = {
		pitch = {50, 100},
		sound = "sound2.wav"
	},
	event3 = {
		"sound3.wav", -- Sound to use for the first viewmodel
		nil, -- The second viewmodel will not play any sound for this event
		{ -- Sound to use for the third viewmodel
			pitch = {10, 100},
			sound = "Sound.Scape2"
		}
	},]]
	deploy = "",
	primary = "Weapon_Pistol.Single",
	secondary = "Weapon_SMG1.Double",
	silence = "Weapon_USP.AttachSilencer",
	zoom = "Default.Zoom",
	burst = "",
	reload = "Weapon_Pistol.Reload",
	empty = "Weapon_Pistol.Empty",
	holster = "",
	pump = "Weapon_Shotgun.Special",
	-- For silencers
	s_deploy = "",
	s_primary = "Weapon_USP.SilencedShot",
	s_secondary = "",
	s_silence = "Weapon_USP.DetachSilencer",
	s_reload = "",
	s_empty = "",
	s_holster = "",
	-- For single reloading
	reload_start = "",
	reload_finish = "Weapon_Shotgun.Special1",
	-- For melee weapons
	hit = "Weapon_Crowbar.Melee_Hit",
	hitworld = "Weapon_Crowbar.Melee_HitWorld",
	miss = "Weapon_Crowbar.Single",
	-- For grenades
	pullback = "",
	throw = ""
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
	AutoReloadOnEmpty = true, -- Automatically reload if the clip is empty and the mouse is not being held
	ReloadOnEmptyFire = false, -- Reload if the weapon is fired with an empty clip
	Spread = vector_origin, -- Bullet spread
	-- These are seperated by primary/secondary so ironsights can lower it
	BobScale = CLIENT and 0.45 or nil, -- Magnitude of the weapon bob
	SwayScale = CLIENT and 0.5 or nil -- Sway deviation
}

SWEP.Secondary = {
	Ammo = "",
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Bullets = -1, -- Change for this variable to be returned by the accessor when bSecondary (IsSpecialActive by default) is true. Set to -1 to disable
	Damage = -1,
	Range = -1,
	Cooldown = -1,
	WalkSpeed = -1,
	RunSpeed = -1,
	FireUnderwater = true,
	InterruptReload = false,
	AutoReloadOnEmpty = false,
	ReloadOnEmptyFire = false,
	Spread = NULL, -- Set to NULL to disable
	BobScale = CLIENT and -1 or nil,
	SwayScale = CLIENT and -1 or nil
}

SWEP.SingleReload = {
	Enable = false,  // True if this weapon reloads 1 round at a time (shotguns)
	QueuedFire = true, -- Queue a primary/secondary fire to activate once the next bullet is put in the chamber
	InitialRound = true -- Give round for the first reload (HL2) or subsequent reloads only (CS:S)
}

SWEP.Burst = {
	Times = { -- Times between burst shots
		0.1, -- Time until first extra shot
		--0.1 -- Time until second extra shot; leave nil to fallback to the previous specified time
	},
	Count = 2, -- Number of extra shots to fire when burst is enabled
	Cooldown = 0.3, -- Cooldown between toggling bursts
	SingleActivity = false -- Only play the initial shooting activity during burst firing
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
	ZoomTime = 1, -- Time it takes to move viewmodel in
	Hold = false, -- Require secondary fire key to be held to use IronSights as opposed to just toggling the state
	DrawCrosshair = false, -- Draw crosshair when IronSights is active
	FireInZoom = false, -- Allow fire during zoom/unzoom
	Pos = CLIENT and vector_origin or nil, -- Local positional translation of the viewmodel
	Ang = CLIENT and angle_zero or nil -- Local angular translation of the viewmodel
}

SWEP.Grenade = {
	Delay = -1, -- Set to -1 to disable any delay. 0 is 1 tick delay. The length of delay until the grenade is thrown
	UpdateHoldType = true, -- Update the holdtype to "normal" when out of grenades
	Damage = SERVER and 125 or nil, -- (Serverside) Damage value of the grenade
	Radius = SERVER and 250 or nil, -- (Serverside) Damage radius value of the grenade
	Class = SERVER and "npc_grenade_frag" or nil, -- (Serverside) Grenade class to throw
	Timer = SERVER and 2.5 or nil -- (Serverside) Grenade timer until detonation
}

SWEP.Melee = {
	DotRange = 0.70721, -- Not sure about this constant, but it's close to 1/sqrt(2)
	HullRadius = 1.732, -- sqrt(3)
	TestHull = Vector(16, 16, 16),
	DamageType = DMG_CLUB,
	Mask = MASK_SHOT_HULL
}

SWEP.DoPump = false -- Do a pump animation after shooting

SWEP.AutoSwitchOnEmpty = false -- Automatically switch away if the weapon is completely empty and the mouse is not being held. Ignores AutoSwitchFrom
SWEP.SwitchOnEmptyFire = false -- Switch away if the weapon is fired with no ammo
SWEP.RemoveOnEmpty = false -- Remove the weapon when it runs out of ammo
SWEP.UseClip1ForSecondary = false -- Check/remove ammo from Clip1 when secondary firing

SWEP.AutoSwitchFrom = true -- Allows auto-switching away from the weapon. This is only checked for engine switching and is ignored when AutoSwitchOnEmpty is true
SWEP.AutoSwitchTo = true -- Allows auto-switching to the weapon
SWEP.BlockDeployOnEmpty = false -- Block deploying the weapon if it has no ammo

SWEP.UnderwaterCooldown = 0.2 --  Time between empty sound if the weapon cannot fire underwater. Set to -1 to only play once per mouse press
SWEP.EmptyCooldown = -1 -- Time between empty sounds. Set to -1 to only play once per mouse press
SWEP.ShotDecreaseTime = 0.0225 -- (CS:S crosshair) How fast the shot count should decrease per shot
SWEP.ShotInitialDecreaseTime = 0.4 -- (CS:S crosshair) How long until the shot decrement starts after the mouse is lifter
SWEP.HolsterReloadTime = -1 -- How long it should take for the weapon to reload if the player holsters during a reload. Set to -1 to cancel all reload activity on holster

SWEP.TracerFreq = 2 -- How often the tracer effect should show - (1 / SWEP.TracerFreq) frequency
SWEP.TracerName = "Tracer" -- Tracer effect to use

SWEP.TriggerBoundSize = 36 -- Trigger box size to pickup the weapon off the ground. Set to -1 to disable pickup. // Bloat the box for player pickup

--SWEP.m_WeaponDeploySpeed = 1 -- Do NOT use this, the deploy animation will be cut short by the idle animation! Instead, set the "rate" key in the SWEP.Activities.deploy table

local bSinglePlayer = game.SinglePlayer()
local sFormatOne = "%s_%s"
local sFormatTwo = "%s_%s_%s"

--- Spawn/Constructor
local sm_tPrecached = {} -- Persists through all weapon instances - acts like static keyword in C++

function SWEP:Initialize()
	local sClass = self:GetClass()
	DevMsg( 2, sClass .. " (weapon_gs_base) Initialize" )
	
	--self.FireFunction = nil -- Fire function to use with Shoot. Args are ( pPlayer, tFireBulletsInfo ). nil = Default FireBullets
	--self.PunchDecayFunction = nil -- Function to decay the punch angle manually. Args are ( pPlayer, aPunchAngle ). The function should modify aPunchAngle and return it. nil = Default decaying
	
	self.m_bAutoSwitchFrom = self.AutoSwitchFrom
	self.m_bDeployedNoAmmo = false
	self.m_bInHolsterAnim = false
	self.m_bInitialized = true
	self.m_bHoldTypeUpdate = false
	self.m_bHolsterAnimDone = false
	self.m_sHoldType = self.HoldType
	self.m_sWorldModel = self.WorldModel
	self.m_tDryFire = { [0] = false, false, false }
	self.m_tEvents = {}
	self.m_tEventHoles = {}
	self.m_tRemovalQueue = {}
	self.m_tUseViewModel = { [0] = false, false, false }
	
	self:SetHoldType( self.m_sHoldType )
	
	-- If it was created silenced, make it appear that way
	self:UpdateThirdPerson()
	
	if ( self.TriggerBoundSize == -1 ) then
		self:UseTriggerBounds( false, 0 )
	else
		self:UseTriggerBounds( true, self.TriggerBoundSize )
	end
	
	if ( CLIENT ) then
		self.m_bDeployed = false
		
		-- 0 = At rest, zoomed out
		-- 1 = Zooming in
		-- 2 = At rest, zoomed in
		-- 3 = Zooming out
		self.m_iIronSightsState = 0
		
		self.BobScale = self.Primary.BobScale
		self.SwayScale = self.Primary.SwaScale
		
		-- For CS:S crosshair
		self.m_iAmmoLastCheck = 0
		self.m_flCrosshairDistance = 0
	end
	
	if ( not sm_tPrecached[sClass] ) then
		sm_tPrecached[sClass] = true
		self:Precache()
	end
end

function SWEP:Precache()
	local sClass = self:GetClass()
	local tWeapon = weapons.GetStored( sClass )
	DevMsg( 2, sClass .. " (weapon_gs_base) Precache" )
	
	if ( CLIENT and self.KillIcon ~= '' ) then
		-- Add KillIcon
		killicon.AddFont( sClass, self.KillIconFont, self.KillIcon, self.KillIconColor )
	end
	
	-- Precache all weapon models
	util.PrecacheModel( self.ViewModel )
	util.PrecacheModel( self.ViewModel1 )
	util.PrecacheModel( self.ViewModel2 )
	util.PrecacheModel( self.m_sWorldModel )
	util.PrecacheModel( self.SilencerModel )
	
	-- Setup and precache all weapon sounds
	for k, s in pairs( self.Sounds ) do
		if ( k ~= "BaseClass" ) then -- Stupid pseudo-inheritance
			-- Register sound table
			if ( istable( s )) then
				if ( not tWeapon.Sounds ) then
					tWeapon.Sounds = {}
				end
				
				if ( s.sound ) then
					if ( not s.name ) then
						s.name = sClass .. "." .. k
					end
					
					if ( not s.channel ) then
						s.channel = CHAN_WEAPON
					end
					
					sound.Add( s )
					self.Sounds[k] = s.name
					tWeapon.Sounds[k] = s.name
					util.PrecacheSound( s.name )
				else
					local sName = s.name or sClass .. "." .. k
					local bAdded = false
					local tDefault
					
					for i = 1, 3 do
						local Sub = s[i]
						
						if ( Sub ) then
							bAdded = true
							
							if ( istable( Sub )) then
								local sNewName = sName .. i
								
								if ( Sub.name ) then
									-- Register the preset name, but the weapon won't use it
									sound.Add( Sub )
								end
								
								Sub.name = sNewName
								sound.Add( Sub )
								util.PrecacheSound( sNewName )
								
								if ( not tDefault ) then
									tDefault = Sub
								end
							elseif ( string.IsSoundFile( Sub )) then
								local sNewName = sName .. i
								local tSound = {
									name = sNewName,
									channel = CHAN_WEAPON,
									sound = Sub
								}
								
								if ( not tDefault ) then
									tDefault = tSound
								end
								
								sound.Add( tSound )
								util.PrecacheSound( sNewName )
							else
								local tNewSound = sound.GetProperties( Sub )
								
								if ( tNewSound ) then
									local sNewName = sName .. i
									tNewSound.name = sNewName
									sound.Add( tNewSound )
									util.PrecacheSound( sNewName )
									
									if ( not tDefault ) then
										tDefault = tNewSound
									end
								elseif ( tDefault ) then
									local sNewName = sName .. i
									tDefault.name = sNewName
									sound.Add( tDefault )
									util.PrecacheSound( sNewName )
								end
							end
						elseif ( tDefault ) then
							tDefault.name = sName .. i
							sound.Add( tDefault )
							util.PrecacheSound( tDefault.name )
						end
					end
					
					sName = bAdded and sName .. "%d" or ""
					self.Sounds[k] = sName
					tWeapon.Sounds[k] = sName
				end
			-- Create a new sound table from a file
			elseif ( string.IsSoundFile( s )) then
				local sName = sClass .. "." .. k
				
				sound.Add({
					name = sName,
					channel = CHAN_WEAPON,
					sound = s
				})
				
				util.PrecacheSound( sName )
				self.Sounds[k] = sName
				
				if ( not tWeapon.Sounds ) then
					tWeapon.Sounds = {}
				end
				
				tWeapon.Sounds[k] = sName
			-- Assume the sound table already exists
			else
				util.PrecacheSound( s )
			end
		end
	end
end

function SWEP:SetupDataTables()
	self:AddNWVar( "Int", "Burst" )
	self:AddNWVar( "Int", "IronSights" )
	self:AddNWVar( "Int", "ShotsFired" )
	self:AddNWVar( "Int", "ShouldThrow" )
	self:AddNWVar( "Int", "Silenced" )
	self:AddNWVar( "Int", "SwitchWeapon", false ) -- To manage clientside deploying
	self:AddNWVar( "Int", "ZoomLevel" )
	self:AddNWVar( "Float", "LastShootTime" )
	self:AddNWVar( "Float", "NextIdle" )
	self:AddNWVar( "Float", "NextIdle1" )
	self:AddNWVar( "Float", "NextIdle2" )
	self:AddNWVar( "Float", "NextThink" )
	self:AddNWVar( "Float", "NextReload" )
	self:AddNWVar( "Float", "ReduceShotTime" )
	self:AddNWVar( "Float", "ZoomActiveTime" )
	
	-- Below are the default CNetworkVars in the engine for reference
	--self:AddNWVar( "Entity", "Owner" )
	--self:AddNWVar( "Float", "NextPrimaryAttack" )
	--self:AddNWVar( "Float", "NextSecondaryAttack" )
	--self:AddNWVar( "Int", "ViewModelIndex" )
	--self:AddNWVar( "Int", "WorldModelIndex" )
	--self:AddNWVar( "Int", "State" )
	--self:AddNWVar( "Int", "PrimaryAmmoType" )
	--self:AddNWVar( "Int", "SecondaryAmmoType" )
	--self:AddNWVar( "Int", "Clip1" )
	--self:AddNWVar( "Int", "Clip2" )
end

--- Deploy
function SWEP:CanDeploy()
	return true
end

function SWEP:Deploy()
	-- Do not deploy again
	if ( self.dt.SwitchWeapon == -1 and (not CLIENT or self.m_bDeployed) ) then
		return true
	end
	
	if ( self.RemoveOnEmpty and not self:HasAmmo() ) then
		if ( SERVER ) then
			self:Remove()
		end
		
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	// Dead men deploy no weapons
	if ( pPlayer == NULL or not pPlayer:Alive() or self.BlockDeployOnEmpty and not self:HasAmmo() ) then
		return false
	end
	
	if ( self:CanDeploy() ) then
		self:SharedDeploy( false )
		
		return true
	end
	
	return false
end

function SWEP:SharedDeploy( bDelayed )
	-- Clientside does not initialize sometimes
	if ( self.m_bInitialized ) then
		self:UpdateThirdPerson()
	else
		self:Initialize()
	end
	
	DevMsg( 2, self:GetClass() .. " (weapon_gs_base) Deploy" )
	
	self.m_bInHolsterAnim = false
	self.m_bHolsterAnimDone = false
	
	if ( SERVER ) then
		self.dt.SwitchWeapon = -1
	else
		self.m_bDeployed = true
	end
	
	if ( not self:HasAmmo() ) then
		self.m_bDeployedNoAmmo = true
	end
	
	local bRun = not bDelayed and (not bSinglePlayer or SERVER)
	local pPlayer = self:GetOwner()
	
	-- Only client can be delayed
	if ( bRun ) then
		self:PlaySound( "deploy", 0 )
		self:SetZoomLevel(0)
		self:SetReduceShotTime(0)
		self:SetShotsFired(0)
		
		pPlayer:SetFOV(0, 0)
	end
		
	-- Wait for all viewmodels to deploy
	local flSequenceDuration = 0
	
	if ( self.ViewModel == "" ) then
		self.m_tUseViewModel[0] = false
		self.m_tDryFire[0] = false
	else
		local pViewModel = pPlayer:GetViewModel(0)
		
		if ( pViewModel == NULL ) then
			self.m_tUseViewModel[0] = false
			self.m_tDryFire[0] = false
		else
			self.m_tUseViewModel[0] = true
			
			if ( self:PlayActivity( "deploy", 0 )) then
				flSequenceDuration = self:SequenceLength(0)
			end
			
			local iActivity = self:LookupActivity( self:GetDryfireActivity(0), 0 )
			self.m_tDryFire[0] = not (iActivity == ACT_INVALID or pViewModel:SelectWeightedSequence( iActivity ) == -1)
		end
	end
	
	if ( self.ViewModel1 == "" ) then
		self.m_tUseViewModel[1] = false
		self.m_tDryFire[1] = false
	else
		local pViewModel = pPlayer:GetViewModel(1)
		
		if ( pViewModel == NULL ) then
			self.m_tUseViewModel[1] = false
			self.m_tDryFire[1] = false
		else
			self.m_tUseViewModel[1] = true
			pViewModel:SetWeaponModel( self.ViewModel1, self )
			self:PlaySound( "deploy", 1, true )
			
			if ( self:PlayActivity( "deploy", 1 )) then
				flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(1) )
			end
			
			local iActivity = self:LookupActivity( self:GetDryfireActivity(1), 1 )
			self.m_tDryFire[1] = not (iActivity == ACT_INVALID or pViewModel:SelectWeightedSequence( iActivity ) == -1)
		end
	end
		
	if ( self.ViewModel2 == "" ) then
		self.m_tUseViewModel[2] = false
		self.m_tDryFire[2] = false
	else
		local pViewModel = pPlayer:GetViewModel(2)
		
		if ( pViewModel == NULL ) then
			self.m_tUseViewModel[2] = false
			self.m_tDryFire[2] = false
		else
			self.m_tUseViewModel[2] = true
			pViewModel:SetWeaponModel( self.ViewModel2, self )
			self:PlaySound( "deploy", 2, true )
			
			if ( self:PlayActivity( "deploy", 2 )) then
				flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(2) )
			end
			
			local iActivity = self:LookupActivity( self:GetDryfireActivity(2), 2 )
			self.m_tDryFire[2] = not (iActivity == ACT_INVALID or pViewModel:SelectWeightedSequence( iActivity ) == -1)
		end
	end
	
	local iIndex = self:GetShouldThrow()
	
	if ( iIndex < 0 ) then
		iIndex = iIndex * -1
		
		self:AddEvent( "deploy", 0, function()
			if ( pPlayer:GetAmmoCount( self:GetGrenadeAmmoName() ) ~= 0 ) then
				self:SetShouldThrow(0)
				
				local flNewTime = CurTime() + (self:PlayActivity( "deploy", iIndex ) and self:SequenceLength( iIndex ))
				self:SetNextPrimaryFire( flNewTime )
				self:SetNextSecondaryFire( flNewTime )
				self:SetNextReload( flNewTime )
			end
			
			return true
		end )
	end
	
	// Can't shoot again until we've finished deploying
	flSequenceDuration = flSequenceDuration + CurTime()
	self:SetNextPrimaryFire( flSequenceDuration )
	self:SetNextSecondaryFire( flSequenceDuration )
	self:SetNextReload( flSequenceDuration )
end

--- Holster/Remove
function SWEP:CanHolster()
	return true
end

function SWEP:Holster( pSwitchingTo )
	-- Do not holster again
	-- https://github.com/Facepunch/garrysmod-issues/issues/2854
	if ( pSwitchingTo == self or self.dt.SwitchWeapon ~= -1 and not (CLIENT and self.m_bDeployed) ) then
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
					net.Start( "GSWeapons-Holster animation" )
						net.WriteEntity( self )
						net.WriteEntity( pSwitchingTo )
					net.Send( pPlayer )
				end
			elseif ( self.RemoveOnEmpty and not self:HasAmmo() ) then
				if ( SERVER ) then
					self:Remove()
				end
				
				return true
			else
				self:SharedHolster( pSwitchingTo )
				
				if ( SERVER ) then
					-- Clientside does not run Holster in single-player
					if ( bSinglePlayer or pSwitchingTo == NULL ) then
						net.Start( "GSWeapons-Holster" )
							net.WriteEntity( self )
							net.WriteEntity( pSwitchingTo )
						net.Broadcast()
					else
						timer.Create( "GSWeapons-Select holster-" .. self:EntIndex(), 0, 1, function()
							if ( self ~= NULL ) then
								net.Start( "GSWeapons-Holster" )
									net.WriteEntity( self )
									net.WriteEntity( pSwitchingTo )
								net.Broadcast()
							end
						end )
					end
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
	table.Empty( self.m_tRemovalQueue )
	self.m_bInHolsterAnim = true
	
	-- The client state is purged too early in single-player for the event to run on time
	if ( not bSinglePlayer or SERVER ) then
		local pPlayer = self:GetOwner()
		
		self:PlaySound( "holster", 0 )
		
		-- Wait for all viewmodels to holster
		local flSequenceDuration = 0
		
		if ( self.m_tUseViewModel[0] ) then
			if ( self:PlayActivity( "holster", 0 )) then
				flSequenceDuration = self:SequenceLength(0)
			else
				-- FIXME
			end
		end
		
		if ( self.m_tUseViewModel[1] ) then
			self:PlaySound( "holster", 1, true )
			
			if ( self:PlayActivity( "holster", 1 )) then
				flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(1) )
			else
			end
		end
			
		if ( self.m_tUseViewModel[2] ) then
			self:PlaySound( "holster", 2, true )
			
			if ( self:PlayActivity( "holster", 2 )) then
				flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(2) )
			else
			end
		end
		
		-- We have to do this here since events are cleared here
		if ( self.HolsterReloadTime ~= -1 and self:EventActive( "reload" )) then
			local flReloadTime = flSequenceDuration + CurTime() + self.HolsterReloadTime
			
			-- If self is NULL in the hook, there's no way to retrieve what EntIndex it had
			local sName = "GSWeapons-Holster reload-" .. self:EntIndex()
			
			hook.Add( "Think", sName, function()
				if ( self == NULL or pPlayer == NULL ) then
					hook.Remove( "Think", sName )
				elseif ( CurTime() >= flReloadTime ) then
					if ( not self:IsActiveWeapon() ) then
						local iMaxClip = self:GetMaxClip1()
						
						if ( iMaxClip ~= -1 ) then
							local iClip = self:Clip1()
							local sAmmoType = self:GetPrimaryAmmoName()
							local iAmmo = math.min( iMaxClip - iClip, pPlayer:GetAmmoCount( sAmmoType ))
							self:SetClip1( iClip + iAmmo )
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
						
						self:FinishReload()
					end
					
					hook.Remove( "Think", sName )
				end
			end )
		end
		
		self:SetZoomLevel(0)
		
		-- Disable all events during Holster animation
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
		
		local bIsInvalid = pSwitchingTo == NULL
		
		self:AddEvent( "holster", flSequenceDuration, function()
			self.m_bInHolsterAnim = false
			self.m_bHolsterAnimDone = true
			
			if ( bIsInvalid ) then -- Switching to NULL to begin with
				pPlayer.m_pNewWeapon = NULL
			elseif ( pSwitchingTo == NULL ) then -- Weapon disappeared; find a new one or come back to the same weapon
				pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
			else -- Weapon being swapped to is still on the player
				pPlayer.m_pNewWeapon = pSwitchingTo
			end
			
			return true
		end )
	end
end

function SWEP:SharedHolster( pSwitchingTo )
	if ( SERVER ) then
		self.dt.SwitchWeapon = pSwitchingTo:EntIndex()
		bRun = true
	else
		self.m_bDeployed = false
		bRun = not bSinglePlayer
		
		if ( pSwitchingTo:EntIndex() == 0 ) then
			pSwitchingTo = NULL
		end
	end
	
	DevMsg( 2, string.format( "%s (weapon_gs_base) Holster to %s", self:GetClass(), tostring( pSwitchingTo )))
	
	self.m_bDeployedNoAmmo = false
	local pPlayer = self:GetOwner()
	local bIsValid = pPlayer ~= NULL
	local bNoAnim = not self.HolsterAnimation
	local bRun
	
	if ( SERVER ) then
		self.dt.SwitchWeapon = pSwitchingTo:EntIndex()
		bRun = true
	else
		self.m_bDeployed = false
		bRun = not bSinglePlayer
	end
	
	-- These are already set if there was a holster animation
	if ( bNoAnim ) then
		if ( bRun and bIsValid and self.HolsterReloadTime ~= -1 and self:EventActive( "reload" )) then
			local flReloadTime = CurTime() + self.HolsterReloadTime
			local sName = "GSWeapons-Holster reload-" .. self:EntIndex()
			
			hook.Add( "Think", sName, function()
				if ( self == NULL or pPlayer == NULL ) then
					hook.Remove( "Think", sName )
				elseif ( CurTime() >= flReloadTime ) then
					if ( not self:IsActiveWeapon() ) then
						local iMaxClip = self:GetMaxClip1()
						
						if ( iMaxClip ~= -1 ) then
							local iClip = self:Clip1()
							local sAmmoType = self:GetPrimaryAmmoName()
							local iAmmo = math.min( iMaxClip - iClip, pPlayer:GetAmmoCount( sAmmoType ))
							self:SetClip1( iClip + iAmmo )
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
						
						self:FinishReload()
					end
					
					hook.Remove( "Think", sName )
				end
			end )
		end
		
		-- https://github.com/Facepunch/garrysmod-requests/issues/739
		table.Empty( self.m_tEvents )
		table.Empty( self.m_tEventHoles )
		table.Empty( self.m_tRemovalQueue )
		
		if ( bRun ) then
			self:SetZoomLevel(0)
			
			-- Disable all actions during holster
			self:SetNextPrimaryFire(-1)
			self:SetNextSecondaryFire(-1)
			self:SetNextReload(-1)
			self:SetNextIdle(-1)
			self:SetNextIdle1(-1)
			self:SetNextIdle2(-1)
		end
	end
	
	self:PlaySound( "holster", 0 )
	
	if ( self.m_tUseViewModel[1] ) then
		if ( bNoAnim ) then
			self:PlaySound( "holster", 1, true )
		end
		
		if ( bRun and bIsValid ) then
			local pViewModel = pPlayer:GetViewModel(1)
			
			if ( pViewModel ~= NULL ) then
				pViewModel:SetWeaponModel("")
			end
		end
	end
	
	if ( self.m_tUseViewModel[2] ) then
		if ( bNoAnim ) then
			self:PlaySound( "holster", 2, true )
		end
		
		if ( bRun and bIsValid ) then
			local pViewModel = pPlayer:GetViewModel(2)
			
			if ( pViewModel ~= NULL ) then
				pViewModel:SetWeaponModel("")
			end
		end
	end
	
	if ( bRun ) then
		if ( bIsValid ) then
			pPlayer:SetFOV(0, 0) // reset the default FOV
		end
	else
		self.m_bInHolsterAnim = false
		self.m_bHolsterAnimDone = true
	end
end

function SWEP:OnRemove()
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		DevMsg( 2, self:GetClass() .. " (weapon_gs_base) Remove invalid" )
	else
		local bRun = not bSinglePlayer or SERVER
		
		if ( bRun ) then
			pPlayer:SetFOV(0, 0) // reset the default FOV
			
			-- Hide the extra viewmodels
			if ( self.m_tUseViewModel[1] ) then
				local pViewModel = pPlayer:GetViewModel(1)
				
				if ( pViewModel ~= NULL ) then
					pViewModel:SetWeaponModel("")
				end
			end
			
			if ( self.m_tUseViewModel[2] ) then
				local pViewModel = pPlayer:GetViewModel(2)
				
				if ( pViewModel ~= NULL ) then
					pViewModel:SetWeaponModel("")
				end
			end
		end
		
		if ( pPlayer:Health() > 0 and pPlayer:Alive() and self:IsActiveWeapon() ) then
			-- The weapon was removed while it was active and the player was alive, so find a new one
			if ( bRun ) then
				pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority, true )
			end
			
			DevMsg( 2, string.format( "%s (weapon_gs_base) Remove to %s", self:GetClass(), tostring( pPlayer.m_pNewWeapon )))
		else
			DevMsg( 2, self:GetClass() .. " (weapon_gs_base) Remove invalid" )
		end
	end
end

--- Think
function SWEP:Think()
	-- Don't think until we're deployed
	if ( CLIENT and timer.Exists( "GSWeapons-Think deploy-" .. self:EntIndex() )) then
		return
	end
	
	-- Do not think if there is no owner
	local pPlayer = self:GetOwner()
	
	if ( pPlayer == NULL ) then
		return
	end
	
	if ( CLIENT ) then
		if ( not self.m_bDeployed and self.dt.SwitchWeapon == -1 ) then
			-- For clientside deployment in single-player or by use of Player:SelectWeapon()
			timer.Create( "GSWeapons-Think deploy-" .. self:EntIndex(), 0, 1, function()
				if ( self ~= NULL and pPlayer ~= NULL and not self.m_bDeployed and self.dt.SwitchWeapon == -1 ) then
					if ( self:CanDeploy() ) then
						self:SharedDeploy( true )
					end
					
					self.m_bDeployed = true
				end
			end )
			
			return
		end
		
		-- The default bobbing algorithm calls upon the set variables BobScale and SwayScale
		-- So instead of using a conditional accessor, these have to be set as soon as SpecialActive changes
		local bSecondary = self:SpecialActive()
		self.BobScale = bSecondary and self.Secondary.BobScale ~= -1 and self.Secondary.BobScale or self.Primary.BobScale
		self.SwayScale = bSecondary and self.Secondary.SwayScale ~= -1 and self.Secondary.SwayScale or self.Primary.SwayScale
	end
	
	local bFirstTimePredicted = IsFirstTimePredicted()
	
	-- Events are removed one Think after they mark themselves as complete to maintain clientside prediction
	if ( bFirstTimePredicted ) then
		for key, _ in pairs( self.m_tRemovalQueue ) do
			self.m_tRemovalQueue[key] = nil
			self.m_tEvents[key] = nil
			
			if ( isnumber( key )) then
				self.m_tEventHoles[key] = true
			end
		end
	end
	
	-- Events have priority over main think function
	local flCurTime = CurTime()
	
	for key, tbl in pairs( self.m_tEvents ) do
		-- Only start running on the first prediction time
		if ( bFirstTimePredicted ) then
			self.m_tEvents[key][4] = true
		elseif ( not self.m_tEvents[key][4] ) then
			continue
		end
		
		if ( tbl[2] <= flCurTime ) then
			local RetVal = tbl[3]()
			
			if ( RetVal == true ) then
				self.m_tRemovalQueue[key] = true
			else
				-- Update interval
				if ( isnumber( RetVal )) then
					tbl[1] = RetVal
				end
				
				tbl[2] = flCurTime + tbl[1]
			end
		end
	end
	
	self:UpdateThirdPerson()
	
	if ( not (pPlayer:KeyDown( IN_ATTACK ) or pPlayer:KeyDown( IN_ATTACK2 )) ) then
		self:MouseLifted()
	end
	
	local flNextThink = self:GetNextThink()
	
	if ( flNextThink ~= -1 and flNextThink <= flCurTime ) then
		self:ItemFrame()
	end
	
	if ( SERVER or not bSinglePlayer ) then
		if ( self:CanIdle(0) ) then
			self:PlayActivity( "idle", 0, nil, true, self.m_tDryFire[0] and self:GetActivitySuffix(0) == "empty" )
		end
		
		if ( self:CanIdle(1) ) then
			self:PlayActivity( "idle", 1, nil, true, self.m_tDryFire[1] and self:GetActivitySuffix(1) == "empty" )
		end
		
		if ( self:CanIdle(2) ) then
			self:PlayActivity( "idle", 2, nil, true, self.m_tDryFire[2] and self:GetActivitySuffix(2) == "empty" )
		end
	end
end

function SWEP:CanIdle( iIndex --[[= 0]] )
	if ( (not iIndex or iIndex == 0) and (not self.ShouldIdle or self.ViewModel == "")
	or iIndex == 1 and (not self.ShouldIdle1 or self.ViewModel1 == "")
	or iIndex == 2 and (not self.ShouldIdle2 or self.ViewModel2 == "") ) then
		return false
	end
	
	local flNextIdle = iIndex == 1 and self:GetNextIdle1() or iIndex == 2 and self:GetNextIdle2() or self:GetNextIdle()
	
	return flNextIdle ~= -1 and flNextIdle <= CurTime()
end

-- Normal think function replacement
function SWEP:ItemFrame()
end

function SWEP:MouseLifted()
	if ( bSinglePlayer and CLIENT ) then
		return
	end
	
	local pPlayer = self:GetOwner()
	local iThrow = self:GetShouldThrow()
	
	if ( iThrow > 0 ) then
		local iIndex = math.floor( iThrow / GRENADE_COUNT )
		
		pPlayer:SetAnimation( PLAYER_ATTACK1 )
		self:PlaySound( "throw", iIndex )
		
		local flDelay = self.Grenade.Delay
		
		if ( flDelay == -1 ) then
			self:SetLastShootTime( CurTime() )
			self:EmitGrenade( iThrow % GRENADE_COUNT )
			self:PlaySound( "primary", iIndex )
			pPlayer:RemoveAmmo( 1, self:GetGrenadeAmmoName() )
		else
			self:AddEvent( "throw", flDelay, function()
				self:SetLastShootTime( CurTime() )
				self:EmitGrenade( iThrow % GRENADE_COUNT )
				self:PlaySound( "primary", iIndex )
				pPlayer:RemoveAmmo( 1, self:GetGrenadeAmmoName() )
				
				return true
			end )
		end
		
		self:SetShouldThrow( -iIndex )
		local bInitial = true
		
		self:AddEvent( "deploy", self:PlayActivity( "throw", iIndex ) and self:SequenceLength( iIndex ) or 0, function()
			if ( self:EventActive( "throw" )) then
				return 0
			end
			
			if ( pPlayer:GetAmmoCount( self:GetGrenadeAmmoName() ) == 0 ) then
				if ( self.RemoveOnEmpty ) then
					if ( SERVER ) then
						self:Remove()
					end
				elseif ( bInitial ) then
					bInitial = false
					self:SetNextPrimaryFire(0)
					self:SetNextSecondaryFire(0)
					self:SetNextReload(0)
				end
			else
				self:SetShouldThrow(0)
				
				local flNewTime = CurTime() + (self:PlayActivity( "deploy", iIndex ) and self:SequenceLength( iIndex ))
				self:SetNextPrimaryFire( flNewTime )
				self:SetNextSecondaryFire( flNewTime )
				self:SetNextReload( flNewTime )
			end
			
			return true
		end )
	end
	
	-- Just ran out of ammo and the mouse has been lifted, so switch away
	if ( self.AutoSwitchOnEmpty and not self.m_bDeployedNoAmmo and not self:HasAmmo() ) then
		pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
	-- Reload is still called serverside only in single-player
	elseif ( self:Clip1() == 0 and self.Primary.AutoReloadOnEmpty or self:Clip2() == 0 and self.Secondary.AutoReloadOnEmpty ) then
		self:Reload()
	end

	if ( not self:EventActive( "burst" )) then
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

function SWEP:UpdateThirdPerson()
	if ( self:Silenced() ) then
		self.WorldModel = self.SilencerModel
		self.AutoSwitchFrom = self.m_bAutoSwitchFrom
		
		if ( self.m_bHoldTypeUpdate ) then
			if ( self.Grenade.UpdateHoldType ) then
				self:SetHoldType( self.m_sHoldType )
			end
			
			self.m_bHoldTypeUpdate = false
		end
	else
		local iThrow = self:GetShouldThrow()
		
		if ( iThrow > 0 ) then
			self.AutoSwitchFrom = false
			
			if ( self.m_bHoldTypeUpdate ) then
				if ( self.Grenade.UpdateHoldType ) then
					self:SetHoldType( self.m_sHoldType )
				end
				
				self.m_bHoldTypeUpdate = false
			end
		elseif ( iThrow ~= 0 ) then
			self.WorldModel = ""
			self.AutoSwitchFrom = self.m_bAutoSwitchFrom
			
			if ( not self.m_bHoldTypeUpdate ) then
				if ( self.Grenade.UpdateHoldType ) then
					self:SetHoldType( "normal" )
				end
				
				self.m_bHoldTypeUpdate = true
			end
		else
			self.WorldModel = self.m_sWorldModel
			self.AutoSwitchFrom = self.m_bAutoSwitchFrom
			
			if ( self.m_bHoldTypeUpdate ) then
				if ( self.Grenade.UpdateHoldType ) then
					self:SetHoldType( self.m_sHoldType )
				end
				
				self.m_bHoldTypeUpdate = false
			end
		end
	end
end
-- FIXME: Add queued reloading and check out secondary fire behaviour
--- Attack
function SWEP:CanPrimaryAttack( iIndex )
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
		if ( iClip ~= 0 ) then
			if ( self.SingleReload.Enable and self.SingleReload.QueuedFire ) then
				local flNextTime = self:SequenceEnd( iIndex )
				self:RemoveEvent( "reload" )
				
				self:AddEvent( "fire", flNextTime, function()
					self:PrimaryAttack()
					
					return true
				end )
				
				-- PrimaryAttack is called before Think
				flNextTime = CurTime() + flNextTime + 0.1
				self:SetNextPrimaryFire( flNextTime )
				self:SetNextSecondaryFire( flNextTime )
				self:SetNextReload( flNextTime )
				
				return false
			-- Interrupt the reload to fire
			elseif ( self.Primary.InterruptReload and (self.Primary.FireUnderwater or iWaterLevel ~= 3) ) then
				-- Stop the reload
				self:SetNextReload( CurTime() - 0.1 )
				self:RemoveEvent( "reload" )
			else
				return false
			end
		else
			return false
		end
	end
	
	-- By default, clip has priority over water
	if ( iClip == 0 or iClip == -1 and self:GetDefaultClip1() ~= -1 and pPlayer:GetAmmoCount( self:GetPrimaryAmmoName() ) == 0 ) then
		self:HandleFireOnEmpty( false, iIndex )
		
		return false
	end
	
	if ( not self.Primary.FireUnderwater and iWaterLevel == 3 ) then
		self:HandleFireUnderwater( false, iIndex )
		
		return false
	end
	
	return true
end

-- Will only be called serverside in single-player
function SWEP:PrimaryAttack()
	if ( self:CanPrimaryAttack(0) ) then
		self:Shoot( false, 0 )
		
		return true
	end
	
	return false
end

function SWEP:CanSecondaryAttack( iIndex )
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
			local flNextTime = self:SequenceEnd( iIndex )
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
	
	if ( iClip == 0 or iClip == -1 and bEmpty and (self.UseClip1ForSecondary and self:GetDefaultClip1() or self:GetDefaultClip2()) ~= -1 ) then
		self:HandleFireOnEmpty( true, iIndex )
		
		return false
	end
	
	if ( not self.Secondary.FireUnderwater and iWaterLevel == 3 ) then
		self:HandleFireUnderwater( true, iIndex )
		
		return false
	end
	
	return true
end

function SWEP:SecondaryAttack()
end

function SWEP:GetShootClip( iIndex --[[= 0]] )
	if ( not iIndex or iIndex == 0 ) then
		return self:Clip1()
	end
	
	return -1
end

function SWEP:SetShootClip( iClip, iIndex --[[= 0]] )
	if ( not iIndex or iIndex == 0 ) then
		self:SetClip1( iClip )
	end
end

function SWEP:Shoot( bSecondary --[[= false]], iIndex --[[= 0]], iClipDeduction --[[= 1]] )
	if ( not iClipDeduction ) then
		iClipDeduction = 1
	end
	
	local iClip = self:GetShootClip( iIndex )
	local bDeductClip = iClip ~= -1
	
	-- Check just in-case the weapon's CanPrimary/SecondaryAttack doesn't check properly
	-- Do NOT let the clip overflow
	if ( bDeductClip and iClipDeduction > iClip ) then
		error( self:GetClass() .. " (weapon_gs_base) Clip overflowed in Shoot! Add check to CanPrimary/SecondaryAttack" )
	end
	
	if ( not iIndex ) then
		iIndex = 0
	end
	
	local bSpecialActive = self:SpecialActive( iIndex )
	local tbl = self:GetShotTable( bSpecialActive )
	local bBurst = self:BurstEnabled( iIndex ) and (not bDeductClip or iClip >= iClipDeduction * 2)
	local flCooldown = bBurst and nil or self:GetCooldown( bSpecialActive )
	local pPlayer = self:GetOwner()
	
	if ( bDeductClip ) then
		iClip = iClip - iClipDeduction
		self:SetShootClip( iClip, iIndex )
	end
	
	if ( bBurst ) then
		local tBurst = self.Burst
		local tTimes = tBurst.Times
		local flLastTime = tTimes[1]
		local iCount = tBurst.Count
		local iCurCount = 1
		
		self:AddEvent( "burst", flLastTime, function()
			if ( bDeductClip ) then
				iClip = iClip - iClipDeduction
				self:SetShootClip( iClip )
			end
			
			pPlayer:SetAnimation( PLAYER_ATTACK1 )
			
			self:SetShotsFired( self:GetShotsFired() + 1 )
			self:DoMuzzleFlash( iIndex )
			self:PlaySound( bSecondary and "secondary" or "primary", iIndex )
			
			if ( not tBurst.SingleActivity ) then
				self:PlayActivity( bSecondary and "secondary" or "primary", iIndex )
			end
			
			self:UpdateBurstShotTable( tbl )
			
			local flCurTime = CurTime()
			self:SetLastShootTime( flCurTime )
			
			if ( self.FireFunction ) then
				self.FireFunction( pPlayer, tbl )
			else
				pPlayer:FireBullets( tbl )
			end
			
			if ( iCurCount == iCount or bDeductClip and iClip < iClipDeduction ) then
				local flNewTime = flCurTime + self:GetCooldown( true )
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
		self:SetReduceShotTime(-1)
		
		local tZoom = self.Zoom
		
		if ( tZoom.UnzoomOnFire ) then
			local iLevel = self:GetZoomLevel()
			
			if ( iLevel ~= 0 ) then
				self:SetZoomLevel(0) -- Disable scope overlay
				pPlayer:SetFOV( 0, tZoom.Times.Fire )
				
				if ( tZoom.HideViewModel ) then
					if ( self.m_tUseViewModel[0] ) then
						self:SetVisible( true, 0 )
					end
					
					if ( self.m_tUseViewModel[1] ) then
						self:SetVisible( true, 1 )
					end
						
					if ( self.m_tUseViewModel[2] ) then
						self:SetVisible( true, 2 )
					end
				end
				
				-- Don't rezoom if the clip is empty
				if ( iClip ~= 0 ) then
					self:AddEvent( "rezoom", flCooldown, function()
						local flRezoom = tZoom.Times.Rezoom
						self:SetZoomActiveTime( flRezoom )
						self:SetZoomLevel( iLevel )
						self:SetNextSecondaryFire( flRezoom )
						pPlayer:SetFOV( tZoom.FOV[iLevel], flRezoom )
						
						if ( not tZoom.FireDuringZoom ) then
							self:SetNextPrimaryFire( flRezoom )
						end
						
						if ( tZoom.HideViewModel ) then
							local pPlayer = self:GetOwner()
							
							if ( self.m_tUseViewModel[0] ) then
								self:SetVisible( false, 0 )
							end
								
							if ( self.m_tUseViewModel[1] ) then
								self:SetVisible( false, 0 )
							end
								
							if ( self.m_tUseViewModel[2] ) then
								self:SetVisible( false, 0 )
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
	self:DoMuzzleFlash( iIndex )
	self:PlaySound( bSecondary and "secondary" or "primary", iIndex )
	local bActivity = self:PlayActivity( bSecondary and "secondary" or "primary", iIndex )
	
	local flCurTime = CurTime()
	self:SetLastShootTime( flCurTime )
	
	-- The zoom level needs to be set before PlayActivity but the times need to be set after
	-- So do two seperate burst blocks
	if ( bBurst or self.DoPump ) then
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
	else
		local flNextTime = flCurTime + flCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
		self:SetNextReload( flNextTime )
	end
	
	if ( self.FireFunction ) then
		self.FireFunction( pPlayer, tbl )
	else
		pPlayer:FireBullets( tbl )
	end
	
	if ( self.DoPump ) then
		self:AddEvent( "pump", bActivity and self:SequenceLength( iIndex ) or 0, function() 
			self:PlaySound( "pump", iIndex )
			self:PlayActivity( "pump", iIndex )
			
			-- Cooldown is sequence based
			local flNextTime = CurTime() + self:SequenceLength( iIndex )
			self:SetNextPrimaryFire( flNextTime )
			self:SetNextSecondaryFire( flNextTime )
			self:SetNextReload( flNextTime )
			
			return true
		end )
	end
	
	self:Punch( bSecondary )
	
	return bActivity
end

function SWEP:UpdateBurstShotTable( tbl )
	tbl.Dir = self:GetShootAngles():Forward()
	tbl.Src = self:GetShootSrc()
end

function SWEP:Throw( iType --[[= GRENADE_THROW]], iIndex --[[= 0]] )
	if ( not iIndex ) then
		iIndex = 0
	end
	
	-- Complicated way to condense the throw data into one DTVar
	self:SetShouldThrow( (iType or GRENADE_THROW) + GRENADE_COUNT * iIndex )
		
	self:PlaySound( "pullback", iIndex )
	self:PlayActivity( "pullback", iIndex )
	
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	self:SetNextIdle(-1)
end

-- Shared for the HL1 grenade
function SWEP:EmitGrenade()
end

function SWEP:Swing( bSecondary, iIndex )	
	local tMelee = self.Melee
	local pPlayer = self:GetOwner()
	pPlayer:LagCompensation( true )
	
	local vSrc = self:GetShootSrc()
	local vForward = self:GetShootAngles():Forward()
	local vEnd = vSrc + vForward * self:GetRange( bSecondary )
	
	local tbl = {
		start = vSrc,
		endpos = vEnd,
		mask = self.Melee.Mask,
		filter = pPlayer
	}
	local tr = util.TraceLine( tbl )
	local bMiss = tr.Fraction == 1
	
	if ( bMiss ) then
		// hull is +/- 16, so use cuberoot of 2 to determine how big the hull is from center to the corner point
		-- Comment is wrong; it's actually the sqrt(3)
		tbl.endpos = vEnd - vForward * tMelee.HullRadius
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.output = tr
		
		util.TraceHull( tbl )
		bMiss = tr.Fraction == 1 or tr.Entity == NULL
		
		if ( not bMiss ) then
			local vTarget = tr.Entity:GetPos() - vSrc
			vTarget:Normalize()
			
			// YWB:  Make sure they are sort of facing the guy at least...
			if ( vTarget:Dot( vForward ) < tMelee.DotRange ) then
				// Force amiss
				tr.Fraction = 1
				tr.Entity = NULL
				bMiss = true
			else
				util.FindHullIntersection( tbl, tr )
				bMiss = tr.Fraction == 1 or tr.Entity == NULL
			end
		end
	else
		bMiss = tr.Entity == NULL
	end
	
	local bFirstTimePredicted = IsFirstTimePredicted()
	local bNoWater = true
	
	if ( bFirstTimePredicted ) then
		local bHitWater = bit.band( util.PointContents( vSrc ), MASK_WATER ) ~= 0
		local bEndNotWater = bit.band( util.PointContents( tr.HitPos ), MASK_WATER ) == 0
		local trSplash
		tbl.mask = MASK_WATER
		tbl.output = nil
		
		if ( bHitWater and bEndNotWater ) then
			tbl.start = tr.HitPos
			tbl.endpos = vSrc
			trSplash = util.TraceLine( tbl )
		elseif ( not (bHitWater or bEndNotWater) ) then
			tbl.start = vSrc
			tbl.endpos = tr.HitPos
			trSplash = util.TraceLine( tbl )
		end
		
		if ( trSplash and not self:DoSplashEffect( trSplash )) then
			bNoWater = false
			local data = EffectData()
				data:SetOrigin( trSplash.HitPos )
				data:SetScale(8)
				
				if ( bit.band( util.PointContents( trSplash.HitPos ), CONTENTS_SLIME ) ~= 0 ) then
					data:SetFlags( FX_WATER_IN_SLIME )
				end
				
			util.Effect( "watersplash", data )
		end
	end
	
	// Send the anim
	pPlayer:SetAnimation( PLAYER_ATTACK1 )
	
	local bActivity
	
	if ( bMiss ) then
		self:PlaySound( "miss", iIndex )
		bActivity = self:PlayActivity( bSecondary and "miss_alt" or "miss", iIndex )	
	else
		self:PlaySound( (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) and "hit" or "hitworld", iIndex )
		
		bActivity = self:PlayActivity( bSecondary and "hit_alt" or "hit", iIndex )
		self:Hit( bSecondary, tr, vForward, iIndex )
		
		if ( bNoWater and bFirstTimePredicted and not self:DoImpactEffect( tr, tMelee.DamageType )) then
			local data = EffectData()
				data:SetOrigin( tr.HitPos )
				data:SetStart( vSrc )
				data:SetSurfaceProp( tr.SurfaceProps )
				data:SetDamageType( tMelee.DamageType )
				data:SetHitBox( tr.HitBox )
				data:SetEntity( tr.Entity )
			util.Effect( "Impact", data )
		end
	end
	
	// Setup out next attack times
	local flCurTime = CurTime()
	self:SetNextPrimaryFire( flCurTime + self:GetCooldown( bSecondary ))
	self:SetNextSecondaryFire( flCurTime + self:SequenceLength( iIndex ))
	
	self:Punch( bSecondary )
	pPlayer:LagCompensation( false )
	
	return bActivity
end

function SWEP:Hit( bSecondary, tr, vForward )
	local flDamage = self:GetDamage( bSecondary )
	local info = DamageInfo()
		info:SetAttacker( self:GetOwner() )
		info:SetInflictor( self )
		info:SetDamage( flDamage )
		info:SetDamageType( self.Melee.DamageType )
		info:SetDamagePosition( tr.HitPos )
		info:SetReportedPosition( tr.StartPos )
		
		--info:SetDamageForce( vForward * info:GetBaseDamage() * self.Force * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat() )
	tr.Entity:DispatchTraceAttack( info, tr, vForward )
end

function SWEP:Silence( iIndex )
	self:PlaySound( "silence", iIndex )
	local flNewTime = self:PlayActivity( "silence", iIndex ) and self:SequenceLength( iIndex ) or 0
	
	self:AddEvent( "silence", flNewTime, function()
		local iSilence = self:GetSilenced()
		local iIndex = 2^iIndex
		self:SetSilenced( bit.band( iSilence, iIndex ) == 0 and iSilence + iIndex or iSilence - iIndex )
		
		return true
	end )
	
	flNewTime = flNewTime + CurTime()
	self:SetNextPrimaryFire( flNewTime )
	self:SetNextSecondaryFire( flNewTime )
	self:SetNextReload( flNewTime )
end

function SWEP:ToggleBurst( iIndex )
	self:PlaySound( "burst", iIndex )
	self:SetNextSecondaryFire( CurTime() + self.Burst.Cooldown )
	
	local iBurst = self:GetBurst()
	local iIndex = 2^iIndex
	self:SetBurst( bit.band( iBurst, iIndex ) == 0 and iBurst + iIndex or iBurst - iIndex )
	
	self:GetOwner():PrintMessage( HUD_PRINTCENTER, bInBurst and "#GSWeapons_FromBurstFire" or "#GSWeapons_ToBurstFire" )
end

-- Doesn't matter which viewmodel is zoomed in since no specific anims are assosiated with it
function SWEP:AdvanceZoom( iIndex )
	local tZoom = self.Zoom
	local iLevel = (self:GetZoomLevel() + 1) % (tZoom.Levels + 1)
	local iFOV = iLevel == 0 and 0 or tZoom.FOV[iLevel]
	local flTime = tZoom.Times[iLevel] or tZoom.Times[0]
	self:PlaySound( "zoom", iIndex )
	
	if ( iFOV and flTime ) then
		self:SetZoomLevel( iLevel )
		
		local pPlayer = self:GetOwner()
		pPlayer:SetFOV( iFOV, flTime )
		
		if ( tZoom.HideViewModel and iLevel < 2 ) then
			local bVisible = iLevel == 0
			
			if ( self.m_tUseViewModel[0] ) then
				self:SetVisible( bVisible, 0 )
			end
				
			if ( self.m_tUseViewModel[1] ) then
				self:SetVisible( bVisible, 1 )
			end
				
			if ( self.m_tUseViewModel[2] ) then
				self:SetVisible( bVisible, 2 )
			end
		end
	else
		ErrorNoHalt( string.format( "%s (weapon_gs_base) Zoom level or time %u not defined! Zooming out..", self:GetClass(), iLevel ))
		self:SetZoomLevel(0)
		
		local pPlayer = self:GetOwner()
		pPlayer:SetFOV(0, 0)
		
		if ( tZoom.HideViewModel ) then
			if ( self.m_tUseViewModel[0] ) then
				self:SetVisible( true, 0 )
			end
				
			if ( self.m_tUseViewModel[1] ) then
				self:SetVisible( true, 1 )
			end
				
			if ( self.m_tUseViewModel[2] ) then
				self:SetVisible( true, 2 )
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

function SWEP:ToggleIronSights( iIndex )
	if ( self:GetIronSights() == 0 ) then
		self:SetIronSights( iIndex + 1 )
		self:SetZoomActiveTime( CurTime() + self.IronSights.ZoomTime )
	else
		self:SetIronSights(0)
		self:SetZoomActiveTime( CurTime() + self.IronSights.ZoomTime )
	end
end

-- Using this instead of Player:MuzzleFlash() allows all viewmodels to use muzzle flash
function SWEP:DoMuzzleFlash( iIndex )
	if ( not self:Silenced( iIndex )) then
		--[[if ( iIndex ) then
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
		else]]
			self:GetOwner():MuzzleFlash()
		--end
	end
end

function SWEP:Punch()
end

function SWEP:HandleFireOnEmpty( bSecondary --[[= false]], iIndex --[[= 0]] )
	self:PlaySound( "empty", iIndex )
	self:PlayActivity( "empty", iIndex )
	
	local pPlayer = self:GetOwner()
	
	if ( self.EmptyCooldown == -1 ) then
		if ( bSecondary ) then
			self:SetNextSecondaryFire(-1)
			
			self:AddEvent( "empty_secondary", 0, function()
				if ( not pPlayer:KeyDown( IN_ATTACK2 ) or (self.UseClip1ForSecondary and self:Clip1() or self:Clip2()) ~= 0 ) then
					if ( self:GetNextSecondaryFire() == -1 ) then
						self:SetNextSecondaryFire(0)
					end
					
					return true
				end
			end )
		else
			self:SetNextPrimaryFire(-1)
			
			self:AddEvent( "empty_primary", 0, function()
				if ( not pPlayer:KeyDown( IN_ATTACK ) or self:Clip1() ~= 0 ) then
					if ( self:GetNextPrimaryFire() == -1 ) then
						self:SetNextPrimaryFire(0)
					end
					
					return true
				end
			end )
		end
	else
		local flNextTime = CurTime() + self.EmptyCooldown
		self:SetNextPrimaryFire( flNextTime )
		self:SetNextSecondaryFire( flNextTime )
	end
	
	if ( self.SwitchOnEmptyFire and not self:HasAmmo() ) then
		pPlayer.m_pNewWeapon = pPlayer:GetNextBestWeapon( self.HighWeightPriority )
	elseif ( bSecondary and self.Secondary.ReloadOnEmptyFire or not bSecondary and self.Primary.ReloadOnEmptyFire ) then
		self:SetNextReload(0)
		self:Reload()
	end
end

function SWEP:HandleFireUnderwater( bSecondary --[[= false]], iIndex --[[= 0]] )
	self:PlaySound( "empty", iIndex )
	self:PlayActivity( "empty", iIndex )
	
	if ( self.UnderwaterCooldown == -1 ) then
		local pPlayer = self:GetOwner()
		
		if ( bSecondary ) then
			self:SetNextSecondaryFire(-1)
			
			self:AddEvent( "empty_secondary", 0, function()
				if ( not pPlayer:KeyDown( IN_ATTACK2 ) or (self.UseClip1ForSecondary and self:Clip1() or self:Clip2()) ~= 0 ) then
					if ( self:GetNextSecondaryFire() == -1 ) then
						self:SetNextSecondaryFire(0)
					end
					
					return true
				end
			end )
		else
			self:SetNextPrimaryFire(-1)
			
			self:AddEvent( "empty_primary", 0, function()
				if ( not pPlayer:KeyDown( IN_ATTACK ) or self:Clip1() ~= 0 ) then
					if ( self:GetNextPrimaryFire() == -1 ) then
						self:SetNextPrimaryFire(0)
					end
					
					return true
				end
			end )
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
	if ( self:CanReload() ) then
		self:ReloadClips()
		
		return true
	end
	
	return false
end

-- Not specifying an index will call ShouldReloadViewModel for all viewmodels
function SWEP:ReloadClips( iIndex --[[= nil]] )
	local pPlayer = self:GetOwner()
	
	if ( self:GetZoomLevel() ~= 0 ) then
		self:SetZoomLevel(0)
		pPlayer:SetFOV(0, 0)
		
		if ( self.Zoom.HideViewModel ) then
			if ( self.m_tUseViewModel[0] ) then
				self:SetVisible( true, 0 )
			end
				
			if ( self.m_tUseViewModel[1] ) then
				self:SetVisible( true, 1 )
			end
				
			if ( self.m_tUseViewModel[2] ) then
				self:SetVisible( true, 2 )
			end
		end
	end
	
	local tSingleReload = self.SingleReload
	
	if ( tSingleReload.Enable ) then
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
		
		local bVM0 = false
		local bVM1 = false
		local bVM2 = false
		local flSequenceDuration = 0
		local flFinishDuration = 0
		
		if ( iIndex ) then
			if ( self.m_tUseViewModel[iIndex] and self:ShouldReloadViewModel( iIndex )) then
				self:PlaySound( "reload_start", iIndex )
				bVM0 = true
				
				if ( self:PlayActivity( "reload_start", iIndex )) then
					flSequenceDuration = self:SequenceLength( iIndex )
				end
			end
		else
			if ( self.m_tUseViewModel[0] and self:ShouldReloadViewModel(0) ) then
				self:PlaySound( "reload_start", 0 )
				bVM0 = true
				
				if ( self:PlayActivity( "reload_start", 0 )) then
					flSequenceDuration = self:SequenceLength(0)
				end
			end
			
			if ( self.m_tUseViewModel[1] and self:ShouldReloadViewModel(1) ) then
				self:PlaySound( "reload_start", 1, true )
				bVM1 = true
				
				if ( self:PlayActivity( "reload_start", 1 )) then
					flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(1) )
				end
			end
			
			if ( self.m_tUseViewModel[2] and self:ShouldReloadViewModel(2) ) then
				self:PlaySound( "reload_start", 2, true )
				bVM2 = true
				
				if ( self:PlayActivity( "reload_start", 2 )) then
					flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(2) )
				end
			end
		end
		
		local bFirst = true
		
		self:AddEvent( "reload", flSequenceDuration, function()
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
			end
			
			local flSequenceDuration = 0
			
			if ( iIndex ) then
				if ( bVM0 ) then
					if ( self:ShouldReloadViewModel( iIndex )) then
						self:PlaySound( "reload", iIndex )
						
						if ( self:PlayActivity( "reload", iIndex )) then
							flSequenceDuration = self:SequenceLength( iIndex )
						end
					else
						self:PlaySound( "reload_finish", iIndex )
						bVM0 = false
						
						if ( self:PlayActivity( "reload_finish", iIndex )) then
							flFinishDuration = self:SequenceLength( iIndex )
						end
					end
				end
			else
				if ( bVM0 ) then
					if ( self:ShouldReloadViewModel(0) ) then
						self:PlaySound( "reload", 0 )
						
						if ( self:PlayActivity( "reload", 0 )) then
							flSequenceDuration = self:SequenceLength(0)
						end
					else
						self:PlaySound( "reload_finish", 0 )
						bVM0 = false
						
						if ( self:PlayActivity( "reload_finish", 0 )) then
							flFinishDuration = math.max( flFinishDuration, self:SequenceLength(0) )
						end
					end
				end
				
				if ( bVM1 ) then
					if ( self:ShouldReloadViewModel(1) ) then
						self:PlaySound( "reload", 1, true )
						
						if ( self:PlayActivity( "reload", 1 )) then
							flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(1) )
						end
					else
						self:PlaySound( "reload_finish", 1, true )
						bVM1 = false
						
						if ( self:PlayActivity( "reload_finish", 1 )) then
							flFinishDuration = math.max( flFinishDuration, self:SequenceLength(1) )
						end
					end
				end
				
				if ( bVM2 ) then
					if ( self:ShouldReloadViewModel(2) ) then
						self:PlaySound( "reload", 2, true )
						
						if ( self:PlayActivity( "reload", 2 )) then
							flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(2) )
						end
					else
						self:PlaySound( "reload_finish", 2, true )
						bVM2 = false
						
						if ( self:PlayActivity( "reload_finish", 2 )) then
							flFinishDuration = math.max( flFinishDuration, self:SequenceLength(2) )
						end
					end
				end
			end
			
			--FIXME: Post dryfire and reload dynamicsism and finish duration accuracy
			if ( iMaxClip1 == -1 and iMaxClip2 == -1 ) then	
				--pPlayer:DoAnimationEvent( PLAYERANIMEVENT_RELOAD_END )
				self:SetShotsFired(0)
				
				local flNextTime = CurTime() + flFinishDuration
				self:SetNextPrimaryFire( flNextTime )
				self:SetNextSecondaryFire( flNextTime )
				self:SetNextReload( flNextTime )
				self:FinishReload()
				
				return true
			end
			
			if ( bFirst ) then
				bFirst = false
				pPlayer:SetAnimation( PLAYER_RELOAD )
				self:SetNextPrimaryFire(0)
				self:SetNextSecondaryFire(0)
			end
			
			-- Start anim times are different than mid reload
			return flSequenceDuration
		end )
	else
		// Play the player's reload animation
		pPlayer:SetAnimation( PLAYER_RELOAD )
		
		local flSequenceDuration = 0
		
		if ( iIndex ) then
			if ( self.m_tUseViewModel[iIndex] and self:ShouldReloadViewModel( iIndex )) then
				self:PlaySound( "reload", iIndex )
				
				if ( self:PlayActivity( "reload", iIndex )) then
					flSequenceDuration = self:SequenceLength( iIndex )
				end
			end
		else
			if ( self.m_tUseViewModel[0] and self:ShouldReloadViewModel(0) ) then
				self:PlaySound( "reload", 0 )
				
				if ( self:PlayActivity( "reload", 0 )) then
					flSequenceDuration = self:SequenceLength(0)
				end
			end
			
			if ( self.m_tUseViewModel[1] and self:ShouldReloadViewModel(1) ) then
				self:PlaySound( "reload", 1, true )
				
				if ( self:PlayActivity( "reload", 1 )) then
					flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(1) )
				end
			end
			
			if ( self.m_tUseViewModel[2] and self:ShouldReloadViewModel(2) ) then
				self:PlaySound( "reload", 2, true )
				
				if ( self:PlayActivity( "reload", 2 )) then
					flSequenceDuration = math.max( flSequenceDuration, self:SequenceLength(2) )
				end
			end
		end
		
		-- Finish reloading after the animation is finished
		self:AddEvent( "reload", flSequenceDuration, function()
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
end

function SWEP:FinishReload()
end

--- Utilities
function SWEP:AddEvent( sName, iTime, fCall )
	-- Do not add to the event table multiple times
	if ( IsFirstTimePredicted() ) then
		if ( fCall ) then -- Added by name
			sName = sName:lower()
			self.m_tEvents[sName] = { iTime, CurTime() + iTime, fCall, false }
			self.m_tRemovalQueue[sName] = nil -- Fixes edge case of event being added upon removal
		else
			local iPos = next( self.m_tEventHoles )
			
			if ( iPos ) then
				self.m_tEvents[iPos] = { sName, CurTime() + sName, iTime, false }
				self.m_tEventHoles[iPos] = nil
			else
				-- No holes, we can safely use the count operation
				self.m_tEvents[#self.m_tEvents] = { sName, CurTime() + sName, iTime, false }
			end
		end
	end
end

function SWEP:EventActive( sName, bIgnorePrediction --[[= false]] )
	sName = sName:lower()
	
	if ( self.m_tRemovalQueue[sName] == nil ) then
		local tEvent = self.m_tEvents[sName]
		
		return tEvent ~= nil and (bIgnorePrediction or tEvent[4])
	end
	
	return false
end

function SWEP:RemoveEvent( sName )
	self.m_tRemovalQueue[sName:lower()] = true
end

function SWEP:AddNWVar( sType, sName, bAddFunctions --[[= true]], DefaultVal --[[= nil]] )
	-- Handle the table here in-case initialize runs after on the client
	if ( not self.m_tNWVarSlots ) then
		self.m_tNWVarSlots = {}
	end
	
	local iSlot = self.m_tNWVarSlots[sType] or 0
	self.m_tNWVarSlots[sType] = iSlot + 1
	
	self:DTVar( sType, iSlot, sName )
	
	if ( bAddFunctions or bAddFunctions == nil ) then
		self["Get" .. sName] = function( self ) return self.dt[sName] end
		self["Set" .. sName] = function( self, Val ) self.dt[sName] = Val end
	end
	
	if ( DefaultVal ) then
		self.dt[sName] = DefaultVal
	end
end

-- Will only be called serverside in single-player
function SWEP:DoImpactEffect( tr, iDamageType )
	return false
end

function SWEP:DoSplashEffect( tr )
	return false
end

function SWEP:PlaySound( sSound, iIndex, bStrictIndex, bPlayShared --[[= false]] )
	if ( sSound == "" ) then
		return false
	end
	
	-- Not a sound file or sound scape
	if ( not (string.IsSoundFile( sSound ) or sSound:find( '.', 2, true ))) then
		local sPrefix = self:GetSoundPrefix( sSound, iIndex )
		
		if ( sPrefix == "" ) then
			sSound = self:LookupSound( sSound, iIndex, bStrictIndex )
			
			if ( sSound == "" ) then
				return false
			end
		else
			local sPlay = self:LookupSound( string.format( sFormatOne, sPrefix, sSound ), iIndex, bStrictIndex )
			
			if ( sPlay == "" ) then
				sSound = self:LookupSound( sSound, iIndex, bStrictIndex )
				
				if ( sSound == "" ) then
					return false
				end
			else
				sSound = sPlay
			end
		end
	end
	
	if ( bPlayShared or bSinglePlayer or SERVER ) then
		local pPlayer = self:GetOwner()
		
		if ( pPlayer == NULL ) then
			self:EmitSound( sSound )
		else
			pPlayer:EmitSound( sSound )
		end
	end
	
	return true
end

-- SendWeaponAnim that supports idle times and multiple view models
-- Sending in a value for flRate will ignore the SWEP.Activities defined rate
function SWEP:PlayActivity( Activity, iIndex --[[= 0]], flRate --[[= 1]], bStrictPrefix --[[= false]], bStrictSuffix --[[= false]] )
	if ( not iIndex ) then
		iIndex = 0
	end
	
	-- Do not play an animation if the weapon is invisible
	if ( not self:IsVisible( iIndex )) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	local pViewModel = pPlayer:GetViewModel( iIndex )
	
	-- Do not give animations to something that does not exist or is invisible
	if ( pViewModel == NULL ) then
		return false
	end
	
	local bSequence = true
	local iSequence, sActivity, iActivity
	
	-- HACK: Weapons with a very short idle animation (CS:S weapons) were causing some efficiency issues
	-- With how many table lookups/comparisons were being done to find an activity
	-- This code is very messy but the most efficient way of doing it while still supporting tags
	if ( isstring( Activity )) then
		local sPrefix = self:GetActivityPrefix( Activity, iIndex )
		local sSuffix = self:GetActivitySuffix( Activity, iIndex )
		local bPrefix = sPrefix ~= ""
		local bSuffix = sSuffix ~= ""
		
		if ( bPrefix and bSuffix ) then
			sActivity = string.format( sFormatTwo, sPrefix, Activity, sSuffix )
			iActivity = self:LookupActivity( sActivity, iIndex )
			
			if ( iActivity == ACT_RESET ) then
				return self:ResetActivity( iIndex, self:LookupActivityKey( sActivity, "rate", iIndex, nil ))
			end
			
			iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence( iActivity )
			bSequence = iSequence == -1
		end
		
		if ( bSequence ) then
			if ( bPrefix and not (bStrictSuffix and bSuffix) ) then
				sActivity = string.format( sFormatOne, sPrefix, Activity )
				iActivity = self:LookupActivity( sActivity, iIndex )
				
				if ( iActivity == ACT_RESET ) then
					return self:ResetActivity( iIndex, self:LookupActivityKey( sActivity, "rate", iIndex, nil ))
				end
				
				iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence( iActivity )
				bSequence = iSequence == -1
			end
			
			if ( bSequence ) then
				if ( bPrefix and bStrictPrefix ) then
					return false
				end
				
				if ( bSuffix ) then
					sActivity = string.format( sFormatOne, Activity, sSuffix )
					iActivity = self:LookupActivity( sActivity, iIndex )
					
					if ( iActivity == ACT_RESET ) then
						return self:ResetActivity( iIndex, self:LookupActivityKey( sActivity, "rate", iIndex, nil ))
					end
					
					iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence( iActivity )
					bSequence = iSequence == -1
				end
				
				if ( bSequence ) then
					if ( bSuffix and bStrictSuffix ) then
						return false
					end
					
					sActivity = Activity
					iActivity = self:LookupActivity( sActivity, iIndex )
					
					if ( iActivity == ACT_RESET ) then
						return self:ResetActivity( iIndex, self:LookupActivityKey( sActivity, "rate", iIndex, nil ))
					end
					
					iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence( iActivity )
					bSequence = iSequence == -1
				end
			end
		end
		
		if ( not flRate ) then
			flRate = self:LookupActivityKey( sActivity, "rate", iIndex, 1 )
		end
	else
		if ( Activity == ACT_INVALID ) then
			return false
		end
		
		if ( Activity == ACT_RESET ) then
			return self:ResetActivity( iIndex, flRate )
		end
		
		if ( not flRate ) then
			flRate = 1
		end
		
		iSequence = pViewModel:SelectWeightedSequence( Activity )
		bSequence = iSequence == -1
	end
	
	if ( bSequence ) then
		return false
	end
	
	if ( iIndex == 0 ) then
		// Take the new activity
		self:SetSaveValue( "m_IdealActivity", iActivity )
		self:SetSaveValue( "m_nIdealSequence", iSequence )
	end
	
	// Don't use transitions when we're deploying
	if ( Activity ~= "deploy" ) then
		// Find the next sequence in the potential chain of sequences leading to our ideal one
		local iNext = pViewModel:FindTransitionSequence( pViewModel:GetSequence(), iSequence )
		
		if ( iNext ~= iSequence ) then
			// Set our activity to the next transitional animation
			iActivity = ACT_TRANSITION
			iSequence = iNext
		end
	end
	
	if ( iIndex == 0 ) then
		-- Since m_Activity in not avaliable in the save table, run Weapon:Weapon_SetActivity() and override everything afterward
		self:Weapon_SetActivity( iActivity )
		self:SetSequence( iSequence )
		self:SetPlaybackRate( flRate )
	end
	
	if ( SERVER or self:GetPredictable() ) then
		-- Enable the view-model if an animation is sent to it
		--pViewModel:SetWeaponModel( self:GetViewModel( iIndex ), self )
		pViewModel:SendViewModelMatchingSequence( iSequence )
		pViewModel:SetPlaybackRate( flRate )
	end
	
	if ( flRate > 0 ) then
		local flTime = self:LookupActivityKey( sActivity, "idle", iIndex, nil ) or self:SequenceLength( iIndex )
		
		if ( istable( flTime )) then
			random.SetSeed( pPlayer:GetMD5Seed() % 0x100 )
			flTime = random.RandomFloat( flTime[1], flTime[2] )
		end
		
		if ( iIndex == 1 ) then
			self:SetNextIdle1( flTime / flRate + CurTime() )
		elseif ( iIndex == 2 ) then
			self:SetNextIdle2( flTime / flRate + CurTime() )
		else
			self:SetNextIdle( flTime / flRate + CurTime() )
		end
	else -- Invalid rate; reset idle time
		if ( iIndex == 1 ) then
			self:SetNextIdle1(0)
		elseif ( iIndex == 2 ) then
			self:SetNextIdle2(0)
		else
			self:SetNextIdle(0)
		end
	end
	
	return true
end

function SWEP:ResetActivity( iIndex --[[= 0]], flRate --[[= nil]] )
	local pViewModel = self:GetOwner():GetViewModel( iIndex )
	
	if ( pViewModel == NULL ) then
		return false
	end
	
	pViewModel:SetCycle(0)
	
	if ( flRate ) then
		pViewModel:SetPlaybackRate( flRate )
	else
		flRate = pViewModel:GetPlaybackRate()
	end
		
	if ( flRate > 0 ) then
		if ( iIndex == 1 ) then
			self:SetNextIdle1( self:SequenceLength(1) / flRate + CurTime() )
		elseif ( iIndex == 2 ) then
			self:SetNextIdle2( self:SequenceLength(2) / flRate + CurTime() )
		else
			self:SetNextIdle( self:SequenceLength(0) / flRate + CurTime() )
		end
	end
	
	return true
end

function SWEP:TranslateActivity( iAct )
	return self.m_tActivityTranslate[iAct] or -1
end

-- Used by PlayActivity to detect when to add the _empty tag
function SWEP:ViewModelEmpty( iIndex --[[= 0]] )
	if ( not iIndex or iIndex == 0 ) then
		return self:Clip1() == 0
	end
	
	return false
end

-- Used by Reload to know when to play the reload anim
function SWEP:ShouldReloadViewModel( iIndex --[[= 0]] )
	if ( not iIndex or iIndex == 0 ) then
		return self:Clip1() ~= self:GetMaxClip1()
	end
	
	return false
end

--- Accessors/Modifiers
-- The functions commented out are already in the weapon metatable
--[[function SWEP:AllowsAutoSwtichFrom()
	return self.AutoSwitchFrom
end

function SWEP:AllowsAutoSwitchTo()
	return self.AutoSwitchTo
end]]

function SWEP:BurstEnabled( iIndex )
	if ( iIndex ) then
		return bit.band( self:GetBurst(), 2^iIndex ) ~= 0
	end
	
	return self:GetBurst() ~= 0
end

function SWEP:GetBulletCount( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.Bullets
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Bullets
end

function SWEP:GetWeaponHoldType()
	return self.HoldType
end

function SWEP:SetWeaponHoldType( sHold )
	sHold = sHold:lower()
	self.HoldType = sHold
	self.m_tActivityTranslate = gsweapons.GetHoldType( sHold )
end

function SWEP:FlipsViewModel( iIndex --[[= 0]] )
	return iIndex == 1 and self.ViewModelFlip1 or iIndex == 2 and self.ViewModelFlip2 or self.ViewModelFlip
end

function SWEP:GetActivityPrefix( sActivity, iIndex )
	if ( self:Silenced( iIndex )) then
		return "s"
	end
	
	return ""
end

function SWEP:GetActivitySuffix( sActivity, iIndex )
	if ( sActivity ~= "empty" and self:ViewModelEmpty( iIndex )) then
		return "empty"
	end
	
	return ""
end

function SWEP:GetSoundPrefix( sSound, iIndex )
	if ( self:Silenced( iIndex )) then
		return "s"
	end
	
	return ""
end

function SWEP:GetCooldown( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.Cooldown
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Cooldown
end

function SWEP:GetDamage( bSecondary )
	if ( bSecondary ) then
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

function SWEP:GetDryfireActivity( iIndex --[[= 0]] )
	if ( not iIndex or iIndex == 0 ) then
		return "primary_empty"
	end
	
	return ""
end

--[[function SWEP:GetMaxClip1()
	return self.Primary.ClipSize
end

function SWEP:GetMaxClip2()
	return self.Secondary.ClipSize
end]]

function SWEP:GetMuzzleAttachment( iEvent )
	-- Assume first attachment
	return iEvent and (iEvent - 4991) / 10 or 1
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

function SWEP:GetGrenadeAmmoName( iIndex )
	return self:GetPrimaryAmmoName()
end

--[[function SWEP:GetPrintName()
	return self.PrintName
end]]

function SWEP:GetRange( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.Range
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Range
end

function SWEP:GetRunSpeed( bSecondary )
	if ( bSecondary ) then
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

function SWEP:GetShotTable( bSecondary )
	return {
		AmmoType = bSecondary and not self.UseClip1ForSecondary
			and self:GetSecondaryAmmoName() or self:GetPrimaryAmmoName(),
		Damage = self:GetDamage( bSecondary ),
		Dir = self:GetShootAngles( bSecondary ):Forward(),
		Distance = self:GetRange( bSecondary ),
		--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
		Num = self:GetBulletCount( bSecondary ),
		Spread = self:GetSpread( bSecondary ),
		Src = self:GetShootSrc( bSecondary ),
		Tracer = self.TracerFreq,
		TracerName = self.TracerName
	}
end

function SWEP:GetSpread( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.Spread
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.Spread
end

--[[function SWEP:GetSlot()
	return self.Slot
end

function SWEP:GetSlotPos()
	return self.SlotPos
end]]

function SWEP:GetViewModel( iIndex --[[= 0]] )
	return iIndex == 1 and self.ViewModel1 or iIndex == 2 and self.ViewModel2 or self.ViewModel
end

function SWEP:GetWalkSpeed( bSecondary )
	if ( bSecondary ) then
		local flSpecial = self.Secondary.WalkSpeed
		
		if ( flSpecial ~= -1 ) then
			return flSpecial
		end
	end
	
	return self.Primary.WalkSpeed
end

--[[function SWEP:GetWeaponViewModel()
	return self.ViewModel
end

function SWEP:GetWeaponWorldModel()
	return self.WorldModel
end

function SWEP:GetWeight()
	return self.Weight
end]]

function SWEP:IronSightsEnabled()
	return self:GetIronSights() > 0
end

-- Returns the activity and playback rate
function SWEP:LookupActivity( sName, iIndex --[[= 0]] )
	local Activity = self.Activities[sName]
	
	if ( Activity ) then
		-- Enum
		if ( isnumber( Activity )) then
			return Activity
		end
		
		if ( not iIndex or iIndex == 0 ) then
			return Activity[1] or ACT_INVALID
		end
		
		return Activity[iIndex + 1] or Activity[1] or ACT_INVALID
	end
	
	return ACT_INVALID
end

-- FIXME: Remove default
function SWEP:LookupActivityKey( sName, sKey, iIndex, Default )
	local Activity = self.Activities[sName]
	
	return Activity and istable( Activity ) and (Activity[sKey .. iIndex + 1] or Activity[sKey]) or Default
end

-- FIXME: Do more GetProperties checks?
function SWEP:LookupSound( sName, iIndex --[[= 0]], bStrictIndex --[[= false]] )
	local sSound = self.Sounds[sName]
	
	if ( sSound ) then
		-- Auto-refresh fix
		if ( istable( sSound ) or string.IsSoundFile( sSound )) then
			self:Precache()
			
			sSound = self.Sounds[sName]
			
			if ( not sSound ) then
				return ""
			end
		end
		
		if ( not iIndex or iIndex == 0 or bStrictIndex ) then
			return string.format( sSound, iIndex or 0 )
		end
		
		local sFormatSound = string.format( sSound, iIndex )
		
		if ( sound.GetProperties( sFormatSound )) then
			return sFormatSound
		end
		
		return string.format( sSound, 0 )
	end
	
	return ""
end

function SWEP:Silenced( iIndex --[[= nil]] )
	if ( iIndex ) then
		return bit.band( self:GetSilenced(), 2^iIndex ) ~= 0
	end
	
	return self:GetSilenced() ~= 0
end

-- The player is considered to be in-zoom to variable modifiers if they are fully zoomed
-- This prevents quick-scoping for the spread/damage/cooldown benfits
function SWEP:SpecialActive( iIndex --[[= nil]] )
	return (self:GetZoomLevel() > 0 or self:Silenced( iIndex ) or self:BurstEnabled( iIndex )) and self:GetZoomActiveTime() <= CurTime()
end

function SWEP:UsesHands()
	return self.UseHands
end
