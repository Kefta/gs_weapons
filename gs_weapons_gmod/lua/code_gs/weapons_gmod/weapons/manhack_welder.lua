SWEP.Base = "gs_baseweapon"

SWEP.Author = "code_gs & garry"
SWEP.Spawnable = true
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.CModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 5

SWEP.Sounds = {
	shoot = "Metal.SawbladeStick"
}

SWEP.Primary.Automatic = false
SWEP.Primary.ShootEntity = "npc_manhack"

SWEP.Secondary.Automatic = false
SWEP.Secondary.ShootEntity = "npc_rollermine"

SWEP.FireFunction = function(pPlayer, tbl)
	local pWeapon = pPlayer:GetActiveWeapon()
	local vSrc = tbl.Src or pWeapon:GetShootSrc()
	local tr = util.TraceLine({
		start = vSrc,
		endpos = vSrc + (tbl.Dir or pWeapon:GetShootDir()) * MAX_TRACE_LENGTH,
		mask = MASK_SOLID
	})
	
	if (not (pWeapon.DoImpactEffect and pWeapon:DoImpactEffect(tr, 0))) then
		if (IsFirstTimePredicted()) then
			local data = EffectData()
				data:SetOrigin(tr.HitPos)
				data:SetNormal(tr.HitNormal)
				data:SetMagnitude(8)
				data:SetScale(1)
				data:SetRadius(16)
			util.Effect("Sparks", data)
		end
	end
	
	if (SERVER) then
		-- Make a manhack
		local pEntity = ents.Create(tbl.ShootEntity or "npc_manhack")
		
		if (pEntity ~= NULL) then
			pEntity:SetPos(tr.HitPos + tr.HitNormal * -16)
			pEntity:SetAngles(tr.HitNormal:Angle())
			pEntity:Spawn()

			undo.Create(code_gs.weapons.GetEntityPrintName(pEntity))

			if (tr.HitWorld) then
				-- Freeze it in place
				pEntity:GetPhysicsObject():EnableMotion(false)
			else
				-- Weld it to the object that we hit
				undo.AddEntity(constraint.Weld(tr.Entity, pEntity, tr.PhysicsBone, 0, 0))
			end
			
			undo.AddEntity(pEntity)
			undo.SetPlayer(self:GetOwner())
			undo.Finish()
		end
	end
end

function SWEP:GetShootInfo(bSecondary)
	local tbl = BaseClass.GetShootInfo(self, bSecondary)
	tbl.ShootEntity = self:GetSpecialKey("ShootEntity", bSecondary)
	
	return tbl
end
