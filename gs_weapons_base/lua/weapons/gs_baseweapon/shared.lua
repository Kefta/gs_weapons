-- FIXME: Splash effect doesn't show when scoped
-- FIXME: Smoke isn't removed

--- Base
-- This is the superclass
SWEP.Base = "gs_baseweapon"
SWEP.GSWeapon = true -- For hooks to know

--- Selection/Menu
SWEP.PrintName = "GSBase" -- Display name
SWEP.Author = "code_gs" -- This isn't used by default for weapon selection panels

SWEP.Spawnable = false -- Displays the weapon in the spawn menu. This must be defined in every weapon!
SWEP.AdminOnly = false -- Restricts weapon spawning to admin+

SWEP.Slot = 0 -- Key (minus one) to press to get to the weapon's category in the weapon selection 
SWEP.SlotPos = 0 -- Category in the weapon selection (minus one) this weapon appears in

--- Weapon demeanour
SWEP.ViewModel = "models/weapons/v_pistol.mdl" -- First-person model of the weapon
SWEP.CModel = "" -- C-model of the weapon. Used when gs_weapons_usecmodels is set to 1. Leave as an empty string for this convar to have no effect on the weapon
SWEP.ShouldIdle = true -- Play idle animations on the first view model
SWEP.UseHands = false -- If the gamemode supports it, show player model hands on the weapon (c_models only)

SWEP.ViewModel1 = "" -- Second first-person model: changing this to anything besides an empty string will display it
SWEP.CModel1 = ""
SWEP.ShouldIdle1 = true
SWEP.UseHands1 = false

SWEP.ViewModel2 = ""
SWEP.CModel2 = ""
SWEP.ShouldIdle2 = true
SWEP.UseHands2 = false

SWEP.WorldModel = "models/weapons/w_pistol.mdl" -- Third-person view of the weapon
SWEP.SilencerModel = "" -- World model to use when the weapon is silenced
SWEP.DroppedModel = "" -- World model to use when the weapon is dropped. Silencer model takes priotiy
SWEP.ReloadModel = "" -- World model to use during reload. Silencer model takes priority
SWEP.HoldType = "pistol" -- How the player should hold the weapon in third-person http://wiki.garrysmod.com/page/Hold_Types
SWEP.HolsterAnimation = true -- Play an animation when the weapon is being holstered. Only works if the weapon has a holster animation

SWEP.Weight = 0 -- Weight in automatic weapon selection
-- There are two weapon switching algorithms:
-- *Singleplay (true) - Switch to the weapon with the highest weight
-- *Multiplay (false) - Try and find a weapon with the same weight, otherwise, fallback to highest
SWEP.HighWeightPriority = false

SWEP.Activities = {-- Default activity events
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
	shoot = ACT_VM_PRIMARYATTACK,
	burst = ACT_VM_PRIMARYATTACK,
	shoot_empty = ACT_VM_DRYFIRE, -- Used when the last bullet in the clip is fired
	altfire = ACT_VM_SECONDARYATTACK,
	silence = ACT_VM_ATTACH_SILENCER,
	reload = ACT_VM_RELOAD,
	reload_empty = ACT_VM_RELOAD_EMPTY, -- Used when the weapon is reloaded with an empty clip
	empty = ACT_INVALID, -- Used when the weapon fires with no ammo in the clip
	draw = ACT_VM_DRAW,
	draw_empty = ACT_VM_DRAW_EMPTY,
	holster = ACT_VM_HOLSTER,
	holster_empty = ACT_VM_HOLSTER_EMPTY,
	idle = ACT_VM_IDLE,
	idle_empty = ACT_VM_IDLE_EMPTY,
	pump = ACT_SHOTGUN_PUMP,
	-- For silencers. If a silenced activity isn't available, the weapon will fallback to the non-silenced version
	s_shoot = ACT_VM_PRIMARYATTACK_SILENCED,
	s_shoot_empty = ACT_VM_DRYFIRE_SILENCED,
	s_silence = ACT_VM_DETACH_SILENCER,
	s_reload = ACT_VM_RELOAD_SILENCED,
	s_draw = ACT_VM_DRAW_SILENCED,
	s_idle = ACT_VM_IDLE_SILENCED,
	-- For single reloading
	reload_start = ACT_SHOTGUN_RELOAD_START,
	reload_finish = ACT_SHOTGUN_RELOAD_FINISH,
	-- For melee weapons
	hit = ACT_VM_HITCENTER,
	hit_alt = ACT_VM_HITCENTER2,
	miss = ACT_VM_MISSCENTER,
	miss_alt = ACT_VM_MISSCENTER2,
	-- For grenades
	pullback = ACT_VM_PULLBACK_HIGH,
	throw = ACT_VM_THROW,
	-- For deployed weapons
	deploy = ACT_VM_DEPLOY,
	deploy_empty = ACT_VM_DEPLOY_EMPTY,
	d_deploy = ACT_VM_UNDEPLOY,
	d_deploy_empty = ACT_VM_UNDEPLOY_EMPTY,
	d_draw = ACT_VM_DRAW_DEPLOYED,
	d_shoot = ACT_VM_PRIMARYATTACK_DEPLOYED,
	d_reload = ACT_VM_RELOAD_DEPLOYED,
	d_idle = ACT_VM_IDLE_DEPLOYED,
	d_idle_empty = ACT_VM_IDLE_DEPLOYED_EMPTY,
	-- For burst
	b_shoot = ACT_VM_PRIMARYATTACK
}

SWEP.Sounds = {-- Default sound events. If a sound isn't available, nothing will play
	--event = "Sound.Scape",
	--[[event2 = {
		pitch = {50, 100},
		sound = "sound2.wav"
	},
	event3 = {
		"sound3.wav", -- Sound to use for the first viewmodel
		nil, -- The second viewmodel will not play any sound for this event
		{-- Sound to use for the third viewmodel
			pitch = {10, 100},
			sound = "Sound.Scape2"
		}
	},]]
	draw = "",
	shoot = "Weapon_Pistol.Single",
	altfire = "",
	silence = "",
	zoom = "",
	reload = "Weapon_Pistol.Reload",
	empty = "Weapon_Pistol.Empty",
	holster = "",
	pump = "",
	-- For silencers
	s_draw = "",
	s_shoot = "Weapon_USP.SilencedShot",
	s_altfire = "",
	s_silence = "",
	s_reload = "",
	s_empty = "",
	s_holster = "",
	-- For single reloading
	reload_start = "",
	reload_finish = "",
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
	Deduction = 1, -- Ammo deducted per shot
	Damage = 42, -- Bullet/melee damage // Douglas Adams 1952 - 2001
	Force = 1, -- Force scale of shot/swing
	Range = MAX_TRACE_LENGTH, -- Bullet/melee distance
	Cooldown = 0.15, -- Time between firing
	WalkSpeed = 1, -- Walk speed multiplier to use when the weapon is deployed
	RunSpeed = 1, -- Run speed multiplier to use when the weapon is deployed
	FireUnderwater = true, -- Allows firing underwater
	FireInAir = true, -- Allows firing while off the ground
	InterruptReload = false, -- Allows interrupting a reload to shoot
	AutoReloadOnEmpty = true, -- Automatically reload if the clip is empty and the mouse is not being held
	ReloadOnEmptyFire = false, -- Reload if the weapon is fired with an empty clip
	Spread = vector_origin, -- Bullet spread vector
	SpreadBias = 0.5, -- Amount of variance on the spread. Between -1 and 1
	TracerFreq = 2, -- How often the tracer effect should show - (1 / SWEP.TracerFreq) frequency
	TracerName = "Tracer", -- Tracer effect to use
	Delay = -1 -- Delay for melee attack
}

SWEP.Secondary = {
	Ammo = "",
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Bullets = -1, -- -1 = disabled. Change for this variable to be returned by the accessor when bSecondary (SpecialActive by default) is true
	Deduction = -1,
	Damage = -1,
	Force = -1,
	Range = -1,
	Cooldown = -1,
	WalkSpeed = -1,
	RunSpeed = -1,
	FireUnderwater = true,
	FireInAir = true,
	InterruptReload = false,
	AutoReloadOnEmpty = false,
	ReloadOnEmptyFire = false,
	Spread = -1,
	TracerFreq = -1,
	TracerName = -1,
	Delay = -1
}

SWEP.SingleReload = {
	Enable = false,  // True if this weapon reloads 1 round at a time (shotguns)
	QueuedFire = true, -- Queue a primary/secondary fire to activate once the next bullet is put in the chamber
	InitialRound = true -- Give round for the first reload (HL2) or subsequent reloads only (CS:S)
}

SWEP.Burst = {
	Times = {-- Times between burst shots
		0.1, -- Time until first extra shot
		--0.1 -- Time until second extra shot; leave nil to fallback to the previous specified time
	},
	Count = 2, -- Number of extra shots to fire when burst is enabled
	Cooldown = 0.3, -- Cooldown between toggling bursts
	SingleActivity = false -- Only play the initial shooting activity during burst firing
}

SWEP.Zoom = {
	FOV = {-- FOV for each zoom level
		55 -- FOV for first zoom level
	},
	Times = {-- Times betweeen zoom levels
		Fire = 0.1, -- Time to unzoom after firing
		Rezoom = 0.05, -- Time to rezoom after unzooming from fire
		Holster = 0, -- Time to unzoom after holstering
		[0] = 0.15, -- Time to loop back to no zoom
		0.2 -- Time to reach the first zoom level; leave nil to fallback to the zoom time in index 0
	},
	Levels = 1, -- Number of zoom levels
	Cooldown = 0.3, -- Cooldown between zooming
	UnzoomOnFire = false, -- Unzoom when the weapon is fired; rezooms after Primary/Secondary cooldown if the clip is not 0
	UnzoomOnReload = true, -- Unzoom when the weapon is reloaded
	HideViewModel = false, -- Hide view model when zoomed
	FireDuringZoom = true, -- Allow fire during zoom/unzoom
	PlayIdle = true -- Play idle animations in zoom
}

SWEP.IronSights = {
	Times = {
		1 -- Time it takes for the first viewmodel to zoom in
		-- Second and third viewmodels fallback to first time
	},
	Pos = {
		vector_origin -- Local position offset for ironsights to reach
	},
	Ang = {
		angle_zero -- Local angular roation for ironsights to reach
	},
	Hold = false, -- Require secondary fire key to be held to use IronSights as opposed to just toggling the state
	FireInZoom = false, -- Allow fire during zoom/unzoom
	PlayIdle = false -- Play idle animations while enabled
}

SWEP.Grenade = {
	Delay = -1, -- Set to -1 to disable any delay. 0 is 1 tick delay. The length of delay until the grenade is thrown
	UpdateHoldType = true -- Update the holdtype to "normal" when out of grenades
}

SWEP.Melee = {
	DotRange = 0.70721, -- Max dot product for a hull trace to hit. Not sure about this constant, but it's close to 1/sqrt(2)
	HullRadius = 1.732, -- Test amount of the forward vector for the end point oof the hull trace. sqrt(3)
	TestHull = Vector(16, 16, 16), -- Test hull mins/maxs
	DamageType = DMG_CLUB, -- Melee damage type
	Mask = MASK_SHOT_HULL, -- Mask to use for melee trace
	StrictTrace = false -- Do not re-trace if there's a delay to the smack
}

SWEP.BipodDeploy = {
	-- The names for the min/max pitch are mixed up in the engine
	MinPitch = -60,
	MaxPitch = 45,
	MaxYaw = 45,
	Delta = 5,
	MaxHeightDifference = 20,
	DownTrace = 16,
	ForwardTrace = 32,
	StepSize = 4,
	TraceAttempts = 4,
	BoxSize = 1,
	MinDeployHeight = 24,
	CheckTime = 0.2,
	ForceUndeployPenalty = 0.1
}

SWEP.DoPump = false -- Do a pump animation after shooting
SWEP.CheckClip1ForSecondary = false -- Check/remove ammo from Clip1 when secondary firing

SWEP.AutoSwitchFrom = true -- Allows auto-switching away from the weapon. This is only checked for engine switching and is ignored by the base when AutoSwitchOnEmpty is true
SWEP.AutoSwitchTo = true -- Allows auto-switching to this weapon
SWEP.AutoSwitchOnEmpty = false -- Automatically switch away if the weapon is completely empty and the mouse is not being held. Ignores AutoSwitchFrom
SWEP.SwitchOnEmptyFire = false -- Switch away if the weapon is fired with no ammo
SWEP.RemoveOnEmpty = false -- Remove the weapon when it runs out of ammo
SWEP.BlockDeployOnEmpty = false -- Block deploying the weapon if it has no ammo

SWEP.UnderwaterCooldown = 0.2 --  Time between empty sound if the weapon cannot fire underwater. Set to -1 to only play once per mouse press
SWEP.EmptyCooldown = -1 -- Time between empty sounds. Set to -1 to only play once per mouse press
SWEP.HolsterReloadTime = -1 -- How long it should take for the weapon to reload if the player holsters during a reload. Set to -1 to cancel all reload activity on holster

SWEP.MaxShots = 15 -- Number of shots to clamp the ShotsFired incrementer to when the mouse is lifted
SWEP.ShotDecreaseTime = 0.0225 -- (CS:S crosshair) How fast the shot count should decrease per shot
SWEP.ShotInitialDecreaseTime = 0.4 -- (CS:S crosshair) How long until the shot decrement starts after the mouse is lifter

SWEP.TriggerBoundSize = 36 -- Trigger box size to pickup the weapon off the ground. Set to -1 to disable pickup. // Bloat the box for player pickup

--SWEP.m_WeaponDeploySpeed = 1 -- Do NOT use this, the deploy animation will be cut short by the idle animation! Instead, set the "rate" key in the SWEP.Activities.deploy table

local bSinglePlayer = game.SinglePlayer()
local bRun = SERVER or not bSinglePlayer
local ENTITY = FindMetaTable("Entity")
local sFormatOne = "%s_%s"
local sFormatTwo = "%s_%s_%s"

--- Spawn/Constructor
local sm_tPrecached = {} -- Persists through all weapon instances - acts like static keyword in C++

function SWEP:Initialize()
	local sClass = self:GetClass()
	code_gs.DevMsg(2, sClass .. " (gs_baseweapon) Initialize")
	
	if (not self.FireFunction) then
		self.FireFunction = ENTITY.FireBullets -- Fire function to use with Shoot. Args are (pPlayer, tFireBulletsInfo)
	end
	
	--[[if (not self.PunchDecayFunction) then
		self.PunchDecayFunction = nil -- Function to decay the punch angle manually. Args are (pPlayer, aPunchAngle). nil goes to default decaying
	end]]
	
	self.m_bAutoSwitchFrom = self.AutoSwitchFrom
	self.m_bInitialized = true
	self:SetupPredictedVar("m_bHolsterAnim", false)
	self:SetupPredictedVar("m_bLowered", false)
	self.m_bUpdateLowerHoldType = false
	self.m_bUpdateThrowHoldType = false
	self.m_flDeployYawStart = 0
	self.m_flDeployYawLeft = 0
	self.m_flDeployYawRight = 0
	self.m_sHoldType = self.HoldType
	self.m_sViewModel = self.ViewModel
	self.m_sViewModel1 = self.ViewModel1
	self.m_sViewModel2 = self.ViewModel2
	self.m_sWorldModel = self.WorldModel
	self.m_tEvents = {}
	self.m_tEventHoles = {}
	self.m_tRemovalQueue = {}
	
	if (bRun) then
		self.m_bActiveNoAmmo = false
		self.m_bDeployCrouched = false
		self.m_bSwitched = false
		self.m_flDeployHeight = 0
		self.m_flDeployTime = 0
		self.m_vDeployPos = vector_origin
		self.m_pDeployEntity = NULL
		self.m_pSwitchWeapon = NULL
		self.m_tDryFire = {[0] = false, false, false}
		--self.m_tSimulateHolsterAnim = {[0] = {false, 0, 0}, {false, 0, 0}, {false, 0, 0}}
		self.m_tUseViewModel = {[0] = false, false, false}
	end
	
	self:ResetHoldType()
	
	-- If it was created silenced, make it appear that way
	self:UpdateVariables()
	
	if (self.TriggerBoundSize == -1) then
		self:UseTriggerBounds(false, 0)
	else
		self:UseTriggerBounds(true, self.TriggerBoundSize)
	end
	
	if (CLIENT) then
		self:SetupPredictedVar("m_bActive", false)
		
		-- 0 = At rest, zoomed out
		-- 1 = Zooming in
		-- 2 = At rest, zoomed in
		-- 3 = Zooming out
		self.m_iIronSightsState0 = 0
		self.m_iIronSightsState1 = 0
		self.m_iIronSightsState2 = 0
		
		-- For CS:S crosshair
		self.m_iAmmoLastCheck = 0
		self.m_flCrosshairDistance = 0
	end
	
	if (not sm_tPrecached[sClass]) then
		self:Precache()
	end
end

function SWEP:Precache()
	local sClass = self:GetClass()
	sm_tPrecached[sClass] = true
	
	local tWeapon = weapons.GetStored(sClass)
	code_gs.DevMsg(2, sClass .. " (gs_baseweapon) Precache")
	
	if (CLIENT and self.KillIcon ~= '') then
		-- Add KillIcon
		killicon.AddFont(sClass, self.KillIconFont, self.KillIcon, self.KillIconColor)
	end
	
	-- Precache all weapon models
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.CModel)
	util.PrecacheModel(self.ViewModel1)
	util.PrecacheModel(self.CModel1)
	util.PrecacheModel(self.ViewModel2)
	util.PrecacheModel(self.CModel2)
	util.PrecacheModel(self.m_sWorldModel)
	util.PrecacheModel(self.SilencerModel)
	util.PrecacheModel(self.DroppedModel)
	util.PrecacheModel(self.ReloadModel)
	
	-- Setup and precache all weapon sounds
	for k, s in pairs(self.Sounds) do
		if (k ~= "BaseClass") then -- Stupid pseudo-inheritance
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
					
					sound.Add(s)
					self.Sounds[k] = s.name
					tWeapon.Sounds[k] = s.name
					util.PrecacheSound(s.name)
				else
					local sName = s.name or sClass .. "." .. k
					local bAdded = false
					local tDefault
					
					for i = 1, 3 do
						local Sub = s[i]
						
						if (Sub) then
							bAdded = true
							
							if (istable(Sub)) then
								local sNewName = sName .. i
								
								if (Sub.name) then
									-- Register the preset name, but the weapon won't use it
									sound.Add(Sub)
								end
								
								Sub.name = sNewName
								sound.Add(Sub)
								util.PrecacheSound(sNewName)
								
								if (not tDefault) then
									tDefault = Sub
								end
							elseif (string.IsSoundFile(Sub)) then
								local sNewName = sName .. i
								local tSound = {
									name = sNewName,
									channel = CHAN_WEAPON,
									sound = Sub
								}
								
								if (not tDefault) then
									tDefault = tSound
								end
								
								sound.Add(tSound)
								util.PrecacheSound(sNewName)
							else
								local tNewSound = sound.GetProperties(Sub)
								
								if (tNewSound) then
									local sNewName = sName .. i
									tNewSound.name = sNewName
									sound.Add(tNewSound)
									util.PrecacheSound(sNewName)
									
									if (not tDefault) then
										tDefault = tNewSound
									end
								elseif (tDefault) then
									local sNewName = sName .. i
									tDefault.name = sNewName
									sound.Add(tDefault)
									util.PrecacheSound(sNewName)
								end
							end
						elseif (tDefault) then
							tDefault.name = sName .. i
							sound.Add(tDefault)
							util.PrecacheSound(tDefault.name)
						end
					end
					
					sName = bAdded and sName .. "%d" or ""
					self.Sounds[k] = sName
					tWeapon.Sounds[k] = sName
				end
			-- Create a new sound table from a file
			elseif (string.IsSoundFile(s)) then
				local sName = sClass .. "." .. k
				
				sound.Add({
					name = sName,
					channel = CHAN_WEAPON,
					sound = s
				})
				
				util.PrecacheSound(sName)
				self.Sounds[k] = sName
				
				if (not tWeapon.Sounds) then
					tWeapon.Sounds = {}
				end
				
				tWeapon.Sounds[k] = sName
			-- Assume the sound table already exists
			else
				util.PrecacheSound(s)
			end
		end
	end
end

function SWEP:SetupDataTables()
	self:AddNWVar("Bool", "Active", false) -- To manage clientside deploying
	self:AddNWVar("Int", "Burst")
	self:AddNWVar("Int", "Deployed")
	self:AddNWVar("Int", "IronSights")
	self:AddNWVar("Int", "ShotsFired")
	self:AddNWVar("Int", "ShouldThrow")
	self:AddNWVar("Int", "Silenced")
	self:AddNWVar("Int", "ZoomLevel")
	self:AddNWVar("Float", "LastShootTime")
	self:AddNWVar("Float", "NextDeployCheck")
	self:AddNWVar("Float", "NextIdle")
	self:AddNWVar("Float", "NextIdle1")
	self:AddNWVar("Float", "NextIdle2")
	self:AddNWVar("Float", "NextItemFrame")
	self:AddNWVar("Float", "NextReload")
	self:AddNWVar("Float", "ReduceShotTime")
	self:AddNWVar("Float", "ZoomActiveTime")
	self:AddNWVar("Float", "ZoomActiveTime1")
	self:AddNWVar("Float", "ZoomActiveTime2")
	
	-- Below are the default CNetworkVars in the engine for reference
	--self:AddNWVar("Entity", "Owner")
	--self:AddNWVar("Float", "NextPrimaryAttack")
	--self:AddNWVar("Float", "NextSecondaryAttack")
	--self:AddNWVar("Int", "ViewModelIndex")
	--self:AddNWVar("Int", "WorldModelIndex")
	--self:AddNWVar("Int", "State")
	--self:AddNWVar("Int", "PrimaryAmmoType")
	--self:AddNWVar("Int", "SecondaryAmmoType")
	--self:AddNWVar("Int", "Clip1")
	--self:AddNWVar("Int", "Clip2")
end

--- Deploy
function SWEP:CanDeploy()
	return true
end

function SWEP:Deploy()
	local pPlayer = self:GetOwner()
	
	// Dead men deploy no weapons
	if (pPlayer == NULL or not pPlayer:Alive()) then
		return false
	end
	
	if (not self:HasAmmo()) then
		if (self.RemoveOnEmpty) then
			if (SERVER) then
				self:Remove()
			end
			
			return false
		end
		
		if (self.BlockDeployOnEmpty) then
			return false
		end
	end
	
	-- Do not deploy again
	if (self.dt.Active and (SERVER or self:GetPredictedVar("m_bActive"))) then
		return true
	end
	
	if (self:CanDeploy()) then
		self:SharedDeploy(false)
		
		return true
	end
	
	code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Deploy invalid", self:GetClass()) .. (IsFirstTimePredicted() and "" or " (predicted)"))
	
	return false
end

function SWEP:SharedDeploy(bDelayed)
	-- Clientside does not initialize sometimes
	if (self.m_bInitialized) then
		self:UpdateVariables()
		self:ResetHoldType()
	else
		self:Initialize()
	end
	
	code_gs.DevMsg(2, self:GetClass() .. " (gs_baseweapon) Deploy" .. ((bSinglePlayer or IsFirstTimePredicted()) and (bDelayed and " late" or "") or " (predicted)"))
	
	local pPlayer = self:GetOwner()
	local flCurTime = CurTime()
	
	if (CLIENT) then
		self:SetPredictedVar("m_bActive", true, bSinglePlayer) -- Delayed version is ran by Think, so it's still in prediction
		
		-- In-case the client wasn't holstered
		table.Empty(self.m_tEvents)
		table.Empty(self.m_tEventHoles)
		table.Empty(self.m_tRemovalQueue)
	end
	
	if (bRun) then
		self.m_bActiveNoAmmo = not self:HasAmmo()
		self.m_bSwitched = false
		
		local iIndex = -self:GetShouldThrow() - 1
		
		if (not (iIndex == -1 or pPlayer:GetAmmoCount(self:GetGrenadeAmmoName()) == 0)) then
			iIndex = -1
			
			if (not bDelayed) then
				self:SetShouldThrow(0)
			end
		end
		
		local bPlayed = false
		local pHideModel
			
		-- Wait for all viewmodels to deploy
		local flSequenceDuration = 0
		
		if (self.ViewModel == "") then
			self.m_tUseViewModel[0] = false
			self.m_tDryFire[0] = false
		else
			local pViewModel = pPlayer:GetViewModel(0)
			
			if (pViewModel == NULL) then
				self.m_tUseViewModel[0] = false
				self.m_tDryFire[0] = false
			else
				self.m_tUseViewModel[0] = true
				pViewModel:SetSkin(self:GetViewModelSkin(0))
				
				if (not bDelayed) then
					if (iIndex == 0) then
						pHideModel = pViewModel
					else
						self:PlaySound("draw", 0)
						bPlayed = true
						
						if (self:PlayActivity("draw", 0)) then
							flSequenceDuration = self:SequenceLength(0)
						end
					end
				end
				
				local iActivity = self:LookupActivity(self:GetDryfireActivity(0), 0)
				self.m_tDryFire[0] = not (iActivity == ACT_INVALID or pViewModel:SelectWeightedSequence(iActivity) == -1)
			end
		end
		
		if (self.ViewModel1 == "") then
			self.m_tUseViewModel[1] = false
			self.m_tDryFire[1] = false
		else
			local pViewModel = pPlayer:GetViewModel(1)
			
			if (pViewModel == NULL) then
				self.m_tUseViewModel[1] = false
				self.m_tDryFire[1] = false
			else
				self.m_tUseViewModel[1] = true
				pViewModel:SetSkin(self:GetViewModelSkin(1))
				
				if (not bDelayed) then
					pViewModel:SetWeaponModel(self.ViewModel1, self)
					
					if (iIndex == 1) then
						pHideModel = pViewModel
					else
						if (not (self:PlaySound("draw", 1, true) or bPlayed)) then
							self:PlaySound("draw", 0)
							bPlayed = true
						end
						
						if (self:PlayActivity("draw", 1)) then
							flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(1))
						end
					end
				end
				
				local iActivity = self:LookupActivity(self:GetDryfireActivity(1), 1)
				self.m_tDryFire[1] = not (iActivity == ACT_INVALID or pViewModel:SelectWeightedSequence(iActivity) == -1)
			end
		end
			
		if (self.ViewModel2 == "") then
			self.m_tUseViewModel[2] = false
			self.m_tDryFire[2] = false
		else
			local pViewModel = pPlayer:GetViewModel(2)
			
			if (pViewModel == NULL) then
				self.m_tUseViewModel[2] = false
				self.m_tDryFire[2] = false
			else
				self.m_tUseViewModel[2] = true
				pViewModel:SetSkin(self:GetViewModelSkin(2))
				
				if (not bDelayed) then
					pViewModel:SetWeaponModel(self.ViewModel2, self)
					
					if (iIndex == 2) then
						pHideModel = pViewModel
					else
						if (not (self:PlaySound("draw", 2, true) or bPlayed)) then
							self:PlaySound("draw", 0)
							bPlayed = true
						end
						
						if (self:PlayActivity("draw", 2)) then
							flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(2))
						end
					end
				end
				
				local iActivity = self:LookupActivity(self:GetDryfireActivity(2), 2)
				self.m_tDryFire[2] = not (iActivity == ACT_INVALID or pViewModel:SelectWeightedSequence(iActivity) == -1)
			end
		end
		
		if (iIndex ~= -1) then
			pHideModel:SetVisible(false)
			
			self:AddEvent("reload_grenade", 0, function()
				if (pPlayer:GetAmmoCount(self:GetGrenadeAmmoName()) ~= 0) then
					self:SetShouldThrow(0)
					local flNewTime
					
					if (pHideModel == NULL) then
						flNewTime = CurTime()
					else
						flNewTime = CurTime() + (self:PlayActivity("draw", iIndex) and self:SequenceLength(iIndex) or 0)
						pHideModel:SetVisible(true)
						self:PlaySound("draw", iIndex)
					end
					
					self:SetNextPrimaryFire(flNewTime)
					self:SetNextSecondaryFire(flNewTime)
					self:SetNextReload(flNewTime)
					
					return true
				end
			end)
		end
		
		if (not bDelayed) then
			self.dt.Active = true
			self:SetZoomLevel(0)
			self:SetDeployed(0)
			self:SetReduceShotTime(0)
			self:SetShotsFired(0)
			
			pPlayer:SetFOV(0, 0)
			
			// Can't shoot again until we've finished deploying
			flSequenceDuration = flSequenceDuration + flCurTime
			self:SetNextPrimaryFire(flSequenceDuration)
			self:SetNextSecondaryFire(flSequenceDuration)
			self:SetNextReload(flSequenceDuration)
		end
	end
end

--- Holster/Remove
function SWEP:CanHolster()
	return self:GetDeployed() == 0
end

function SWEP:Holster(pSwitchingTo)
	if (self.RemoveOnEmpty and not self:HasAmmo()) then
		if (SERVER) then
			self:Remove()
		end
		
		return true
	end
	
	-- Do not holster again
	-- https://github.com/Facepunch/garrysmod-issues/issues/2854
	if (SERVER and not self.dt.Active) then
		return true
	end
	
	local pPlayer = self:GetOwner()
	local bIsValid = pPlayer ~= NULL
	
	-- Holster is called when the player dies with it active but nothing should be done
	-- Player:Alive() will return true on the frame the death occured but the health will be less than or equal to 0
	if (bIsValid and (pPlayer:Health() < 1 or not pPlayer:Alive())) then
		return true
	end
	
	if (pSwitchingTo == self) then
		if (CLIENT and not self:GetPredictedVar("m_bActive", true)) then
			return true
		end
		
		if (self:CanHolster(pSwitchingTo)) then
			if (self.HolsterAnimation) then
				if (self:GetPredictedVar("m_bHolsterAnim", true)) then
					return self:GetNextItemFrame() <= CurTime()
				end
				
				return false
			end
			
			return true
		end
		
		return false
	end
	
	-- If we are switching to NULL (picked up an object) don't play an animation
	if (self.HolsterAnimation and bIsValid and pSwitchingTo ~= NULL and pPlayer:GetCurrentCommand()) then
		if (not self:GetPredictedVar("m_bHolsterAnim")) then
			if (self:CanHolster(pSwitchingTo)) then
				self:HolsterAnim(pSwitchingTo, false)
				
				if (SERVER) then
					-- Run this clientside to reset the viewmodels and set the variables for a full holster
					if (bSinglePlayer) then
						net.Start("GS-Weapons-Holster animation")
							net.WriteEntity(self)
							net.WriteEntity(pSwitchingTo)
						net.Send(pPlayer)
					else
						-- Give the client a chance to holster themselves
						timer.Create("GS-Weapons-Holster animation-" .. self:EntIndex(), 0, 1, function()
							if (not (self == NULL or pPlayer == NULL) and self:GetOwner() == pPlayer) then
								net.Start("GS-Weapons-Holster animation")
									net.WriteEntity(self)
									net.WriteEntity(pSwitchingTo)
								net.Send(pPlayer)
							end
						end)
					end
				end
			end
			
			return false
		end
			
		if (self:GetNextItemFrame() > CurTime()) then
			return false
		end
	end
	
	if (self:CanHolster(pSwitchingTo)) then
		self:SharedHolster(pSwitchingTo, false)
		
		if (SERVER) then
			-- Clientside does not run Holster in single-player
			if (bSinglePlayer) then
				net.Start("GS-Weapons-Holster")
					net.WriteEntity(self)
					net.WriteEntity(pSwitchingTo)
				net.Send(pPlayer)
			else
				timer.Create("GS-Weapons-Holster-" .. self:EntIndex(), 0, 1, function()
					if (not (self == NULL or pPlayer == NULL) and self:GetOwner() == pPlayer) then
						net.Start("GS-Weapons-Holster")
							net.WriteEntity(self)
							net.WriteEntity(pSwitchingTo)
						net.Send(pPlayer)
					end
				end)
			end
		end
		
		return true
	end
		
	code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Holster invalid to %s", self:GetClass(), tostring(pSwitchingTo)) .. (IsFirstTimePredicted() and "" or " (predicted)"))
	
	return false
end

function SWEP:HolsterAnim(pSwitchingTo, bDelayed)
	code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Holster animation to %s", self:GetClass(), tostring(pSwitchingTo)) .. (bDelayed and " late" or IsFirstTimePredicted() and "" or " (predicted)"))
	
	self:SetPredictedVar("m_bHolsterAnim", true, bDelayed)
	local pPlayer = self:GetOwner()
	
	if (bRun) then
		self.m_pSwitchWeapon = pSwitchingTo
		
		if (IsFirstTimePredicted() or bDelayed) then
			if (self.HolsterReloadTime ~= -1 and self:EventActive("reload")) then
				-- If self is NULL in the hook, there's no way to retrieve what EntIndex it had
				local sName = "GS-Weapons-Holster reload-" .. self:EntIndex()
				local flReloadTime
				local bDidReload = false
				
				hook.Add("Think", sName, function()
					if (bDidReload and IsFirstTimePredicted()) then
						hook.Remove("Think", sName)
					elseif (self == NULL or pPlayer == NULL) then
						hook.Remove("Think", sName)
					elseif (not self:IsActiveWeapon()) then
						if (flReloadTime) then
							if (CurTime() >= flReloadTime) then
								local iMaxClip = self:GetMaxClip1()
								
								if (iMaxClip ~= -1) then
									local iClip = self:Clip1()
									local sAmmoType = self:GetPrimaryAmmoName()
									local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(sAmmoType))
									self:SetClip1(iClip + iAmmo)
									pPlayer:RemoveAmmo(iAmmo, sAmmoType)
								end
								
								iMaxClip = self:GetMaxClip2()
								
								// If I use secondary clips, reload secondary
								if (iMaxClip ~= -1) then
									local iClip = self:Clip2()
									local sAmmoType = self:GetSecondaryAmmoName()
									local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(sAmmoType))
									self:SetClip2(iClip + iAmmo)
									pPlayer:RemoveAmmo(iAmmo, sAmmoType)
								end
								
								self:FinishReload()
								bDidReload = true
							end
						else
							flReloadTime = CurTime() + self.HolsterReloadTime
						end
					end
				end)
			end
		end
		
		if (not bDelayed) then
			local iIndex = -self:GetShouldThrow() - 1
			local bPlayed = false
			
			-- Wait for all viewmodels to holster
			local flEndTime = 0
			local flCurTime = CurTime()
			
			if (self.m_tUseViewModel[0] and iIndex ~= 0) then
				self:PlaySound("holster", 0)
				bPlayed = true
				
				if (self:PlayActivity("holster", 0)) then
					flEndTime = self:SequenceLength(0)
				--[[elseif (self:PlayActivity("draw", 0)) then
					flEndTime = self:SequenceLength(0)
					
					local tbl = self.m_tSimulateHolsterAnim[0]
					tbl[1] = true
					tbl[2] = flCurTime
					tbl[3] = flEndTime
					
					-- Guaranteed to be valid
					pPlayer:GetViewModel(0):SetCycle(1)]]
				end
			end
			
			if (self.m_tUseViewModel[1] and iIndex ~= 1) then
				if (not (self:PlaySound("holster", 1, true) or bPlayed)) then
					self:PlaySound("holster", 0)
					bPlayed = true
				end
				
				if (self:PlayActivity("holster", 1)) then
					flEndTime = math.max(flEndTime, self:SequenceLength(1))
				--[[elseif (self:PlayActivity("draw", 1)) then
					local flSeqDur = self:SequenceLength(1)
					flEndTime = math.max(flEndTime, flSeqDur)
					
					local tbl = self.m_tSimulateHolsterAnim[1]
					tbl[1] = true
					tbl[2] = flCurTime
					tbl[3] = flSeqDur
					
					pPlayer:GetViewModel(1):SetCycle(1)]]
				end
			end
				
			if (self.m_tUseViewModel[2] and iIndex ~= 2) then
				if (not (self:PlaySound("holster", 2, true) or bPlayed)) then
					self:PlaySound("holster", 0)
					bPlayed = true
				end
				
				if (self:PlayActivity("holster", 2)) then
					flEndTime = math.max(flEndTime, self:SequenceLength(2))
				--[[elseif (self:PlayActivity("draw", 2)) then
					local flSeqDur = self:SequenceLength(2)
					flEndTime = math.max(flEndTime, flSeqDur)
					
					local tbl = self.m_tSimulateHolsterAnim[2]
					tbl[1] = true
					tbl[2] = flCurTime
					tbl[3] = flSeqDur
					
					pPlayer:GetViewModel(2):SetCycle(1)]]
				end
			end
			
			self:SetZoomLevel(0)
			self:SetDeployed(0)
			
			-- Disable all events during Holster animation
			self:SetNextPrimaryFire(-1)
			self:SetNextSecondaryFire(-1)
			self:SetNextReload(-1)
			self:SetNextItemFrame(flCurTime + flEndTime)
		end
	end
	
	-- https://github.com/Facepunch/garrysmod-requests/issues/739
	table.Empty(self.m_tEvents)
	table.Empty(self.m_tEventHoles)
	table.Empty(self.m_tRemovalQueue)
end

function SWEP:SharedHolster(pSwitchingTo, bDelayed)	
	code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Holster to %s", self:GetClass(), tostring(pSwitchingTo)) .. (bDelayed and " late" or IsFirstTimePredicted() and "" or " (predicted)"))
	
	local pPlayer = self:GetOwner()
	local bIsValid = pPlayer ~= NULL
	local bNoAnim = not self.HolsterAnimation
	self:SetPredictedVar("m_bHolsterAnim", false, bDelayed)
	self:SetPredictedVar("m_bLowered", false, bDelayed)
	
	if (CLIENT) then
		self:SetPredictedVar("m_bActive", false, bDelayed)
	end
	
	if (bRun) then
		--local tbl = self.m_tSimulateHolsterAnim
		--tbl[0][1] = false
		--tbl[1][1] = false
		--tbl[2][1] = false
		
		self.m_tUseViewModel[0] = false
		self.m_tUseViewModel[1] = false
		self.m_tUseViewModel[2] = false
		
		if (bNoAnim) then
			self:SetZoomLevel(0)
			self:SetDeployed(0)
			
			-- Disable all actions during holster
			self:SetNextPrimaryFire(-1)
			self:SetNextSecondaryFire(-1)
			self:SetNextReload(-1)
			-- FIXME: Change this to a variable
			if (bIsValid and self.HolsterReloadTime ~= -1 and self:EventActive("reload")) then
				-- If self is NULL in the hook, there's no way to retrieve what EntIndex it had
				local sName = "GS-Weapons-Holster reload-" .. self:EntIndex()
				local flReloadTime
				local bDidReload = false
			
				hook.Add("Think", sName, function()
					if (bDidReload and IsFirstTimePredicted()) then
						hook.Remove("Think", sName)
					elseif (self == NULL or pPlayer == NULL) then
						hook.Remove("Think", sName)
					elseif (not self:IsActiveWeapon()) then
						if (flReloadTime) then
							if (CurTime() >= flReloadTime) then
								local iMaxClip = self:GetMaxClip1()
								
								if (iMaxClip ~= -1) then
									local iClip = self:Clip1()
									local sAmmoType = self:GetPrimaryAmmoName()
									local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(sAmmoType))
									self:SetClip1(iClip + iAmmo)
									pPlayer:RemoveAmmo(iAmmo, sAmmoType)
								end
								
								iMaxClip = self:GetMaxClip2()
								
								// If I use secondary clips, reload secondary
								if (iMaxClip ~= -1) then
									local iClip = self:Clip2()
									local sAmmoType = self:GetSecondaryAmmoName()
									local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(sAmmoType))
									self:SetClip2(iClip + iAmmo)
									pPlayer:RemoveAmmo(iAmmo, sAmmoType)
								end
								
								self:FinishReload()
								bDidReload = true
							end
						else
							flReloadTime = CurTime() + self.HolsterReloadTime
						end
					end
				end)
			end
		end
		
		if (not bDelayed) then
			self.dt.Active = false
			self:SetNextIdle(-1)
			self:SetNextIdle1(-1)
			self:SetNextIdle2(-1)
			
			if (bIsValid) then
				pPlayer:SetFOV(0, self.Zoom.Times.Holster) // reset the default FOV
				local iIndex = -self:GetShouldThrow() - 1
				local bPlayed = false
				
				if (bNoAnim and iIndex ~= 0) then
					self:PlaySound("holster", 0)
					bPlayed = true
				end
				
				if (self.m_tUseViewModel[1]) then
					if (bNoAnim and not (iIndex == 1 or self:PlaySound("holster", 1, true) or bPlayed)) then
						self:PlaySound("holster", 0)
						bPlayed = true
					end
					
					local pViewModel = pPlayer:GetViewModel(1)
					
					if (pViewModel ~= NULL) then
						pViewModel:SetWeaponModel("")
					end
				end
				
				if (self.m_tUseViewModel[2]) then
					if (bNoAnim and not (iIndex == 2 or self:PlaySound("holster", 2, true) or bPlayed)) then
						self:PlaySound("holster", 0)
						bPlayed = true
					end
					
					local pViewModel = pPlayer:GetViewModel(2)
					
					if (pViewModel ~= NULL) then
						pViewModel:SetWeaponModel("")
					end
				end
			end
		end
	end
	
	-- These are already set if there was a holster animation
	if (bNoAnim) then
		-- https://github.com/Facepunch/garrysmod-requests/issues/739
		table.Empty(self.m_tEvents)
		table.Empty(self.m_tEventHoles)
		table.Empty(self.m_tRemovalQueue)
	end
end

function SWEP:OnRemove()
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		code_gs.DevMsg(2, self:GetClass() .. " (gs_baseweapon) Remove invalid")
	else
		if (bRun) then
			pPlayer:SetFOV(0, self.Zoom.Times.Holster) // reset the default FOV
			
			-- Hide the extra viewmodels
			if (self.m_tUseViewModel[1]) then
				local pViewModel = pPlayer:GetViewModel(1)
				
				if (pViewModel ~= NULL) then
					pViewModel:SetWeaponModel("")
				end
			end
			
			if (self.m_tUseViewModel[2]) then
				local pViewModel = pPlayer:GetViewModel(2)
				
				if (pViewModel ~= NULL) then
					pViewModel:SetWeaponModel("")
				end
			end
		end
		
		if (pPlayer:Health() > 0 and pPlayer:Alive() and self:IsActiveWeapon()) then
			-- The weapon was removed while it was active and the player was alive, so find a new one
			local pWeapon = pPlayer:GetNextBestWeapon(self.HighWeightPriority, true)
			
			if (bRun) then
				pPlayer:SwitchWeapon(pWeapon)
			end
			
			code_gs.DevMsg(2, string.format("%s (gs_baseweapon) Remove to %s", self:GetClass(), tostring(pWeapon)))
		else
			code_gs.DevMsg(2, self:GetClass() .. " (gs_baseweapon) Remove invalid")
		end
	end
end

--- Think/Idle
function SWEP:CanIdle(iIndex --[[= 0]])
	if (not self.Zoom.PlayIdle and self:GetZoomLevel() > 0) then
		return false
	end
	
	if (not self.IronSights.PlayIdle and self:IronSightsEnabled(iIndex or 0)) then
		return false
	end
	
	local flNextIdle
	
	if (iIndex == 1) then
		if (not self.ShouldIdle1 or self.ViewModel1 == "") then
			return false
		end
		
		flNextIdle = self:GetNextIdle1()
	elseif (iIndex == 2) then
		if (not self.ShouldIdle2 or self.ViewModel2 == "") then
			return false
		end
		
		flNextIdle = self:GetNextIdle2()
	else
		if (not self.ShouldIdle or self.ViewModel == "") then
			return false
		end
		
		flNextIdle = self:GetNextIdle()
	end
	
	return flNextIdle ~= -1 and flNextIdle <= CurTime()
end

function SWEP:Think()
	self:UpdateVariables()
	
	if (CLIENT) then
		if (self.dt.Active) then
			if (not self:GetPredictedVar("m_bActive")) then
				-- For clientside deployment in single-player or by use of Player:SelectWeapon()
				self:SharedDeploy(true)
			end
		elseif (self:GetPredictedVar("m_bActive")) then
			self:SetPredictedVar("m_bActive", false)
			assert(false, "Holstered thru think!")
		end
	end
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		return
	end
	
	if (self:GetPredictedVar("m_bHolsterAnim")) then
		if (bRun) then
			--[[local flCurTime = CurTime()
			local tbl = self.m_tSimulateHolsterAnim[0]
			
			if (tbl[1]) then
				local pViewModel = pPlayer:GetViewModel(0)
				
				if (pViewModel ~= NULL) then
					pViewModel:SetCycle(math.max(0, 1 - (flCurTime - tbl[2]) / tbl[3]))
				end
			end
			
			tbl = self.m_tSimulateHolsterAnim[1]
			
			if (tbl[1]) then
				local pViewModel = pPlayer:GetViewModel(1)
				
				if (pViewModel ~= NULL) then
					pViewModel:SetCycle(math.max(0, 1 - (flCurTime - tbl[2]) / tbl[3]))
				end
			end
			
			tbl = self.m_tSimulateHolsterAnim[2]
			
			if (tbl[1]) then
				local pViewModel = pPlayer:GetViewModel(2)
				
				if (pViewModel ~= NULL) then
					pViewModel:SetCycle(math.max(0, 1 - (flCurTime - tbl[2]) / tbl[3]))
				end
			end]]
			
			if (not self.m_bSwitched and IsFirstTimePredicted() and self:GetNextItemFrame() <= CurTime()) then
				if (self.m_pSwitchWeapon == NULL) then -- Weapon disappeared; find a new one or come back to the same weapon
					pPlayer:SwitchWeapon(pPlayer:GetNextBestWeapon(self.HighWeightPriority))
				else -- Weapon being swapped to is still on the player
					pPlayer:SwitchWeapon(self.m_pSwitchWeapon)
				end
				
				self.m_bSwitched = true
			end
		end
		
		return
	end
	
	if (not self.dt.Active) then
		return
	end
	
	local bFirstTimePredicted = IsFirstTimePredicted()
	
	-- Events are removed one Think after they mark themselves as complete to maintain clientside prediction
	if (bFirstTimePredicted) then
		for key, _ in pairs(self.m_tRemovalQueue) do
			self.m_tRemovalQueue[key] = nil
			self.m_tEvents[key] = nil
			
			if (isnumber(key)) then
				self.m_tEventHoles[key] = true
			end
		end
	end
	
	-- Events have priority over main think function
	local flCurTime = CurTime()
	
	for key, tbl in pairs(self.m_tEvents) do
		-- Only start running on the first prediction time
		if (bFirstTimePredicted) then
			self.m_tEvents[key][4] = true
		elseif (not self.m_tEvents[key][4]) then
			continue
		end
		
		-- -1 is an event that counts as active but never ran
		if (tbl[1] ~= -1) then
			if (tbl[2] <= flCurTime) then
				local RetVal = tbl[3]()
				
				if (RetVal == true) then
					self.m_tRemovalQueue[key] = true
				else
					-- Update interval
					if (isnumber(RetVal)) then
						tbl[1] = RetVal
					end
					
					tbl[2] = flCurTime + tbl[1]
				end
			end
		end
	end
	
	if (not (pPlayer:KeyDown(IN_ATTACK) or pPlayer:KeyDown(IN_ATTACK2))) then
		self:MouseLifted()
	end
	
	local flNextThink = self:GetNextItemFrame()
	
	if (not (flNextThink == -1 or flNextThink > flCurTime)) then
		self:ItemFrame()
	end
	
	if (bRun) then
		local iIndex = self:GetDeployed() - 1
		
		if (iIndex ~= -1) then
			local flNextCheck = self:GetNextDeployCheck()
			
			if (not (flNextCheck == -1 or flNextCheck > flCurTime)) then
				if (self:ShouldUndeploy() and self:ToggleDeploy(iIndex)) then
					self:RemoveEvent("reload")
					self:SetNextReload(0)
					
					if (bSinglePlayer) then
						net.Start("GS-Weapons-Finish reload")
						net.Send(pPlayer)
					end
					
					local flEndTime = flCurTime + self.BipodDeploy.ForceUndeployPenalty
					self:SetNextPrimaryFire(flEndTime)
					self:SetNextSecondaryFire(flEndTime)
					self:SetNextReload(flEndTime)
				end
				
				self:SetNextDeployCheck(flCurTime + self.BipodDeploy.CheckTime)
			end
		end
		
		if (self:CanIdle(0)) then
			self:PlayActivity("idle", 0, nil, true, self.m_tDryFire[0] and self:GetActivitySuffix(0) == "empty")
		end
		
		if (self:CanIdle(1)) then
			self:PlayActivity("idle", 1, nil, true, self.m_tDryFire[1] and self:GetActivitySuffix(1) == "empty")
		end
		
		if (self:CanIdle(2)) then
			self:PlayActivity("idle", 2, nil, true, self.m_tDryFire[2] and self:GetActivitySuffix(2) == "empty")
		end
	end
end

local gs_weapons_usecmodels = GetConVar("gs_weapons_usecmodels")

function SWEP:UpdateVariables()
	local bUseCModel = gs_weapons_usecmodels:GetBool()
	
	if (self.CModel ~= "") then
		if (bUseCModel) then
			self.ViewModel = self.CModel
			self.UseHands = true
		else
			self.ViewModel = self.m_sViewModel
			self.UseHands = false
		end
	end
	
	if (self.CModel1 ~= "") then
		if (bUseCModel) then
			self.ViewModel1 = self.CModel1
			self.UseHands1 = true
		else
			self.ViewModel1 = self.m_sViewModel1
			self.UseHands1 = false
		end
	end
	
	if (self.CModel2 ~= "") then
		if (bUseCModel) then
			self.ViewModel2 = self.CModel2
			self.UseHands2 = true
		else
			self.ViewModel2 = self.m_sViewModel2
			self.UseHands2 = false
		end
	end
	
	self.WorldModel = self.m_sWorldModel
	local iWorldIndex = self:GetWorldModelIndex()
	
	-- Silencer has first priority
	if (self.SilencerModel ~= "" and self:Silenced(iWorldIndex)) then
		self.WorldModel = self.SilencerModel
	elseif (self.DroppedModel ~= "" and self:GetOwner() == NULL) then
		self.WorldModel = self.DroppedModel
	elseif (self.ReloadModel ~= "" and self:EventActive("reload")) then
		self.WorldModel = self.ReloadModel
	end
	
	local iThrow = self:GetShouldThrow()
	
	if (iThrow > 0) then
		self.AutoSwitchFrom = false
		
		if (self.m_bUpdateThrowHoldType and self.Grenade.UpdateHoldType) then
			self.m_bUpdateThrowHoldType = false
			self:ResetHoldType()
		end
	elseif (iThrow ~= 0) then
		if (iThrow == -(iWorldIndex + 1)) then
			self.WorldModel = ""
		end
		
		self.AutoSwitchFrom = self.m_bAutoSwitchFrom
		
		if (self.Grenade.UpdateHoldType and self:GetHoldType() ~= "normal") then
			self.m_bUpdateThrowHoldType = true
			self:SetHoldType("normal")
		end
	else
		self.AutoSwitchFrom = self.m_bAutoSwitchFrom
		
		if (self.m_bUpdateThrowHoldType and self.Grenade.UpdateHoldType) then
			self.m_bUpdateThrowHoldType = false
			self:ResetHoldType()
		end
	end
	
	if (self:GetPredictedVar("m_bLowered", true) and self:GetHoldType() ~= "normal") then
		self.m_bUpdateLowerHoldType = true
		self:SetHoldType("normal")
	elseif (self.m_bUpdateLowerHoldType) then
		self:ResetHoldType()
	end
end

function SWEP:MouseLifted()
	if (not bRun) then
		return
	end
	
	local pPlayer = self:GetOwner()
	local flCurTime = CurTime()
	local iThrow = self:GetShouldThrow()
	
	if (iThrow > 0) then
		self:SetShouldThrow(0)
		local iIndex = math.floor(iThrow / code_gs.weapons.GRENADE_COUNT)
		
		pPlayer:SetAnimation(PLAYER_ATTACK1)
		
		local flDelay = self.Grenade.Delay
		
		if (flDelay == -1) then
			self:SetLastShootTime(flCurTime)
			self:EmitGrenade(iThrow % code_gs.weapons.GRENADE_COUNT)
			self:PlaySound("throw", iIndex)
			pPlayer:RemoveAmmo(1, self:GetGrenadeAmmoName())
		else
			self:AddEvent("throw", flDelay, function()
				self:SetLastShootTime(CurTime())
				self:EmitGrenade(iThrow % code_gs.weapons.GRENADE_COUNT)
				self:PlaySound("throw", iIndex)
				pPlayer:RemoveAmmo(1, self:GetGrenadeAmmoName())
				
				return true
			end)
		end
		
		local flTime = 0
		
		if (self:PlayActivity("throw", iIndex)) then
			flTime = self:SequenceLength(iIndex)
			
			if (flTime < flDelay) then
				flTime = flDelay
			end
		end
		
		self:AddEvent("reload_grenade", flTime, function()
			-- This must be run AFTER throw
			if (self:EventActive("throw")) then
				return 0
			end
			
			if (pPlayer:GetAmmoCount(self:GetGrenadeAmmoName()) == 0) then
				if (self.RemoveOnEmpty) then
					if (SERVER) then
						self:Remove()
					end
				else
					local pViewModel = pPlayer:GetViewModel(iIndex)
					local bIsValid = pViewModel ~= NULL
					
					if (bIsValid) then
						pViewModel:SetVisible(false)
					end
					
					self:SetShouldThrow(-iIndex - 1)
					
					self:AddEvent("draw", 0, function()
						if (pPlayer:GetAmmoCount(self:GetGrenadeAmmoName()) ~= 0) then
							if (bIsValid) then
								pViewModel:SetVisible(true)
							end
							
							self:SetShouldThrow(0)
							
							self:PlaySound("draw", iIndex)
							local flNewTime = CurTime() + (self:PlayActivity("draw", iIndex) and self:SequenceLength(iIndex) or 0)
							self:SetNextPrimaryFire(flNewTime)
							self:SetNextSecondaryFire(flNewTime)
							self:SetNextReload(flNewTime)
							
							return true
						end
					end)
				end
			else
				local flNewTime = CurTime() + (self:PlayActivity("draw", iIndex) and self:SequenceLength(iIndex) or 0)
				self:SetNextPrimaryFire(flNewTime)
				self:SetNextSecondaryFire(flNewTime)
				self:SetNextReload(flNewTime)
			end
			
			return true
		end)
	end
	
	-- Just ran out of ammo and the mouse has been lifted, so switch away
	if (self.AutoSwitchOnEmpty and not self.m_bActiveNoAmmo and not self:HasAmmo()) then
		pPlayer:SwitchWeapon(pPlayer:GetNextBestWeapon(self.HighWeightPriority))
	-- Reload is still called serverside only in single-player
	elseif (self:Clip1() == 0 and self.Primary.AutoReloadOnEmpty or self:Clip2() == 0 and self.Secondary.AutoReloadOnEmpty) then
		self:Reload()
	end

	if (not self:EventActive("burst")) then
		// The following code prevents the player from tapping the firebutton repeatedly 
		// to simulate full auto and retaining the single shot accuracy of single fire
		local iShotsFired = self:GetShotsFired()
		local flShotTime = self:GetReduceShotTime()
		
		if (flShotTime == -1) then
			if (iShotsFired > self.MaxShots) then
				self:SetShotsFired(self.MaxShots)
			end
			
			self:SetReduceShotTime(flCurTime + self.ShotInitialDecreaseTime)
		elseif (iShotsFired ~= 0) then
			if (flShotTime < flCurTime) then
				self:SetShotsFired(iShotsFired - 1)
				self:SetReduceShotTime(flCurTime + self.ShotDecreaseTime)
			end
		end
	end
end

-- Normal think function replacement
function SWEP:ItemFrame()
end
-- FIXME: Add queued reloading and check out secondary fire behaviour
--- Attack
function SWEP:CanPrimaryAttack(iIndex)
	if (self:EventActive("fire") or self:GetNextPrimaryFire() == -1) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	-- Make sure player is at least valid for the methods below
	if (pPlayer == NULL) then
		return false
	end
	
	local iWaterLevel = pPlayer:WaterLevel()
	
	if (iWaterLevel == 0 and not (self.Primary.FireInAir or pPlayer:OnGround())) then
		return false
	end
	
	local iClip = self:Clip1()
	local bEmpty
	
	if (iClip == -1) then
		if (self:GetDefaultClip1() == -1) then
			bEmpty = false
		else
			bEmpty = pPlayer:GetAmmoCount(self:GetPrimaryAmmoName()) == 0
		end
	else
		bEmpty = iClip == 0
	end
	
	-- In the middle of a reload
	if (self:EventActive("reload")) then
		if (bEmpty) then
			return false
		end
		
		if (self.SingleReload.Enable and self.SingleReload.QueuedFire) then
			-- FIXME: Use first available ammo or SequenceEnd
			self:AddEvent("fire", self:SequenceEnd(iIndex), function()
				self:PrimaryAttack()
				self:RemoveEvent("reload")
				self:SetNextReload(0)
				
				if (bSinglePlayer) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				return true
			end)
			
			return false
		end
		
		-- Interrupt the reload to fire
		if (not self.Primary.InterruptReload or not self.Primary.FireUnderwater and iWaterLevel == 3) then
			return false
		end
		
		-- Stop the reload
		self:RemoveEvent("reload")
		self:SetNextReload(0)
		
		if (bSinglePlayer) then
			net.Start("GS-Weapons-Finish reload")
			net.Send(pPlayer)
		end
	end
	
	-- By default, clip has priority over water
	if (bEmpty) then
		self:HandleFireOnEmpty(false, iIndex)
		
		return false
	end
	
	if (not self.Primary.FireUnderwater and iWaterLevel == 3) then
		self:HandleFireUnderwater(false, iIndex)
		
		return false
	end
	
	return true
end

-- Will only be called serverside in single-player
function SWEP:PrimaryAttack()	
	if (self:CanPrimaryAttack(0)) then
		self:Shoot(self:SpecialActive(0), 0)
		
		return true
	end
	
	return false
end

function SWEP:CanSecondaryAttack(bSecondary, iIndex)
	if (self:EventActive("fire") or self:GetNextSecondaryFire() == -1) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		return false
	end
	
	local iWaterLevel = pPlayer:WaterLevel()
	
	if (iWaterLevel == 0 and not (self.Secondary.FireInAir or pPlayer:OnGround())) then
		return false
	end
	
	local iClip = self.CheckClip1ForSecondary and self:Clip1() or self:Clip2()
	local bEmpty
	
	if (iClip == -1) then
		if (self:GetDefaultClip2() == -1) then
			bEmpty = false
		else
			bEmpty = pPlayer:GetAmmoCount(self.CheckClip1ForSecondary and self:GetPrimaryAmmoName() or self:GetSecondaryAmmoName()) == 0
		end
	else
		bEmpty = iClip == 0
	end
	
	if (self:EventActive("reload")) then
		if (bEmpty) then
			return false
		end
		
		if (self.SingleReload.Enable and self.SingleReload.QueuedFire) then
			self:AddEvent("fire", self:SequenceEnd(iIndex), function()
				self:SecondaryAttack()
				self:RemoveEvent("reload")
				self:SetNextReload(0)
				
				if (bSinglePlayer) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				return true
			end)
			
			return false
		end
		
		if (not self.Secondary.InterruptReload or not self.Secondary.FireUnderwater and iWaterLevel == 3) then
			return false
		end
		
		self:RemoveEvent("reload")
		self:SetNextReload(0)
		
		if (bSinglePlayer) then
			net.Start("GS-Weapons-Finish reload")
			net.Send(pPlayer)
		end
	end
	
	if (bEmpty) then
		self:HandleFireOnEmpty(true, iIndex)
		
		return false
	end
	
	if (not self.Secondary.FireUnderwater and iWaterLevel == 3) then
		self:HandleFireUnderwater(true, iIndex)
		
		return false
	end
	
	return true
end

function SWEP:SecondaryAttack()
end

function SWEP:GetShootClip(bSecondary --[[= false]])
	return self:Clip1()
end

function SWEP:GetWorldModelIndex()
	return 0
end

function SWEP:SetShootClip(iClip, bSecondary)
	self:SetClip1(iClip)
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	if (not iIndex) then
		iIndex = 0
	end
	
	local iClipDeduction = self:GetSpecialKey("Deduction", bSecondary)
	local iClip = self:GetShootClip(bSecondary)
	local bDeductClip = iClip ~= -1
	
	-- Check just in-case the weapon's CanPrimary/SecondaryAttack doesn't check properly
	-- Do NOT let the clip overflow
	if (bDeductClip and iClipDeduction > iClip) then
		error(self:GetClass() .. " (gs_baseweapon) Clip overflowed in Shoot! Add check to CanPrimary/SecondaryAttack")
	end
	
	local tbl = self:GetShootInfo(bSecondary)
	local bBurst = self:BurstEnabled(iIndex) and (not bDeductClip or iClip >= iClipDeduction * 2)
	local flCooldown = self:GetSpecialKey("Cooldown", bSecondary)
	local pPlayer = self:GetOwner()
	
	if (bDeductClip) then
		iClip = iClip - iClipDeduction
		self:SetShootClip(iClip, bSecondary)
	end
	
	if (bBurst) then
		local tBurst = self.Burst
		local tTimes = tBurst.Times
		local flLastTime = tTimes[1]
		local iCount = tBurst.Count
		local iCurCount = 1
		
		self:AddEvent("burst", flLastTime, function()
			if (bDeductClip) then
				iClip = iClip - iClipDeduction
				self:SetShootClip(iClip, bSecondary)
			end
			
			self:SetShotsFired(self:GetShotsFired() + 1)
			self:UpdateBurstShotTable(tbl, bSecondary)
			
			self:PlaySound("shoot", iIndex)
			
			local bActivity = self:ShootEffects(true, iIndex, true)
			local flCurTime = CurTime()
			self:SetLastShootTime(flCurTime)
			self.FireFunction(pPlayer, tbl)
			
			if (iCurCount == iCount or bDeductClip and iClip < iClipDeduction) then
				if (self.DoPump) then
					self:SetNextPrimaryFire(-1)
					self:SetNextSecondaryFire(-1)
					self:SetNextReload(-1)
					self:SetReduceShotTime(-1)
					
					self:AddEvent("pump", bActivity and self:SequenceLength(iIndex) or 0, function() 
						self:PlaySound("pump", iIndex)
						
						-- Cooldown is sequence based
						local flNextTime = CurTime() + (self:PlayActivity("pump", iIndex) and self:SequenceLength(iIndex) or 0)
						self:SetNextPrimaryFire(flNextTime)
						self:SetNextSecondaryFire(flNextTime)
						self:SetNextReload(flNextTime)
						
						return true
					end)
				else
					local flNewTime = flCurTime + flCooldown
					self:SetNextPrimaryFire(flNewTime)
					self:SetNextSecondaryFire(flNewTime)
					self:SetNextReload(flNewTime)
					self:SetReduceShotTime(-1)
				end
				
				return true
			end
			
			iCurCount = iCurCount + 1
			flLastTime = tTimes[iCurCount] or flLastTime
			
			return flLastTime
		end)
	else
		self:SetReduceShotTime(-1)
		
		local tZoom = self.Zoom
		
		if (tZoom.UnzoomOnFire) then
			local iLevel = self:GetZoomLevel()
			
			if (iLevel ~= 0) then
				self:SetZoomLevel(0) -- Disable scope overlay
				pPlayer:SetFOV(0, tZoom.Times.Fire)
				
				if (tZoom.HideViewModel) then
					if (self.m_tUseViewModel[0]) then
						local pViewModel = pPlayer:GetViewModel(0)
						pViewModel:SetVisible(true)
					end
					
					if (self.m_tUseViewModel[1]) then
						local pViewModel = pPlayer:GetViewModel(1)
						pViewModel:SetVisible(true)
					end
						
					if (self.m_tUseViewModel[2]) then
						local pViewModel = pPlayer:GetViewModel(2)
						pViewModel:SetVisible(true)
					end
				end
				
				-- Don't rezoom if the clip is empty
				if (iClip ~= 0) then
					self:AddEvent("rezoom", flCooldown, function()
						local flRezoom = tZoom.Times.Rezoom
						self:SetZoomActiveTime(flRezoom)
						self:SetZoomLevel(iLevel)
						self:SetNextSecondaryFire(flRezoom)
						pPlayer:SetFOV(tZoom.FOV[iLevel], flRezoom)
						
						if (not tZoom.FireDuringZoom) then
							self:SetNextPrimaryFire(flRezoom)
						end
						
						if (tZoom.HideViewModel) then
							local pPlayer = self:GetOwner()
							
							if (self.m_tUseViewModel[0]) then
								local pViewModel = pPlayer:GetViewModel(0)
								pViewModel:SetVisible(false)
							end
								
							if (self.m_tUseViewModel[1]) then
								local pViewModel = pPlayer:GetViewModel(1)
								pViewModel:SetVisible(false)
							end
								
							if (self.m_tUseViewModel[2]) then
								local pViewModel = pPlayer:GetViewModel(2)
								pViewModel:SetVisible(false)
							end
						end
						
						return true
					end)
				end
			end
		end
	end
	
	self:SetShotsFired(self:GetShotsFired() + 1)
	
	self:PlaySound("shoot", iIndex)
	
	local bActivity = self:ShootEffects(bSecondary, iIndex, false)
	local flCurTime = CurTime()
	self:SetLastShootTime(flCurTime)
	
	-- The zoom level needs to be set before PlayActivity but the times need to be set after
	-- So do two seperate burst blocks
	if (bBurst or self.DoPump) then
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
	else
		local flNextTime = flCurTime + flCooldown
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
		self:SetNextReload(flNextTime)
	end
	
	self.FireFunction(pPlayer, tbl)
	
	if (not bBurst and self.DoPump) then
		self:AddEvent("pump", bActivity and self:SequenceLength(iIndex) or 0, function() 
			self:PlaySound("pump", iIndex)
			
			-- Cooldown is sequence based
			local flNextTime = CurTime() + (self:PlayActivity("pump", iIndex) and self:SequenceLength(iIndex) or 0)
			self:SetNextPrimaryFire(flNextTime)
			self:SetNextSecondaryFire(flNextTime)
			self:SetNextReload(flNextTime)
			
			return true
		end)
	end
	
	if (self:GetDeployed() == iIndex + 1 and self.m_pDeployEntity:IsPlayer()) then
		self.m_pDeployEntity:SetDSP(32, false)
	end
	
	self:Punch(bSecondary)
	
	return bActivity
end

-- weapon_base compatibility
function SWEP:ShootBullet(flDamage, flNum, flSpread, iIndex)
	-- SUPER-DUPER HACK but I don't want to copy and paste a bunch of code
	local fGetShotTable = self.GetShootInfo
	self.GetShootInfo = function(self, bSecondary)
		local tbl = fGetShotTable(self, bSecondary)
		tbl.Damage = flDamage
		tbl.Num = flNum
		tbl.Spread = Vector(flSpread, flSpread)
	end
	
	self:Shoot(self:SpecialActive(iIndex or 0), iIndex)
	
	self.GetShootInfo = fGetShotTable
end

function SWEP:ShootEffects(bSecondary, iIndex --[[= 0]], bInBurst --[[= false]])
	self:DoMuzzleFlash(iIndex)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	
	if (bInBurst and self.Burst.SingleActivity) then
		return false
	end
	
	local iClip = self:GetShootClip(bSecondary)
	
	return self:PlayActivity((bInBurst or self:BurstEnabled(iIndex) and (iClip == -1 or iClip >= self:GetSpecialKey("Deduction", bSecondary))) and "burst" or "shoot", iIndex)
end

function SWEP:UpdateBurstShotTable(tbl, bSecondary)
	tbl.Dir = self:GetShootDir(bSecondary)
	tbl.ShootAngles = self:GetShootAngles(bSecondary)
	tbl.Src = self:GetShootSrc(bSecondary)
end

function SWEP:Throw(iType --[[= code_gs.weapons.GRENADE_THROW]], iIndex --[[= 0]])
	if (not iIndex) then
		iIndex = 0
	end
	
	-- Complicated way to condense the throw data into one DTVar
	self:SetShouldThrow((iType or code_gs.weapons.GRENADE_THROW) + code_gs.weapons.GRENADE_COUNT * iIndex)
		
	self:PlaySound("pullback", iIndex)
	local bActivity = self:PlayActivity("pullback", iIndex)
	
	self:SetNextPrimaryFire(-1)
	self:SetNextSecondaryFire(-1)
	self:SetNextReload(-1)
	self:SetNextIdle(-1)
	
	return bActivity
end

-- Shared for the HL1 grenade
function SWEP:EmitGrenade()
end

-- FIXME: Check all of this
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
		
		if (not (tr.Fraction == 1 or tr.Entity == NULL)) then
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

function SWEP:Swing(bSecondary, iIndex)
	local pPlayer = self:GetOwner()
	pPlayer:LagCompensation(true)
	
	local tMelee = self.Melee
	local vSrc = self:GetShootSrc(bSecondary)
	local vForward = self:GetShootDir(bSecondary)
	
	local tbl = {
		start = vSrc,
		endpos = vSrc + vForward * self:GetSpecialKey("Range", bSecondary),
		mask = tMelee.Mask,
		filter = pPlayer
	}
	local tr = self:GetMeleeTrace(tbl, vForward)
	local flDelay = self:GetSpecialKey("Delay", bSecondary, vForward)
	local bActivity
	
	if (tr.Fraction == 1) then
		self:PlaySound("miss", iIndex)
		bActivity = self:PlayActivity(bSecondary and "miss_alt" or "miss", iIndex)
	else
		bActivity = self:PlayActivity(bSecondary and "hit_alt" or "hit", iIndex)
	end
	
	if (flDelay == -1) then
		self:Smack(tr, vForward, bSecondary, iIndex)
	else
		if (bActivity) then
			local pViewModel = pPlayer:GetViewModel(iIndex)
			local flRate = pViewModel:GetPlaybackRate()
			flDelay = flDelay / (flRate == 0 and 1 or flRate < 0 and -flRate or flRate)
		end 
		
		self:AddEvent("smack", flDelay, function()
			local bRetrace = not tMelee.StrictTrace -- FIXME
			
			if (bRetrace) then
				pPlayer:LagCompensation(true)
				
				local vSrc = self:GetShootSrc(bSecondary)
				local vForward = self:GetShootDir(bSecondary)
				
				tbl.start = vSrc
				tbl.endpos = vSrc + vForward * self:GetSpecialKey("Range", bSecondary)
				tbl.mask = tMelee.Mask
				tbl.filter = pPlayer
				tbl.output = tr
				
				self:GetMeleeTrace(tbl, vForward)
			end
			
			self:Smack(tr, vForward, bSecondary, iIndex)
			
			if (bRetrace) then
				pPlayer:LagCompensation(false)
			end
			
			return true
		end)
	end
	
	// Setup out next attack times
	local flCurTime = CurTime()
	local flCooldown = self:GetSpecialKey("Cooldown", bSecondary)
	self:SetLastShootTime(flCurTime)
	self:SetNextPrimaryFire(flCurTime + flCooldown)
	self:SetNextSecondaryFire(flCurTime + (bActivity and self:SequenceLength(iIndex) or flCooldown))
	
	pPlayer:LagCompensation(false)
	
	return bActivity
end

function SWEP:Smack(tr, vForward, bSecondary, iIndex)
	local tMelee = self.Melee
	local pPlayer = self:GetOwner()
	local vSrc = self:GetShootSrc(bSecondary)
	local tbl = {}
	
	local bFirstTimePredicted = IsFirstTimePredicted()
	local bNoWater = true
	
	if (bFirstTimePredicted) then
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
		
		if (trSplash and not self:DoSplashEffect(trSplash)) then
			local data = EffectData()
				data:SetOrigin(trSplash.HitPos)
				data:SetScale(8)
				
				if (bit.band(util.PointContents(trSplash.HitPos), CONTENTS_SLIME) ~= 0) then
					data:SetFlags(FX_WATER_IN_SLIME)
				end
				
			util.Effect("watersplash", data)
		end
	end
	
	// Send the anim
	pPlayer:SetAnimation(PLAYER_ATTACK1)
		
	if (tr.Fraction ~= 1) then
		self:PlaySound((tr.Entity:IsPlayer() or tr.Entity:IsNPC()) and "hit" or "hitworld", iIndex)
		self:SmackDamage(tr, vForward, bSecondary)
		
		if (bNoWater and not self.DoImpactEffect or not self:DoImpactEffect(tr, tMelee.DamageType) and bFirstTimePredicted) then
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
end

function SWEP:SmackDamage(tr, vForward, bSecondary)
	local flDamage = self:GetSpecialKey("Damage", bSecondary)
	local info = DamageInfo()
		info:SetAttacker(self:GetOwner())
		info:SetInflictor(self)
		info:SetDamage(flDamage)
		info:SetDamageType(self.Melee.DamageType)
		info:SetDamagePosition(tr.HitPos)
		info:SetReportedPosition(tr.StartPos)
		--info:SetDamageForce(vForward * info:GetBaseDamage() * self:GetSpecialKey("Force", bSecondary) * (1 / (flDamage < 1 and 1 or flDamage)) * phys_pushscale:GetFloat()) FIXME
	tr.Entity:DispatchTraceAttack(info, tr, vForward)
end

function SWEP:Silence(iIndex)
	self:PlaySound("silence", iIndex)
	local flNewTime = self:PlayActivity("silence", iIndex) and self:SequenceLength(iIndex) or 0
	
	self:AddEvent("silence", flNewTime, function()
		local iSilence = self:GetSilenced()
		iIndex = 2^iIndex
		self:SetSilenced(bit.band(iSilence, iIndex) == 0 and iSilence + iIndex or iSilence - iIndex)
		
		return true
	end)
	
	flNewTime = flNewTime + CurTime()
	self:SetNextPrimaryFire(flNewTime)
	self:SetNextSecondaryFire(flNewTime)
	self:SetNextReload(flNewTime)
end

function SWEP:ToggleBurst(iIndex)
	self:PlaySound("toggleburst", iIndex)
	self:PlayActivity("toggleburst", iIndex)
	self:SetNextSecondaryFire(CurTime() + self.Burst.Cooldown)
	
	local iBurst = self:GetBurst()
	iIndex = 2^iIndex
	
	local bNoBurst = bit.band(iBurst, iIndex) == 0
	self:SetBurst(bNoBurst and iBurst + iIndex or iBurst - iIndex)
	
	self:GetOwner():PrintMessage(HUD_PRINTCENTER, code_gs.GetPhrase(bNoBurst and "weapons_toburstfire" or "weapons_fromburstfire"))
end

-- Doesn't matter which viewmodel is zoomed in since no specific anims are assosiated with it
function SWEP:AdvanceZoom(iIndex)
	local tZoom = self.Zoom
	local iLevel = (self:GetZoomLevel() + 1) % (tZoom.Levels + 1)
	local iFOV = iLevel == 0 and 0 or tZoom.FOV[iLevel]
	local flTime = tZoom.Times[iLevel] or tZoom.Times[0]
	self:PlaySound("zoom", iIndex)
	
	if (iFOV and flTime) then
		self:SetZoomLevel(iLevel)
		
		local pPlayer = self:GetOwner()
		pPlayer:SetFOV(iFOV, flTime)
		
		-- Don't hide again if the VM is already hidden
		if (tZoom.HideViewModel and iLevel < 2) then
			local bVisible = iLevel == 0
			
			if (self.m_tUseViewModel[0]) then
				local pViewModel = pPlayer:GetViewModel(0)
				pViewModel:SetVisible(bVisible)
			end
				
			if (self.m_tUseViewModel[1]) then
				local pViewModel = pPlayer:GetViewModel(1)
				pViewModel:SetVisible(bVisible)
			end
				
			if (self.m_tUseViewModel[2]) then
				local pViewModel = pPlayer:GetViewModel(2)
				pViewModel:SetVisible(bVisible)
			end
		end
	else
		ErrorNoHalt(string.format("%s (gs_baseweapon) Zoom level or time %u not defined! Zooming out..", self:GetClass(), iLevel))
		self:SetZoomLevel(0)
		
		local pPlayer = self:GetOwner()
		pPlayer:SetFOV(0, 0)
		
		if (tZoom.HideViewModel) then
			if (self.m_tUseViewModel[0]) then
				local pViewModel = pPlayer:GetViewModel(0)
				pViewModel:SetVisible(true)
			end
				
			if (self.m_tUseViewModel[1]) then
				local pViewModel = pPlayer:GetViewModel(1)
				pViewModel:SetVisible(true)
			end
				
			if (self.m_tUseViewModel[2]) then
				local pViewModel = pPlayer:GetViewModel(2)
				pViewModel:SetVisible(true)
			end
		end
	end
	
	local flNextTime = CurTime()
	self:SetNextSecondaryFire(flNextTime + tZoom.Cooldown)
	
	flNextTime = flNextTime + flTime
	
	if (iIndex == 1) then
		self:SetZoomActiveTime1(flNextTime)
	elseif (iIndex == 2) then
		self:SetZoomActiveTime2(flNextTime)
	else
		self:SetZoomActiveTime(flNextTime)
	end
	
	if (not tZoom.FireDuringZoom) then
		self:SetNextPrimaryFire(flNextTime)
	end
end

function SWEP:ToggleIronSights(iIndex --[[= 0]])
	local flCurTime = CurTime()
	local iSights = self:GetIronSights()
	iIndex = 2^iIndex
	self:SetIronSights(bit.band(iSights, iIndex) == 0 and iSights + iIndex or iSights - iIndex)
	
	if (iIndex == 1) then
		local flTotalTime = self.IronSights.ZoomTime[2] or self.IronSights.ZoomTime[1]
		local flRemaining = flCurTime - self:GetZoomActiveTime1()
		self:SetZoomActiveTime1(flCurTime + (flRemaining < flTotalTime
			and flTotalTime - flReamining or flTotalTime))
	elseif (iIndex == 2) then
		local flTotalTime = self.IronSights.ZoomTime[3] or self.IronSights.ZoomTime[2] or self.IronSights.ZoomTime[1]
		local flRemaining = flCurTime - self:GetZoomActiveTime2()
		self:SetZoomActiveTime2(flCurTime + (flRemaining < flTotalTime
			and flTotalTime - flReamining or flTotalTime))
	else
		local flTotalTime = self.IronSights.ZoomTime[1]
		local flRemaining = flCurTime - self:GetZoomActiveTime()
		self:SetZoomActiveTime(flCurTime + (flRemaining < flTotalTime
			and flTotalTime - flReamining or flTotalTime))
	end
end

local function TestDeployAngle(vForward, vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, flStepSize, iAttempts, bDebug, tbl, tr)
	// sandbags are around 50 units high. Shouldn't be able to deploy on anything a lot higher than that

	// optimal standing height (for animation's sake) is around 42 units
	// optimal ducking height is around 20 units (20 unit high object, plus 8 units of gun)

	// Start one half box width away from the edge of the player hull
	local vForwardStart = vStart + vForward * flStartOffset
	
	tbl.start = vForwardStart
	tbl.endpos = vForwardStart + vForward * flMaxForwardDist
	util.TraceHull(tbl)
	
	if (bDebug) then
		debugoverlay.Line(vForwardStart, tbl.endpos, DEBUG_LENGTH, color_debug)
		debugoverlay.Box(vForwardStart, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_altdebug)
		debugoverlay.Box(tr.HitPos, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_debug)
	end
	
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
		
		if (bDebug) then
			debugoverlay.Line(vDownTraceStart, tr.HitPos, DEBUG_LENGTH, color_debug)
			debugoverlay.Box(vDownTraceStart, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_altdebug)
			debugoverlay.Box(tr.HitPos, tbl.mins, tbl.maxs, DEBUG_LENGTH, color_debug)
		end
		
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
	
	if (not bFound or pBestDeployEnt == NULL) then
		return false
	end
	
	return true, flHighestTraceEnd, pBestDeployEnt
end

local DEPLOY_DOWNTRACE_OFFSET = 16 // yay for magic numbers

function SWEP:TestDeploy(bDebug)
	local tDeploy = self.BipodDeploy
	
	-- Bound check
	if (bTestLimits and tDeploy.MaxYaw <= 0) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	-- Don't deploy in the air, underwater, or during a movement transition
	if (pPlayer:GetGroundEntity() == NULL) then
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
	
	local bDeployed = self:GetDeployed() ~= 0
	local pFilter
	
	if (bDeployed) then
		pFilter = player.GetAll()
		local pDeployedOn = self.m_pDeployEntity
		
		if (pDeployedOn:IsPlayer()) then
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
	
	if (bDeployed and self.m_bDeployCrouched or pPlayer:Crouching()) then
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
	local bSuccess, flDeployedHeight, pDeployedOn = TestDeployAngle(aEyes:Forward(), vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, tDeploy.StepSize, tDeploy.TraceAttempts, bDebug, tbl, tr)
	
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
		local bSuccess, flTestDeployHeight = TestDeployAngle(aEyes:Forward(), vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, tDeploy.StepSize, tDeploy.TraceAttempts, bDebug, tbl, tr)
		
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
		local bSuccess, flTestDeployHeight = TestDeployAngle(aEyes:Forward(), vStart, vTraceHeight, flStartOffset, flDownOffset, flMaxForwardDist, tDeploy.StepSize, tDeploy.TraceAttempts, bDebug, tbl, tr)
		
		// don't allow yaw to a position that is too different in height
		if (not bSuccess or math.abs(flDeployedHeight - flTestDeployHeight) > tDeploy.MaxHeightDifference) then
			break
		end
		
		flYawLimitRight = flRight
	end
	
	-- Eek, no references in Lua
	return true, flDeployedHeight - flHeightOffset, pDeployedOn, flYaw, flYawLimitLeft, -flYawLimitRight
end

function SWEP:ShouldUndeploy()
	local bSuccess, flDeployedHeight, pDeployedOn, flYaw, flYawLimitLeft, flYawLimitRight = self:TestDeploy(false)
	
	// If the entity we were deployed on has changed, or has moved, the origin
	// of it will be different. If so, recalc our yaw limits.
	if (bSuccess and math.abs(self.m_flDeployHeight - flDeployedHeight) <= self.BipodDeploy.MaxHeightDifference) then
		self.m_pDeployEntity = pDeployedOn
		local vNewPos = pDeployedOn:GetPos()
		
		if (self.m_vDeployPos ~= vNewPos) then
			self.m_vDeployPos = vNewPos
			self.m_flDeployYawLeft = flYawLimitLeft
			self.m_flDeployYawRight = flYawLimitRight
			
			if (bSinglePlayer) then
				net.Start("GS-Weapons-BipodDeploy")
					net.WriteDouble(flYawLimitLeft)
					net.WriteDouble(flYawLimitRight)
				net.Send(self:GetOwner())
			end
		end
		
		return false
	end
	
	return true
end

function SWEP:ToggleDeploy(iIndex)
	if (self:GetDeployed() == 0) then
		local pPlayer = self:GetOwner()
		local bSuccess, flDeployedHeight, pDeployedOn, flYaw, flYawLimitLeft, flYawLimitRight = self:TestDeploy(true)
		
		if (bSuccess) then
			local flEndTime = CurTime()
			
			self.m_flDeployHeight = flDeployedHeight
			self.m_pDeployEntity = pDeployedOn
			self.m_vDeployPos = pDeployedOn:GetPos()
			self.m_flDeployTime = flEndTime
			self.m_flDeployYawStart = flYaw
			self.m_flDeployYawLeft = flYawLimitLeft
			self.m_flDeployYawRight = flYawLimitRight
			
			// Save this off so we do duck checks later, even though we won't be flagged as ducking
			self.m_bDeployCrouched = pPlayer:Crouching()
			
			// More TODO:
			// recalc our yaw limits if the item we're deployed on has moved or rotated
			// if our new limits are outside our current eye angles, undeploy us
			flEndTime = flEndTime + (self:PlayActivity("deploy", iIndex) and self:SequenceLength(iIndex) or 0) 
			self:SetNextPrimaryFire(flEndTime)
			self:SetNextSecondaryFire(flEndTime)
			self:SetNextReload(flEndTime)
			
			self:SetDeployed((iIndex or 0) + 1)
			
			if (bSinglePlayer) then
				net.Start("GS-Weapons-BipodDeploy")
					net.WriteDouble(flYaw) -- No imprecisions
					net.WriteDouble(flYawLimitLeft)
					net.WriteDouble(flYawLimitRight)
				net.Send(pPlayer)
			end
		end
		
		return bSuccess
	end
	
	local flEndTime = CurTime() + (self:PlayActivity("deploy", iIndex) and self:SequenceLength(iIndex) or 0) 
	self:SetNextPrimaryFire(flEndTime)
	self:SetNextSecondaryFire(flEndTime)
	self:SetNextReload(flEndTime)
	
	self:SetDeployed(0)
	
	return true
end

-- Using this instead of Player:MuzzleFlash() allows all viewmodels to use muzzle flash
function SWEP:DoMuzzleFlash(iIndex)
	if (not self:Silenced(iIndex)) then
		--[[if (iIndex) then
			-- https://github.com/Facepunch/garrysmod-issues/issues/2552
			if (SERVER) then
				self:SetSaveValue("m_nMuzzleFlashParity", bit.band(self:GetInternalVariable("m_nMuzzleFlashParity") + 1, 3))
				
				local pPlayer = self:GetOwner()
				pPlayer:SetSaveValue("m_nMuzzleFlashParity", bit.band(pPlayer:GetInternalVariable("m_nMuzzleFlashParity") + 1, 3))
				
				local pViewModel = pPlayer:GetViewModel(iIndex)
				
				-- Always check if the viewmodel is valid
				if (pViewModel ~= NULL) then
					pViewModel:SetSaveValue("m_nMuzzleFlashParity", bit.band(pViewModel:GetInternalVariable("m_nMuzzleFlashParity") + 1, 3))
				end
			end
		else]]
			self:GetOwner():MuzzleFlash()
		--end
	end
end

function SWEP:Punch()
end

function SWEP:HandleFireOnEmpty(bSecondary --[[= false]], iIndex --[[= 0]])
	self:PlaySound("empty", iIndex)
	self:PlayActivity("empty", iIndex)
	
	local pPlayer = self:GetOwner()
	
	if (self.EmptyCooldown == -1) then
		if (bSecondary) then
			self:SetNextSecondaryFire(-1)
			
			self:AddEvent("empty_secondary", 0, function()
				if (not pPlayer:KeyDown(IN_ATTACK2) or (self.CheckClip1ForSecondary and self:Clip1() or self:Clip2()) ~= 0) then
					if (self:GetNextSecondaryFire() == -1) then
						self:SetNextSecondaryFire(0)
					end
					
					return true
				end
			end)
		else
			self:SetNextPrimaryFire(-1)
			
			self:AddEvent("empty_primary", 0, function()
				if (not pPlayer:KeyDown(IN_ATTACK) or self:Clip1() ~= 0) then
					if (self:GetNextPrimaryFire() == -1) then
						self:SetNextPrimaryFire(0)
					end
					
					return true
				end
			end)
		end
	else
		local flNextTime = CurTime() + self.EmptyCooldown
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
	end
	
	if (self.SwitchOnEmptyFire and not self:HasAmmo()) then
		pPlayer:SwitchWeapon(pPlayer:GetNextBestWeapon(self.HighWeightPriority))
	elseif (bSecondary and self.Secondary.ReloadOnEmptyFire or not bSecondary and self.Primary.ReloadOnEmptyFire) then
		self:SetNextReload(0)
		self:Reload()
	end
end

function SWEP:HandleFireUnderwater(bSecondary --[[= false]], iIndex --[[= 0]])
	self:PlaySound("empty", iIndex)
	self:PlayActivity("empty", iIndex)
	
	if (self.UnderwaterCooldown == -1) then
		local pPlayer = self:GetOwner()
		
		if (bSecondary) then
			self:SetNextSecondaryFire(-1)
			
			self:AddEvent("empty_secondary", 0, function()
				if (not pPlayer:KeyDown(IN_ATTACK2) or (self.CheckClip1ForSecondary and self:Clip1() or self:Clip2()) ~= 0) then
					if (self:GetNextSecondaryFire() == -1) then
						self:SetNextSecondaryFire(0)
					end
					
					return true
				end
			end)
		else
			self:SetNextPrimaryFire(-1)
			
			self:AddEvent("empty_primary", 0, function()
				if (not pPlayer:KeyDown(IN_ATTACK) or self:Clip1() ~= 0) then
					if (self:GetNextPrimaryFire() == -1) then
						self:SetNextPrimaryFire(0)
					end
					
					return true
				end
			end)
		end
	else
		local flNextTime = CurTime() + self.UnderwaterCooldown
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
	end
end

--- Reload
function SWEP:CanReload()
	local flNextReload = self:GetNextReload()
	
	if (flNextReload == -1 or flNextReload > CurTime()) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer == NULL) then
		return false
	end
	
	// If I don't have any spare ammo, I can't reload
	local iMaxClip1 = self:GetMaxClip1()
	
	-- Do not reload if both clips are already full
	if (iMaxClip1 == -1 or self:Clip1() == iMaxClip1 or pPlayer:GetAmmoCount(self:GetPrimaryAmmoName()) == 0) then
		local iMaxClip2 = self:GetMaxClip2()
		
		if (iMaxClip2 == -1 or self:Clip2() == iMaxClip2 or pPlayer:GetAmmoCount(self:GetSecondaryAmmoName()) == 0) then
			return false
		end
	end
	
	return true
end

-- Will only be called serverside in single-player
function SWEP:Reload()
	if (self:CanReload()) then
		self:ReloadClips()
		
		return true
	end
	
	return false
end

-- Not specifying an index will call ShouldReloadViewModel for all viewmodels
function SWEP:ReloadClips()
	local pPlayer = self:GetOwner()
	
	if (self.Zoom.UnzoomOnReload and self:GetZoomLevel() ~= 0) then
		self:SetZoomLevel(0)
		pPlayer:SetFOV(0, 0)
		
		if (self.Zoom.HideViewModel) then
			if (self.m_tUseViewModel[0]) then
				local pViewModel = pPlayer:GetViewModel(0)
				pViewModel:SetVisible(true)
			end
				
			if (self.m_tUseViewModel[1]) then
				local pViewModel = pPlayer:GetViewModel(1)
				pViewModel:SetVisible(true)
			end
				
			if (self.m_tUseViewModel[2]) then
				local pViewModel = pPlayer:GetViewModel(2)
				pViewModel:SetVisible(true)
			end
		end
	end
	
	local tSingleReload = self.SingleReload
	
	if (tSingleReload.Enable) then
		local iMaxClip1 = self:GetMaxClip1()
		local iMaxClip2 = self:GetMaxClip2()
		local sAmmo1
		local sAmmo2
		local iClip1
		local iClip2
		local iAmmoCount1
		local iAmmoCount2
		
		if (iMaxClip1 ~= -1) then
			sAmmo1 = self:GetPrimaryAmmoName()
			iClip1 = self:Clip1()
			iAmmoCount1 = pPlayer:GetAmmoCount(sAmmo1)
		end
		
		if (iMaxClip2 ~= -1) then
			sAmmo2 = self:GetSecondaryAmmoName()
			iClip2 = self:Clip2()
			iAmmoCount2 = pPlayer:GetAmmoCount(sAmmo2)
		end
		
		// Play the player's reload animation
		--pPlayer:SetAnimation(PLAYERANIMEVENT_RELOAD)
		
		local bVM0 = false
		local bVM1 = false
		local bVM2 = false
		local flSequenceDuration = 0
		local flFinishTime = 0
		
		if (self.m_tUseViewModel[0] and self:ShouldReloadViewModel(0)) then
			self:PlaySound("reload_start", 0)
			bVM0 = true
			
			if (self:PlayActivity("reload_start", 0)) then
				flSequenceDuration = self:SequenceLength(0)
			end
		end
		
		if (self.m_tUseViewModel[1] and self:ShouldReloadViewModel(1)) then
			self:PlaySound("reload_start", 1, true)
			bVM1 = true
			
			if (self:PlayActivity("reload_start", 1)) then
				flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(1))
			end
		end
		
		if (self.m_tUseViewModel[2] and self:ShouldReloadViewModel(2)) then
			self:PlaySound("reload_start", 2, true)
			bVM2 = true
			
			if (self:PlayActivity("reload_start", 2)) then
				flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(2))
			end
		end
		
		self:SetNextReload(-1)
		local bFirst = true
		
		self:AddEvent("reload", flSequenceDuration, function()
			-- HACK: Don't reload with primary fire underwater
			if ((pPlayer:KeyDown(IN_ATTACK) and not self.Primary.FireUnderwater and pPlayer:WaterLevel() == 3
				or pPlayer:KeyDown(IN_ATTACK2)) and not tSingleReload.QueuedFire) then
				self:SetNextIdle(-1)
				
				-- Start reloading when the mouse is lifted
				return 0
			elseif (self:GetNextIdle() == -1) then
				-- Re-enable idling
				self:SetNextIdle(0)
				
				-- Skip one tick for PrimaryAttack to have priority
				return 0
			end
			
			if (not bFirst or tSingleReload.InitialRound) then
				if (iMaxClip1 ~= -1) then
					iClip1 = iClip1 + 1
					self:SetClip1(iClip1)
					iAmmoCount1 = iAmmoCount1 - 1
					pPlayer:RemoveAmmo(1, sAmmo1)
					
					if (iAmmoCount1 == 0 or iClip1 == iMaxClip1) then
						iMaxClip1 = -1
					end
				end
				
				if (iMaxClip2 ~= -1) then
					iClip2 = iClip2 + 1
					self:SetClip2(iClip2)
					iAmmoCount2 = iAmmoCount2 - 1
					pPlayer:RemoveAmmo(1, sAmmo2)
					
					if (iAmmoCount2 == 0 or iClip2 == iMaxClip2) then
						iMaxClip2 = -1
					end
				end
			end
			
			local flSequenceDuration = 0
			local flCurTime = CurTime()
			
			if (bVM0) then
				if (self:ShouldReloadViewModel(0)) then
					self:PlaySound("reload", 0)
					
					if (self:PlayActivity("reload", 0)) then
						flSequenceDuration = self:SequenceLength(0)
					end
				else
					self:PlaySound("reload_finish", 0)
					bVM0 = false
					
					if (self:PlayActivity("reload_finish", 0)) then
						flFinishTime = math.max(flFinishTime, flCurTime + self:SequenceLength(0))
					end
				end
			end
			
			if (bVM1) then
				if (self:ShouldReloadViewModel(1)) then
					self:PlaySound("reload", 1, true)
					
					if (self:PlayActivity("reload", 1)) then
						flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(1))
					end
				else
					self:PlaySound("reload_finish", 1, true)
					bVM1 = false
					
					if (self:PlayActivity("reload_finish", 1)) then
						flFinishTime = math.max(flFinishTime, flCurTime + self:SequenceLength(1))
					end
				end
			end
			
			if (bVM2) then
				if (self:ShouldReloadViewModel(2)) then
					self:PlaySound("reload", 2, true)
					
					if (self:PlayActivity("reload", 2)) then
						flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(2))
					end
				else
					self:PlaySound("reload_finish", 2, true)
					bVM2 = false
					
					if (self:PlayActivity("reload_finish", 2)) then
						flFinishTime = math.max(flFinishTime, flCurTime + self:SequenceLength(2))
					end
				end
			end
			
			if (iMaxClip1 == -1 and iMaxClip2 == -1) then	
				--pPlayer:DoAnimationEvent(PLAYERANIMEVENT_RELOAD_END)
				
				self:SetNextPrimaryFire(flFinishTime)
				self:SetNextSecondaryFire(flFinishTime)
				self:SetNextReload(flFinishTime)
				
				self:SetShotsFired(0)
				self:FinishReload()
				
				if (bSinglePlayer) then
					net.Start("GS-Weapons-Finish reload")
					net.Send(pPlayer)
				end
				
				return true
			end
			
			if (bFirst) then
				bFirst = false
				pPlayer:SetAnimation(PLAYER_RELOAD)
				self:SetNextPrimaryFire(0)
				self:SetNextSecondaryFire(0)
			end
			
			-- Start anim times are different than mid reload
			return flSequenceDuration
		end)
	else
		// Play the player's reload animation
		pPlayer:SetAnimation(PLAYER_RELOAD)
		
		local flSequenceDuration = 0
		
		if (self.m_tUseViewModel[0] and self:ShouldReloadViewModel(0)) then
			self:PlaySound("reload", 0)
			
			if (self:PlayActivity("reload", 0)) then
				flSequenceDuration = self:SequenceLength(0)
			end
		end
		
		if (self.m_tUseViewModel[1] and self:ShouldReloadViewModel(1)) then
			self:PlaySound("reload", 1, true)
			
			if (self:PlayActivity("reload", 1)) then
				flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(1))
			end
		end
		
		if (self.m_tUseViewModel[2] and self:ShouldReloadViewModel(2)) then
			self:PlaySound("reload", 2, true)
			
			if (self:PlayActivity("reload", 2)) then
				flSequenceDuration = math.max(flSequenceDuration, self:SequenceLength(2))
			end
		end
		
		self:SetNextReload(CurTime() + flSequenceDuration)
		
		-- Finish reloading after the animation is finished
		self:AddEvent("reload", flSequenceDuration, function()
			local iMaxClip = self:GetMaxClip1()
			
			// If I use primary clips, reload primary
			if (iMaxClip ~= -1) then
				local iClip = self:Clip1()
				local sAmmoType = self:GetPrimaryAmmoName()
				
				-- Only reload what is available
				local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(sAmmoType))
				
				-- Add to the clip
				self:SetClip1(iClip + iAmmo)
				
				-- Take from the player's reserve
				pPlayer:RemoveAmmo(iAmmo, sAmmoType)
			end
			
			iMaxClip = self:GetMaxClip2()
			
			// If I use secondary clips, reload secondary
			if (iMaxClip ~= -1) then
				local iClip = self:Clip2()
				local sAmmoType = self:GetSecondaryAmmoName()
				local iAmmo = math.min(iMaxClip - iClip, pPlayer:GetAmmoCount(sAmmoType))
				self:SetClip2(iClip + iAmmo)
				pPlayer:RemoveAmmo(iAmmo, sAmmoType)
			end
			
			self:SetShotsFired(0)
			self:FinishReload()
			
			if (bSinglePlayer) then
				net.Start("GS-Weapons-Finish reload")
				net.Send(pPlayer)
			end
			
			return true
		end)
	end
end

function SWEP:FinishReload()
end

--- Utilities
function SWEP:AddEvent(sName, iTime, fCall, bNoPrediction)
	local bAddedByName = isstring(sName)
	
	if (IsFirstTimePredicted() or (bAddedByName and bNoPrediction or fCall == true)) then
		if (bAddedByName) then -- Added by name
			sName = sName:lower()
			self.m_tEvents[sName] = {iTime, CurTime() + iTime, fCall, false}
			self.m_tRemovalQueue[sName] = nil -- Fixes edge case of event being added upon removal
		else
			local iPos = next(self.m_tEventHoles)
			
			if (iPos) then
				self.m_tEvents[iPos] = {sName, CurTime() + sName, iTime, false}
				self.m_tEventHoles[iPos] = nil
			else
				-- No holes, we can safely use the count operation
				self.m_tEvents[#self.m_tEvents] = {sName, CurTime() + sName, iTime, false}
			end
		end
	end
end

function SWEP:EventActive(sName, bNoPrediction)
	sName = sName:lower()
	
	return self.m_tEvents[sName] ~= nil and (bNoPrediction or IsFirstTimePredicted() or self.m_tEvents[sName][4])
end

function SWEP:RemoveEvent(sName, bNoPrediction)
	if (bNoPrediction) then
		self.m_tEvents[sName:lower()] = nil
	else
		self.m_tRemovalQueue[sName:lower()] = true
	end
end

function SWEP:AddNWVar(sType, sName, bAddFunctions --[[= true]], DefaultVal --[[= nil]])
	-- Handle the table here in-case initialize runs after on the client
	if (not self.m_tNWVarSlots) then
		self.m_tNWVarSlots = {}
	end
	
	local iSlot = self.m_tNWVarSlots[sType] or 0
	self.m_tNWVarSlots[sType] = iSlot + 1
	
	self:DTVar(sType, iSlot, sName)
	
	if (bAddFunctions or bAddFunctions == nil) then
		self["Get" .. sName] = function(self) return self.dt[sName] end
		self["Set" .. sName] = function(self, Val) self.dt[sName] = Val end
	end
	
	if (DefaultVal) then
		self.dt[sName] = DefaultVal
	end
end

-- Currently MUST be called in a predicted context
function SWEP:ToggleFullyLowered(iIndex --[[= 0]])
	if (self:GetPredictedVar("m_bLowered")) then
		self:SetPredictedVar("m_bLowered", false)
		self:PlaySound("draw", iIndex)
		
		local pViewModel = self:GetOwner():GetViewModel(iIndex)
		
		if (pViewModel ~= NULL) then
			pViewModel:SetVisible(true)
		end
		
		local flNextTime = self:PlayActivity("draw", iIndex) and self:SequenceLength(iIndex) or 0
		
		self:AddEvent("lower", flNextTime, function()
			if (SERVER and bSinglePlayer) then
				net.Start("GS-Weapons-Lower")
				net.Send(self:GetOwner())
			end
			
			return true
		end)
		
		flNextTime = flNextTime + CurTime()
		self:SetNextPrimaryFire(flNextTime)
		self:SetNextSecondaryFire(flNextTime)
		self:SetNextReload(flNextTime)
	else
		if (SERVER and bSinglePlayer) then
			net.Start("GS-Weapons-Lower")
			net.Send(self:GetOwner())
		end
		
		self:PlaySound("holster", iIndex)
		
		local bRan = false
		
		self:AddEvent("lower", self:PlayActivity("holster", iIndex) and self:SequenceLength(iIndex) or 0, function()
			-- FIXME: Hack to fix hands bug
			if (bRan) then
				self:SetPredictedVar("m_bLowered", true)
				return true
			end
			
			local pViewModel = self:GetOwner():GetViewModel(iIndex)
			
			if (pViewModel ~= NULL) then
				pViewModel:SetVisible(false)
			end
			
			bRan = true
			
			return 0.2 -- Magic number
		end)
		
		self:SetNextPrimaryFire(-1)
		self:SetNextSecondaryFire(-1)
		self:SetNextReload(-1)
	end
end

function SWEP:PlaySound(sSound, iIndex, bStrictIndex, bPlayShared --[[= false]])
	-- Not a sound file or sound scape
	if (not (string.IsSoundFile(sSound) or sSound:find('.', 2, true))) then
		local sPrefix = self:GetSoundPrefix(sSound, iIndex)
		
		if (sPrefix == "") then
			sSound = self:LookupSound(sSound, iIndex, bStrictIndex)
			
			if (sSound == "") then
				return false
			end
		else
			local sPlay = self:LookupSound(string.format(sFormatOne, sPrefix, sSound), iIndex, bStrictIndex)
			
			if (sPlay == "") then
				sSound = self:LookupSound(sSound, iIndex, bStrictIndex)
				
				if (sSound == "") then
					return false
				end
			else
				sSound = sPlay
			end
		end
	end
	
	if (bPlayShared or SERVER) then
		local pPlayer = self:GetOwner()
		
		if (pPlayer == NULL) then
			self:EmitSound(sSound)
		else
			pPlayer:EmitSound(sSound)
		end
	end
	
	return true
end

local tDeployActivities = {
	[ACT_VM_DRAW] = true,
	[ACT_VM_DRAW_SILENCED] = true,
	[ACT_VM_DRAW_DEPLOYED] = true,
	[ACT_VM_DRAW_EMPTY] = true,
	draw = true
}

-- SendWeaponAnim that supports idle times and multiple view models
-- Sending in a value for flRate will ignore the SWEP.Activities defined rate
function SWEP:PlayActivity(Activity, iIndex --[[= 0]], flRate --[[= 1]], bStrictPrefix --[[= false]], bStrictSuffix --[[= false]])
	if (not iIndex) then
		iIndex = 0
	end
	
	-- Do not play an animation if the weapon is invisible
	if (not self:IsVisible(iIndex)) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	local pViewModel = pPlayer:GetViewModel(iIndex)
	
	-- Do not give animations to something that does not exist or is invisible
	if (pViewModel == NULL) then
		return false
	end
	
	local bSequence = true
	local iSequence, sActivity, iActivity
	
	-- HACK: Weapons with a very short idle animation (CS:S weapons) were causing some efficiency issues
	-- With how many table lookups/comparisons were being done to find an activity
	-- This code is very messy but the most efficient way of doing it while still supporting tags
	if (isstring(Activity)) then
		local sPrefix = self:GetActivityPrefix(Activity, iIndex)
		local sSuffix = self:GetActivitySuffix(Activity, iIndex)
		local bPrefix = sPrefix ~= ""
		local bSuffix = sSuffix ~= ""
		
		if (bPrefix and bSuffix) then
			sActivity = string.format(sFormatTwo, sPrefix, Activity, sSuffix)
			iActivity = self:LookupActivity(sActivity, iIndex)
			
			if (isstring(iActivity)) then
				self:PlaySequence(iActivity, iIndex, flRate)
				
				-- No way to tell if it succeeded or not
				return true
			end
			
			if (iActivity == ACT_RESET) then
				return self:ResetActivity(iIndex, self:LookupActivityKey(sActivity, "rate", iIndex))
			end
			
			iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence(iActivity)
			bSequence = iSequence == -1
		end
		
		if (bSequence) then
			if (bPrefix and not (bStrictSuffix and bSuffix)) then
				sActivity = string.format(sFormatOne, sPrefix, Activity)
				iActivity = self:LookupActivity(sActivity, iIndex)
				
				if (isstring(iActivity)) then
					self:PlaySequence(iActivity, iIndex, flRate)
					
					return true
				end
				
				if (iActivity == ACT_RESET) then
					return self:ResetActivity(iIndex, self:LookupActivityKey(sActivity, "rate", iIndex))
				end
				
				iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence(iActivity)
				bSequence = iSequence == -1
			end
			
			if (bSequence) then
				if (bPrefix and bStrictPrefix) then
					return false
				end
				
				if (bSuffix) then
					sActivity = string.format(sFormatOne, Activity, sSuffix)
					iActivity = self:LookupActivity(sActivity, iIndex)
					
					if (isstring(iActivity)) then
						self:PlaySequence(iActivity, iIndex, flRate)
						
						return true
					end
					
					if (iActivity == ACT_RESET) then
						return self:ResetActivity(iIndex, self:LookupActivityKey(sActivity, "rate", iIndex))
					end
					
					iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence(iActivity)
					bSequence = iSequence == -1
				end
				
				if (bSequence) then
					if (bSuffix and bStrictSuffix) then
						return false
					end
					
					sActivity = Activity
					iActivity = self:LookupActivity(sActivity, iIndex)
					
					if (isstring(iActivity)) then
						self:PlaySequence(iActivity, iIndex, flRate)
						
						return true
					end
					
					if (iActivity == ACT_RESET) then
						return self:ResetActivity(iIndex, self:LookupActivityKey(sActivity, "rate", iIndex))
					end
					
					iSequence = iActivity == ACT_INVALID and -1 or pViewModel:SelectWeightedSequence(iActivity)
					bSequence = iSequence == -1
				end
			end
		end
		
		if (not flRate) then
			flRate = self:LookupActivityKey(sActivity, "rate", iIndex) or 1
		end
	else
		if (Activity == ACT_INVALID) then
			return false
		end
		
		if (Activity == ACT_RESET) then
			return self:ResetActivity(iIndex, flRate)
		end
		
		if (not flRate) then
			flRate = 1
		end
		
		iActivity = Activity
		iSequence = pViewModel:SelectWeightedSequence(Activity)
		bSequence = iSequence == -1
	end
	
	if (bSequence) then
		return false
	end
	
	if (iIndex == 0) then
		// Take the new activity
		self:SetSaveValue("m_IdealActivity", iActivity)
		self:SetSaveValue("m_nIdealSequence", iSequence)
	end
	
	// Don't use transitions when we're deploying
	if (not tDeployActivities[Activity]) then
		// Find the next sequence in the potential chain of sequences leading to our ideal one
		local iNext = pViewModel:FindTransitionSequence(pViewModel:GetSequence(), iSequence)
		
		if (iNext ~= iSequence) then
			// Set our activity to the next transitional animation
			iActivity = ACT_TRANSITION
			iSequence = iNext
		end
	end
	
	if (iIndex == 0) then
		-- Since m_Activity in not avaliable in the save table, run Weapon:Weapon_SetActivity() and override everything afterward
		self:Weapon_SetActivity(iActivity)
		self:SetSequence(iSequence)
		self:SetPlaybackRate(flRate)
	end
	
	if (SERVER or self:GetPredictable()) then
		-- Enable the view-model if an animation is sent to it
		--pViewModel:SetWeaponModel(self:GetViewModel(iIndex), self)
		pViewModel:SendViewModelMatchingSequence(iSequence)
		pViewModel:SetPlaybackRate(flRate)
	end
	
	if (flRate == 0) then -- Invalid rate; reset idle time
		if (iIndex == 0) then
			self:SetNextIdle(0)
		elseif (iIndex == 1) then
			self:SetNextIdle1(0)
		elseif (iIndex == 2) then
			self:SetNextIdle2(0)
		end
	else
		local flTime = self:LookupActivityKey(sActivity, "idle", iIndex) or pViewModel:SequenceDuration()
		
		if (istable(flTime)) then
			code_gs.random:SetSeed(pPlayer:GetMD5Seed() % 0x100)
			flTime = code_gs.random:RandomFloat(flTime[1], flTime[2])
		end
		
		if (iIndex == 0) then
			self:SetNextIdle(flTime / (flRate < 0 and -flRate or flRate) + CurTime())
		elseif (iIndex == 1) then
			self:SetNextIdle1(flTime / (flRate < 0 and -flRate or flRate) + CurTime())
		elseif (iIndex == 2) then
			self:SetNextIdle2(flTime / (flRate < 0 and -flRate or flRate) + CurTime())
		end
	end
	
	return true
end

function SWEP:PlaySequence(Sequence, iIndex --[[= 0]], flRate --[[= 1]])
	if (Sequence == -1) then
		return false
	end
	
	local pViewModel = self:GetOwner():GetViewModel(iIndex)
	
	if (pViewModel == NULL) then
		return false
	end
	
	local flTime
	
	if (isstring(Sequence)) then
		Sequence, flTime = pViewModel:LookupSequence(Sequence)
		
		if (Sequence == -1) then
			return false
		end
	else
		flTime = pViewModel:SequenceDuration(Sequence)
	end
	
	flRate = flRate or 1
	
	if (SERVER or self:GetPredictable()) then
		--pViewModel:SetWeaponModel(self:GetViewModel(iIndex), self)
		pViewModel:SendViewModelMatchingSequence(Sequence)
		pViewModel:SetPlaybackRate(flRate)
	end
	
	if (flRate == 0) then
		if (iIndex == 0) then
			self:SetNextIdle(0)
		elseif (iIndex == 1) then
			self:SetNextIdle1(0)
		elseif (iIndex == 2) then
			self:SetNextIdle2(0)
		end
	else
		if (iIndex == 0) then
			self:SetNextIdle(flTime / (flRate < 0 and -flRate or flRate) + CurTime())
		elseif (iIndex == 1) then
			self:SetNextIdle1(flTime / (flRate < 0 and -flRate or flRate) + CurTime())
		elseif (iIndex == 2) then
			self:SetNextIdle2(flTime / (flRate < 0 and -flRate or flRate) + CurTime())
		end
	end
end

function SWEP:ResetActivity(iIndex --[[= 0]], flRate --[[= nil]])
	local pViewModel = self:GetOwner():GetViewModel(iIndex)
	
	if (pViewModel == NULL) then
		return false
	end
	
	pViewModel:SetCycle(0)
	
	if (flRate) then
		pViewModel:SetPlaybackRate(flRate)
	else
		flRate = pViewModel:GetPlaybackRate()
	end
		
	if (flRate == 0) then
		if (iIndex == 0) then
			self:SetNextIdle(0)
		elseif (iIndex == 1) then
			self:SetNextIdle1(0)
		elseif (iIndex == 2) then
			self:SetNextIdle2(0)
		end
	else
		if (iIndex == 0) then
			self:SetNextIdle(pViewModel:SequenceDuration() / flRate + CurTime())
		elseif (iIndex == 1) then
			self:SetNextIdle1(pViewModel:SequenceDuration() / flRate + CurTime())
		elseif (iIndex == 2) then
			self:SetNextIdle2(pViewModel:SequenceDuration() / flRate + CurTime())
		end
	end
	
	return true
end
-- FIXME: Add prediction count system with UnpredictedCurTime
function SWEP:SetupPredictedVar(sName, Initial)
	self[sName] = Initial
	self[sName .. "-PREV"] = Initial
	self[sName .. "-PRED"] = {Initial, 0}
	self[sName .. "-TIME"] = 0
end

function SWEP:SetPredictedVar(sName, Val, bNoPrediction)
	assert(bNoPrediction or IsFirstTimePredicted() or self[sName .. "-TIME"] == CurTime())
	
	if (bNoPrediction) then
		self[sName] = Val
		self[sName .. "-PREV"] = Val
		self[sName .. "-TIME"] = 0
		
		self[sName .. "-PRED"][1] = Val
		self[sName .. "-PRED"][2] = 0
	elseif (IsFirstTimePredicted()) then
		local flCurTime = CurTime()
		
		if (self[sName .. "-TIME"] ~= flCurTime) then
			self[sName .. "-TIME"] = flCurTime
			self[sName .. "-PREV"] = self[sName]
		end
		
		self[sName] = Val
	else
		self[sName .. "-PRED"][1] = Val
		self[sName .. "-PRED"][2] = UnPredictedCurTime()
	end
end

function SWEP:GetPredictedVar(sName, bNoPrediction)
	assert(self[sName] ~= nil)
	
	if (bNoPrediction or IsFirstTimePredicted() or self[sName .. "-TIME"] ~= CurTime()) then
		return self[sName] -- Raw value; not predicted or nothing has been set this frame
	end
	
	if (self[sName .. "-PRED"][2] == UnPredictedCurTime()) then
		return self[sName .. "-PRED"][1] -- Something has been set this prediction run
	end
	
	return self[sName .. "-PREV"] -- Something was set this frame, but not this prediction run
end

function SWEP:TakePrimaryAmmo(iAmount)
	local iClip = self:Clip1()
	
	if (iClip == -1) then
		local pPlayer = self:GetOwner()
		local sAmmo = self:GetPrimaryAmmoName()
		
		if (pPlayer:GetAmmoCount(sAmmo) > 0) then
			pPlayer:RemoveAmmo(iAmount, sAmmo)
		end
	else
		if (iClip - iAmount < 0) then
			self:SetClip1(0)
		else
			self:SetClip1(iClip - iAmount)
		end
	end
end

function SWEP:TakeSecondaryAmmo(iAmount)
	local iClip = self:Clip2()
	
	if (iClip == -1) then
		local pPlayer = self:GetOwner()
		local sAmmo = self:GetSecondaryAmmoName()
		
		if (pPlayer:GetAmmoCount(sAmmo) > 0) then
			pPlayer:RemoveAmmo(iAmount, sAmmo)
		end
	else
		if (iClip - iAmount < 0) then
			self:SetClip2(0)
		else
			self:SetClip2(iClip - iAmount)
		end
	end
end

-- Used by PlayActivity to detect when to add the _empty tag
function SWEP:ViewModelEmpty(iIndex --[[= 0]])
	if (not iIndex or iIndex == 0) then
		return self:GetShootClip(self:SpecialActive(iIndex)) == 0
	end
	
	return false
end

-- Used by Reload to know when to play the reload anim
function SWEP:ShouldReloadViewModel(iIndex --[[= 0]])
	if (not iIndex or iIndex == 0) then
		return self:Clip1() ~= self:GetMaxClip1()
	end
	
	return false
end

--- Hooks
--[[function SWEP:ContextScreenClick(vAim, nMouse, bPressed, pPlayer)
end]]

-- Will only be called serverside in single-player
function SWEP:DoImpactEffect(tr, nDamage)
	return false
end

function SWEP:DoSplashEffect()
	return false
end

--[[function SWEP:OnReloaded()
end

function SWEP:OnRestore()
end

function SWEP:OnRestore()
end

function SWEP:OwnerChanged()
end]]

function SWEP:TranslateActivity(iAct)
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

function SWEP:Ammo1()
	return self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoName())
end

function SWEP:Ammo2()
	return self:GetOwner():GetAmmoCount(self:GetSecondaryAmmoName())
end

function SWEP:GetSpecialKey(sKey, bSecondary, bNoConVar)
	local Val
	
	if (bSecondary) then
		Val = self.Secondary[sKey]
		
		if (Val ~= -1) then
			return not bNoConVar and isstring(Val) and GetConVarNumber(Val) or isfunction(Val) and Val() or Val
		end
	end
	
	Val = self.Primary[sKey]
	
	return not bNoConVar and isstring(Val) and GetConVarNumber(Val) or isfunction(Val) and Val() or Val
end

function SWEP:BurstEnabled(iIndex)
	if (iIndex) then
		return bit.band(self:GetBurst(), 2^iIndex) ~= 0
	end
	
	return self:GetBurst() ~= 0
end

function SWEP:SetWeaponHoldType(sHold)
	sHold = sHold:lower()
	self.HoldType = sHold
	self.m_tActivityTranslate = code_gs.weapons.GetHoldType(sHold)
end

function SWEP:ResetHoldType()
	self:SetHoldType(self.m_sHoldType)
end

function SWEP:FlipsViewModel(iIndex --[[= 0]])
	return iIndex == 0 and self.ViewModel or iIndex == 1 and self.ViewModelFlip1 or iIndex == 2 and self.ViewModelFlip2 or ""
end

function SWEP:GetActivityPrefix(sActivity, iIndex)
	if (self:Silenced(iIndex)) then
		return "s"
	end
	
	if (self:GetDeployed() == iIndex + 1) then
		return "d"
	end
	
	return ""
end

-- Games like DoD:S have team-based skins
-- Override this return to choose what skin to use for each viewmodel
function SWEP:GetViewModelSkin(iIndex)
	return 0
end

function SWEP:GetActivitySuffix(sActivity, iIndex)
	if (sActivity ~= "empty" and self:ViewModelEmpty(iIndex)) then
		return "empty"
	end
	
	return ""
end

function SWEP:GetSoundPrefix(sSound, iIndex)
	if (self:Silenced(iIndex)) then
		return "s"
	end
	
	return ""
end

function SWEP:GetDefaultClip1()
	return self.Primary.DefaultClip
end

function SWEP:GetDefaultClip2()
	return self.Secondary.DefaultClip
end

-- FIXME: Add silenced conditions to this
function SWEP:GetDryfireActivity(iIndex --[[= 0]])
	if (not iIndex or iIndex == 0) then
		return "shoot_empty"
	end
	
	return ""
end

--[[function SWEP:GetMaxClip1()
	return self.Primary.ClipSize
end

function SWEP:GetMaxClip2()
	return self.Secondary.ClipSize
end]]

function SWEP:GetMuzzleAttachment(iEvent)
	-- Assume first attachment
	return iEvent and (iEvent - 4991) / 10 or 1
end

function SWEP:GetEjectionAttachment(iEvent)
	return 2
end

--[[function SWEP:GetOwner()
	return self.Owner -- Will always be an entity (NULL included)
end

function SWEP:GetPrimaryAmmoType()
	return game.GetAmmoID(self.Primary.Ammo)
end

function SWEP:GetSecondaryAmmoType()
	return game.GetAmmoID(self.Secondary.Ammo)
end]]

function SWEP:GetPrimaryAmmoName()
	return self.Primary.Ammo
end

function SWEP:GetSecondaryAmmoName()
	return self.Secondary.Ammo
end

function SWEP:GetGrenadeAmmoName(iIndex)
	return self:GetPrimaryAmmoName()
end

--[[function SWEP:GetPrintName()
	return self.PrintName
end]]

function SWEP:GetShootAngles(bSecondary)
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + pPlayer:GetViewPunchAngles()
end

function SWEP:GetShootDir(bSecondary)
	return self:GetShootAngles(bSecondary):Forward()
end

function SWEP:GetShootSrc(bSecondary)
	return self:GetOwner():GetShootPos()
end

function SWEP:GetShootAmmoName(bSecondary)
	return self:GetPrimaryAmmoName()
end

function SWEP:GetShootInfo(bSecondary)
	return {
		AmmoType = self:GetShootAmmoName(bSecondary),
		Damage = self:GetSpecialKey("Damage", bSecondary),
		Dir = self:GetShootDir(bSecondary),
		Distance = self:GetSpecialKey("Range", bSecondary),
		--Flags = FIRE_BULLETS_ALLOW_WATER_SURFACE_IMPACTS,
		Force = self:GetSpecialKey("Force", bSecondary),
		Num = self:GetSpecialKey("Bullets", bSecondary),
		ShootAngles = self:GetShootAngles(bSecondary),
		Spread = self:GetSpecialKey("Spread", bSecondary),
		SpreadBias = self:GetSpecialKey("SpreadBias", bSecondary),
		Src = self:GetShootSrc(bSecondary),
		Tracer = self:GetSpecialKey("TracerFreq", bSecondary),
		TracerName = self:GetSpecialKey("TracerName", bSecondary, true)
	}
end

--[[function SWEP:GetSlot()
	return self.Slot
end

function SWEP:GetSlotPos()
	return self.SlotPos
end

-- This must be done shared
function SWEP:GetTracerOrigin()
end]]

function SWEP:GetViewModel(iIndex --[[= 0]])
	return iIndex == 1 and self.ViewModel1 or iIndex == 2 and self.ViewModel2 or self.ViewModel
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

function SWEP:IronSightsEnabled(iIndex)
	if (iIndex) then
		return bit.band(self:GetIronSights(), 2^iIndex) ~= 0
	end
	
	return self:GetIronSights() ~= 0
end

-- Returns the activity and playback rate
function SWEP:LookupActivity(sName, iIndex --[[= 0]])
	local Activity = self.Activities[sName]
	
	if (Activity) then
		if (istable(Activity)) then
			Activity = iIndex and Activity[iIndex + 1] or Activity[1]
			
			if (Activity) then
				-- FIXME: Add method to see if the seed has been set this command
				code_gs.random:SetSeed(self:GetOwner():GetMD5Seed() % 0x100)
				
				return istable(Activity) and Activity[code_gs.random:RandomInt(1, #Activity)] or Activity or ACT_INVALID
			end
			
			return ACT_INVALID
		end
		
		-- Enum or sequence
		return Activity
	end
	
	return ACT_INVALID
end

function SWEP:LookupActivityKey(sName, sKey, iIndex)
	local Activity = self.Activities[sName]
	
	if (Activity and istable(Activity)) then
		if (Activity[sKey .. iIndex + 1] == nil) then
			return Activity[sKey]
		end
		
		return Activity[sKey .. iIndex + 1]
	end
end

function SWEP:LookupSound(sName, iIndex --[[= 0]], bStrictIndex --[[= false]])
	local sSound = self.Sounds[sName]
	
	if (sSound) then
		-- Auto-refresh fix
		if (istable(sSound) or string.IsSoundFile(sSound)) then
			self:Precache()
			
			sSound = self.Sounds[sName]
			
			if (not sSound) then
				return ""
			end
		end
		
		if (not iIndex or iIndex == 0 or bStrictIndex) then
			return string.format(sSound, iIndex or 0)
		end
		
		local sFormatSound = string.format(sSound, iIndex)
		
		if (sound.GetProperties(sFormatSound)) then
			return sFormatSound
		end
		
		return string.format(sSound, 0)
	end
	
	return ""
end

function SWEP:SetDeploySpeed()
	-- Do nothing! Change the deploy speed using the SWEP.Activities table
end

function SWEP:Silenced(iIndex --[[= nil]])
	if (iIndex) then
		return bit.band(self:GetSilenced(), 2^iIndex) ~= 0
	end
	
	return self:GetSilenced() ~= 0
end

-- The player is considered to be in-zoom to variable modifiers if they are fully zoomed
-- This prevents quick-scoping for the spread/damage/cooldown benfits
function SWEP:SpecialActive(iIndex --[[= nil]])
	if (self:Silenced(iIndex) or self:BurstEnabled(iIndex) or self:IronSightsEnabled(iIndex)) then
		return true
	end
	
	if (iIndex) then
		if (self:GetDeployed() == iIndex + 1) then
			return true
		end
	elseif (self:GetDeployed() ~= 0) then
		return true
	end
	
	if (self:GetZoomLevel() > 0) then
		if (not iIndex) then
			local flCurTime = CurTime()
			
			return self:GetZoomActiveTime() <= flCurTime and self:GetZoomActiveTime1() <= flCurTime and self:GetZoomActiveTime2() <= flCurTime
		end
		
		if (iIndex == 0) then
			return self:GetZoomActiveTime() <= CurTime()
		end
		
		if (iIndex == 1) then
			return self:GetZoomActiveTime1() <= CurTime()
		end
		
		if (iIndex == 2) then
			return self:GetZoomActiveTime2() <= CurTime()
		end
	end
	
	return false
end

function SWEP:UsesHands()
	return self.UseHands
end
