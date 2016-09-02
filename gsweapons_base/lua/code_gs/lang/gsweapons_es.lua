-- Declare language table
local tLang = {}

-- Define new global environment for defining convinence
-- Next best thing to parsing a text file, which I may do eventually
setfenv( 1, tLang )

--- General
language = "Español"
GS_LanguageLoaded = "Idioma %q inicializado!"

--- GSWeaponBase
GSWeaponBase_ToBurstFire = "Se ha cambiado al modo ráfaga"
GSWeaponBase_FromBurstFire = "Se ha cambiado al modo semiautomático"

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
CStrike_MP5Navy = "Metralleta K&M"
CStrike_P90 = "ES C90"
CStrike_TMP = "Ametralladora Schmidt"
CStrike_UMP45 = "K&M UMP45"

-- Rifles
CStrike_AK47 = "CV-47"
CStrike_AUG = "Bullpup"
CStrike_AWP = "Rifle de Francotirador Magnum"
CStrike_Famas = "Clarion 5.56"
CStrike_G3SG1 = "D3/AU-1"
CStrike_Galil = "IDF Defender"
CStrike_M249 = "M249"
CStrike_M4A1 = "Carabina Maverick M4A1"
CStrike_Scout = "Schmidt Scout"
CStrike_SG550 = "Krieg 550 Commando"
CStrike_SG552 = "Krieg 552"

-- Shotguns
CStrike_M3 = "Leone 12 Gauge Super"
CStrike_XM1014 = "Escopeta Automática Leone YG1265"

-- Grenades
CStrike_Flashbang = "Granada Aturdidora"
CStrike_HEGrenade = "Granada HE"
CStrike_SmokeGrenade = "Granada de Humo"

-- Other weapons
CStrike_C4 = "Explosivo C4"
CStrike_Knife = "Cuchillo"

--- Half-Life 1
HL1_357 = "357 Pistola"
HL1_MP5 = "9mm AR"
HL1_Shotgun = "Escopeta"
HL1_Glock = "9mm Pistola"
HL1_HandGrenade = "Granada de Mano"

-- Send to lib
return tLang