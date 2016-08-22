-- http://wiki.garrysmod.com/page/Structures/ENT
AddCSLuaFile()

--ENT.Base = "gs_baseentity" -- This is the superclass
ENT.PrintName = "GS_BaseEntity" -- Display name
ENT.Spawnable = false -- Displays the entity in the spawn menu. This must be defined in every entity!
ENT.AdminOnly = false -- Restricts entity spawning to admin+
ENT.Type = "anim" -- Entity type: anim, brush, point, ai, nextbot, or filter
ENT.Editable = false -- Can entity keys be edited: http://wiki.garrysmod.com/page/Editable_Entities
ENT.Model = "" -- Entity model; leave as "" to not set a model

ENT.Sounds = { -- Default sound events
	--["sound1"] = "sound.wav",
	--[["sound2"] = {
		channel = CHAN_STATIC,
		pitch = { 50, 100 },
		sound = "sound2.wav"
	}]]
}

if ( CLIENT ) then
	ENT.Author = "code_gs and Valve" -- Displayed on entity selection panel
	ENT.Category = "Source" -- Category in the spawn menu the entity should appear in. This must be defined in every entity!
	ENT.AutomaticFrameAdvance = false -- Advances animation frames - set to true for animated entities
	--ENT.RenderGroup = RENDERGROUP_OPAQUE -- April 2016: "RenderGroup of SENTs and SWEPs is now defaulted to engine default unless overridden ( instead of defaulting to RG_OPAQUE )"
else
	ENT.DisableDuplicator = false -- Should the entity not be copied with the duplicator tool
	ENT.CanPickup = false -- Can the entity be picked up
end

local static_precached = {} -- Persists through all entity instances -- acts like static keyword in C++

function ENT:Initialize()
	local sClass = self:GetClass()
	DevMsg( 2, sClass .. " (gs_baseentity) Initialize" )
	
	self.m_tEvents = {}
	self.m_tEventHoles = {}
	
	if ( not static_precached[sClass] ) then
		static_precached[sClass] = true
		self:Precache()
	end
	
	local sModel = self.Model
	
	if ( sModel ~= "" ) then
		self:SetModel( sModel )
	end
end

function ENT:Precache()
	local sClass = self:GetClass()
	local tEnt = scripted_ents.GetStored( sClass )
	DevMsg( 2, sClass .. " (gs_baseentity) Precache" )
	
	-- Precache entity model
	util.PrecacheModel( self.Model )
	
	-- Setup and precache all entity sounds
	for k, s in pairs( self.Sounds ) do
		if ( k ~= "BaseClass" ) then -- Stupid pseudo-inheritance
			-- Register sound table
			if ( istable( s )) then
				if ( not s.name ) then
					s.name = sClass .. "." .. k
				end
				
				sound.Add( s )
				self.Sounds[k] = s.name
				tEnt.Sounds[k] = s.name
				util.PrecacheSound( s.name )
			-- Create a new sound table from a file
			elseif ( string.IsSoundFile( s )) then
				local sName = sClass .. "." .. k
				
				sound.Add({
					name = sName,
					channel = CHAN_ITEM,
					sound = s
				})
				
				self.Sounds[k] = sName
				tEnt.Sounds[k] = sName
				util.PrecacheSound( sName )
			-- Assume the sound table already exists
			else
				util.PrecacheSound( s )
			end
		end
	end
end

function ENT:SetupDataTables()
	self:DTVar( "Float", 0, "NextThink" )
end

function ENT:OnRemove()
	DevMsg( 2, self:GetClass() .. " (gs_baseentity) Remove" )
end

function ENT:Think()
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
	
	local flNextThink = self:GetNextThink()
	
	if ( flNextThink ~= -1 and flNextThink <= flCurTime ) then
		self:ItemFrame()
	end
end

-- Normal think function replacement
function ENT:ItemFrame()
end

function ENT:AddEvent( sName, iTime, fCall )
	-- Do not add to the event table multiple times
	if ( IsFirstTimePredicted() ) then
		if ( fCall ) then
			self.m_tEvents[sName] = { iTime, CurTime() + iTime, fCall }
		else
			self.m_tEvents[next( self.m_tEventHoles ) or #self.m_tEvents] = { sName, CurTime() + sName, iTime }
		end
	end
end

function ENT:EventActive( sName )
	return self.m_tEvents[sName] ~= nil
end

function ENT:RemoveEvent( sName )
	self.m_tEvents[sName] = nil
end

function ENT:LookupSound( sName )
	return self.Sounds[sName] or ""
end

function ENT:PlaySound( sName )
	self:EmitSound( self:LookupSound( sName ))
end

function ENT:GetNextThink()
	return self.dt.NextThink
end

function ENT:SetNextThink( flTime )
	self.dt.NextThink = flTime
end

if ( SERVER ) then
	function ENT:Use( _, pCaller )
		if ( self.CanPickup and pCaller:IsPlayer() and not self:IsPlayerHolding() ) then
			pCaller:PickupObject( self )
		end
	end
end
