// Citizen package. Not really a weapon, just needs to be a visible model for citizens to open.
SWEP.Base = "basehlcombatweapon"

SWEP.Spawnable = true
SWEP.Slot = 2
SWEP.SlotPos = 2

SWEP.ViewModelCount = 0 -- FIXME: Spam print still happening
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/w_package.mdl"
SWEP.HoldType = "slam"

function SWEP:Attack()
end
