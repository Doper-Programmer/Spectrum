hook.Add( "HUDShouldDraw", "HideHUD", function( name )
    if name == "CHudHealth" or name == "CHudBattery" or name == "CHudSuitPower" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" or name == "DarkRP_LocalPlayerHUD"  or name == "DarkRP_Hungermod" or name == "DarkRP_LockdownHUD" or name == "CHudVoiceSelfStatus" or name == "CHudVoiceStatus" then
        return false
    end  
end)
