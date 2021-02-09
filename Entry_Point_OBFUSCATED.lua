getgenv().console = true; -- synapse x/krnl/arch console, you can turn it off if you're not using synapse x, your exploit MUST support rconsoleprint if this is on

if getgenv().console == true then
    if is_synapse_function or KRNL_LOADED then
        rconsolename("EntryPointHaxx v1, crafted with my computer. :Bruh:")
        rconsoleprint("@@CYAN@@")
        rconsoleprint("\n")
        rconsoleprint [==[
  ______       _              _____      _       _   _    _                         __ 
 |  ____|     | |            |  __ \    (_)     | | | |  | |                       /_ |
 | |__   _ __ | |_ _ __ _   _| |__) |__  _ _ __ | |_| |__| | __ ___  ____  __ __   _| |
 |  __| | '_ \| __| '__| | | |  ___/ _ \| | '_ \| __|  __  |/ _` \ \/ /\ \/ / \ \ / / |
 | |____| | | | |_| |  | |_| | |  | (_) | | | | | |_| |  | | (_| |>  <  >  <   \ V /| |
 |______|_| |_|\__|_|   \__, |_|   \___/|_|_| |_|\__|_|  |_|\__,_/_/\_\/_/\_\   \_/ |_|
                         __/ |                                                         
                        |___/                                                          
]==]
        rconsoleprint("Loading...\n")
    end
else
    if getgenv().console == false then
        print("EntryPointHaxx v1")
        wait(1)
        print("Loading...")
    end
end

if not Drawing then
    error("No Drawing Library!")
    return
end

if game.PlaceId == 2991849143 then -- shadow war thing
    local library = loadstring(game:HttpGet("https://pastebin.com/raw/CkyR8ePz"))()
    local ShadowGUI = library:CreateWindow("Shadow War")
    local ESP2 =
        ShadowGUI:Toggle(
        "ESP",
        {
            flag = "ESP2lol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if ShadowGUI.flags.ESP2lol then
                    if not Drawing then
                        error("Drawing Lib not supported on your exploit!")
                        return
                    end
                    local LP = game:GetService("Players").LocalPlayer
                    EspPlrs = {}
                    function IsPartVisible(Part1, Part2)
                        local CheckPart = Instance.new("Part", game:GetService("Workspace"))
                        CheckPart.Name = "CheckVisWall"
                        CheckPart.Anchored = true
                        CheckPart.CanCollide = false
                        CheckPart.Transparency = 1
                        CheckPart.Size = Vector3.new(3, 3, 3)
                        CheckPart.CFrame = Part2.CFrame
                        local Ray = Ray.new(Part1.Position, (Part2.Position - Part1.Position).unit * 9999)
                        local part, position = workspace:FindPartOnRay(Ray, Part1.Parent)
                        if part then
                            if part.Name == CheckPart.Name then
                                CheckPart:Destroy()
                                return true
                            end
                        end
                        CheckPart:Destroy()
                        return false
                    end
                    local function GetPartCorners(Part)
                        local Size = Part.Size * Vector3.new(1, 1.5)
                        return {
                            TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
                            BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
                            TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
                            BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position
                        }
                    end
                    function GetEspPlrs()
                        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
                            if LP.Team then
                                if v.Team.Name ~= LP.Team.Name then
                                    table.insert(EspPlrs, v)
                                end
                            else
                                if v.Name ~= LP.Name then
                                    table.insert(EspPlrs, v)
                                end
                            end
                        end
                    end
                    function tocam(pos)
                        local PosChar, withinScreenBounds = workspace.Camera:WorldToViewportPoint(pos)
                        return Vector2.new(PosChar.X, PosChar.Y)
                    end
                    Drawings = {}
                    function UpdateTracer()
                        for i, v in pairs(Drawings) do
                            v:Remove()
                        end
                        Drawings = {}
                        EspPlrs = {}
                        GetEspPlrs()
                        for i, v in pairs(EspPlrs) do
                            local a, b =
                                pcall(
                                function()
                                    if not v or not v.Character then
                                        return
                                    end
                                    Head = v.Character:FindFirstChild("Head")
                                    if Head ~= nil then
                                        local PosChar, withinScreenBounds =
                                            workspace.Camera:WorldToViewportPoint(Head.Position)
                                        if withinScreenBounds then
                                            if not LP.Character:FindFirstChild("Head") then
                                                return
                                            end
                                            local IsVisible = IsPartVisible(LP.Character:FindFirstChild("Head"), Head)
                                            local Mag =
                                                (LP.Character:FindFirstChild("Head").Position - Head.Position).Magnitude
                                            local DrawColor = Color3.fromRGB(255 / Mag * 255, 255 / 255 * Mag, 0)
                                            local Line = Drawing.new("Line")
                                            Line.Visible = true
                                            Line.From =
                                                Vector2.new(
                                                workspace.Camera.ViewportSize.X / 2,
                                                workspace.Camera.ViewportSize.Y
                                            )
                                            Line.To = Vector2.new(PosChar.X, PosChar.Y)
                                            Line.Color = DrawColor
                                            Line.Thickness = 2
                                            Line.Transparency = 1
                                            Drawings[#Drawings + 1] = Line
                                            local Text = Drawing.new("Text")
                                            Text.Text =
                                                "Name: " ..
                                                v.Name ..
                                                    "\n" ..
                                                        "Dist: " ..
                                                            math.floor(Mag) ..
                                                                " " ..
                                                                    "Visible: " ..
                                                                        tostring(IsVisible) ..
                                                                            " " ..
                                                                                "Health: " ..
                                                                                    v.Character.Humanoid.Health
                                            Text.Color = DrawColor
                                            Text.Center = true
                                            Text.Outline = true
                                            Text.Visible = true
                                            Text.Size = 16
                                            Text.Position = Vector2.new(PosChar.X, PosChar.Y - 50)
                                            Drawings[#Drawings + 1] = Text
                                            local LineColor
                                            local LineThicc = 1
                                            if IsVisible then
                                                LineColor = Color3.fromRGB(0, 255, 0)
                                                LineThicc = 3
                                            else
                                                LineColor = Color3.fromRGB(255, 255, 255)
                                            end
                                            local LinePosChar = GetPartCorners(v.Character.HumanoidRootPart)
                                            local Quad = Drawing.new("Quad")
                                            Quad.Visible = true
                                            Quad.Thickness = 1
                                            Quad.Color = LineColor
                                            Quad.PointA = tocam(LinePosChar["TR"])
                                            Quad.PointB = tocam(LinePosChar["TL"])
                                            Quad.PointC = tocam(LinePosChar["BL"])
                                            Quad.PointD = tocam(LinePosChar["BR"])
                                            Drawings[#Drawings + 1] = Quad
                                        end
                                    end
                                end
                            )
                            if b then
                                warn(b)
                            end
                        end
                    end
                    while true do
                        UpdateTracer()
                        game:GetService("RunService").RenderStepped:Wait()
                    end
                end
            end
        end
    )
    local InfiniteAmmo =
        ShadowGUI:Toggle(
        "Unlimited Ammo",
        {
            flag = "Unlimitedammolol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if ShadowGUI.flags.InfiniteAmmolol then
                    while true do
                        for i, v in pairs(game:GetService("Players").LocalPlayer.Status.Ammo:GetChildren()) do
                            v.Value = 500
                            wait()
                        end
                    end
                end
            end
        end
    )
else
    local load = loadstring("return {}")
    if
        type(load) ~=
            type(
                function()
                end
            )
     then
        error("Exploit doesn't support ui libs!")
    elseif load() == nil then
        error("Exploit doesn't support ui libs!")
    end
    local library = loadstring(game:HttpGet("https://pastebin.com/raw/CkyR8ePz"))()
    local gui = library:CreateWindow("EntryPointHaxx v1")
    local Teleports = library:CreateWindow("Teleports")
    --local patches = game:GetService("StarterGui").Weapons.Patches disabled since useless
    gui:Section("Main")
    Teleports:Section("The Deposit (no noclip)")
    local StarterGui = game:GetService("StarterGui")
    local bindable = Instance.new("BindableFunction")
    function bindable.OnInvoke(response)
        warn("User responded with (OK)")
    end
    StarterGui:SetCore(
        "SendNotification",
        {
            Title = "EntryPointHaxx",
            Text = "EntryPointHaxx, made by gen40!",
            Icon = "rbxassetid://5047429623",
            Duration = 8,
            Callback = bindable,
            Button1 = "OK"
        }
    )
    wait(5)
    local Noclip =
        gui:Toggle(
        "Noclip",
        {
            flag = "Nocliplol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if gui.flags.Nocliplol then
                    local noclip = true
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    while true do
                        player = game:GetService("Players").LocalPlayer
                        character = player.Character
                        if noclip then
                            for _, v in pairs(character:GetDescendants()) do
                                pcall(
                                    function()
                                        if v:IsA("BasePart") then
                                            v.CanCollide = false
                                        end
                                    end
                                )
                            end
                        end
                        game:GetService("RunService").Stepped:wait()
                    end
                    wait(2)
                end
            end
        end
    )
    local ESP =
        gui:Toggle(
        "ESP",
        {
            flag = "ESPlol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if gui.flags.ESPlol then
                    if not Drawing then
                        error("Drawing Library doesn't exist on your exploit!")
                        return
                    end
                    local LP = game:GetService("Players").LocalPlayer
                    EspPlrs = {}
                    function IsPartVisible(Part1, Part2)
                        local CheckPart = Instance.new("Part", game:GetService("Workspace"))
                        CheckPart.Name = "CheckVisWall"
                        CheckPart.Anchored = true
                        CheckPart.CanCollide = false
                        CheckPart.Transparency = 1
                        CheckPart.Size = Vector3.new(3, 3, 3)
                        CheckPart.CFrame = Part2.CFrame
                        local Ray = Ray.new(Part1.Position, (Part2.Position - Part1.Position).unit * 9999)
                        local part, position = workspace:FindPartOnRay(Ray, Part1.Parent)
                        if part then
                            if part.Name == CheckPart.Name then
                                CheckPart:Destroy()
                                return true
                            end
                        end
                        CheckPart:Destroy()
                        return false
                    end
                    local function GetPartCorners(Part)
                        local Size = Part.Size * Vector3.new(1, 1.5)
                        return {
                            TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
                            BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
                            TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
                            BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position
                        }
                    end
                    function GetEspPlrs()
                        for k, v in pairs(game:GetService("Workspace").Level.Actors:GetChildren()) do
                            if LP.Team then
                                if v.Team.Name ~= LP.Team.Name then
                                    table.insert(EspPlrs, v)
                                end
                            else
                                if v.Name ~= LP.Name then
                                    table.insert(EspPlrs, v)
                                end
                            end
                        end
                    end
                    function tocam(pos)
                        local PosChar, withinScreenBounds = workspace.Camera:WorldToViewportPoint(pos)
                        return Vector2.new(PosChar.X, PosChar.Y)
                    end
                    Drawings = {}
                    function UpdateTracer()
                        for i, v in pairs(Drawings) do
                            v:Remove()
                        end
                        Drawings = {}
                        EspPlrs = {}
                        GetEspPlrs()
                        for i, v in pairs(EspPlrs) do
                            local a, b =
                                pcall(
                                function()
                                    if not v or not v.Character then
                                        return
                                    end
                                    Head = v.Character:FindFirstChild("Head")
                                    if Head ~= nil then
                                        local PosChar, withinScreenBounds =
                                            workspace.Camera:WorldToViewportPoint(Head.Position)
                                        if withinScreenBounds then
                                            if not LP.Character:FindFirstChild("Head") then
                                                return
                                            end
                                            local IsVisible = IsPartVisible(LP.Character:FindFirstChild("Head"), Head)
                                            local Mag =
                                                (LP.Character:FindFirstChild("Head").Position - Head.Position).Magnitude
                                            local DrawColor = Color3.fromRGB(255 / Mag * 255, 255 / 255 * Mag, 0)
                                            local Line = Drawing.new("Line")
                                            Line.Visible = true
                                            Line.From =
                                                Vector2.new(
                                                workspace.Camera.ViewportSize.X / 2,
                                                workspace.Camera.ViewportSize.Y
                                            )
                                            Line.To = Vector2.new(PosChar.X, PosChar.Y)
                                            Line.Color = DrawColor
                                            Line.Thickness = 2
                                            Line.Transparency = 1
                                            Drawings[#Drawings + 1] = Line
                                            local Text = Drawing.new("Text")
                                            Text.Text =
                                                "Name: " ..
                                                v.Name ..
                                                    "\n" ..
                                                        "Dist: " ..
                                                            math.floor(Mag) ..
                                                                " " ..
                                                                    "Visible: " ..
                                                                        tostring(IsVisible) ..
                                                                            " " ..
                                                                                "Health: " ..
                                                                                    v.Character.Humanoid.Health
                                            Text.Color = DrawColor
                                            Text.Center = true
                                            Text.Outline = true
                                            Text.Visible = true
                                            Text.Size = 16
                                            Text.Position = Vector2.new(PosChar.X, PosChar.Y - 50)
                                            Drawings[#Drawings + 1] = Text
                                            local LineColor
                                            local LineThicc = 1
                                            if IsVisible then
                                                LineColor = Color3.fromRGB(0, 255, 0)
                                                LineThicc = 3
                                            else
                                                LineColor = Color3.fromRGB(255, 255, 255)
                                            end
                                            local LinePosChar = GetPartCorners(v.Character.HumanoidRootPart)
                                            local Quad = Drawing.new("Quad")
                                            Quad.Visible = true
                                            Quad.Thickness = 1
                                            Quad.Color = LineColor
                                            Quad.PointA = tocam(LinePosChar["TR"])
                                            Quad.PointB = tocam(LinePosChar["TL"])
                                            Quad.PointC = tocam(LinePosChar["BL"])
                                            Quad.PointD = tocam(LinePosChar["BR"])
                                            Drawings[#Drawings + 1] = Quad
                                        end
                                    end
                                end
                            )
                            if b then
                                warn(b)
                            end
                        end
                    end
                    while true do
                        UpdateTracer()
                        game:GetService("RunService").RenderStepped:Wait()
                    end
                end
            end
        end
    )
    local InfiniteAmmo =
        gui:Toggle(
        "Infinite Ammo",
        {
            flag = "InfiniteAmmolol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if gui.flags.InfiniteAmmolol then
                    while true do
                        for i, v in pairs(game:GetService("Players").LocalPlayer.Status.Ammo:GetChildren()) do
                            v.Value = 500
                            wait()
                        end
                    end
                end
            end
        end
    )
    local Crosshair =
        gui:Toggle(
        "Crosshair",
        {
            flag = "Crosshairlol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if gui.flags.Crosshairlol then
                    crosshairlength = 20

                    crosshairlength = 20

                    local uis = game:GetService("UserInputService")
                    local cc = game.Workspace.CurrentCamera
                    local xl = Drawing.new("Line")
                    xl.Visible = true
                    local yl = Drawing.new("Line")
                    yl.Visible = true
                    xl.Thickness = 1
                    yl.Thickness = 1
                    xl.Color = Color3.fromRGB(50, 205, 50)
                    yl.Color = Color3.fromRGB(50, 205, 50)
                    xl.From = Vector2.new((cc.ViewportSize.X / 2) + (crosshairlength / 2 + 1), cc.ViewportSize.Y / 2)
                    xl.To = Vector2.new(cc.ViewportSize.X / 2 - (crosshairlength / 2), cc.ViewportSize.Y / 2)
                    yl.From = Vector2.new(cc.ViewportSize.X / 2, cc.ViewportSize.Y / 2 + (crosshairlength / 2))
                    yl.To = Vector2.new(cc.ViewportSize.X / 2, cc.ViewportSize.Y / 2 - (crosshairlength / 2))
                    function rainbow(yeet)
                        return math.acos(math.cos(yeet * math.pi)) / math.pi
                    end
                    local count = 0
                end
            end
        end
    )

    local Fullbright =
        gui:Toggle(
        "Fullbright",
        {
            flag = "Fullbrightlol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if gui.flags.Fullbrightlol then
                    local Light = game:GetService("Lighting")

                    function dofullbright()
                        Light.Ambient = Color3.new(1, 1, 1)
                        Light.ColorShift_Bottom = Color3.new(1, 1, 1)
                        Light.ColorShift_Top = Color3.new(1, 1, 1)
                    end

                    dofullbright()

                    Light.LightingChanged:Connect(dofullbright)
                end
            end
        end
    )

    local Undetectable =
        gui:Toggle(
        "Undetectable (DEBUG)",
        {
            flag = "Undetectablelol"
        }
    )
    spawn(
        function()
            while wait(1) do
                if gui.flags.Undetectablelol then
                    game:GetService("Workspace").Level.Players.Player.Flags.Trespassing:Destroy()
                    game:GetService("Workspace").Level.Players.Player.Flags.Armed:Destroy()
                end
            end
        end
    )
    local Suicide =
        gui:Button(
        "Suicide",
        function()
            game:GetService("Workspace").Level.Players.Player.Humanoid:Destroy()
        end
    )
    local BasementLOL =
        Teleports:Button(
        "Basement",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(143.158936, 173.5, -87.5504684)
        end
    )

    local BasementCameras =
        Teleports:Button(
        "Basement Cameras",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(156.421799, 173.5, -69.0994873)
        end
    )

    local Upstairscamera =
        Teleports:Button(
        "Upstairs Camera",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(206.02037, 204.699997, -31.9035645)
        end
    )

    local Upstairscomputer =
        Teleports:Button(
        "Upstairs Computer",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(188.715012, 204.699997, -23.5959377)
        end
    )
    local safe =
        Teleports:Button(
        "Safe (Operative +)",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                game:GetService("Workspace").Level.Geometry.Safe.SafeDoor.C4Marker.Location.CFrame
        end
    )
    local vault =
        Teleports:Button(
        "Vault",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(183.394379, 173.5, -69.0273285)
        end
    )
    local innervault =
        Teleports:Button(
        "Inner Vault",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(185.771362, 173.997116, -38.3532219)
        end
    )
    local transformer =
        Teleports:Button(
        "Transformer",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(236.409882, 188.499985, 89.524765)
        end
    )
    local spawn =
        Teleports:Button(
        "Spawn",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(190.754837, 188.499985, 76.4451523)
        end
    )
    Teleports:Section("The Withdrawl TP (WIP)")
    local spawn2 =
        Teleports:Button(
        "Spawn",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-24.6269531, 3.00011826, 15.0105438)
        end
    )
    local spawnnext =
        Teleports:Button(
        "Room near spawn",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-8.33014679, 15.4001341, 20.7810898)
        end
    )
    local securityroomwithdrawl =
        Teleports:Button(
        "Server Room",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                game:GetService("Workspace").Level.Geometry.ServerRoom.Computer.Center.CFrame
        end
    )
    local vaultgatedoor =
        Teleports:Button(
        "Vault (Get both guards)",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(50.0835419, 3.40013123, 50.8847618)
        end
    )
    local innervaultdoor =
        Teleports:Button(
        "Inner Vault",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(65.4378738, 3.4001081, 54.023613)
        end
    )
    local cameraroomwithdrawl =
        Teleports:Button(
        "Camera Room",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                game:GetService("Workspace").Level.Geometry.SecurityRoom.BoxLocation.CFrame
        end
    )
    local Storageroomtamper =
        Teleports:Button(
        "Tamper Room",
        function()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                game:GetService("Workspace").Level.Geometry.StorageRoom.BoxLocation.CFrame
        end
    )
    if getgenv().console == false then
    elseif getgenv().console == true then
        if is_synapse_function then
            print("Successfully loaded using Synapse X!")
        end
        if KRNL_LOADED then
            print("Successfully loaded using KRNL!")
        end
        if IS_ARCH then
            error("Arch is not supported currently!")
        end
        if not is_synapse_function or KRNL_LOADED or IS_ARCH then
            warn(
                "This script works best on Synapse X and KRNL, it has some support for EasyExploits API but for things like WRD API, it doesn't work. Don't be shocked if some features don't work."
            )
            warn("KRNL's, Arch's and Synapse X's drawing librarys are all great for this script.")
        end
    end
    if getgenv().console == true then
        if is_synapse_function or KRNL_LOADED then
            rconsoleclear()
            rconsoleprint("@@YELLOW@@")
            rconsoleprint [==[
  ______       _              _____      _       _   _    _                         __ 
 |  ____|     | |            |  __ \    (_)     | | | |  | |                       /_ |
 | |__   _ __ | |_ _ __ _   _| |__) |__  _ _ __ | |_| |__| | __ ___  ____  __ __   _| |
 |  __| | '_ \| __| '__| | | |  ___/ _ \| | '_ \| __|  __  |/ _` \ \/ /\ \/ / \ \ / / |
 | |____| | | | |_| |  | |_| | |  | (_) | | | | | |_| |  | | (_| |>  <  >  <   \ V /| |
 |______|_| |_|\__|_|   \__, |_|   \___/|_|_| |_|\__|_|  |_|\__,_/_/\_\/_/\_\   \_/ |_|
                         __/ |                                                         
                        |___/                                                          
]==]
            rconsoleprint("\n")
            rconsoleprint [==[
  _                     _          _ _ 
 | |                   | |        | | |
 | |     ___   __ _  __| | ___  __| | |
 | |    / _ \ / _` |/ _` |/ _ \/ _` | |
 | |___| (_) | (_| | (_| |  __/ (_| |_|
 |______\___/ \__,_|\__,_|\___|\__,_(_)
                                       
    ]==]
        end
    else
        print("EntryPointHaxx v1 successfully loaded!")
    end
end
print("Credits go to Unsourced Pyramid, Yes, JasonJJK, walmort and more!")
