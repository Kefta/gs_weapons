local tHoldTypes = {}

function code_gs.weapons.RegisterHoldType(sName, tActTable)
	tHoldTypes[sName:lower()] = tActTable
end

function code_gs.weapons.GetHoldType(sName)
	return tHoldTypes[sName:lower()] or tHoldTypes["normal"] or {}
end

function code_gs.weapons.GetHoldTypeActivity(sName, iActivity)
	return (tHoldTypes[sName:lower()] or tHoldTypes["normal"] or {})[iActivity] or -1
end

local function RegisterDefaultHoldType(sName, iStartIndex)
	code_gs.weapons.RegisterHoldType(sName, {
		[ACT_MP_STAND_IDLE] = iStartIndex,
		[ACT_MP_WALK] = iStartIndex + 1,
		[ACT_MP_RUN] = iStartIndex + 2,
		[ACT_MP_CROUCH_IDLE] = iStartIndex + 3,
		[ACT_MP_CROUCHWALK] = iStartIndex + 4,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = iStartIndex + 5,
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = iStartIndex + 5,
		[ACT_MP_RELOAD_STAND] = iStartIndex + 6,
		[ACT_MP_RELOAD_CROUCH] = iStartIndex + 6,
		[ACT_MP_JUMP] = iStartIndex == ACT_HL2MP_IDLE and ACT_HL2MP_JUMP_SLAM or iStartIndex + 7,
		--[ACT_RANGE_ATTACK1] = iStartIndex + 8, -- FIXME: This isn't right! Maps to ACT_HL2MP_SWIM_IDLE_*
		[ACT_MP_SWIM] = iStartIndex + 9
	})
end

local function RegisterIdleActivity(sName, iIndex)
	code_gs.weapons.RegisterHoldType(sName, {
		[ACT_MP_STAND_IDLE] = iIndex,
		[ACT_MP_WALK] = ACT_HL2MP_WALK,
		[ACT_MP_RUN] = ACT_HL2MP_RUN,
		[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH,
		[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_HL2MP_GESTURE_RANGE_ATTACK,
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_GESTURE_RANGE_ATTACK,
		[ACT_MP_RELOAD_STAND] = ACT_HL2MP_GESTURE_RELOAD,
		[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_GESTURE_RELOAD,
		[ACT_MP_JUMP] = ACT_HL2MP_JUMP_SLAM,
		--[ACT_RANGE_ATTACK1] = iStartIndex + 8, -- FIXME: This isn't right! Maps to ACT_HL2MP_SWIM_IDLE_*
		[ACT_MP_SWIM] = ACT_HL2MP_SWIM
	})
end

RegisterDefaultHoldType("pistol", ACT_HL2MP_IDLE_PISTOL)
RegisterDefaultHoldType("smg", ACT_HL2MP_IDLE_SMG1)
RegisterDefaultHoldType("grenade", ACT_HL2MP_IDLE_GRENADE)
RegisterDefaultHoldType("ar2", ACT_HL2MP_IDLE_AR2)
RegisterDefaultHoldType("shotgun", ACT_HL2MP_IDLE_SHOTGUN)
RegisterDefaultHoldType("rpg", ACT_HL2MP_IDLE_RPG)
RegisterDefaultHoldType("physgun", ACT_HL2MP_IDLE_PHYSGUN)
RegisterDefaultHoldType("crossbow", ACT_HL2MP_IDLE_CROSSBOW)
RegisterDefaultHoldType("melee", ACT_HL2MP_IDLE_MELEE)
RegisterDefaultHoldType("slam", ACT_HL2MP_IDLE_SLAM)
RegisterDefaultHoldType("normal", ACT_HL2MP_IDLE)
RegisterDefaultHoldType("fist", ACT_HL2MP_IDLE_FIST)
RegisterDefaultHoldType("melee2", ACT_HL2MP_IDLE_MELEE2)
RegisterDefaultHoldType("passive", ACT_HL2MP_IDLE_PASSIVE)
RegisterDefaultHoldType("knife", ACT_HL2MP_IDLE_KNIFE)
RegisterDefaultHoldType("duel", ACT_HL2MP_IDLE_DUEL)
RegisterDefaultHoldType("camera", ACT_HL2MP_IDLE_CAMERA)
RegisterDefaultHoldType("magic", ACT_HL2MP_IDLE_MAGIC)
RegisterDefaultHoldType("revolver", ACT_HL2MP_IDLE_REVOLVER)

RegisterIdleActivity("angry", ACT_HL2MP_IDLE_ANGRY)
RegisterIdleActivity("scared", ACT_HL2MP_IDLE_SCARED)
RegisterIdleActivity("suitcase", ACT_HL2MP_IDLE_SUITCASE)
--RegisterIdleActivity("cower", ACT_HL2MP_IDLE_COWER)

code_gs.weapons.RegisterHoldType("zombie", {
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ZOMBIE,
	[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_01,
	[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE, -- FIXME: Differentiate between fast and slow, and figure out which numbered activity to use
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_HL2MP_GESTURE_RANGE_ATTACK,
	[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_GESTURE_RANGE_ATTACK,
	[ACT_MP_RELOAD_STAND] = ACT_HL2MP_GESTURE_RELOAD,
	[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_GESTURE_RELOAD,
	[ACT_MP_JUMP] = ACT_ZOMBIE_LEAPING,
	--[ACT_RANGE_ATTACK1] = iStartIndex + 8, -- FIXME: This isn't right! Maps to ACT_HL2MP_SWIM_IDLE_*
	[ACT_MP_SWIM] = ACT_HL2MP_SWIM
})
