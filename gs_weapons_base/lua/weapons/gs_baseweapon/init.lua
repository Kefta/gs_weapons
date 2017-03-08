AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

if (game.SinglePlayer()) then
	util.AddNetworkString("GS-Weapons-Reload")
	util.AddNetworkString("GS-Weapons-Finish reload")
	util.AddNetworkString("GS-Weapons-Bipod deploy")
	util.AddNetworkString("GS-Weapons-Bipod deploy update")
end

--- Weapon behaviour
SWEP.DisableDuplicator = false -- Block spawning weapon with the duplicator

SWEP.Grenade.Class = "npc_grenade_frag" -- Grenade class to throw
SWEP.Grenade.Damage = 125 -- Damage value of the grenade
SWEP.Grenade.Radius = 250 -- Damage radius value of the grenade
SWEP.Grenade.Timer = 2.5 -- Grenade timer until detonation

SWEP.Inputs = { -- key = function(pWeapon, pActivator, pCaller, sData) end
	--[[hideweapon = function(pWeapon)
		if (pWeapon:IsActiveWeapon()) then
			for i = 0, self.ViewModelCount - 1 do
				pWeapon:SetHideWeapon(true, i)
			end
		end
	end,]]
	ammo = function(pWeapon, _, _, iValue)
		iValue = tonumber(iValue)
		
		if (iValue > 0) then
			-- https://github.com/Facepunch/garrysmod-requests/issues/703
			--pWeapon:SetPrimaryAmmoCount(wep:GetPrimaryAmmoCount() + iValue)
		end
	end
}

SWEP.KeyValues = {} -- key = function(pWeapon, sValue) end

--- Attack
local vHullMax = Vector(6, 6, 6)
local vHullMin = -vHullMax
local vRand = Vector(600, 0, 0)

-- From the HL2 frag
function SWEP:EmitGrenade()
	local tGrenade = self.Grenade
	local pGrenade = ents.Create(tGrenade.Class)
	
	if (pGrenade:IsValid()) then
		local pPlayer = self:GetOwner()
		local vEye = pPlayer:EyePos()
		local aEye = pPlayer:ActualEyeAngles()
		local vForward = aEye:Forward()
		local vSrc = vEye + vForward * 18 + aEye:Right() * 8
		vForward[3] = vForward[3] + 0.1
		
		local tr = util.TraceHull({
			start = vEye,
			endpos = vSrc,
			mins = vHullMin,
			maxs = vHullMax,
			mask = MASK_PLAYERSOLID,
			filter = pPlayer,
			collisiongroup = pPlayer:GetCollisionGroup()
		})
		
		if (tr.Fraction ~= 1 or tr.AllSolid or tr.StartSolid) then
			vSrc = tr.HitPos
		end
		
		pGrenade:SetPos(vSrc)
		pGrenade:SetOwner(pPlayer)
		pGrenade:Spawn()
		
		pGrenade:SetSaveValue("m_takedamage", 1)
		pGrenade:SetSaveValue("m_flDamage", tGrenade.Damage)
		pGrenade:SetSaveValue("m_DmgRadius", tGrenade.Radius)
		pGrenade:SetSaveValue("m_hThrower", pPlayer)
		--pGrenade:SetSaveValue("m_hOriginalThrower", pPlayer)
		pGrenade:Fire("SetTimer", tostring(tGrenade.Timer))
		
		local pPhysObj = pGrenade:GetPhysicsObject()
		
		if (pPhysObj:IsValid()) then
			pPhysObj:AddVelocity(pPlayer:_GetVelocity() + vForward * 1200)
			
			vRand[2] = code_gs.random:RandomInt(-1200, 1200)
			pPhysObj:AddAngleVelocity(vRand)
		end
	end
	
	return pGrenade 
end

--- Hooks
function SWEP:AcceptInput(sName, pActivator, pCaller, sData)
	local fInput = self.Inputs[sName:lower()]
	
	if (fInput) then
		fInput(self, pActivator, pCaller, sData)
	else
		code_gs.DevMsg(1, string.format("%s (gs_baseweapon) Unhandled input %q", self:GetClass(), sName))
	end
end

function SWEP:KeyValue(sKey, sValue)
	local fInput = self.KeyValues[string.lower(sKey)]
	
	if (fInput) then
		return fInput(self, sValue)
	end
	
	code_gs.DevMsg(1, string.format("%s (gs_baseweapon) Unhandled key-value %q %q", self:GetClass(), sKey, sValue))
	
	return false
end

--- Accessors/Modifiers
function SWEP:GetCapabilities()
	return bit.bor(CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1)
end
