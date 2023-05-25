if (CLIENT) then
    hook.Add( "InitPostEntity", "Ready", function()
        net.Start( "load.bank.data.system" )
        net.SendToServer()
    end )
end

if (SERVER) then
    util.AddNetworkString( "load.bank.data.system" )
    net.Receive( "load.bank.data.system", function( len, user )
        if (not file.Exists("spectrum-bank/" .. user:SteamID64() .. ".dat", "DATA")) then
            file.Write("spectrum-bank/" .. user:SteamID64() .. ".dat", "0")
        end
    end)
end