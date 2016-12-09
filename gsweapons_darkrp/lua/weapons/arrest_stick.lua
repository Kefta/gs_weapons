SWEP.Base = "stick_base"

SWEP.PrintName = "#DarkRP_ArrestStick"
SWEP.Spawnable = true
SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.Secondary.Automatic = false

SWEP.StickColor = color_red or Color(255, 0, 0)

-- Compatibility
SWEP.IsDarkRPArrestStick = true

DarkRP.hookStub({
    name = "canArrest",
    description = "Whether someone can arrest another player.",
    parameters = {
        {
            name = "arrester",
            description = "The player trying to arrest someone.",
            type = "Player"
        },
        {
            name = "arrestee",
            description = "The player being arrested.",
            type = "Player"
        }
    },
    returns = {
        {
            name = "canArrest",
            description = "A yes or no as to whether the arrester can arrest the arestee.",
            type = "boolean"
        },
        {
            name = "message",
            description = "The message that is shown when they can't arrest the player.",
            type = "string"
        }
    },
    realm = "Server"
})

if ( CLIENT ) then
	SWEP.Category = "DarkRP (Utility)"
else
	local color_cyan = color_cyan or Color(0, 255, 255)
	local sLog = "%s (%s) arrested %s"
	
	function SWEP:Hit( tr )
		local pPlayer = self:GetOwner()
		local pEntity = tr.Entity
		
		if ( pEntity.onArrestStickUsed ) then
			pEntity:onArrestStickUsed( pPlayer )
		elseif ( pEntity:IsPlayer() ) then
			local bCanArrest, sMessage = hook.Call( "canArrest", DarkRP.hooks, pPlayer, pEntity )
			
			if ( bCanArrest ) then
				pEntity:arrest( nil, pPlayer )
				
				local sName = pPlayer:Nick()
				DarkRP.notify( pEntity, 0, 20, DarkRP.getPhrase( "youre_arrested_by", sName ))
				
				if ( pPlayer.SteamName ) then
					DarkRP.log( string.format( sLog, sName, pPlayer:SteamID(), pEntity:Nick() ), color_cyan )
				end
			elseif ( sMessage ) then
				DarkRP.notify( pPlayer, 1, 5, sMessage )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	local pPlayer = self:GetOwner()
	
	if ( pPlayer:HasWeapon("unarrest_stick")) then
		pPlayer.m_pNewWeapon = pPlayer:GetWeapon("unarrest_stick")
	end
end
