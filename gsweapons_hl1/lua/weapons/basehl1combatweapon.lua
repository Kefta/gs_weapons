DEFINE_BASECLASS( "weapon_gs_base" )

--- GSBase
SWEP.Primary = {
	BobScale = 0.45,
	SwayScale = 0.5
}

if ( CLIENT ) then
	SWEP.BobStyle = "hl"
	SWEP.CrosshairStyle = "hl"
end
