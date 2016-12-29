include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("GSWeapons-Detonate")

ENT.CanPickup = true

ENT.DetonateOnDamage = false

local BaseClass = baseclass.Get(ENT.Base)

function ENT:Use(pActivator, pCaller, nUseType, flValue)
	if (not self.m_bDetonated) then -- Pickup only if the grenade hasn't been detonated
		BaseClass.Use(self, pActivator, pCaller, nUseType, flValue)
	end
	
	if (not self:EventActive("detonate")) then
		self:StartDetonation()
	end
end

function ENT:OnTakeDamage(info)
	if (self.DetonateOnDamage and info:GetDamage() > 0) then
		self:Detonate()
		
		if (code_gs.weapons.DetonationNetworked(self.DetonationType)) then
			net.Start("GSWeapons-Detonate")
				net.WriteEntity(self)
			net.Broadcast()
		end
	end
end

function ENT:StartDetonation(flTime --[[= 2.5]])
	self:AddEvent("detonate", flTime or 2.5, function()
		local bRet = self:Detonate()
		
		if (code_gs.weapons.DetonationNetworked(self.DetonationType)) then
			net.Start("GSWeapons-Detonate")
				net.WriteEntity(self)
			net.Broadcast()
		end
		
		return bRet
	end)
end
