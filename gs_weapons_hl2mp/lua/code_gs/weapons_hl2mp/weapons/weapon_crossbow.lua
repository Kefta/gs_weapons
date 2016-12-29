SWEP.Base = "weapon_hl2mp_base"

SWEP.Spawnable = true
SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.ViewModel = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.HoldType = "crossbow"

SWEP.Weight = 6

SWEP.Activities = {
	idle_empty = ACT_VM_FIDGET
}

SWEP.Sounds = {
	shoot = "Weapon_Crossbow.Single",
	reload = "Weapon_Crossbow.Reload"
	-- "Weapon_Crossbow.BoltElectrify"
	-- "Weapon_Crossbow.BoltFly"
}

SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Damage = 100
SWEP.Primary.PunchAngle = Angle(-2, 0, 0)

SWEP.Secondary.Automatic = false

SWEP.Zoom = {
	FOV = {
		20
	},
	Times = {
		[0] = 0.2,
		0.1
	},
	Levels = 1,
	Cooldown = 0,
	UnzoomOnReload = false
}

SWEP.Bolt = {
	WaterVelocity = 1500,
	AirVelocity = 3500,
	Attachment = 1,
	SpriteMaterial = "sprites/blueflare1.vmt",
	DieTime = 0.25
}

if (CLIENT) then
	SWEP.SelectionIcon = 'g'
	SWEP.KillIcon = 'g'
end

local nSpriteFlags = bit.bor(EFL_DIRTY_SPATIAL_PARTITION, EFL_DIRTY_SURROUNDING_COLLISION_BOUNDS)
-- Fixme: add as separate method and make all of this viewmodel independent
function SWEP:PrimaryAttack()
	if (not self:CanPrimaryAttack(0)) then
		return false
	end
	
	local pPlayer = self:GetOwner()
	local bSecondary = self:SpecialActive(0)
	
	if (SERVER) then
		local aShoot = self:GetShootAngles(bSecondary)
		local pBolt = ents.Create("crossbow_bolt")
		
		if (pBolt ~= NULL) then
			pBolt:SetPos(self:GetShootSrc(bSecondary))
			pBolt:SetAngles(aShoot)
			pBolt:SetOwner(pPlayer)
			pBolt:_SetAbsVelocity(aShoot:Forward() * (pPlayer:WaterLevel() == 3 and self.Bolt.WaterVelocity or self.Bolt.AirVelocity))
			pBolt:Spawn()
			--pBolt.m_iDamage = self:GetSpecialKey("Damage", bSecondary) FIXME
		end
	end
	
	local pViewModel = pPlayer:GetViewModel(0)
	
	if (pViewModel ~= NULL) then
		pViewModel:SetSkin(0)
		
		local data = EffectData()
			data:SetEntity(pViewModel)
			data:SetAttachment(self.Bolt.Attachment)
			
			if (SERVER) then
				data:SetEntIndex(pViewModel:EntIndex())
			end
			
		util.Effect("CrossbowLoad", data)
		
		if (SERVER) then
			local pBlast = ents.Create("env_sprite")
			
			if (pBlast ~= NULL) then
				pBlast:SetModelName(self.Bolt.SpriteMaterial)
				pBlast:SetPos(self:GetPos())
				pBlast:Spawn()
				pBlast:SetSolid(SOLID_NONE)
				pBlast:SetCollisionBounds(vector_origin, vector_origin)
				pBlast:SetMoveType(MOVETYPE_NONE)
				pBlast:SetAttachment(pViewModel, self.Bolt.Attachment)
				pBlast:SetRenderMode(RENDERMODE_TRANSADD)
				pBlast:SetSaveValue("m_flScaleTime", 0)
				pBlast:SetSaveValue("m_flSpriteScale", 0.2) -- Fix; this or "scale"?
				pBlast:SetSaveValue("m_flBrightnessTime", 0)
				pBlast:SetSaveValue("m_nBrightness", 128)
				pBlast:AddEFlags(nSpriteFlags)
				
				self:AddEvent("spritestartfade", 0.01, function()
					if (pBlast == NULL) then
						return true
					end
					
					pBlast:SetSaveValue("m_flBrightnessTime", self.Bolt.DieTime)
					pBlast:SetSaveValue("m_nBrightness", 0)
					pBlast:SetSaveValue("m_flDieTime", CurTime() + self.Bolt.DieTime)
					
					self:AddEvent("spritefade", 0, function()
						if (pBlast == NULL) then
							return true
						end
						
						local flCurTime = CurTime()
						local tSaveTable = pBlast:GetSaveTable()
						
						if (flCurTime > tSaveTable["m_flDieTime"]) then
							pBlast:Remove()
							
							return true
						end
						
						local flFrames = tSaveTable["frame"] + tSaveTable["framerate"] * (flCurTime - tSaveTable["m_flLastTime"])
						local flMaxFrames = tSaveTable["m_flMaxFrame"]
						pBlast:SetSaveValue("m_flLastTime", flCurTime)
						
						if (flFrames > flMaxFrames) then
							if (pBlast:HasSpawnFlags(SF_SPRITE_ONCE)) then
								--pBlast:AddEffects(EF_NODRAW)
								pBlast:Remove()
								
								return true
							end
							
							if (flMaxFrames > 0) then
								flFrames = flFrames % flMaxFrames
							end
						end
						
						pBlast:SetSaveValue("m_flFrame", flFrames)
					end)
					
					return true
				end)
			end
		end
	end
	
	local iClip = self:GetShootClip()
	
	if (iClip ~= -1) then
		self:SetShootClip(iClip - self:GetSpecialKey("Deduction", bSecondary))
	end
	
	self:PlaySound("shoot", 0)
	self:PlayActivity("shoot", 0)
	
	local flCurTime = CurTime()
	self:SetLastShootTime(flCurTime)
	self:SetNextPrimaryFire(flCurTime + self:GetSpecialKey("Cooldown", bSecondary))
	
	self:Punch(bSecondary)
	
	return true
end

function SWEP:SharedDeploy(bDelayed)
	if (self:Clip1() == 0) then
		local pViewModel = self:GetOwner():GetViewModel(0)
		
		if (pViewModel ~= NULL) then
			pViewModel:SetSkin(1)
		end
	end
	
	BaseClass.SharedDeploy(self, bDelayed)
end

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack(0)) then
		self:AdvanceZoom(0)
		
		return true
	end
	
	return false
end

function SWEP:SharedHolster(pSwitchingTo, bDelayed)
	BaseClass.SharedHolster(self, pSwitchingTo, bDelayed)
	
	local pPlayer = self:GetOwner()
	
	if (pPlayer ~= NULL) then
		local pViewModel = pPlayer:GetViewModel(0)
		
		if (pViewModel ~= NULL) then
			pViewModel:SetSkin(0)
		end
	end
end
