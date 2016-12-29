SWEP.Base = "gs_baseweapon"

SWEP.PrintName = "DODBase"
SWEP.Author = "code_gs & Valve"

SWEP.TriggerBoundSize = 10

if (CLIENT) then
	SWEP.BobStyle = "css"
	SWEP.CrosshairStyle = "dod"
	
	SWEP.EventStyle = {
		[5001] = "dod",
		[5011] = "dod",
		[5021] = "dod",
		[5031] = "dod"
	}
	
	SWEP.Primary = {
		BobCycle = 0.8,
		BobUp = 0.5
	}
end
