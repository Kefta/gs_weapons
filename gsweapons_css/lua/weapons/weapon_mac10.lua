DEFINE_BASECLASS( "weapon_csbase_smg" )

--- GSBase
SWEP.PrintName = "#CStrike_Mac10"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.Sounds = {
	primary = "Weapon_MAC10.Single"
}

SWEP.Primary = {
	Ammo = "45ACP",
	ClipSize = 30,
	DefaultClip = 130,
	Damage = 29,
	Cooldown = 0.075,
	RangeModifier = 0.82,
	Spread = {
		Base = 0.03,
		Air = 0.375,
		Move = 0.03
	}
}

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 'l'
	SWEP.SelectionIcon = 'l'
	
	SWEP.CSSCrosshair = {
		Min = 9
	}
	
	SWEP.MuzzleFlashScale = 1.1
end

--- CSBase_SMG
SWEP.Accuracy = {
	Base = 0.15,
	Divisor = 200,
	Offset = 0.6,
	Max = 1.65
}

SWEP.Kick = {
	Air = {
		UpBase = 1.3,
		LateralBase = 0.55,
		UpModifier = 0.4,
		LateralModifier = 0.05,
		UpMax = 4.75,
		LateralMax = 3.75,
		DirectionChange = 5
	},
	Move = {
		UpBase = 0.9,
		LateralBase = 0.45,
		UpModifier = 0.25,
		LateralModifier = 0.035,
		UpMax = 3.5,
		LateralMax = 2.75,
		DirectionChange = 7
	},
	Crouch = {
		UpBase = 0.75,
		LateralBase = 0.4,
		UpModifier = 0.175,
		LateralModifier = 0.03,
		UpMax = 2.75,
		LateralMax = 2.5,
		DirectionChange = 10
	},
	Base = {
		UpBase = 0.775,
		LateralBase = 0.425,
		UpModifier = 0.2,
		LateralModifier = 0.03,
		UpMax = 3,
		LateralMax = 2.75,
		DirectionChange = 9
	}
}
