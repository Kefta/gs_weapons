-- FIXME: add set model hook and fix UsesHands
AddCSLuaFile()

ENT.Base = "gs_baseentity"

if (CLIENT) then
	ENT.RenderGroup = RENDERGROUP_OTHER
end

local BaseClass = baseclass.Get(ENT.Base)

function ENT:Initialize()
	BaseClass.Initialize(self)
	
	self:SetNotSolid(true)
	self:DrawShadow(false)
	self:SetTransmitWithParent(true)
	self:SetMoveType(MOVETYPE_NONE)
end

function ENT:DoSetup(pPlayer, iIndex --[[= 0]])
	local pViewModel = pPlayer:GetViewModel(iIndex)
	
	if (pViewModel:IsValid()) then
		self:SetParent(pViewModel)
		self:SetOwner(pPlayer)
		
		self:SetPos(vector_origin)
		self:SetAngles(angle_zero)
		
		self:SetNWVar("Index", iIndex)
		
		pViewModel:DeleteOnRemove(self)
		pPlayer:DeleteOnRemove(self)
	elseif (SERVER) then
		self:Remove()
	end
end

if (CLIENT) then
	local function DrawModel(self)
		local pPlayer = self:GetOwner()
		
		if (pPlayer:IsValid()) then
			local pActiveWeapon = pPlayer:GetActiveWeapon()
			
			if (pActiveWeapon.GSWeapon and pActiveWeapon:UsesHands(self:GetNWVar("Index", 0))) then
				local tHands = player_manager.TranslatePlayerHands(pPlayer:GetModel())
				self:SetModel(tHands.model)
				self:SetSkin(tHands.skin)
				self:SetBodyGroups(tHands.body)
				
				self:DrawModel()
			end
		end
	end

	ENT.Draw = DrawModel
	ENT.DrawTranslucent = DrawModel
end
