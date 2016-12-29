ENT.Base = "gs_basegrenade"

ENT.PrintName = "CSBase_Grenade"

ENT.DetonationType = "explode_css"

// smaller, cube bounding box so we rest on the ground
ENT.Size = {
	Min = Vector(-2, -2, -2),
	Max = Vector(2, 2, 2)
}

ENT.Gravity = 0.4
ENT.Friction = 0.2
ENT.Elasticity = 0.45

function ENT:Initialize()
	BaseClass.Initialize(self)
	
	self:SetGravity(self.Gravity)
	self:SetFriction(self.Friction)
	self:SetElasticity(self.Elasticity)
	
	-- https://github.com/Facepunch/garrysmod-issues/issues/2770
	if (SERVER) then
		self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	end
end
