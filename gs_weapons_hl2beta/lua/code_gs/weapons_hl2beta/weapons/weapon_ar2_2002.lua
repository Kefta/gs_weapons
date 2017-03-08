SWEP.Base = "weapon_hlbase_machinegun"

SWEP.Spawnable = true
SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.ViewModel = "models/code_gs/weapons/hl2beta_2002/v_ar2.mdl"
SWEP.WorldModel = "models/code_gs/weapons/hl2beta_2002/w_ar2.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 5

SWEP.Sounds = {
	reload = "Weapon_AR2.Reload",
	empty = "Weapon_AR2.Empty",
	shoot = "Weapon_AR2.Single",
	shoot2 = "Weapon_AR2.Double"
}

SWEP.Activities = {
	shoot = function(self, iIndex)
		local iShots = self:GetPredictedVar("AnimLevel" .. iIndex, 0)
		
		if (iShots < 2) then
			return ACT_VM_PRIMARYATTACK
		end
		
		if (iShots == 2) then
			return ACT_VM_HITLEFT
		end
		
		if (iShots == 3) then
			return ACT_VM_HITLEFT2
		end
		
		return ACT_VM_HITRIGHT
	end
}

SWEP.Primary.Ammo = "MediumRound"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60

SWEP.Primary.Cooldown = 0.1

SWEP.Primary.Spread = function(self)
	return self:GetOwner():IsPlayer() and VECTOR_CONE_3DEGREES or VECTOR_CONE_8DEGREES
end

SWEP.Secondary.Ammo = "SMG1_Grenade"
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Cooldown = 0.5
SWEP.Secondary.Force = 1000
SWEP.Secondary.FireUnderwater = false

SWEP.PunchAngle = {
	VerticalKick = 24, //Degrees
	SlideLimit = 3 //Seconds
}

SWEP.GrenadeClass = "grenade_ar2"

if (CLIENT) then
	SWEP.KillIcon = '2'
	SWEP.SelectionIcon = 'l'
end

local sk_plr_dmg_smg1_grenade = GetConVar("sk_plr_dmg_smg1_grenade") -- FIXME: Add new convar

function SWEP:SharedDeploy()
	for i = 0, self.ViewModelCount - 1 do
		if (self:GetPredictedVar("AnimLevel" .. i, 0) ~= 0) then
			self:SetPredictedVar("AnimLevel" .. i, 0)
		end
	end
end

function SWEP:MouseLifted(iIndex)
	BaseClass.MouseLifted(self, iIndex)
	
	if (self:GetPredictedVar("AnimLevel" .. iIndex, 0) ~= 0) then
		self:SetPredictedVar("AnimLevel" .. iIndex, 0)
	end
end

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:Launch(true, iIndex)
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:Shoot(bSecondary --[[= false]], iIndex --[[= 0]])
	BaseClass.Shoot(self, bSecondary, iIndex)
	
	local iLevel = self:GetPredictedVar("AnimLevel" .. iIndex, 0)
	
	if (iLevel ~= 5) then
		self:SetPredictedVar("AnimLevel" .. (iIndex or 0), iLevel + 1)
	end
end

-- Copied from the SMG
function SWEP:Launch(bSecondary --[[= false]], iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
		
	if (SERVER) then
		// Create the grenade
		local pGrenade = ents.Create(self.GrenadeClass)
		
		if (pGrenade:IsValid()) then
			pGrenade:SetPos(self:GetShootSrc(iIndex))
			pGrenade:SetAngles(self:GetShootAngles(iIndex))
			pGrenade:SetOwner(pPlayer)
			pGrenade:Spawn()
			
			local vVelocity = self:GetShootDir(iIndex)
			vVelocity:Mul(self:GetSpecialKey("Force", bSecondary, iIndex))
			pGrenade:_SetAbsVelocity(vVelocity)
			
			pGrenade:SetLocalAngularVelocity(AngleRand(-400, 400))
			pGrenade:SetMoveType(MOVETYPE_FLYGRAVITY)
			pGrenade:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
			
			pGrenade:SetSaveValue("m_hThrower", pPlayer)
			pGrenade:SetSaveValue("m_flDamage", sk_plr_dmg_smg1_grenade:GetFloat())
		end
	end
		
	pPlayer:RemoveAmmo(self:GetSpecialKey("Deduction", bSecondary, iIndex), self:GetAmmoType(bSecondary, iIndex))
		
	// Register a muzzleflash for the AI
	if (not self:DoMuzzleFlash(iIndex)) then
		pPlayer:MuzzleFlash()
	end
	
	pPlayer:SetAnimation(PLAYER_ATTACK1)
	
	local flCooldown = self:GetSpecialKey("Cooldown", bSecondary, iIndex)
	local flNextTime = CurTime() + flCooldown
	
	// Can shoot again immediately
	self:SetNextAttack(flNextTime, iIndex)
	
	// Can blow up after a short delay (so have time to release mouse button)
	self:SetNextAttack(flNextTime + flCooldown, iIndex) -- Double the penalty
	self:SetNextReload(flNextTime, iIndex)
	
	self:Punch(bSecondary, iIndex)
	self:PlaySound("shoot2", iIndex)
	
	return self:PlayActivity("shoot2", iIndex) ~= -1
end

function SWEP:Punch(bSecondary --[[= false]], iIndex --[[= 0]])
	if (not bSecondary) then
		BaseClass.Punch(self, bSecondary, iIndex)
	end
end

function SWEP:FinishReload(iIndex)
	if (self:GetPredictedVar("AnimLevel" .. iIndex, 0) ~= 0) then
		self:SetPredictedVar("AnimLevel" .. iIndex, 0)
	end
end

function SWEP:GetAmmoType(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:GetSecondaryAmmoType() or self:GetPrimaryAmmoType()) or -1
end

function SWEP:GetDefaultClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:GetDefaultClip2() or self:GetDefaultClip1()) or -1
end

function SWEP:GetMaxClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:GetMaxClip2() or self:GetMaxClip1()) or -1
end

function SWEP:GetClip(bSecondary --[[= false]], iIndex --[[= 0]])
	return (iIndex == nil or iIndex == 0) and (bSecondary and self:Clip2() or self:Clip1()) or -1
end

function SWEP:SetClip(iAmmo, bSecondary --[[= false]], iIndex --[[= 0]])
	if (iIndex == nil or iIndex == 0) then
		if (bSecondary) then
			self:SetClip2(iAmmo)
		else
			self:SetClip1(iAmmo)
		end
	end
end
