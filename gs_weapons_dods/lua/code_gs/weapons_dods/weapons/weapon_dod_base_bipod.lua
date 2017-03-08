SWEP.Base = "weapon_dod_base_gun"

SWEP.PrintName = "DoDBase_Bipod"

-- FIXME: Isn't working
SWEP.StrictPrefixes = {
	clip1 = function(self, iIndex) return self:GetClip(false, iIndex) == 1 end,
	clip2 = function(self, iIndex) return self:GetClip(false, iIndex) == 2 end,
	clip3 = function(self, iIndex) return self:GetClip(false, iIndex) == 3 end,
	clip4 = function(self, iIndex) return self:GetClip(false, iIndex) == 4 end,
	clip5 = function(self, iIndex) return self:GetClip(false, iIndex) == 5 end,
	clip6 = function(self, iIndex) return self:GetClip(false, iIndex) == 6 end,
	clip7 = function(self, iIndex) return self:GetClip(false, iIndex) == 7 end,
	clip8 = function(self, iIndex) return self:GetClip(false, iIndex) == 8 end
}

SWEP.Activities = {
	deploy_clip1 = ACT_VM_DEPLOY_1,
	deploy_clip2 = ACT_VM_DEPLOY_2,
	deploy_clip3 = ACT_VM_DEPLOY_3,
	deploy_clip4 = ACT_VM_DEPLOY_4,
	deploy_clip5 = ACT_VM_DEPLOY_5,
	deploy_clip6 = ACT_VM_DEPLOY_6,
	deploy_clip7 = ACT_VM_DEPLOY_7,
	deploy_clip8 = ACT_VM_DEPLOY_8,
	idle_clip1 = ACT_VM_IDLE_1,
	idle_clip2 = ACT_VM_IDLE_2,
	idle_clip3 = ACT_VM_IDLE_3,
	idle_clip4 = ACT_VM_IDLE_4,
	idle_clip5 = ACT_VM_IDLE_5,
	idle_clip6 = ACT_VM_IDLE_6,
	idle_clip7 = ACT_VM_IDLE_7,
	idle_clip8 = ACT_VM_IDLE_8,
	shoot_clip1 = ACT_VM_PRIMARYATTACK_1,
	shoot_clip2 = ACT_VM_PRIMARYATTACK_2,
	shoot_clip3 = ACT_VM_PRIMARYATTACK_3,
	shoot_clip4 = ACT_VM_PRIMARYATTACK_4,
	shoot_clip5 = ACT_VM_PRIMARYATTACK_5,
	shoot_clip6 = ACT_VM_PRIMARYATTACK_6,
	shoot_clip7 = ACT_VM_PRIMARYATTACK_7,
	shoot_clip8 = ACT_VM_PRIMARYATTACK_8,
	d_deploy_clip1 = ACT_VM_UNDEPLOY_1,
	d_deploy_clip2 = ACT_VM_UNDEPLOY_2,
	d_deploy_clip3 = ACT_VM_UNDEPLOY_3,
	d_deploy_clip4 = ACT_VM_UNDEPLOY_4,
	d_deploy_clip5 = ACT_VM_UNDEPLOY_5,
	d_deploy_clip6 = ACT_VM_UNDEPLOY_6,
	d_deploy_clip7 = ACT_VM_UNDEPLOY_7,
	d_deploy_clip8 = ACT_VM_UNDEPLOY_8,
	d_idle_clip1 = ACT_VM_IDLE_DEPLOYED_1,
	d_idle_clip2 = ACT_VM_IDLE_DEPLOYED_2,
	d_idle_clip3 = ACT_VM_IDLE_DEPLOYED_3,
	d_idle_clip4 = ACT_VM_IDLE_DEPLOYED_4,
	d_idle_clip5 = ACT_VM_IDLE_DEPLOYED_5,
	d_idle_clip6 = ACT_VM_IDLE_DEPLOYED_6,
	d_idle_clip7 = ACT_VM_IDLE_DEPLOYED_7,
	d_idle_clip8 = ACT_VM_IDLE_DEPLOYED_8,
	d_shoot_clip1 = ACT_VM_PRIMARYATTACK_DEPLOYED_1,
	d_shoot_clip2 = ACT_VM_PRIMARYATTACK_DEPLOYED_2,
	d_shoot_clip3 = ACT_VM_PRIMARYATTACK_DEPLOYED_3,
	d_shoot_clip4 = ACT_VM_PRIMARYATTACK_DEPLOYED_4,
	d_shoot_clip5 = ACT_VM_PRIMARYATTACK_DEPLOYED_5,
	d_shoot_clip6 = ACT_VM_PRIMARYATTACK_DEPLOYED_6,
	d_shoot_clip7 = ACT_VM_PRIMARYATTACK_DEPLOYED_7,
	d_shoot_clip8 = ACT_VM_PRIMARYATTACK_DEPLOYED_8
}

SWEP.Secondary.Automatic = false
SWEP.Secondary.InterruptReload = true

function SWEP:Attack(bSecondary --[[= false]], iIndex --[[= 0]])
	if (bSecondary) then
		self:ToggleBipodDeploy()
	else
		self:Shoot(false, iIndex)
	end
end

function SWEP:CanReload(iIndex --[[= 0]])
	return self:GetBipodDeployed() and BaseClass.CanReload(self, iIndex)
end
