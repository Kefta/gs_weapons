hook.Call("GS-Weapons-Load") -- Load the other weapons
-- FIXME: Burst going too fast, playing anim with even one in the clip left
-- FIXME: Deploying not working correctly
-- FIXME: Make yaw offsets network vars in single-player
-- FIXME: Add custom __index
-- FIXME: Change GetShootPos to match punch angle

--- Base
-- This is the superclass
SWEP.Base = "gs_baseweapon"
SWEP.NoTranslateBase = false -- Don't translate the base string when loading weapons with RegisterWeaponsFromFolder
SWEP.GSWeapon = true -- For hooks to know

--- Selection/Menu
SWEP.PrintName = "GSBase" -- Display name
SWEP.Author = "code_gs" -- Not displayed on weapon panels in this base

SWEP.Spawnable = false -- Displays the weapon in the spawn menu. This must be defined in every weapon!
SWEP.AdminOnly = false -- Restricts weapon spawning to admin+

SWEP.Slot = 0 -- Key (minus one) to press to get to the weapon's category in the weapon selection 
SWEP.SlotPos = 0 -- Category in the weapon selection (minus one) this weapon appears in

--- Weapon demeanour
SWEP.ViewModelCount = 1 -- Sets how many viewmodels are precached for use. Max of "3" is supported

SWEP.ViewModel = "models/weapons/v_pistol.mdl" -- First-person model of the weapon. An empty string will hide the viewmodel
SWEP.CModel = "" -- C-model of the weapon. Used when gs_weapons_usecmodels is set to 1. Leave as an empty string for this convar to have no effect on the weapon
SWEP.UseHands = false -- Show player model hands on the weapon

SWEP.ViewModel1 = "" -- Second first-person model
SWEP.CModel1 = ""
SWEP.UseHands1 = false

SWEP.ViewModel2 = ""
SWEP.CModel2 = ""
SWEP.UseHands2 = false

SWEP.WorldModel = "models/weapons/w_pistol.mdl" -- Third-person view of the weapon
SWEP.SilencerModel = "" -- World model to use when the weapon is silenced
SWEP.DroppedModel = "" -- World model to use when the weapon is dropped. Silencer model takes priotiy
SWEP.ReloadModel = "" -- World model to use during reload. Silencer model takes priority
SWEP.HoldType = "pistol" -- How the player should hold the weapon in third-person http://wiki.garrysmod.com/page/Hold_Types

SWEP.Weight = 0 -- Weight in automatic weapon selection
-- There are two weapon switching algorithms:
-- *Singleplay (true) - Switch to the weapon with the highest weight
-- *Multiplay (false) - Try and find a weapon with the same weight, otherwise, fallback to highest
SWEP.HighWeightPriority = false

SWEP.SoundPrefixes = {
	s = function(self, iIndex) return self:GetSilenced(iIndex) end
}

SWEP.Sounds = {-- Default sound events. If a sound isn't available, nothing will play
	--[[
	event = "Sound.Scape", -- Sound manifest
	event2 = "foobar/sound.wav", -- Sound file
	event3 = "sound_foobar.ogg",
	event2 = {
		pitch = {50, 100},
		sound = "sound.wav" -- https://wiki.garrysmod.com/page/Structures/SoundData
	},
	event3 = {
		"sound1.wav", -- Randomly selected sound
		"sound2.wav",
		"sound3.wav"
	},
	event3_1 = "sound.wav" -- The second viewmodel will play this sound. Other viewmodels will use event3's definition
	]]
	--- Core sounds
	draw = "",
	empty = "Weapon_Pistol.Empty",
	reload = "Weapon_Pistol.Reload",
	holster = "",
	-- Single reloading
	reloadstart = "",
	reloadfinish = "",
	-- Shooting
	shoot = "Weapon_Pistol.Single",
	shoot2 = "",
	pump = "Weapon_Shotgun.Special1",
	-- Melee
	hit = "Weapon_Crowbar.Melee_Hit",
	hit2 = "Weapon_Crowbar.Melee_Hit",
	hitworld = "Weapon_Crowbar.Melee_HitWorld",
	hitworld2 = "Weapon_Crowbar.Melee_HitWorld",
	miss = "Weapon_Crowbar.Single",
	miss2 = "Weapon_Crowbar.Single",
	-- Grenades
	pullback = "",
	throw = "",
	-- Events
	silence = "",
	lower = "",
	deploy = "",
	burst = "",
	zoom = "",
	-- Silenced
	s_shoot = "Weapon_USP.SilencedShot"
}

SWEP.StrictPrefixes = {
	s = function(self, iIndex) return self:GetSilenced(iIndex) end,
	l = function(self, iIndex) return self:GetLowered(iIndex) end
}

SWEP.StrictSuffixes = {
	empty = function(self, iIndex)
		if (self:GetClip(false, iIndex) == 0) then
			local pViewModel = self:GetOwner():GetViewModel(iIndex)
			
			if (pViewModel:IsValid()) then
				-- Only play if the dryfire activity actually exists
				-- FIXME: This is really dumb
				local Activity = self:LookupActivity("shoot_empty", iIndex)
				
				if (Activity == ACT_INVALID) then
					return false
				end
				
				return (isstring(Activity) and pViewModel:LookupSequence(Activity) or pViewModel:SelectWeightedSequence(Activity)) ~= -1
			end
		end
		
		return false
	end
}

SWEP.WeakPrefixes = {
	d = function(self, iIndex) return self:GetBipodDeployed(iIndex) end
}

SWEP.WeakSuffixes = {
	--sprint = function() return false end
}

SWEP.Activities = { -- Default activity events
	--[[
	event = ACT_VM_EVENT, -- Activity enum
	event2 = "some_sequence", -- Viewmodel sequence string
	event3 = {
		"some_other_sequence",
		rate = 0.7, -- Playback rate for the viewmodels. Will use "1" if not defined
		idle = 5 -- Time until idle. Will use sequence duriation if not defined
	},
	event4 = {
		ACT_VM_EVENT1, -- Randomly selected activity
		ACT_VM_EVENT2,
		rate = {2, 5}, -- Randomly selects a float between [min, max)
		idle = {1, 3}
	},
	event4_2 = ACT_VM_EVENT, -- The third viewmodel will use this activity. Other viewmodels will use event4's definition
	event5 = ACT_VM_EVENT,
	event5_empty = ACT_VM_EVENT1, -- When the weapon is empty, it will use this instead of event5
	event5_empty_0 = ACT_VM_EVENT2 -- When the first viewmodel is empty, it will use this. Other viewmodels will use event5_empty
	]]
	
	--- Core activities
	draw = ACT_VM_DRAW,
	empty = ACT_INVALID, -- Used when the weapon fires with no ammo in the clip
	reload = ACT_VM_RELOAD,
	holster = ACT_VM_HOLSTER,
	idle = ACT_VM_IDLE,
	-- Single reloading
	reloadstart = ACT_SHOTGUN_RELOAD_START,
	reloadfinish = ACT_SHOTGUN_RELOAD_FINISH,
	-- Shooting
	shoot = ACT_VM_PRIMARYATTACK,
	shoot2 = ACT_VM_SECONDARYATTACK,
	pump = ACT_SHOTGUN_PUMP,
	-- Melee
	hit = ACT_VM_HITCENTER,
	hit2 = ACT_VM_HITCENTER2,
	miss = ACT_VM_MISSCENTER,
	miss2 = ACT_VM_MISSCENTER2,
	-- Grenades
	pullback = ACT_VM_PULLBACK_HIGH,
	throw = ACT_VM_THROW,
	-- Events
	silence = ACT_VM_ATTACH_SILENCER,
	lower = ACT_VM_IDLE_TO_LOWERED,
	deploy = ACT_VM_DEPLOY,
	burst = ACT_INVALID,
	
	-- Tagged activities - if a tagged version isn't available, the weapon will fallback to the core equivalent. Etc. "s_shoot" will go to "shoot"
	
	--- Prefixes
	-- Silenced
	s_draw = ACT_VM_DRAW_SILENCED,
	s_reload = ACT_VM_RELOAD_SILENCED,
	s_idle = ACT_VM_IDLE_SILENCED,
	s_silence = ACT_VM_DETACH_SILENCER,
	s_shoot = ACT_VM_PRIMARYATTACK_SILENCED,
	-- Lowered
	l_idle = ACT_VM_IDLE_LOWERED,
	l_lower = ACT_VM_LOWERED_TO_IDLE,
	-- Deployed
	d_draw = ACT_VM_DRAW_DEPLOYED,
	d_reload = ACT_VM_RELOAD_DEPLOYED,
	d_idle = ACT_VM_IDLE_DEPLOYED,
	d_shoot = ACT_VM_PRIMARYATTACK_DEPLOYED,
	d_deploy = ACT_VM_UNDEPLOY,
	
	--- Suffixes
	-- Empty
	draw_empty = ACT_VM_DRAW_EMPTY,
	reload_empty = ACT_VM_RELOAD_EMPTY, -- Used when the weapon is reloaded with an empty clip
	holster_empty = ACT_VM_HOLSTER_EMPTY,
	idle_empty = ACT_VM_IDLE_EMPTY,
	shoot_empty = ACT_VM_DRYFIRE, -- Used when the last bullet in the clip is fired
	deploy_empty = ACT_VM_DEPLOY_EMPTY,
	-- Sprint
	idle_sprint = ACT_VM_SPRINT_IDLE,
	
	--- Prefix + Suffix
	-- Silenced empty
	s_shoot_empty = ACT_VM_DRYFIRE_SILENCED,
	-- Deployed empty
	d_idle_empty = ACT_VM_IDLE_DEPLOYED_EMPTY,
	d_deploy_empty = ACT_VM_UNDEPLOY_EMPTY,
	d_shoot_empty = ACT_VM_PRIMARYATTACK_DEPLOYED_EMPTY
}

-- Events defined by code_gs.weapons.RegisterAnimEvent. Weapon model anim events. Set to "" to block engine execution
SWEP.EventStyle = {
	-- CS:S bullet ejection
	[20] = "css",
	
	-- HL2 muzzle flashes
	[21] = "default", -- First-person
	[22] = "default", -- Third-person
	
	-- HL2 melee hit
	[3001] = "",
	
	-- Grenades
	-- Throw states are handled by Think events
	[3005] = "",
	[3013] = "",
	[3016] = "",
	
	-- Reload
	[3015] = "default",
	
	-- Sequence end
	-- Sequence lengths are managed by network vars
	[3900] = "",
	
	-- CS:S muzzle flash
	[5001] = "css", -- First-person, Attachment 0
	[5003] = "css", -- Third-person, Attachment 0
	[5011] = "css", -- First-person, Attachment 1
	[5013] = "css", -- Third-person, Attachment 1
	[5021] = "css", -- First-person, Attachment 2
	[5023] = "css", -- Third-person, Attachment 2
	[5031] = "css", -- First-person, Attachment 3
	[5033] = "css", -- Third-person, Attachment 3
	
	-- HL2 bullet ejection
	[6001] = "default",
	
	-- DoD:S bullet ejection
	[6002] = "dod"
}

--- Weapon behaviour
SWEP.Primary = {
	-- Ammo
	Ammo = "", -- Ammo type declared by game.GetAmmoType or exists by default http://wiki.garrysmod.com/page/Default_Ammo_Types
	ClipSize = -1, -- Max amount of ammo in clip
	DefaultClip = -1, -- Amount of ammo weapon spawns with
	-- General stats
	Cooldown = 0.15, -- Time between firing
	Damage = 42, -- Bullet/melee damage // Douglas Adams 1952 - 2001
	EmptyCooldown = -1, -- Time between empty sounds. Set to -1 to only play once per mouse press
	Force = 1, -- Force scale of shot/swing
	Range = MAX_TRACE_LENGTH, -- Bullet/melee distance
	UnderwaterCooldown = 0.2, --  Time between empty sound if the weapon cannot fire underwater. Set to -1 to only play once per mouse press
	-- Shooting stats
	Bullets = 1, -- How many bullets are shot by FireBullets
	Deduction = 1, -- Ammo deducted per shot
	Spread = vector_origin, -- Bullet spread vector
	SpreadBias = 0.5, -- Amount of variance on the spread. Between -1 and 1
	TracerFreq = 2, -- (1 / TracerFreq) bullets will show a tracer effect. 0 shows no effect
	TracerName = "Tracer", -- Tracer effect to use
	-- Melee stats
	EffectDelay = 0, -- Delay for melee effect
	SmackDelay = 0, -- Delay for melee damage
	-- General behaviour
	Automatic = true, -- Continously runs PrimaryAttack with the mouse held down
	FireAfterReload = false, -- Queue to fire after a reload if the weapon attempted to fire during one. InterruptReload has priority
	FireInAir = true, -- Allows firing while off the ground
	FireUnderwater = true, -- Allows firing underwater
	InterruptReload = false, -- Allows interrupting a reload to shoot
	ReloadOnEmptyFire = false, -- Reload if the weapon is fired with an empty clip
	SwitchOnEmptyFire = false, -- Switch away if the weapon is fired with no ammo
	-- Shooting behaviour
	DoPump = false -- Do a pump animation after shooting
}

SWEP.Secondary = {
	Ammo = "",
	ClipSize = -1,
	DefaultClip = -1,
	Cooldown = 0.15,
	Damage = 42,
	EmptyCooldown = -1,
	Force = 1,
	Range = MAX_TRACE_LENGTH,
	UnderwaterCooldown = 0.2,
	Bullets = 1,
	Deduction = 1,
	Spread = vector_origin,
	SpreadBias = 0.5,
	TracerFreq = 2,
	TracerName = "Tracer",
	EffectDelay = 0,
	SmackDelay = 0,
	Automatic = true,
	FireAfterReload = false,
	FireInAir = true,
	FireUnderwater = true,
	InterruptReload = false,
	ReloadOnEmptyFire = false,
	SwitchOnEmptyFire = false,
	DoPump = false
}

SWEP.SingleReload = {
	Enable = false,  // True if this weapon reloads 1 round at a time (shotguns)
	FireStall = false, -- Pause the reload if a fire button is down
	InitialRound = true -- Give round for the first reload (HL2) or subsequent reloads only (CS:S)
}

SWEP.Burst = {
	Cooldown = 0.3, -- Cooldown between toggling bursts
	Count = 2, -- Number of extra shots to fire when burst is enabled
	SingleSound = false, -- Only play the initial shooting sound during burst firing
	SingleActivity = false, -- Only play the initial shooting activity during burst firing
	Times = {-- Times between burst shots
		0.1, -- Time until first extra shot
		--0.1 -- Time until second extra shot; leave nil to fallback to the first time
	}
}

SWEP.Zoom = {
	AllowFire = true, -- Allow fire during zoom/unzoom
	Cooldown = 0.3, -- Cooldown between zooming
	FOV = {-- FOV for each zoom level
		55 -- FOV for first zoom level
	},
	Levels = 1, -- Number of zoom levels
	Times = {-- Times betweeen zoom levels
		Fire = 0.1, -- Time to unzoom after firing
		Reload = 0, -- Time to unzoom after reloading
		Rezoom = 0.05, -- Time to rezoom after unzooming from fire
		Holster = 0, -- Time to unzoom after holstering
		[0] = 0.15, -- Time to loop back to no zoom
		0.2 -- Time to reach the first zoom level; leave nil to fallback to the zoom time in index 0
	},
	UnzoomOnFire = false, -- Unzoom when the weapon is fired; rezooms after Primary/Secondary cooldown if the clip is not 0
	UnzoomOnReload = true -- Unzoom when the weapon is reloaded
}

SWEP.IronSights = {
	Hold = false, -- Require key to be held to use IronSights as opposed to just toggling the state
	-- Per-viewmodel data
	Ang = {
		angle_zero -- Local angular roation for ironsights to reach
		-- Second and third viewmodels fallback to first angle
	},
	Pos = {
		vector_origin -- Local position offset for ironsights to reach
	},
	Times = {
		1 -- Time it takes for the first viewmodel to zoom in
	}
}

SWEP.Grenade = {
	Delay = 0 -- The length of delay until the grenade is thrown
}

SWEP.Melee = {
	DamageType = DMG_CLUB, -- Melee damage type
	DotRange = 0.70721, -- Max dot product for a hull trace to hit. Not sure about this constant, but it's close to 1/sqrt(2)
	HullRadius = 1.732, -- Test amount of the forward vector for the end point oof the hull trace. sqrt(3)
	InitialTrace = true, -- Trace initially even if both the smack and effect have delays
	Mask = MASK_SHOT_HULL, -- Mask to use for melee trace
	Retrace = true, -- Re-trace if there's a delay to the smack
	TestHull = Vector(16, 16, 16) -- Test hull mins/maxs
}

SWEP.BipodDeploy = {
	BoxSize = 1, -- Size of the hull trace box
	CheckTime = 0.2, -- Time interval to check if the player should still be deployed
	Delta = 5, -- Yaw angle interval to trace at
	DownTrace = 16, -- Unit distance downward to trace to
	ForceUndeployPenalty = 0.1, -- Time to penalise firing after force undeploying
	ForwardTrace = 32, -- Unit distance forward to trace to
	MaxHeightDifference = 20, -- Max height between trace intervals allowed
	MinDeployHeight = 24, -- Minimum height from player's feet to allow deploy
	-- The names for the min/max pitch are mixed up in the engine
	MaxPitch = 45, -- Max pitch eye angle to allow deploying
	MinPitch = -60, -- Min pitch eye angle to allow deploying
	MaxYaw = 45, -- Max yaw rotation to allow while deployed
	StepSize = 4, -- Forward multiplier applied each angled trace attempt
	TimeToDeploy = 0.3, -- Default time to change the view offset if the deploy activity doesn't exist on the weapon
	TraceAttempts = 4 -- Angled trace attempts
}

SWEP.FireFunction = nil -- Fire function to use with Shoot. Args are (pPlayer, tFireBulletsInfo)
SWEP.PunchDecayFunction = nil -- Function to decay the punch angle manually. Args are (pPlayer, aPunchAngle). nil goes to default decaying

SWEP.WalkSpeed = 1 -- Walk speed multiplier to use when the weapon is deployed
SWEP.RunSpeed = 1 -- Run speed multiplier to use when the weapon is deployed

SWEP.AutoSwitchFrom = true -- Allows auto-switching away from the weapon. This is only checked for engine switching and is ignored by the base when AutoSwitchOnEmpty is true
SWEP.AutoSwitchTo = true -- Allows auto-switching to this weapon
SWEP.AutoReloadOnEmpty = true -- Automatically reload if the clip is empty and the mouse is not being held
SWEP.AutoSwitchOnEmpty = false -- Automatically switch away if the weapon is completely empty and the mouse is not being held. Ignores AutoSwitchFrom
SWEP.RemoveOnEmpty = false -- Remove the weapon when it runs out of ammo
SWEP.BlockDeployOnEmpty = false -- Block deploying the weapon if it has no ammo

SWEP.ReloadAfterHolster = false -- Should the weapon reload after holstering? sk_auto_reload_time controls the time

SWEP.MaxShots = 15 -- Number of shots to clamp the ShotsFired incrementer to when the mouse is lifted
SWEP.ShotDecreaseTime = 0.0225 -- (CS:S crosshair) How fast the shot count should decrease per shot
SWEP.ShotInitialDecreaseTime = 0.4 -- (CS:S crosshair) How long until the shot decrement starts after the mouse is lifter

SWEP.TriggerBoundSize = 36 -- Trigger box size to pickup the weapon off the ground. Set to -1 to disable pickup. // Bloat the box for player pickup

SWEP.m_WeaponDeploySpeed = 12 -- Do NOT use this, the deploy animation will be cut short by the idle animation! Instead, set the "rate" key in the SWEP.Activities.deploy table

-- Constants
local bSinglePlayer = game.SinglePlayer()
local bSinglePlayerPredicted = SERVER and bSinglePlayer
local bMultiPlayer = not bSinglePlayer
local bPredictedRealm = SERVER or not bSinglePlayer
local bUnPredictedRealm = not bPredictedRealm --CLIENT and bSinglePlayer
local ENTITY = FindMetaTable("Entity")
local phys_pushscale = GetConVar("phys_pushscale")
local sk_auto_reload_time = GetConVar("sk_auto_reload_time")
local gs_weapons_usecmodels = CreateConVar("gs_weapons_usecmodels", "0", bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED), "Use c-models for weapons, where applicable")
local tEventDefault = {[0] = 0}

--- Spawn/Constructor
local sm_tPrecached = {} -- Persists through all weapon instances - acts like static keyword in C++

-- Forward declare these so ChangeState sees them
local DefaultDeploy, DefaultHolster, ChangeState

if (CLIENT) then
	ChangeState = function(self, _, _, iNewState)
		if (iNewState == 0) then
			if (self:GetClientState() ~= 0) then
				DefaultDeploy(self, true)
				self:SharedDeploy(true)
				self:SetClientState(0)
			end
		elseif (iNewState < 0) then
			if (self:GetClientState() >= 0) then
				self:SetClientState(iNewState)
			end
		elseif (self:GetClientState() <= 0) then
			local pSwitchingTo = iNewState == 1 and NULL or Entity(iNewState - 1)
			
			DefaultHolster(self, pSwitchingTo, true)
			self:SharedHolster(pSwitchingTo, true)
			self:SetClientState(iNewState)
		end
	end
end

function SWEP:Initialize()
	local sClass = self:GetClass()
	code_gs.DevMsg(2, sClass .. " (gs_baseweapon) Initialize")
	
	self.m_bAutoSwitchFrom = self.AutoSwitchFrom -- Store the previous state since it is overwritten during grenade throws
	self.m_bInitialized = true
	--self.m_flDeployYawStart = 0 -- Yaw bounds: start offset and how far left and right can be gone locally
	--self.m_flDeployYawLeft = 0
	--self.m_flDeployYawRight = 0
	
	for i = 0, self.ViewModelCount - 1 do
		self["m_bUseViewModel" .. i] = false
		
		if (bPredictedRealm) then
			self["m_bFireEvent" .. i] = false
		end
		
		if (CLIENT) then
			-- 0 = At rest, zoomed out
			-- 1 = Zooming in
			-- 2 = At rest, zoomed in
			-- 3 = Zooming out
			self["m_iIronSightsState" .. i] = 0
		end
	end
	
	if (bPredictedRealm) then
		self.m_bActiveNoAmmo = false -- Pulled out with no ammo
		self.m_bSwitched = false -- Used for holster anims to know if SelectWeapon has been invoked yet
		
		--self.m_bDeployCrouched = false -- Bipod-deployed while crouched
		--self.m_bDeployViewAnimUpdated = true -- Deploy view animation positions have been updated since the deploy state changed
		--self.m_flDeployHeight = 0 -- Height the gun was deployed at
		--self.m_flDeployLength = 0 -- Length of deploy animation
		--self.m_flDeployTime = 0 -- Time the weapon was originally deployed at
		--self.m_flDeployEndTime = 0 -- Time until the weapon is fully deployed
		--self.m_flDeployViewStartHeight = 0 -- Start height of the deployed view offset
		--self.m_flDeployViewEndHeight = 0 -- Goal height of the deployed view offset
		--self.m_vDeployPos = vector_origin -- Position the weapon was deployed at
		--self.m_pDeployEntity = NULL -- Entity the weapon was deployed on
	end
	
	if (self.TriggerBoundSize == -1) then
		self:UseTriggerBounds(false, 0)
	else
		self:UseTriggerBounds(true, self.TriggerBoundSize)
	end
	
	if (CLIENT) then
		-- For CS:S crosshair
		self.m_iAmmoLastCheck = 0 -- Number of shots on the last crosshair draw
		self.m_flCrosshairDistance = 0 -- Unscaled distance in the cross-section horizontally and vertically
		
		self:SetNWProxy("State", ChangeState)
	end
	
	if (not sm_tPrecached[sClass]) then
		self:Precache()
	end
end

function SWEP:Precache()
	local sClass = self:GetClass()
	sm_tPrecached[sClass] = true -- Only precache once
	
	local tWeapon = weapons.GetStored(sClass)
	code_gs.DevMsg(2, sClass .. " (gs_baseweapon) Precache")
	
	if (CLIENT and self.KillIcon ~= '') then
		-- Add kill-icon
		killicon.AddFont(sClass, self.KillIconFont, self.KillIcon, self.KillIconColor)
	end
	
	-- Precache all weapon models
	util.PrecacheModel(self.WorldModel)
	util.PrecacheModel(self.SilencerModel)
	util.PrecacheModel(self.DroppedModel)
	util.PrecacheModel(self.ReloadModel)
	
	for i = 1, self.ViewModelCount - 1 do
		if (i == 0) then
			util.PrecacheModel(self.ViewModel)
			util.PrecacheModel(self.CModel)
		else
			util.PrecacheModel(self["ViewModel" .. i])
			util.PrecacheModel(self["CModel" .. i])
		end
	end
	
	-- Setup and precache all weapon sounds
	for k, s in pairs(self.Sounds) do
		if (k == "BaseClass") then -- Stupid pseudo-inheritance
			continue
		end
		
		-- Register sound table
		if (istable(s)) then
			if (not tWeapon.Sounds) then
				tWeapon.Sounds = {}
			end
			
			if (s.sound) then
				if (not s.name) then
					s.name = sClass .. "." .. k
				end
				
				if (not s.channel) then
					s.channel = CHAN_WEAPON
				end
			else
				s = {
					name = sClass .. "." .. k,
					channel = CHAN_WEAPON,
					sound = s
				}
			end
			
			sound.Add(s)
			self.Sounds[k] = s.name
			tWeapon.Sounds[k] = s.name
			util.PrecacheSound(s.name)
		-- Assume the sound manifest already exists
		elseif (not isfunction(s)) then
			util.PrecacheSound(s)
		end
	end
end

--[[function SWEP:SetupDataTables()
	-- Below are the default CNetworkVars in the engine for reference
	--self:NetworkVar("Entity", 0, "Owner")
	--self:NetworkVar("Float", 0, "NextPrimaryAttack")
	--self:NetworkVar("Float", 1, "NextSecondaryAttack")
	--self:NetworkVar("Int", 0, "ViewModelIndex")
	--self:NetworkVar("Int", 1, "WorldModelIndex")
	--self:NetworkVar("Int", 2, "State")
	--self:NetworkVar("Int", 3, "PrimaryAmmoType")
	--self:NetworkVar("Int", 4, "SecondaryAmmoType")
	--self:NetworkVar("Int", 5, "Clip1")
	--self:NetworkVar("Int", 6, "Clip2")
end]]

--- Deploy
function SWEP:CanDeploy()
	return true
end

DefaultDeploy = function(self, bDelayed)
	-- Clientside does not initialize sometimes
	if (not self.m_bInitialized) then
		self:Initialize()
	end
	
	code_gs.DevMsg(2, self:GetClass() .. " (gs_baseweapon) Deploy")
	
	local pPlayer = self:GetOwner()
	
	if (bPredictedRealm) then
		self.m_bActiveNoAmmo = not self:IsEmpty()
		self.m_bSwitched = false
		
		if (not bDelayed) then
			pPlayer:SetFOV(0, 0)
		end
	end
	
	if (self.ViewModelCount == 0) then
		local pViewModel = pPlayer:GetViewModel(0)
		pViewModel:SetWeaponModel("") -- FIXME: Test if this works
	else
		for i = 0, self.ViewModelCount - 1 do
			local pViewModel = pPlayer:GetViewModel(i)
			local bUseModel
			
			if (pViewModel:IsValid()) then
				bUseModel = true
				pViewModel:SetSkin(self:GetViewModelSkin(i))
				
				if (i ~= 0) then
					pViewModel:SetWeaponModel("", self)
				end
			else
				bUseModel = false
			end
			
			self["m_bUseViewModel" .. i] = bUseModel
			
			if (not bDelayed and bPredictedRealm) then
				if (self:GetPredictedVar("HideGrenade" .. i, false)) then
					local iType = self:GetGrenadeAmmoType(i)
					
					if (pPlayer:GetAmmoCount(iType) == 0) then
						self:SetHideWeapon(true, i)
						self:SetHardSequenceEnd(0)
						
						self:AddEvent("draw_" .. iIndex, 0, function()
							if (pPlayer:GetAmmoCount(iType) ~= 0) then
								self:SetHideWeapon(false, iIndex)
								self:SetPredictedVar("HideGrenade" .. i, true)
								
								self:PlaySound("draw", iIndex)
								self:SetHardSequenceEnd(self:PlayActivity("draw", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex))
								
								return true
							end
						end)
						
						return
					end
				end
				
				if (bUseModel) then
					self:PlaySound("draw", i)
					self:SetHardSequenceEnd(self:PlayActivity("draw", i) == -1 and 0 or CurTime() + self:SequenceLength(i), i)
				else
					self:SetHardSequenceEnd(0)
				end
			end
		end
	end
end

function SWEP:Deploy()
	local pPlayer = self:GetOwner()
	
	// Dead men deploy no weapons
	if (not (pPlayer:IsValid() and pPlayer:Alive())) then
		return false
	end
	
	if (self:IsEmpty()) then
		-- In-case ammo was deducted whle the weapon was holstered
		if (self.RemoveOnEmpty) then
			if (SERVER) then
				self:Remove()
			end
			
			return false
		end
		
		-- Half-Life 2 behaviour
		if (self.BlockDeployOnEmpty) then
			return false
		end
	end
	
	-- Do not deploy again
	if (SERVER) then
		if (self:GetState() == 0) then
			return true
		end
	elseif (self:GetClientState() == 0) then
		return true
	end
	
	if (self:CanDeploy()) then
		DefaultDeploy(self, false)
		self:SharedDeploy(false)
		
		if (CLIENT) then
			self:SetClientState(0)
		end
		
		self:SetState(0)
		
		return true
	end
	
	return false
end

function SWEP:SharedDeploy(bDelayed)
end

--- Holster/Remove
function SWEP:CanHolster()
	-- Don't holster while bipod-deployed
	return not self:GetBipodDeployed()
end

DefaultHolster = function(self, pSwitchingTo, bDelayed)
	code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Holster to %s", self:GetClass(), tostring(pSwitchingTo)))
	
	local pPlayer, bIsValid, bResetViewModel
	
	if (bPredictedRealm) then
		pPlayer = self:GetOwner()
		bIsValid = pPlayer:IsValid()
		bResetViewModel = bIsValid and not bDelayed
	else
		bIsValid = false
	end
	
	self:SetZoomLevel(0)
	self:SetZoomActiveTime(0)
	self:SetBipodDeployed(false)
	
	for i = 0, self.ViewModelCount - 1 do
		self["m_bUseViewModel" .. i] = false
		
		self:SetLowered(false, i)
		self:SetHideWeapon(false, i)
		self:SetShotsFired(0, i)
		
		if (bPredictedRealm) then
			if (self:GetPredictedVar("ReduceShotTime" .. i, -1) ~= -1) then
				self:SetPredictedVar("ReduceShotTime" .. i, -1)
			end
			
			if (bResetViewModel and self:UseViewModel(i)) then
				local pViewModel = pPlayer:GetViewModel(i)
				pViewModel:SetSkin(0)
				
				if (i ~= 0) then
					pViewModel:SetWeaponModel("")
				end
			end
		end
	end
	
	if (bIsValid) then
		if (not bDelayed) then
			pPlayer:SetFOV(0, self.Zoom.Times.Holster) // reset the default FOV
		end
		
		if (self.ReloadAfterHolster) then
			local flReloadTime = CurTime() + sk_auto_reload_time:GetFloat()
			local sName = "GS-Weapons-Holster reload-%u-" .. self:EntIndex()
			
			for i = 0, self.ViewModelCount - 1 do
				if (self:EventActive("reload_" .. i)) then
					local sName = string.format(sName, i)
					
					hook.Add("Tick", sName, function()
						if (not (self:IsValid() and pPlayer == self:GetOwner()) or self:IsActiveWeapon()) then
							hook.Remove("Tick", sName)
						elseif (CurTime() >= flReloadTime) then
							hook.Remove("Tick", sName)
							
							local iMaxClip = self:GetMaxClip(false, i)
							local iClip2 = self:GetClip(true, i)
							
							// If I use primary clips, reload primary
							if (iMaxClip ~= -1) then
								local iClip1 = self:GetClip(false, i)
								local iAmmoType = self:GetAmmoType(false, i)
								local iAmmo = math.min(iMaxClip - iClip1, pPlayer:GetAmmoCount(iAmmoType))
								
								self:SetClip(iClip1 + iAmmo, false, i)
								pPlayer:RemoveAmmo(iAmmo, iAmmoType)
							end
							
							if (iClip2 == self:GetClip(true, i)) then
								local iMaxClip = self:GetMaxClip(true, i)
								
								if (iMaxClip ~= -1) then
									local iClip = self:GetClip(true, i)
									local iAmmoType = self:GetAmmoType(true, i)
									local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(iAmmoType))
									
									self:SetClip(iClip + iAmmo, true, i)
									pPlayer:RemoveAmmo(iAmmo, iAmmoType)
								end
							end
							
							self:FinishReload(i)
						end
					end)
				end
			end
		end
	end
	
	local tEvents = self:GetPredictedVar("ActiveEvents")
	
	if (tEvents) then
		for i = 1, tEvents[0] do
			self:SetPredictedVar(tEvents[i], nil)
		end
		
		self:SetPredictedVar("ActiveEvents", tEventDefault)
	end
end

function SWEP:Holster(pSwitchingTo)
	-- <3 Garry
	-- https://github.com/Facepunch/garrysmod-issues/issues/2854
	if (CLIENT and (bSinglePlayer or pSwitchingTo == self)) then
		return self:GetClientState() > 0
	end
	
	if (self.RemoveOnEmpty and not self:HasAmmo()) then
		if (SERVER) then
			self:Remove()
		end
		
		return true
	end
	
	local pPlayer = self:GetOwner()
	local bIsValid = pPlayer:IsValid()
	
	-- Holster is called when the player dies with it active but nothing should be done
	-- Player:Alive() will return true on the frame the death occured but the health will be less than or equal to 0
	if (bIsValid and (pPlayer:Health() < 1 or not pPlayer:Alive())) then
		return true
	end
	
	local iState = self:GetState()
	
	-- Do not holster again
	if (SERVER and iState > 0) then
		return true
	end
	
	if (pSwitchingTo == self) then
		-- FIXME
		ErrorNoHalt("[GS] Invalid holster state! Removing..")
		
		if (SERVER) then
			self:Remove()
		end
		
		return true
	end
	
	if (CLIENT and self:GetClientState() > 0) then
		return true
	end
	
	local bDidAnim = iState < 0
	
	-- If we are switching to NULL (picked up an object) don't play an animation
	if (bDidAnim) then
		if (self:GetNWVar("Float", "HolsterAnimEnd") > CurTime()) then
			return false
		end
	elseif (bIsValid and pSwitchingTo:IsValid()) then
		if (self:CanHolster(pSwitchingTo)) then
			local flEndTime = 0
			
			for i = 0, self.ViewModelCount - 1 do
				if (self:UseViewModel(i)) then
					-- Wait for all viewmodels to holster
					self:PlaySound("holster", i)
					
					if (self:PlayActivity("holster", i) ~= -1) then
						flEndTime = math.max(flEndTime, self:SequenceLength(i))
					end
				end
			end
			
			if (flEndTime == 0) then
				DefaultHolster(self, pSwitchingTo, false)
				self:SharedHolster(pSwitchingTo, false)
				
				local iState = pSwitchingTo:EntIndex() + 1
				
				if (CLIENT) then
					self:SetClientState(iState)
				end
				
				self:SetState(iState)
				
				return true
			end
			
			self:SetNWVar("Float", "HolsterAnimEnd", CurTime() + flEndTime)
			
			local iState = -(pSwitchingTo:EntIndex() + 1)
			
			if (CLIENT) then
				self:SetClientState(iState)
			end
			
			self:SetState(iState)
		end
			
		return false
	end
	
	-- Don't check if holstering is allowed again after an animation
	if (bDidAnim or self:CanHolster(pSwitchingTo)) then
		DefaultHolster(self, pSwitchingTo, false)
		self:SharedHolster(pSwitchingTo, false)
		
		local iState = pSwitchingTo:EntIndex() + 1
		
		if (CLIENT) then
			self:SetClientState(iState)
		end
		
		self:SetState(iState)
		
		return true
	end
	
	return false
end

function SWEP:SharedHolster(pSwitchingTo, bDelayed)
end

function SWEP:OnRemove()
	local pPlayer = self:GetOwner()
	
	if (pPlayer:IsValid()) then
		if (bPredictedRealm and self:IsActiveWeapon()) then
			pPlayer:SetFOV(0, self.Zoom.Times.Holster) // reset the default FOV
			
			for i = 1, self.ViewModelCount - 1 do
				-- Hide the extra viewmodels
				if (self:UseViewModel(i)) then
					local pViewModel = pPlayer:GetViewModel(i)
					
					if (pViewModel:IsValid()) then
						pViewModel:SetWeaponModel("")
					end
				end
			end
		end
				
		if (pPlayer:Alive() and pPlayer:Health() > 0) then
			-- The weapon was removed while it was active and the player was alive, so find a new one
			local pWeapon = pPlayer:GetNextBestWeapon(self.HighWeightPriority, true) -- FIXME: Returning the wrong weapon in single-player
			
			if (bPredictedRealm) then
				code_gs.weapons.SelectWeapon(pPlayer, pWeapon)
			end
			
			code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Remove to %s", self:GetClass(), tostring(pWeapon)))
		else
			code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Remove", self:GetClass(), tostring(NULL)))
		end
	end
end

if (SERVER) then
	-- Put this here instead of init to prevent having to copy DefaultHolster's code
	function SWEP:OnDrop()
		DefaultHolster(NULL, false)
		self:SharedHolster(NULL, false)
		self:SetState(1)
	end
end

--- Think/Idle
local function OnEventError(sError)
	debug.Trace()
	ErrorNoHalt(sError)
end

local tRemovalQueue = {}
local bUpdateEvents = false

function SWEP:Think()
	local flCurTime = CurTime()
	self:NextThink(flCurTime)
	
	if (CLIENT) then
		self:SetNextClientThink(flCurTime)
	end
	
	local iState = self:GetState()
	
	-- Don't think while holstered
	if (iState > 0) then
		if (CLIENT and self:GetClientState() <= 0) then
			local pSwitchingTo = iState == 1 and NULL or Entity(iState - 1)
			
			DefaultHolster(self, pSwitchingTo, true)
			self:SharedHolster(pSwitchingTo, true)
			self:SetClientState(iState)
		end
		
		return true
	end
	
	local pPlayer = self:GetOwner()
	
	-- Don't think with no holder
	if (not pPlayer:IsValid()) then
		return true
	end
	
	-- In holster animation
	if (iState < 0) then
		-- Client hasn't pre-holstered yet
		if (iClientState == 0) then
			self:SetClientState(iState)
		end
		
		if (bPredictedRealm and not self.m_bSwitched and self:GetNWVar("Float", "HolsterAnimEnd") <= flCurTime) then
			local pSwitchingTo = Entity(-(iState + 1))
			
			-- Activity is done, switch away
			code_gs.weapons.SelectWeapon(pPlayer, pSwitchingTo:IsValid() and pSwitchingTo or pPlayer:GetNextBestWeapon(self.HighWeightPriority))
			self.m_bSwitched = true
		end
		
		return true
	end
	
	if (CLIENT and iState == 0 and self:GetClientState() ~= 0) then
		DefaultDeploy(self, true)
		self:SharedDeploy(true)
		self:SetClientState(0)
	end
	
	local tEvents = self:GetPredictedVar("ActiveEvents", tEventDefault)
	
	-- Events have priority over main think functions
	-- TODO: Flush old commands out
	for i = 1, tEvents[0] do
		local tEvent = self:GetPredictedVar(tEvents[i])
		
		if (tEvent) then
			local bRun
			
			if (tEvent[2] == true) then
				bRun = tEvent[1](self) == true
			elseif (tEvent[1] == -1) then
				bRun = false
			else
				bRun = tEvent[2] <= flCurTime
			end
			
			if (bRun) then
				local bNoError, RetVal = xpcall(tEvent[3], OnEventError)
				
				if (bNoError) then
					-- Mark the event as being finished
					if (RetVal == true) then
						self:SetPredictedVar(tEvents[i], nil)
						bUpdateEvents = true
						tRemovalQueue[i] = true
					-- Update interval
					elseif (isnumber(RetVal)) then
						self:SetPredictedVar(tEvents[i], {RetVal, flCurTime + RetVal, tEvent[3]})
					elseif (isfunction(RetVal)) then
						self:SetPredictedVar(tEvents[i], {RetVal, true, tEvent[3]})
					end
				else
					self:SetPredictedVar(tEvents[i], nil)
					bUpdateEvents = true
					tRemovalQueue[i] = true
				end
			end
		else
			-- Event was removed
			bUpdateEvents = true
			tRemovalQueue[i] = true
		end
	end
	
	-- Remove events
	if (bUpdateEvents) then
		local tNewEvents = {}
		local iActualIndex = 0
		
		for i = 1, tEvents[0] do
			if (not tRemovalQueue[i]) then
				iActualIndex = iActualIndex + 1
				tNewEvents[iActualIndex] = tEvents[i]
			end
		end
		
		tNewEvents[0] = iActualIndex
		self:SetPredictedVar("ActiveEvents", tNewEvents)
		
		table.Empty(tRemovalQueue)
		bUpdateEvents = false
	end
	
	for i = 0, self.ViewModelCount - 1 do
		if (self:ViewModelInactive(i)) then
			self:MouseLifted(i)
		end
	end
	
	-- Think function replacement
	if (self:GetNextItemFrame() <= flCurTime) then
		self:ItemFrame()
	end
	
	if (bPredictedRealm) then
		if (self:GetBipodDeployed() and self:GetPredictedVar("DeployNextCheck", 0) <= flCurTime) then
			if (self:ShouldBipodUndeploy()) then
				self:ToggleBipodDeploy(true)
			end
			
			-- Checking deploy conditions requires a lot of traces, so don't do it too often
			self:SetPredictedVar("DeployNextCheck", flCurTime + self.BipodDeploy.CheckTime)
		end
		
		for i = 0, self.ViewModelCount - 1 do
			if (self:CanIdle(i)) then
				-- Strict tags: don't idle while silenced or lowered if no associated idle is available
				self:PlayActivity("idle", i, nil, true)
			end
		end
	end
	
	return true
end

function SWEP:CanIdle(iIndex --[[= 0]])
	if (not self:EventActive("reload_" .. iIndex) and self:GetShouldThrow(iIndex) == 0) then
		local flTime = self:GetNextIdle(iIndex)
		
		return flTime ~= -1 and flTime <= CurTime()
	end
	
	return false
end

function SWEP:MouseLifted(iIndex)
	if (bUnPredictedRealm) then
		return
	end
	
	local pPlayer = self:GetOwner()
	local flCurTime = CurTime()
	
	local iThrow = self:GetShouldThrow(iIndex)
	
	if (iThrow ~= 0) then
		self:SetShouldThrow(0, iIndex)
		pPlayer:SetAnimation(PLAYER_ATTACK1)
		
		local iType = self:GetGrenadeAmmoType(iIndex)
		
		self:AddEvent("throw_" .. iIndex, self.Grenade.Delay, function()
			self:SetLastAttackTime(CurTime(), iIndex)
			self:SetLastShootTime()
			self:EmitGrenade(iThrow)
			self:PlaySound("throw", iIndex)
			pPlayer:RemoveAmmo(1, iType)
			
			return true
		end)
		
		self:SetHardSequenceEnd(self:PlayActivity("throw", iIndex) == -1 and 0 or flCurTime + self:SequenceLength(iIndex))
		
		self:AddEvent("reload_grenade_" .. iIndex, function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end, function()
			if (pPlayer:GetAmmoCount(iType) == 0) then
				if (self.RemoveOnEmpty) then
					if (SERVER) then
						self:Remove()
					end
				else
					self:SetHideWeapon(true, iIndex)
					self:SetPredictedVar("HideGrenade" .. iIndex, true)
					
					self:AddEvent("draw_" .. iIndex, 0, function()
						if (pPlayer:GetAmmoCount(iType) ~= 0) then
							self:SetHideWeapon(false, iIndex)
							self:SetPredictedVar("HideGrenade" .. iIndex, false)
							
							self:PlaySound("draw", iIndex)
							self:SetHardSequenceEnd(self:PlayActivity("draw", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex))
							
							return true
						end
					end)
				end
			else
				self:SetHardSequenceEnd(self:PlayActivity("draw", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex))
			end
			
			return true
		end)
	end
	
	-- FIXME
	if (iIndex == 0) then
		-- Just ran out of ammo and the mouse has been lifted, so switch away
		if (self.AutoSwitchOnEmpty and not self.m_bActiveNoAmmo and self:IsEmpty(0)) then
			if (not self.m_bSwitched) then
				code_gs.weapons.SelectWeapon(pPlayer, pPlayer:GetNextBestWeapon(self.HighWeightPriority))
				self.m_bSwitched = true
			end
		-- Reload is still called serverside only in single-player
		-- FIXME: Change this to special keys
		elseif (self.AutoReloadOnEmpty and self:GetClip(false, 0) == 0 and pPlayer:GetAmmoCount(self:GetAmmoType(false, 0)) ~= 0
		or self:GetClip(true, 0) == 0 and pPlayer:GetAmmoCount(self:GetAmmoType(true, 0)) ~= 0) then
			self:DoReloadFunction(0)
		end
	elseif (self.AutoReloadOnEmpty and self:GetClip(false, iIndex) == 0 and pPlayer:GetAmmoCount(self:GetAmmoType(false, iIndex)) ~= 0
	or self:GetClip(true, iIndex) == 0 and pPlayer:GetAmmoCount(self:GetAmmoType(true, iIndex)) ~= 0) then
		self:DoReloadFunction(iIndex)
	end
		
	
	if (not self:EventActive("burst_" .. iIndex)) then
		// The following code prevents the player from tapping the firebutton repeatedly 
		// to simulate full auto and retaining the single shot accuracy of single fire
		local iShotsFired = self:GetShotsFired(iIndex)
		
		if (iShotsFired ~= 0) then
			local flShotTime = self:GetPredictedVar("ReduceShotTime" .. iIndex, -1)
			
			if (flShotTime == -1) then
				-- Clamp max shots
				if (self:GetShotsFired(iIndex) > self.MaxShots) then
					self:SetShotsFired(self.MaxShots, iIndex)
				end
				
				-- Initial time is greater than the normal decrease interval to prevent tap firing advantages
				self:SetPredictedVar("ReduceShotTime" .. iIndex, flCurTime + self.ShotInitialDecreaseTime)
			elseif (flShotTime < flCurTime) then
				self:SetShotsFired(iShotsFired - 1, iIndex)
				self:SetPredictedVar("ReduceShotTime" .. iIndex, flCurTime + self.ShotDecreaseTime)
			end
		end
	end
end

-- Normal think function replacement
function SWEP:ItemFrame()
end

--- Reload
function SWEP:CanReload(iIndex --[[= 0]])
	if (self:EventActive("reload_" .. iIndex) or self:GetLowered(iIndex) or self:GetHideWeapon(iIndex) or self:GetShouldThrow(iIndex) ~= 0) then
		return false
	end
	
	local flCurTime = CurTime()
	
	if (self:GetHardSequenceEnd(iIndex) > flCurTime or self:GetNWVar("Float", "HolsterAnimEnd") > flCurTime) then
		return false
	end
	
	local flNextReload = self:GetNextReload(iIndex)
	
	if (flNextReload == -1 or flNextReload > flCurTime) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (not pPlayer:IsValid()) then
		return false
	end
	
	// If I don't have any spare ammo, I can't reload
	local iMaxClip = self:GetMaxClip(false, iIndex)
	
	-- Do not reload if both clips are already full
	if (iMaxClip <= -1 or self:GetClip(false, iIndex) == iMaxClip or pPlayer:GetAmmoCount(self:GetAmmoType(false, iIndex)) == 0) then
		local iMaxClip = self:GetMaxClip(true, iIndex)
		
		if (iMaxClip <= -1 or self:GetClip(true, iIndex) == iMaxClip or pPlayer:GetAmmoCount(self:GetAmmoType(true, iIndex)) == 0) then
			return false
		end
	end
	
	return true
end

function SWEP:DoReloadFunction(iIndex --[[= 0]])
	if (self:CanReload(iIndex)) then
		self:ReloadClips(iIndex)
		
		return true
	end
	
	return false
end

-- Will only be called serverside in single-player
function SWEP:Reload()
	local bReloaded = false
	
	for i = 0, self.ViewModelCount - 1 do
		if (self:DoReloadFunction(i)) then
			bReloaded = true
		end
	end
	
	return bReloaded
end

function SWEP:ReloadClips(iIndex --[[= 0]])
	if (iIndex == nil) then
		iIndex = 0
	end
	
	local pPlayer = self:GetOwner()
	
	if (self.Zoom.UnzoomOnReload and self:GetZoomLevel() ~= 0) then
		self:SetZoomLevel(0)
		pPlayer:SetFOV(0, self.Zoom.Times.Reload)
	end
	
	local tSingleReload = self.SingleReload
	
	if (tSingleReload.Enable) then
		local iMaxClip1 = self:GetMaxClip(false, iIndex)
		local iAmmoType1 = self:GetAmmoType(false, iIndex)
		local bNoAmmo1 = iMaxClip1 <= -1
		
		local iMaxClip2 = self:GetMaxClip(true, iIndex)
		local iAmmoType2 = self:GetAmmoType(true, iIndex)
		local bNoAmmo2 = iMaxClip2 <= -1
		
		// Play the player's reload animation
		pPlayer:DoAnimationEvent(PLAYERANIMEVENT_RELOAD)
		self:PlaySound("reloadstart", iIndex)
		
		self:SetHardSequenceEnd(self:PlayActivity("reloadstart", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex), iIndex)
		
		-- FIXME: Fix prediction errors
		local bFirst = true
		local flFirstTime = -1
		local bSkip = false
		local flSkipEndTime = -1
		
		self:AddEvent("reload_" .. iIndex, function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end, function()
			local bReloadDone1, bReloadDone2
			local iClip2 = bNoAmmo2 and -1 or self:GetClip(true, iIndex)
			
			if (bNoAmmo1) then
				bReloadDone1 = true
			else
				local iClip1 = self:GetClip(false, iIndex)
				
				if (tSingleReload.FireStall and (iClip1 > 0 or self:GetSpecialKey("FireUnderwater", false, iIndex) and pPlayer:WaterLevel() == 3) and not self:ViewModelInactive(iIndex)) then
					bSkip = true
					
					return
				end
				
				if (bSkip) then
					bSkip = false
					flSkipEndTime = CurTime()
					
					return
				end
				
				if (flSkipEndTime == CurTime()) then
					return
				end
				
				local iAmmoCount = pPlayer:GetAmmoCount(iAmmoType1)
				bReloadDone1 = iClip1 >= iMaxClip1 or iAmmoCount == 0
				
				if (not bReloadDone1 and (not bFirst or tSingleReload.InitialRound)) then
					iClip1 = iClip1 + 1
					self:SetClip(iClip1, false, iIndex)
					iAmmoCount = iAmmoCount - 1
					pPlayer:RemoveAmmo(1, iAmmoType1)
					
					bReloadDone1 = iClip1 >= iMaxClip1 or iAmmoCount == 0
				end
			end
			
			if (bNoAmmo2) then
				bReloadDone2 = true
			-- Primary and secondary fire share the same clip
			elseif (iClip2 ~= self:GetClip(true, iIndex)) then
				bReloadDone2 = bReloadDone1
			else
				if (tSingleReload.FireStall and (iClip2 > 0 or self:GetSpecialKey("FireUnderwater", true, iIndex) and pPlayer:WaterLevel() == 3) and not self:ViewModelInactive(iIndex)) then
					bSkip = true
					
					return
				end
				
				if (bSkip) then
					bSkip = false
					flSkipEndTime = CurTime()
					
					return
				end
				
				if (flSkipEndTime == CurTime()) then
					return
				end
				
				local iAmmoCount = pPlayer:GetAmmoCount(iAmmoType2)
				bReloadDone2 = iClip2 >= iMaxClip2 or iAmmoCount == 0
				
				if (not bReloadDone2 and (not bFirst or tSingleReload.InitialRound)) then
					iClip2 = iClip2 + 1
					self:SetClip(iClip2, true, iIndex)
					iAmmoCount = iAmmoCount - 1
					pPlayer:RemoveAmmo(1, iAmmoType2)
					
					bReloadDone2 = iClip2 >= iMaxClip2 or iAmmoCount == 0
				end
			end
			
			if (bReloadDone1 and bReloadDone2) then
				pPlayer:DoAnimationEvent(PLAYERANIMEVENT_RELOAD_END)
				self:PlaySound("reloadfinish", iIndex)
				
				self:SetHardSequenceEnd(self:PlayActivity("reloadfinish", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex))
				
				self:FinishReload(iIndex)
				
				if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				return true
			end
			
			pPlayer:DoAnimationEvent(PLAYERANIMEVENT_RELOAD_LOOP)
			self:PlaySound("reload", iIndex)
			
			self:SetNWVar("Float", "SingleReloadEnd" .. iIndex, self:PlayActivity("reload", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex))
			
			if (bFirst or flFirstTime == CurTime()) then
				self:SetShotsFired(0, iIndex)
				
				bFirst = false
				flFirstTime = CurTime()
				pPlayer:SetAnimation(PLAYER_RELOAD)
				
				return function(self) return self:GetNWVar("Float", "SingleReloadEnd" .. iIndex, 0) <= CurTime() end
			end
		end)
		
		if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
			net.Start("GS-Weapons-Reload")
			net.Send(pPlayer)
		end
	else
		// Play the player's reload animation
		pPlayer:SetAnimation(PLAYER_RELOAD)
		pPlayer:DoAnimationEvent(PLAYERANIMEVENT_RELOAD)
		
		self:PlaySound("reload", iIndex)
		
		self:SetHardSequenceEnd(self:PlayActivity("reload", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex), iIndex)
		
		-- Finish reloading after the animation is finished
		self:AddEvent("reload_" .. iIndex, function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end, function()
			local iMaxClip = self:GetMaxClip(false, iIndex)
			local iClip2 = self:GetClip(true, iIndex)
			
			// If I use primary clips, reload primary
			if (iMaxClip ~= -1) then
				local iClip1 = self:GetClip(false, iIndex)
				local iAmmoType = self:GetAmmoType(false, iIndex)
				
				-- Only reload what is available
				local iAmmo = math.min(iMaxClip - iClip1, pPlayer:GetAmmoCount(iAmmoType))
				
				-- Add to the clip
				self:SetClip(iClip1 + iAmmo, false, iIndex)
				
				-- Take from the player's reserve
				pPlayer:RemoveAmmo(iAmmo, iAmmoType)
			end
			
			if (iClip2 == self:GetClip(true, iIndex)) then
				local iMaxClip = self:GetMaxClip(true, iIndex)
				
				// If I use primary clips, reload primary
				if (iMaxClip ~= -1) then
					local iClip = self:GetClip(true, iIndex)
					local iAmmoType = self:GetAmmoType(true, iIndex)
					local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(iAmmoType))
					
					self:SetClip(iClip + iAmmo, true, iIndex)
					pPlayer:RemoveAmmo(iAmmo, iAmmoType)
				end
			end
			
			self:SetShotsFired(0, iIndex)
			self:FinishReload(iIndex)
			
			if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
				net.Start("GS-Weapons-Finish reload")
				net.Send(pPlayer)
			end
			
			return true
		end)
		
		if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
			net.Start("GS-Weapons-Reload")
			net.Send(pPlayer)
		end
	end
	
	self:StartReload(iIndex)
end

--- Attack
function SWEP:CanAttack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (self:GetLowered(iIndex) or self:GetHideWeapon(iIndex) or self:GetShouldThrow(iIndex) ~= 0) then
		return false
	end
	
	if (iIndex == nil) then
		iIndex = 0
	end
	
	-- If the weapon has played its empty sound or is in a burst fire
	if (self:EventActive("empty_" .. (bSecondary and "secondary_" or "primary_") .. iIndex) or self:EventActive("burst_" .. iIndex)) then
		return false
	end
	
	local flCurTime = CurTime()
	
	-- If the viewmodel is in the middle of an important sequence
	if (self:GetHardSequenceEnd(iIndex) > flCurTime or self:GetNWVar("Float", "HolsterAnimEnd") > flCurTime
	-- No quick-scoping!
	or not self.Zoom.AllowFire and self:GetZoomActiveTime() > flCurTime) then
		return false
	end
	
	local bDelayedFire = self["m_bFireEvent" .. iIndex]
	local flNextAttack = self:GetNextAttack(bSecondary, iIndex)
	
	-- If there's already a queued fire, or the weapon can't fire yet
	if (not bDelayedFire and (self:EventActive("fire_" .. iIndex) or flNextAttack == -1 or flNextAttack > flCurTime)) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (not pPlayer:IsValid()) then
		return false
	end
	
	local iWaterLevel = pPlayer:WaterLevel()
	
	if (iWaterLevel == 0 and not (self:GetSpecialKey("FireInAir", bSecondary, iIndex) or pPlayer:OnGround())) then
		return false
	end
	
	local iClip = self:GetClip(bSecondary, iIndex)
	local bEmpty
	
	if (iClip <= -1) then
		if (self:GetDefaultClip(bSecondary, iIndex) <= -1) then
			bEmpty = false
		else
			bEmpty = pPlayer:GetAmmoCount(self:GetAmmoType(bSecondary, iIndex)) == 0
		end
	else
		bEmpty = iClip == 0
	end
	
	local bInReload = self:EventActive("reload_" .. iIndex)
	local bDoEmptyEvent = not (bInReload or bDelayedFire)
	
	if (bEmpty) then
		if (bDoEmptyEvent) then
			self:HandleFireOnEmpty(bSecondary, iIndex)
		end
		
		return false
	end
	
	if (iWaterLevel == 3 and not self:GetSpecialKey("FireUnderwater", bSecondary, iIndex)) then
		if (bDoEmptyEvent) then
			self:HandleFireUnderwater(bSecondary, iIndex)
		end
		
		return false
	end
	
	-- In the middle of a reload
	if (bInReload and not bDelayedFire) then
		-- Interrupt the reload to fire
		if (self:GetSpecialKey("InterruptReload", bSecondary, iIndex)) then
			-- Stop the reload
			self:RemoveReload(iIndex)
			
			if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
				net.Start("GS-Weapons-Finish reload")
				net.Send(pPlayer)
			end
		elseif (self:GetSpecialKey("FireAfterReload", bSecondary, iIndex)) then
			self:AddEvent("fire_" .. iIndex, self:SequenceEnd(iIndex), function()
				self["m_bFireEvent" .. iIndex] = true
				local flNextReload = self:GetNextReload(iIndex)
				
				self:Attack(bSecondary, iIndex)
				self:RemoveReload(iIndex)
				
				if (bSinglePlayerPredicted and iIndex == self:GetWorldModelIndex()) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				self["m_bFireEvent" .. iIndex] = false
				
				return true
			end)
			
			return false
		end
	end
	
	return true
end

function SWEP:DoAttack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (self:CanAttack(bSecondary, iIndex)) then
		self:Attack(bSecondary, iIndex)
		
		return true
	end
	
	return false
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (not bSecondary) then
		self:Shoot(false, iIndex)
	end
end

local function DryFire(self, flCooldown, bSecondary --[[= false]], iIndex --[[= 0]])
	self:PlaySound("empty", iIndex)
	self:PlayActivity("empty", iIndex)
	
	local pPlayer = self:GetOwner()
	local flCooldown = self:GetSpecialKey("EmptyCooldown", bSecondary, iIndex)
	
	if (flCooldown == -1) then
		local nKey = self:GetFireButton(bSecondary, iIndex)
		
		if (nKey ~= 0) then
			self:AddEvent("empty_" .. (bSecondary and "secondary_" or "primary_") .. iIndex, 0, function()
				if (not (pPlayer:KeyDown(nKey) and self:GetClip(bSecondary, iIndex) == 0)) then
					return true
				end
			end)
		end
	else
		self:SetNextAttack(CurTime() + flCooldown, bSecondary, iIndex)
	end
end

function SWEP:HandleFireOnEmpty(bSecondary --[[= false]], iIndex --[[= 0]])
	DryFire(self, self:GetSpecialKey("EmptyCooldown", bSecondary, iIndex), bSecondary, iIndex)
	
	if (self:GetSpecialKey("SwitchOnEmptyFire", bSecondary, iIndex) and self:IsEmpty(bSecondary, iIndex)) then
		code_gs.weapons.SelectWeapon(pPlayer, pPlayer:GetNextBestWeapon(self.HighWeightPriority))
	elseif (self:GetSpecialKey("ReloadOnEmptyFire", bSecondary, iIndex)) then
		self:DoReloadFunction(iIndex)
	end
end

function SWEP:HandleFireUnderwater(bSecondary --[[= false]], iIndex --[[= 0]])
	DryFire(self, self:GetSpecialKey("UnderwaterCooldown", bSecondary, iIndex), bSecondary, iIndex)
end

-- Will only be called serverside in single-player
function SWEP:PrimaryAttack()
	return self:DoAttack(false, 0)
end

function SWEP:SecondaryAttack()
	return self:DoAttack(true, 0)
end

local function RezoomEvent(self, Cooldown, iLevel, bSecondary --[[= false]], iIndex --[[= 0]])
	self:AddEvent("rezoom_" .. iIndex, Cooldown, function()
		-- Don't rezoom if the clip is empty
		if (self:GetClip(bSecondary, iIndex) ~= 0) then
			local tZoom = self.Zoom
			local flRezoom = tZoom.Times.Rezoom
			self:GetOwner():SetFOV(tZoom.FOV[iLevel], flRezoom)
			
			flRezoom = CurTime() + flRezoom
			self:SetZoomActiveTime(flRezoom)
			self:SetZoomLevel(iLevel)
			self:SetNextAttack(flRezoom, true, iIndex)
		end
		
		return true
	end)
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	if (iIndex == nil) then
		iIndex = 0
	end
	
	local iClipDeduction = self:GetSpecialKey("Deduction", bSecondary, iIndex)
	local iClip = self:GetClip(bSecondary, iIndex)
	local bDeductClip = iClip ~= -1
	
	-- Check just in-case the weapon's CanPrimary/SecondaryAttack doesn't check properly
	-- Do NOT let the clip overflow
	if (bDeductClip and iClipDeduction > iClip) then
		error(self:GetClass() .. " (gs_baseweapon) Clip overflowed in Shoot! Add check to CanPrimary/SecondaryAttack")
	end
	
	local tbl = self:GetShootInfo(bSecondary, iIndex)
	local bBurst = self:GetBurst(iIndex) and (not bDeductClip or iClip >= iClipDeduction * 2)
	local flCooldown = self:GetSpecialKey("Cooldown", bSecondary, iIndex)
	local tZoom = self.Zoom
	local iLevel = self:GetZoomLevel()
	local pPlayer = self:GetOwner()
	local bDoZoomEvent = tZoom.UnzoomOnFire and iLevel ~= 0
	local flCurTime = CurTime()
	
	local fFireFunc = self.FireFunction
	local bCustomFiring = false
	
	if (fFireFunc) then
		bCustomFiring = true
	else
		fFireFunc = ENTITY.FireBullets
	end
	
	fFireFunc(pPlayer, tbl)
	
	-- If the clip is not -1, reduce it
	if (bDeductClip) then
		iClip = iClip - iClipDeduction
		self:SetClip(iClip, bSecondary, iIndex)
	end
	
	-- Unzoom before playing the firing animation
	if (bDoZoomEvent) then
		self:SetZoomActiveTime(flCurTime + tZoom.Times.Fire)
		self:SetZoomLevel(0) -- Disable scope overlay
		pPlayer:SetFOV(0, tZoom.Times.Fire)
	end
	
	if (bBurst) then		
		local tBurst = self.Burst
		local tTimes = tBurst.Times
		local iCount = tBurst.Count
		self:SetPredictedVar("BurstCount" .. iIndex, 0)
		
		self:AddEvent("burst_" .. iIndex, tTimes[1], function()
			local iCurCount = self:GetPredictedVar("BurstCount" .. iIndex, 0) + 1
			self:SetPredictedVar("BurstCount" .. iIndex, iCurCount)
			
			self:UpdateBurstShotTable(tbl, bSecondary, iIndex)
			fFireFunc(pPlayer, tbl)
			
			if (bDeductClip) then
				iClip = self:GetClip(bSecondary, iIndex) - iClipDeduction
				self:SetClip(iClip, bSecondary, iIndex)
			end
			
			self:PlaySound(bSecondary and "shoot2" or "shoot", iIndex)
			local bActivity = self:PlayActivity(bSecondary and "shoot2" or "shoot", iIndex) ~= -1
			
			if (not self:DoMuzzleFlash(iIndex)) then
				pPlayer:MuzzleFlash()
			end
			
			pPlayer:SetAnimation(PLAYER_ATTACK1)
			
			self:SetShotsFired(self:GetShotsFired(iIndex) + 1, iIndex)
			
			local flCurTime = CurTime()
			self:SetLastAttackTime(flCurTime, iIndex)
			
			if (bCustomFiring) then
				self:SetLastShootTime()
			end
			
			if (iCurCount == iCount or bDeductClip and iClip < iClipDeduction) then
				self:SetPredictedVar("ReduceShotTime" .. iIndex, -1)
				
				if (self.DoPump) then
					self:SetHardSequenceEnd(bActivity and flCurTime + self:SequenceLength(iIndex) or 0, iIndex)
					local fCooldown = function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end
					
					self:AddEvent("pump", fCooldown, function() 
						self:PlaySound("pump", iIndex)
						self:SetHardSequenceEnd(self:PlayActivity("pump", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex), iIndex)
						
						if (bDoZoomEvent) then
							RezoomEvent(self, fCooldown, iLevel, bSecondary, iIndex)
						end
						
						return true
					end)
				else
					if (bDoZoomEvent) then
						RezoomEvent(self, flCooldown, iLevel, bSecondary, iIndex)
					end
					
					local flNewTime = flCurTime + flCooldown
					self:SetNextAttack(flNewTime, false, iIndex)
					self:SetNextAttack(flNewTime, true, iIndex)
					self:SetNextReload(flNewTime, iIndex)
				end
				
				return true
			end
			
			iCurCount = iCurCount + 1
			
			if (tTimes[iCurCount]) then
				return tTimes[iCurCount]
			end
		end)
	else
		self:SetPredictedVar("ReduceShotTime" .. iIndex, -1)
		
		if (self.DoPump) then
			self:SetHardSequenceEnd(bActivity and flCurTime + self:SequenceLength(iIndex) or 0, iIndex)
			local fCooldown = function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end
			
			self:AddEvent("pump", fCooldown, function() 
				self:PlaySound("pump", iIndex)
				self:SetHardSequenceEnd(self:PlayActivity("pump", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex), iIndex)
				
				if (bDoZoomEvent) then
					RezoomEvent(self, fCooldown, iLevel, bSecondary, iIndex)
				end
				
				return true
			end)
		else
			if (bDoZoomEvent) then
				RezoomEvent(self, flCooldown, iLevel, bSecondary, iIndex)
			end
			
			local flNextTime = flCurTime + flCooldown
			self:SetNextAttack(flNextTime, false, iIndex)
			self:SetNextAttack(flNextTime, true, iIndex)
			self:SetNextReload(flNextTime, iIndex)
		end
	end
	
	if (not self:DoMuzzleFlash(iIndex)) then
		pPlayer:MuzzleFlash()
	end
	
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	
	self:SetShotsFired(self:GetShotsFired(iIndex) + 1, iIndex)
	self:SetLastAttackTime(flCurTime, iIndex)
	
	if (bCustomFiring) then
		self:SetLastShootTime()
	end
	
	if (self:GetBipodDeployed()) then
		local pDeployedEnt = self:GetPredictedVar("DeployEntity", NULL)
		
		if (pDeployedEnt:IsPlayer()) then
			pDeployedEnt:SetDSP(32, false)
		end
	end
	
	self:Punch(bSecondary, iIndex)
	self:PlaySound(bSecondary and "shoot2" or "shoot", iIndex)
	
	return self:PlayActivity(bSecondary and "shoot2" or "shoot", iIndex) ~= -1
end

function SWEP:Punch()
end

function SWEP:UpdateBurstShotTable(tbl, bSecondary --[[= false]], iIndex --[[= 0]])
	tbl.Dir = self:GetShootDir(iIndex)
	tbl.ShootAngles = self:GetShootAngles(iIndex)
	tbl.Src = self:GetShootSrc(iIndex)
end

local function GetMeleeSound(self, tr, bSecondary --[[= false]], iIndex --[[= 0]])
	if (tr.Hit and not tr.HitSky) then
		local pEntity = tr.Entity
		
		return (pEntity:IsPlayer() or pEntity:IsNPC())
			and (bSecondary "hit2" or "hit") or (bSecondary and "hitworld2" or "hitworld")
	end
	
	return bSecondary and "miss2" or "miss"
end

function SWEP:Swing(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary == nil) then
		bSecondary = false
	end
	
	if (iIndex == nil) then
		iIndex = 0
	end
	
	local flSmackDelay = self:GetSpecialKey("SmackDelay", bSecondary, iIndex)
	local flEffectDelay = self:GetSpecialKey("EffectDelay", bSecondary, iIndex)
	local bSmackNoDelay = flSmackDelay == 0
	local bEffectNoDelay = flEffectDelay == 0
	local tMelee = self.Melee
	local bShouldTrace = bSmackNoDelay or bEffectNoDelay or tMelee.InitialTrace
	
	local pPlayer = self:GetOwner()
	
	if (bShouldTrace) then
		pPlayer:LagCompensation(true)
	end
	
	local vSrc = self:GetShootSrc(iIndex)
	local vForward = self:GetShootDir(iIndex)
	local flRange = self:GetSpecialKey("Range", bSecondary, iIndex)
	local tr, tbl
	
	if (bShouldTrace) then
		tbl = {
			start = vSrc,
			endpos = vSrc + vForward * flRange,
			mask = tMelee.Mask,
			filter = pPlayer
		}
		tr = self:GetMeleeTrace(tbl, vForward)
	else
		tbl = {}
		tr = util.ClearTrace()
	end
	
	if (bShouldTrace) then
		pPlayer:LagCompensation(false)
	end
	
	local bActivity = self:PlayActivity(tr.Hit and not tr.HitSky and (bSecondary and "hit2" or "hit") or (bSecondary and "miss2" or "miss"), iIndex)
	-- FIXME: Go through all IsValid instances and account for the world
	local bHit = not bShouldTrace or tr.Hit and not tr.HitSky
	
	if (bHit) then
		if (bActivity) then
			if (self:UseViewModel(iIndex)) then
				local flScale = pPlayer:GetViewModel(iIndex):GetPlaybackRate()
				flScale = flScale == 0 and 1 or flScale < 0 and -flScale or flScale
				
				flSmackDelay = flSmackDelay / flScale
				flEffectDelay = flEffectDelay / flScale
			end
		end
		
		if (bSmackNoDelay) then
			self:SmackDamage(tr, vForward, bSecondary, iIndex)
		else
			self:AddEvent("smackdamage_" .. iIndex, flSmackDelay, function()
				local bRetrace = not bShouldTrace or tMelee.Retrace
				
				if (bRetrace) then
					pPlayer:LagCompensation(true)
					
					local vSrc = self:GetShootSrc(iIndex)
					vForward = self:GetShootDir(iIndex)
					
					local tbl = tbl
					tbl.start = vSrc
					tbl.endpos = vSrc + vForward * flRange
					tbl.mask = tMelee.Mask
					tbl.filter = pPlayer
					tbl.output = tr
					
					tr = self:GetMeleeTrace(tbl, vForward)
					
					pPlayer:LagCompensation(false)
					
					if (not tr.Hit or tr.HitSky) then
						return true
					end
				elseif (not (tr.Entity:IsWorld() or tr.Entity:IsValid())) then
					return true
				end
				
				self:SmackDamage(tr, vForward, bSecondary, iIndex)
				
				return true
			end)
		end
		
		if (bEffectNoDelay) then
			self:SmackEffect(tr, vForward, bSecondary, iIndex)
			self:PlaySound(GetMeleeSound(self, tr, bSecondary, iIndex), iIndex)
		else
			self:AddEvent("smackeffect_" .. iIndex, flEffectDelay, function()
				local bRetrace = not bShouldTrace or tMelee.Retrace
				
				if (bRetrace) then
					pPlayer:LagCompensation(true)
					
					local vSrc = self:GetShootSrc(iIndex)
					vForward = self:GetShootDir(iIndex)
					
					local tbl = tbl
					tbl.start = vSrc
					tbl.endpos = vSrc + vForward * flRange
					tbl.mask = tMelee.Mask
					tbl.filter = pPlayer
					tbl.output = tr
					
					tr = self:GetMeleeTrace(tbl, vForward)
					
					pPlayer:LagCompensation(false)
					
					if (not tr.Hit or tr.HitSky) then
						return true
					end
				elseif (not (tr.Entity:IsWorld() or tr.Entity:IsValid())) then
					return true
				end
				
				self:SmackEffect(tr, vForward, bSecondary, iIndex)
				self:PlaySound(GetMeleeSound(self, tr, bSecondary, iIndex), iIndex)
				
				return true
			end)
		end
	end
		
	if (not (bHit and bShouldTrace)) then
		self:PlaySound(GetMeleeSound(self, tr, bSecondary, iIndex), iIndex)
	end
	
	// Send the anim
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	
	// Setup out next attack times
	local flCurTime = CurTime()
	local flCooldown = self:GetSpecialKey("Cooldown", bSecondary, iIndex)
	local flNextTime = flCurTime + flCooldown
	
	self:SetLastAttackTime(flCurTime, iIndex)
	self:SetLastShootTime()
	
	self:SetNextAttack(flNextTime, false, iIndex)
	self:SetNextAttack(bActivity and flCurTime + self:SequenceLength(iIndex) or flNextTime, true, iIndex)
	self:SetNextReload(flNextTime, iIndex)
	
	return bActivity, bHit
end

function SWEP:Throw(iType --[[= code_gs.weapons.GRENADE_THROW]], iIndex --[[= 0]])
	self:SetShouldThrow(iType or code_gs.weapons.GRENADE_THROW, iIndex)
	self:PlaySound("pullback", iIndex)
	
	return self:PlayActivity("pullback", iIndex) ~= -1
end

--- Attachments/Effects
function SWEP:ToggleSilenced(iIndex --[[= 0]])
	self:PlaySound("silence", iIndex)
	self:SetHardSequenceEnd(self:PlayActivity("silence", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex), iIndex)
	
	self:AddEvent("silence", function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end, function()
		self:SetSilenced(not self:GetSilenced(iIndex), iIndex)
		
		return true
	end)
end

function SWEP:ToggleLowered(iIndex --[[= 0]])
	-- FIXME: Add alternative to activity
	self:PlaySound("lower", iIndex)
	self:SetHardSequenceEnd(self:PlayActivity("lower", iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex), iIndex)
	
	self:AddEvent("lower", function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end, function()
		self:SetLowered(not self:GetLowered(iIndex), iIndex)
		
		return true
	end)
end

local function DoBipodAnimation(self, bForce --[[= false]])
	local flCurTime = CurTime()
	local flDeployEndTime = 0
	
	-- Deploy all viewmodels
	for i = 0, self.ViewModelCount - 1 do
		if (self:UseViewModel(i)) then
			self:PlaySound("deploy", i)
			local bDeploySequence = self:PlayActivity("deploy", i) ~= -1
			
			if (bForce) then
				-- Stop reloading for a deploy state change
				self:RemoveReload(i)
				
				if (bSinglePlayerPredicted and i == self:GetWorldModelIndex()) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(self:GetOwner())
				end
				
				if (bDeploySequence) then
					flDeployEndTime = math.max(flDeployEndTime, self:SequenceLength(i))
				end
				
				local flEndTime = flCurTime + self.BipodDeploy.ForceUndeployPenalty
				self:SetNextAttack(flEndTime, false, i)
				self:SetNextAttack(flEndTime, true, i)
				self:SetNextReload(flEndTime, i)
			elseif (bDeploySequence) then
				local flSequenceLength = self:SequenceLength(i)
				flDeployEndTime = math.max(flDeployEndTime, flSequenceLength)
				self:SetHardSequenceEnd(flCurTime + flSequenceLength, i)
			else
				self:SetHardSequenceEnd(0, i)
			end
		end
	end
	
	if (flDeployEndTime == 0) then
		flDeployEndTime = self.BipodDeploy.TimeToDeploy
	end
	
	self:SetPredictedVar("DeployTime", flCurTime) -- FIXME: Currently isn't used - change that
	self:SetPredictedVar("DeployEndTime", flCurTime + flDeployEndTime)
	self:SetPredictedVar("DeployLength", flDeployEndTime)
	
	self:SetPredictedVar("DeployUpdateViewAnim", true)
end
-- FIXME: Rename this and make it work properly with prediction
-- FIXME: Check the penalty time causing the animation to be interrupted, and reload cancelling
function SWEP:ToggleBipodDeploy(bForce --[[= false]])
	if (self:GetBipodDeployed()) then
		self:SetBipodDeployed(false)
		DoBipodAnimation(self, bForce)
		
		return true
	end
	
	local bSuccess, flDeployedHeight, pDeployedOn, flYawStart, flYawLimitLeft, flYawLimitRight = self:TestBipodDeploy()
	
	if (bSuccess) then
		local pPlayer = self:GetOwner()
		self:SetBipodDeployed(true)
		DoBipodAnimation(self, bForce)
		
		self:SetPredictedVar("DeployHeight", flDeployedHeight)
		self:SetPredictedVar("DeployEntity", pDeployedOn)
		self:SetPredictedVar("DeployPos", pDeployedOn:GetPos())
		self:SetPredictedVar("DeployYawStart", flYawStart)
		self:SetPredictedVar("DeployYawLeft", flYawLimitLeft)
		self:SetPredictedVar("DeployYawRight", flYawLimitRight)
		
		// Save this off so we do duck checks later, even though we won't be flagged as ducking
		self:SetPredictedVar("DeployCrouched", pPlayer:Crouching())
		
		// More TODO:
		// recalc our yaw limits if the item we're deployed on has moved or rotated
		// if our new limits are outside our current eye angles, undeploy us
		
		if (bSinglePlayerPredicted) then
			net.Start("GS-Weapons-Bipod deploy")
				net.WriteDouble(flYawStart) -- No imprecisions
				net.WriteDouble(flYawLimitLeft)
				net.WriteDouble(flYawLimitRight)
			net.Send(pPlayer)
		end
	end
	
	return bSuccess
end

local function TestDeployAngle(vForward, vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, flStepSize, iAttempts, tbl, tr)
	// sandbags are around 50 units high. Shouldn't be able to deploy on anything a lot higher than that

	// optimal standing height (for animation's sake) is around 42 units
	// optimal ducking height is around 20 units (20 unit high object, plus 8 units of gun)

	// Start one half box width away from the edge of the player hull
	local vForwardStart = vStart + vForward * flStartOffset
	
	tbl.start = vForwardStart
	tbl.endpos = vForwardStart + vForward * flMaxForwardDist
	util.TraceHull(tbl)
	
	-- I would leave these in, but they lag A TON from piling up
	--debugoverlay.Line(vForwardStart, tbl.endpos, DEBUG_LENGTH, color_debug)
	--debugoverlay.Box(vForwardStart, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_altdebug)
	--debugoverlay.Box(tr.HitPos, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_debug)
	
	// Test forward, are we trying to deploy into a solid object?
	if (tr.Fraction ~= 1) then
		return false
	end
	
	local vDownTraceStart = vStart + vForward * flDownOffset
	
	// search down from the forward trace
	// use the farthest point first. If that fails, move towards the player a few times
	// to see if they are trying to deploy on a thin railing
	
	local flHighestTraceEnd = vDownTraceStart[3] + vTraceHeight[3]
	local pBestDeployEnt = NULL
	local bFound = false
	
	tbl.start = vDownTraceStart
	tbl.endpos = vDownTraceStart + vTraceHeight // trace forward one box width
	
	while (iAttempts > 0) do
		util.TraceHull(tbl)
		
		--debugoverlay.Line(vDownTraceStart, tr.HitPos, DEBUG_LENGTH, color_debug)
		--debugoverlay.Box(vDownTraceStart, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_altdebug)
		--debugoverlay.Box(tr.HitPos, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_debug)
		
		local bSuccess = not (tr.Fraction == 1 or tr.StartSolid or tr.AllSolid)
		
		// if this is the first one found, set found flag
		if (bSuccess) then
			if (not bFound) then
				bFound = true
			end
		elseif (bFound) then
			// it failed and we have some data. break here
			break
		end
		
		local flTraceHeight = tr.HitPos[3]
		
		// if this trace is better (higher) use this one
		if (flTraceHeight > flHighestTraceEnd) then
			flHighestTraceEnd = flTraceHeight
			pBestDeployEnt = tr.Entity
		end
		
		iAttempts = iAttempts - 1
		
		// move towards the player, looking for a better height to deploy on
		vDownTraceStart:Add(vForward * flStepSize)
	end
	
	if (bFound and pBestDeployEnt:IsValid()) then
		return true, flHighestTraceEnd, pBestDeployEnt
	end
	
	return false
end

local DEPLOY_DOWNTRACE_OFFSET = 16 // yay for magic numbers

function SWEP:TestBipodDeploy()
	local tDeploy = self.BipodDeploy
	local pPlayer = self:GetOwner()
	
	-- Don't deploy in the air, underwater, or during a movement transition
	if (not pPlayer:GetGroundEntity():IsValid()) then
		return false
	end
	
	-- Deploy on what the player is looking at, not where they're necessarily facing
	local aEyes = pPlayer:EyeAngles()
	local flPitch = aEyes[1]
	
	-- In-case EyeAngles isn't bounded correctly
	-- FIXME: Can use modulo, but I forgot how it handles negative numbers
	if (flPitch > 180) then
		flPitch = flPitch - 360
	end
	
	-- Don't deploy while the player is looking too high or low
	if (flPitch > tDeploy.MaxPitch or flPitch < tDeploy.MinPitch) then
		return false
	end
	
	local flTraceBox = tDeploy.BoxSize
	local flMaxForwardDist = tDeploy.ForwardTrace - 2 * flTraceBox
	
	-- Don't trace backward
	if (flMaxForwardDist < 0) then
		return false
	end
	
	aEyes[1] = 0 -- Now that the bounds have been checked, only check for y-axis rotation
	local _, vMaxs = pPlayer:GetHull()
	local flMaxX = vMaxs[1]
	local flStartOffset = flMaxX + flTraceBox
	local flDownTrace = tDeploy.DownTrace
	local flDownOffset = flMaxX + flDownTrace
	local vTraceBox = Vector(flTraceBox, flTraceBox, flTraceBox)
	local vStart = pPlayer:GetPos()
	local flStartHeight = vStart[3]
	local flHeightOffset = flTraceBox + flStartHeight - DEPLOY_DOWNTRACE_OFFSET
	
	local bDeployed = self:GetBipodDeployed()
	local pFilter
	
	if (bDeployed) then
		pFilter = player.GetAll()
		local pDeployedOn = self:GetPredictedVar("DeployEntity", NULL)
		
		if (pDeployedOn:IsPlayer()) then -- FIXME: Make work with NPCs?
			local iPlayers = player.GetCount()
			
			for i = 1, iPlayers do
				if (pFilter[i] == pDeployedOn) then
					-- Remove the deployed entity from the filter
					pFilter[i] = pFilter[iPlayers]
					pFilter[iPlayers] = nil
				end
			end
		end
	else
		pFilter = pPlayer
	end
	
	if (bDeployed and self:GetPredictedVar("DeployCrouched", false) or pPlayer:Crouching()) then
		local _, vMaxs = pPlayer:GetHullDuck()
		flStartHeight = flStartHeight + vMaxs[3] - flTraceBox - flDownTrace / 4
	else
		-- FIXME: Source of 60? Is related to DoD player height
		flStartHeight = flStartHeight + 60 - flTraceBox - flDownTrace / 4
	end
	
	vStart[3] = flStartHeight
	
	local tr = {}
	local tbl = {
		mask = MASK_SOLID,
		filter = pFilter,
		mins = -vTraceBox,
		maxs = vTraceBox,
		output = tr
	}
	
	local vTraceHeight = pPlayer:OBBMaxs()
	vTraceHeight[1] = 0
	vTraceHeight[2] = 0
	vTraceHeight[3] = -vTraceHeight[3]
	
	-- Returns
	local bSuccess, flDeployedHeight, pDeployedOn = TestDeployAngle(aEyes:Forward(), vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, tDeploy.StepSize, tDeploy.TraceAttempts, tbl, tr)
	
	// can't deploy here, drop out early
	-- If we can't deploy right in front of us, no use in checking the further angles
	if (not bSuccess or flDeployedHeight - flHeightOffset < tDeploy.MinDeployHeight) then
		return false
	end
	
	local flYaw = aEyes[2]
	local flLeft = 0
	local flYawLimitLeft = 0
	
	repeat
		flLeft = flLeft + tDeploy.Delta
		aEyes[2] = flYaw + flLeft
		local bSuccess, flTestDeployHeight = TestDeployAngle(aEyes:Forward(), vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, tDeploy.StepSize, tDeploy.TraceAttempts, tbl, tr)
		
		// don't allow yaw to a position that is too different in height
		if (not bSuccess or math.abs(flDeployedHeight - flTestDeployHeight) > tDeploy.MaxHeightDifference) then
			break
		end
		
		flYawLimitLeft = flLeft
	until (flLeft > tDeploy.MaxYaw)
	
	// we already tested directly ahead and it was clear. skip one test
	local flRight = 0
	local flYawLimitRight = 0
	
	// Sweep Right
	while (flRight <= tDeploy.MaxYaw) do
		flRight = flRight + tDeploy.Delta
		aEyes[2] = flYaw - flRight
		local bSuccess, flTestDeployHeight = TestDeployAngle(aEyes:Forward(), vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, tDeploy.StepSize, tDeploy.TraceAttempts, tbl, tr)
		
		// don't allow yaw to a position that is too different in height
		if (not bSuccess or math.abs(flDeployedHeight - flTestDeployHeight) > tDeploy.MaxHeightDifference) then
			break
		end
		
		flYawLimitRight = flRight
	end
	
	-- Eek, no references in Lua
	return true, flDeployedHeight - flHeightOffset, pDeployedOn, flYaw, flYawLimitLeft, -flYawLimitRight
end

function SWEP:ShouldBipodUndeploy()
	local bSuccess, flDeployedHeight, pDeployedOn, flYaw, flYawLimitLeft, flYawLimitRight = self:TestBipodDeploy()
	
	// If the entity we were deployed on has changed, or has moved, the origin
	// of it will be different. If so, recalc our yaw limits.
	if (bSuccess and math.abs(pWeapon:GetPredictedVar("DeployHeight", 0) - flDeployedHeight) <= self.BipodDeploy.MaxHeightDifference) then
		local vNewPos = pDeployedOn:GetPos()
		self:SetPredictedVar("DeployEntity", pDeployedOn)
		
		-- FIXME: Figure out how to predict all of this and properly move the yaw limits
		if (self:GetPredictedVar("DeployPos", vector_origin) ~= vNewPos) then
			self:SetPredictedVar("DeployPos", vNewPos)
			self:SetPredictedVar("DeployYawLeft", flYawLimitLeft)
			self:SetPredictedVar("DeployYawRight", flYawLimitRight)
			
			if (bSinglePlayerPredicted) then
				net.Start("GS-Weapons-Bipod deploy update")
					net.WriteDouble(flYawLimitLeft)
					net.WriteDouble(flYawLimitRight)
				net.Send(self:GetOwner())
			end
		end
		
		return false
	end
	
	return true
end

-- Doesn't really matter which viewmodel is zoomed in since no specific anims are assosiated with it
-- But an index parameter is present for sound purposes
function SWEP:AdvanceZoom(iIndex --[[= 0]])
	local tZoom = self.Zoom
	local iLevel = (self:GetZoomLevel() + 1) % (tZoom.Levels + 1)
	local iFOV = iLevel == 0 and 0 or tZoom.FOV[iLevel]
	local flTime = tZoom.Times[iLevel] or tZoom.Times[0]
	
	if (iFOV and flTime) then
		self:SetZoomLevel(iLevel)
		self:GetOwner():SetFOV(iFOV, flTime)
	else
		ErrorNoHalt(string.format("%s (gs_baseweapon) Zoom level or time %u not defined! Zooming out..", self:GetClass(), iLevel))
		self:SetZoomLevel(0)
		
		self:GetOwner():SetFOV(0, 0)
	end
	
	self:PlaySound("zoom", iIndex)
	
	local flNextTime = CurTime()
	self:SetNextAttack(flNextTime + tZoom.Cooldown, true, iIndex)
	self:SetZoomActiveTime(flNextTime + flTime)
end

function SWEP:ToggleBurst(iIndex --[[= 0]])
	local bOldState = self:GetBurst(iIndex)
	self:SetBurst(not bOldState, iIndex)
	
	self:PlaySound("burst", iIndex)
	self:PlayActivity("burst", iIndex)
	self:SetNextAttack(CurTime() + self.Burst.Cooldown, true, iIndex)
end

function SWEP:ToggleIronSights(iIndex --[[= 0]])
	local flCurTime = CurTime()
	self:SetIronSights(self:GetIronSights(iIndex), iIndex)
	-- FIXME
	--[[local flTotalTime = self.IronSights.ZoomTime[1]
	local flRemaining = flCurTime - self:GetZoomActiveTime()
	self:SetZoomActiveTime(flCurTime + (flRemaining < flTotalTime
		and flTotalTime - flReamining or flTotalTime))]]
end

function SWEP:ToggleFullyLowered(iIndex --[[= 0]])
	local bNewState = not self:GetHideWeapon(iIndex)
	local sActivity
	
	if (bNewState) then
		sActivity = "holster"
		
		self:AddEvent("lower", function(self) return self:GetHardSequenceEnd(iIndex) <= CurTime() end, function()
			self:SetHideWeapon(bNewState, iIndex)
			
			return true
		end)
	else
		sActivity = "draw"
		self:SetHideWeapon(bNewState, iIndex)
	end
	
	self:PlaySound(sActivity, iIndex)
	self:SetHardSequenceEnd(self:PlayActivity(sActivity, iIndex) == -1 and 0 or CurTime() + self:SequenceLength(iIndex))
end

--- Hooks
function SWEP:FireAnimationEvent(vPos, aRot, iEvent, sOptions)
	local sStyle = self.EventStyle[iEvent]
	
	if (sStyle) then
		code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Event %u played with %q style", self:GetClass(), iEvent, sStyle))
			
		return code_gs.weapons.GetAnimEvent(iEvent, sStyle:lower())(self, vPos, aRot, iEvent, sOptions)
	end
	
	code_gs.DevMsg(1, string.format("%s (gs_baseweapon) Missing event %u: %s", self:GetClass(), iEvent, sOptions))
end

-- Using this instead of Player:MuzzleFlash() allows all viewmodels to use muzzle flash
function SWEP:DoMuzzleFlash(iIndex)
	return self:GetSilenced(iIndex)
end

-- Will only be called serverside in single-player
function SWEP:DoImpactEffect(tr, nDamage)
	return false
end

function SWEP:DoSplashEffect()
	return false
end

function SWEP:TranslateActivity(nActivity)
	local iIndex = self:GetWorldModelIndex()
	
	return code_gs.weapons.GetHoldTypeActivity(
		(self:GetHideWeapon(iIndex) or self:GetNWVar("Float", "HolsterAnimEnd") > CurTime()) and "normal"
		or self:GetLowered(iIndex) and "passive" or self.HoldType, nActivity)
end

function SWEP:SmackDamage(tr, vForward, bSecondary, iIndex)
	local flDamage = self:GetSpecialKey("Damage", bSecondary, iIndex)
	
	local info = DamageInfo()
		info:SetAttacker(self:GetOwner())
		info:SetInflictor(self)
		info:SetDamage(flDamage)
		info:SetDamageType(self.Melee.DamageType)
		info:SetDamagePosition(tr.HitPos)
		info:SetReportedPosition(tr.StartPos)
		info:SetDamageForce(vForward * info:GetBaseDamage() * self:GetSpecialKey("Force", bSecondary, iIndex) * phys_pushscale:GetFloat())
	tr.Entity:DispatchTraceAttack(info, tr, vForward)
end

function SWEP:SmackEffect(tr, vForward, bSecondary, iIndex)
	local tMelee = self.Melee
	local pPlayer = self:GetOwner()
	local vSrc = tr.StartPos
	local tbl = {}
	
	local bFirstTimePredicted = IsFirstTimePredicted()
	
	local bHitWater = bit.band(util.PointContents(vSrc), MASK_WATER) ~= 0
	local bEndNotWater = bit.band(util.PointContents(tr.HitPos), MASK_WATER) == 0
	local trSplash = bHitWater and bEndNotWater and
		util.TraceLine({
			start = tr.HitPos,
			endpos = vSrc,
			mask = MASK_WATER
		})
	or not (bHitWater or bEndNotWater) and
		util.TraceLine({
			start = vSrc,
			endpos = tr.HitPos,
			mask = MASK_WATER
		})
	
	if (trSplash and not self:DoSplashEffect(trSplash) and bFirstTimePredicted) then
		local data = EffectData()
			data:SetOrigin(trSplash.HitPos)
			data:SetScale(8)
			
			if (bit.band(util.PointContents(trSplash.HitPos), CONTENTS_SLIME) ~= 0) then
				data:SetFlags(FX_WATER_IN_SLIME)
			end
			
		util.Effect("watersplash", data)
	end
		
	if (not (tr.Fraction == 1 or trSplash or self:DoImpactEffect(tr, tMelee.DamageType))) then
		local data = EffectData()
			data:SetOrigin(tr.HitPos)
			data:SetStart(vSrc)
			data:SetSurfaceProp(tr.SurfaceProps)
			data:SetDamageType(tMelee.DamageType)
			data:SetHitBox(tr.HitBox)
			data:SetEntity(tr.Entity)
		util.Effect("Impact", data)
	end
end

function SWEP:StartReload(iIndex)
end

function SWEP:InterruptReload(iIndex)
end

function SWEP:FinishReload(iIndex)
end

--- Utilities
function SWEP:AddEvent(sName, Time, fCall)
	sName = "Event-" .. sName:lower()
	self:SetPredictedVar(sName, {Time, isfunction(Time) and true or CurTime() + Time, fCall})
	
	local tEvents = {}
	local tOldEvents = self:GetPredictedVar("ActiveEvents", tEventDefault)
	tEvents[0] = tOldEvents[0] + 1
	
	for i = 1, tOldEvents[0] do
		tEvents[i] = tOldEvents[i]
	end
	
	tEvents[tEvents[0]] = sName
	self:SetPredictedVar("ActiveEvents", tEvents)
end

function SWEP:EventActive(sName)
	return self:GetPredictedVar("Event-" .. sName:lower()) ~= nil
end

function SWEP:RemoveEvent(sName)
	self:SetPredictedVar("Event-" .. sName:lower(), nil)
end

-- Remove the event and call the associated hook
function SWEP:RemoveReload(iIndex --[[= 0]])
	if (iIndex == nil) then
		iIndex = 0
	end
	
	self:RemoveEvent("reload_" .. iIndex)
	self:InterruptReload(iIndex)
end

function SWEP:PlaySound(sSound, iIndex, bPlayShared --[[= false]])
	-- Could use goto, but ehhhh
	local bDefault = true
	
	for sPrefix, func in pairs(self.SoundPrefixes) do
		if (func ~= false and func(self, iIndex)) then
			local sNewSound = self:LookupSound(sPrefix .. "_" .. sSound, iIndex)
			
			if (sNewSound ~= "") then
				sSound = sNewSound
				bDefault = false
				
				break
			end
		end
	end
	
	if (bDefault) then
		sSound = self:LookupSound(sSound, iIndex)
	end
	
	if (sSound == "") then
		return false
	end
	
	if (bPlayShared or SERVER) then
		local pPlayer = self:GetOwner()
		
		if (pPlayer:IsValid()) then
			pPlayer:EmitSound(sSound)
		else
			self:EmitSound(sSound)
		end
	end
	
	return true
end

local function TestActivity(self, sActivity, pViewModel, iIndex --[[= 0]], flRate --[[= 1]])
	local Activity = self:LookupActivity(sActivity, iIndex)
	
	if (isstring(Activity)) then
		return true, self:PlaySequence(Activity, iIndex, flRate or self:LookupActivityKey(sActivity, "rate", iIndex))
	end
	
	if (Activity == ACT_RESET) then
		return true, self:ResetActivity(iIndex, flRate or self:LookupActivityKey(sActivity, "rate", iIndex))
	end
	
	if (Activity == ACT_INVALID) then
		return false, -1
	end
	
	return Activity, pViewModel:SelectWeightedSequence(Activity)
end

local function TestActivityTable(self, tPrefix, tSuffix, sActivity, pViewModel, iIndex --[[= 0]], flRate --[[= 0]], bStrictTags --[[= false]])
	local sPrefixTest = "_" .. sActivity
	
	for sPrefix, func in pairs(tPrefix) do
		if (func ~= false and func(self, iIndex)) then
			local sNewActivity = sPrefix .. sPrefixTest
			local sSuffixTest = sNewActivity .. "_"
			
			for sSuffix, func in pairs(tSuffix) do
				if (func ~= false and func(self, iIndex)) then
					local sNewActivity = sSuffixTest .. sSuffix
					local iNewActivity, iNewSequence = TestActivity(self, sNewActivity, pViewModel, iIndex, flRate)
					
					if (iNewActivity == true) then
						return true, iNewSequence
					end
					
					if (iNewSequence ~= -1) then
						return iNewActivity, iNewSequence, sNewActivity
					end
					
					if (bStrictTags) then
						return true, -1
					end
				end
			end
			
			local iNewActivity, iNewSequence = TestActivity(self, sNewActivity, pViewModel, iIndex, flRate)
			
			if (iNewActivity == true) then
				return true, iNewSequence
			end
			
			if (iNewSequence ~= -1) then
				return iNewActivity, iNewSequence, sNewActivity
			end
			
			if (bStrictTags) then
				return true, -1
			end
		end
	end
	
	local sSuffixTest = sActivity .. "_"
	
	for sSuffix, func in pairs(tSuffix) do
		if (func ~= false and func(self, iIndex)) then
			local sNewActivity = sSuffixTest .. sSuffix
			local iNewActivity, iNewSequence = TestActivity(self, sNewActivity, pViewModel, iIndex, flRate)
			
			if (iNewActivity == true) then
				return true, iNewSequence
			end
			
			if (iNewSequence ~= -1) then
				return iNewActivity, iNewSequence, sNewActivity
			end
			
			if (bStrictTags) then
				return true, -1
			end
		end
	end
	
	return false
end

-- SendWeaponAnim that supports idle times and multiple view models
-- Sending in a value for flRate will ignore the SWEP.Activities defined rate
-- FIXME: Fix SelectWeightedSequence for non-predicted instances
function SWEP:PlayActivity(Activity, iIndex --[[= 0]], flRate --[[= SWEP.Activities rate or 1]], bStrictTags --[[= false]])
	if (self:GetHideWeapon(iIndex)) then
		return -1
	end
	
	local pPlayer = self:GetOwner()
	local pViewModel = pPlayer:GetViewModel(iIndex)
	
	-- Do not give animations to something that does not exist or is invisible
	if (not (pViewModel:IsValid() and pViewModel:IsVisible())) then
		return -1
	end
	
	local iActivity, iSequence, sActivity
	
	if (isstring(Activity)) then
		iActivity, iSequence, sActivity = TestActivityTable(self, self.StrictPrefixes, self.StrictSuffixes, Activity, pViewModel, iIndex, flRate, bStrictTags)
		
		if (iActivity == false) then
			iActivity, iSequence, sActivity = TestActivityTable(self, self.WeakPrefixes, self.WeakSuffixes, Activity, pViewModel, iIndex, flRate, false)
			
			if (iActivity == false) then
				iActivity, iSequence = TestActivity(self, Activity, pViewModel, iIndex, flRate)
				
				if (iSequence == -1) then
					return -1
				end
				
				sActivity = Activity
			end
		end
		
		if (iActivity == true) then
			return iSequence
		end
		
		if (not flRate) then
			flRate = self:LookupActivityKey(sActivity, "rate", iIndex) or 1
		end
	else
		if (Activity == ACT_INVALID) then
			return -1
		end
		
		if (Activity == ACT_RESET) then
			return self:ResetActivity(iIndex, flRate)
		end
		
		iSequence = pViewModel:SelectWeightedSequence(Activity)
		
		if (iSequence == -1) then
			return -1
		end
		
		iActivity = Activity
		
		if (not flRate) then
			flRate = 1
		end
	end
	
	if (iIndex == nil) then
		iIndex = 0
	end
	
	if (iIndex == 0) then
		// Take the new activity
		self:SetSaveValue("m_IdealActivity", iActivity)
		self:SetSaveValue("m_nIdealSequence", iSequence)
	end
	
	// Find the next sequence in the potential chain of sequences leading to our ideal one
	local iNext = pViewModel:FindTransitionSequence(pViewModel:GetSequence(), iSequence)
	
	if (iNext ~= iSequence) then
		// Set our activity to the next transitional animation
		iActivity = ACT_TRANSITION
		iSequence = iNext
	end
	
	if (iIndex == 0) then
		-- Since m_Activity in not avaliable in the save table, run Weapon:Weapon_SetActivity() and override everything afterward
		self:Weapon_SetActivity(iActivity)
		--self:SetSequence(iSequence)
		--self:SetPlaybackRate(flRate)
	end
	
	if (SERVER or self:GetPredictable()) then
		-- Enable the view-model if an animation is sent to it
		pViewModel:SendViewModelMatchingSequence(iSequence) -- Runs SetSequence internally
		pViewModel:SetPlaybackRate(flRate)
	end
	
	-- Idle times won't be properly scaled if SetPlaybackRate is called in the middle of a sequence
	-- https://github.com/Facepunch/garrysmod-requests/issues/704
	if (flRate == 0) then
		self:SetNextIdle(-1, iIndex) -- No movement!
	else
		local flTime
		
		if (sActivity) then
			flTime = self:LookupActivityKey(sActivity, "idle", iIndex)
			
			if (not flTime) then
				flTime = pViewModel:SequenceDuration()
			elseif (istable(flTime)) then
				flTime = code_gs.random:SharedRandomFloat(pPlayer, self:GetClass() .. "IdleTime" .. iIndex .. "-" .. sActivity, flTime[1], flTime[2])
			end
		else
			flTime = pViewModel:SequenceDuration()
		end
		
		self:SetNextIdle(flTime / (flRate < 0 and -flRate or flRate) + CurTime(), iIndex)
	end
	
	return iSequence
end

function SWEP:PlaySequence(Sequence, iIndex --[[= 0]], flRate --[[= 1]])
	if (Sequence == -1) then
		return -1
	end
	
	local pViewModel = self:GetOwner():GetViewModel(iIndex)
	
	if (not (pViewModel:IsValid() and pViewModel:IsVisible())) then
		return false
	end
	
	local flTime
	
	if (isstring(Sequence)) then
		Sequence, flTime = pViewModel:LookupSequence(Sequence)
		
		if (Sequence == -1) then
			return -1
		end
	else
		flTime = pViewModel:SequenceDuration(Sequence)
	end
	
	if (not flRate) then
		flRate = 1
	end
	
	if (iIndex == nil) then
		iIndex = 0
	end
	
	if (iIndex == 0) then
		self:SetSaveValue("m_nIdealSequence", Sequence)
	end
	
	if (SERVER or self:GetPredictable()) then
		pViewModel:SendViewModelMatchingSequence(Sequence)
		pViewModel:SetPlaybackRate(flRate)
	end
	
	if (flRate == 0) then
		self:SetNextIdle(0, iIndex)
	else
		self:SetNextIdle(flTime / (flRate < 0 and -flRate or flRate) + CurTime(), iIndex)
	end
	
	return Sequence
end

-- Not sending in a rate value will fallback to the previously set value
function SWEP:ResetActivity(iIndex --[[= 0]], flRate --[[= Previous rate]])
	local pViewModel = self:GetOwner():GetViewModel(iIndex)
	
	if (not (pViewModel:IsValid() and pViewModel:IsVisible())) then
		return -1
	end
	
	-- https://github.com/Facepunch/garrysmod-issues/issues/3038
	pViewModel:SetCycle(0)
	
	if (flRate) then
		pViewModel:SetPlaybackRate(flRate)
	else
		flRate = pViewModel:GetPlaybackRate()
	end
		
	if (flRate == 0) then
		self:SetNextIdle(0, iIndex)
	else
		self:SetNextIdle(flTime / (flRate < 0 and -flRate or flRate) + CurTime(), iIndex)
	end
	
	return pViewModel:GetSequence()
end

-- Add multiple viewmodel support to SequenceDuration
-- https://github.com/Facepunch/garrysmod-issues/issues/2783
function SWEP:SequenceLength(iIndex --[[= 0]], iSequence --[[= self:GetSequence()]])
	local pPlayer = self:GetOwner()
	
	if (pPlayer:IsValid()) then
		local pViewModel = pPlayer:GetViewModel(iIndex)
		
		if (pViewModel:IsValid()) then
			if (iSequence) then
				return pViewModel:SequenceDuration(iSequence)
			end
			
			return pViewModel:SequenceDuration() / pViewModel:GetPlaybackRate()
		end
	end
	
	return 0.1
end

function SWEP:SequenceEnd(iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
	
	if (pPlayer:IsValid()) then
		local pViewModel = pPlayer:GetViewModel(iIndex)
		
		if (pViewModel:IsValid()) then
			return (1 - pViewModel:GetCycle()) * pViewModel:SequenceDuration() / pViewModel:GetPlaybackRate()
		end
	end
	
	return 0
end

--- Accessors/Modifiers
SWEP.GetNWVar = code_gs.weapons.GetNWVar
SWEP.SetNWVar = code_gs.weapons.SetNWVar
SWEP.SetNWProxy = code_gs.weapons.SetNWProxy
SWEP.GetPredictedVar = code_gs.weapons.GetPredictedVar
SWEP.SetPredictedVar = code_gs.weapons.SetPredictedVar

code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Bool", "Burst", false, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Bool", "BipodDeployed")
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Bool", "HideWeapon", false, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Bool", "IronSights", false, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Bool", "Lowered", false, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Bool", "Silenced", false, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Int", "ShotsFired", 0, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Int", "ShouldThrow", 0, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, true, "Int", "State", 1)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Int", "ZoomLevel")
code_gs.weapons.PredictedAccessorFunc(SWEP, true, "Float", "HardSequenceEnd", 0, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Float", "LastAttackTime", 0, true)
--code_gs.weapons.PredictedAccessorFunc(SWEP, false, "Float", "NextAttack", 0, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, true, "Float", "NextIdle", 0, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, true, "Float", "NextReload", 0, true)
code_gs.weapons.PredictedAccessorFunc(SWEP, false, "Float", "NextItemFrame")
code_gs.weapons.PredictedAccessorFunc(SWEP, bSinglePlayer, "Float", "ZoomActiveTime")

function SWEP:IsFullyBipodDeployed()
	return self:GetBipodDeployed() and self:GetPredictedVar("DeployEndTime", 0) < CurTime()
end

function SWEP:GetSpecialKey(sKey, bSecondary --[[= false]], iIndex --[[= 0]])
	local Val
	
	if (bSecondary) then
		Val = self.Secondary[sKey]
	else
		Val = self.Primary[sKey]
	end
	
	if (isconvar(Val)) then
		local sRet = Val:GetString()
		
		return tonumber(sRet) or sRet
	end
	
	if (isfunction(Val)) then
		return Val(self, iIndex or 0)
	end
		
	return Val
end

function SWEP:GetWalkSpeed()
	return self.WalkSpeed
end

function SWEP:GetRunSpeed()
	return self.RunSpeed
end

function SWEP:LookupSound(sName, iIndex --[[= 0]])
	if (iIndex == nil) then
		iIndex = 0
	end
	
	sName = sName:lower()
	
	local sSound = self.Sounds[sName .. "_" .. iIndex] or self.Sounds[sName]
	
	if (sSound) then
		if (sSound ~= "") then
			-- Auto-refresh fix
			if (istable(sSound)) then
				self:Precache()
				
				sSound = self.Sounds[sName .. "_" .. iIndex] or self.Sounds[sName]
			end
			
			if (isfunction(sSound)) then
				return sSound(self, iIndex)
			end
		end
		
		return sSound
	end
	
	return ""
end

-- Returns the activity and playback rate
function SWEP:LookupActivity(sName, iIndex --[[= 0]])
	if (iIndex == nil) then
		iIndex = 0
	end
	
	sName = sName:lower()
	
	local Activity = self.Activities[sName .. "_" .. iIndex] or self.Activities[sName]
	
	if (Activity) then
		if (istable(Activity)) then
			local iLen = #Activity
			
			if (iLen == 0) then
				return ACT_INVALID
			end
			
			if (iLen == 1) then
				return Activity[1]
			end
			
			return Activity[code_gs.random:SharedRandomInt(self:GetOwner(), self:GetClass() .. "-Activity" .. iIndex .. "-" .. sName, 1, iLen)]
		end
		
		if (isfunction(Activity)) then
			return Activity(self, iIndex)
		end
		
		-- Enum or sequence
		return Activity
	end
	
	return ACT_INVALID
end

function SWEP:LookupActivityKey(sName, sKey, iIndex --[[= 0]])
	if (iIndex == nil) then
		iIndex = 0
	end
	
	local Activity = self.Activities[sName .. "_" .. iIndex] or self.Activities[sName]
	
	if (Activity ~= nil and istable(Activity)) then
		local Ret = Activity[sKey]
		
		if (Ret ~= nil) then
			if (isfunction(Ret)) then
				return Ret(self, iIndex)
			end
			
			return Ret
		end
	end
end

-- Ammo
function SWEP:GetAmmoType(bSecondary --[[= false]], iIndex --[[= 0]])
	return not bSecondary and (iIndex == nil or iIndex == 0) and self:GetPrimaryAmmoType() or -1
end

function SWEP:GetGrenadeAmmoType(iIndex --[[= 0]])
	return not bSecondary and (iIndex == nil or iIndex == 0) and self:GetPrimaryAmmoType() or -1
end

function SWEP:GetDefaultClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return not bSecondary and (iIndex == nil or iIndex == 0) and self:GetDefaultClip1() or -1
end

function SWEP:GetMaxClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return not bSecondary and (iIndex == nil or iIndex == 0) and self:GetMaxClip1() or -1
end

function SWEP:GetClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return not bSecondary and (iIndex == nil or iIndex == 0) and self:Clip1() or -1
end

function SWEP:SetClip(iAmmo, bSecondary --[[= false]], iIndex --[[= 0]])
	if (not bSecondary and (iIndex == nil or iIndex == 0)) then
		self:SetClip1(iAmmo)
	end
end

function SWEP:IsEmpty(bSecondary --[[= false]], iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
	
	if (pPlayer:IsValid()) then
		return self:GetClip(bSecondary, iIndex) == 0 and pPlayer:GetAmmoCount(self:GetAmmoType(bSecondary, iIndex)) == 0
	end
	
	return self:GetClip(bSecondary, iIndex) == 0
end

function SWEP:GetPrimaryAmmoName()
	return self.Primary.Ammo
end

function SWEP:GetSecondaryAmmoName()
	return self.Secondary.Ammo
end

function SWEP:GetDefaultClip1()
	return self.Primary.DefaultClip
end

function SWEP:GetDefaultClip2()
	return self.Secondary.DefaultClip
end

-- Viewmodel
function SWEP:GetViewModel(iIndex --[[= 0]])
	if (iIndex == nil or iIndex == 0) then
		return gs_weapons_usecmodels:GetBool() and self.CModel ~= "" and self.CModel or self.ViewModel
	end
	
	return gs_weapons_usecmodels:GetBool() and self["CModel" .. iIndex] ~= "" and self["CModel" .. iIndex] or self["ViewModel" .. iIndex]
end

-- Games like DoD:S have team-based skins
-- Override this return to choose what skin to use for each viewmodel
function SWEP:GetViewModelSkin(iIndex --[[= 0]])
	return 0
end

function SWEP:FlipsViewModel(iIndex --[[= 0]])
	if (iIndex == nil or iIndex == 0) then
		return self.ViewModelFlip
	end
	
	return self["ViewModelFlip" .. iIndex]
end

function SWEP:UseViewModel(iIndex --[[= 0]])
	return self["m_bUseViewModel" .. (iIndex or 0)] and self:GetOwner():GetViewModel(iIndex):IsValid()
end

function SWEP:ViewModelInactive(iIndex --[[= 0]])
	if (iIndex == 0 or iIndex == nil) then
		return not self:GetOwner():KeyDown(IN_ATTACK)
	end
	
	return true
end

function SWEP:UsesHands(iIndex --[[= 0]])
	if (iIndex == 0 or iIndex == nil) then
		if (self.UseHands) then
			return true
		end
		
		return gs_weapons_usecmodels:GetBool() and self.CModel ~= ""
	end
	
	if (self["UseHands" .. iIndex]) then
		return true
	end
	
	return gs_weapons_usecmodels:GetBool() and self["CModel" .. iIndex] ~= ""
end

-- Worldmodel
function SWEP:GetWorldModel()
	return self.WorldModel
end

function SWEP:GetWorldModelIndex()
	return 0
end

-- Attack
function SWEP:GetNextAttack(bSecondary --[[= false]], iIndex --[[= 0]])
	return self:GetNWVar("Float", (bSecondary and "Secondary" or "Primary") .. "Cooldown" .. (iIndex or 0))
end

function SWEP:SetNextAttack(flTime, bSecondary --[[= false]], iIndex --[[= 0]])
	return self:SetNWVar("Float", (bSecondary and "Secondary" or "Primary") .. "Cooldown" .. (iIndex or 0), flTime)
end

function SWEP:GetFireButton(bSecondary --[[= false]], iIndex --[[= 0]])
	if (iIndex == 0 or iIndex == nil) then
		return bSecondary and IN_ATTACK2 or IN_ATTACK
	end
	
	return 0
end

function SWEP:GetShootAngles(iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + pPlayer:GetViewPunchAngles()
end

function SWEP:GetShootDir(iIndex --[[= 0]])
	return self:GetShootAngles(iIndex):Forward()
end

function SWEP:GetShootSrc(iIndex --[[= 0]])
	return self:GetOwner():GetShootPos()
end

function SWEP:GetShootInfo(bSecondary --[[= false]], iIndex --[[= 0]])
	return {
		AmmoType = self:GetAmmoType(bSecondary, iIndex),
		Damage = self:GetSpecialKey("Damage", bSecondary, iIndex),
		Dir = self:GetShootDir(iIndex),
		Distance = self:GetSpecialKey("Range", bSecondary, iIndex),
		--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
		Force = self:GetSpecialKey("Force", bSecondary, iIndex),
		Num = self:GetSpecialKey("Bullets", bSecondary, iIndex),
		ShootAngles = self:GetShootAngles(iIndex),
		Spread = self:GetSpecialKey("Spread", bSecondary, iIndex),
		SpreadBias = self:GetSpecialKey("SpreadBias", bSecondary, iIndex),
		Src = self:GetShootSrc(iIndex),
		Tracer = self:GetSpecialKey("TracerFreq", bSecondary, iIndex),
		TracerName = self:GetSpecialKey("TracerName", bSecondary, iIndex)
	}
end

function SWEP:GetEjectionAttachment(iEvent)
	return 2
end

function SWEP:GetMuzzleAttachment(iEvent --[[= 5001]])
	-- Assume first attachment
	return ((iEvent or 5001) - 4991) / 10
end

-- This must be done shared
function SWEP:GetTracerOrigin()
	-- Return to override
	-- Default behaviour is Player:ComputeTracerStartPosition(vShootSrc)
end

function SWEP:GetMeleeTrace(tbl, vForward)
	local tr = util.TraceLine(tbl)
	
	if (tr.Fraction == 1) then
		local tMelee = self.Melee
		
		// hull is +/- 16, so use cuberoot of 2 to determine how big the hull is from center to the corner point
		-- Comment is wrong; it's actually the sqrt(3)
		tbl.endpos = tbl.endpos - vForward * tMelee.HullRadius
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.output = tr
		
		util.TraceHull(tbl)
		
		if (tr.Fraction ~= 1 and tr.Entity:IsValid()) then
			local vTarget = tr.Entity:GetPos() - tr.StartPos
			vTarget:Normalize()
			
			// YWB:  Make sure they are sort of facing the guy at least...
			if (vTarget:Dot(vForward) < tMelee.DotRange) then
				// Force amiss
				tr.Fraction = 1
				tr.Entity = NULL
				tr.Hit = false
				bMiss = true
			else
				util.FindHullIntersection(tbl, tr)
			end
		end
	end
	
	return tr
end

-- Compatibility - do not use!
function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:ShootBullet(flDamage --[[= SWEP.Primary.Damage]], flNum --[[SWEP.Primary.Bullets]], flSpread --[[SWEP.Primary.Spread]])
	-- SUPER-DUPER HACK but I don't want to copy and paste a bunch of code
	local fGetShotTable = self.GetShootInfo
	self.GetShootInfo = function(self)
		local tbl = fGetShotTable(self, false)
		tbl.Damage = flDamage
		tbl.Num = flNum
		tbl.Spread = Vector(flSpread, flSpread)
	end
	
	self:Shoot(false)
	
	self.GetShootInfo = fGetShotTable
end

function SWEP:ShootEffects()
	local pPlayer = self:GetOwner()
	
	if (not self:DoMuzzleFlash()) then
		pPlayer:MuzzleFlash()
	end
	
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	self:PlayActivity("shoot")
end

function SWEP:TakePrimaryAmmo(iAmount)
	local iClip = self:Clip1()
	
	if (iClip ~= 0) then
		if (iClip > -1) then
			if (iClip - iAmount < 0) then
				self:SetClip1(0)
			else
				self:SetClip1(iClip - iAmount)
			end
		else	
			local pPlayer = self:GetOwner()
			local iAmmo = self:GetPrimaryAmmoType()
			
			if (pPlayer:GetAmmoCount(iAmmo) > 0) then
				pPlayer:RemoveAmmo(iAmount, iAmmo)
			end
		end
	end
end

function SWEP:TakeSecondaryAmmo(iAmount)
	local iClip = self:Clip2()
	
	if (iClip ~= 0) then
		if (iClip > -1) then
			if (iClip - iAmount < 0) then
				self:SetClip2(0)
			else
				self:SetClip2(iClip - iAmount)
			end
		else	
			local pPlayer = self:GetOwner()
			local iAmmo = self:GetSecondaryAmmoType()
			
			if (pPlayer:GetAmmoCount(iAmmo) > 0) then
				pPlayer:RemoveAmmo(iAmount, iAmmo)
			end
		end
	end
end

function SWEP:Ammo1()
	return self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
end

function SWEP:Ammo2()
	return self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoType())
end

function SWEP:SetDeploySpeed()
	-- Do nothing! Change the deploy speed using the SWEP.Activities table
end

function SWEP:SetWeaponHoldType(sHold)
	self.HoldType = sHold:lower()
end
