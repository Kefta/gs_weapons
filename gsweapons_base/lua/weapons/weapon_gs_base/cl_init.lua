include( "shared.lua" )

--- Selection/Menu
SWEP.Category = "Source" -- Category in the spawn menu the weapon should appear in. This must be defined in every weapon!
SWEP.DrawAmmo = true -- Draw HL2 ammo HUD when the weapon is out

SWEP.KillIcon = '' -- '' = no killicon. Letter from the KillIconFont file to draw for killicon notifications
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
SWEP.DrawCrosshair = true -- Call DoDrawCrosshair or not. This will disable crosshair and scope drawing
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
	
	-- HL2 melee hit
	[3001] = "",
	
	-- Grenades
	-- Throw events are handled by Think events
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
	[6001] = "default"
}

--SWEP.RenderGroup = RENDERGROUP_OPAQUE -- April 2016: "RenderGroup of SENTs and SWEPs is now defaulted to engine default unless overridden ( instead of defaulting to RG_OPAQUE )"

--- Holster
net.Receive( "GSWeapons-Holster", function()
	local pWeapon = net.ReadEntity()
	
	if ( pWeapon.SharedHolster and pWeapon.m_bDeployed ) then
		local pSwitchingTo = net.ReadEntity()
		pWeapon:SharedHolster( pSwitchingTo:EntIndex() == 0 and NULL or pSwitchingTo, true )
	end
end )

net.Receive( "GSWeapons-Holster animation", function()
	local pWeapon = net.ReadEntity()
	
	if ( pWeapon.HolsterAnim and not pWeapon.m_bHolsterAnim and pWeapon.m_bDeployed ) then
		local pSwitchingTo = net.ReadEntity()
		pWeapon:HolsterAnim( pSwitchingTo:EntIndex() == 0 and NULL or pSwitchingTo, true )
	end
end )

--- HUD/Visual
-- Bobbing affects all view models; individual view models can call CalcViewModelView
function SWEP:CalcViewModelView( vm, vPos, ang, vNewPos, aNew )
	vPos, ang = gsweapons.GetBobType( self.BobStyle )( self, vPos, ang, vNewPos, aNew )
	
	local iIndex = self:GetIronSights()
	local flZoomActive = self:GetZoomActiveTime()
	local flCurTime = CurTime()
	local bZooming = flZoomActive > flCurTime
	
	if ( iIndex == vm:ViewModelIndex() and not (bZooming and self.m_iIronSightsState == 0) ) then
		if ( self.m_iIronSightsState == 0 ) then
			self.m_iIronSightsState = 1
		end
		
		if ( self.m_iIronSightsState == 1 ) then
			if ( bZooming ) then
				local flProgress = (self:GetZoomActiveTime() - CurTime()) / self.IronSights.ZoomTime
				
				return vPos + self.IronSights.Pos * flProgress, ang + self.IronSights.Ang * flProgress
			end
			
			self.m_iIronSightsState = 2
		end
		
		if ( self.m_iIronSightsState == 2 ) then
			if ( not bZooming ) then
				return vPos + self.IronSights.Pos, ang + self.IronSights.Ang
			end
			
			self.m_iIronSightsState = 3
		end
		
		if ( bZooming ) then
			local flProgress = (self:GetZoomActiveTime() - CurTime()) / self.IronSights.ZoomTime
			
			return vPos + self.IronSights.Pos * flProgress, ang + self.IronSights.Ang * flProgress
		end
		
		self.m_iIronSightsState = 0
	end
	
	return vPos, ang
end

function SWEP:DoDrawCrosshair( x, y )
	return self.Zoom.DrawOverlay and self:GetZoomLevel() ~= 0 and not self:GetOwner():ShouldDrawLocalPlayer()
		and gsweapons.GetScope( self.ScopeStyle )( self, x, y ) or (self.IronSights.DrawCrosshair or self:GetIronSights() == 0)
		and gsweapons.GetCrosshair( self.CrosshairStyle )( self, x, y ) or true
end

function SWEP:FireAnimationEvent( vPos, ang, iEvent, sOptions )
	if ( self.EventStyle[iEvent] ) then
		return gsweapons.GetAnimEvent( iEvent, self.EventStyle[iEvent]:lower() )( self, vPos, ang, iEvent, sOptions )
	end
	
	DevMsg( 2, string.format( "%s (weapon_gs_base) Missing event %u: %s", self:GetClass(), iEvent, sOptions ))
end

function SWEP:DrawWeaponSelection( x, y, flWide, flTall )
	draw.SimpleText( self.SelectionIcon, self.SelectionFont, x + flWide / 2, y + flTall * 0.1, self.SelectionColor, TEXT_ALIGN_CENTER )
end

--- Utilities
function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
	self:DrawModel()
end

--- Accessors/Modifiers
function SWEP:GetMuzzleFlashScale()
	return self.MuzzleFlashScale
end

--- Player functions
net.Receive( "GSWeapons-Player DTVars", function(len, ply)
	timer.Create( "GSWeapons-Player DTVars", 0, 0, function()	
		local pPlayer = LocalPlayer()
		
		if ( pPlayer ~= NULL ) then
			pPlayer:InstallDataTable()
			pPlayer:SetupWeaponDataTables()
			timer.Remove( "GSWeapons-Player DTVars" )
		end
	end )
end )
