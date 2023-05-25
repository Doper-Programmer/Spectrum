
SSLib = { }

if (CLIENT) then
    net.Receive("bank.system.pay.transferFrom", function() 
        local data = net.ReadTable()
        chat.AddText("Вы перевели на карту " .. data.transferToUser:GetName() .. " " .. DarkRP.formatMoney(data.transferMoney))
    end)

    net.Receive("bank.system.pay.transferTo", function() 
        local data = net.ReadTable()
            chat.AddText("Вы получили на карту ", DarkRP.formatMoney(data.transferMoney) , 
            " от ", data.transferFromUser:GetName()
        ) 
    end)
end


if (SERVER) then
    util.AddNetworkString("bank.system.pay.transferFrom")
    util.AddNetworkString("bank.system.pay.transferTo")

    hook.Add("PlayerSay", "pay check", function(user, mess)
        if (string.find(string.lower(mess), "/pay")) then
            local message = string.sub(string.lower(mess), #"/pay" + 2)
            local args    = string.Split(message, " ")

            if (#args == 2) then
                local transferFrom = user
                local transferTo   = nil

                for k, v in pairs(player.GetAll()) do
                    if (string.lower(v:GetName()) == string.Trim(args[2])) then
                        transferTo = v
                        break
                    end
                end 
                

                if (transferTo != nil) then
                    local transUserMoney = tonumber(args[1])
                    local transferRequest = 
                    {
                        from = 
                        {
                            transferToUser = transferTo,
                            transferMoney    = transUserMoney
                        },

                        to = 
                        {
                            transferFromUser = transferFrom,
                            transferMoney    = transUserMoney
                        }
                    }
                    if (file.Exists("spectrum-bank/" .. transferFrom:SteamID64() .. ".dat", "DATA") 
                    and file.Exists("spectrum-bank/" .. transferTo:SteamID64() .. ".dat", "DATA")) then
                        local x1 = file.Read("spectrum-bank/" .. transferFrom:SteamID64() .. ".dat", "DATA")
                        local x2 = file.Read("spectrum-bank/" .. transferTo:SteamID64() .. ".dat", "DATA")
                        
                        if (transUserMoney >= tonumber(x2)) then
                            file.Write("spectrum-bank/" .. transferFrom:SteamID64() .. ".dat", "" .. (tonumber(x1) - transUserMoney))
                            file.Write("spectrum-bank/" .. transferTo:SteamID64() .. ".dat", "" .. (tonumber(x2) + transUserMoney))

                            net.Start("bank.system.pay.transferFrom")
                                net.WriteTable(transferRequest.from)
                            net.Send(transferFrom)
        
                            net.Start("bank.system.pay.transferTo")
                                net.WriteTable(transferRequest.to)
                            net.Send(transferTo)
                        end
                    end
                end
            end
            return ""
        end
    end)

end