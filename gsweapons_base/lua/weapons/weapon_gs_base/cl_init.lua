-- TODO: Convert styles to send into a weapons function
include( "shared.lua" )

--- Selection/Menu
SWEP.Category = "Source" -- Category in the spawn menu the weapon should appear in. This must be defined in every weapon!
SWEP.DrawAmmo = true -- Draw HL2 ammo HUD when the weapon is out

SWEP.KillIcon = 'v' -- Letter from the KillIconFont file to draw on the weapon selection panel and killicons
SWEP.KillIconFont = "HL2KillIcon" -- Font defined by surface.CreateFont to use for killicons
SWEP.KillIconColor = Color( 255, 80, 0, 255 ) -- Color of the font for killicons
SWEP.SelectionIcon = 'V'
SWEP.SelectionFont = "HL2Selection" -- Font defined by surface.CreateFont to use for weapon selection icons
SWEP.SelectionColor = Color( 255, 210, 0, 255 ) -- Color of the font for weapon selection icons

--- Weapon demeanour
SWEP.BobStyle = "default" -- Style defined in bob.lua. Set to "" to disable bobbing
SWEP.BobSpeed = 320/250 -- Speed at which the bob is clamped at. Only affects cstrike and hl bob styles 

SWEP.CrosshairStyle = "default" -- Style defined in crosshair.lua
SWEP.DrawCrosshair = true -- Call DoDrawCrosshair or not
SWEP.AccurateCrosshair = false -- (Buggy) Moves crosshair with actual shooting position

SWEP.CSSCrosshair = {
	Min = 4, // The minimum distance the crosshair can achieve...
	Delta = 3, // Distance at which the crosshair shrinks at each step
	Vel = 100/250 -- Velocity at which the crosshair expands
}

SWEP.MuzzleFlashScale = 1 -- Only for CS:S muzzle flash

SWEP.EventStyle = { -- Set to "" to disable an event
	-- CS:S bullet ejection
	[20] = "cstrike",
	
	-- HL2 muzzle flashes
	[21] = "default", -- First-person
	[22] = "default", -- Third-person
	
	-- CS:S muzzle flash
	[5001] = "cstrike", -- First-person, Attachment 0
	[5003] = "cstrike", -- Third-person, Attachment 0
	[5011] = "cstrike", -- First-person, Attachment 1
	[5013] = "cstrike", -- Third-person, Attachment 1
	[5021] = "cstrike", -- First-person, Attachment 2
	[5023] = "cstrike", -- Third-person, Attachment 2
	[5031] = "cstrike", -- First-person, Attachment 3
	[5033] = "cstrike", -- Third-person, Attachment 3
	
	-- HL2 bullet ejection
	[6001] = "default"
}

--SWEP.RenderGroup = RENDERGROUP_OPAQUE -- April 2016: "RenderGroup of SENTs and SWEPs is now defaulted to engine default unless overridden ( instead of defaulting to RG_OPAQUE )"

--- Holster
if ( game.SinglePlayer() ) then
	net.Receive( "GSWeaponBase - Holster Animation", function()
		net.ReadEntity():DoHolsterAnim( net.ReadEntity() )
	end )
	
	net.Receive( "GSWeaponBase - Holster", function()
		net.ReadEntity():SharedHolster( net.ReadEntity() )
	end )
end

--- HUD/Visual
-- Bobbing affects all view models; individual view models can call CalcViewModelView
local fGetBobbingMethod = include( "bob.lua" )

function SWEP:CalcViewModelView( vm, vPos, ang, vNewPos, aNew )
	return fGetBobbingMethod( self.BobStyle )( self, vm, vPos, ang, vNewPos, aNew )
end

local fGetCrosshair = include( "crosshair.lua" )

function SWEP:DoDrawCrosshair( x, y )
	return fGetCrosshair( self.Zoom.DrawOverlay and self:GetZoomLevel() ~= 0 and self.Zoom.ScopeStyle or self.CrosshairStyle )( self, x, y )
end

local fGetAnimEvent = include( "event.lua" )

function SWEP:FireAnimationEvent( vPos, ang, iEvent, sOptions )
	if ( self.EventStyle[iEvent] ) then
		return fGetAnimEvent( iEvent, self.EventStyle[iEvent] )( self, vPos, ang, iEvent, sOptions )
	else
		DevMsg( 2, string.format( "%s (weapon_gs_base) Missing event %u: %s", self:GetClass(), iEvent, sOptions ))
	end
end

function SWEP:DrawWeaponSelection( x, y, flWide, flTall )
	draw.SimpleText( self.SelectionIcon, self.SelectionFont, x + flWide / 2, y + flTall * 0.2, self.SelectionColor, TEXT_ALIGN_CENTER )
end

--- Utilities
surface.CreateFont( "HL2KillIcon", { font = "HL2MP", size = ScreenScale(30), weight = 500, additive = true })
surface.CreateFont( "HL2Selection", { font = "HALFLIFE2", size = ScreenScale(120), weight = 500, additive = true }) -- cs font doesn't work for some reason

function SWEP:DrawWorldModel()
	if ( self.SilencerModel ~= "" and self:Silenced() ) then
		self.WorldModel = self.SilencerModel
	else
		self.WorldModel = self.m_sWorldModel
	end
	
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
	if ( self.SilencerModel ~= "" and self:Silenced() ) then
		self.WorldModel = self.SilencerModel
	else
		self.WorldModel = self.m_sWorldModel
	end
	
	self:DrawModel()
end

local fSetDormant = _R.Entity.SetDormant

function SWEP:SetDormant( bDormant )
	// If I'm going from active to dormant and I'm carried by another player, holster me.
	if ( bDormant and not self:IsDormant() and not self:IsCarriedByLocalPlayer() ) then
		self:Holster( NULL )
	end
	
	fSetDormant( self, bDormant ) -- Weapon metatable baseclass
end

--- Accessors/Modifiers
function SWEP:GetMuzzleFlashScale()
	return self.MuzzleFlashScale
end

--- Player functions
-- DTVar exists are varying times based on when the player loads in
hook.Add( "Think", "GSBase-Player DTVars", function()
	local pLocalPlayer = LocalPlayer()
	
	if ( pLocalPlayer.DTVar ) then
		if ( pLocalPlayer.SetupWeaponDataTables ) then
			pLocalPlayer:SetupWeaponDataTables()
		else
			ErrorNoHalt( "Player DTVars could not be initialized! This is probably due to an earlier error that halted loading. Please fix/contact code_gs before using GSWeapons" )
		end
		
		hook.Remove( "Think", "GSBase-Player DTVars" )
	end
end )
