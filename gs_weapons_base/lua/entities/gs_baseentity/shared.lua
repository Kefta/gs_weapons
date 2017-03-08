-- http://wiki.garrysmod.com/page/Structures/ENT
-- FIXME: Update the Precache sound structure and PlaySound
-- Also remove the NWVar if possible

--ENT.Base = "gs_baseentity" -- This is NOT the superclass. Let base_anim/base_entity handle it's default implementation
ENT.NoTranslateBase = false -- Don't translate the base string when loading weapons with RegisterEntitiesFromFolder

ENT.PrintName = "GSBase" -- Display name
ENT.Author = "code_gs" -- Displayed on entity selection panel
ENT.Spawnable = false -- Displays the entity in the spawn menu. This must be defined in every entity!
ENT.AdminOnly = false -- Restricts entity spawning to admin+
ENT.Type = "anim" -- Entity type: anim, brush, point, ai, nextbot, or filter
ENT.Editable = false -- Can entity keys be edited: http://wiki.garrysmod.com/page/Editable_Entities
ENT.Model = "" -- Entity model; leave as "" to not set a model

ENT.Sounds = {-- Default sound events
	--["sound1"] = "sound.wav",
	--[["sound2"] = {
		channel = CHAN_STATIC,
		pitch = {50, 100},
		sound = "sound2.wav"
	}]]
}

local sm_tPrecached = {} -- Persists through all entity instances -- acts like static keyword in C++

function ENT:Initialize()
	if (self.m_bInitialized) then
		return
	end
	
	local sClass = self:GetClass()
	code_gs.DevMsg(2, sClass .. " (gs_baseentity) Initialize")
	
	self.m_bInitialized = true
	self.m_tEvents = {}
	self.m_tEventHoles = {}
	self.m_tRemovalQueue = {}
	
	if (not sm_tPrecached[sClass]) then
		sm_tPrecached[sClass] = true
		self:Precache()
	end
	
	local sModel = self.Model
	
	if (sModel ~= "") then
		self:SetModel(sModel)
	end
end

function ENT:Precache()
	local sClass = self:GetClass()
	local tEnt = scripted_ents.GetStored(sClass)
	code_gs.DevMsg(2, sClass .. " (gs_baseentity) Precache")
	
	if (CLIENT and self.KillIcon ~= '') then
		-- Add KillIcon
		killicon.AddFont(sClass, self.KillIconFont, self.KillIcon, self.KillIconColor)
	end
	
	-- Precache entity model
	util.PrecacheModel(self.Model)
	
	-- Setup and precache all entity sounds
	for k, s in pairs(self.Sounds) do
		if (k ~= "BaseClass") then -- Stupid pseudo-inheritance
			-- Register sound table
			if (istable(s)) then
				if (s.sound) then
					if (not s.name) then
						s.name = sClass .. "." .. k
					end
					
					sound.Add(s)
					self.Sounds[k] = s.name
					tEnt.Sounds[k] = s.name
					util.PrecacheSound(s.name)
				else
					sound.Add({
						name = sClass .. "." .. k,
						channel = CHAN_ITEM,
						sound = s
					})
				end
			-- Create a new sound table from a file
			elseif (string.IsSoundFile(s)) then
				local sName = sClass .. "." .. k
				
				sound.Add({
					name = sName,
					channel = CHAN_ITEM,
					sound = s
				})
				
				self.Sounds[k] = sName
				tEnt.Sounds[k] = sName
				util.PrecacheSound(sName)
			-- Assume the sound table already exists
			else
				util.PrecacheSound(s)
			end
		end
	end
end

function ENT:SetupDataTables()
	self:AddNWVar("Float", "NextItemFrame")
end

function ENT:OnRemove()
	code_gs.DevMsg(2, self:GetClass() .. " (gs_baseentity) Remove")
end

function ENT:Think()
	-- Fixes clientside not initializing on occasion
	if (not self.m_bInitialized) then
		self:Initialize()
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
	
	local flNextThink = self:GetNextItemFrame()
	
	if (flNextThink ~= -1 and flNextThink <= flCurTime) then
		self:ItemFrame()
	end
end

-- Normal think function replacement
function ENT:ItemFrame()
end

function ENT:AddEvent(sName, iTime, fCall, bNoPrediction)
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

function ENT:EventActive(sName, bNoPrediction)
	sName = sName:lower()
	
	return self.m_tEvents[sName] ~= nil and (bNoPrediction or IsFirstTimePredicted() or self.m_tEvents[sName][4])
end

function ENT:RemoveEvent(sName, bNoPrediction)
	if (bNoPrediction) then
		self.m_tEvents[sName:lower()] = nil
	else
		self.m_tRemovalQueue[sName:lower()] = true
	end
end

function ENT:AddNWVar(sType, sName, bAddFunctions --[[= true]], DefaultVal --[[= nil]])
	-- Initialize could be skipped clientside
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

function ENT:LookupSound(sName)
	return self.Sounds[sName] or ""
end

function ENT:PlaySound(sName)
	self:EmitSound(self:LookupSound(sName))
end
