DEFINE_BASECLASS( "weapon_csbase_rifle" )

--- GSBase
SWEP.PrintName = "#CStrike_FAMAS"
SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/v_rif_famas.mdl"
SWEP.ViewModelFlip = false
SWEP.WorldModel = "models/weapons/w_rif_famas.mdl"
SWEP.Weight = 75

SWEP.Sounds = {
	primary = "Weapon_FAMAS.Single"
}

SWEP.Primary = {
	Ammo = "556mmRound",
	ClipSize = 25,
	DefaultClip = 115,
	Damage = 30,
	Cooldown = 0.09,
	WalkSpeed = 220/250,
	FireUnderwater = false,
	RangeModifier = 0.96,
	Spread = {
		Base = 0.02,
		Air = 0.3,
		Move = 0.07,
		Additive = 0.01
	}
}

SWEP.Secondary = {
	Cooldown = 0.35,
	Spread = {
		Additive = 0
	}
}

SWEP.Burst = {
	Times = {
		0.05,
		0.1
	}
}

SWEP.SpecialType = SPECIAL_BURST

if ( CLIENT ) then
	SWEP.Category = "Counter-Strike: Source"
	SWEP.KillIcon = 't'
	SWEP.SelectionIcon = 't'
	
	SWEP.MuzzleFlashScale = 1.3
	
	SWEP.EventStyle = {
		-- CS:S muzzle flash
		[5001] = "cstrike_x",
		[5011] = "cstrike_x",
		[5021] = "cstrike_x",
		[5031] = "cstrike_x"
	}
end

--- CSBase_SMG
SWEP.Accuracy = {
	Divisor = 215,
	Offset = 0.3,
	Max = 1,
	Additive = 0.03
}

SWEP.Kick = {
	Move = {
		UpBase = 1,
		LateralBase = 0.45,
		UpModifier = 0.275,
		LateralModifier = 0.05,
		UpMax = 4,
		LateralMax = 2.5,
		DirectionChange = 7
	},
	Air = {
		UpBase = 1.25,
		LateralBase = 0.45,
		UpModifier = 0.22,
		LateralModifier = 0.18,
		UpMax = 5.5,
		LateralMax = 4,
		DirectionChange = 5
	},
	Crouch = {
		UpBase = 0.575,
		LateralBase = 0.325,
		UpModifier = 0.2,
		LateralModifier = 0.011,
		UpMax = 3.25,
		LateralMax = 2,
		DirectionChange = 8
	},
	Base = {
		UpBase = 0.625,
		LateralBase = 0.375,
		UpModifier = 0.25,
		LateralModifier = 0.0125,
		UpMax = 3.5,
		LateralMax = 2.25,
		DirectionChange = 8
	}
}

--- CSBase_Gun
-- Famas is the only weapon that adds extra spread if the secondary is off. No idea why
function SWEP:GetSpread( bSecondary --[[= self:SpecialActive()]] )
	if ( bSecondary or bSecondary == nil and self:SpecialActive() ) then
		local flSpecial = self.Secondary.Spread.Additive
		
		if ( flSpecial ~= -1 ) then
			return BaseClass.GetSpread( self, true ) + flSpecial
		end
	end
	
	return BaseClass.GetSpread( self, false ) + self.Primary.Spread.Additive
end
