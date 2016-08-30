-- Declare language table
local tLang = {}

-- Define new global environment for defining convinence
-- Next best thing to parsing a text file, which I may do eventually
setfenv( 1, tLang )

--- General
language = "English"
GS_LanguageLoaded = "Language %q loaded!"

--- GSWeaponBase
GSWeaponBase_ToBurstFire = "Switched to burst-fire mode"
GSWeaponBase_FromBurstFire = "Switched to semi-automatic"

--- Counter-Strike: Source
-- Pistols
CStrike_FiveSeven = "ES Five-Seven"
CStrike_P228 = "228 Compact"
CStrike_Glock = "9x19mm Sidearm"
CStrike_USP = "K&M .45 Tactical"
CStrike_DEagle = "Night Hawk .50C"
CStrike_Elites = ".40 Dual Elites"

-- Sub-machine guns
CStrike_Mac10 = "Ingram Mac-10"
CStrike_MP5Navy = "K&M Sub-Machine Gun"
CStrike_P90 = "ES C90"
CStrike_TMP = "Schmidt Machine Pistol"
CStrike_UMP45 = "K&M UMP45"

-- Rifles
CStrike_AK47 = "CV-47"
CStrike_AUG = "Bullpup"
CStrike_AWP = "Magnum Sniper Rifle"
CStrike_Famas = "Clarion 5.56"
CStrike_G3SG1 = "D3/AU-1"
CStrike_Galil = "IDF Defender"
CStrike_M249 = "M249"
CStrike_M4A1 = "Maverick M4A1 Carbine"
CStrike_Scout = "Schmidt Scout"
CStrike_SG550 = "Krieg 550 Commando"
CStrike_SG552 = "Krieg 552"

-- Shotguns
CStrike_M3 = "Leone 12 Gauge Super"
CStrike_XM1014 = "Leone YG1265 Auto Shotgun"

-- Grenades
CStrike_Flashbang = "Flashbang"
CStrike_HEGrenade = "HE Grenade"
CStrike_SmokeGrenade = "Smoke Grenade"

-- Other weapons
CStrike_C4 = "C4 Explosive"
CStrike_Knife = "Knife"

--- Half-Life 1
HL_357 = "357 Handgun"
HL_MP5 = "9mm AR"
HL_Shotgun = "Shotgun"

-- Send to lib
return tLang