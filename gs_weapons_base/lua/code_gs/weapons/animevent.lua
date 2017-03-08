local Empty = function() end
local ReturnTrue = function() return true end
local tAnimEvents = {}

function code_gs.weapons.RegisterAnimEvent(Events, sName, func)	
	if (isnumber(Events)) then
		local tEvent = tAnimEvents[Events]
		
		if (not tEvent) then
			tEvent = {}
			tAnimEvents[Events] = tEvent
		end
		
		tEvent[sName:lower()] = func
	else
		for i = 1, #Events do
			local iEvent = Events[i]
			local tEvent = tAnimEvents[iEvent]
			
			if (not tEvent) then
				tEvent = {}
				tAnimEvents[iEvent] = tEvent
			end
			
			tEvent[sName:lower()] = func
		end
	end
end

function code_gs.weapons.GetAnimEvent(iEvent, sName)
	if (sName == "") then
		return ReturnTrue
	end
	
	local tEvent = tAnimEvents[iEvent]
	
	if (tEvent) then
		return tEvent[sName:lower()] or Empty
	end
	
	return Empty
end

if (SERVER) then
	code_gs.weapons.RegisterAnimEvent(3015, "hl2_357", function(pWeapon)
		local vWorld = pWeapon:GetOwner():WorldSpaceCenter()
		local aRand = Angle(90, 0, 0)
		local data = EffectData()
			data:SetEntIndex(pWeapon:EntIndex())
		
		// Emit six spent shells
		for i = 1, 6 do
				data:SetOrigin(vWorld + VectorRand(-4, 4))
				aRand[2] = code_gs.random:RandomInt(0, 360)
				data:SetAngles(aRand)
			util.Effect("ShellEject", data)
		end	
		
		return true
	end)
else
	local sSep = string.char(32)
	local cRep = string.char(173)

	code_gs.weapons.RegisterAnimEvent(20, "css", function(pWeapon, _, _, _, sOptions)
		local aEyes = pWeapon:GetOwner():EyeAngles()
		local tOptions = sSep:Explode(sOptions)
		local sEffect = tOptions[1]
		
		if (sEffect) then
			-- https://github.com/Facepunch/garrysmod-issues/issues/2789
			local iReplace = sEffect:find(cRep, 1, true)
			
			if (iReplace) then
				sEffect = sEffect:sub(1, iReplace - 1) .. "_" .. sEffect:sub(iReplace + 1)
			end
		else
			sEffect = "EjectBrass_9mm"
		end
		
		local data = EffectData()
			data:SetOrigin(pWeapon:GetAttachment(tOptions[2] and tonumber(tOptions[2]) or pWeapon:GetMuzzleAttachment()).Pos)
			data:SetAngles((aEyes:Right() * 100 + aEyes:Up() * 20):Angle())
			data:SetFlags(tOptions[3] and tonumber(tOptions[3]) or 120) -- Velocity
		util.Effect(sEffect, data)
		
		return true
	end)
	
	code_gs.weapons.RegisterAnimEvent({5001, 5011, 5021, 5031}, "css", function(pWeapon, _, _, iEvent)
		if (not pWeapon:GetSilenced() and (not pWeapon.Zoom.DrawOverlay or pWeapon:GetZoomLevel() == 0)) then
			local data = EffectData()
				data:SetEntity(pWeapon:GetOwner():GetViewModel(0))
				data:SetAttachment(pWeapon:GetMuzzleAttachment(iEvent)) -- FIXME: Wrong position flipped?
				data:SetScale(pWeapon.MuzzleFlashScale)
			util.Effect("CS_MuzzleFlash", data)
		end
		
		return true
	end)
	
	code_gs.weapons.RegisterAnimEvent({5001, 5011, 5021, 5031}, "css_x", function(pWeapon, _, _, iEvent)
		if (not pWeapon:GetSilenced() and (not pWeapon.Zoom.DrawOverlay or pWeapon:GetZoomLevel() == 0)) then
			local data = EffectData()
				data:SetEntity(pWeapon:GetOwner():GetViewModel(0))
				data:SetAttachment(pWeapon.MuzzleFlashScale)
				data:SetScale(pWeapon:GetMuzzleFlashScale())
			util.Effect("CS_MuzzleFlash_X", data)
		end
		
		return true
	end)

	code_gs.weapons.RegisterAnimEvent({5003, 5013, 5023, 5033}, "css", function(pWeapon, _, _, iEvent)
		if (not pWeapon:GetSilenced()) then
			local dlight = DynamicLight(0x40000000 + pWeapon:GetOwner():EntIndex())
			dlight.pos = pWeapon:GetAttachment(pWeapon:GetMuzzleAttachment(iEvent)).Pos
			dlight.size = 70
			dlight.decay = 1400 --dlight.size / 0.05
			dlight.dietime = CurTime() + 0.05
			dlight.r = 255
			dlight.g = 192
			dlight.b = 64
			dlight.style = 5
		end
		
		return true
	end)
	
	code_gs.weapons.RegisterAnimEvent(7001, "css_c4", function(pWeapon, _, _, _, sOptions)
		pWeapon.m_sScreenText = sOptions:sub(1, 16) -- Only take 16 characters
	end)
end
