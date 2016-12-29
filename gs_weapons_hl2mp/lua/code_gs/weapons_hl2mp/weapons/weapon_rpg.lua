SWEP.Base = "weapon_hl2mp_base"

SWEP.Spawnable = true
SWEP.Slot = 4

SWEP.ViewModel = "models/weapons/v_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.HoldType = "rpg"

SWEP.Sounds = {
	shoot = "Weapon_RPG.Single",
	laseron = "Weapon_RPG.LaserOn",
	laseroff = "Weapon_RPG.LaserOff",
	empty = "Weapon_SMG1.Empty"
}

SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Damage = 150
SWEP.Primary.Cooldown = 1

SWEP.Missile = {
	Class = "rpg_missile",
	VelMul = 300,
	VelAdd = Vector(0, 0, 128),
	GracePeriod = 0.3
}

local bMultiPlayer = not game.SinglePlayer()

if (CLIENT) then
	SWEP.SelectionIcon = 'i'
	--SWEP.KillIcon = 'x'
elseif (bMultiPlayer) then
	util.AddNetworkString("gs-weapons_hl2mp-weapon_rpg")
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	
	self:AddNWVar("Entity", "Missile", false)
end

local fReload = function(_, pWeapon, pPlayer)
	if (not (pWeapon == NULL or pPlayer == NULL) and pWeapon:GetOwner() == pPlayer and pWeapon:PlayActivity("reload")) then
		pWeapon:SetNextPrimaryFire(CurTime() + pWeapon:SequenceLength(0))
	end
end

function SWEP:CanPrimaryAttack(iIndex)
	return BaseClass.CanPrimaryAttack(self, iIndex) and self.dt.Missile == NULL
end
-- Fixme: Make viewmodel independent
function SWEP:PrimaryAttack()
	if (not self:CanPrimaryAttack(0)) then
		return false
	end
	
	local bSecondary = self:SpecialActive(0)
	local flCurTime = CurTime()
	local pPlayer = self:GetOwner()
	pPlayer:RemoveAmmo(self:GetSpecialKey("Deduction", bSecondary), self:GetPrimaryAmmoName())
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	
	self:PlayActivity("shoot")
	self:PlaySound("shoot")
	
	if (SERVER) then
		local aShoot = self:GetShootAngles(bSecondary)
		local vEyePos = pPlayer:EyePos()
		local vForward = aShoot:Forward()
		
		local tMissile = self.Missile
		local pMissile = ents.Create(tMissile.Class)
		self.dt.Missile = pMissile
		
		pMissile:SetPos(self:GetShootSrc(bSecondary) + vForward * 12 + aShoot:Right() * 6 + aShoot:Up() * -3)
		pMissile:SetAngles(aShoot)
		pMissile:SetOwner(pPlayer)
		pMissile:Spawn()
		pMissile:CallOnRemove("gs-weapons_hl2mp-weapon_rpg", fReload, self, pPlayer)
		pMissile:AddEffects(EF_NOSHADOW)
		pMissile:_SetAbsVelocity(vForward * tMissile.VelMul + tMissile.VelAdd)
		pMissile:SetSaveValue("m_flDamage", self:GetSpecialKey("Damage", bSecondary))
		
		if (util.TraceLine({start = vEyePos, endpos = vEyePos + vForward * 128, mask = MASK_SHOT, filter = self}).Fraction == 1) then
			pMissile:SetSaveValue("m_flGracePeriodEndsAt", flCurTime + tMelee.GracePeriod)
			
			// Go non-solid until the grace period ends
			pMissile:AddSolidFlags(FSOLID_NOT_SOLID)
		end
		
		if (bMultiPlayer) then
			timer.Create("gs-weapons_hl2mp-weapon_rpg", 0, 1, function()
				if (not (pMissile == NULL or self == NULL or pPlayer == NULL) and self:GetOwner() == pPlayer) then
					net.Start("gs-weapons_hl2mp-weapon_rpg")
						net.WriteEntity(pMissile)
					net.Send(pPlayer)
				end
			end)
		end
	end
end

function SWEP:GetShootAngles(bSecondary)
	return self:GetOwner():ActualEyeAngles()
end

if (CLIENT) then
	if (bMultiPlayer) then
		net.Receive("gs-weapons_hl2mp-weapon_rpg", function()
			local pMissile = net.ReadEntity()
			
			if (pMissile ~= NULL) then
				local pPlayer = LocalPlayer()
				pMissile:CallOnRemove("gs-weapons_hl2mp-weapon_rpg", fReload, pPlayer:GetActiveWeapon(), pPlayer)
			end
		end)
	end
	
	--[[function SWEP:Draw(nFlags)
		// Only render these on the transparent pass
		if (bit.band(nFlags, STUDIO_TRANSPARENCY)) then
			
		end
	end
	
	function SWEP:ViewModelDrawn()
		// Draw our laser effects
		
	end]]
end
