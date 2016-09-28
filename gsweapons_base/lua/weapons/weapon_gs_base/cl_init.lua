include( "shared.lua" )

--- Selection/Menu
SWEP.Category = "Source" -- Category in the spawn menu the weapon should appear in. This must be defined in every weapon!
SWEP.DrawAmmo = true -- Draw HL2 ammo HUD when the weapon is out

SWEP.KillIcon = 'v' -- Letter from the KillIconFont file to draw for killicon notifications
SWEP.KillIconFont = "HL2KillIcon" -- Font defined by surface.CreateFont to use for killicons
SWEP.KillIconColor = Color(255, 80, 0, 255) -- Color of the font for killicons
SWEP.SelectionIcon = 'V' -- Letter from the SelectionFont file to draw on the weapon selection panel
SWEP.SelectionFont = "HL2Selection" -- Font defined by surface.CreateFont to use for weapon selection icons
SWEP.SelectionColor = Color(255, 210, 0, 255) -- Color of the font for weapon selection icons

--- Weapon demeanour
SWEP.BobStyle = "default" -- Style defined by gsweapons.RegisterBobType. Set to "" to disable all bobbing
SWEP.BobSpeed = 320/250 -- Speed at which the bob is clamped at. Only affects css and hl bob styles

SWEP.CrosshairStyle = "default" -- Style defined by gsweapons.RegisterCrosshair. Set to "" to disable crosshair drawing
SWEP.ScopeStyle = "css" -- Style defined by gsweapons.RegsiterScope. Set to "" to disable scope drawing. Scope style to show if the weapon is zoomed and SWEP.Zoom.DrawOverlay is true
SWEP.DrawCrosshair = true -- Call DoDrawCrosshair or not
SWEP.AccurateCrosshair = false -- Moves crosshair with actual shooting position

SWEP.CSSCrosshair = {
	Min = 4, // The minimum distance the crosshair can achieve...
	Delta = 3, // Distance at which the crosshair shrinks at each step
	Vel = 100/250 -- Velocity at which the crosshair expands
}

SWEP.MuzzleFlashScale = 1 -- Only for CS:S muzzle flash

-- Events defined by gsweapons.RegisterAnimEvent. Weapon model anim events. Set to "" to block engine execution
SWEP.EventStyle = {
	-- CS:S bullet ejection
	[20] = "css",
	
	-- HL2 muzzle flashes
	[21] = "default", -- First-person
	[22] = "default", -- Third-person
	
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
	[6001] = "default"
}

--SWEP.RenderGroup = RENDERGROUP_OPAQUE -- April 2016: "RenderGroup of SENTs and SWEPs is now defaulted to engine default unless overridden ( instead of defaulting to RG_OPAQUE )"

--- Holster
if ( game.SinglePlayer() ) then
	net.Receive( "GSWeapons-Holster animation", function()
		local pWeapon = net.ReadEntity()
		
		if ( pWeapon.HolsterAnim ) then
			pWeapon:HolsterAnim( net.ReadEntity() )
		end
	end )
	
	net.Receive( "GSWeapons-Holster", function()
		local pWeapon = net.ReadEntity()
		
		if ( pWeapon.SharedHolster ) then
			pWeapon:SharedHolster( net.ReadEntity() )
		end
	end )
end

--- HUD/Visual
-- Bobbing affects all view models; individual view models can call CalcViewModelView
function SWEP:CalcViewModelView( vm, vPos, ang, vNewPos, aNew )
	return gsweapons.GetBobType( self.BobStyle )( self, vm, vPos, ang, vNewPos, aNew )
end

function SWEP:DoDrawCrosshair( x, y )
	return self.Zoom.DrawOverlay and self:GetZoomLevel() ~= 0 and not self:GetOwner():ShouldDrawLocalPlayer()
		and gsweapons.GetScope( self.ScopeStyle )( self, x, y )
		or gsweapons.GetCrosshair( self.CrosshairStyle )( self, x, y )
end

function SWEP:FireAnimationEvent( vPos, ang, iEvent, sOptions )
	if ( self.EventStyle[iEvent] ) then
		return gsweapons.GetAnimEvent( iEvent, self.EventStyle[iEvent]:lower() )( self, vPos, ang, iEvent, sOptions )
	else
		DevMsg( 2, string.format( "%s (weapon_gs_base) Missing event %u: %s", self:GetClass(), iEvent, sOptions ))
	end
end

function SWEP:DrawWeaponSelection( x, y, flWide, flTall )
	draw.SimpleText( self.SelectionIcon, self.SelectionFont, x + flWide / 2, y + flTall * 0.2, self.SelectionColor, TEXT_ALIGN_CENTER )
end

--- Utilities
surface.CreateFont( "HL2KillIcon", { font = "HL2MP", size = ScreenScale(30), weight = 500, additive = true })
surface.CreateFont( "HL2Selection", { font = "HALFLIFE2", size = ScreenScale(120), weight = 500, additive = true })

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

--- Accessors/Modifiers
function SWEP:GetMuzzleFlashScale()
	return self.MuzzleFlashScale
end

--- Player functions
-- DTVar exists are varying times based on when the player loads in
hook.Add( "Think", "GSWeapons-Player DTVars", function()
	local pLocalPlayer = LocalPlayer()
	
	if ( pLocalPlayer.DTVar ) then
		if ( pLocalPlayer.SetupWeaponDataTables ) then
			pLocalPlayer:SetupWeaponDataTables()
		else
			ErrorNoHalt( "[GSWeapons] Player DTVars could not be initialized! This is probably due to an earlier error that halted loading. Please fix, or contact code_gs" )
		end
		
		hook.Remove( "Think", "GSWeapons-Player DTVars" )
	end
end )
