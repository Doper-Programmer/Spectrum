NextUsing = 0
-- Основные сведения --
SWEP.PrintName 				= "Кошёлек"
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

SWEP.ViewModel				= "models/weapons/v_hands.mdl"
SWEP.WorldModel				= ""



if (SERVER) then  
    util.AddNetworkString("Money.informate.swep") 
    function SWEP:PrimaryAttack()
        
        if (CurTime() < NextUsing) then return end
        
        NextUsing = (CurTime() + 1)

        net.Start("Money.informate.swep")
            net.WriteTable(
                {
                    Salary = false, 
                    money = DarkRP.formatMoney(self.Owner:getDarkRPVar("money"))
                }
            )
        net.Send(self.Owner)

    end
    
    
    function SWEP:SecondaryAttack()
        if (CurTime() < NextUsing) then return end
        
        NextUsing = (CurTime() + 1)

        net.Start("Money.informate.swep")
            net.WriteTable(
                {
                    Salary = true, 
                    money = DarkRP.formatMoney(self.Owner:getDarkRPVar("salary"))
                }
            )
        net.Send(self.Owner)
    end
    
    function SWEP:Deploy()
        return false
    end
    
    function SWEP:ShouldDropOnDie()
        return false
    end
    
end

if (CLIENT) then
    net.Receive("Money.informate.swep", function() 
        local data = net.ReadTable()
        if !data.Salary then
            chat.AddText(Color(0, 100, 220), "Кошелёк", Color(255, 255, 255), " | " , Color(0, 155, 0), data.money)
        elseif data.Salary then
            chat.AddText(Color(0, 100, 220), "Текущая зарплата", Color(255, 255, 255), " | " , Color(0, 155, 0), data.money)
        end
    end)
end