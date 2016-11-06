if ( SERVER or not game.SinglePlayer() ) then
	-- Handles weapon switching
	hook.Add( "StartCommand", "GSWeapons-Shared SelectWeapon", function( pPlayer, cmd )
		if ( pPlayer.m_pNewWeapon ) then
			-- https://github.com/Facepunch/garrysmod-issues/issues/2906
			if ( (--[[not pPlayer.m_pNULLWeapon and]] pPlayer.m_pNewWeapon == NULL) or pPlayer.m_pNewWeapon == pPlayer:GetActiveWeapon() ) then
				pPlayer.m_pNewWeapon = nil
			else
				-- Sometimes does not work the first time
				cmd:SelectWeapon( pPlayer.m_pNewWeapon )
			end
		end
	end )
	
	-- Scales the player's movement speeds based on their weapon
	hook.Add( "Move", "GSWeapons-Punch decay and move speed", function( pPlayer, mv )
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		
		--[[if ( pActiveWeapon.PunchDecayFunction ) then
			pPlayer.dt.LastPunchAngle = pPlayer:GetViewPunchAngles()
		end]]
		
		if ( pActiveWeapon.GetWalkSpeed ) then
			local flOldSpeed = mv:GetMaxSpeed() *
				(pPlayer:KeyDown( IN_SPEED ) and pActiveWeapon:GetRunSpeed( pActiveWeapon:SpecialActive() ) or pActiveWeapon:GetWalkSpeed( pActiveWeapon:SpecialActive() ))
			
			mv:SetMaxSpeed( flOldSpeed )
			mv:SetMaxClientSpeed( flOldSpeed )
		end
	end )

	--[[hook.Add( "FinishMove", "GSWeapons-Punch decay", function( pPlayer )
		local fPunchDecay = pPlayer:GetActiveWeapon().PunchDecayFunction
		
		if ( fPunchDecay ) then
			pPlayer:SetViewPunchAngles( fPunchDecay( pPlayer, pPlayer.dt.LastPunchAngle ))
		end
	end )]]
end

local ENTITY = FindMetaTable( "Entity" )
local PLAYER = FindMetaTable( "Player" )

function PLAYER:InstallDataTable()
	if ( not self.m_bInstalledDataTable ) then
		ENTITY.InstallDataTable( self )
		self.m_bInstalledDataTable = true
	end
end

function PLAYER:SetupWeaponDataTables()
	-- For CS:S ViewPunching
	self:DTVar( "Bool", 0, "PunchDirection" )
	self:DTVar( "Angle", 0, "LastPunchAngle" )
	
	-- For CS:S flashing
	self:DTVar( "Float", 0, "FlashDuration" )
	self:DTVar( "Float", 1, "FlashMaxAlpha" )
end

-- Shared version of SelectWeapon
function PLAYER:SwitchWeapon( Weapon )
	if ( isstring( Weapon )) then
		local pWeapon = self:GetWeapon( Weapon )
		
		if ( pWeapon ~= NULL ) then
			self.m_pNewWeapon = pWeapon
			self.m_pNULLWeapon = false
		end
	elseif ( Weapon == NULL ) then
		self.m_pNewWeapon = Weapon
		self.m_pNULLWeapon = true
	elseif ( Weapon:GetOwner() == self ) then
		self.m_pNewWeapon = Weapon
		self.m_pNULLWeapon = false
	end
end

function PLAYER:CSDecayPunchAngle( aPunch )
	local flLen = aPunch:NormalizeInPlace()
	flLen = flLen - (10 + flLen * 0.5) * FrameTime()
	
	return aPunch * (flLen < 0 and 0 or flLen)
end

function PLAYER:SharedRandomFloat( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetMD5Seed() % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomFloat( flMin, flMax )
end

function PLAYER:SharedRandomInt( sName, iMin, iMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetMD5Seed() % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomInt( iMin, iMax )
end

function PLAYER:SharedRandomVector( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetMD5Seed() % 0x80000000, sName, iAdditionalSeed ))

	return Vector( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ) )
end

function PLAYER:SharedRandomAngle( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetMD5Seed() % 0x80000000, sName, iAdditionalSeed ))

	return Angle( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

function PLAYER:SharedRandomColor( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( self:GetMD5Seed() % 0x80000000, sName, iAdditionalSeed ))
	
	return Color( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

if ( SERVER ) then
	local mp_fadetoblack = GetConVar( "mp_fadetoblack" )
	local colSpec = Color( 255, 255, 255, 150 )

	function PLAYER:IsBlind()
		return CurTime() < (self.m_flBlindUntilTime or 0)
	end

	function PLAYER:Blind( flHoldTime, flFadeTime, iAlpha )
		// Don't flash a spectator
		local flCurTime = CurTime()
		local nMode = self:GetObserverMode()
		
		// estimate when we can see again
		local flOldBlindStart = self.m_flBlindStartTime or 0
		local flOldBlindUntil = self.m_flBlindUntilTime or 0
		
		// adjust the hold time to match the fade time.
		local flHalfFade = flFadeTime * 0.5
		local flNewBlindUntil = flCurTime + flHoldTime + flHalfFade
		self.m_flBlindStartTime = flCurTime
		self.m_flBlindUntilTime = flNewBlindUntil > flOldBlindUntil and flNewBlindUntil or flOldBlindUntil
		
		// Spectators get a lessened flash
		if ( nMode == OBS_MODE_NONE or nMode == OBS_MODE_IN_EYE ) then
			if ( flCurTime > flOldBlindUntil ) then
				// The previous flashbang is wearing off, or completely gone
				self.dt.FlashDuration = flFadeTime / 1.4
				self.dt.FlashMaxAlpha = iAlpha
			else
				// The previous flashbang is still going strong - only extend the duration
				local flRemaining = flOldBlindStart + self.dt.FlashDuration - flCurTime
				self.dt.FlashDuration = flRemaining > flFadeTime and flRemaining or flFadeTime
				
				local iMaxAlpha = self.dt.FlashMaxAlpha or 0
				self.dt.FlashMaxAlpha = iMaxAlpha > iAlpha and iMaxAlpha or iAlpha
			end
		elseif ( not mp_fadetoblack:GetBool() ) then
			// make sure the spectator flashbang time is 1/2 second or less.
			self:ScreenFade( SCREENFADE.IN, colSpec, flFadeTime < 0.5 and flFadeTime or 0.5, flHalfFade < flHoldTime and flHalfFade or flHoldTime )
		end
	end

	function PLAYER:Deafen( flDistance )
		// Spectators don't get deafened
		local nMode = self:GetObserverMode()
		
		if ( (nMode == OBS_MODE_NONE or nMode == OBS_MODE_IN_EYE) and flDistance < 1000 ) then
			// dsp presets are defined in hl2/scripts/dsp_presets.txt
			self:SetDSP( flDistance < 600 and 37 or flDistance < 800 and 36 or 35, false ) -- 134, 135, 136
		end
	end
end
