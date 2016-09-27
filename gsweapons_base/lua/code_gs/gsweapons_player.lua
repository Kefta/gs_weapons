if ( SERVER or not game.SinglePlayer() ) then
	-- Handles weapon switching
	hook.Add( "StartCommand", "GSWeapons-Shared SelectWeapon", function( pPlayer, cmd )
		if ( pPlayer.m_pNewWeapon ) then
			if ( pPlayer.m_pNewWeapon == NULL or pPlayer.m_pNewWeapon == pPlayer:GetActiveWeapon() ) then
				pPlayer.m_pNewWeapon = nil
			else
				-- Sometimes does not work the first time
				cmd:SelectWeapon( pPlayer.m_pNewWeapon )
			end
		end
	end )
	
	-- Scales the player's movement speeds based on their weapon
	hook.Add( "Move", "GSWeapons-Punch decay and Move speed", function( pPlayer, mv )
		local pActiveWeapon = pPlayer:GetActiveWeapon()
		
		if ( pActiveWeapon.PunchDecayFunction ) then
			pPlayer.dt.LastPunchAngle = pPlayer:GetViewPunchAngles()
		end
		
		if ( pActiveWeapon.GetWalkSpeed ) then
			local flOldSpeed = mv:GetMaxSpeed() *
				(pPlayer:KeyDown( IN_SPEED ) and pActiveWeapon:GetRunSpeed() or pActiveWeapon:GetWalkSpeed())
			
			mv:SetMaxSpeed( flOldSpeed )
			mv:SetMaxClientSpeed( flOldSpeed )
		end
	end )

	hook.Add( "FinishMove", "GSWeapons-Punch decay", function( pPlayer )
		local fPunchDecay = pPlayer:GetActiveWeapon().PunchDecayFunction
		
		if ( fPunchDecay ) then
			pPlayer:SetViewPunchAngles( fPunchDecay( pPlayer, pPlayer.dt.LastPunchAngle ))
		end
	end )
end

local PLAYER = _R.Player

function PLAYER:SetupWeaponDataTables()
	-- For CS:S ViewPunching
	self:DTVar( "Bool", 0, "PunchDirection" )
	self:DTVar( "Angle", 0, "LastPunchAngle" )
end

-- Shared version of SelectWeapon
function PLAYER:SwitchWeapon( weapon )
	if ( isstring( weapon )) then
		local pWeapon = self:GetWeapon( weapon )
		
		if ( pWeapon ~= NULL ) then
			self.m_pNewWeapon = pWeapon
		end
	elseif ( weapon:GetOwner() == self ) then
		self.m_pNewWeapon = weapon
	end
end

function PLAYER:CSDecayPunchAngle( aPunch )
	local flLen = aPunch:NormalizeInPlace()
	flLen = flLen - (10 + flLen * 0.5) * FrameTime()
	
	return aPunch * (flLen < 0 and 0 or flLen)
end

function PLAYER:SharedRandomFloat( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomFloat( flMin, flMax )
end

function PLAYER:SharedRandomInt( sName, iMin, iMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return random.RandomInt( iMin, iMax )
end

function PLAYER:SharedRandomVector( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))

	return Vector( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ) )
end

function PLAYER:SharedRandomAngle( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))

	return Angle( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end

function PLAYER:SharedRandomColor( sName, flMin, flMax, iAdditionalSeed )
	random.SetSeed( util.SeedFileLineHash( math.MD5Random( self:GetCurrentCommand():CommandNumber() ) % 0x80000000, sName, iAdditionalSeed ))
	
	return Color( random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ), 
			random.RandomFloat( flMin, flMax ))
end
