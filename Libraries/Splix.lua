-- // Variables
local Workspace = game:GetService("Workspace")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
-- UI Variables
local Library = {
    Drawings = {},
    Hidden = {},
    Connections = {},
    Pointers = {},
    Began = {},
    Ended = {},
    Changed = {},
    Folders = {
        Main = "Adroitlyz Hub",
        Assets = "Adroitlyz Hub/Assets",
        Configs = "Adroitlyz Hub/Configs"
    },
    Shared = {
        Initialized = false,
        Fps = 0,
        Ping = 0
    }
}
--
if not isfolder(Library.Folders.Main) then
    makefolder(Library.Folders.Main)
end
--
if not isfolder(Library.Folders.Assets) then
    makefolder(Library.Folders.Assets)
end
--
if not isfolder(Library.Folders.Configs) then
    makefolder(Library.Folders.Configs)
end
--
local Utility = {}
local pages = {}
local sections = {}
-- Theme Variables
--local themes = {}
local Theme = {
    accent = Color3.fromRGB(50, 100, 255),
    light_contrast = Color3.fromRGB(30, 30, 30),
    dark_contrast = Color3.fromRGB(20, 20, 20),
    outline = Color3.fromRGB(0, 0, 0),
    inline = Color3.fromRGB(50, 50, 50),
    textcolor = Color3.fromRGB(255, 255, 255),
    textborder = Color3.fromRGB(0, 0, 0),
    cursoroutline = Color3.fromRGB(10, 10, 10),
    font = 2,
    textsize = 13
}
-- // Utility Functions
do
    function Utility:Size(xScale,xOffset,yScale,yOffset,instance)
        if instance then
            local x = xScale*instance.Size.x+xOffset
            local y = yScale*instance.Size.y+yOffset
            --
            return Vector2.new(x,y)
        else
            local vx,vy = Workspace.CurrentCamera.ViewportSize.x, Workspace.CurrentCamera.ViewportSize.y
            --
            local x = xScale*vx+xOffset
            local y = yScale*vy+yOffset
            --
            return Vector2.new(x,y)
        end
    end
    --
    function Utility:Position(xScale,xOffset,yScale,yOffset,instance)
        if instance then
            local x = instance.Position.x+xScale*instance.Size.x+xOffset
            local y = instance.Position.y+yScale*instance.Size.y+yOffset
            --
            return Vector2.new(x,y)
        else
            local vx,vy = Workspace.CurrentCamera.ViewportSize.x, Workspace.CurrentCamera.ViewportSize.y
            --
            local x = xScale*vx+xOffset
            local y = yScale*vy+yOffset
            --
            return Vector2.new(x,y)
        end
    end
    --
	function Utility:Create(instanceType, instanceOffset, instanceProperties, instanceParent)
        local instanceType = instanceType or "Frame"
        local instanceOffset = instanceOffset or {Vector2.new(0,0)}
        local instanceProperties = instanceProperties or {}
        local instanceHidden = false
        local instance = nil
        --
		if instanceType == "Frame" or instanceType == "frame" then
            local frame = Drawing.new("Square")
            frame.Visible = true
            frame.Filled = true
            frame.Thickness = 0
            frame.Color = Color3.fromRGB(255,255,255)
            frame.Size = Vector2.new(100,100)
            frame.Position = Vector2.new(0,0)
            frame.ZIndex = 50
            frame.Transparency = Library.Shared.Initialized and 1 or 0
            instance = frame
        elseif instanceType == "TextLabel" or instanceType == "textlabel" then
            local text = Drawing.new("Text")
            text.Font = 3
            text.Visible = true
            text.Outline = true
            text.Center = false
            text.Color = Color3.fromRGB(255,255,255)
            text.ZIndex = 50
            text.Transparency = Library.Shared.Initialized and 1 or 0
            instance = text
        elseif instanceType == "Triangle" or instanceType == "triangle" then
            local frame = Drawing.new("Triangle")
            frame.Visible = true
            frame.Filled = true
            frame.Thickness = 0
            frame.Color = Color3.fromRGB(255,255,255)
            frame.ZIndex = 50
            frame.Transparency = Library.Shared.Initialized and 1 or 0
            instance = frame
        elseif instanceType == "Image" or instanceType == "image" then
            local image = Drawing.new("Image")
            image.Size = Vector2.new(12,19)
            image.Position = Vector2.new(0,0)
            image.Visible = true
            image.ZIndex = 50
            image.Transparency = Library.Shared.Initialized and 1 or 0
            instance = image
        elseif instanceType == "Circle" or instanceType == "circle" then
            local circle = Drawing.new("Circle")
            circle.Visible = false
            circle.Color = Color3.fromRGB(255, 0, 0)
            circle.Thickness = 1
            circle.NumSides = 30
            circle.Filled = true
            circle.Transparency = 1
            circle.ZIndex = 50
            circle.Radius = 50
            circle.Transparency = Library.Shared.Initialized and 1 or 0
            instance = circle
        elseif instanceType == "Quad" or instanceType == "quad" then
            local quad = Drawing.new("Quad")
            quad.Visible = false
            quad.Color = Color3.fromRGB(255, 255, 255)
            quad.Thickness = 1.5
            quad.Transparency = 1
            quad.ZIndex = 50
            quad.Filled = false
            quad.Transparency = Library.Shared.Initialized and 1 or 0
            instance = quad
        elseif instanceType == "Line" or instanceType == "line" then
            local line = Drawing.new("Line")
            line.Visible = false
            line.Color = Color3.fromRGB(255, 255, 255)
            line.Thickness = 1.5
            line.Transparency = 1
            line.Thickness = 1.5
            line.ZIndex = 50
            line.Transparency = Library.Shared.Initialized and 1 or 0
            instance = line
        end
        --
        if instance then
            for i, v in pairs(instanceProperties) do
                if i == "Hidden" or i == "hidden" then
                    instanceHidden = true
                else
                    if Library.Shared.Initialized then
                        instance[i] = v
                    else
                        if i ~= "Transparency" then
                            instance[i] = v
                        end
                    end
                end
            end
            --
            if not instanceHidden then
                Library.Drawings[#Library.Drawings + 1] = {instance, instanceOffset, instanceProperties["Transparency"] or 1}
            else
                Library.Hidden[#Library.Hidden + 1] = {instance}
            end
            --
            if instanceParent then
                instanceParent[#instanceParent + 1] = instance
            end
            --
            return instance
        end
	end
    --
    function Utility:UpdateOffset(instance, instanceOffset)
        for i,v in pairs(Library.Drawings) do
            if v[1] == instance then
                v[2] = instanceOffset
            end
        end
    end
    --
    function Utility:UpdateTransparency(instance, instanceTransparency)
        for i,v in pairs(Library.Drawings) do
            if v[1] == instance then
                v[3] = instanceTransparency
            end
        end
    end
    --
    function Utility:Remove(instance, hidden)
        local ind = 0
        --
        for i,v in pairs(hidden and Library.Hidden or Library.Drawings) do
            if v[1] == instance then
                ind = i
                if hidden then
                    v[1] = nil
                else
                    v[2] = nil
                    v[1] = nil
                end
            end
        end
        --
        table.remove(hidden and Library.Hidden or Library.Drawings, ind)
        instance:Remove()
    end
    --
    function Utility:GetSubPrefix(str)
        local str = tostring(str):gsub(" ","")
        local var = ""
        --
        if #str == 2 then
            local sec = string.sub(str,#str,#str+1)
            var = sec == "1" and "st" or sec == "2" and "nd" or sec == "3" and "rd" or "th"
        end
        --
        return var
    end
    --
    function Utility:Connection(connectionType, connectionCallback)
        local connection = connectionType:Connect(connectionCallback)
        Library.Connections[#Library.Connections + 1] = connection
        --
        return connection
    end
    --
    function Utility:Disconnect(connection)
        for i,v in pairs(Library.Connections) do
            if v == connection then
                Library.Connections[i] = nil
                v:Disconnect()
            end
        end
    end
    --
    function Utility:MouseLocation()
        return InputService:GetMouseLocation()
    end
    --
    function Utility:MouseOverDrawing(values, valuesAdd)
        local valuesAdd = valuesAdd or {}
        local values = {
            (values[1] or 0) + (valuesAdd[1] or 0),
            (values[2] or 0) + (valuesAdd[2] or 0),
            (values[3] or 0) + (valuesAdd[3] or 0),
            (values[4] or 0) + (valuesAdd[4] or 0)
        }
        --
        local mouseLocation = Utility:MouseLocation()
	    return (mouseLocation.x >= values[1] and mouseLocation.x <= (values[1] + (values[3] - values[1]))) and (mouseLocation.y >= values[2] and mouseLocation.y <= (values[2] + (values[4] - values[2])))
    end
    --
    function Utility:GetTextBounds(text, textSize, font)
        local textbounds = Vector2.new(0, 0)
        --
        local textlabel = Utility:Create("TextLabel", {Vector2.new(0, 0)}, {
            Text = text,
            Size = textSize,
            Font = font,
            Hidden = true
        })
        --
        textbounds = textlabel.TextBounds
        Utility:Remove(textlabel, true)
        --
        return textbounds
    end
    --
    function Utility:GetScreenSize()
        return Workspace.CurrentCamera.ViewportSize
    end
    --
    function Utility:LoadImage(instance, imageName, imageLink)
        local data
        --
        if isfile(Library.Folders.Assets.."/"..imageName..".png") then
            data = readfile(Library.Folders.Assets.."/"..imageName..".png")
        else
            if imageLink then
                data = game:HttpGet(imageLink)
                writefile(Library.Folders.Assets.."/"..imageName..".png", data)
            else
                return
            end
        end
        --
        if data and instance then
            instance.Data = data
        end
    end
    --
    function Utility:Lerp(instance, instanceTo, instanceTime)
        local currentTime = 0
        local currentIndex = {}
        local connection
        --
        for i,v in pairs(instanceTo) do
            currentIndex[i] = instance[i]
        end
        --
        local function lerp()
            for i,v in pairs(instanceTo) do
                instance[i] = ((v - currentIndex[i]) * currentTime / instanceTime) + currentIndex[i]
            end
        end
        --
        connection = RunService.RenderStepped:Connect(function(delta)
            if currentTime < instanceTime then
                currentTime = currentTime + delta
                lerp()
            else
                connection:Disconnect()
            end
        end)
    end
    --
    function Utility:Combine(table1, table2)
        local table3 = {}
        for i,v in pairs(table1) do table3[i] = v end
        local t = #table3
        for z,x in pairs(table2) do table3[z + t] = x end
        return table3
    end
end
-- // Library Functions
do
    Library.__index = Library
	pages.__index = pages
	sections.__index = sections
    --
    function Library:New(info)
		local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "UI Title"
        local size = info.size or info.Size or Vector2.new(504,604)
        local accent = info.accent or info.Accent or info.color or info.Color or Theme.accent
        --
        Theme.accent = accent
        --
        local window = {pages = {}, isVisible = false, uibind = Enum.KeyCode.Z, currentPage = nil, fading = false, dragging = false, drag = Vector2.new(0,0), currentContent = {frame = nil, dropdown = nil, multibox = nil, colorpicker = nil, keybind = nil}}
        --
        local main_frame = Utility:Create("Frame", {Vector2.new(0,0)}, {
            Size = Utility:Size(0, size.X, 0, size.Y),
            Position = Utility:Position(0.5, -(size.X/2) ,0.5, -(size.Y/2)),
            Color = Theme.outline
        });window["main_frame"] = main_frame
        --
        local frame_inline = Utility:Create("Frame", {Vector2.new(1,1), main_frame}, {
            Size = Utility:Size(1, -2, 1, -2, main_frame),
            Position = Utility:Position(0, 1, 0, 1, main_frame),
            Color = Theme.accent
        })
        --
        local inner_frame = Utility:Create("Frame", {Vector2.new(1,1), frame_inline}, {
            Size = Utility:Size(1, -2, 1, -2, frame_inline),
            Position = Utility:Position(0, 1, 0, 1, frame_inline),
            Color = Theme.light_contrast
        })
        --
        local title = Utility:Create("TextLabel", {Vector2.new(4,2), inner_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 4, 0, 2, inner_frame)
        })
        --
        local inner_frame_inline = Utility:Create("Frame", {Vector2.new(4,18), inner_frame}, {
            Size = Utility:Size(1, -8, 1, -22, inner_frame),
            Position = Utility:Position(0, 4, 0, 18, inner_frame),
            Color = Theme.inline
        })
        --
        local inner_frame_inline2 = Utility:Create("Frame", {Vector2.new(1,1), inner_frame_inline}, {
            Size = Utility:Size(1, -2, 1, -2, inner_frame_inline),
            Position = Utility:Position(0, 1, 0, 1, inner_frame_inline),
            Color = Theme.outline
        })
        --
        local back_frame = Utility:Create("Frame", {Vector2.new(1,1), inner_frame_inline2}, {
            Size = Utility:Size(1, -2, 1, -2, inner_frame_inline2),
            Position = Utility:Position(0, 1, 0, 1, inner_frame_inline2),
            Color = Theme.dark_contrast
        });window["back_frame"] = back_frame
        --
        local tab_frame_inline = Utility:Create("Frame", {Vector2.new(4,24), back_frame}, {
            Size = Utility:Size(1, -8, 1, -28, back_frame),
            Position = Utility:Position(0, 4, 0, 24, back_frame),
            Color = Theme.outline
        })
        --
        local tab_frame_inline2 = Utility:Create("Frame", {Vector2.new(1,1), tab_frame_inline}, {
            Size = Utility:Size(1, -2, 1, -2, tab_frame_inline),
            Position = Utility:Position(0, 1, 0, 1, tab_frame_inline),
            Color = Theme.inline
        })
        --
        local tab_frame = Utility:Create("Frame", {Vector2.new(1,1), tab_frame_inline2}, {
            Size = Utility:Size(1, -2, 1, -2, tab_frame_inline2),
            Position = Utility:Position(0, 1, 0, 1, tab_frame_inline2),
            Color = Theme.light_contrast
        });window["tab_frame"] = tab_frame
        --
        function window:GetConfig()
            local config = {}
            --
            for i,v in pairs(Library.Pointers) do
                if typeof(v:Get()) == "table" and v:Get().Transparency then
                    local hue, sat, val = v:Get().Color:ToHSV()
                    config[i] = {Color = {hue, sat, val}, Transparency = v:Get().Transparency}
                else
                    config[i] = v:Get()
                end
            end
            --
            return game:GetService("HttpService"):JSONEncode(config)
        end
        --
        function window:LoadConfig(config)
            local config = HttpService:JSONDecode(config)
            --
            for i,v in pairs(config) do
                if Library.Pointers[i] then
                    Library.Pointers[i]:Set(v)
                end
            end
        end
        --
        function window:Move(vector)
            for i,v in pairs(Library.Drawings) do
                if v[2][2] then
                    v[1].Position = Utility:Position(0, v[2][1].X, 0, v[2][1].Y, v[2][2])
                else
                    v[1].Position = Utility:Position(0, vector.X, 0, vector.Y)
                end
            end
        end
        --
        function window:CloseContent()
            if window.currentContent.dropdown and window.currentContent.dropdown.open then
                local dropdown = window.currentContent.dropdown
                dropdown.open = not dropdown.open
                Utility:LoadImage(dropdown.dropdown_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                --
                for i,v in pairs(dropdown.holder.drawings) do
                    Utility:Remove(v)
                end
                --
                dropdown.holder.drawings = {}
                dropdown.holder.buttons = {}
                dropdown.holder.inline = nil
                --
                window.currentContent.frame = nil
                window.currentContent.dropdown = nil
            elseif window.currentContent.multibox and window.currentContent.multibox.open then
                local multibox = window.currentContent.multibox
                multibox.open = not multibox.open
                Utility:LoadImage(multibox.multibox_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                --
                for i,v in pairs(multibox.holder.drawings) do
                    Utility:Remove(v)
                end
                --
                multibox.holder.drawings = {}
                multibox.holder.buttons = {}
                multibox.holder.inline = nil
                --
                window.currentContent.frame = nil
                window.currentContent.multibox = nil
            elseif window.currentContent.colorpicker and window.currentContent.colorpicker.open then
                local colorpicker = window.currentContent.colorpicker
                colorpicker.open = not colorpicker.open
                --
                for i,v in pairs(colorpicker.holder.drawings) do
                    Utility:Remove(v)
                end
                --
                colorpicker.holder.drawings = {}
                --
                window.currentContent.frame = nil
                window.currentContent.colorpicker = nil
            elseif window.currentContent.keybind and window.currentContent.keybind.open then
                local modemenu = window.currentContent.keybind.modemenu
                window.currentContent.keybind.open = not window.currentContent.keybind.open
                --
                for i,v in pairs(modemenu.drawings) do
                    Utility:Remove(v)
                end
                --
                modemenu.drawings = {}
                modemenu.buttons = {}
                modemenu.frame = nil
                --
                window.currentContent.frame = nil
                window.currentContent.keybind = nil
            end
        end
        --
        function window:IsOverContent()
            local isOver = false
            --
            if window.currentContent.frame and Utility:MouseOverDrawing({window.currentContent.frame.Position.X,window.currentContent.frame.Position.Y,window.currentContent.frame.Position.X + window.currentContent.frame.Size.X,window.currentContent.frame.Position.Y + window.currentContent.frame.Size.Y}) then
                isOver = true
            end
            --
            return isOver
        end
        --
        function window:Unload()
            for i,v in pairs(Library.Connections) do
                v:Disconnect()
                v = nil
            end
            --
            for i,v in next, Library.Hidden do
                coroutine.wrap(function()
                    if v[1] and v[1].Remove and v[1].__OBJECT_EXISTS then
                        local instance = v[1]
                        v[1] = nil
                        v = nil
                        --
                        instance:Remove()
                    end
                end)()
            end
            --
            for i,v in pairs(Library.Drawings) do
                coroutine.wrap(function()
                    if v[1].__OBJECT_EXISTS then
                        local instance = v[1]
                        v[2] = nil
                        v[1] = nil
                        v = nil
                        --
                        instance:Remove()
                    end
                end)()
            end
            --
            for i,v in pairs(Library.Began) do
                v = nil
            end
            --
            for i,v in pairs(Library.Ended) do
                v = nil
            end
            --
            for i,v in pairs(Library.Changed) do
                v = nil
            end
            --
            Library.Drawings = nil
            Library.Hidden = nil
            Library.Connections = nil
            Library.Began = nil
            Library.Ended = nil
            Library.Changed = nil
            --
            InputService.MouseIconEnabled = true
        end
        --
        function window:Watermark(info)
            window.watermark = {visible = false}
            --
            local info = info or {}
            local watermark_name = info.name or info.Name or info.title or info.Title or string.format("$$ Splix || uid : %u || ping : %u || fps : %u", 1, 100, 200)
            --
            local text_bounds = Utility:GetTextBounds(watermark_name, Theme.textsize, Theme.font)
            --
            local watermark_outline = Utility:Create("Frame", {Vector2.new(100,38/2-10)}, {
                Size = Utility:Size(0, text_bounds.X+20, 0, 21),
                Position = Utility:Position(0, 100, 0, 38/2-10),
                Hidden = true,
                ZIndex = 60,
                Color = Theme.outline,
                Visible = window.watermark.visible
            })window.watermark.outline = watermark_outline
            --
            local watermark_inline = Utility:Create("Frame", {Vector2.new(1,1), watermark_outline}, {
                Size = Utility:Size(1, -2, 1, -2, watermark_outline),
                Position = Utility:Position(0, 1, 0, 1, watermark_outline),
                Hidden = true,
                ZIndex = 60,
                Color = Theme.inline,
                Visible = window.watermark.visible
            })
            --
            local watermark_frame = Utility:Create("Frame", {Vector2.new(1,1), watermark_inline}, {
                Size = Utility:Size(1, -2, 1, -2, watermark_inline),
                Position = Utility:Position(0, 1, 0, 1, watermark_inline),
                Hidden = true,
                ZIndex = 60,
                Color = Theme.light_contrast,
                Visible = window.watermark.visible
            })
            --
            local watermark_accent = Utility:Create("Frame", {Vector2.new(0,0), watermark_frame}, {
                Size = Utility:Size(1, 0, 0, 1, watermark_frame),
                Position = Utility:Position(0, 0, 0, 0, watermark_frame),
                Hidden = true,
                ZIndex = 60,
                Color = Theme.accent,
                Visible = window.watermark.visible
            })
            --
            local watermark_title = Utility:Create("TextLabel", {Vector2.new(2 + 6,4), watermark_outline}, {
                Text = string.format("splix - fps : %u - uid : %u", 35, 2),
                Size = Theme.textsize,
                Font = Theme.font,
                Color = Theme.textcolor,
                OutlineColor = Theme.textborder,
                Hidden = true,
                ZIndex = 60,
                Position = Utility:Position(0, 2 + 6, 0, 4, watermark_outline),
                Visible = window.watermark.visible
            })
            --
            function window.watermark:UpdateSize()
                watermark_outline.Size = Utility:Size(0, watermark_title.TextBounds.X + 4 + (6*2), 0, 21)
                watermark_inline.Size = Utility:Size(1, -2, 1, -2, watermark_outline)
                watermark_frame.Size = Utility:Size(1, -2, 1, -2, watermark_inline)
                watermark_accent.Size = Utility:Size(1, 0, 0, 1, watermark_frame)
            end
            --
            function window.watermark:Visibility()
                watermark_outline.Visible = window.watermark.visible
                watermark_inline.Visible = window.watermark.visible
                watermark_frame.Visible = window.watermark.visible
                watermark_accent.Visible = window.watermark.visible
                watermark_title.Visible = window.watermark.visible
            end
            --
            function window.watermark:Update(updateType, updateValue)
                if updateType == "Visible" then
                    window.watermark.visible = updateValue
                    window.watermark:Visibility()
                end
            end
            --
            Utility:Connection(RunService.RenderStepped, function(fps)
                Library.Shared.Fps = math.round(1 / fps)
                Library.Shared.Ping = tonumber(string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] .. "")
            end)
            --
            watermark_title.Text = string.format("$$ Splix || uid : %u || ping : %i || fps : %u", 1, tostring(Library.Shared.Ping), Library.Shared.Fps)
            window.watermark:UpdateSize()
            --
            spawn(function()
                while wait(0.1) do
                    watermark_title.Text = string.format("$$ Splix || uid : %u || ping : %i || fps : %u", 1, tostring(Library.Shared.Ping), Library.Shared.Fps)
                    window.watermark:UpdateSize()
                end
            end)
            --
            return window.watermark
        end
        --
        function window:KeybindsList(info)
            window.keybindslist = {visible = false, keybinds = {}}
            --
            local info = info or {}
            --
            local keybindslist_outline = Utility:Create("Frame", {Vector2.new(10,(Utility:GetScreenSize().Y/2)-200)}, {
                Size = Utility:Size(0, 150, 0, 22),
                Position = Utility:Position(0, 10, 0.4, 0),
                Hidden = true,
                ZIndex = 55,
                Color = Theme.outline,
                Visible = window.keybindslist.visible
            })window.keybindslist.outline = keybindslist_outline
            --
            local keybindslist_inline = Utility:Create("Frame", {Vector2.new(1,1), keybindslist_outline}, {
                Size = Utility:Size(1, -2, 1, -2, keybindslist_outline),
                Position = Utility:Position(0, 1, 0, 1, keybindslist_outline),
                Hidden = true,
                ZIndex = 55,
                Color = Theme.inline,
                Visible = window.keybindslist.visible
            })
            --
            local keybindslist_frame = Utility:Create("Frame", {Vector2.new(1,1), keybindslist_inline}, {
                Size = Utility:Size(1, -2, 1, -2, keybindslist_inline),
                Position = Utility:Position(0, 1, 0, 1, keybindslist_inline),
                Hidden = true,
                ZIndex = 55,
                Color = Theme.light_contrast,
                Visible = window.keybindslist.visible
            })
            --
            local keybindslist_accent = Utility:Create("Frame", {Vector2.new(0,0), keybindslist_frame}, {
                Size = Utility:Size(1, 0, 0, 1, keybindslist_frame),
                Position = Utility:Position(0, 0, 0, 0, keybindslist_frame),
                Hidden = true,
                ZIndex = 55,
                Color = Theme.accent,
                Visible = window.keybindslist.visible
            })
            --
            local keybindslist_title = Utility:Create("TextLabel", {Vector2.new(keybindslist_outline.Size.X/2,4), keybindslist_outline}, {
                Text = "- Keybinds -",
                Size = Theme.textsize,
                Font = Theme.font,
                Color = Theme.textcolor,
                OutlineColor = Theme.textborder,
                Center = true,
                Hidden = true,
                ZIndex = 55,
                Position = Utility:Position(0.5, 0, 0, 5, keybindslist_outline),
                Visible = window.keybindslist.visible
            })
            --
            function window.keybindslist:Resort()
                local index = 0
                for i,v in pairs(window.keybindslist.keybinds) do
                    v:Move(0 + (index*17))
                    --
                    index = index + 1
                end
            end
            --
            function window.keybindslist:Add(keybindname, keybindvalue)
                if keybindname and keybindvalue and not window.keybindslist.keybinds[keybindname] then
                    local keybindTable = {}
                    --
                    local keybind_outline = Utility:Create("Frame", {Vector2.new(0,keybindslist_outline.Size.Y-1), keybindslist_outline}, {
                        Size = Utility:Size(1, 0, 0, 18, keybindslist_outline),
                        Position = Utility:Position(0, 0, 1, -1, keybindslist_outline),
                        Hidden = true,
                        ZIndex = 55,
                        Color = Theme.outline,
                        Visible = window.keybindslist.visible
                    })
                    --
                    local keybind_inline = Utility:Create("Frame", {Vector2.new(1,1), keybind_outline}, {
                        Size = Utility:Size(1, -2, 1, -2, keybind_outline),
                        Position = Utility:Position(0, 1, 0, 1, keybind_outline),
                        Hidden = true,
                        ZIndex = 55,
                        Color = Theme.inline,
                        Visible = window.keybindslist.visible
                    })
                    --
                    local keybind_frame = Utility:Create("Frame", {Vector2.new(1,1), keybind_inline}, {
                        Size = Utility:Size(1, -2, 1, -2, keybind_inline),
                        Position = Utility:Position(0, 1, 0, 1, keybind_inline),
                        Hidden = true,
                        ZIndex = 55,
                        Color = Theme.dark_contrast,
                        Visible = window.keybindslist.visible
                    })
                    --
                    local keybind_title = Utility:Create("TextLabel", {Vector2.new(4,3), keybind_outline}, {
                        Text = keybindname,
                        Size = Theme.textsize,
                        Font = Theme.font,
                        Color = Theme.textcolor,
                        OutlineColor = Theme.textborder,
                        Center = false,
                        Hidden = true,
                        ZIndex = 55,
                        Position = Utility:Position(0, 4, 0, 3, keybind_outline),
                        Visible = window.keybindslist.visible
                    })
                    --
                    local keybind_value = Utility:Create("TextLabel", {Vector2.new(keybind_outline.Size.X - 4 - Utility:GetTextBounds(keybindname, Theme.textsize, Theme.font).X,3), keybind_outline}, {
                        Text = "["..keybindvalue.."]",
                        Size = Theme.textsize,
                        Font = Theme.font,
                        Color = Theme.textcolor,
                        OutlineColor = Theme.textborder,
                        Hidden = true,
                        ZIndex = 55,
                        Position = Utility:Position(1, -4 - Utility:GetTextBounds(keybindname, Theme.textsize, Theme.font).X, 0, 3, keybind_outline),
                        Visible = window.keybindslist.visible
                    })
                    --
                    function keybindTable:Move(yPos)
                        keybind_outline.Position = Utility:Position(0, 0, 1, -1 + yPos, keybindslist_outline)
                        keybind_inline.Position = Utility:Position(0, 1, 0, 1, keybind_outline)
                        keybind_frame.Position = Utility:Position(0, 1, 0, 1, keybind_inline)
                        keybind_title.Position = Utility:Position(0, 4, 0, 3, keybind_outline)
                        keybind_value.Position = Utility:Position(1, -4 - keybind_value.TextBounds.X, 0, 3, keybind_outline)
                    end
                    --
                    function keybindTable:Remove()
                        Utility:Remove(keybind_outline, true)
                        Utility:Remove(keybind_inline, true)
                        Utility:Remove(keybind_frame, true)
                        Utility:Remove(keybind_title, true)
                        Utility:Remove(keybind_value, true)
                        --
                        window.keybindslist.keybinds[keybindname] = nil
                        keybindTable = nil
                    end
                    --
                    function keybindTable:Visibility()
                        keybind_outline.Visible = window.keybindslist.visible
                        keybind_inline.Visible = window.keybindslist.visible
                        keybind_frame.Visible = window.keybindslist.visible
                        keybind_title.Visible = window.keybindslist.visible
                        keybind_value.Visible = window.keybindslist.visible
                    end
                    --
                    window.keybindslist.keybinds[keybindname] = keybindTable
                    window.keybindslist:Resort()
                end
            end
            --
            function window.keybindslist:Remove(keybindname)
                if keybindname and window.keybindslist.keybinds[keybindname] then
                    window.keybindslist.keybinds[keybindname]:Remove()
                    window.keybindslist.keybinds[keybindname] = nil
                    window.keybindslist:Resort()
                end
            end
            --
            function window.keybindslist:Visibility()
                keybindslist_outline.Visible = window.keybindslist.visible
                keybindslist_inline.Visible = window.keybindslist.visible
                keybindslist_frame.Visible = window.keybindslist.visible
                keybindslist_accent.Visible = window.keybindslist.visible
                keybindslist_title.Visible = window.keybindslist.visible
                --
                for i,v in pairs(window.keybindslist.keybinds) do
                    v:Visibility()
                end
            end
            --
            function window.keybindslist:Update(updateType, updateValue)
                if updateType == "Visible" then
                    window.keybindslist.visible = updateValue
                    window.keybindslist:Visibility()
                end
            end
            --
            Utility:Connection(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),function()
                keybindslist_outline.Position = Utility:Position(0, 10, 0.4, 0)
                keybindslist_inline.Position = Utility:Position(0, 1, 0, 1, keybindslist_outline)
                keybindslist_frame.Position = Utility:Position(0, 1, 0, 1, keybindslist_inline)
                keybindslist_accent.Position = Utility:Position(0, 0, 0, 0, keybindslist_frame)
                keybindslist_title.Position = Utility:Position(0.5, 0, 0, 5, keybindslist_outline)
                --
                window.keybindslist:Resort()
            end)
        end
        --
        function window:Cursor(info)
            window.cursor = {}
            --
            local cursor = Utility:Create("Triangle", nil, {
                Color = Theme.cursoroutline,
                Thickness = 2.5,
                Filled = false,
                ZIndex = 65,
                Hidden = true
            });window.cursor["cursor"] = cursor
            --
            local cursor_inline = Utility:Create("Triangle", nil, {
                Color = Theme.accent,
                Filled = true,
                Thickness = 0,
                ZIndex = 65,
                Hidden = true
            });window.cursor["cursor_inline"] = cursor_inline
            --
            Utility:Connection(RunService.RenderStepped, function()
                local mouseLocation = Utility:MouseLocation()
                --
                cursor.PointA = Vector2.new(mouseLocation.X, mouseLocation.Y)
                cursor.PointB = Vector2.new(mouseLocation.X + 16, mouseLocation.Y + 6)
                cursor.PointC = Vector2.new(mouseLocation.X + 6, mouseLocation.Y + 16)
                --
                cursor_inline.PointA = Vector2.new(mouseLocation.X, mouseLocation.Y)
                cursor_inline.PointB = Vector2.new(mouseLocation.X + 16, mouseLocation.Y + 6)
                cursor_inline.PointC = Vector2.new(mouseLocation.X + 6, mouseLocation.Y + 16)
            end)
            --
            InputService.MouseIconEnabled = false
            --
            return window.cursor
        end
        --
        function window:Fade()
            window.fading = true
            window.isVisible = not window.isVisible
            --
            spawn(function()
                for i, v in pairs(Library.Drawings) do
                    Utility:Lerp(v[1], {Transparency = window.isVisible and v[3] or 0}, 0.25)
                end
            end)
            --
            window.cursor["cursor"].Transparency = window.isVisible and 1 or 0
            window.cursor["cursor_inline"].Transparency = window.isVisible and 1 or 0
            InputService.MouseIconEnabled = not window.isVisible
            --
            window.fading = false
        end
        --
        function window:Initialize()
            window.pages[1]:Show()
            --
            for i,v in pairs(window.pages) do
                v:Update()
            end
            --
            Library.Shared.Initialized = true
            --
            window:Watermark()
            window:KeybindsList()
            window:Cursor()
            --
            window:Fade()
        end
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and window.isVisible and Utility:MouseOverDrawing({main_frame.Position.X,main_frame.Position.Y,main_frame.Position.X + main_frame.Size.X,main_frame.Position.Y + 20}) then
                local mouseLocation = Utility:MouseLocation()
                --
                window.dragging = true
                window.drag = Vector2.new(mouseLocation.X - main_frame.Position.X, mouseLocation.Y - main_frame.Position.Y)
            end
        end
        --
        Library.Ended[#Library.Ended + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and window.dragging then
                window.dragging = false
                window.drag = Vector2.new(0, 0)
            end
        end
        --
        Library.Changed[#Library.Changed + 1] = function(Input)
            if window.dragging and window.isVisible then
                local mouseLocation = Utility:MouseLocation()
                if Utility:GetScreenSize().Y-main_frame.Size.Y-5 > 5 then
                    local move = Vector2.new(math.clamp(mouseLocation.X - window.drag.X, 5, Utility:GetScreenSize().X-main_frame.Size.X-5), math.clamp(mouseLocation.Y - window.drag.Y, 5, Utility:GetScreenSize().Y-main_frame.Size.Y-5))
                    window:Move(move)
                else
                    local move = Vector2.new(mouseLocation.X - window.drag.X, mouseLocation.Y - window.drag.Y)
                    window:Move(move)
                end
            end
        end
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.KeyCode == window.uibind then
                window:Fade()
            end
        end
        --
        Utility:Connection(InputService.InputBegan,function(Input)
            for _, func in pairs(Library.Began) do
                if not window.dragging then
                    local e,s = pcall(function()
                        func(Input)
                    end)
                else
                    break
                end
            end
        end)
        --
        Utility:Connection(InputService.InputEnded,function(Input)
            for _, func in pairs(Library.Ended) do
                local e,s = pcall(function()
                    func(Input)
                end)
            end
        end)
        --
        Utility:Connection(InputService.InputChanged,function()
            for _, func in pairs(Library.Changed) do
                local e,s = pcall(function()
                    func()
                end)
            end
        end)
        --
        Utility:Connection(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),function()
            window:Move(Vector2.new((Utility:GetScreenSize().X/2) - (size.X/2), (Utility:GetScreenSize().Y/2) - (size.Y/2)))
        end)
        --
		return setmetatable(window, Library)
	end
    --
    function Library:Page(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Page"
        --
        local window = self
        --
        local page = {open = false, sections = {}, sectionOffset = {left = 0, right = 0}, window = window}
        --
        local position = 4
        --
        for i,v in pairs(window.pages) do
            position = position + (v.page_button.Size.X+2)
        end
        --
        local textbounds = Utility:GetTextBounds(name, Theme.textsize, Theme.font)
        --
        local page_button = Utility:Create("Frame", {Vector2.new(position,4), window.back_frame}, {
            Size = Utility:Size(0, textbounds.X+20, 0, 21),
            Position = Utility:Position(0, position, 0, 4, window.back_frame),
            Color = Theme.outline
        });page["page_button"] = page_button
        --
        local page_button_inline = Utility:Create("Frame", {Vector2.new(1,1), page_button}, {
            Size = Utility:Size(1, -2, 1, -1, page_button),
            Position = Utility:Position(0, 1, 0, 1, page_button),
            Color = Theme.inline
        });page["page_button_inline"] = page_button_inline
        --
        local page_button_color = Utility:Create("Frame", {Vector2.new(1,1), page_button_inline}, {
            Size = Utility:Size(1, -2, 1, -1, page_button_inline),
            Position = Utility:Position(0, 1, 0, 1, page_button_inline),
            Color = Theme.dark_contrast
        });page["page_button_color"] = page_button_color
        --
        local page_button_title = Utility:Create("TextLabel", {Vector2.new(Utility:Position(0.5, 0, 0, 2, page_button_color).X - page_button_color.Position.X,2), page_button_color}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            Center = true,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0.5, 0, 0, 2, page_button_color)
        })
        --
        window.pages[#window.pages + 1] = page
        --
        function page:Update()
            page.sectionOffset["left"] = 0
            page.sectionOffset["right"] = 0
            --
            for i,v in pairs(page.sections) do
                Utility:UpdateOffset(v.section_inline, {Vector2.new(v.side == "right" and (window.tab_frame.Size.X/2)+2 or 5,5 + page["sectionOffset"][v.side]), window.tab_frame})
                page.sectionOffset[v.side] = page.sectionOffset[v.side] + v.section_inline.Size.Y + 5
            end
            --
            window:Move(window.main_frame.Position)
        end
        --
        function page:Show()
            if window.currentPage then
                window.currentPage.page_button_color.Size = Utility:Size(1, -2, 1, -1, window.currentPage.page_button_inline)
                window.currentPage.page_button_color.Color = Theme.dark_contrast
                window.currentPage.open = false
                --
                for i,v in pairs(window.currentPage.sections) do
                    for z,x in pairs(v.visibleContent) do
                        x.Visible = false
                    end
                end
                --
                window:CloseContent()
            end
            --
            window.currentPage = page
            page_button_color.Size = Utility:Size(1, -2, 1, 0, page_button_inline)
            page_button_color.Color = Theme.light_contrast
            page.open = true
            --
            for i,v in pairs(page.sections) do
                for z,x in pairs(v.visibleContent) do
                    x.Visible = true
                end
            end
        end
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and Utility:MouseOverDrawing({page_button.Position.X,page_button.Position.Y,page_button.Position.X + page_button.Size.X,page_button.Position.Y + page_button.Size.Y}) and window.currentPage ~= page then
                page:Show()
            end
        end
        --
        return setmetatable(page, pages)
    end
    --
    function pages:Section(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Section"
        local side = info.side or info.Side or "left"
        side = side:lower()
        local window = self.window
        local page = self
        local section = {window = window, page = page, visibleContent = {}, currentAxis = 20, side = side}
        --
        local section_inline = Utility:Create("Frame", {Vector2.new(side == "right" and (window.tab_frame.Size.X/2)+2 or 5,5 + page["sectionOffset"][side]), window.tab_frame}, {
            Size = Utility:Size(0.5, -7, 0, 22, window.tab_frame),
            Position = Utility:Position(side == "right" and 0.5 or 0, side == "right" and 2 or 5, 0, 5 + page.sectionOffset[side], window.tab_frame),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent);section["section_inline"] = section_inline
        --
        local section_outline = Utility:Create("Frame", {Vector2.new(1,1), section_inline}, {
            Size = Utility:Size(1, -2, 1, -2, section_inline),
            Position = Utility:Position(0, 1, 0, 1, section_inline),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent);section["section_outline"] = section_outline
        --
        local section_frame = Utility:Create("Frame", {Vector2.new(1,1), section_outline}, {
            Size = Utility:Size(1, -2, 1, -2, section_outline),
            Position = Utility:Position(0, 1, 0, 1, section_outline),
            Color = Theme.dark_contrast,
            Visible = page.open
        }, section.visibleContent);section["section_frame"] = section_frame
        --
        local section_accent = Utility:Create("Frame", {Vector2.new(0,0), section_frame}, {
            Size = Utility:Size(1, 0, 0, 2, section_frame),
            Position = Utility:Position(0, 0, 0, 0, section_frame),
            Color = Theme.accent,
            Visible = page.open
        }, section.visibleContent);section["section_accent"] = section_accent
        --
        local section_title = Utility:Create("TextLabel", {Vector2.new(3,3), section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 3, 0, 3, section_frame),
            Visible = page.open
        }, section.visibleContent);section["section_title"] = section_title
        --
        function section:Update()
            section_inline.Size = Utility:Size(0.5, -7, 0, section.currentAxis+4, window.tab_frame)
            section_outline.Size = Utility:Size(1, -2, 1, -2, section_inline)
            section_frame.Size = Utility:Size(1, -2, 1, -2, section_outline)
        end
        --
        page.sectionOffset[side] = page.sectionOffset[side] + 100 + 5
        page.sections[#page.sections + 1] = section
        --
        return setmetatable(section, sections)
    end
    --
    function pages:MultiSection(info)
        local info = info or {}
        local msections = info.sections or info.Sections or {}
        local side = info.side or info.Side or "left"
        local size = info.size or info.Size or 150
        side = side:lower()
        local window = self.window
        local page = self
        local multiSection = {window = window, page = page, sections = {}, backup = {}, visibleContent = {}, currentSection = nil, xAxis = 0, side = side}
        --
        local multiSection_inline = Utility:Create("Frame", {Vector2.new(side == "right" and (window.tab_frame.Size.X/2)+2 or 5,5 + page["sectionOffset"][side]), window.tab_frame}, {
            Size = Utility:Size(0.5, -7, 0, size, window.tab_frame),
            Position = Utility:Position(side == "right" and 0.5 or 0, side == "right" and 2 or 5, 0, 5 + page.sectionOffset[side], window.tab_frame),
            Color = Theme.inline,
            Visible = page.open
        }, multiSection.visibleContent);multiSection["section_inline"] = multiSection_inline
        --
        local multiSection_outline = Utility:Create("Frame", {Vector2.new(1,1), multiSection_inline}, {
            Size = Utility:Size(1, -2, 1, -2, multiSection_inline),
            Position = Utility:Position(0, 1, 0, 1, multiSection_inline),
            Color = Theme.outline,
            Visible = page.open
        }, multiSection.visibleContent);multiSection["section_outline"] = multiSection_outline
        --
        local multiSection_frame = Utility:Create("Frame", {Vector2.new(1,1), multiSection_outline}, {
            Size = Utility:Size(1, -2, 1, -2, multiSection_outline),
            Position = Utility:Position(0, 1, 0, 1, multiSection_outline),
            Color = Theme.dark_contrast,
            Visible = page.open
        }, multiSection.visibleContent);multiSection["section_frame"] = multiSection_frame
        --
        local multiSection_backFrame = Utility:Create("Frame", {Vector2.new(0,2), multiSection_frame}, {
            Size = Utility:Size(1, 0, 0, 17, multiSection_frame),
            Position = Utility:Position(0, 0, 0, 2, multiSection_frame),
            Color = Theme.light_contrast,
            Visible = page.open
        }, multiSection.visibleContent)
        --
        local multiSection_bottomFrame = Utility:Create("Frame", {Vector2.new(0,multiSection_backFrame.Size.Y - 1), multiSection_backFrame}, {
            Size = Utility:Size(1, 0, 0, 1, multiSection_backFrame),
            Position = Utility:Position(0, 0, 1, -1, multiSection_backFrame),
            Color = Theme.outline,
            Visible = page.open
        }, multiSection.visibleContent)
        --
        local multiSection_accent = Utility:Create("Frame", {Vector2.new(0,0), multiSection_frame}, {
            Size = Utility:Size(1, 0, 0, 2, multiSection_frame),
            Position = Utility:Position(0, 0, 0, 0, multiSection_frame),
            Color = Theme.accent,
            Visible = page.open
        }, multiSection.visibleContent);multiSection["section_accent"] = multiSection_accent
        --
        for i,v in pairs(msections) do
            local msection = {window = window, page = page, currentAxis = 24, sections = {}, visibleContent = {}, section_inline = multiSection_inline, section_outline = multiSection_outline, section_frame = multiSection_frame, section_accent = multiSection_accent}
            --
            local textBounds = Utility:GetTextBounds(v, Theme.textsize, Theme.font)
            --
            local msection_frame = Utility:Create("Frame", {Vector2.new(multiSection.xAxis,0), multiSection_backFrame}, {
                Size = Utility:Size(0, textBounds.X + 14, 1, -1, multiSection_backFrame),
                Position = Utility:Position(0, multiSection.xAxis, 0, 0, multiSection_backFrame),
                Color = i == 1 and Theme.dark_contrast or Theme.light_contrast,
                Visible = page.open
            }, multiSection.visibleContent);msection["msection_frame"] = msection_frame
            --
            local msection_line = Utility:Create("Frame", {Vector2.new(msection_frame.Size.X,0), msection_frame}, {
                Size = Utility:Size(0, 1, 1, 0, msection_frame),
                Position = Utility:Position(1, 0, 0, 0, msection_frame),
                Color = Theme.outline,
                Visible = page.open
            }, multiSection.visibleContent)
            --
            local msection_title = Utility:Create("TextLabel", {Vector2.new(msection_frame.Size.X * 0.5,1), msection_frame}, {
                Text = v,
                Size = Theme.textsize,
                Font = Theme.font,
                Color = Theme.textcolor,
                OutlineColor = Theme.textborder,
                Center = true,
                Position = Utility:Position(0.5, 0, 0, 1, msection_frame),
                Visible = page.open
            }, multiSection.visibleContent)
            --
            local msection_bottomline = Utility:Create("Frame", {Vector2.new(0,msection_frame.Size.Y), msection_frame}, {
                Size = Utility:Size(1, 0, 0, 1, msection_frame),
                Position = Utility:Position(0, 0, 1, 0, msection_frame),
                Color = i == 1 and Theme.dark_contrast or Theme.outline,
                Visible = page.open
            }, multiSection.visibleContent);msection["msection_bottomline"] = msection_bottomline
            --
            function msection:Update()
                if multiSection.currentSection == msection then
                    multiSection.visibleContent = Utility:Combine(multiSection.backup, multiSection.currentSection.visibleContent)
                else
                    for z,x in pairs(msection.visibleContent) do
                        x.Visible = false
                    end
                end
            end
            --
            Library.Began[#Library.Began + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and page.open and  Utility:MouseOverDrawing({msection_frame.Position.X,msection_frame.Position.Y,msection_frame.Position.X + msection_frame.Size.X,msection_frame.Position.Y + msection_frame.Size.Y}) and multiSection.currentSection ~= msection and not window:IsOverContent() then
                    multiSection.currentSection.msection_frame.Color = Theme.light_contrast
                    multiSection.currentSection.msection_bottomline.Color = Theme.outline
                    --
                    for i,v in pairs(multiSection.currentSection.visibleContent) do
                        v.Visible = false
                    end
                    --
                    multiSection.currentSection = msection
                    msection_frame.Color = Theme.dark_contrast
                    msection_bottomline.Color = Theme.dark_contrast
                    --
                    for i,v in pairs(multiSection.currentSection.visibleContent) do
                        v.Visible = true
                    end
                    --
                    multiSection.visibleContent = Utility:Combine(multiSection.backup, multiSection.currentSection.visibleContent)
                end
            end
            --
            if i == 1 then
                multiSection.currentSection = msection
            end
            --
            multiSection.sections[#multiSection.sections + 1] = setmetatable(msection, sections)
            multiSection.xAxis = multiSection.xAxis + textBounds.X + 15
        end
        --
        for z,x in pairs(multiSection.visibleContent) do
            multiSection.backup[z] = x
        end
        --
        page.sectionOffset[side] = page.sectionOffset[side] + 100 + 5
        page.sections[#page.sections + 1] = multiSection
        --
        return table.unpack(multiSection.sections)
    end
    --
    function sections:Label(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Label"
        local middle = info.middle or info.Middle or false
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local label = {axis = section.currentAxis}
        --
        local label_title = Utility:Create("TextLabel", {Vector2.new(middle and (section.section_frame.Size.X/2) or 4,label.axis), section.section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Center = middle,
            Position = Utility:Position(middle and 0.5 or 0, middle and 0 or 4, 0, 0, section.section_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = label
        end
        --
        section.currentAxis = section.currentAxis + label_title.TextBounds.Y + 4
        section:Update()
        --
        return label
    end
    --
    function sections:Toggle(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Toggle"
        local def = info.def or info.Def or info.default or info.Default or false
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local toggle = {axis = section.currentAxis, current = def, addedAxis = 0, colorpickers = 0, keybind = nil}
        --
        local toggle_outline = Utility:Create("Frame", {Vector2.new(4,toggle.axis), section.section_frame}, {
            Size = Utility:Size(0, 15, 0, 15),
            Position = Utility:Position(0, 4, 0, toggle.axis, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local toggle_inline = Utility:Create("Frame", {Vector2.new(1,1), toggle_outline}, {
            Size = Utility:Size(1, -2, 1, -2, toggle_outline),
            Position = Utility:Position(0, 1, 0, 1, toggle_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local toggle_frame = Utility:Create("Frame", {Vector2.new(1,1), toggle_inline}, {
            Size = Utility:Size(1, -2, 1, -2, toggle_inline),
            Position = Utility:Position(0, 1, 0, 1, toggle_inline),
            Color = toggle.current == true and Theme.accent or Theme.light_contrast,
            Visible = page.open
        }, section.visibleContent)
        --
        local toggle__gradient = Utility:Create("Image", {Vector2.new(0,0), toggle_frame}, {
            Size = Utility:Size(1, 0, 1, 0, toggle_frame),
            Position = Utility:Position(0, 0, 0 , 0, toggle_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        local toggle_title = Utility:Create("TextLabel", {Vector2.new(23,toggle.axis + (15/2) - (Utility:GetTextBounds(name, Theme.textsize, Theme.font).Y/2)), section.section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 23, 0, toggle.axis + (15/2) - (Utility:GetTextBounds(name, Theme.textsize, Theme.font).Y/2), section.section_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        Utility:LoadImage(toggle__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        function toggle:Get()
            return toggle.current
        end
        --
        function toggle:Set(bool)
            if bool or not bool then
                toggle.current = bool
                toggle_frame.Color = toggle.current == true and Theme.accent or Theme.light_contrast
                --
                callback(toggle.current)
            end
        end
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and toggle_outline.Visible and window.isVisible and page.open and Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + toggle.axis, section.section_frame.Position.X + section.section_frame.Size.X - toggle.addedAxis, section.section_frame.Position.Y + toggle.axis + 15}) and not window:IsOverContent() then
                toggle.current = not toggle.current
                toggle_frame.Color = toggle.current == true and Theme.accent or Theme.light_contrast
                --
                callback(toggle.current)
                --
                if toggle.keybind and toggle.keybind.active then toggle.keybind.active = false window.keybindslist:Remove(toggle.keybind.keybindname) end
            end
        end
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = toggle
        end
        --
        section.currentAxis = section.currentAxis + 15 + 4
        section:Update()
        --
        function toggle:Colorpicker(info)
            local info = info or {}
            local cpinfo = info.info or info.Info or name
            local def = info.def or info.Def or info.default or info.Default or Color3.fromRGB(255, 0, 0)
            local transp = info.transparency or info.Transparency or info.transp or info.Transp or info.alpha or info.Alpha or nil
            local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
            local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
            --
            local hh, ss, vv = def:ToHSV()
            local colorpicker = {toggle, axis = toggle.axis, index = toggle.colorpickers, current = {hh, ss, vv , (transp or 0)}, holding = {picker = false, huepicker = false, transparency = false}, holder = {inline = nil, picker = nil, picker_cursor = nil, huepicker = nil, huepicker_cursor = {}, transparency = nil, transparencybg = nil, transparency_cursor = {}, drawings = {}}}
            --
            local colorpicker_outline = Utility:Create("Frame", {Vector2.new(section.section_frame.Size.X-(toggle.colorpickers == 0 and (30+4) or (64 + 4)),colorpicker.axis), section.section_frame}, {
                Size = Utility:Size(0, 30, 0, 15),
                Position = Utility:Position(1, -(toggle.colorpickers == 0 and (30+4) or (64 + 4)), 0, colorpicker.axis, section.section_frame),
                Color = Theme.outline,
                Visible = page.open
            }, section.visibleContent)
            --
            local colorpicker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_outline}, {
                Size = Utility:Size(1, -2, 1, -2, colorpicker_outline),
                Position = Utility:Position(0, 1, 0, 1, colorpicker_outline),
                Color = Theme.inline,
                Visible = page.open
            }, section.visibleContent)
            --
            local colorpicker__transparency
            if transp then
                colorpicker__transparency = Utility:Create("Image", {Vector2.new(1,1), colorpicker_inline}, {
                    Size = Utility:Size(1, -2, 1, -2, colorpicker_inline),
                    Position = Utility:Position(0, 1, 0 , 1, colorpicker_inline),
                    Visible = page.open
                }, section.visibleContent)
            end
            --
            local colorpicker_frame = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_inline}, {
                Size = Utility:Size(1, -2, 1, -2, colorpicker_inline),
                Position = Utility:Position(0, 1, 0, 1, colorpicker_inline),
                Color = def,
                Transparency = transp and (1 - transp) or 1,
                Visible = page.open
            }, section.visibleContent)
            --
            local colorpicker__gradient = Utility:Create("Image", {Vector2.new(0,0), colorpicker_frame}, {
                Size = Utility:Size(1, 0, 1, 0, colorpicker_frame),
                Position = Utility:Position(0, 0, 0 , 0, colorpicker_frame),
                Transparency = 0.5,
                Visible = page.open
            }, section.visibleContent)
            --
            if transp then
                Utility:LoadImage(colorpicker__transparency, "cptransp", "https://i.imgur.com/IIPee2A.png")
            end
            Utility:LoadImage(colorpicker__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
            --
            function colorpicker:Set(color, transp_val)
                if typeof(color) == "table" then
                    if color.Color and color.Transparency then
                        local h, s, v = table.unpack(color.Color)
                        colorpicker.current = {h, s, v , color.Transparency}
                        colorpicker_frame.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                        colorpicker_frame.Transparency = 1 - colorpicker.current[4]
                        callback(Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), colorpicker.current[4])
                    else
                        colorpicker.current = color
                        colorpicker_frame.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                        colorpicker_frame.Transparency = 1 - colorpicker.current[4]
                        callback(Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), colorpicker.current[4])
                    end
                elseif typeof(color) == "color3" then
                    local h, s, v = color:ToHSV()
                    colorpicker.current = {h, s, v, (transp_val or 0)}
                    colorpicker_frame.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                    colorpicker_frame.Transparency = 1 - colorpicker.current[4]
                    callback(Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), colorpicker.current[4]) 
                end
            end
            --
            function colorpicker:Refresh()
                local mouseLocation = Utility:MouseLocation()
                if colorpicker.open and colorpicker.holder.picker and colorpicker.holding.picker then
                    colorpicker.current[2] = math.clamp(mouseLocation.X - colorpicker.holder.picker.Position.X, 0, colorpicker.holder.picker.Size.X) / colorpicker.holder.picker.Size.X
                    --
                    colorpicker.current[3] = 1-(math.clamp(mouseLocation.Y - colorpicker.holder.picker.Position.Y, 0, colorpicker.holder.picker.Size.Y) / colorpicker.holder.picker.Size.Y)
                    --
                    colorpicker.holder.picker_cursor.Position = Utility:Position(colorpicker.current[2], -3, 1-colorpicker.current[3] , -3, colorpicker.holder.picker)
                    --
                    Utility:UpdateOffset(colorpicker.holder.picker_cursor, {Vector2.new((colorpicker.holder.picker.Size.X*colorpicker.current[2])-3,(colorpicker.holder.picker.Size.Y*(1-colorpicker.current[3]))-3), colorpicker.holder.picker})
                    --
                    if colorpicker.holder.transparencybg then
                        colorpicker.holder.transparencybg.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                    end
                elseif colorpicker.open and colorpicker.holder.huepicker and colorpicker.holding.huepicker then
                    colorpicker.current[1] = (math.clamp(mouseLocation.Y - colorpicker.holder.huepicker.Position.Y, 0, colorpicker.holder.huepicker.Size.Y) / colorpicker.holder.huepicker.Size.Y)
                    --
                    colorpicker.holder.huepicker_cursor[1].Position = Utility:Position(0, -3, colorpicker.current[1], -3, colorpicker.holder.huepicker)
                    colorpicker.holder.huepicker_cursor[2].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.huepicker_cursor[1])
                    colorpicker.holder.huepicker_cursor[3].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.huepicker_cursor[2])
                    colorpicker.holder.huepicker_cursor[3].Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                    --
                    Utility:UpdateOffset(colorpicker.holder.huepicker_cursor[1], {Vector2.new(-3,(colorpicker.holder.huepicker.Size.Y*colorpicker.current[1])-3), colorpicker.holder.huepicker})
                    --
                    colorpicker.holder.background.Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                    --
                    if colorpicker.holder.transparency_cursor and colorpicker.holder.transparency_cursor[3] then
                        colorpicker.holder.transparency_cursor[3].Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4])
                    end
                    --
                    if colorpicker.holder.transparencybg then
                        colorpicker.holder.transparencybg.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                    end
                elseif colorpicker.open and colorpicker.holder.transparency and colorpicker.holding.transparency then
                    colorpicker.current[4] = 1 - (math.clamp(mouseLocation.X - colorpicker.holder.transparency.Position.X, 0, colorpicker.holder.transparency.Size.X) / colorpicker.holder.transparency.Size.X)
                    --
                    colorpicker.holder.transparency_cursor[1].Position = Utility:Position(1-colorpicker.current[4], -3, 0, -3, colorpicker.holder.transparency)
                    colorpicker.holder.transparency_cursor[2].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.transparency_cursor[1])
                    colorpicker.holder.transparency_cursor[3].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.transparency_cursor[2])
                    colorpicker.holder.transparency_cursor[3].Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4])
                    colorpicker_frame.Transparency = (1 - colorpicker.current[4])
                    --
                    Utility:UpdateTransparency(colorpicker_frame, (1 - colorpicker.current[4]))
                    Utility:UpdateOffset(colorpicker.holder.transparency_cursor[1], {Vector2.new((colorpicker.holder.transparency.Size.X*(1-colorpicker.current[4]))-3,-3), colorpicker.holder.transparency})
                    --
                    colorpicker.holder.background.Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                end
                --
                colorpicker:Set(colorpicker.current)
            end
            --
            function colorpicker:Get()
                return {Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), Transparency = colorpicker.current[4]}
            end
            --
            Library.Began[#Library.Began + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and colorpicker_outline.Visible then
                    if colorpicker.open and colorpicker.holder.inline and Utility:MouseOverDrawing({colorpicker.holder.inline.Position.X, colorpicker.holder.inline.Position.Y, colorpicker.holder.inline.Position.X + colorpicker.holder.inline.Size.X, colorpicker.holder.inline.Position.Y + colorpicker.holder.inline.Size.Y}) then
                        if colorpicker.holder.picker and Utility:MouseOverDrawing({colorpicker.holder.picker.Position.X - 2, colorpicker.holder.picker.Position.Y - 2, colorpicker.holder.picker.Position.X - 2 + colorpicker.holder.picker.Size.X + 4, colorpicker.holder.picker.Position.Y - 2 + colorpicker.holder.picker.Size.Y + 4}) then
                            colorpicker.holding.picker = true
                            colorpicker:Refresh()
                        elseif colorpicker.holder.huepicker and Utility:MouseOverDrawing({colorpicker.holder.huepicker.Position.X - 2, colorpicker.holder.huepicker.Position.Y - 2, colorpicker.holder.huepicker.Position.X - 2 + colorpicker.holder.huepicker.Size.X + 4, colorpicker.holder.huepicker.Position.Y - 2 + colorpicker.holder.huepicker.Size.Y + 4}) then
                            colorpicker.holding.huepicker = true
                            colorpicker:Refresh()
                        elseif colorpicker.holder.transparency and Utility:MouseOverDrawing({colorpicker.holder.transparency.Position.X - 2, colorpicker.holder.transparency.Position.Y - 2, colorpicker.holder.transparency.Position.X - 2 + colorpicker.holder.transparency.Size.X + 4, colorpicker.holder.transparency.Position.Y - 2 + colorpicker.holder.transparency.Size.Y + 4}) then
                            colorpicker.holding.transparency = true
                            colorpicker:Refresh()
                        end
                    elseif Utility:MouseOverDrawing({section.section_frame.Position.X + (section.section_frame.Size.X - (colorpicker.index == 0 and (30 + 4 + 2) or (64 + 4 + 2))), section.section_frame.Position.Y + colorpicker.axis, section.section_frame.Position.X + section.section_frame.Size.X - (colorpicker.index == 1 and 36 or 0), section.section_frame.Position.Y + colorpicker.axis + 15}) and not window:IsOverContent() then
                        if not colorpicker.open then
                            window:CloseContent()
                            colorpicker.open = not colorpicker.open
                            --
                            local colorpicker_open_outline = Utility:Create("Frame", {Vector2.new(4,colorpicker.axis + 19), section.section_frame}, {
                                Size = Utility:Size(1, -8, 0, transp and 219 or 200, section.section_frame),
                                Position = Utility:Position(0, 4, 0, colorpicker.axis + 19, section.section_frame),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings);colorpicker.holder.inline = colorpicker_open_outline
                            --
                            local colorpicker_open_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_outline),
                                Color = Theme.inline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_frame = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_inline),
                                Color = Theme.dark_contrast
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_accent = Utility:Create("Frame", {Vector2.new(0,0), colorpicker_open_frame}, {
                                Size = Utility:Size(1, 0, 0, 2, colorpicker_open_frame),
                                Position = Utility:Position(0, 0, 0, 0, colorpicker_open_frame),
                                Color = Theme.accent
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_title = Utility:Create("TextLabel", {Vector2.new(4,2), colorpicker_open_frame}, {
                                Text = cpinfo,
                                Size = Theme.textsize,
                                Font = Theme.font,
                                Color = Theme.textcolor,
                                OutlineColor = Theme.textborder,
                                Position = Utility:Position(0, 4, 0, 2, colorpicker_open_frame),
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_picker_outline = Utility:Create("Frame", {Vector2.new(4,17), colorpicker_open_frame}, {
                                Size = Utility:Size(1, -27, 1, transp and -40 or -21, colorpicker_open_frame),
                                Position = Utility:Position(0, 4, 0, 17, colorpicker_open_frame),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_picker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_picker_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_picker_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_picker_outline),
                                Color = Theme.inline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_picker_bg = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_picker_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_picker_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_picker_inline),
                                Color = Color3.fromHSV(colorpicker.current[1],1,1)
                            }, colorpicker.holder.drawings);colorpicker.holder.background = colorpicker_open_picker_bg
                            --
                            local colorpicker_open_picker_image = Utility:Create("Image", {Vector2.new(0,0), colorpicker_open_picker_bg}, {
                                Size = Utility:Size(1, 0, 1, 0, colorpicker_open_picker_bg),
                                Position = Utility:Position(0, 0, 0 , 0, colorpicker_open_picker_bg),
                            }, colorpicker.holder.drawings);colorpicker.holder.picker = colorpicker_open_picker_image
                            --
                            local colorpicker_open_picker_cursor = Utility:Create("Image", {Vector2.new((colorpicker_open_picker_image.Size.X*colorpicker.current[2])-3,(colorpicker_open_picker_image.Size.Y*(1-colorpicker.current[3]))-3), colorpicker_open_picker_image}, {
                                Size = Utility:Size(0, 6, 0, 6, colorpicker_open_picker_image),
                                Position = Utility:Position(colorpicker.current[2], -3, 1-colorpicker.current[3] , -3, colorpicker_open_picker_image),
                            }, colorpicker.holder.drawings);colorpicker.holder.picker_cursor = colorpicker_open_picker_cursor
                            --
                            local colorpicker_open_huepicker_outline = Utility:Create("Frame", {Vector2.new(colorpicker_open_frame.Size.X-19,17), colorpicker_open_frame}, {
                                Size = Utility:Size(0, 15, 1, transp and -40 or -21, colorpicker_open_frame),
                                Position = Utility:Position(1, -19, 0, 17, colorpicker_open_frame),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_huepicker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_outline),
                                Color = Theme.inline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_huepicker_image = uUtilitytility:Create("Image", {Vector2.new(1,1), colorpicker_open_huepicker_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_inline),
                                Position = Utility:Position(0, 1, 0 , 1, colorpicker_open_huepicker_inline),
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker = colorpicker_open_huepicker_image
                            --
                            local colorpicker_open_huepicker_cursor_outline = Utility:Create("Frame", {Vector2.new(-3,(colorpicker_open_huepicker_image.Size.Y*colorpicker.current[1])-3), colorpicker_open_huepicker_image}, {
                                Size = Utility:Size(1, 6, 0, 6, colorpicker_open_huepicker_image),
                                Position = Utility:Position(0, -3, colorpicker.current[1], -3, colorpicker_open_huepicker_image),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[1] = colorpicker_open_huepicker_cursor_outline
                            --
                            local colorpicker_open_huepicker_cursor_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_cursor_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_cursor_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_cursor_outline),
                                Color = Theme.textcolor
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[2] = colorpicker_open_huepicker_cursor_inline
                            --
                            local colorpicker_open_huepicker_cursor_color = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_cursor_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_cursor_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_cursor_inline),
                                Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[3] = colorpicker_open_huepicker_cursor_color
                            --
                            if transp then
                                local colorpicker_open_transparency_outline = Utility:Create("Frame", {Vector2.new(4,colorpicker_open_frame.Size.X-19), colorpicker_open_frame}, {
                                    Size = Utility:Size(1, -27, 0, 15, colorpicker_open_frame),
                                    Position = Utility:Position(0, 4, 1, -19, colorpicker_open_frame),
                                    Color = Theme.outline
                                }, colorpicker.holder.drawings)
                                --
                                local colorpicker_open_transparency_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_outline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_outline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_outline),
                                    Color = Theme.inline
                                }, colorpicker.holder.drawings)
                                --
                                local colorpicker_open_transparency_bg = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_inline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_inline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_inline),
                                    Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                                }, colorpicker.holder.drawings);colorpicker.holder.transparencybg = colorpicker_open_transparency_bg
                                --
                                local colorpicker_open_transparency_image = Utility:Create("Image", {Vector2.new(1,1), colorpicker_open_transparency_inline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_inline),
                                    Position = Utility:Position(0, 1, 0 , 1, colorpicker_open_transparency_inline),
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency = colorpicker_open_transparency_image
                                --
                                local colorpicker_open_transparency_cursor_outline = Utility:Create("Frame", {Vector2.new((colorpicker_open_transparency_image.Size.X*(1-colorpicker.current[4]))-3,-3), colorpicker_open_transparency_image}, {
                                    Size = Utility:Size(0, 6, 1, 6, colorpicker_open_transparency_image),
                                    Position = Utility:Position(1-colorpicker.current[4], -3, 0, -3, colorpicker_open_transparency_image),
                                    Color = Theme.outline
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[1] = colorpicker_open_transparency_cursor_outline
                                --
                                local colorpicker_open_transparency_cursor_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_cursor_outline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_cursor_outline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_cursor_outline),
                                    Color = Theme.textcolor
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[2] = colorpicker_open_transparency_cursor_inline
                                --
                                local colorpicker_open_transparency_cursor_color = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_cursor_inline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_cursor_inline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_cursor_inline),
                                    Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4]),
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[3] = colorpicker_open_transparency_cursor_color
                                --
                                Utility:LoadImage(colorpicker_open_transparency_image, "transp", "https://i.imgur.com/ncssKbH.png")
                                --
                            end
                            --
                            Utility:LoadImage(colorpicker_open_picker_image, "valsat", "https://i.imgur.com/wpDRqVH.png")
                            Utility:LoadImage(colorpicker_open_picker_cursor, "valsat_cursor", "https://raw.githubusercontent.com/mvonwalk/splix-assets/main/Images-cursor.png")
                            Utility:LoadImage(colorpicker_open_huepicker_image, "hue", "https://i.imgur.com/iEOsHFv.png")
                            --
                            window.currentContent.frame = colorpicker_open_inline
                            window.currentContent.colorpicker = colorpicker
                        else
                            colorpicker.open = not colorpicker.open
                            --
                            for i,v in pairs(colorpicker.holder.drawings) do
                                Utility:Remove(v)
                            end
                            --
                            colorpicker.holder.drawings = {}
                            colorpicker.holder.inline = nil
                            --
                            window.currentContent.frame = nil
                            window.currentContent.colorpicker = nil
                        end
                    else
                        if colorpicker.open then
                            colorpicker.open = not colorpicker.open
                            --
                            for i,v in pairs(colorpicker.holder.drawings) do
                                Utility:Remove(v)
                            end
                            --
                            colorpicker.holder.drawings = {}
                            colorpicker.holder.inline = nil
                            --
                            window.currentContent.frame = nil
                            window.currentContent.colorpicker = nil
                        end
                    end
                elseif Input.UserInputType == Enum.UserInputType.MouseButton1 and colorpicker.open then
                    colorpicker.open = not colorpicker.open
                    --
                    for i,v in pairs(colorpicker.holder.drawings) do
                        Utility:Remove(v)
                    end
                    --
                    colorpicker.holder.drawings = {}
                    colorpicker.holder.inline = nil
                    --
                    window.currentContent.frame = nil
                    window.currentContent.colorpicker = nil
                end
            end
            --
            Library.Ended[#Library.Ended + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if colorpicker.holding.picker then
                        colorpicker.holding.picker = not colorpicker.holding.picker
                    end
                    if colorpicker.holding.huepicker then
                        colorpicker.holding.huepicker = not colorpicker.holding.huepicker
                    end
                    if colorpicker.holding.transparency then
                        colorpicker.holding.transparency = not colorpicker.holding.transparency
                    end
                end
            end
            --
            Library.Changed[#Library.Changed + 1] = function()
                if colorpicker.open and colorpicker.holding.picker or colorpicker.holding.huepicker or colorpicker.holding.transparency then
                    if window.isVisible then
                        colorpicker:Refresh()
                    else
                        if colorpicker.holding.picker then
                            colorpicker.holding.picker = not colorpicker.holding.picker
                        end
                        if colorpicker.holding.huepicker then
                            colorpicker.holding.huepicker = not colorpicker.holding.huepicker
                        end
                        if colorpicker.holding.transparency then
                            colorpicker.holding.transparency = not colorpicker.holding.transparency
                        end
                    end
                end
            end
            --
            if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
                Library.Pointers[tostring(pointer)] = colorpicker
            end
            --
            toggle.addedAxis = toggle.addedAxis + 30 + 4 + 2
            toggle.colorpickers = toggle.colorpickers + 1
            section:Update()
            --
            return colorpicker, toggle
        end
        --
        function toggle:Keybind(info)
            local info = info or {}
            local def = info.def or info.Def or info.default or info.Default or nil
            local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
            local mode = info.mode or info.Mode or "Always"
            local keybindname = info.keybindname or info.keybindName or info.KeybindName or info.Keybindname or nil
            local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
            --
            toggle.addedaxis = toggle.addedAxis + 40 + 4 + 2
            --
            local keybind = {keybindname = keybindname or name, axis = toggle.axis, current = {}, selecting = false, mode = mode, open = false, modemenu = {buttons = {}, drawings = {}}, active = false}
            --
            toggle.keybind = keybind
            --
            local allowedKeyCodes = {"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","One","Two","Three","Four","Five","Six","Seveen","Eight","Nine","0","Insert","Tab","Home","End","LeftAlt","LeftControl","LeftShift","RightAlt","RightControl","RightShift","CapsLock"}
            local allowedInputTypes = {"MouseButton1","MouseButton2","MouseButton3"}
            local shortenedInputs = {["MouseButton1"] = "MB1", ["MouseButton2"] = "MB2", ["MouseButton3"] = "MB3", ["Insert"] = "Ins", ["LeftAlt"] = "LAlt", ["LeftControl"] = "LC", ["LeftShift"] = "LS", ["RightAlt"] = "RAlt", ["RightControl"] = "RC", ["RightShift"] = "RS", ["CapsLock"] = "Caps"}
            --
            local keybind_outline = Utility:Create("Frame", {Vector2.new(section.section_frame.Size.X-(40+4),keybind.axis), section.section_frame}, {
                Size = Utility:Size(0, 40, 0, 17),
                Position = Utility:Position(1, -(40+4), 0, keybind.axis, section.section_frame),
                Color = Theme.outline,
                Visible = page.open
            }, section.visibleContent)
            --
            local keybind_inline = Utility:Create("Frame", {Vector2.new(1,1), keybind_outline}, {
                Size = Utility:Size(1, -2, 1, -2, keybind_outline),
                Position = Utility:Position(0, 1, 0, 1, keybind_outline),
                Color = Theme.inline,
                Visible = page.open
            }, section.visibleContent)
            --
            local keybind_frame = Utility:Create("Frame", {Vector2.new(1,1), keybind_inline}, {
                Size = Utility:Size(1, -2, 1, -2, keybind_inline),
                Position = Utility:Position(0, 1, 0, 1, keybind_inline),
                Color = Theme.light_contrast,
                Visible = page.open
            }, section.visibleContent)
            --
            local keybind__gradient = Utility:Create("Image", {Vector2.new(0,0), keybind_frame}, {
                Size = Utility:Size(1, 0, 1, 0, keybind_frame),
                Position = Utility:Position(0, 0, 0 , 0, keybind_frame),
                Transparency = 0.5,
                Visible = page.open
            }, section.visibleContent)
            --
            local keybind_value = Utility:Create("TextLabel", {Vector2.new(keybind_outline.Size.X/2,1), keybind_outline}, {
                Text = "...",
                Size = Theme.textsize,
                Font = Theme.font,
                Color = Theme.textcolor,
                OutlineColor = Theme.textborder, 
                Center = true,
                Position = Utility:Position(0.5, 0, 1, 0, keybind_outline),
                Visible = page.open
            }, section.visibleContent)
            --
            Utility:LoadImage(keybind__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
            --
            function keybind:Shorten(string)
                for i,v in pairs(shortenedInputs) do
                    string = string.gsub(string, i, v)
                end
                return string
            end
            --
            function keybind:Change(input)
                input = input or "..."
                local inputTable = {}
                --
                if input.EnumType then
                    if input.EnumType == Enum.KeyCode or input.EnumType == Enum.UserInputType then
                        if table.find(allowedKeyCodes, input.Name) or table.find(allowedInputTypes, input.Name) then
                            inputTable = {input.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType", input.Name}
                            --
                            keybind.current = inputTable
                            keybind_value.Text = #keybind.current > 0 and keybind:Shorten(keybind.current[2]) or "..."
                            --
                            return true
                        end
                    end
                end
                --
                return false
            end
            --
            function keybind:Get()
                return keybind.current
            end
            --
            function keybind:Set(tbl)
                keybind.current = tbl
                keybind_value.Text = #keybind.current > 0 and keybind:Shorten(keybind.current[2]) or "..."
            end
            --
            function keybind:Active()
                return keybind.active
            end
            --
            function keybind:Reset()
                for i,v in pairs(keybind.modemenu.buttons) do
                    v.Color = v.Text == keybind.mode and Theme.accent or Theme.textcolor
                end
                --
                keybind.active = keybind.mode == "Always" and true or false
                if keybind.current[1] and keybind.current[2] then
                    callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
                end
            end
            --
            keybind:Change(def)
            --
            Library.Began[#Library.Began + 1] = function(Input)
                if keybind.current[1] and keybind.current[2] then
                    if Input.KeyCode == Enum[keybind.current[1]][keybind.current[2]] or Input.UserInputType == Enum[keybind.current[1]][keybind.current[2]] then
                        if keybind.mode == "Hold" then
                            local old = keybind.active
                            keybind.active = toggle:Get()
                            if keybind.active then window.keybindslist:Add(keybindname or name, keybind_value.Text) else window.keybindslist:Remove(keybindname or name) end
                            if keybind.active ~= old then callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active) end
                        elseif keybind.mode == "Toggle" then
                            local old = keybind.active
                            keybind.active = not keybind.active == true and toggle:Get() or false
                            if keybind.active then window.keybindslist:Add(keybindname or name, keybind_value.Text) else window.keybindslist:Remove(keybindname or name) end
                            if keybind.active ~= old then callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active) end
                        end
                    end
                end
                --
                if keybind.selecting and window.isVisible then
                    local done = keybind:Change(Input.KeyCode.Name ~= "Unknown" and Input.KeyCode or Input.UserInputType)
                    if done then
                        keybind.selecting = false
                        keybind.active = keybind.mode == "Always" and true or false
                        keybind_frame.Color = Theme.light_contrast
                        --
                        window.keybindslist:Remove(keybindname or name)
                        callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
                    end
                end
                --
                if not window.isVisible and keybind.selecting then
                    keybind.selecting = false
                    keybind_frame.Color = Theme.light_contrast
                end
                --
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and keybind_outline.Visible then
                    if Utility:MouseOverDrawing({section.section_frame.Position.X + (section.section_frame.Size.X - (40+4+2)), section.section_frame.Position.Y + keybind.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + keybind.axis + 17}) and not window:IsOverContent() and not keybind.selecting then
                        keybind.selecting = true
                        keybind_frame.Color = Theme.dark_contrast
                    end
                    if keybind.open and keybind.modemenu.frame then
                        if Utility:MouseOverDrawing({keybind.modemenu.frame.Position.X, keybind.modemenu.frame.Position.Y, keybind.modemenu.frame.Position.X + keybind.modemenu.frame.Size.X, keybind.modemenu.frame.Position.Y + keybind.modemenu.frame.Size.Y}) then
                            local changed = false
                            --
                            for i,v in pairs(keybind.modemenu.buttons) do
                                if Utility:MouseOverDrawing({keybind.modemenu.frame.Position.X, keybind.modemenu.frame.Position.Y + (15 * (i - 1)), keybind.modemenu.frame.Position.X + keybind.modemenu.frame.Size.X, keybind.modemenu.frame.Position.Y + (15 * (i - 1)) + 15}) then
                                    keybind.mode = v.Text
                                    changed = true
                                end
                            end
                            --
                            if changed then keybind:Reset() end
                        else
                            keybind.open = not keybind.open
                            --
                            for i,v in pairs(keybind.modemenu.drawings) do
                                Utility:Remove(v)
                            end
                            --
                            keybind.modemenu.drawings = {}
                            keybind.modemenu.buttons = {}
                            keybind.modemenu.frame = nil
                            --
                            window.currentContent.frame = nil
                            window.currentContent.keybind = nil
                        end
                    end
                end
                --
                if Input.UserInputType == Enum.UserInputType.MouseButton2 and window.isVisible and keybind_outline.Visible then
                    if Utility:MouseOverDrawing({section.section_frame.Position.X  + (section.section_frame.Size.X - (40+4+2)), section.section_frame.Position.Y + keybind.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + keybind.axis + 17}) and not window:IsOverContent() and not keybind.selecting then
                        window:CloseContent()
                        keybind.open = not keybind.open
                        --
                        local modemenu = Utility:Create("Frame", {Vector2.new(keybind_outline.Size.X + 2,0), keybind_outline}, {
                            Size = Utility:Size(0, 64, 0, 49),
                            Position = Utility:Position(1, 2, 0, 0, keybind_outline),
                            Color = Theme.outline,
                            Visible = page.open
                        }, keybind.modemenu.drawings);keybind.modemenu.frame = modemenu
                        --
                        local modemenu_inline = Utility:Create("Frame", {Vector2.new(1,1), modemenu}, {
                            Size = Utility:Size(1, -2, 1, -2, modemenu),
                            Position = Utility:Position(0, 1, 0, 1, modemenu),
                            Color = Theme.inline,
                            Visible = page.open
                        }, keybind.modemenu.drawings)
                        --
                        local modemenu_frame = Utility:Create("Frame", {Vector2.new(1,1), modemenu_inline}, {
                            Size = Utility:Size(1, -2, 1, -2, modemenu_inline),
                            Position = Utility:Position(0, 1, 0, 1, modemenu_inline),
                            Color = Theme.light_contrast,
                            Visible = page.open
                        }, keybind.modemenu.drawings)
                        --
                        local keybind__gradient = Utility:Create("Image", {Vector2.new(0,0), modemenu_frame}, {
                            Size = Utility:Size(1, 0, 1, 0, modemenu_frame),
                            Position = Utility:Position(0, 0, 0 , 0, modemenu_frame),
                            Transparency = 0.5,
                            Visible = page.open
                        }, keybind.modemenu.drawings)
                        --
                        Utility:LoadImage(keybind__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
                        --
                        for i,v in pairs({"Always", "Toggle", "Hold"}) do
                            local button_title = Utility:Create("TextLabel", {Vector2.new(modemenu_frame.Size.X/2,15 * (i-1)), modemenu_frame}, {
                                Text = v,
                                Size = Theme.textsize,
                                Font = Theme.font,
                                Color = v == keybind.mode and Theme.accent or Theme.textcolor,
                                Center = true,
                                OutlineColor = Theme.textborder,
                                Position = Utility:Position(0.5, 0, 0, 15 * (i-1), modemenu_frame),
                                Visible = page.open
                            }, keybind.modemenu.drawings);keybind.modemenu.buttons[#keybind.modemenu.buttons + 1] = button_title
                        end
                        --
                        window.currentContent.frame = modemenu
                        window.currentContent.keybind = keybind
                    end
                end
            end
            --
            Library.Ended[#Library.Ended + 1] = function(Input)
                if keybind.active and keybind.mode == "Hold" then
                    if keybind.current[1] and keybind.current[2] then
                        if Input.KeyCode == Enum[keybind.current[1]][keybind.current[2]] or Input.UserInputType == Enum[keybind.current[1]][keybind.current[2]] then
                            keybind.active = false
                            window.keybindslist:Remove(keybindname or name)
                            callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
                        end
                    end
                end
            end
            --
            if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
                Library.Pointers[tostring(pointer)] = keybind
            end
            --
            toggle.addedAxis = 40+4+2
            section:Update()
            --
            return keybind
        end
        --
        return toggle
    end
    --
    function sections:Slider(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Slider"
        local def = info.def or info.Def or info.default or info.Default or 10
        local min = info.min or info.Min or info.minimum or info.Minimum or 0
        local max = info.max or info.Max or info.maximum or info.Maximum or 100
        local sub = info.suffix or info.Suffix or info.ending or info.Ending or info.prefix or info.Prefix or info.measurement or info.Measurement or ""
        local decimals = info.decimals or info.Decimals or 1
        decimals = 1 / decimals
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
        def = math.clamp(def, min, max)
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local slider = {min = min, max = max, sub = sub, decimals = decimals, axis = section.currentAxis, current = def, holding = false}
        --
        local slider_title = Utility:Create("TextLabel", {Vector2.new(4,slider.axis), section.section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 4, 0, slider.axis, section.section_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        local slider_outline = Utility:Create("Frame", {Vector2.new(4,slider.axis + 15), section.section_frame}, {
            Size = Utility:Size(1, -8, 0, 12, section.section_frame),
            Position = Utility:Position(0, 4, 0, slider.axis + 15, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local slider_inline = Utility:Create("Frame", {Vector2.new(1,1), slider_outline}, {
            Size = Utility:Size(1, -2, 1, -2, slider_outline),
            Position = Utility:Position(0, 1, 0, 1, slider_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local slider_frame = Utility:Create("Frame", {Vector2.new(1,1), slider_inline}, {
            Size = Utility:Size(1, -2, 1, -2, slider_inline),
            Position = Utility:Position(0, 1, 0, 1, slider_inline),
            Color = Theme.light_contrast,
            Visible = page.open
        }, section.visibleContent)
        --
        local slider_slide = Utility:Create("Frame", {Vector2.new(1,1), slider_inline}, {
            Size = Utility:Size(0, (slider_frame.Size.X / (slider.max - slider.min) * (slider.current - slider.min)), 1, -2, slider_inline),
            Position = Utility:Position(0, 1, 0, 1, slider_inline),
            Color = Theme.accent,
            Visible = page.open
        }, section.visibleContent)
        --
        local slider__gradient = Utility:Create("Image", {Vector2.new(0,0), slider_frame}, {
            Size = Utility:Size(1, 0, 1, 0, slider_frame),
            Position = Utility:Position(0, 0, 0 , 0, slider_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        local textBounds = Utility:GetTextBounds(name, Theme.textsize, Theme.font)
        local slider_value = Utility:Create("TextLabel", {Vector2.new(slider_outline.Size.X/2,(slider_outline.Size.Y/2) - (textBounds.Y/2)), slider_outline}, {
            Text = slider.current..slider.sub.."/"..slider.max..slider.sub,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            Center = true,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0.5, 0, 0, (slider_outline.Size.Y/2) - (textBounds.Y/2), slider_outline),
            Visible = page.open
        }, section.visibleContent)
        --
        Utility:LoadImage(slider__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        function slider:Set(value)
            slider.current = math.clamp(math.round(value * slider.decimals) / slider.decimals, slider.min, slider.max)
            local percent = 1 - ((slider.max - slider.current) / (slider.max - slider.min))
            slider_value.Text = slider.current..slider.sub.."/"..slider.max..slider.sub
            slider_slide.Size = Utility:Size(0, percent * slider_frame.Size.X, 1, -2, slider_inline)
            callback(slider.current)
        end
        --
        function slider:Refresh()
            local mouseLocation = Utility:MouseLocation()
            local percent = math.clamp(mouseLocation.X - slider_slide.Position.X, 0, slider_frame.Size.X) / slider_frame.Size.X
            local value = math.floor((slider.min + (slider.max - slider.min) * percent) * slider.decimals) / slider.decimals
            value = math.clamp(value, slider.min, slider.max)
            slider:Set(value)
        end
        --
        function slider:Get()
            return slider.current
        end
        --
        slider:Set(slider.current)
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and slider_outline.Visible and window.isVisible and page.open and Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + slider.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + slider.axis + 27}) and not window:IsOverContent() then
                slider.holding = true
                slider:Refresh()
            end
        end
        --
        Library.Ended[#Library.Ended + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and slider.holding and window.isVisible then
                slider.holding = false
            end
        end
        --
        Library.Changed[#Library.Changed + 1] = function(Input)
            if slider.holding and window.isVisible then
                slider:Refresh()
            end
        end
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = sliderPointers
        end
        --
        section.currentAxis = section.currentAxis + 27 + 4
        section:Update()
        --
        return slider
    end
    --
    function sections:Button(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Button"
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local button = {axis = section.currentAxis}
        --
        local button_outline = Utility:Create("Frame", {Vector2.new(4,button.axis), section.section_frame}, {
            Size = Utility:Size(1, -8, 0, 20, section.section_frame),
            Position = Utility:Position(0, 4, 0, button.axis, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local button_inline = Utility:Create("Frame", {Vector2.new(1,1), button_outline}, {
            Size = Utility:Size(1, -2, 1, -2, button_outline),
            Position = Utility:Position(0, 1, 0, 1, button_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local button_frame = Utility:Create("Frame", {Vector2.new(1,1), button_inline}, {
            Size = Utility:Size(1, -2, 1, -2, button_inline),
            Position = Utility:Position(0, 1, 0, 1, button_inline),
            Color = Theme.light_contrast,
            Visible = page.open
        }, section.visibleContent)
        --
        local button_gradient = Utility:Create("Image", {Vector2.new(0,0), button_frame}, {
            Size = Utility:Size(1, 0, 1, 0, button_frame),
            Position = Utility:Position(0, 0, 0 , 0, button_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        local button_title = Utility:Create("TextLabel", {Vector2.new(button_frame.Size.X/2,1), button_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Center = true,
            Position = Utility:Position(0.5, 0, 0, 1, button_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        Utility:LoadImage(button_gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and button_outline.Visible and window.isVisible and Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + button.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + button.axis + 20}) and not window:IsOverContent() then
                callback()
            end
        end
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = button
        end
        --
        section.currentAxis = section.currentAxis + 20 + 4
        section:Update()
        --
        return button
    end
    --
    function sections:ButtonHolder(info)
        local info = info or {}
        local buttons = info.buttons or info.Buttons or {}
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local buttonHolder = {buttons = {}}
        --
        for i=1, 2 do
            local button = {axis = section.currentAxis}
            --
            local button_outline = Utility:Create("Frame", {Vector2.new(i == 2 and ((section.section_frame.Size.X / 2) + 2) or 4,button.axis), section.section_frame}, {
                Size = Utility:Size(0.5, -6, 0, 20, section.section_frame),
                Position = Utility:Position(0, i == 2 and 2 or 4, 0, button.axis, section.section_frame),
                Color = Theme.outline,
                Visible = page.open
            }, section.visibleContent)
            --
            local button_inline = Utility:Create("Frame", {Vector2.new(1,1), button_outline}, {
                Size = Utility:Size(1, -2, 1, -2, button_outline),
                Position = Utility:Position(0, 1, 0, 1, button_outline),
                Color = Theme.inline,
                Visible = page.open
            }, section.visibleContent)
            --
            local button_frame = Utility:Create("Frame", {Vector2.new(1,1), button_inline}, {
                Size = Utility:Size(1, -2, 1, -2, button_inline),
                Position = Utility:Position(0, 1, 0, 1, button_inline),
                Color = Theme.light_contrast,
                Visible = page.open
            }, section.visibleContent)
            --
            local button_gradient = Utility:Create("Image", {Vector2.new(0,0), button_frame}, {
                Size = Utility:Size(1, 0, 1, 0, button_frame),
                Position = Utility:Position(0, 0, 0 , 0, button_frame),
                Transparency = 0.5,
                Visible = page.open
            }, section.visibleContent)
            --
            local button_title = Utility:Create("TextLabel", {Vector2.new(button_frame.Size.X/2,1), button_frame}, {
                Text = buttons[i][1],
                Size = Theme.textsize,
                Font = Theme.font,
                Color = Theme.textcolor,
                OutlineColor = Theme.textborder,
                Center = true,
                Position = Utility:Position(0.5, 0, 0, 1, button_frame),
                Visible = page.open
            }, section.visibleContent)
            --
            Utility:LoadImage(button_gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
            --
            Library.Began[#Library.Began + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and button_outline.Visible and window.isVisible and Utility:MouseOverDrawing({section.section_frame.Position.X + (i == 2 and (section.section_frame.Size.X/2) or 0), section.section_frame.Position.Y + button.axis, section.section_frame.Position.X + section.section_frame.Size.X - (i == 1 and (section.section_frame.Size.X/2) or 0), section.section_frame.Position.Y + button.axis + 20}) and not window:IsOverContent() then
                    buttons[i][2]()
                end
            end
        end
        --
        section.currentAxis = section.currentAxis + 20 + 4
        section:Update()
    end
    --
    function sections:Dropdown(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Dropdown"
        local options = info.options or info.Options or {"1", "2", "3"}
        local def = info.def or info.Def or info.default or info.Default or options[1]
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local dropdown = {open = false, current = tostring(def), holder = {buttons = {}, drawings = {}}, axis = section.currentAxis}
        --
        local dropdown_outline = Utility:Create("Frame", {Vector2.new(4,dropdown.axis + 15), section.section_frame}, {
            Size = Utility:Size(1, -8, 0, 20, section.section_frame),
            Position = Utility:Position(0, 4, 0, dropdown.axis + 15, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local dropdown_inline = Utility:Create("Frame", {Vector2.new(1,1), dropdown_outline}, {
            Size = Utility:Size(1, -2, 1, -2, dropdown_outline),
            Position = Utility:Position(0, 1, 0, 1, dropdown_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local dropdown_frame = Utility:Create("Frame", {Vector2.new(1,1), dropdown_inline}, {
            Size = Utility:Size(1, -2, 1, -2, dropdown_inline),
            Position = Utility:Position(0, 1, 0, 1, dropdown_inline),
            Color = Theme.light_contrast,
            Visible = page.open
        }, section.visibleContent)
        --
        local dropdown_title = Utility:Create("TextLabel", {Vector2.new(4,dropdown.axis), section.section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 4, 0, dropdown.axis, section.section_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        local dropdown__gradient = Utility:Create("Image", {Vector2.new(0,0), dropdown_frame}, {
            Size = Utility:Size(1, 0, 1, 0, dropdown_frame),
            Position = Utility:Position(0, 0, 0 , 0, dropdown_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        local dropdown_value = Utility:Create("TextLabel", {Vector2.new(3,dropdown_frame.Size.Y/2 - 7), dropdown_frame}, {
            Text = dropdown.current,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 3, 0, (dropdown_frame.Size.Y/2) - 7, dropdown_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        local dropdown_image = Utility:Create("Image", {Vector2.new(dropdown_frame.Size.X - 15,dropdown_frame.Size.Y/2 - 3), dropdown_frame}, {
            Size = Utility:Size(0, 9, 0, 6, dropdown_frame),
            Position = Utility:Position(1, -15, 0.5, -3, dropdown_frame),
            Visible = page.open
        }, section.visibleContent);dropdown["dropdown_image"] = dropdown_image
        --
        Utility:LoadImage(dropdown_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
        Utility:LoadImage(dropdown__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        function dropdown:Update()
            if dropdown.open and dropdown.holder.inline then
                for i,v in pairs(dropdown.holder.buttons) do
                    v[1].Color = v[1].Text == tostring(dropdown.current) and Theme.accent or Theme.textcolor
                    v[1].Position = Utility:Position(0, v[1].Text == tostring(dropdown.current) and 8 or 6, 0, 2, v[2])
                    Utility:UpdateOffset(v[1], {Vector2.new(v[1].Text == tostring(dropdown.current) and 8 or 6, 2), v[2]})
                end
            end
        end
        --
        function dropdown:Set(value)
            if typeof(value) == "string" and table.find(options, value) then
                dropdown.current = value
                dropdown_value.Text = value
            end
        end
        --
        function dropdown:Get()
            return dropdown.current
        end
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and dropdown_outline.Visible then
                if dropdown.open and dropdown.holder.inline and Utility:MouseOverDrawing({dropdown.holder.inline.Position.X, dropdown.holder.inline.Position.Y, dropdown.holder.inline.Position.X + dropdown.holder.inline.Size.X, dropdown.holder.inline.Position.Y + dropdown.holder.inline.Size.Y}) then
                    for i,v in pairs(dropdown.holder.buttons) do
                        if Utility:MouseOverDrawing({v[2].Position.X, v[2].Position.Y, v[2].Position.X + v[2].Size.X, v[2].Position.Y + v[2].Size.Y}) and v[1].Text ~= dropdown.current then
                            dropdown.current = v[1].Text
                            dropdown_value.Text = dropdown.current
                            dropdown:Update()
                        end
                    end
                elseif Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + dropdown.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + dropdown.axis + 15 +  20}) and not window:IsOverContent() then
                    if not dropdown.open then
                        window:CloseContent()
                        dropdown.open = not dropdown.open
                        Utility:LoadImage(dropdown_image, "arrow_up", "https://i.imgur.com/SL9cbQp.png")
                        --
                        local dropdown_open_outline = Utility:Create("Frame", {Vector2.new(0,19), dropdown_outline}, {
                            Size = Utility:Size(1, 0, 0, 3 + (#options * 19), dropdown_outline),
                            Position = Utility:Position(0, 0, 0, 19, dropdown_outline),
                            Color = Theme.outline,
                            Visible = page.open
                        }, dropdown.holder.drawings);dropdown.holder.outline = dropdown_open_outline
                        --
                        local dropdown_open_inline = Utility:Create("Frame", {Vector2.new(1,1), dropdown_open_outline}, {
                            Size = Utility:Size(1, -2, 1, -2, dropdown_open_outline),
                            Position = Utility:Position(0, 1, 0, 1, dropdown_open_outline),
                            Color = Theme.inline,
                            Visible = page.open
                        }, dropdown.holder.drawings);dropdown.holder.inline = dropdown_open_inline
                        --
                        for i,v in pairs(options) do
                            local dropdown_value_frame = Utility:Create("Frame", {Vector2.new(1,1 + (19 * (i-1))), dropdown_open_inline}, {
                                Size = Utility:Size(1, -2, 0, 18, dropdown_open_inline),
                                Position = Utility:Position(0, 1, 0, 1 + (19 * (i-1)), dropdown_open_inline),
                                Color = Theme.light_contrast,
                                Visible = page.open
                            }, dropdown.holder.drawings)
                            --
                            local dropdown_value = Utility:Create("TextLabel", {Vector2.new(v == tostring(dropdown.current) and 8 or 6,2), dropdown_value_frame}, {
                                Text = v,
                                Size = Theme.textsize,
                                Font = Theme.font,
                                Color = v == tostring(dropdown.current) and Theme.accent or Theme.textcolor,
                                OutlineColor = Theme.textborder,
                                Position = Utility:Position(0, v == tostring(dropdown.current) and 8 or 6, 0, 2, dropdown_value_frame),
                                Visible = page.open
                            }, dropdown.holder.drawings);dropdown.holder.buttons[#dropdown.holder.buttons + 1] = {dropdown_value, dropdown_value_frame}
                        end
                        --
                        window.currentContent.frame = dropdown_open_inline
                        window.currentContent.dropdown = dropdown
                    else
                        dropdown.open = not dropdown.open
                        Utility:LoadImage(dropdown_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                        --
                        for i,v in pairs(dropdown.holder.drawings) do
                            Utility:Remove(v)
                        end
                        --
                        dropdown.holder.drawings = {}
                        dropdown.holder.buttons = {}
                        dropdown.holder.inline = nil
                        --
                        window.currentContent.frame = nil
                        window.currentContent.dropdown = nil
                    end
                else
                    if dropdown.open then
                        dropdown.open = not dropdown.open
                        Utility:LoadImage(dropdown_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                        --
                        for i,v in pairs(dropdown.holder.drawings) do
                            Utility:Remove(v)
                        end
                        --
                        dropdown.holder.drawings = {}
                        dropdown.holder.buttons = {}
                        dropdown.holder.inline = nil
                        --
                        window.currentContent.frame = nil
                        window.currentContent.dropdown = nil
                    end
                end
            elseif Input.UserInputType == Enum.UserInputType.MouseButton1 and dropdown.open then
                dropdown.open = not dropdown.open
                Utility:LoadImage(dropdown_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                --
                for i,v in pairs(dropdown.holder.drawings) do
                    Utility:Remove(v)
                end
                --
                dropdown.holder.drawings = {}
                dropdown.holder.buttons = {}
                dropdown.holder.inline = nil
                --
                window.currentContent.frame = nil
                window.currentContent.dropdown = nil
            end
        end
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = dropdown
        end
        --
        section.currentAxis = section.currentAxis + 35 + 4
        section:Update()
        --
        return dropdown
    end
    --
    function sections:Multibox(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Multibox"
        local options = info.options or info.Options or {"1", "2", "3"}
        local def = info.def or info.Def or info.default or info.Default or {options[1]}
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
        local min = info.min or info.Min or info.minimum or info.Minimum or 0
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local multibox = {open = false, current = def, holder = {buttons = {}, drawings = {}}, axis = section.currentAxis}
        --
        local multibox_outline = Utility:Create("Frame", {Vector2.new(4,multibox.axis + 15), section.section_frame}, {
            Size = Utility:Size(1, -8, 0, 20, section.section_frame),
            Position = Utility:Position(0, 4, 0, multibox.axis + 15, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local multibox_inline = Utility:Create("Frame", {Vector2.new(1,1), multibox_outline}, {
            Size = Utility:Size(1, -2, 1, -2, multibox_outline),
            Position = Utility:Position(0, 1, 0, 1, multibox_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local multibox_frame = Utility:Create("Frame", {Vector2.new(1,1), multibox_inline}, {
            Size = Utility:Size(1, -2, 1, -2, multibox_inline),
            Position = Utility:Position(0, 1, 0, 1, multibox_inline),
            Color = Theme.light_contrast,
            Visible = page.open
        }, section.visibleContent)
        --
        local multibox_title = Utility:Create("TextLabel", {Vector2.new(4,multibox.axis), section.section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 4, 0, multibox.axis, section.section_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        local multibox__gradient = Utility:Create("Image", {Vector2.new(0,0), multibox_frame}, {
            Size = Utility:Size(1, 0, 1, 0, multibox_frame),
            Position = Utility:Position(0, 0, 0 , 0, multibox_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        local multibox_value = Utility:Create("TextLabel", {Vector2.new(3,multibox_frame.Size.Y/2 - 7), multibox_frame}, {
            Text = "",
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 3, 0, (multibox_frame.Size.Y/2) - 7, multibox_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        local multibox_image = Utility:Create("Image", {Vector2.new(multibox_frame.Size.X - 15,multibox_frame.Size.Y/2 - 3), multibox_frame}, {
            Size = Utility:Size(0, 9, 0, 6, multibox_frame),
            Position = Utility:Position(1, -15, 0.5, -3, multibox_frame),
            Visible = page.open
        }, section.visibleContent);multibox["multibox_image"] = multibox_image
        --
        Utility:LoadImage(multibox_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
        Utility:LoadImage(multibox__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        function multibox:Update()
            if multibox.open and multibox.holder.inline then
                for i,v in pairs(multibox.holder.buttons) do
                    v[1].Color = table.find(multibox.current, v[1].Text) and Theme.accent or Theme.textcolor
                    v[1].Position = Utility:Position(0, table.find(multibox.current, v[1].Text) and 8 or 6, 0, 2, v[2])
                    Utility:UpdateOffset(v[1], {Vector2.new(table.find(multibox.current, v[1].Text) and 8 or 6, 2), v[2]})
                end
            end
        end
        --
        function multibox:Serialize(tbl)
            local str = ""
            --
            for i,v in pairs(tbl) do
                str = str..v..", "
            end
            --
            return string.sub(str, 0, #str - 2)
        end
        --
        function multibox:Resort(tbl,original)
            local newtbl = {}
            --
            for i,v in pairs(original) do
                if table.find(tbl, v) then
                    newtbl[#newtbl + 1] = v
                end
            end
            --
            return newtbl
        end
        --
        function multibox:Set(tbl)
            if typeof(tbl) == "table" then
                multibox.current = tbl
                multibox_value.Text =  multibox:Serialize(multibox:Resort(multibox.current, options))
            end
        end
        --
        function multibox:Get()
            return multibox.current
        end
        --
        multibox_value.Text = multibox:Serialize(multibox:Resort(multibox.current, options))
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and multibox_outline.Visible then
                if multibox.open and multibox.holder.inline and Utility:MouseOverDrawing({multibox.holder.inline.Position.X, multibox.holder.inline.Position.Y, multibox.holder.inline.Position.X + multibox.holder.inline.Size.X, multibox.holder.inline.Position.Y + multibox.holder.inline.Size.Y}) then
                    for i,v in pairs(multibox.holder.buttons) do
                        if Utility:MouseOverDrawing({v[2].Position.X, v[2].Position.Y, v[2].Position.X + v[2].Size.X, v[2].Position.Y + v[2].Size.Y}) and v[1].Text ~= multibox.current then
                            if not table.find(multibox.current, v[1].Text) then
                                multibox.current[#multibox.current + 1] = v[1].Text
                                multibox_value.Text = multibox:Serialize(multibox:Resort(multibox.current, options))
                                multibox:Update()
                            else
                                if #multibox.current > min then
                                    table.remove(multibox.current, table.find(multibox.current, v[1].Text))
                                    multibox_value.Text = multibox:Serialize(multibox:Resort(multibox.current, options))
                                    multibox:Update()
                                end
                            end
                        end
                    end
                elseif Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + multibox.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + multibox.axis + 15 +  20}) and not window:IsOverContent() then
                    if not multibox.open then
                        window:CloseContent()
                        multibox.open = not multibox.open
                        Utility:LoadImage(multibox_image, "arrow_up", "https://i.imgur.com/SL9cbQp.png")
                        --
                        local multibox_open_outline = Utility:Create("Frame", {Vector2.new(0,19), multibox_outline}, {
                            Size = Utility:Size(1, 0, 0, 3 + (#options * 19), multibox_outline),
                            Position = Utility:Position(0, 0, 0, 19, multibox_outline),
                            Color = Theme.outline,
                            Visible = page.open
                        }, multibox.holder.drawings);multibox.holder.outline = multibox_open_outline
                        --
                        local multibox_open_inline = Utility:Create("Frame", {Vector2.new(1,1), multibox_open_outline}, {
                            Size = Utility:Size(1, -2, 1, -2, multibox_open_outline),
                            Position = Utility:Position(0, 1, 0, 1, multibox_open_outline),
                            Color = Theme.inline,
                            Visible = page.open
                        }, multibox.holder.drawings);multibox.holder.inline = multibox_open_inline
                        --
                        for i,v in pairs(options) do
                            local multibox_value_frame = Utility:Create("Frame", {Vector2.new(1,1 + (19 * (i-1))), multibox_open_inline}, {
                                Size = Utility:Size(1, -2, 0, 18, multibox_open_inline),
                                Position = Utility:Position(0, 1, 0, 1 + (19 * (i-1)), multibox_open_inline),
                                Color = Theme.light_contrast,
                                Visible = page.open
                            }, multibox.holder.drawings)
                            local multibox_value = Utility:Create("TextLabel", {Vector2.new(table.find(multibox.current, v) and 8 or 6,2), multibox_value_frame}, {
                                Text = v,
                                Size = Theme.textsize,
                                Font = Theme.font,
                                Color = table.find(multibox.current, v) and Theme.accent or Theme.textcolor,
                                OutlineColor = Theme.textborder,
                                Position = Utility:Position(0, table.find(multibox.current, v) and 8 or 6, 0, 2, multibox_value_frame),
                                Visible = page.open
                            }, multibox.holder.drawings);multibox.holder.buttons[#multibox.holder.buttons + 1] = {multibox_value, multibox_value_frame}
                        end
                        --
                        window.currentContent.frame = multibox_open_inline
                        window.currentContent.multibox = multibox
                    else
                        multibox.open = not multibox.open
                        Utility:LoadImage(multibox_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                        --
                        for i,v in pairs(multibox.holder.drawings) do
                            Utility:Remove(v)
                        end
                        --
                        multibox.holder.drawings = {}
                        multibox.holder.buttons = {}
                        multibox.holder.inline = nil
                        --
                        window.currentContent.frame = nil
                        window.currentContent.multibox = nil
                    end
                else
                    if multibox.open then
                        multibox.open = not multibox.open
                        Utility:LoadImage(multibox_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                        --
                        for i,v in pairs(multibox.holder.drawings) do
                            Utility:Remove(v)
                        end
                        --
                        multibox.holder.drawings = {}
                        multibox.holder.buttons = {}
                        multibox.holder.inline = nil
                        --
                        window.currentContent.frame = nil
                        window.currentContent.multibox = nil
                    end
                end
            elseif Input.UserInputType == Enum.UserInputType.MouseButton1 and multibox.open then
                multibox.open = not multibox.open
                Utility:LoadImage(multibox_image, "arrow_down", "https://i.imgur.com/tVqy0nL.png")
                --
                for i,v in pairs(multibox.holder.drawings) do
                    Utility:Remove(v)
                end
                --
                multibox.holder.drawings = {}
                multibox.holder.buttons = {}
                multibox.holder.inline = nil
                --
                window.currentContent.frame = nil
                window.currentContent.multibox = nil
            end
        end
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = multibox
        end
        --
        section.currentAxis = section.currentAxis + 35 + 4
        section:Update()
        --
        return multibox
    end
    --
    function sections:Keybind(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Keybind"
        local def = info.def or info.Def or info.default or info.Default or nil
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        local mode = info.mode or info.Mode or "Always"
        local keybindname = info.keybindname or info.keybindName or info.Keybindname or info.KeybindName or nil
        local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local keybind = {keybindname = keybindname or name, axis = section.currentAxis, current = {}, selecting = false, mode = mode, open = false, modemenu = {buttons = {}, drawings = {}}, active = false}
        --
        local allowedKeyCodes = {"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","One","Two","Three","Four","Five","Six","Seveen","Eight","Nine","0","Insert","Tab","Home","End","LeftAlt","LeftControl","LeftShift","RightAlt","RightControl","RightShift","CapsLock"}
        local allowedInputTypes = {"MouseButton1","MouseButton2","MouseButton3"}
        local shortenedInputs = {["MouseButton1"] = "MB1", ["MouseButton2"] = "MB2", ["MouseButton3"] = "MB3", ["Insert"] = "Ins", ["LeftAlt"] = "LAlt", ["LeftControl"] = "LC", ["LeftShift"] = "LS", ["RightAlt"] = "RAlt", ["RightControl"] = "RC", ["RightShift"] = "RS", ["CapsLock"] = "Caps"}
        --
        local keybind_outline = Utility:Create("Frame", {Vector2.new(section.section_frame.Size.X-(40+4),keybind.axis), section.section_frame}, {
            Size = Utility:Size(0, 40, 0, 17),
            Position = Utility:Position(1, -(40+4), 0, keybind.axis, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local keybind_inline = Utility:Create("Frame", {Vector2.new(1,1), keybind_outline}, {
            Size = Utility:Size(1, -2, 1, -2, keybind_outline),
            Position = Utility:Position(0, 1, 0, 1, keybind_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local keybind_frame = Utility:Create("Frame", {Vector2.new(1,1), keybind_inline}, {
            Size = Utility:Size(1, -2, 1, -2, keybind_inline),
            Position = Utility:Position(0, 1, 0, 1, keybind_inline),
            Color = Theme.light_contrast,
            Visible = page.open
        }, section.visibleContent)
        --
        local keybind_title = Utility:Create("TextLabel", {Vector2.new(4,keybind.axis + (17/2) - (Utility:GetTextBounds(name, Theme.textsize, Theme.font).Y/2)), section.section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 4, 0, keybind.axis + (17/2) - (Utility:GetTextBounds(name, Theme.textsize, Theme.font).Y/2), section.section_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        local keybind__gradient = Utility:Create("Image", {Vector2.new(0,0), keybind_frame}, {
            Size = Utility:Size(1, 0, 1, 0, keybind_frame),
            Position = Utility:Position(0, 0, 0 , 0, keybind_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        local keybind_value = Utility:Create("TextLabel", {Vector2.new(keybind_outline.Size.X/2,1), keybind_outline}, {
            Text = "...",
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder, 
            Center = true,
            Position = Utility:Position(0.5, 0, 1, 0, keybind_outline),
            Visible = page.open
        }, section.visibleContent)
        --
        Utility:LoadImage(keybind__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        function keybind:Shorten(string)
            for i,v in pairs(shortenedInputs) do
                string = string.gsub(string, i, v)
            end
            return string
        end
        --
        function keybind:Change(input)
            input = input or "..."
            local inputTable = {}
            --
            if input.EnumType then
                if input.EnumType == Enum.KeyCode or input.EnumType == Enum.UserInputType then
                    if table.find(allowedKeyCodes, input.Name) or table.find(allowedInputTypes, input.Name) then
                        inputTable = {input.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType", input.Name}
                        --
                        keybind.current = inputTable
                        keybind_value.Text = #keybind.current > 0 and keybind:Shorten(keybind.current[2]) or "..."
                        --
                        return true
                    end
                end
            end
            --
            return false
        end
        --
        function keybind:Get()
            return keybind.current
        end
        --
        function keybind:Active()
            return keybind.active
        end
        --
        function keybind:Reset()
            for i,v in pairs(keybind.modemenu.buttons) do
                v.Color = v.Text == keybind.mode and Theme.accent or Theme.textcolor
            end
            --
            keybind.active = keybind.mode == "Always" and true or false
            if keybind.current[1] and keybind.current[2] then
                callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
            end
        end
        --
        keybind:Change(def)
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if keybind.current[1] and keybind.current[2] then
                if Input.KeyCode == Enum[keybind.current[1]][keybind.current[2]] or Input.UserInputType == Enum[keybind.current[1]][keybind.current[2]] then
                    if keybind.mode == "Hold" then
                        keybind.active = true
                        if keybind.active then window.keybindslist:Add(keybindname or name, keybind_value.Text) else window.keybindslist:Remove(keybindname or name) end
                        callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
                    elseif keybind.mode == "Toggle" then
                        keybind.active = not keybind.active
                        if keybind.active then window.keybindslist:Add(keybindname or name, keybind_value.Text) else window.keybindslist:Remove(keybindname or name) end
                        callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
                    end
                end
            end
            --
            if keybind.selecting and window.isVisible then
                local done = keybind:Change(Input.KeyCode.Name ~= "Unknown" and Input.KeyCode or Input.UserInputType)
                if done then
                    keybind.selecting = false
                    keybind.active = keybind.mode == "Always" and true or false
                    keybind_frame.Color = Theme.light_contrast
                    --
                    window.keybindslist:Remove(keybindname or name)
                    --
                    callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
                end
            end
            --
            if not window.isVisible and keybind.selecting then
                keybind.selecting = false
                keybind_frame.Color = Theme.light_contrast
            end
            --
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and keybind_outline.Visible then
                if Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + keybind.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + keybind.axis + 17}) and not window:IsOverContent() and not keybind.selecting then
                    keybind.selecting = true
                    keybind_frame.Color = Theme.dark_contrast
                end
                if keybind.open and keybind.modemenu.frame then
                    if Utility:MouseOverDrawing({keybind.modemenu.frame.Position.X, keybind.modemenu.frame.Position.Y, keybind.modemenu.frame.Position.X + keybind.modemenu.frame.Size.X, keybind.modemenu.frame.Position.Y + keybind.modemenu.frame.Size.Y}) then
                        local changed = false
                        --
                        for i,v in pairs(keybind.modemenu.buttons) do
                            if Utility:MouseOverDrawing({keybind.modemenu.frame.Position.X, keybind.modemenu.frame.Position.Y + (15 * (i - 1)), keybind.modemenu.frame.Position.X + keybind.modemenu.frame.Size.X, keybind.modemenu.frame.Position.Y + (15 * (i - 1)) + 15}) then
                                keybind.mode = v.Text
                                changed = true
                            end
                        end
                        --
                        if changed then keybind:Reset() end
                    else
                        keybind.open = not keybind.open
                        --
                        for i,v in pairs(keybind.modemenu.drawings) do
                            Utility:Remove(v)
                        end
                        --
                        keybind.modemenu.drawings = {}
                        keybind.modemenu.buttons = {}
                        keybind.modemenu.frame = nil
                        --
                        window.currentContent.frame = nil
                        window.currentContent.keybind = nil
                    end
                end
            end
            --
            if Input.UserInputType == Enum.UserInputType.MouseButton2 and window.isVisible and keybind_outline.Visible then
                if Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + keybind.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + keybind.axis + 17}) and not window:IsOverContent() and not keybind.selecting then
                    window:CloseContent()
                    keybind.open = not keybind.open
                    --
                    local modemenu = Utility:Create("Frame", {Vector2.new(keybind_outline.Size.X + 2,0), keybind_outline}, {
                        Size = Utility:Size(0, 64, 0, 49),
                        Position = Utility:Position(1, 2, 0, 0, keybind_outline),
                        Color = Theme.outline,
                        Visible = page.open
                    }, keybind.modemenu.drawings);keybind.modemenu.frame = modemenu
                    --
                    local modemenu_inline = Utility:Create("Frame", {Vector2.new(1,1), modemenu}, {
                        Size = Utility:Size(1, -2, 1, -2, modemenu),
                        Position = Utility:Position(0, 1, 0, 1, modemenu),
                        Color = Theme.inline,
                        Visible = page.open
                    }, keybind.modemenu.drawings)
                    --
                    local modemenu_frame = Utility:Create("Frame", {Vector2.new(1,1), modemenu_inline}, {
                        Size = Utility:Size(1, -2, 1, -2, modemenu_inline),
                        Position = Utility:Position(0, 1, 0, 1, modemenu_inline),
                        Color = Theme.light_contrast,
                        Visible = page.open
                    }, keybind.modemenu.drawings)
                    --
                    local keybind__gradient = Utility:Create("Image", {Vector2.new(0,0), modemenu_frame}, {
                        Size = Utility:Size(1, 0, 1, 0, modemenu_frame),
                        Position = Utility:Position(0, 0, 0 , 0, modemenu_frame),
                        Transparency = 0.5,
                        Visible = page.open
                    }, keybind.modemenu.drawings)
                    --
                    Utility:LoadImage(keybind__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
                    --
                    for i,v in pairs({"Always", "Toggle", "Hold"}) do
                        local button_title = Utility:Create("TextLabel", {Vector2.new(modemenu_frame.Size.X/2,15 * (i-1)), modemenu_frame}, {
                            Text = v,
                            Size = Theme.textsize,
                            Font = Theme.font,
                            Color = v == keybind.mode and Theme.accent or Theme.textcolor,
                            Center = true,
                            OutlineColor = Theme.textborder,
                            Position = Utility:Position(0.5, 0, 0, 15 * (i-1), modemenu_frame),
                            Visible = page.open
                        }, keybind.modemenu.drawings);keybind.modemenu.buttons[#keybind.modemenu.buttons + 1] = button_title
                    end
                    --
                    window.currentContent.frame = modemenu
                    window.currentContent.keybind = keybind
                end
            end
        end
        --
        Library.Ended[#Library.Ended + 1] = function(Input)
            if keybind.active and keybind.mode == "Hold" then
                if keybind.current[1] and keybind.current[2] then
                    if Input.KeyCode == Enum[keybind.current[1]][keybind.current[2]] or Input.UserInputType == Enum[keybind.current[1]][keybind.current[2]] then
                        keybind.active = false
                        window.keybindslist:Remove(keybindname or name)
                        callback(Enum[keybind.current[1]][keybind.current[2]], keybind.active)
                    end
                end
            end
        end
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = keybind
        end
        --
        section.currentAxis = section.currentAxis + 17 + 4
        section:Update()
        --
        return keybind
    end
    --
    function sections:Colorpicker(info)
        local info = info or {}
        local name = info.name or info.Name or info.title or info.Title or "New Colorpicker"
        local cpinfo = info.info or info.Info or name
        local def = info.def or info.Def or info.default or info.Default or Color3.fromRGB(255, 0, 0)
        local transp = info.transparency or info.Transparency or info.transp or info.Transp or info.alpha or info.Alpha or nil
        local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
        local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local hh, ss, vv = def:ToHSV()
        local colorpicker = {axis = section.currentAxis, secondColorpicker = false, current = {hh, ss, vv , (transp or 0)}, holding = {picker = false, huepicker = false, transparency = false}, holder = {inline = nil, picker = nil, picker_cursor = nil, huepicker = nil, huepicker_cursor = {}, transparency = nil, transparencybg = nil, transparency_cursor = {}, drawings = {}}}
        --
        local colorpicker_outline = Utility:Create("Frame", {Vector2.new(section.section_frame.Size.X-(30+4),colorpicker.axis), section.section_frame}, {
            Size = Utility:Size(0, 30, 0, 15),
            Position = Utility:Position(1, -(30+4), 0, colorpicker.axis, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local colorpicker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_outline}, {
            Size = Utility:Size(1, -2, 1, -2, colorpicker_outline),
            Position = Utility:Position(0, 1, 0, 1, colorpicker_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local colorpicker__transparency
        if transp then
            colorpicker__transparency = Utility:Create("Image", {Vector2.new(1,1), colorpicker_inline}, {
                Size = Utility:Size(1, -2, 1, -2, colorpicker_inline),
                Position = Utility:Position(0, 1, 0 , 1, colorpicker_inline),
                Visible = page.open
            }, section.visibleContent)
        end
        --
        local colorpicker_frame = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_inline}, {
            Size = Utility:Size(1, -2, 1, -2, colorpicker_inline),
            Position = Utility:Position(0, 1, 0, 1, colorpicker_inline),
            Color = def,
            Transparency = transp and (1 - transp) or 1,
            Visible = page.open
        }, section.visibleContent)
        --
        local colorpicker__gradient = Utility:Create("Image", {Vector2.new(0,0), colorpicker_frame}, {
            Size = Utility:Size(1, 0, 1, 0, colorpicker_frame),
            Position = Utility:Position(0, 0, 0 , 0, colorpicker_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        local colorpicker_title = Utility:Create("TextLabel", {Vector2.new(4,colorpicker.axis + (15/2) - (Utility:GetTextBounds(name, Theme.textsize, Theme.font).Y/2)), section.section_frame}, {
            Text = name,
            Size = Theme.textsize,
            Font = Theme.font,
            Color = Theme.textcolor,
            OutlineColor = Theme.textborder,
            Position = Utility:Position(0, 4, 0, colorpicker.axis + (15/2) - (Utility:GetTextBounds(name, Theme.textsize, Theme.font).Y/2), section.section_frame),
            Visible = page.open
        }, section.visibleContent)
        --
        if transp then
            Utility:LoadImage(colorpicker__transparency, "cptransp", "https://i.imgur.com/IIPee2A.png")
        end
        Utility:LoadImage(colorpicker__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        function colorpicker:Set(color, transp_val)
            if typeof(color) == "table" then
                colorpicker.current = color
                colorpicker_frame.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                colorpicker_frame.Transparency = 1 - colorpicker.current[4]
                callback(Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), colorpicker.current[4])
            elseif typeof(color) == "color3" then
                local h, s, v = color:ToHSV()
                colorpicker.current = {h, s, v, (transp_val or 0)}
                colorpicker_frame.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                colorpicker_frame.Transparency = 1 - colorpicker.current[4]
                callback(Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), colorpicker.current[4]) 
            end
        end
        --
        function colorpicker:Refresh()
            local mouseLocation = Utility:MouseLocation()
            if colorpicker.open and colorpicker.holder.picker and colorpicker.holding.picker then
                colorpicker.current[2] = math.clamp(mouseLocation.X - colorpicker.holder.picker.Position.X, 0, colorpicker.holder.picker.Size.X) / colorpicker.holder.picker.Size.X
                --
                colorpicker.current[3] = 1-(math.clamp(mouseLocation.Y - colorpicker.holder.picker.Position.Y, 0, colorpicker.holder.picker.Size.Y) / colorpicker.holder.picker.Size.Y)
                --
                colorpicker.holder.picker_cursor.Position = Utility:Position(colorpicker.current[2], -3, 1-colorpicker.current[3] , -3, colorpicker.holder.picker)
                --
                Utility:UpdateOffset(colorpicker.holder.picker_cursor, {Vector2.new((colorpicker.holder.picker.Size.X*colorpicker.current[2])-3,(colorpicker.holder.picker.Size.Y*(1-colorpicker.current[3]))-3), colorpicker.holder.picker})
                --
                if colorpicker.holder.transparencybg then
                    colorpicker.holder.transparencybg.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                end
            elseif colorpicker.open and colorpicker.holder.huepicker and colorpicker.holding.huepicker then
                colorpicker.current[1] = (math.clamp(mouseLocation.Y - colorpicker.holder.huepicker.Position.Y, 0, colorpicker.holder.huepicker.Size.Y) / colorpicker.holder.huepicker.Size.Y)
                --
                colorpicker.holder.huepicker_cursor[1].Position = Utility:Position(0, -3, colorpicker.current[1], -3, colorpicker.holder.huepicker)
                colorpicker.holder.huepicker_cursor[2].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.huepicker_cursor[1])
                colorpicker.holder.huepicker_cursor[3].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.huepicker_cursor[2])
                colorpicker.holder.huepicker_cursor[3].Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                --
                Utility:UpdateOffset(colorpicker.holder.huepicker_cursor[1], {Vector2.new(-3,(colorpicker.holder.huepicker.Size.Y*colorpicker.current[1])-3), colorpicker.holder.huepicker})
                --
                colorpicker.holder.background.Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                --
                if colorpicker.holder.transparency_cursor and colorpicker.holder.transparency_cursor[3] then
                    colorpicker.holder.transparency_cursor[3].Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4])
                end
                --
                if colorpicker.holder.transparencybg then
                    colorpicker.holder.transparencybg.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                end
            elseif colorpicker.open and colorpicker.holder.transparency and colorpicker.holding.transparency then
                colorpicker.current[4] = 1 - (math.clamp(mouseLocation.X - colorpicker.holder.transparency.Position.X, 0, colorpicker.holder.transparency.Size.X) / colorpicker.holder.transparency.Size.X)
                --
                colorpicker.holder.transparency_cursor[1].Position = Utility:Position(1-colorpicker.current[4], -3, 0, -3, colorpicker.holder.transparency)
                colorpicker.holder.transparency_cursor[2].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.transparency_cursor[1])
                colorpicker.holder.transparency_cursor[3].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.transparency_cursor[2])
                colorpicker.holder.transparency_cursor[3].Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4])
                colorpicker_frame.Transparency = (1 - colorpicker.current[4])
                --
                Utility:UpdateTransparency(colorpicker_frame, (1 - colorpicker.current[4]))
                Utility:UpdateOffset(colorpicker.holder.transparency_cursor[1], {Vector2.new((colorpicker.holder.transparency.Size.X*(1-colorpicker.current[4]))-3,-3), colorpicker.holder.transparency})
                --
                colorpicker.holder.background.Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
            end
            --
            colorpicker:Set(colorpicker.current)
        end
        --
        function colorpicker:Get()
            return Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
        end
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and colorpicker_outline.Visible then
                if colorpicker.open and colorpicker.holder.inline and Utility:MouseOverDrawing({colorpicker.holder.inline.Position.X, colorpicker.holder.inline.Position.Y, colorpicker.holder.inline.Position.X + colorpicker.holder.inline.Size.X, colorpicker.holder.inline.Position.Y + colorpicker.holder.inline.Size.Y}) then
                    if colorpicker.holder.picker and Utility:MouseOverDrawing({colorpicker.holder.picker.Position.X - 2, colorpicker.holder.picker.Position.Y - 2, colorpicker.holder.picker.Position.X - 2 + colorpicker.holder.picker.Size.X + 4, colorpicker.holder.picker.Position.Y - 2 + colorpicker.holder.picker.Size.Y + 4}) then
                        colorpicker.holding.picker = true
                        colorpicker:Refresh()
                    elseif colorpicker.holder.huepicker and Utility:MouseOverDrawing({colorpicker.holder.huepicker.Position.X - 2, colorpicker.holder.huepicker.Position.Y - 2, colorpicker.holder.huepicker.Position.X - 2 + colorpicker.holder.huepicker.Size.X + 4, colorpicker.holder.huepicker.Position.Y - 2 + colorpicker.holder.huepicker.Size.Y + 4}) then
                        colorpicker.holding.huepicker = true
                        colorpicker:Refresh()
                    elseif colorpicker.holder.transparency and Utility:MouseOverDrawing({colorpicker.holder.transparency.Position.X - 2, colorpicker.holder.transparency.Position.Y - 2, colorpicker.holder.transparency.Position.X - 2 + colorpicker.holder.transparency.Size.X + 4, colorpicker.holder.transparency.Position.Y - 2 + colorpicker.holder.transparency.Size.Y + 4}) then
                        colorpicker.holding.transparency = true
                        colorpicker:Refresh()
                    end
                elseif Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + colorpicker.axis, section.section_frame.Position.X + section.section_frame.Size.X - (colorpicker.secondColorpicker and (30+4) or 0), section.section_frame.Position.Y + colorpicker.axis + 15}) and not window:IsOverContent() then
                    if not colorpicker.open then
                        window:CloseContent()
                        colorpicker.open = not colorpicker.open
                        --
                        local colorpicker_open_outline = Utility:Create("Frame", {Vector2.new(4,colorpicker.axis + 19), section.section_frame}, {
                            Size = Utility:Size(1, -8, 0, transp and 219 or 200, section.section_frame),
                            Position = Utility:Position(0, 4, 0, colorpicker.axis + 19, section.section_frame),
                            Color = Theme.outline
                        }, colorpicker.holder.drawings);colorpicker.holder.inline = colorpicker_open_outline
                        --
                        local colorpicker_open_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_outline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_outline),
                            Position = Utility:Position(0, 1, 0, 1, colorpicker_open_outline),
                            Color = Theme.inline
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_open_frame = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_inline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_inline),
                            Position = Utility:Position(0, 1, 0, 1, colorpicker_open_inline),
                            Color = Theme.dark_contrast
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_open_accent = Utility:Create("Frame", {Vector2.new(0,0), colorpicker_open_frame}, {
                            Size = Utility:Size(1, 0, 0, 2, colorpicker_open_frame),
                            Position = Utility:Position(0, 0, 0, 0, colorpicker_open_frame),
                            Color = Theme.accent
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_title = Utility:Create("TextLabel", {Vector2.new(4,2), colorpicker_open_frame}, {
                            Text = cpinfo,
                            Size = Theme.textsize,
                            Font = Theme.font,
                            Color = Theme.textcolor,
                            OutlineColor = Theme.textborder,
                            Position = Utility:Position(0, 4, 0, 2, colorpicker_open_frame),
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_open_picker_outline = Utility:Create("Frame", {Vector2.new(4,17), colorpicker_open_frame}, {
                            Size = Utility:Size(1, -27, 1, transp and -40 or -21, colorpicker_open_frame),
                            Position = Utility:Position(0, 4, 0, 17, colorpicker_open_frame),
                            Color = Theme.outline
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_open_picker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_picker_outline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_picker_outline),
                            Position = Utility:Position(0, 1, 0, 1, colorpicker_open_picker_outline),
                            Color = Theme.inline
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_open_picker_bg = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_picker_inline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_picker_inline),
                            Position = Utility:Position(0, 1, 0, 1, colorpicker_open_picker_inline),
                            Color = Color3.fromHSV(colorpicker.current[1],1,1)
                        }, colorpicker.holder.drawings);colorpicker.holder.background = colorpicker_open_picker_bg
                        --
                        local colorpicker_open_picker_image = Utility:Create("Image", {Vector2.new(0,0), colorpicker_open_picker_bg}, {
                            Size = Utility:Size(1, 0, 1, 0, colorpicker_open_picker_bg),
                            Position = Utility:Position(0, 0, 0 , 0, colorpicker_open_picker_bg),
                        }, colorpicker.holder.drawings);colorpicker.holder.picker = colorpicker_open_picker_image
                        --
                        local colorpicker_open_picker_cursor = Utility:Create("Image", {Vector2.new((colorpicker_open_picker_image.Size.X*colorpicker.current[2])-3,(colorpicker_open_picker_image.Size.Y*(1-colorpicker.current[3]))-3), colorpicker_open_picker_image}, {
                            Size = Utility:Size(0, 6, 0, 6, colorpicker_open_picker_image),
                            Position = Utility:Position(colorpicker.current[2], -3, 1-colorpicker.current[3] , -3, colorpicker_open_picker_image),
                        }, colorpicker.holder.drawings);colorpicker.holder.picker_cursor = colorpicker_open_picker_cursor
                        --
                        local colorpicker_open_huepicker_outline = Utility:Create("Frame", {Vector2.new(colorpicker_open_frame.Size.X-19,17), colorpicker_open_frame}, {
                            Size = Utility:Size(0, 15, 1, transp and -40 or -21, colorpicker_open_frame),
                            Position = Utility:Position(1, -19, 0, 17, colorpicker_open_frame),
                            Color = Theme.outline
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_open_huepicker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_outline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_outline),
                            Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_outline),
                            Color = Theme.inline
                        }, colorpicker.holder.drawings)
                        --
                        local colorpicker_open_huepicker_image = Utility:Create("Image", {Vector2.new(1,1), colorpicker_open_huepicker_inline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_inline),
                            Position = Utility:Position(0, 1, 0 , 1, colorpicker_open_huepicker_inline),
                        }, colorpicker.holder.drawings);colorpicker.holder.huepicker = colorpicker_open_huepicker_image
                        --
                        local colorpicker_open_huepicker_cursor_outline = Utility:Create("Frame", {Vector2.new(-3,(colorpicker_open_huepicker_image.Size.Y*colorpicker.current[1])-3), colorpicker_open_huepicker_image}, {
                            Size = Utility:Size(1, 6, 0, 6, colorpicker_open_huepicker_image),
                            Position = Utility:Position(0, -3, colorpicker.current[1], -3, colorpicker_open_huepicker_image),
                            Color = Theme.outline
                        }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[1] = colorpicker_open_huepicker_cursor_outline
                        --
                        local colorpicker_open_huepicker_cursor_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_cursor_outline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_cursor_outline),
                            Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_cursor_outline),
                            Color = Theme.textcolor
                        }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[2] = colorpicker_open_huepicker_cursor_inline
                        --
                        local colorpicker_open_huepicker_cursor_color = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_cursor_inline}, {
                            Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_cursor_inline),
                            Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_cursor_inline),
                            Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                        }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[3] = colorpicker_open_huepicker_cursor_color
                        --
                        if transp then
                            local colorpicker_open_transparency_outline = Utility:Create("Frame", {Vector2.new(4,colorpicker_open_frame.Size.X-19), colorpicker_open_frame}, {
                                Size = Utility:Size(1, -27, 0, 15, colorpicker_open_frame),
                                Position = Utility:Position(0, 4, 1, -19, colorpicker_open_frame),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_transparency_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_outline),
                                Color = Theme.inline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_transparency_bg = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_inline),
                                Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                            }, colorpicker.holder.drawings);colorpicker.holder.transparencybg = colorpicker_open_transparency_bg
                            --
                            local colorpicker_open_transparency_image = Utility:Create("Image", {Vector2.new(1,1), colorpicker_open_transparency_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_inline),
                                Position = Utility:Position(0, 1, 0 , 1, colorpicker_open_transparency_inline),
                            }, colorpicker.holder.drawings);colorpicker.holder.transparency = colorpicker_open_transparency_image
                            --
                            local colorpicker_open_transparency_cursor_outline = Utility:Create("Frame", {Vector2.new((colorpicker_open_transparency_image.Size.X*(1-colorpicker.current[4]))-3,-3), colorpicker_open_transparency_image}, {
                                Size = Utility:Size(0, 6, 1, 6, colorpicker_open_transparency_image),
                                Position = Utility:Position(1-colorpicker.current[4], -3, 0, -3, colorpicker_open_transparency_image),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[1] = colorpicker_open_transparency_cursor_outline
                            --
                            local colorpicker_open_transparency_cursor_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_cursor_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_cursor_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_cursor_outline),
                                Color = Theme.textcolor
                            }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[2] = colorpicker_open_transparency_cursor_inline
                            --
                            local colorpicker_open_transparency_cursor_color = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_cursor_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_cursor_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_cursor_inline),
                                Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4]),
                            }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[3] = colorpicker_open_transparency_cursor_color
                            --
                            Utility:LoadImage(colorpicker_open_transparency_image, "transp", "https://i.imgur.com/ncssKbH.png")
                            --
                        end
                        --
                        Utility:LoadImage(colorpicker_open_picker_image, "valsat", "https://i.imgur.com/wpDRqVH.png")
                        Utility:LoadImage(colorpicker_open_picker_cursor, "valsat_cursor", "https://raw.githubusercontent.com/mvonwalk/splix-assets/main/Images-cursor.png")
                        Utility:LoadImage(colorpicker_open_huepicker_image, "hue", "https://i.imgur.com/iEOsHFv.png")
                        --
                        window.currentContent.frame = colorpicker_open_inline
                        window.currentContent.colorpicker = colorpicker
                    else
                        colorpicker.open = not colorpicker.open
                        --
                        for i,v in pairs(colorpicker.holder.drawings) do
                            Utility:Remove(v)
                        end
                        --
                        colorpicker.holder.drawings = {}
                        colorpicker.holder.inline = nil
                        --
                        window.currentContent.frame = nil
                        window.currentContent.colorpicker = nil
                    end
                else
                    if colorpicker.open then
                        colorpicker.open = not colorpicker.open
                        --
                        for i,v in pairs(colorpicker.holder.drawings) do
                            Utility:Remove(v)
                        end
                        --
                        colorpicker.holder.drawings = {}
                        colorpicker.holder.inline = nil
                        --
                        window.currentContent.frame = nil
                        window.currentContent.colorpicker = nil
                    end
                end
            elseif Input.UserInputType == Enum.UserInputType.MouseButton1 and colorpicker.open then
                colorpicker.open = not colorpicker.open
                --
                for i,v in pairs(colorpicker.holder.drawings) do
                    Utility:Remove(v)
                end
                --
                colorpicker.holder.drawings = {}
                colorpicker.holder.inline = nil
                --
                window.currentContent.frame = nil
                window.currentContent.colorpicker = nil
            end
        end
        --
        Library.Ended[#Library.Ended + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if colorpicker.holding.picker then
                    colorpicker.holding.picker = not colorpicker.holding.picker
                end
                if colorpicker.holding.huepicker then
                    colorpicker.holding.huepicker = not colorpicker.holding.huepicker
                end
                if colorpicker.holding.transparency then
                    colorpicker.holding.transparency = not colorpicker.holding.transparency
                end
            end
        end
        --
        Library.Changed[#Library.Changed + 1] = function()
            if colorpicker.open and colorpicker.holding.picker or colorpicker.holding.huepicker or colorpicker.holding.transparency then
                if window.isVisible then
                    colorpicker:Refresh()
                else
                    if colorpicker.holding.picker then
                        colorpicker.holding.picker = not colorpicker.holding.picker
                    end
                    if colorpicker.holding.huepicker then
                        colorpicker.holding.huepicker = not colorpicker.holding.huepicker
                    end
                    if colorpicker.holding.transparency then
                        colorpicker.holding.transparency = not colorpicker.holding.transparency
                    end
                end
            end
        end
        --
        if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
            Library.Pointers[tostring(pointer)] = colorpicker
        end
        --
        section.currentAxis = section.currentAxis + 15 + 4
        section:Update()
        --
        function colorpicker:Colorpicker(info)
            local info = info or {}
            local cpinfo = info.info or info.Info or name
            local def = info.def or info.Def or info.default or info.Default or Color3.fromRGB(255, 0, 0)
            local transp = info.transparency or info.Transparency or info.transp or info.Transp or info.alpha or info.Alpha or nil
            local pointer = info.pointer or info.Pointer or info.flag or info.Flag or nil
            local callback = info.callback or info.callBack or info.Callback or info.CallBack or function()end
            --
            colorpicker.secondColorpicker = true
            --
            local hh, ss, vv = def:ToHSV()
            local colorpicker = {axis = colorpicker.axis, current = {hh, ss, vv , (transp or 0)}, holding = {picker = false, huepicker = false, transparency = false}, holder = {inline = nil, picker = nil, picker_cursor = nil, huepicker = nil, huepicker_cursor = {}, transparency = nil, transparencybg = nil, transparency_cursor = {}, drawings = {}}}
            --
            colorpicker_outline.Position = Utility:Position(1, -(60+8), 0, colorpicker.axis, section.section_frame)
            Utility:UpdateOffset(colorpicker_outline, {Vector2.new(section.section_frame.Size.X-(60+8),colorpicker.axis), section.section_frame})
            --
            local colorpicker_outline = Utility:Create("Frame", {Vector2.new(section.section_frame.Size.X-(30+4),colorpicker.axis), section.section_frame}, {
                Size = Utility:Size(0, 30, 0, 15),
                Position = Utility:Position(1, -(30+4), 0, colorpicker.axis, section.section_frame),
                Color = Theme.outline,
                Visible = page.open
            }, section.visibleContent)
            --
            local colorpicker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_outline}, {
                Size = Utility:Size(1, -2, 1, -2, colorpicker_outline),
                Position = Utility:Position(0, 1, 0, 1, colorpicker_outline),
                Color = Theme.inline,
                Visible = page.open
            }, section.visibleContent)
            --
            local colorpicker__transparency
            if transp then
                colorpicker__transparency = Utility:Create("Image", {Vector2.new(1,1), colorpicker_inline}, {
                    Size = Utility:Size(1, -2, 1, -2, colorpicker_inline),
                    Position = Utility:Position(0, 1, 0 , 1, colorpicker_inline),
                    Visible = page.open
                }, section.visibleContent)
            end
            --
            local colorpicker_frame = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_inline}, {
                Size = Utility:Size(1, -2, 1, -2, colorpicker_inline),
                Position = Utility:Position(0, 1, 0, 1, colorpicker_inline),
                Color = def,
                Transparency = transp and (1 - transp) or 1,
                Visible = page.open
            }, section.visibleContent)
            --
            local colorpicker__gradient = Utility:Create("Image", {Vector2.new(0,0), colorpicker_frame}, {
                Size = Utility:Size(1, 0, 1, 0, colorpicker_frame),
                Position = Utility:Position(0, 0, 0 , 0, colorpicker_frame),
                Transparency = 0.5,
                Visible = page.open
            }, section.visibleContent)
            --
            if transp then
                Utility:LoadImage(colorpicker__transparency, "cptransp", "https://i.imgur.com/IIPee2A.png")
            end
            Utility:LoadImage(colorpicker__gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
            --
            function colorpicker:Set(color, transp_val)
                if typeof(color) == "table" then
                    colorpicker.current = color
                    colorpicker_frame.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                    colorpicker_frame.Transparency = 1 - colorpicker.current[4]
                    callback(Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), colorpicker.current[4])
                elseif typeof(color) == "color3" then
                    local h, s, v = color:ToHSV()
                    colorpicker.current = {h, s, v, (transp_val or 0)}
                    colorpicker_frame.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                    colorpicker_frame.Transparency = 1 - colorpicker.current[4]
                    callback(Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3]), colorpicker.current[4]) 
                end
            end
            --
            function colorpicker:Refresh()
                local mouseLocation = Utility:MouseLocation()
                if colorpicker.open and colorpicker.holder.picker and colorpicker.holding.picker then
                    colorpicker.current[2] = math.clamp(mouseLocation.X - colorpicker.holder.picker.Position.X, 0, colorpicker.holder.picker.Size.X) / colorpicker.holder.picker.Size.X
                    --
                    colorpicker.current[3] = 1-(math.clamp(mouseLocation.Y - colorpicker.holder.picker.Position.Y, 0, colorpicker.holder.picker.Size.Y) / colorpicker.holder.picker.Size.Y)
                    --
                    colorpicker.holder.picker_cursor.Position = Utility:Position(colorpicker.current[2], -3, 1-colorpicker.current[3] , -3, colorpicker.holder.picker)
                    --
                    Utility:UpdateOffset(colorpicker.holder.picker_cursor, {Vector2.new((colorpicker.holder.picker.Size.X*colorpicker.current[2])-3,(colorpicker.holder.picker.Size.Y*(1-colorpicker.current[3]))-3), colorpicker.holder.picker})
                    --
                    if colorpicker.holder.transparencybg then
                        colorpicker.holder.transparencybg.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                    end
                elseif colorpicker.open and colorpicker.holder.huepicker and colorpicker.holding.huepicker then
                    colorpicker.current[1] = (math.clamp(mouseLocation.Y - colorpicker.holder.huepicker.Position.Y, 0, colorpicker.holder.huepicker.Size.Y) / colorpicker.holder.huepicker.Size.Y)
                    --
                    colorpicker.holder.huepicker_cursor[1].Position = Utility:Position(0, -3, colorpicker.current[1], -3, colorpicker.holder.huepicker)
                    colorpicker.holder.huepicker_cursor[2].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.huepicker_cursor[1])
                    colorpicker.holder.huepicker_cursor[3].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.huepicker_cursor[2])
                    colorpicker.holder.huepicker_cursor[3].Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                    --
                    Utility:UpdateOffset(colorpicker.holder.huepicker_cursor[1], {Vector2.new(-3,(colorpicker.holder.huepicker.Size.Y*colorpicker.current[1])-3), colorpicker.holder.huepicker})
                    --
                    colorpicker.holder.background.Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                    --
                    if colorpicker.holder.transparency_cursor and colorpicker.holder.transparency_cursor[3] then
                        colorpicker.holder.transparency_cursor[3].Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4])
                    end
                    --
                    if colorpicker.holder.transparencybg then
                        colorpicker.holder.transparencybg.Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                    end
                elseif colorpicker.open and colorpicker.holder.transparency and colorpicker.holding.transparency then
                    colorpicker.current[4] = 1 - (math.clamp(mouseLocation.X - colorpicker.holder.transparency.Position.X, 0, colorpicker.holder.transparency.Size.X) / colorpicker.holder.transparency.Size.X)
                    --
                    colorpicker.holder.transparency_cursor[1].Position = Utility:Position(1-colorpicker.current[4], -3, 0, -3, colorpicker.holder.transparency)
                    colorpicker.holder.transparency_cursor[2].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.transparency_cursor[1])
                    colorpicker.holder.transparency_cursor[3].Position = Utility:Position(0, 1, 0, 1, colorpicker.holder.transparency_cursor[2])
                    colorpicker.holder.transparency_cursor[3].Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4])
                    colorpicker_frame.Transparency = (1 - colorpicker.current[4])
                    --
                    Utility:UpdateTransparency(colorpicker_frame, (1 - colorpicker.current[4]))
                    Utility:UpdateOffset(colorpicker.holder.transparency_cursor[1], {Vector2.new((colorpicker.holder.transparency.Size.X*(1-colorpicker.current[4]))-3,-3), colorpicker.holder.transparency})
                    --
                    colorpicker.holder.background.Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                end
                --
                colorpicker:Set(colorpicker.current)
            end
            --
            function colorpicker:Get()
                return Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
            end
            --
            Library.Began[#Library.Began + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and window.isVisible and colorpicker_outline.Visible then
                    if colorpicker.open and colorpicker.holder.inline and Utility:MouseOverDrawing({colorpicker.holder.inline.Position.X, colorpicker.holder.inline.Position.Y, colorpicker.holder.inline.Position.X + colorpicker.holder.inline.Size.X, colorpicker.holder.inline.Position.Y + colorpicker.holder.inline.Size.Y}) then
                        if colorpicker.holder.picker and Utility:MouseOverDrawing({colorpicker.holder.picker.Position.X - 2, colorpicker.holder.picker.Position.Y - 2, colorpicker.holder.picker.Position.X - 2 + colorpicker.holder.picker.Size.X + 4, colorpicker.holder.picker.Position.Y - 2 + colorpicker.holder.picker.Size.Y + 4}) then
                            colorpicker.holding.picker = true
                            colorpicker:Refresh()
                        elseif colorpicker.holder.huepicker and Utility:MouseOverDrawing({colorpicker.holder.huepicker.Position.X - 2, colorpicker.holder.huepicker.Position.Y - 2, colorpicker.holder.huepicker.Position.X - 2 + colorpicker.holder.huepicker.Size.X + 4, colorpicker.holder.huepicker.Position.Y - 2 + colorpicker.holder.huepicker.Size.Y + 4}) then
                            colorpicker.holding.huepicker = true
                            colorpicker:Refresh()
                        elseif colorpicker.holder.transparency and Utility:MouseOverDrawing({colorpicker.holder.transparency.Position.X - 2, colorpicker.holder.transparency.Position.Y - 2, colorpicker.holder.transparency.Position.X - 2 + colorpicker.holder.transparency.Size.X + 4, colorpicker.holder.transparency.Position.Y - 2 + colorpicker.holder.transparency.Size.Y + 4}) then
                            colorpicker.holding.transparency = true
                            colorpicker:Refresh()
                        end
                    elseif Utility:MouseOverDrawing({section.section_frame.Position.X + (section.section_frame.Size.X - (30 + 4 + 2)), section.section_frame.Position.Y + colorpicker.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + colorpicker.axis + 15}) and not window:IsOverContent() then
                        if not colorpicker.open then
                            window:CloseContent()
                            colorpicker.open = not colorpicker.open
                            --
                            local colorpicker_open_outline = Utility:Create("Frame", {Vector2.new(4,colorpicker.axis + 19), section.section_frame}, {
                                Size = Utility:Size(1, -8, 0, transp and 219 or 200, section.section_frame),
                                Position = Utility:Position(0, 4, 0, colorpicker.axis + 19, section.section_frame),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings);colorpicker.holder.inline = colorpicker_open_outline
                            --
                            local colorpicker_open_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_outline),
                                Color = Theme.inline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_frame = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_inline),
                                Color = Theme.dark_contrast
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_accent = Utility:Create("Frame", {Vector2.new(0,0), colorpicker_open_frame}, {
                                Size = Utility:Size(1, 0, 0, 2, colorpicker_open_frame),
                                Position = Utility:Position(0, 0, 0, 0, colorpicker_open_frame),
                                Color = Theme.accent
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_title = Utility:Create("TextLabel", {Vector2.new(4,2), colorpicker_open_frame}, {
                                Text = cpinfo,
                                Size = Theme.textsize,
                                Font = Theme.font,
                                Color = Theme.textcolor,
                                OutlineColor = Theme.textborder,
                                Position = Utility:Position(0, 4, 0, 2, colorpicker_open_frame),
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_picker_outline = Utility:Create("Frame", {Vector2.new(4,17), colorpicker_open_frame}, {
                                Size = Utility:Size(1, -27, 1, transp and -40 or -21, colorpicker_open_frame),
                                Position = Utility:Position(0, 4, 0, 17, colorpicker_open_frame),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_picker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_picker_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_picker_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_picker_outline),
                                Color = Theme.inline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_picker_bg = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_picker_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_picker_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_picker_inline),
                                Color = Color3.fromHSV(colorpicker.current[1],1,1)
                            }, colorpicker.holder.drawings);colorpicker.holder.background = colorpicker_open_picker_bg
                            --
                            local colorpicker_open_picker_image = Utility:Create("Image", {Vector2.new(0,0), colorpicker_open_picker_bg}, {
                                Size = Utility:Size(1, 0, 1, 0, colorpicker_open_picker_bg),
                                Position = Utility:Position(0, 0, 0 , 0, colorpicker_open_picker_bg),
                            }, colorpicker.holder.drawings);colorpicker.holder.picker = colorpicker_open_picker_image
                            --
                            local colorpicker_open_picker_cursor = Utility:Create("Image", {Vector2.new((colorpicker_open_picker_image.Size.X*colorpicker.current[2])-3,(colorpicker_open_picker_image.Size.Y*(1-colorpicker.current[3]))-3), colorpicker_open_picker_image}, {
                                Size = Utility:Size(0, 6, 0, 6, colorpicker_open_picker_image),
                                Position = Utility:Position(colorpicker.current[2], -3, 1-colorpicker.current[3] , -3, colorpicker_open_picker_image),
                            }, colorpicker.holder.drawings);colorpicker.holder.picker_cursor = colorpicker_open_picker_cursor
                            --
                            local colorpicker_open_huepicker_outline = Utility:Create("Frame", {Vector2.new(colorpicker_open_frame.Size.X-19,17), colorpicker_open_frame}, {
                                Size = Utility:Size(0, 15, 1, transp and -40 or -21, colorpicker_open_frame),
                                Position = Utility:Position(1, -19, 0, 17, colorpicker_open_frame),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_huepicker_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_outline),
                                Color = Theme.inline
                            }, colorpicker.holder.drawings)
                            --
                            local colorpicker_open_huepicker_image = Utility:Create("Image", {Vector2.new(1,1), colorpicker_open_huepicker_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_inline),
                                Position = Utility:Position(0, 1, 0 , 1, colorpicker_open_huepicker_inline),
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker = colorpicker_open_huepicker_image
                            --
                            local colorpicker_open_huepicker_cursor_outline = Utility:Create("Frame", {Vector2.new(-3,(colorpicker_open_huepicker_image.Size.Y*colorpicker.current[1])-3), colorpicker_open_huepicker_image}, {
                                Size = Utility:Size(1, 6, 0, 6, colorpicker_open_huepicker_image),
                                Position = Utility:Position(0, -3, colorpicker.current[1], -3, colorpicker_open_huepicker_image),
                                Color = Theme.outline
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[1] = colorpicker_open_huepicker_cursor_outline
                            --
                            local colorpicker_open_huepicker_cursor_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_cursor_outline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_cursor_outline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_cursor_outline),
                                Color = Theme.textcolor
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[2] = colorpicker_open_huepicker_cursor_inline
                            --
                            local colorpicker_open_huepicker_cursor_color = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_huepicker_cursor_inline}, {
                                Size = Utility:Size(1, -2, 1, -2, colorpicker_open_huepicker_cursor_inline),
                                Position = Utility:Position(0, 1, 0, 1, colorpicker_open_huepicker_cursor_inline),
                                Color = Color3.fromHSV(colorpicker.current[1], 1, 1)
                            }, colorpicker.holder.drawings);colorpicker.holder.huepicker_cursor[3] = colorpicker_open_huepicker_cursor_color
                            --
                            if transp then
                                local colorpicker_open_transparency_outline = Utility:Create("Frame", {Vector2.new(4,colorpicker_open_frame.Size.X-19), colorpicker_open_frame}, {
                                    Size = Utility:Size(1, -27, 0, 15, colorpicker_open_frame),
                                    Position = Utility:Position(0, 4, 1, -19, colorpicker_open_frame),
                                    Color = Theme.outline
                                }, colorpicker.holder.drawings)
                                --
                                local colorpicker_open_transparency_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_outline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_outline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_outline),
                                    Color = Theme.inline
                                }, colorpicker.holder.drawings)
                                --
                                local colorpicker_open_transparency_bg = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_inline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_inline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_inline),
                                    Color = Color3.fromHSV(colorpicker.current[1], colorpicker.current[2], colorpicker.current[3])
                                }, colorpicker.holder.drawings);colorpicker.holder.transparencybg = colorpicker_open_transparency_bg
                                --
                                local colorpicker_open_transparency_image = Utility:Create("Image", {Vector2.new(1,1), colorpicker_open_transparency_inline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_inline),
                                    Position = Utility:Position(0, 1, 0 , 1, colorpicker_open_transparency_inline),
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency = colorpicker_open_transparency_image
                                --
                                local colorpicker_open_transparency_cursor_outline = Utility:Create("Frame", {Vector2.new((colorpicker_open_transparency_image.Size.X*(1-colorpicker.current[4]))-3,-3), colorpicker_open_transparency_image}, {
                                    Size = Utility:Size(0, 6, 1, 6, colorpicker_open_transparency_image),
                                    Position = Utility:Position(1-colorpicker.current[4], -3, 0, -3, colorpicker_open_transparency_image),
                                    Color = Theme.outline
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[1] = colorpicker_open_transparency_cursor_outline
                                --
                                local colorpicker_open_transparency_cursor_inline = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_cursor_outline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_cursor_outline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_cursor_outline),
                                    Color = Theme.textcolor
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[2] = colorpicker_open_transparency_cursor_inline
                                --
                                local colorpicker_open_transparency_cursor_color = Utility:Create("Frame", {Vector2.new(1,1), colorpicker_open_transparency_cursor_inline}, {
                                    Size = Utility:Size(1, -2, 1, -2, colorpicker_open_transparency_cursor_inline),
                                    Position = Utility:Position(0, 1, 0, 1, colorpicker_open_transparency_cursor_inline),
                                    Color = Color3.fromHSV(0, 0, 1 - colorpicker.current[4]),
                                }, colorpicker.holder.drawings);colorpicker.holder.transparency_cursor[3] = colorpicker_open_transparency_cursor_color
                                --
                                Utility:LoadImage(colorpicker_open_transparency_image, "transp", "https://i.imgur.com/ncssKbH.png")
                                --
                            end
                            --
                            Utility:LoadImage(colorpicker_open_picker_image, "valsat", "https://i.imgur.com/wpDRqVH.png")
                            Utility:LoadImage(colorpicker_open_picker_cursor, "valsat_cursor", "https://raw.githubusercontent.com/mvonwalk/splix-assets/main/Images-cursor.png")
                            Utility:LoadImage(colorpicker_open_huepicker_image, "hue", "https://i.imgur.com/iEOsHFv.png")
                            --
                            window.currentContent.frame = colorpicker_open_inline
                            window.currentContent.colorpicker = colorpicker
                        else
                            colorpicker.open = not colorpicker.open
                            --
                            for i,v in pairs(colorpicker.holder.drawings) do
                                Utility:Remove(v)
                            end
                            --
                            colorpicker.holder.drawings = {}
                            colorpicker.holder.inline = nil
                            --
                            window.currentContent.frame = nil
                            window.currentContent.colorpicker = nil
                        end
                    else
                        if colorpicker.open then
                            colorpicker.open = not colorpicker.open
                            --
                            for i,v in pairs(colorpicker.holder.drawings) do
                                Utility:Remove(v)
                            end
                            --
                            colorpicker.holder.drawings = {}
                            colorpicker.holder.inline = nil
                            --
                            window.currentContent.frame = nil
                            window.currentContent.colorpicker = nil
                        end
                    end
                elseif Input.UserInputType == Enum.UserInputType.MouseButton1 and colorpicker.open then
                    colorpicker.open = not colorpicker.open
                    --
                    for i,v in pairs(colorpicker.holder.drawings) do
                        Utility:Remove(v)
                    end
                    --
                    colorpicker.holder.drawings = {}
                    colorpicker.holder.inline = nil
                    --
                    window.currentContent.frame = nil
                    window.currentContent.colorpicker = nil
                end
            end
            --
            Library.Ended[#Library.Ended + 1] = function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if colorpicker.holding.picker then
                        colorpicker.holding.picker = not colorpicker.holding.picker
                    end
                    if colorpicker.holding.huepicker then
                        colorpicker.holding.huepicker = not colorpicker.holding.huepicker
                    end
                    if colorpicker.holding.transparency then
                        colorpicker.holding.transparency = not colorpicker.holding.transparency
                    end
                end
            end
            --
            Library.Changed[#Library.Changed + 1] = function()
                if colorpicker.open and colorpicker.holding.picker or colorpicker.holding.huepicker or colorpicker.holding.transparency then
                    if window.isVisible then
                        colorpicker:Refresh()
                    else
                        if colorpicker.holding.picker then
                            colorpicker.holding.picker = not colorpicker.holding.picker
                        end
                        if colorpicker.holding.huepicker then
                            colorpicker.holding.huepicker = not colorpicker.holding.huepicker
                        end
                        if colorpicker.holding.transparency then
                            colorpicker.holding.transparency = not colorpicker.holding.transparency
                        end
                    end
                end
            end
            --
            if pointer and tostring(pointer) ~= "" and tostring(pointer) ~= " " and not Library.Pointers[tostring(pointer)] then
                Library.Pointers[tostring(pointer)] = keybind
            end
            --
            return colorpicker
        end
        --
        return colorpicker
    end
    --
    function sections:ConfigBox(info)
        local info = info or {}
        --
        local window = self.window
        local page = self.page
        local section = self
        --
        local configLoader = {axis = section.currentAxis, current = 1, buttons = {}}
        --
        local configLoader_outline = Utility:Create("Frame", {Vector2.new(4,configLoader.axis), section.section_frame}, {
            Size = Utility:Size(1, -8, 0, 148, section.section_frame),
            Position = Utility:Position(0, 4, 0, configLoader.axis, section.section_frame),
            Color = Theme.outline,
            Visible = page.open
        }, section.visibleContent)
        --
        local configLoader_inline = Utility:Create("Frame", {Vector2.new(1,1), configLoader_outline}, {
            Size = Utility:Size(1, -2, 1, -2, configLoader_outline),
            Position = Utility:Position(0, 1, 0, 1, configLoader_outline),
            Color = Theme.inline,
            Visible = page.open
        }, section.visibleContent)
        --
        local configLoader_frame = Utility:Create("Frame", {Vector2.new(1,1), configLoader_inline}, {
            Size = Utility:Size(1, -2, 1, -2, configLoader_inline),
            Position = Utility:Position(0, 1, 0, 1, configLoader_inline),
            Color = Theme.light_contrast,
            Visible = page.open
        }, section.visibleContent)
        --
        local configLoader_gradient = Utility:Create("Image", {Vector2.new(0,0), configLoader_frame}, {
            Size = Utility:Size(1, 0, 1, 0, configLoader_frame),
            Position = Utility:Position(0, 0, 0 , 0, configLoader_frame),
            Transparency = 0.5,
            Visible = page.open
        }, section.visibleContent)
        --
        for i=1, 8 do
            local config_title = Utility:Create("TextLabel", {Vector2.new(configLoader_frame.Size.X/2,2 + (18 * (i-1))), configLoader_frame}, {
                Text = "Config-Slot: "..tostring(i),
                Size = Theme.textsize,
                Font = Theme.font,
                Color = i == 1 and Theme.accent or Theme.textcolor,
                OutlineColor = Theme.textborder,
                Center = true,
                Position = Utility:Position(0.5, 0, 0, 2 + (18 * (i-1)), configLoader_frame),
                Visible = page.open
            }, section.visibleContent)
            --
            configLoader.buttons[i] = config_title
        end
        --
        Utility:LoadImage(configLoader_gradient, "gradient", "https://i.imgur.com/5hmlrjX.png")
        --
        function configLoader:Refresh()
            for i,v in pairs(configLoader.buttons) do
                v.Color = i == configLoader.current and Theme.accent or Theme.textcolor
            end
        end
        --
        function configLoader:Get()
            return configLoader.current
        end
        --
        function configLoader:Set(current)
            configLoader.current = current
            configLoader:Refresh()
        end
        --
        Library.Began[#Library.Began + 1] = function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and configLoader_outline.Visible and window.isVisible and Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + configLoader.axis, section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + configLoader.axis + 148}) and not window:IsOverContent() then
                for i=1, 8 do
                    if Utility:MouseOverDrawing({section.section_frame.Position.X, section.section_frame.Position.Y + configLoader.axis + 2 + (18 * (i-1)), section.section_frame.Position.X + section.section_frame.Size.X, section.section_frame.Position.Y + configLoader.axis + 2 + (18 * (i-1)) + 18}) then
                        configLoader.current = i
                        configLoader:Refresh()
                    end
                end
            end
        end
        --
        window.Pointers["configbox"] = configLoader
        section.currentAxis = section.currentAxis + 148 + 4
        section:Update()
        --
        return configLoader
    end
end
return Library, Utility, Library.Pointers, Theme
