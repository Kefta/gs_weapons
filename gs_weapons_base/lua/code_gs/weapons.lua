if (code_gs.weapons) then return end -- No auto-refresh here

-- Here's why these overwrites are needed:
-- https://github.com/garrynewman/garrysmod/pull/1261
-- https://github.com/garrynewman/garrysmod/pull/1299
-- https://github.com/garrynewman/garrysmod/pull/1307
code_gs.weapons = {}

local function DeepCopy(tbl)
	local tCopy = {}
	setmetatable(tCopy, debug.getmetatable(tbl))
	
	for k, v in pairs(tbl) do
		if (istable(v)) then
			tCopy[k] = DeepCopy(v)
		elseif (isvector(v)) then
			tCopy[k] = Vector(v)
		elseif (isangle(v)) then
			tCopy[k] = Angle(v)
		--[[elseif (ismatrix(v)) then
			tCopy[k] = Matrix(v)]]
		else
			tCopy[k] = v
		end
	end
	
	return tCopy
end

do
	--[[local Aliases = {}

	function weapons.Alias( From, To )

		Alias[ From ] = To

	end]]

	function weapons.Get( name )

		local Stored = weapons.GetStored( name )

		if ( !Stored ) then
			return nil
		end

		-- Create/copy a new table
		local retval = DeepCopy( Stored )

		if ( !retval.Base ) then
			retval.Base = "weapon_base"
		end

		-- If we're not derived from ourselves (a base weapon)
		-- then derive from our 'Base' weapon.
		if ( retval.Base != name ) then
			local BaseWeapon = weapons.Get( retval.Base )

			if ( BaseWeapon ) then
				for k, v in pairs( BaseWeapon ) do
					if ( retval[ k ] == nil ) then
						retval[ k ] = v
					elseif ( k != "BaseClass" && istable( retval[ k ] ) && istable( v ) ) then
						table.InheritNoBaseClass( retval[ k ], v )
					end
				end

				retval[ "BaseClass" ] = BaseWeapon
			else
				MsgN( "SWEP (", name, ") is derived from non-existant SWEP (", retval.Base, ") - expect errors!" )
			end
		end

		return retval

	end
end

do
	local Aliases = {}

	function scripted_ents.Alias( From, To )

		Aliases[ From ] = To

	end

	function scripted_ents.Get( name )

		local Stored

		-- Do we have an alias?
		if ( Aliases[ name ] ) then
			local newname = Aliases[ name ]
			Stored = scripted_ents.GetStored( newname )

			if ( Stored ) then
				-- Update the name
				name = newname
			else
				-- Try the original name
				Stored = GetStored( name )
			end
		else
			Stored = scripted_ents.GetStored( name )
		end

		if ( !Stored ) then
			return nil
		end

		-- Create/copy a new table
		local retval = DeepCopy( Stored.t )
		retval.Base = Stored.Base

		-- Derive from base class
		if ( retval.Base != name ) then
			local BaseEntity = scripted_ents.Get( retval.Base )

			if ( BaseEntity ) then
				for k, v in pairs( BaseEntity ) do
					if ( retval[ k ] == nil ) then
						retval[ k ] = v
					elseif ( k != "BaseClass" && istable( retval[ k ] ) && istable( v ) ) then
						table.InheritNoBaseClass( retval[ k ], v )
					end
				end

				retval[ "BaseClass" ] = BaseEntity
			else
				MsgN( "SENT (", name, ") is derived from non-existant SENT (", retval.Base, ") - expect errors!" )
			end
		end

		return retval

	end
end

-- Grenade throw type enums
code_gs.weapons.GRENADE_THROW = 1
code_gs.weapons.GRENADE_TOSS = 2
code_gs.weapons.GRENADE_LOB = 3
code_gs.weapons.GRENADE_COUNT = 4 -- Number of throw types

code_gs.weapons.DefaultTypeVal = {
	Bool = false,
	Int = 0,
	Float = 0,
	Angle = angle_zero,
	Vector = vector_origin,
	String = "",
	Entity = NULL
}

function code_gs.weapons.GetNWVar(self, sType, sName, Fallback --[[= nil]])
	return self["GetNW2" .. sType](self, "GS-Weapons-" .. sName, Fallback)
end

function code_gs.weapons.SetNWVar(self, sType, sName, Val)
	self["SetNW2" .. sType](self, "GS-Weapons-" .. sName, Val)
end

function code_gs.weapons.SetNWProxy(self, sName, func)
	self:SetNWVarProxy("GS-Weapons-" .. sName, func)
end

if (SERVER) then
	-- There's no way to tell on the server if the engine is in prediction :(
	function code_gs.weapons.SetPredictedVar(self, sName, Val)
		self[sName] = Val
		self[sName .. "-SETUP"] = true
	end
	
	function code_gs.weapons.GetPredictedVar(self, sName, Default)
		if (self[sName .. "-SETUP"]) then
			return self[sName]
		end
		
		return Default
	end
else
	function code_gs.weapons.InPrediction()
		return CurTime() ~= UnPredictedCurTime()
	end
	
	local MAX_STORED_PREDICTIONS = 16
	
	function code_gs.weapons.GetPredictedVar(self, sName, Default)
		local iLen = self[sName .. "-COUNT"]
		
		if (iLen == nil) then
			return Default
		end
		
		-- Raw value
		if (iLen == 0 or IsFirstTimePredicted()) then
			return self[sName]
		end
		
		local flUnPredictedCurTime = UnPredictedCurTime()
		
		-- Something has been set this prediction run
		if (self[sName .. "-PREDTIME"] == flUnPredictedCurTime) then
			return self[sName .. "-PREDVAL"]
		end
		
		local flCurTime = CurTime()
		
		-- Not in prediction
		if (flUnPredictedCurTime == flCurTime) then
			return self[sName]
		end
		
		local tProxy = self[sName .. "-PROXY"]
		
		for i = 1, iLen do
			if (tProxy[i] >= flCurTime) then
				return self[sName .. "-PREV"][i]
			end
		end
		
		return self[sName]
	end
	
	function code_gs.weapons.SetPredictedVar(self, sName, Val)
		if (self[sName .. "-COUNT"] == nil) then
			self[sName] = Val
			self[sName .. "-PREV"] = {}
			self[sName .. "-PROXY"] = {}
			self[sName .. "-PREDVAL"] = Val
			self[sName .. "-PREDTIME"] = 0
			self[sName .. "-COUNT"] = 0
		end
		
		local flCurTime = CurTime()
		local flUnPredictedCurTime = UnPredictedCurTime()
		
		if (IsFirstTimePredicted() or flUnPredictedCurTime == flCurTime) then
			local iLen = self[sName .. "-COUNT"]
			local tProxy = self[sName .. "-PROXY"]
			
			if (tProxy[iLen] ~= flCurTime) then
				local tPrev = self[sName .. "-PREV"]
				
				-- Garbage collection
				if (iLen == MAX_STORED_PREDICTIONS) then
					-- Remove the oldest value
					table.remove(tPrev, 1)
					table.remove(tProxy, 1)
				else
					iLen = iLen + 1
					self[sName .. "-COUNT"] = iLen
				end
				
				tPrev[iLen] = self[sName]
				tProxy[iLen] = flCurTime
			end
			
			self[sName] = Val
		else
			self[sName .. "-PREDVAL"] = Val
			self[sName .. "-PREDTIME"] = flUnPredictedCurTime
		end
	end
end

function code_gs.weapons.PredictedAccessorFunc(self, bNetworked, sType, sName, Default --[[= code_gs.weapons.DefaultTypeVal[sType]], bIndexed --[[= false]])
	local DefaultType = code_gs.weapons.DefaultTypeVal[sType]
	
	if (DefaultType == nil) then
		error("Entity \"" .. tostring(self) .. "\" attempted to declare invalid network type \"" .. sType .. "\"\n" ..
			"If you are using a custom NW type function, make sure to add a default case to code_gs.weapons.DefaultTypeVal")
	end
	
	if (Default == nil) then
		Default = DefaultType
	end
	
	if (bIndexed) then
		if (bNetworked) then
			self["Get" .. sName] = function(self, iIndex) return code_gs.weapons.GetNWVar(self, sType, sName .. (iIndex or 0), Default) end
			self["Set" .. sName] = function(self, Val, iIndex) code_gs.weapons.SetNWVar(self, sType, sName .. (iIndex or 0), Val) end
		else
			self["Get" .. sName] = function(self, iIndex) return code_gs.weapons.GetPredictedVar(self, sName .. (iIndex or 0), Default) end
			self["Set" .. sName] = function(self, Val, iIndex) code_gs.weapons.SetPredictedVar(self, sName .. (iIndex or 0), Val) end
		end
	elseif (bNetworked) then
		self["Get" .. sName] = function(self) return code_gs.weapons.GetNWVar(self, sType, sName, Default) end
		self["Set" .. sName] = function(self, Val) code_gs.weapons.SetNWVar(self, sType, sName, Val) end
	else
		self["Get" .. sName] = function(self) return code_gs.weapons.GetPredictedVar(self, sName, Default) end
		self["Set" .. sName] = function(self, Val) code_gs.weapons.SetPredictedVar(self, sName, Val) end
	end
end

do
	local WEAPON = FindMetaTable("Weapon")
	
	-- https://github.com/Facepunch/garrysmod-requests/issues/825
	if (not WEAPON.SetLastShootTime) then
		WEAPON.SetLastShootTime = function() end
	end
end

if (CLIENT) then
	surface.CreateFont("HL2KillIcon", {font = "HL2MP", size = ScreenScale(30), weight = 500, additive = true})
	surface.CreateFont("HL2Selection", {font = "HalfLife2", size = ScreenScale(120), weight = 500, additive = true})
	surface.CreateFont("CSSKillIcon", {font = "csd", size = ScreenScale(30), weight = 500, additive = true})
	surface.CreateFont("CSSSelection", {font = "cs", size = ScreenScale(120), weight = 500, additive = true})
end

local tLangChange = {}

cvars.AddChangeCallback("gmod_language", function()
	timer.Simple(0, function() -- Let all of the languages repopulate first
		for _, v in pairs(tLangChange) do
			v.PrintName = code_gs.GetPhrase(v.UntranslatedPrintName)
		end
		
		local tEnts = ents.GetAll()
		
		for i = 1, #tEnts do
			local tbl = tLangChange[tEnts[i]:GetClass()]
			
			if (tbl) then
				tEnts[i].PrintName = code_gs.GetPhrase(tbl.UntranslatedPrintName)
			end
		end
	end)
end)
			

local function SetupVariables(tbl, sClass, sBase, sCategory, sPrefix)
	if (CLIENT and not tbl.Category) then
		tbl.Category = sCategory
	end
	
	tbl.ClassName = sPrefix .. "_" .. sClass
	
	if (not tbl.Base) then
		tbl.Base = sBase
	elseif (sPrefix) then
		local sCurrentBase = tbl.Base:lower()
		
		if (not (tbl.NoTranslateBase or sCurrentBase == sBase)) then
			tbl.Base = sPrefix .. "_" .. sCurrentBase
		end
	end
	
	if (not tbl.PrintName) then
		tbl.UntranslatedPrintName = sPrefix and (sPrefix .. "_" .. sClass) or sClass
		tbl.PrintName = code_gs.GetPhrase(tbl.UntranslatedPrintName)
		tLangChange[tbl.ClassName] = tbl
	end
end

local GLOBALENV = {
	_G = _G,
	__index = function(t, k)
		local ret = rawget(t, k)
		
		if (ret == nil) then
			return _G[k]
		end
		
		return ret
	end,
	__newindex = function(t, k, v)
		_G[k] = v -- Setting globals still works
	end
}

local function Register(tEnv, sPath, fCallback)
	if (sPath[#sPath] ~= '/') then
		sPath = sPath .. "/"
	end
	
	local tFiles, tFolders = file.Find(sPath .. "*", "LUA")
	
	for i = 1, #tFiles do
		local sFile = tFiles[i]:lower()
		
		if (sFile:sub(-4) == ".lua") then
			local func = code_gs.SafeCompile(sPath .. tFiles[i]) -- Don't use lower-case version for inclusion (Linux)
			
			if (func) then
				-- Don't bother sending it if the server isn't going to register it
				if (SERVER) then
					AddCSLuaFile(sPath .. tFiles[i])
				end
				
				local tEnv = setmetatable(DeepCopy(tEnv), GLOBALENV)
				tEnv._ENV = tEnv
				setfenv(func, tEnv)
				
				if (func() ~= true) then
					fCallback(tEnv, sFile:sub(1, -5))
				end
			end
		end
	end
	
	for i = 1, #tFolders do
		local sPath = sPath .. tFolders[i] .. "/"
		local tFiles = file.Find(sPath .. "*.lua", "LUA")
		
		local tEnv = setmetatable(DeepCopy(tEnv), GLOBALENV)
		tEnv._ENV = tEnv
		
		local bRegister = true
		
		-- We have to loop to take case-sensativity into account
		for i = 1, #tFiles do
			if (tFiles[i]:lower() == (SERVER and "init.lua" or "cl_init.lua")) then
				local func = code_gs.SafeCompile(sPath .. tFiles[i])
				
				if (func) then
					setfenv(func, tEnv)
					
					if (func() == true) then
						bRegister = false -- This would be a good place for goto
					end
				end
				
				break
			end
		end
		
		if (bRegister) then
			fCallback(tEnv, tFolders[i]:lower())
		end
		
		bRegister = true
	end
end

local tSWEPEnv = {
	SWEP = {
		Primary = {},
		Secondary = {}
	},
	BaseClass = {},
	-- Do this here so that GLOBALENV's __index doesn't have to search three places
	include = code_gs.EnvironmentInclude,
	AddCSLuaFile = code_gs.EnvironmentAddCSLuaFile,
	CompileFile = code_gs.EnvironmentCompile
}

function code_gs.weapons.RegisterWeaponsFromFolder(sPath, sCategory, sPrefix)
	Register(tSWEPEnv, sPath, function(tEnv, sClass)
		local SWEP = tEnv.SWEP
		SetupVariables(SWEP, SWEP.ClassName and SWEP.ClassName:lower() or sClass, "gs_baseweapon", sCategory, sPrefix)
		
		if (SWEP.Base == SWEP.ClassName) then
			tEnv.BaseClass = {}
		else
			tEnv.BaseClass = baseclass.Get(SWEP.Base)
		end
		
		weapons.Register(SWEP, SWEP.ClassName)
	end)
end

local tENTEnv = {
	ENT = {},
	BaseClass = {},
	include = code_gs.EnvironmentInclude,
	AddCSLuaFile = code_gs.EnvironmentAddCSLuaFile,
	CompileFile = code_gs.EnvironmentCompile
}

function code_gs.weapons.RegisterEntitiesFromFolder(sPath, sCategory, sPrefix)
	Register(tENTEnv, sPath, function(tEnv, sClass)
		local ENT = tEnv.ENT
		SetupVariables(ENT, ENT.ClassName and ENT.ClassName:lower() or sClass, "gs_baseentity", sCategory, sPrefix)
		
		if (ENT.Base == ENT.ClassName) then
			tEnv.BaseClass = {}
		else
			tEnv.BaseClass = baseclass.Get(ENT.Base)
		end
		
		scripted_ents.Register(ENT, ENT.ClassName)
	end)
end

function code_gs.weapons.GetEntityPrintName(pEntity)
	return pEntity.GetPrintName and pEntity:GetPrintName() or pEntity.PrintName or pEntity:GetClass()
end
