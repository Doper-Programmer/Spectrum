NextUsing = 0
-- Основные сведения --
SWEP.PrintName 				= "Банковская карта"
SWEP.Author 				= "*RedHat*"
SWEP.Instructions			= "Инструкция"
SWEP.Category 				= "SpectrumRolePlay"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
-------------------	

-- Патроны --						
SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
							
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
------------------------

SWEP.Weight					= 1
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

-- Позиция в Weapon Selector --							
SWEP.Slot					= 2
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/v_slam.mdl"
SWEP.WorldModel				= "models/weapons/w_slam.mdl"



if (SERVER) then  
    util.AddNetworkString("Bank.informate.swep") 
    function SWEP:PrimaryAttack()

        if (CurTime() < NextUsing) then return end
        
        NextUsing = (CurTime() + 1)
        
        if (file.Exists("spectrum-bank/" .. self.Owner:SteamID64() .. ".dat", "DATA")) then
            net.Start("Bank.informate.swep")
                net.WriteString(file.Read("spectrum-bank/" .. self.Owner:SteamID64() .. ".dat"))
            net.Send(self.Owner)
        end
    end
    
    
    function SWEP:SecondaryAttack()

    end
    
    function SWEP:Deploy()
        return false
    end
    
    function SWEP:ShouldDropOnDie()
        return false
    end
    
end

if (CLIENT) then
    net.Receive("Bank.informate.swep", function() 
       local balance = net.ReadString()
       chat.AddText(Color(0, 100, 220), "Баланс карты", Color(255, 255, 255), " | " , Color(0, 155, 0),
       DarkRP.formatMoney(tonumber(balance)))
    end)
end