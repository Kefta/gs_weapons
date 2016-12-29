-- FIXME: Activities
SWEP.Base = "weapon_dod_base_gun"

SWEP.PrintName = "DoDBase_Bipod"

SWEP.Activities = {
	deploy_1 = ACT_VM_DEPLOY_1,
	deploy_2 = ACT_VM_DEPLOY_2,
	deploy_3 = ACT_VM_DEPLOY_3,
	deploy_4 = ACT_VM_DEPLOY_4,
	deploy_5 = ACT_VM_DEPLOY_5,
	deploy_6 = ACT_VM_DEPLOY_6,
	deploy_7 = ACT_VM_DEPLOY_7,
	deploy_8 = ACT_VM_DEPLOY_8,
	idle_1 = ACT_VM_IDLE_1,
	idle_2 = ACT_VM_IDLE_2,
	idle_3 = ACT_VM_IDLE_3,
	idle_4 = ACT_VM_IDLE_4,
	idle_5 = ACT_VM_IDLE_5,
	idle_6 = ACT_VM_IDLE_6,
	idle_7 = ACT_VM_IDLE_7,
	idle_8 = ACT_VM_IDLE_8,
	shoot_1 = ACT_VM_PRIMARYATTACK_1,
	shoot_2 = ACT_VM_PRIMARYATTACK_2,
	shoot_3 = ACT_VM_PRIMARYATTACK_3,
	shoot_4 = ACT_VM_PRIMARYATTACK_4,
	shoot_5 = ACT_VM_PRIMARYATTACK_5,
	shoot_6 = ACT_VM_PRIMARYATTACK_6,
	shoot_7 = ACT_VM_PRIMARYATTACK_7,
	shoot_8 = ACT_VM_PRIMARYATTACK_8,
	d_deploy_1 = ACT_VM_UNDEPLOY_1,
	d_deploy_2 = ACT_VM_UNDEPLOY_2,
	d_deploy_3 = ACT_VM_UNDEPLOY_3,
	d_deploy_4 = ACT_VM_UNDEPLOY_4,
	d_deploy_5 = ACT_VM_UNDEPLOY_5,
	d_deploy_6 = ACT_VM_UNDEPLOY_6,
	d_deploy_7 = ACT_VM_UNDEPLOY_7,
	d_deploy_8 = ACT_VM_UNDEPLOY_8,
	d_idle_1 = ACT_VM_IDLE_DEPLOYED_1,
	d_idle_2 = ACT_VM_IDLE_DEPLOYED_2,
	d_idle_3 = ACT_VM_IDLE_DEPLOYED_3,
	d_idle_4 = ACT_VM_IDLE_DEPLOYED_4,
	d_idle_5 = ACT_VM_IDLE_DEPLOYED_5,
	d_idle_6 = ACT_VM_IDLE_DEPLOYED_6,
	d_idle_7 = ACT_VM_IDLE_DEPLOYED_7,
	d_idle_8 = ACT_VM_IDLE_DEPLOYED_8,
	d_shoot_1 = ACT_VM_PRIMARYATTACK_DEPLOYED_1,
	d_shoot_2 = ACT_VM_PRIMARYATTACK_DEPLOYED_2,
	d_shoot_3 = ACT_VM_PRIMARYATTACK_DEPLOYED_3,
	d_shoot_4 = ACT_VM_PRIMARYATTACK_DEPLOYED_4,
	d_shoot_5 = ACT_VM_PRIMARYATTACK_DEPLOYED_5,
	d_shoot_6 = ACT_VM_PRIMARYATTACK_DEPLOYED_6,
	d_shoot_7 = ACT_VM_PRIMARYATTACK_DEPLOYED_7,
	d_shoot_8 = ACT_VM_PRIMARYATTACK_DEPLOYED_8
}

SWEP.Secondary.Automatic = false

function SWEP:SecondaryAttack()
	if (self:CanSecondaryAttack()) then
		return self:ToggleDeploy(0)
	end
	
	return false
end

function SWEP:CanReload()
	return self:GetDeployed() ~= 0 and BaseClass.CanReload(self)
end

function SWEP:ReloadClips()
	BaseClass.ReloadClips(self)
	
	self:SetNextSecondaryFire(0)
end

function SWEP:GetActivitySuffix(sActivity, iIndex)
	local iClip = self:GetShootClip()
	
	if (iClip > 0 or iClip < 9) then
		return tostring(iClip)
	end
	
	return BaseClass.GetActivitySuffix(self, sActivity, iIndex)
end
