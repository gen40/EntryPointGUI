-- for exploits that do not support return {} (ui libraries) i made it so that they do get supported using this which doesn't use httpget and that the ui library is inside the actual script
local library = {count = 0, queue = {}, callbacks = {}, rainbowtable = {}, toggled = true, binds = {}}
local defaults
do
    local dragger = {}
    do
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local inputService = game:GetService("UserInputService")
        local heartbeat = game:GetService("RunService").Heartbeat
        -- // credits to Ririchi / Inori for this cute drag function :)
        function dragger.new(frame)
            local s, event =
                pcall(
                function()
                    return frame.MouseEnter
                end
            )

            if s then
                frame.Active = true

                event:connect(
                    function()
                        local input =
                            frame.InputBegan:connect(
                            function(key)
                                if key.UserInputType == Enum.UserInputType.MouseButton1 then
                                    local objectPosition =
                                        Vector2.new(
                                        mouse.X - frame.AbsolutePosition.X,
                                        mouse.Y - frame.AbsolutePosition.Y
                                    )
                                    while heartbeat:wait() and
                                        inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                        pcall(
                                            function()
                                                frame:TweenPosition(
                                                    UDim2.new(
                                                        0,
                                                        mouse.X - objectPosition.X +
                                                            (frame.Size.X.Offset * frame.AnchorPoint.X),
                                                        0,
                                                        mouse.Y - objectPosition.Y +
                                                            (frame.Size.Y.Offset * frame.AnchorPoint.Y)
                                                    ),
                                                    "Out",
                                                    "Linear",
                                                    0.1,
                                                    true
                                                )
                                            end
                                        )
                                    end
                                end
                            end
                        )

                        local leave
                        leave =
                            frame.MouseLeave:connect(
                            function()
                                input:disconnect()
                                leave:disconnect()
                            end
                        )
                    end
                )
            end
        end

        game:GetService("UserInputService").InputBegan:connect(
            function(key, gpe)
                if (not gpe) then
                    if key.KeyCode == Enum.KeyCode.RightControl then
                        library.toggled = not library.toggled
                        for i, data in next, library.queue do
                            local pos = (library.toggled and data.p or UDim2.new(-1, 0, -0.5, 0))
                            data.w:TweenPosition(pos, (library.toggled and "Out" or "In"), "Quad", 0.15, true)
                            wait()
                        end
                    end
                end
            end
        )
    end

    local types = {}
    do
        types.__index = types
        function types.window(name, options)
            library.count = library.count + 1
            local newWindow =
                library:Create(
                "Frame",
                {
                    Name = name,
                    Size = UDim2.new(0, 190, 0, 30),
                    BackgroundColor3 = options.topcolor,
                    BorderSizePixel = 0,
                    Parent = library.container,
                    Position = UDim2.new(0, (15 + (200 * library.count) - 200), 0, 0),
                    ZIndex = 3,
                    library:Create(
                        "TextLabel",
                        {
                            Text = name,
                            Size = UDim2.new(1, -10, 1, 0),
                            Position = UDim2.new(0, 5, 0, 0),
                            BackgroundTransparency = 1,
                            Font = Enum.Font.Code,
                            TextSize = options.titlesize,
                            Font = options.titlefont,
                            TextColor3 = options.titletextcolor,
                            TextStrokeTransparency = library.options.titlestroke,
                            TextStrokeColor3 = library.options.titlestrokecolor,
                            ZIndex = 3
                        }
                    ),
                    library:Create(
                        "TextButton",
                        {
                            Size = UDim2.new(0, 30, 0, 30),
                            Position = UDim2.new(1, -35, 0, 0),
                            BackgroundTransparency = 1,
                            Text = "-",
                            TextSize = options.titlesize,
                            Font = options.titlefont, --Enum.Font.Code;
                            Name = "window_toggle",
                            TextColor3 = options.titletextcolor,
                            TextStrokeTransparency = library.options.titlestroke,
                            TextStrokeColor3 = library.options.titlestrokecolor,
                            ZIndex = 3
                        }
                    ),
                    library:Create(
                        "Frame",
                        {
                            Name = "Underline",
                            Size = UDim2.new(1, 0, 0, 2),
                            Position = UDim2.new(0, 0, 1, -2),
                            BackgroundColor3 = (options.underlinecolor ~= "rainbow" and options.underlinecolor or
                                Color3.new()),
                            BorderSizePixel = 0,
                            ZIndex = 3
                        }
                    ),
                    library:Create(
                        "Frame",
                        {
                            Name = "container",
                            Position = UDim2.new(0, 0, 1, 0),
                            Size = UDim2.new(1, 0, 0, 0),
                            BorderSizePixel = 0,
                            BackgroundColor3 = options.bgcolor,
                            ClipsDescendants = false,
                            library:Create(
                                "UIListLayout",
                                {
                                    Name = "List",
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                }
                            )
                        }
                    )
                }
            )

            if options.underlinecolor == "rainbow" then
                table.insert(library.rainbowtable, newWindow:FindFirstChild("Underline"))
            end

            local window =
                setmetatable(
                {
                    count = 0,
                    object = newWindow,
                    container = newWindow.container,
                    toggled = true,
                    flags = {}
                },
                types
            )

            table.insert(
                library.queue,
                {
                    w = window.object,
                    p = window.object.Position
                }
            )

            newWindow:FindFirstChild("window_toggle").MouseButton1Click:connect(
                function()
                    window.toggled = not window.toggled
                    newWindow:FindFirstChild("window_toggle").Text = (window.toggled and "+" or "-")
                    if (not window.toggled) then
                        window.container.ClipsDescendants = true
                    end
                    wait()
                    local y = 0
                    for i, v in next, window.container:GetChildren() do
                        if (not v:IsA("UIListLayout")) then
                            y = y + v.AbsoluteSize.Y
                        end
                    end

                    local targetSize = window.toggled and UDim2.new(1, 0, 0, y + 5) or UDim2.new(1, 0, 0, 0)
                    local targetDirection = window.toggled and "In" or "Out"

                    window.container:TweenSize(targetSize, targetDirection, "Quad", 0.15, true)
                    wait(.15)
                    if window.toggled then
                        window.container.ClipsDescendants = false
                    end
                end
            )

            return window
        end

        function types:Resize()
            local y = 0
            for i, v in next, self.container:GetChildren() do
                if (not v:IsA("UIListLayout")) then
                    y = y + v.AbsoluteSize.Y
                end
            end
            self.container.Size = UDim2.new(1, 0, 0, y + 5)
        end

        function types:GetOrder()
            local c = 0
            for i, v in next, self.container:GetChildren() do
                if (not v:IsA("UIListLayout")) then
                    c = c + 1
                end
            end
            return c
        end

        function types:Label(text)
            local v =
                game:GetService "TextService":GetTextSize(
                text,
                18,
                Enum.Font.SourceSans,
                Vector2.new(math.huge, math.huge)
            )
            local object =
                library:Create(
                "Frame",
                {
                    Size = UDim2.new(1, 0, 0, v.Y + 5),
                    BackgroundTransparency = 1,
                    library:Create(
                        "TextLabel",
                        {
                            Size = UDim2.new(1, 0, 1, 0),
                            Position = UDim2.new(0, 10, 0, 0),
                            LayoutOrder = self:GetOrder(),
                            Text = text,
                            TextSize = 18,
                            Font = Enum.Font.SourceSans,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 1,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextWrapped = true
                        }
                    ),
                    Parent = self.container
                }
            )
            self:Resize()
        end

        function types:Toggle(name, options, callback)
            local default = options.default or false
            local location = options.location or self.flags
            local flag = options.flag or ""
            local callback = callback or function()
                end

            location[flag] = default

            local check =
                library:Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    LayoutOrder = self:GetOrder(),
                    library:Create(
                        "TextLabel",
                        {
                            Name = name,
                            Text = "\r" .. name,
                            BackgroundTransparency = 1,
                            TextColor3 = library.options.textcolor,
                            Position = UDim2.new(0, 5, 0, 0),
                            Size = UDim2.new(1, -5, 1, 0),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Font = library.options.font,
                            TextSize = library.options.fontsize,
                            TextStrokeTransparency = library.options.textstroke,
                            TextStrokeColor3 = library.options.strokecolor,
                            library:Create(
                                "TextButton",
                                {
                                    Text = (location[flag] and utf8.char(10003) or ""),
                                    Font = library.options.font,
                                    TextSize = library.options.fontsize,
                                    Name = "Checkmark",
                                    Size = UDim2.new(0, 20, 0, 20),
                                    Position = UDim2.new(1, -25, 0, 4),
                                    TextColor3 = library.options.textcolor,
                                    BackgroundColor3 = library.options.bgcolor,
                                    BorderColor3 = library.options.bordercolor,
                                    TextStrokeTransparency = library.options.textstroke,
                                    TextStrokeColor3 = library.options.strokecolor
                                }
                            )
                        }
                    ),
                    Parent = self.container
                }
            )

            local function click(t)
                location[flag] = not location[flag]
                callback(location[flag])
                check:FindFirstChild(name).Checkmark.Text = location[flag] and utf8.char(10003) or ""
            end

            check:FindFirstChild(name).Checkmark.MouseButton1Click:connect(click)
            library.callbacks[flag] = click

            if location[flag] == true then
                callback(location[flag])
            end

            self:Resize()
            return {
                Set = function(self, b)
                    location[flag] = b
                    callback(location[flag])
                    check:FindFirstChild(name).Checkmark.Text = location[flag] and utf8.char(10003) or ""
                end
            }
        end

        function types:Button(name, callback)
            callback = callback or function()
                end

            local check =
                library:Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    LayoutOrder = self:GetOrder(),
                    library:Create(
                        "TextButton",
                        {
                            Name = name,
                            Text = name,
                            BackgroundColor3 = library.options.btncolor,
                            BorderColor3 = library.options.bordercolor,
                            TextStrokeTransparency = library.options.textstroke,
                            TextStrokeColor3 = library.options.strokecolor,
                            TextColor3 = library.options.textcolor,
                            Position = UDim2.new(0, 5, 0, 5),
                            Size = UDim2.new(1, -10, 0, 20),
                            Font = library.options.font,
                            TextSize = library.options.fontsize
                        }
                    ),
                    Parent = self.container
                }
            )

            check:FindFirstChild(name).MouseButton1Click:connect(callback)
            self:Resize()

            return {
                Fire = function()
                    callback()
                end
            }
        end

        function types:Box(name, options, callback) --type, default, data, location, flag)
            local type = options.type or ""
            local default = options.default or ""
            local data = options.data
            local location = options.location or self.flags
            local flag = options.flag or ""
            local callback = callback or function()
                end
            local min = options.min or 0
            local max = options.max or 9e9

            if type == "number" and (not tonumber(default)) then
                location[flag] = default
            else
                location[flag] = ""
                default = ""
            end

            local check =
                library:Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    LayoutOrder = self:GetOrder(),
                    library:Create(
                        "TextLabel",
                        {
                            Name = name,
                            Text = "\r" .. name,
                            BackgroundTransparency = 1,
                            TextColor3 = library.options.textcolor,
                            TextStrokeTransparency = library.options.textstroke,
                            TextStrokeColor3 = library.options.strokecolor,
                            Position = UDim2.new(0, 5, 0, 0),
                            Size = UDim2.new(1, -5, 1, 0),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Font = library.options.font,
                            TextSize = library.options.fontsize,
                            library:Create(
                                "TextBox",
                                {
                                    TextStrokeTransparency = library.options.textstroke,
                                    TextStrokeColor3 = library.options.strokecolor,
                                    Text = tostring(default),
                                    Font = library.options.font,
                                    TextSize = library.options.fontsize,
                                    Name = "Box",
                                    Size = UDim2.new(0, 60, 0, 20),
                                    Position = UDim2.new(1, -65, 0, 3),
                                    TextColor3 = library.options.textcolor,
                                    BackgroundColor3 = library.options.boxcolor,
                                    BorderColor3 = library.options.bordercolor,
                                    PlaceholderColor3 = library.options.placeholdercolor
                                }
                            )
                        }
                    ),
                    Parent = self.container
                }
            )

            local box = check:FindFirstChild(name):FindFirstChild("Box")
            box.FocusLost:connect(
                function(e)
                    local old = location[flag]
                    if type == "number" then
                        local num = tonumber(box.Text)
                        if (not num) then
                            box.Text = tonumber(location[flag])
                        else
                            location[flag] = math.clamp(num, min, max)
                            box.Text = tonumber(location[flag])
                        end
                    else
                        location[flag] = tostring(box.Text)
                    end

                    callback(location[flag], old, e)
                end
            )

            if type == "number" then
                box:GetPropertyChangedSignal("Text"):connect(
                    function()
                        box.Text = string.gsub(box.Text, "[%a+]", "")
                    end
                )
            end

            self:Resize()
            return box
        end

        function types:Bind(name, options, callback)
            local location = options.location or self.flags
            local keyboardOnly = options.kbonly or false
            local flag = options.flag or ""
            local callback = callback or function()
                end
            local default = options.default

            if keyboardOnly and (not tostring(default):find("MouseButton")) then
                location[flag] = default
            end

            local banned = {
                Return = true,
                Space = true,
                Tab = true,
                Unknown = true
            }

            local shortNames = {
                RightControl = "RightCtrl",
                LeftControl = "LeftCtrl",
                LeftShift = "LShift",
                RightShift = "RShift",
                MouseButton1 = "Mouse1",
                MouseButton2 = "Mouse2"
            }

            local allowed = {
                MouseButton1 = true,
                MouseButton2 = true
            }

            local nm = (default and (shortNames[default.Name] or default.Name) or "None")
            local check =
                library:Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    LayoutOrder = self:GetOrder(),
                    library:Create(
                        "TextLabel",
                        {
                            Name = name,
                            Text = "\r" .. name,
                            BackgroundTransparency = 1,
                            TextColor3 = library.options.textcolor,
                            Position = UDim2.new(0, 5, 0, 0),
                            Size = UDim2.new(1, -5, 1, 0),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Font = library.options.font,
                            TextSize = library.options.fontsize,
                            TextStrokeTransparency = library.options.textstroke,
                            TextStrokeColor3 = library.options.strokecolor,
                            BorderColor3 = library.options.bordercolor,
                            BorderSizePixel = 1,
                            library:Create(
                                "TextButton",
                                {
                                    Name = "Keybind",
                                    Text = nm,
                                    TextStrokeTransparency = library.options.textstroke,
                                    TextStrokeColor3 = library.options.strokecolor,
                                    Font = library.options.font,
                                    TextSize = library.options.fontsize,
                                    Size = UDim2.new(0, 60, 0, 20),
                                    Position = UDim2.new(1, -65, 0, 5),
                                    TextColor3 = library.options.textcolor,
                                    BackgroundColor3 = library.options.bgcolor,
                                    BorderColor3 = library.options.bordercolor,
                                    BorderSizePixel = 1
                                }
                            )
                        }
                    ),
                    Parent = self.container
                }
            )

            local button = check:FindFirstChild(name).Keybind
            button.MouseButton1Click:connect(
                function()
                    library.binding = true

                    button.Text = "..."
                    local a, b = game:GetService("UserInputService").InputBegan:wait()
                    local name = tostring(a.KeyCode.Name)
                    local typeName = tostring(a.UserInputType.Name)

                    if
                        (a.UserInputType ~= Enum.UserInputType.Keyboard and (allowed[a.UserInputType.Name]) and
                            (not keyboardOnly)) or
                            (a.KeyCode and (not banned[a.KeyCode.Name]))
                     then
                        local name =
                            (a.UserInputType ~= Enum.UserInputType.Keyboard and a.UserInputType.Name or a.KeyCode.Name)
                        location[flag] = (a)
                        button.Text = shortNames[name] or name
                    else
                        if (location[flag]) then
                            if
                                (not pcall(
                                    function()
                                        return location[flag].UserInputType
                                    end
                                ))
                             then
                                local name = tostring(location[flag])
                                button.Text = shortNames[name] or name
                            else
                                local name =
                                    (location[flag].UserInputType ~= Enum.UserInputType.Keyboard and
                                    location[flag].UserInputType.Name or
                                    location[flag].KeyCode.Name)
                                button.Text = shortNames[name] or name
                            end
                        end
                    end

                    wait(0.1)
                    library.binding = false
                end
            )

            if location[flag] then
                button.Text = shortNames[tostring(location[flag].Name)] or tostring(location[flag].Name)
            end

            library.binds[flag] = {
                location = location,
                callback = callback
            }

            self:Resize()
        end

        function types:Section(name)
            local order = self:GetOrder()
            local determinedSize = UDim2.new(1, 0, 0, 25)
            local determinedPos = UDim2.new(0, 0, 0, 4)
            local secondarySize = UDim2.new(1, 0, 0, 20)

            if order == 0 then
                determinedSize = UDim2.new(1, 0, 0, 21)
                determinedPos = UDim2.new(0, 0, 0, -1)
                secondarySize = nil
            end

            local check =
                library:Create(
                "Frame",
                {
                    Name = "Section",
                    BackgroundTransparency = 1,
                    Size = determinedSize,
                    BackgroundColor3 = library.options.sectncolor,
                    BorderSizePixel = 0,
                    LayoutOrder = order,
                    library:Create(
                        "TextLabel",
                        {
                            Name = "section_lbl",
                            Text = name,
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            BackgroundColor3 = library.options.sectncolor,
                            TextColor3 = library.options.textcolor,
                            Position = determinedPos,
                            Size = (secondarySize or UDim2.new(1, 0, 1, 0)),
                            Font = library.options.font,
                            TextSize = library.options.fontsize,
                            TextStrokeTransparency = library.options.textstroke,
                            TextStrokeColor3 = library.options.strokecolor
                        }
                    ),
                    Parent = self.container
                }
            )

            self:Resize()
        end

        function types:Slider(name, options, callback)
            local default = options.default or options.min
            local min = options.min or 0
            local max = options.max or 1
            local location = options.location or self.flags
            local precise = options.precise or false -- e.g 0, 1 vs 0, 0.1, 0.2, ...
            local flag = options.flag or ""
            local callback = callback or function()
                end

            location[flag] = default

            local check =
                library:Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    LayoutOrder = self:GetOrder(),
                    library:Create(
                        "TextLabel",
                        {
                            Name = name,
                            TextStrokeTransparency = library.options.textstroke,
                            TextStrokeColor3 = library.options.strokecolor,
                            Text = "\r" .. name,
                            BackgroundTransparency = 1,
                            TextColor3 = library.options.textcolor,
                            Position = UDim2.new(0, 5, 0, 2),
                            Size = UDim2.new(1, -5, 1, 0),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Font = library.options.font,
                            TextSize = library.options.fontsize,
                            library:Create(
                                "Frame",
                                {
                                    Name = "Container",
                                    Size = UDim2.new(0, 60, 0, 20),
                                    Position = UDim2.new(1, -65, 0, 3),
                                    BackgroundTransparency = 1,
                                    --BorderColor3 = library.options.bordercolor;
                                    BorderSizePixel = 0,
                                    library:Create(
                                        "TextLabel",
                                        {
                                            Name = "ValueLabel",
                                            Text = default,
                                            BackgroundTransparency = 1,
                                            TextColor3 = library.options.textcolor,
                                            Position = UDim2.new(0, -10, 0, 0),
                                            Size = UDim2.new(0, 1, 1, 0),
                                            TextXAlignment = Enum.TextXAlignment.Right,
                                            Font = library.options.font,
                                            TextSize = library.options.fontsize,
                                            TextStrokeTransparency = library.options.textstroke,
                                            TextStrokeColor3 = library.options.strokecolor
                                        }
                                    ),
                                    library:Create(
                                        "TextButton",
                                        {
                                            Name = "Button",
                                            Size = UDim2.new(0, 5, 1, -2),
                                            Position = UDim2.new(0, 0, 0, 1),
                                            AutoButtonColor = false,
                                            Text = "",
                                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                                            BorderSizePixel = 0,
                                            ZIndex = 2,
                                            TextStrokeTransparency = library.options.textstroke,
                                            TextStrokeColor3 = library.options.strokecolor
                                        }
                                    ),
                                    library:Create(
                                        "Frame",
                                        {
                                            Name = "Line",
                                            BackgroundTransparency = 0,
                                            Position = UDim2.new(0, 0, 0.5, 0),
                                            Size = UDim2.new(1, 0, 0, 1),
                                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                            BorderSizePixel = 0
                                        }
                                    )
                                }
                            )
                        }
                    ),
                    Parent = self.container
                }
            )

            local overlay = check:FindFirstChild(name)

            local renderSteppedConnection
            local inputBeganConnection
            local inputEndedConnection
            local mouseLeaveConnection
            local mouseDownConnection
            local mouseUpConnection

            check:FindFirstChild(name).Container.MouseEnter:connect(
                function()
                    local function update()
                        if renderSteppedConnection then
                            renderSteppedConnection:disconnect()
                        end

                        renderSteppedConnection =
                            game:GetService("RunService").RenderStepped:connect(
                            function()
                                local mouse = game:GetService("UserInputService"):GetMouseLocation()
                                local percent =
                                    (mouse.X - overlay.Container.AbsolutePosition.X) /
                                    (overlay.Container.AbsoluteSize.X)
                                percent = math.clamp(percent, 0, 1)
                                percent = tonumber(string.format("%.2f", percent))

                                overlay.Container.Button.Position = UDim2.new(math.clamp(percent, 0, 0.99), 0, 0, 1)

                                local num = min + (max - min) * percent
                                local value = (precise and num or math.floor(num))

                                overlay.Container.ValueLabel.Text = value
                                callback(tonumber(value))
                                location[flag] = tonumber(value)
                            end
                        )
                    end

                    local function disconnect()
                        if renderSteppedConnection then
                            renderSteppedConnection:disconnect()
                        end
                        if inputBeganConnection then
                            inputBeganConnection:disconnect()
                        end
                        if inputEndedConnection then
                            inputEndedConnection:disconnect()
                        end
                        if mouseLeaveConnection then
                            mouseLeaveConnection:disconnect()
                        end
                        if mouseUpConnection then
                            mouseUpConnection:disconnect()
                        end
                    end

                    inputBeganConnection =
                        check:FindFirstChild(name).Container.InputBegan:connect(
                        function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                update()
                            end
                        end
                    )

                    inputEndedConnection =
                        check:FindFirstChild(name).Container.InputEnded:connect(
                        function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                disconnect()
                            end
                        end
                    )

                    mouseDownConnection = check:FindFirstChild(name).Container.Button.MouseButton1Down:connect(update)
                    mouseUpConnection =
                        game:GetService("UserInputService").InputEnded:connect(
                        function(a, b)
                            if a.UserInputType == Enum.UserInputType.MouseButton1 and (mouseDownConnection.Connected) then
                                disconnect()
                            end
                        end
                    )
                end
            )

            if default ~= min then
                local percent = 1 - ((max - default) / (max - min))
                local number = default

                number = tonumber(string.format("%.2f", number))
                if (not precise) then
                    number = math.floor(number)
                end

                overlay.Container.Button.Position = UDim2.new(math.clamp(percent, 0, 0.99), 0, 0, 1)
                overlay.Container.ValueLabel.Text = number
            end

            self:Resize()
            return {
                Set = function(self, value)
                    local percent = 1 - ((max - value) / (max - min))
                    local number = value

                    number = tonumber(string.format("%.2f", number))
                    if (not precise) then
                        number = math.floor(number)
                    end

                    overlay.Container.Button.Position = UDim2.new(math.clamp(percent, 0, 0.99), 0, 0, 1)
                    overlay.Container.ValueLabel.Text = number
                    location[flag] = number
                    callback(number)
                end
            }
        end

        function types:SearchBox(text, options, callback)
            local list = options.list or {}
            local flag = options.flag or ""
            local location = options.location or self.flags
            local callback = callback or function()
                end

            local busy = false
            local box =
                library:Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    LayoutOrder = self:GetOrder(),
                    library:Create(
                        "TextBox",
                        {
                            Text = "",
                            PlaceholderText = text,
                            PlaceholderColor3 = Color3.fromRGB(60, 60, 60),
                            Font = library.options.font,
                            TextSize = library.options.fontsize,
                            Name = "Box",
                            Size = UDim2.new(1, -10, 0, 20),
                            Position = UDim2.new(0, 5, 0, 4),
                            TextColor3 = library.options.textcolor,
                            BackgroundColor3 = library.options.dropcolor,
                            BorderColor3 = library.options.bordercolor,
                            TextStrokeTransparency = library.options.textstroke,
                            TextStrokeColor3 = library.options.strokecolor,
                            library:Create(
                                "ScrollingFrame",
                                {
                                    Position = UDim2.new(0, 0, 1, 1),
                                    Name = "Container",
                                    BackgroundColor3 = library.options.btncolor,
                                    ScrollBarThickness = 0,
                                    BorderSizePixel = 0,
                                    BorderColor3 = library.options.bordercolor,
                                    Size = UDim2.new(1, 0, 0, 0),
                                    library:Create(
                                        "UIListLayout",
                                        {
                                            Name = "ListLayout",
                                            SortOrder = Enum.SortOrder.LayoutOrder
                                        }
                                    ),
                                    ZIndex = 2
                                }
                            )
                        }
                    ),
                    Parent = self.container
                }
            )

            local function rebuild(text)
                box:FindFirstChild("Box").Container.ScrollBarThickness = 0
                for i, child in next, box:FindFirstChild("Box").Container:GetChildren() do
                    if (not child:IsA("UIListLayout")) then
                        child:Destroy()
                    end
                end

                if #text > 0 then
                    for i, v in next, list do
                        if string.sub(string.lower(v), 1, string.len(text)) == string.lower(text) then
                            local button =
                                library:Create(
                                "TextButton",
                                {
                                    Text = v,
                                    Font = library.options.font,
                                    TextSize = library.options.fontsize,
                                    TextColor3 = library.options.textcolor,
                                    BorderColor3 = library.options.bordercolor,
                                    TextStrokeTransparency = library.options.textstroke,
                                    TextStrokeColor3 = library.options.strokecolor,
                                    Parent = box:FindFirstChild("Box").Container,
                                    Size = UDim2.new(1, 0, 0, 20),
                                    LayoutOrder = i,
                                    BackgroundColor3 = library.options.btncolor,
                                    ZIndex = 2
                                }
                            )

                            button.MouseButton1Click:connect(
                                function()
                                    busy = true
                                    box:FindFirstChild("Box").Text = button.Text
                                    wait()
                                    busy = false

                                    location[flag] = button.Text
                                    callback(location[flag])

                                    box:FindFirstChild("Box").Container.ScrollBarThickness = 0
                                    for i, child in next, box:FindFirstChild("Box").Container:GetChildren() do
                                        if (not child:IsA("UIListLayout")) then
                                            child:Destroy()
                                        end
                                    end
                                    box:FindFirstChild("Box").Container:TweenSize(
                                        UDim2.new(1, 0, 0, 0),
                                        "Out",
                                        "Quad",
                                        0.25,
                                        true
                                    )
                                end
                            )
                        end
                    end
                end

                local c = box:FindFirstChild("Box").Container:GetChildren()
                local ry = (20 * (#c)) - 20

                local y = math.clamp((20 * (#c)) - 20, 0, 100)
                if ry > 100 then
                    box:FindFirstChild("Box").Container.ScrollBarThickness = 5
                end

                box:FindFirstChild("Box").Container:TweenSize(UDim2.new(1, 0, 0, y), "Out", "Quad", 0.25, true)
                box:FindFirstChild("Box").Container.CanvasSize = UDim2.new(1, 0, 0, (20 * (#c)) - 20)
            end

            box:FindFirstChild("Box"):GetPropertyChangedSignal("Text"):connect(
                function()
                    if (not busy) then
                        rebuild(box:FindFirstChild("Box").Text)
                    end
                end
            )

            local function reload(new_list)
                list = new_list
                rebuild("")
            end
            self:Resize()
            return reload, box:FindFirstChild("Box")
        end

        function types:Dropdown(name, options, callback)
            local location = options.location or self.flags
            local flag = options.flag or ""
            local callback = callback or function()
                end
            local list = options.list or {}

            location[flag] = list[1]
            local check =
                library:Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    LayoutOrder = self:GetOrder(),
                    library:Create(
                        "Frame",
                        {
                            Name = "dropdown_lbl",
                            BackgroundTransparency = 0,
                            BackgroundColor3 = library.options.dropcolor,
                            Position = UDim2.new(0, 5, 0, 4),
                            BorderColor3 = library.options.bordercolor,
                            Size = UDim2.new(1, -10, 0, 20),
                            library:Create(
                                "TextLabel",
                                {
                                    Name = "Selection",
                                    Size = UDim2.new(1, 0, 1, 0),
                                    Text = list[1],
                                    TextColor3 = library.options.textcolor,
                                    BackgroundTransparency = 1,
                                    Font = library.options.font,
                                    TextSize = library.options.fontsize,
                                    TextStrokeTransparency = library.options.textstroke,
                                    TextStrokeColor3 = library.options.strokecolor
                                }
                            ),
                            library:Create(
                                "TextButton",
                                {
                                    Name = "drop",
                                    BackgroundTransparency = 1,
                                    Size = UDim2.new(0, 20, 1, 0),
                                    Position = UDim2.new(1, -25, 0, 0),
                                    Text = "v",
                                    TextColor3 = library.options.textcolor,
                                    Font = library.options.font,
                                    TextSize = library.options.fontsize,
                                    TextStrokeTransparency = library.options.textstroke,
                                    TextStrokeColor3 = library.options.strokecolor
                                }
                            )
                        }
                    ),
                    Parent = self.container
                }
            )

            local button = check:FindFirstChild("dropdown_lbl").drop
            local input

            button.MouseButton1Click:connect(
                function()
                    if (input and input.Connected) then
                        return
                    end

                    check:FindFirstChild("dropdown_lbl"):WaitForChild("Selection").TextColor3 =
                        Color3.fromRGB(60, 60, 60)
                    check:FindFirstChild("dropdown_lbl"):WaitForChild("Selection").Text = name
                    local c = 0
                    for i, v in next, list do
                        c = c + 20
                    end

                    local size = UDim2.new(1, 0, 0, c)

                    local clampedSize
                    local scrollSize = 0
                    if size.Y.Offset > 100 then
                        clampedSize = UDim2.new(1, 0, 0, 100)
                        scrollSize = 5
                    end

                    local goSize = (clampedSize ~= nil and clampedSize) or size
                    local container =
                        library:Create(
                        "ScrollingFrame",
                        {
                            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
                            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
                            Name = "DropContainer",
                            Parent = check:FindFirstChild("dropdown_lbl"),
                            Size = UDim2.new(1, 0, 0, 0),
                            BackgroundColor3 = library.options.bgcolor,
                            BorderColor3 = library.options.bordercolor,
                            Position = UDim2.new(0, 0, 1, 0),
                            ScrollBarThickness = scrollSize,
                            CanvasSize = UDim2.new(0, 0, 0, size.Y.Offset),
                            ZIndex = 5,
                            ClipsDescendants = true,
                            library:Create(
                                "UIListLayout",
                                {
                                    Name = "List",
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                }
                            )
                        }
                    )

                    for i, v in next, list do
                        local btn =
                            library:Create(
                            "TextButton",
                            {
                                Size = UDim2.new(1, 0, 0, 20),
                                BackgroundColor3 = library.options.btncolor,
                                BorderColor3 = library.options.bordercolor,
                                Text = v,
                                Font = library.options.font,
                                TextSize = library.options.fontsize,
                                LayoutOrder = i,
                                Parent = container,
                                ZIndex = 5,
                                TextColor3 = library.options.textcolor,
                                TextStrokeTransparency = library.options.textstroke,
                                TextStrokeColor3 = library.options.strokecolor
                            }
                        )

                        btn.MouseButton1Click:connect(
                            function()
                                check:FindFirstChild("dropdown_lbl"):WaitForChild("Selection").TextColor3 =
                                    library.options.textcolor
                                check:FindFirstChild("dropdown_lbl"):WaitForChild("Selection").Text = btn.Text

                                location[flag] = tostring(btn.Text)
                                callback(location[flag])

                                game:GetService("Debris"):AddItem(container, 0)
                                input:disconnect()
                            end
                        )
                    end

                    container:TweenSize(goSize, "Out", "Quad", 0.15, true)

                    local function isInGui(frame)
                        local mloc = game:GetService("UserInputService"):GetMouseLocation()
                        local mouse = Vector2.new(mloc.X, mloc.Y - 36)

                        local x1, x2 = frame.AbsolutePosition.X, frame.AbsolutePosition.X + frame.AbsoluteSize.X
                        local y1, y2 = frame.AbsolutePosition.Y, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y

                        return (mouse.X >= x1 and mouse.X <= x2) and (mouse.Y >= y1 and mouse.Y <= y2)
                    end

                    input =
                        game:GetService("UserInputService").InputBegan:connect(
                        function(a)
                            if a.UserInputType == Enum.UserInputType.MouseButton1 and (not isInGui(container)) then
                                check:FindFirstChild("dropdown_lbl"):WaitForChild("Selection").TextColor3 =
                                    library.options.textcolor
                                check:FindFirstChild("dropdown_lbl"):WaitForChild("Selection").Text = location[flag]

                                container:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quad", 0.15, true)
                                wait(0.15)

                                game:GetService("Debris"):AddItem(container, 0)
                                input:disconnect()
                            end
                        end
                    )
                end
            )

            self:Resize()
            local function reload(self, array)
                options = array
                location[flag] = array[1]
                pcall(
                    function()
                        input:disconnect()
                    end
                )
                check:WaitForChild("dropdown_lbl").Selection.Text = location[flag]
                check:FindFirstChild("dropdown_lbl"):WaitForChild("Selection").TextColor3 = library.options.textcolor
                game:GetService("Debris"):AddItem(container, 0)
            end

            return {
                Refresh = reload
            }
        end
    end

    function library:Create(class, data)
        local obj = Instance.new(class)
        for i, v in next, data do
            if i ~= "Parent" then
                if typeof(v) == "Instance" then
                    v.Parent = obj
                else
                    obj[i] = v
                end
            end
        end

        obj.Parent = data.Parent
        return obj
    end

    function library:CreateWindow(name, options)
        if (not library.container) then
            library.container =
                self:Create(
                "ScreenGui",
                {
                    self:Create(
                        "Frame",
                        {
                            Name = "Container",
                            Size = UDim2.new(1, -30, 1, 0),
                            Position = UDim2.new(0, 20, 0, 20),
                            BackgroundTransparency = 1,
                            Active = false
                        }
                    ),
                    Parent = game:GetService("CoreGui")
                }
            ):FindFirstChild("Container")
        end

        if (not library.options) then
            library.options = setmetatable(options or {}, {__index = defaults})
        end

        local window = types.window(name, library.options)
        dragger.new(window.object)
        return window
    end

    default = {
        topcolor = Color3.fromRGB(30, 30, 30),
        titlecolor = Color3.fromRGB(255, 255, 255),
        underlinecolor = "rainbow",
        bgcolor = Color3.fromRGB(35, 35, 35),
        boxcolor = Color3.fromRGB(35, 35, 35),
        btncolor = Color3.fromRGB(25, 25, 25),
        dropcolor = Color3.fromRGB(25, 25, 25),
        sectncolor = Color3.fromRGB(25, 25, 25),
        bordercolor = Color3.fromRGB(60, 60, 60),
        font = Enum.Font.SourceSans,
        titlefont = Enum.Font.Code,
        fontsize = 17,
        titlesize = 18,
        textstroke = 1,
        titlestroke = 1,
        strokecolor = Color3.fromRGB(0, 0, 0),
        textcolor = Color3.fromRGB(255, 255, 255),
        titletextcolor = Color3.fromRGB(255, 255, 255),
        placeholdercolor = Color3.fromRGB(255, 255, 255),
        titlestrokecolor = Color3.fromRGB(0, 0, 0)
    }

    library.options = setmetatable({}, {__index = default})

    spawn(
        function()
            while true do
                for i = 0, 1, 1 / 300 do
                    for _, obj in next, library.rainbowtable do
                        obj.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
                    end
                    wait()
                end
            end
        end
    )

    local function isreallypressed(bind, inp)
        local key = bind
        if typeof(key) == "Instance" then
            if key.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key.KeyCode then
                return true
            elseif tostring(key.UserInputType):find("MouseButton") and inp.UserInputType == key.UserInputType then
                return true
            end
        end
        if tostring(key):find "MouseButton1" then
            return key == inp.UserInputType
        else
            return key == inp.KeyCode
        end
    end

    game:GetService("UserInputService").InputBegan:connect(
        function(input)
            if (not library.binding) then
                for idx, binds in next, library.binds do
                    local real_binding = binds.location[idx]
                    if real_binding and isreallypressed(real_binding, input) then
                        binds.callback()
                    end
                end
            end
        end
    )
end
getgenv().console = true -- synapse x/krnl/arch console, you can turn it off if you're not using synapse x, your exploit MUST support rconsoleprint if this is on

if getgenv().console == true then
    if is_synapse_function or KRNL_LOADED or IS_ARCH then
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
                                                                        " " .. "Health: " .. v.Character.Humanoid.Health
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
Teleports:Section("The Withdrawl TP")
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
Teleports:Section("The Lakehouse TP")
local controlroom =
    Teleports:Button(
    "Control Room",
    function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
            game:GetService("Workspace").Level.Geometry["2"].SecurityComputer1.ImgScreen.CFrame
    end
)
Teleports:Section("The Scientist TP")
local basementscientist =
    Teleports:Button(
    "Basement",
    function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
            CFrame.new(-5.61629915, -6.39999771, 5.7047925)
    end
)
local controlroom =
    Teleports:Button(
    "Control Room",
    function()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
            game:GetService("Workspace").Level.Geometry.HackableComputer.Screen.CFrame
    end
)
local screwdriverroom =
    Teleports:Button(
    "Screwdriver Room",
    function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(17.5797043, 12.6000395, 11.2429724)
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
        print("Successfully loaded using Arch!")
    end
end
if getgenv().console == true then
    if is_synapse_function or KRNL_LOADED or IS_ARCH then
        rconsoleclear()
        rconsoleprint("@@WHITE@@")
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
    if IS_ARCH then
        rconsoleprint("\n")
        rconsoleprint [==[
                   _       ______    _ _ _   _             
    /\            | |     |  ____|  | (_) | (_)            
   /  \   _ __ ___| |__   | |__   __| |_| |_ _  ___  _ __  
  / /\ \ | '__/ __| '_ \  |  __| / _` | | __| |/ _ \| '_ \ 
 / ____ \| | | (__| | | | | |___| (_| | | |_| | (_) | | | |
/_/    \_\_|  \___|_| |_| |______\__,_|_|\__|_|\___/|_| |_|

    ]==]
    end
else
    if getgenv().console == false then
        print("EntryPointHaxx v1 successfully loaded!")
    end
end
print("Credits go to Unsourced Pyramid, Yes, JasonJJK, walmort and more!")
