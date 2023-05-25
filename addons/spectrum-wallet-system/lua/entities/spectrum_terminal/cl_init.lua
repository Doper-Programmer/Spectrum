include("shared.lua")



surface.CreateFont( "TerminalTitle", {
    font = "DermaLarge", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = true,
    size = ScreenScale(12),
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = false,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
} )


surface.CreateFont( "UITerminal", {
    font = "DermaLarge", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = true,
    size = ScreenScale(6),
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = false,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
} )

surface.CreateFont( "TerminalTitleShop", {
    font = "DermaLarge", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = true,
    size = ScreenScale(15),
    weight = 300,
    blursize = 0,
    scanlines = 0,
    antialias = false,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
} )



surface.CreateFont( "TerminalTitlePrices", {
    font = "DermaLarge", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = true,
    size = ScreenScale(19),
    weight = 800,
    blursize = 0,
    scanlines = 0,
    antialias = false,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
} )


local data = {}


function ENT:Draw()
    local user = LocalPlayer()
    local dist = user:EyePos():Distance( self:GetPos() )
    
    local activityUI = false

    local ang = self:GetAngles()
    local pos = self:GetPos()

    local viewDistUI, viewDistObject = 5000, 10000
    local viewMaxDistUI, viewMaxDistObject = viewDistUI, viewDistObject
    local uiRender = dist < viewMaxDistUI
    local objectRender = dist < viewMaxDistObject

    pos = pos + ang:Up() * 1.55

        
    if (uiRender) then
        self:DrawModel()
        cam.Start3D2D(pos, ang, 0.02)
            draw.RoundedBox(1.5, -300, -600, 600, 1200, Color(30, 30, 30))
            draw.DrawText( "SPECTRUM BANK SYSTEM", "TerminalTitle", 0, 540, Color( 225, 225, 0), TEXT_ALIGN_CENTER)
            
            draw.DrawText( "Терминал пользователя\n" .. (data.username or ""), "TerminalTitleShop", 0, -580, Color( 225, 225, 255), TEXT_ALIGN_CENTER)
            draw.DrawText( data.price or "Цена не установлена", "TerminalTitlePrices", 0, -100, Color( 225, 225, 255), TEXT_ALIGN_CENTER)
            
            draw.RoundedBox(3, -175, -15, 350, 100, Color(60, 40, 40))
            draw.DrawText( "Оплатить", "TerminalTitlePrices", 0, 0, Color( 225, 225, 225), TEXT_ALIGN_CENTER)
            
        // 28 max
        cam.End3D2D()
    end

    net.Receive("terminal.request", function() 
        local entity = net.ReadTable()


        if (entity.owner:IsValid()) then data.username = entity.owner:Nick() end
        if (entity.owner != entity.user) and (dFrameTerminal == nil) then
            dFrameTerminal = vgui.Create("DFrame")
            dFrameTerminal:SetSize(500, 150)
            dFrameTerminal:Center()
            dFrameTerminal:SetTitle("")
            dFrameTerminal:MakePopup()
            dFrameTerminal:SetDraggable(false)
            dFrameTerminal:ShowCloseButton(false)

            dFrameTerminal.Paint = function(_, w, h) 
                draw.RoundedBox(3, 0, 0, w, h, Color(30, 30, 30))
            end

            
            local button = {}
            local text = {}

            button.accept = vgui.Create("DButton", dFrameTerminal)
            button.accept:SetSize(200, 25)
            button.accept:SetPos(dFrameTerminal:GetWide() - 200, dFrameTerminal:GetTall() - 25)
            button.accept:SetText("Принять изменения")
            button.accept:SetColor(Color(255, 255, 255))
            button.accept.Paint = function(_, w, h) 
                draw.RoundedBox(3, 0, 0, w, h, Color(60, 40, 40))
            end


            button.exit = vgui.Create("DButton", dFrameTerminal)
            button.exit:SetSize(40, 20)
            button.exit:SetPos(dFrameTerminal:GetWide() - 40, 0)
            button.exit:SetColor(Color(255, 255, 255))
            button.exit:SetText("X")
            button.exit.Paint = function(_, w, h) 
                draw.RoundedBox(3, 0, 0, w, h, Color(120, 30, 30))
            end

            button.exit.DoClick = function() 
                dFrameTerminal:Remove()
                dFrameTerminal = nil
            end


            /*text.shopname = vgui.Create("DTextEntry", dFrameTerminal)
            text.shopname:SetSize(500, 30)
            text.shopname:SetPos((dFrameTerminal:GetWide() - 500) / 2, (dFrameTerminal:GetTall() - 100) / 2)
            text.shopname:SetValue("Название магазина")
            */
            text.price = vgui.Create("DTextEntry", dFrameTerminal)
            text.price:SetSize(500, 30)
            text.price:SetPos((dFrameTerminal:GetWide() - 500) / 2, (dFrameTerminal:GetTall() - 20) / 2)
            text.price:SetValue("Установите цену")

            button.accept.DoClick = function(self)
                data.price = DarkRP.formatMoney(text.price:GetInt()) == "$0" and "Цена не установлена" or DarkRP.formatMoney(text.price:GetInt())
                dFrameTerminal:Remove()
                dFrameTerminal = nil
            end 
        end




        if (entity.owner == entity.user) and (dFrameTerminal == nil) then
            dFrameTerminal = vgui.Create("DFrame")
            dFrameTerminal:SetSize(300, 150)
            dFrameTerminal:Center()
            dFrameTerminal:SetTitle("")
            dFrameTerminal:MakePopup()
            dFrameTerminal:SetDraggable(false)
            dFrameTerminal:ShowCloseButton(false)

            dFrameTerminal.Paint = function(_, w, h) 
                draw.RoundedBox(3, 0, 0, w, h, Color(30, 30, 30))
            end

            
            local button = {}
            local text = {}

            button.accept = vgui.Create("DButton", dFrameTerminal)
            button.accept:SetSize(300, 25)
            button.accept:SetPos(dFrameTerminal:GetWide() - 300, dFrameTerminal:GetTall() - 55)
            button.accept:SetColor(Color(255, 255, 255))
            button.accept:SetText("Подтвердить")
            button.accept:SetFont("UITerminal")
            button.accept.Paint = function(_, w, h) 
                draw.RoundedBox(3, 0, 0, w, h, Color(60, 40, 40))
            end

            button.canel = vgui.Create("DButton", dFrameTerminal)
            button.canel:SetSize(300, 25)
            button.canel:SetPos(dFrameTerminal:GetWide() - 300, dFrameTerminal:GetTall() - 25)
            button.canel:SetColor(Color(255, 255, 255))
            button.canel:SetText("Отмена")
            button.canel:SetFont("UITerminal")
            button.canel.Paint = function(_, w, h) 
                draw.RoundedBox(3, 0, 0, w, h, Color(60, 40, 40))
            end

            button.exit = vgui.Create("DButton", dFrameTerminal)
            button.exit:SetSize(40, 20)
            button.exit:SetPos(dFrameTerminal:GetWide() - 40, 0)
            button.exit:SetColor(Color(255, 255, 255))
            button.exit:SetText("X")
            button.exit.Paint = function(_, w, h) 
                draw.RoundedBox(3, 0, 0, w, h, Color(120, 30, 30))
            end

            /*
                До делать систему терминала и ui
                начать делать банкомат
            */

            text.price = vgui.Create("DLabel", dFrameTerminal)
            text.price:SetText("Оплата на сумму \n" .. (data.price or "Цена не установлена"))
            text.price:SetFont("UITerminal")
            text.price:SetSize(300, 100)
            text.price:SetPos(dFrameTerminal:GetWide() - 300, -25)


            button.accept.DoClick = function()
                dFrameTerminal:Remove()
                dFrameTerminal = nil
            end

            button.canel.DoClick = function()
                dFrameTerminal:Remove()
                dFrameTerminal = nil
            end

            button.exit.DoClick = function() 
                dFrameTerminal:Remove()
                dFrameTerminal = nil
            end
        end
    end)
end

