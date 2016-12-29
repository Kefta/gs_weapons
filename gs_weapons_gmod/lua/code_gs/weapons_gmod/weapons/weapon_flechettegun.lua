if (not IsMounted("ep2")) then return true end -- Block registration

SWEP.Base = "gs_baseweapon"

SWEP.Author = "code_gs & garry"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.CModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"

SWEP.Sounds = {
	shoot = "NPC_Hunter.FlechetteShoot"
}

SWEP.Primary = {
	Cooldown = 0.1,
	Force = 2000
}

SWEP.FireFunction = function(pPlayer, tbl)
	if (SERVER) then
		local pWeapon = pPlayer:GetActiveWeapon()
		local pEntity = ents.Create(self.ShootClass)
		
		if (pEntity ~= NULL) then
			pEntity:SetPos(pWeapon:GetShootSrc() + (tbl.Dir or pWeapon:GetShootDir()) * 32)
			pEntity:SetAngles(tbl.ShootAngles or pWeapon:GetShootAngles())
			pEntity:Spawn()

			pEntity:_SetVelocity(vForward * (tbl.Force or self:GetSpecialKey("Force")))
			pEntity:SetOwner(pPlayer)
		end
	end
end

SWEP.ShootClass = "hunter_flechette"

if (CLIENT) then
	SWEP.ViewModelFOV = 54
	
	-- No shell ejection
	SWEP.EventStyle = {
		[20] = "",
		[6001] = "",
		[6002] = ""
	}
end

function SWEP:Precache()
	BaseClass.Precache(self)
	
	game.AddParticles("particles/hunter_flechette.pcf")
	game.AddParticles("particles/hunter_projectile.pcf")
end
