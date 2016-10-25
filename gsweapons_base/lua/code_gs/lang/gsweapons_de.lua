-- Declare language table
local tLang = {}

-- Define new global environment for defining convinence
-- Next best thing to parsing a text file, which I may do eventually
setfenv( 1, tLang )

--- General
language = "Deutsch"

--- GSWeapons
GSWeapons_Loaded = "[GSWeapons] Geladen mit Sprache %q"
GSWeapons_ToBurstFire = "Umgeschaltet auf Schnellfeuer"
GSWeapons_FromBurstFire = "Umgeschaltet auf Halbautomatik"

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
CStrike_MP5Navy = "K&M Maschinenpistole"
CStrike_P90 = "ES C90"
CStrike_TMP = "Schmidt Maschinenpistole"
CStrike_UMP45 = "K&M UMP45"

-- Rifles
CStrike_AK47 = "CV-47"
CStrike_AUG = "Bullpup"
CStrike_AWP = "Magnum Scharfschützengewehr"
CStrike_Famas = "Clarion 5.56"
CStrike_G3SG1 = "D3/AU-1"
CStrike_Galil = "IDF Defender"
CStrike_M249 = "M249"
CStrike_M4A1 = "Maverick M4A1 Karabiner"
CStrike_Scout = "Schmidt Scout"
CStrike_SG550 = "Krieg 550 Commando"
CStrike_SG552 = "Krieg 552"

-- Shotguns
CStrike_M3 = "Leone 12 Gauge Super"
CStrike_XM1014 = "Leone YG1265 Auto Schrotflinte"

-- Grenades
CStrike_Flashbang = "Blendgranate"
CStrike_HEGrenade = "HE Granate"
CStrike_SmokeGrenade = "Rauchgranate"

-- Other weapons
CStrike_C4 = "C4 Sprengstoff"
CStrike_Knife = "Messer"

--- Half-Life 1
HL1_357 = "357 Pistole"
HL1_MP5 = "9mm AR"
HL1_Shotgun = "Schrotflinte"
HL1_Glock = "9mm Pistole"
HL1_HandGrenade = "Handgranate"

-- Send to lib
return tLang
