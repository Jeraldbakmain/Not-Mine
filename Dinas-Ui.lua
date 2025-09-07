local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local Library = {}
Library.__index = Library

local colors = {
    background = Color3.fromRGB(20, 20, 30),
    surface = Color3.fromRGB(30, 30, 45),
    primary = Color3.fromRGB(100, 70, 200),
    secondary = Color3.fromRGB(70, 130, 230),
    accent = Color3.fromRGB(0, 200, 220),
    text = Color3.fromRGB(240, 240, 250),
    textSecondary = Color3.fromRGB(180, 180, 200),
    success = Color3.fromRGB(90, 200, 120),
    warning = Color3.fromRGB(230, 170, 50),
    error = Color3.fromRGB(220, 80, 80)
}

local FONT_REGULAR = Enum.Font.ArimoBold
local FONT_ICONS = Enum.Font.ArimoBold

local function createTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function HSVToRGB(h, s, v)
    h = h % 1
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    if i == 0 then
        return Color3.new(v, t, p)
    elseif i == 1 then
        return Color3.new(q, v, p)
    elseif i == 2 then
        return Color3.new(p, v, t)
    elseif i == 3 then
        return Color3.new(p, q, v)
    elseif i == 4 then
        return Color3.new(t, p, v)
    else
        return Color3.new(v, p, q)
    end
end

local function RGBToHSV(r, g, b)
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, v
    
    v = max
    
    local d = max - min
    if max == 0 then
        s = 0
    else
        s = d / max
    end
    
    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d
            if g < b then
                h = h + 6
            end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    
    return h, s, v
end

    function Library:CreateWindow(title)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomLib"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 600, 0, 35)

local function updateMainFrameSize()
    local screenSize = screenGui.AbsoluteSize
    local width = math.clamp(screenSize.X * 0.7, 300, 600)
    local height = math.clamp(screenSize.Y * 0.7, 200, 500)

    mainFrame.Size = UDim2.new(0, width, 0, height)
end

updateMainFrameSize()

screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateMainFrameSize)

mainFrame.BackgroundTransparency = 1
createTween(mainFrame, {BackgroundTransparency = 0}, 0.5)

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStroke.Color = colors.primary
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.7
    uiStroke.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = colors.surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = colors.text
    titleText.TextSize = 16
    titleText.Font = FONT_REGULAR
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 35, 1, 0)
    minimizeButton.Position = UDim2.new(1, -70, 0, 0)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Text = "─"
    minimizeButton.TextColor3 = colors.textSecondary
    minimizeButton.TextSize = 18
    minimizeButton.Font = FONT_REGULAR
    minimizeButton.Parent = titleBar

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 35, 1, 0)
    closeButton.Position = UDim2.new(1, -35, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = colors.textSecondary
    closeButton.TextSize = 20
    closeButton.Font = FONT_REGULAR
    closeButton.Parent = titleBar

    local tabButtonsFrame = Instance.new("ScrollingFrame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(0, 160, 1, -35)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 35)
    tabButtonsFrame.BackgroundColor3 = colors.surface
    tabButtonsFrame.BorderSizePixel = 0
    tabButtonsFrame.ScrollBarThickness = 0
    tabButtonsFrame.Parent = mainFrame

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -160, 1, -35)
    contentFrame.Position = UDim2.new(0, 160, 0, 35)
    contentFrame.BackgroundColor3 = colors.background
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    closeButton.MouseButton1Click:Connect(function()
        createTween(mainFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, 600, 0, 0)}, 0.5)
        wait(0.5)
        screenGui:Destroy()
    end)

    local tabsListLayout = Instance.new("UIListLayout")
    tabsListLayout.Name = "TabsListLayout"
    tabsListLayout.Padding = UDim.new(0, 8)
    tabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsListLayout.Parent = tabButtonsFrame

    tabsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, tabsListLayout.AbsoluteContentSize.Y + 20)
    end)

    local tabs = {}
    local currentTab = nil
    local isMinimized = true

    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            createTween(mainFrame, {Size = UDim2.new(0, 600, 0, 35)}, 0.3)
            minimizeButton.Text = "+"
            tabButtonsFrame.Visible = false
            contentFrame.Visible = false
        else
            createTween(mainFrame, {Size = UDim2.new(0, 600, 0, 430)}, 0.3) 
            minimizeButton.Text = "─"
            tabButtonsFrame.Visible = true
            contentFrame.Visible = true
        end
    end)

    local window = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TabButtonsFrame = tabButtonsFrame,
        ContentFrame = contentFrame,
        Tabs = tabs,
        IsMinimized = isMinimized
    }

    setmetatable(window, Library)

    local function adaptForDevice()
    if UserInputService.TouchEnabled then
        mainFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        titleText.TextSize = 18
        minimizeButton.TextSize = 22
        closeButton.TextSize = 24
        
        minimizeButton.Size = UDim2.new(0, 50, 1, 0)
        closeButton.Size = UDim2.new(0, 50, 1, 0)
        closeButton.Position = UDim2.new(1, -50, 0, 0)
        minimizeButton.Position = UDim2.new(1, -100, 0, 0)
    else
        updateMainFrameSize()
        
        titleText.TextSize = 14
        minimizeButton.TextSize = 16
        closeButton.TextSize = 18
        
        minimizeButton.Size = UDim2.new(0, 30, 1, 0)
        closeButton.Size = UDim2.new(0, 30, 1, 0)
        closeButton.Position = UDim2.new(1, -30, 0, 0)
        minimizeButton.Position = UDim2.new(1, -60, 0, 0)
    end
end

adaptForDevice()

UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(adaptForDevice)

    local dragging = false
    local dragInput, dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return window
end

function Library:AddTab(name, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "TabButton"
    tabButton.Size = UDim2.new(1, -20, 0, 45)
    tabButton.Position = UDim2.new(0, 10, 0, 10 + (#self.Tabs * 53))
    tabButton.BackgroundColor3 = colors.surface
    tabButton.BorderSizePixel = 0
    tabButton.Text = "  " .. icon .. "  " .. name
    tabButton.TextColor3 = colors.textSecondary
    tabButton.TextSize = 14
    tabButton.Font = FONT_REGULAR
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Parent = self.TabButtonsFrame
    tabButton.LayoutOrder = #self.Tabs + 1
    tabButton.AutoButtonColor = false

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = tabButton

    local tabHighlight = Instance.new("Frame")
    tabHighlight.Name = "Highlight"
    tabHighlight.Size = UDim2.new(0, 4, 1, -10)
    tabHighlight.Position = UDim2.new(0, -4, 0, 5)
    tabHighlight.BackgroundColor3 = colors.primary
    tabHighlight.BorderSizePixel = 0
    tabHighlight.Visible = false
    tabHighlight.Parent = tabButton

    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(0, 2)
    highlightCorner.Parent = tabHighlight

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.BackgroundColor3 = colors.background
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = colors.textSecondary
    tabContent.Visible = false
    tabContent.Parent = self.ContentFrame

    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = tabContent
    contentPadding.PaddingLeft = UDim.new(0, 15)
    contentPadding.PaddingTop = UDim.new(0, 15)
    contentPadding.PaddingRight = UDim.new(0, 10)

    local contentListLayout = Instance.new("UIListLayout")
    contentListLayout.Name = "ContentListLayout"
    contentListLayout.Padding = UDim.new(0, 15)
    contentListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentListLayout.Parent = tabContent

    contentListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentListLayout.AbsoluteContentSize.Y + 15)
    end)

    local tab = {
        Name = name,
        Button = tabButton,
        Content = tabContent,
        Elements = {},
        Highlight = tabHighlight
    }

    table.insert(self.Tabs, tab)

    tabButton.MouseEnter:Connect(function()
        if currentTab ~= tab then
            createTween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
            createTween(tabButton, {TextColor3 = colors.text}, 0.2)
        end
    end)

    tabButton.MouseLeave:Connect(function()
        if currentTab ~= tab then
            createTween(tabButton, {BackgroundColor3 = colors.surface}, 0.2)
            createTween(tabButton, {TextColor3 = colors.textSecondary}, 0.2)
        end
    end)

    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)

    if #self.Tabs == 1 then
        self:SwitchTab(tab)
    end

    return tab
end

function Library:SwitchTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Content.Visible = false
        createTween(t.Button, {BackgroundColor3 = colors.surface}, 0.2)
        createTween(t.Button, {TextColor3 = colors.textSecondary}, 0.2)
        t.Highlight.Visible = false
    end

    tab.Content.Visible = true
    createTween(tab.Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
    createTween(tab.Button, {TextColor3 = colors.text}, 0.2)
    tab.Highlight.Visible = true
    
    currentTab = tab
end

function Library:AddButton(tab, name, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 45)
    button.BackgroundColor3 = colors.surface
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = colors.text
    button.TextSize = 14
    button.Font = FONT_REGULAR
    button.Parent = tab.Content
    button.LayoutOrder = #tab.Elements + 1
    button.AutoButtonColor = false
    button.Visible = true

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = button

    local buttonHighlight = Instance.new("Frame")
    buttonHighlight.Name = "Highlight"
    buttonHighlight.Size = UDim2.new(1, 0, 1, 0)
    buttonHighlight.Position = UDim2.new(0, 0, 0, 0)
    buttonHighlight.BackgroundColor3 = colors.primary
    buttonHighlight.BackgroundTransparency = 1
    buttonHighlight.BorderSizePixel = 0
    buttonHighlight.ZIndex = -1
    buttonHighlight.Parent = button

    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(0, 8)
    highlightCorner.Parent = buttonHighlight

    button.MouseEnter:Connect(function()
        createTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}, 0.2)
        createTween(buttonHighlight, {BackgroundTransparency = 0.9}, 0.2)
    end)

    button.MouseLeave:Connect(function()
        createTween(button, {BackgroundColor3 = colors.surface}, 0.2)
        createTween(buttonHighlight, {BackgroundTransparency = 1}, 0.2)
    end)

    button.MouseButton1Down:Connect(function()
        createTween(button, {Size = UDim2.new(1, -25, 0, 42)}, 0.1)
        createTween(button, {BackgroundColor3 = colors.primary}, 0.1)
    end)

    button.MouseButton1Up:Connect(function()
        createTween(button, {Size = UDim2.new(1, -20, 0, 45)}, 0.1)
        createTween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}, 0.1)
    end)

    button.MouseButton1Click:Connect(function()
        createTween(buttonHighlight, {BackgroundTransparency = 0.7}, 0.1)
        wait(0.1)
        createTween(buttonHighlight, {BackgroundTransparency = 0.9}, 0.3)
        callback()
    end)

    table.insert(tab.Elements, button)
    return button
end

function Library:AddToggle(tab, name, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = tab.Content
    toggleFrame.LayoutOrder = #tab.Elements + 1
    toggleFrame.Visible = true

    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "Text"
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 0, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = name
    toggleText.TextColor3 = colors.text
    toggleText.TextSize = 14
    toggleText.Font = FONT_REGULAR
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -12)
    toggleButton.BackgroundColor3 = colors.surface
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    toggleButton.AutoButtonColor = false

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton

    local toggleDot = Instance.new("Frame")
    toggleDot.Name = "Dot"
    toggleDot.Size = UDim2.new(0, 21, 0, 21)
    toggleDot.Position = UDim2.new(0, 2, 0, 2)
    toggleDot.BackgroundColor3 = colors.text
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleButton

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 10)
    dotCorner.Parent = toggleDot

    local isToggled = false

    local function updateToggle()
        if isToggled then
            createTween(toggleButton, {BackgroundColor3 = colors.primary}, 0.2)
            createTween(toggleDot, {Position = UDim2.new(0, 27, 0, 2)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            createTween(toggleButton, {BackgroundColor3 = colors.surface}, 0.2)
            createTween(toggleDot, {Position = UDim2.new(0, 2, 0, 2)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
        callback(isToggled)
    end

    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
    end)

    toggleButton.MouseEnter:Connect(function()
        createTween(toggleButton, {BackgroundColor3 = isToggled and Color3.fromRGB(110, 80, 210) or Color3.fromRGB(50, 50, 65)}, 0.2)
    end)

    toggleButton.MouseLeave:Connect(function()
        createTween(toggleButton, {BackgroundColor3 = isToggled and colors.primary or colors.surface}, 0.2)
    end)

    table.insert(tab.Elements, toggleFrame)
    return toggleFrame
end

function Library:AddSlider(tab, name, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = tab.Content
    sliderFrame.LayoutOrder = #tab.Elements + 1
    sliderFrame.Visible = true

    local sliderText = Instance.new("TextLabel")
    sliderText.Name = "Text"
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.Position = UDim2.new(0, 0, 0, 0)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = name .. ": " .. defaultValue
    sliderText.TextColor3 = colors.text
    sliderText.TextSize = 14
    sliderText.Font = FONT_REGULAR
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Parent = sliderFrame

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, 0, 0, 6)
    sliderTrack.Position = UDim2.new(0, 0, 0, 35)
    sliderTrack.BackgroundColor3 = colors.surface
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = sliderTrack

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = colors.primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 18, 0, 18)
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -9, 0.5, -9)
    sliderButton.BackgroundColor3 = colors.text
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    sliderButton.AutoButtonColor = false

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 9)
    buttonCorner.Parent = sliderButton

    local isSliding = false
    local currentValue = defaultValue

    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = math.floor(value)
        sliderText.Text = name .. ": " .. currentValue
        createTween(sliderFill, {Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)}, 0.1)
        createTween(sliderButton, {Position = UDim2.new((currentValue - min) / (max - min), -9, 0.5, -9)}, 0.1)
        callback(currentValue)
    end

    local function onInputChanged(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local inputPosition
            if input.UserInputType == Enum.UserInputType.Touch then
                inputPosition = input.Position
            else
                inputPosition = UserInputService:GetMouseLocation()
            end
            
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            local relativeX = (inputPosition.X - trackPos.X) / trackSize.X
            local value = min + (max - min) * math.clamp(relativeX, 0, 1)
            updateSlider(value)
        end
    end

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            createTween(sliderButton, {Size = UDim2.new(0, 22, 0, 22)}, 0.1)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isSliding then
                isSliding = false
                createTween(sliderButton, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
            end
        end
    end)

    UserInputService.InputChanged:Connect(onInputChanged)

    sliderButton.MouseEnter:Connect(function()
        createTween(sliderButton, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
    end)

    sliderButton.MouseLeave:Connect(function()
        if not isSliding then
            createTween(sliderButton, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
        end
    end)

    table.insert(tab.Elements, sliderFrame)
    return sliderFrame
end

function Library:AddLabel(tab, text, icon)
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "LabelFrame"
    labelFrame.Size = UDim2.new(1, -20, 0, 30)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = tab.Content
    labelFrame.LayoutOrder = #tab.Elements + 1
    labelFrame.Visible = true

    local labelText = Instance.new("TextLabel")
    labelText.Name = "LabelText"
    labelText.Size = UDim2.new(1, 0, 1, 0)
    labelText.Position = UDim2.new(0, 0, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = icon and ("  " .. icon .. "  " .. text) or text
    labelText.TextColor3 = colors.textSecondary
    labelText.TextSize = 14
    labelText.Font = FONT_REGULAR
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = labelFrame

    table.insert(tab.Elements, labelFrame)
    return labelFrame
end

function Library:AddParagraph(tab, text, icon)
    local paragraphFrame = Instance.new("Frame")
    paragraphFrame.Name = "ParagraphFrame"
    paragraphFrame.BackgroundTransparency = 1
    paragraphFrame.LayoutOrder = #tab.Elements + 1
    paragraphFrame.Visible = true
    paragraphFrame.Size = UDim2.new(1, 0, 0, 0)
    paragraphFrame.Parent = tab.Content

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ParagraphText"
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = colors.textSecondary
    textLabel.TextSize = 13
    textLabel.Font = FONT_REGULAR
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Text = icon and ("  " .. icon .. "  " .. text) or text
    textLabel.Size = UDim2.new(1, 0, 0, 0)
    textLabel.Position = UDim2.new(0,0,0,0)
    textLabel.Parent = paragraphFrame

    local padding = 20

    local function updateSize()
        if paragraphFrame.AbsoluteSize.X == 0 then return end

        local maxWidth = paragraphFrame.AbsoluteSize.X - padding
        local textSize = TextService:GetTextSize(
            textLabel.Text,
            textLabel.TextSize,
            textLabel.Font,
            Vector2.new(maxWidth, math.huge)
        )
        textLabel.Size = UDim2.new(1, -padding, 0, textSize.Y)
        paragraphFrame.Size = UDim2.new(1, 0, 0, textSize.Y)
    end

    paragraphFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
    textLabel:GetPropertyChangedSignal("Text"):Connect(updateSize)

    task.defer(updateSize)

    table.insert(tab.Elements, paragraphFrame)
    return paragraphFrame
end

function Library:AddDropdown(tab, name, options, defaultOption, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = name .. "DropdownFrame"
    dropdownFrame.Size = UDim2.new(1, -20, 0, 40)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = tab.Content
    dropdownFrame.LayoutOrder = #tab.Elements + 1
    dropdownFrame.Visible = true

    local dropdownText = Instance.new("TextLabel")
    dropdownText.Name = "Text"
    dropdownText.Size = UDim2.new(0.7, 0, 1, 0)
    dropdownText.Position = UDim2.new(0, 0, 0, 0)
    dropdownText.BackgroundTransparency = 1
    dropdownText.Text = name
    dropdownText.TextColor3 = colors.text
    dropdownText.TextSize = 14
    dropdownText.Font = FONT_REGULAR
    dropdownText.TextXAlignment = Enum.TextXAlignment.Left
    dropdownText.Parent = dropdownFrame

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(0.3, 0, 1, 0)
    dropdownButton.Position = UDim2.new(0.7, 0, 0, 0)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = defaultOption or "Select..."
    dropdownButton.TextColor3 = colors.text
    dropdownButton.TextSize = 13
    dropdownButton.Font = FONT_REGULAR
    dropdownButton.Parent = dropdownFrame

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownButton

    local dropdownIcon = Instance.new("TextLabel")
    dropdownIcon.Name = "Icon"
    dropdownIcon.Size = UDim2.new(0, 20, 1, 0)
    dropdownIcon.Position = UDim2.new(1, -20, 0, 0)
    dropdownIcon.BackgroundTransparency = 1
    dropdownIcon.Text = "▼"
    dropdownIcon.TextColor3 = colors.textSecondary
    dropdownIcon.TextSize = 12
    dropdownIcon.Font = FONT_REGULAR
    dropdownIcon.Parent = dropdownButton

    local screenGui = self.ScreenGui or game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("CustomLib")
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Name = "DropdownList"
    dropdownList.Size = UDim2.new(0, 0, 0, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    dropdownList.BorderSizePixel = 0
    dropdownList.ScrollBarThickness = 6
    dropdownList.ScrollBarImageColor3 = colors.textSecondary
    dropdownList.Visible = false
    dropdownList.ZIndex = 100
    dropdownList.Parent = screenGui

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = dropdownList

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropdownList
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)

    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    listPadding.Parent = dropdownList

    local isOpen = false
    local selectedOption = defaultOption
    local renderConnection

    local function updateDropdownPosition()
        if isOpen then
            local buttonAbsolutePos = dropdownButton.AbsolutePosition
            local buttonAbsoluteSize = dropdownButton.AbsoluteSize
            
            dropdownList.Position = UDim2.new(
                0, buttonAbsolutePos.X,
                0, buttonAbsolutePos.Y + buttonAbsoluteSize.Y + 5
            )
            
            dropdownList.Size = UDim2.new(0, buttonAbsoluteSize.X, 0, dropdownList.AbsoluteSize.Y)
        end
    end

    local function updateListSize()
        if not isOpen then return end
        
        local contentHeight = listLayout.AbsoluteContentSize.Y + 10
        local maxHeight = math.min(contentHeight, 200)
        
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        
        dropdownList.Size = UDim2.new(dropdownList.Size.X.Scale, dropdownList.Size.X.Offset, 0, maxHeight)
        
        updateDropdownPosition()
    end

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateListSize)

    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            updateListSize()
            
            dropdownList.Visible = true
            dropdownIcon.Text = "▲"
            
            if not renderConnection then
                renderConnection = RunService.RenderStepped:Connect(updateDropdownPosition)
            end
        else
            dropdownList.Visible = false
            dropdownIcon.Text = "▼"
            
            if renderConnection then
                renderConnection:Disconnect()
                renderConnection = nil
            end
        end
    end

    local function selectOption(option)
        selectedOption = option
        dropdownButton.Text = option
        toggleDropdown()
        callback(option)
    end

    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option .. "Option"
        optionButton.Size = UDim2.new(1, -10, 0, 30)
        optionButton.BackgroundColor3 = colors.surface
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = colors.text
        optionButton.TextSize = 13
        optionButton.Font = FONT_REGULAR
        optionButton.ZIndex = 101
        optionButton.Parent = dropdownList

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton

        optionButton.MouseButton1Click:Connect(function()
            selectOption(option)
        end)

        optionButton.MouseEnter:Connect(function()
            createTween(optionButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}, 0.2)
        end)

        optionButton.MouseLeave:Connect(function()
            createTween(optionButton, {BackgroundColor3 = colors.surface}, 0.2)
        end)
    end

    dropdownButton.MouseButton1Click:Connect(toggleDropdown)

    local function closeDropdown(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local dropdownPos = dropdownList.AbsolutePosition
            local dropdownSize = dropdownList.AbsoluteSize
            
            local isClickInsideDropdown = 
                mousePos.X >= dropdownPos.X and 
                mousePos.X <= dropdownPos.X + dropdownSize.X and
                mousePos.Y >= dropdownPos.Y and 
                mousePos.Y <= dropdownPos.Y + dropdownSize.Y
                
            local isClickOnButton = 
                mousePos.X >= dropdownButton.AbsolutePosition.X and 
                mousePos.X <= dropdownButton.AbsolutePosition.X + dropdownButton.AbsoluteSize.X and
                mousePos.Y >= dropdownButton.AbsolutePosition.Y and 
                mousePos.Y <= dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y
            
            if not isClickInsideDropdown and not isClickOnButton then
                toggleDropdown()
            end
        end
    end

    UserInputService.InputBegan:Connect(closeDropdown)

    dropdownFrame.Destroying:Connect(function()
        if renderConnection then
            renderConnection:Disconnect()
        end
        dropdownList:Destroy()
    end)

    table.insert(tab.Elements, dropdownFrame)
    return dropdownFrame
end

function Library:AddColorPicker(tab, name, defaultColor, callback)
    local screenGui = self.ScreenGui or game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("CustomLib")
   
    local colorPickerFrame = Instance.new("Frame")
colorPickerFrame.Name = name .. "ColorPicker"
colorPickerFrame.Size = UDim2.new(1, -20, 0, 40)
colorPickerFrame.BackgroundTransparency = 1
colorPickerFrame.Parent = tab.Content
colorPickerFrame.LayoutOrder = #tab.Elements + 1
colorPickerFrame.Visible = true

    local colorPickerText = Instance.new("TextLabel")
    colorPickerText.Name = "Text"
    colorPickerText.Size = UDim2.new(0.7, 0, 1, 0)
    colorPickerText.Position = UDim2.new(0, 0, 0, 0)
    colorPickerText.BackgroundTransparency = 1
    colorPickerText.Text = name
    colorPickerText.TextColor3 = colors.text
    colorPickerText.TextSize = 14
    colorPickerText.Font = FONT_REGULAR
    colorPickerText.TextXAlignment = Enum.TextXAlignment.Left
    colorPickerText.Parent = colorPickerFrame

    local colorButton = Instance.new("TextButton")
    colorButton.Name = "ColorButton"
    colorButton.Size = UDim2.new(0.1, 0, 0.6, 0)
    colorButton.Position = UDim2.new(0.8, 0, 0.2, 0)
    colorButton.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 0, 0)
    colorButton.BorderSizePixel = 0
    colorButton.Text = ""
    colorButton.AutoButtonColor = false
    colorButton.Parent = colorPickerFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = colorButton

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    buttonStroke.Color = colors.textSecondary
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.5
    buttonStroke.Parent = colorButton

    local function createColorPickerPopup()
        local popup = Instance.new("Frame")
        popup.Name = "ColorPickerPopup"
        popup.Size = UDim2.new(0, 300, 0, 320)
        popup.Position = UDim2.new(0.5, -150, 0.5, -160)
        popup.AnchorPoint = Vector2.new(0.5, 0.5)
        popup.BackgroundColor3 = colors.surface
        popup.BorderSizePixel = 0
        popup.ZIndex = 100
        popup.Parent = screenGui

        local popupCorner = Instance.new("UICorner")
        popupCorner.CornerRadius = UDim.new(0, 12)
        popupCorner.Parent = popup

        local popupStroke = Instance.new("UIStroke")
        popupStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        popupStroke.Color = colors.primary
        popupStroke.Thickness = 2
        popupStroke.Transparency = 0.7
        popupStroke.Parent = popup

        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 30)
        titleBar.Position = UDim2.new(0, 0, 0, 0)
        titleBar.BackgroundColor3 = colors.background
        titleBar.BorderSizePixel = 0
        titleBar.ZIndex = 101
        titleBar.Parent = popup
        
local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    popup.Position = newPos
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = popup.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

        local titleText = Instance.new("TextLabel")
        titleText.Name = "TitleText"
        titleText.Size = UDim2.new(1, -40, 1, 0)
        titleText.Position = UDim2.new(0, 10, 0, 0)
        titleText.BackgroundTransparency = 1
        titleText.Text = name
        titleText.TextColor3 = colors.text
        titleText.TextSize = 14
        titleText.Font = FONT_REGULAR
        titleText.TextXAlignment = Enum.TextXAlignment.Left
        titleText.ZIndex = 102
        titleText.Parent = titleBar

        local closeButton = Instance.new("TextButton")
        closeButton.Name = "CloseButton"
        closeButton.Size = UDim2.new(0, 30, 1, 0)
        closeButton.Position = UDim2.new(1, -30, 0, 0)
        closeButton.BackgroundTransparency = 1
        closeButton.Text = "×"
        closeButton.TextColor3 = colors.textSecondary
        closeButton.TextSize = 18
        closeButton.Font = FONT_REGULAR
        closeButton.ZIndex = 102
        closeButton.Parent = titleBar

        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "ContentFrame"
        contentFrame.Size = UDim2.new(1, -20, 1, -45)
        contentFrame.Position = UDim2.new(0, 10, 0, 35)
        contentFrame.BackgroundTransparency = 1
        contentFrame.ZIndex = 101
        contentFrame.Parent = popup

        local hsPickerFrame = Instance.new("Frame")
        hsPickerFrame.Name = "HSPicker"
        hsPickerFrame.Size = UDim2.new(1, 0, 0, 150)
        hsPickerFrame.Position = UDim2.new(0, 0, 0, 0)
        hsPickerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hsPickerFrame.BorderSizePixel = 0
        hsPickerFrame.ZIndex = 102
        hsPickerFrame.Parent = contentFrame

        local hsPickerCorner = Instance.new("UICorner")
        hsPickerCorner.CornerRadius = UDim.new(0, 6)
        hsPickerCorner.Parent = hsPickerFrame

        local marker = Instance.new("Frame")
        marker.Name = "Marker"
        marker.Size = UDim2.new(0, 10, 0, 10)
        marker.Position = UDim2.new(0.5, -5, 0.5, -5)
        marker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        marker.BorderSizePixel = 2
        marker.BorderColor3 = Color3.fromRGB(0, 0, 0)
        marker.ZIndex = 104
        marker.Parent = hsPickerFrame

        local markerCorner = Instance.new("UICorner")
        markerCorner.CornerRadius = UDim.new(0, 5)
        markerCorner.Parent = marker

        local hueSliderFrame = Instance.new("Frame")
        hueSliderFrame.Name = "HueSliderFrame"
        hueSliderFrame.Size = UDim2.new(1, 0, 0, 20)
        hueSliderFrame.Position = UDim2.new(0, 0, 0, 160)
        hueSliderFrame.BackgroundTransparency = 1
        hueSliderFrame.ZIndex = 102
        hueSliderFrame.Parent = contentFrame

        local hueSlider = Instance.new("Frame")
        hueSlider.Name = "HueSlider"
        hueSlider.Size = UDim2.new(1, 0, 0, 6)
        hueSlider.Position = UDim2.new(0, 0, 0.5, -3)
        hueSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        hueSlider.BorderSizePixel = 0
        hueSlider.ZIndex = 103
        hueSlider.Parent = hueSliderFrame

        local hueSliderCorner = Instance.new("UICorner")
        hueSliderCorner.CornerRadius = UDim.new(0, 3)
        hueSliderCorner.Parent = hueSlider

        local hueGradient = Instance.new("UIGradient")
        hueGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
        }
        hueGradient.Rotation = 0
        hueGradient.Parent = hueSlider

        local hueButton = Instance.new("TextButton")
        hueButton.Name = "HueButton"
        hueButton.Size = UDim2.new(0, 14, 0, 14)
        hueButton.Position = UDim2.new(0.5, -7, 0.5, -7)
        hueButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueButton.BorderSizePixel = 2
        hueButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        hueButton.Text = ""
        hueButton.ZIndex = 105
        hueButton.AutoButtonColor = false
        hueButton.Parent = hueSlider

        local hueButtonCorner = Instance.new("UICorner")
        hueButtonCorner.CornerRadius = UDim.new(0, 7)
        hueButtonCorner.Parent = hueButton

        local currentColorFrame = Instance.new("Frame")
        currentColorFrame.Name = "CurrentColorFrame"
        currentColorFrame.Size = UDim2.new(1, 0, 0, 30)
        currentColorFrame.Position = UDim2.new(0, 0, 0, 190)
        currentColorFrame.BackgroundTransparency = 1
        currentColorFrame.ZIndex = 102
        currentColorFrame.Parent = contentFrame

        local currentColorBox = Instance.new("Frame")
        currentColorBox.Name = "CurrentColorBox"
        currentColorBox.Size = UDim2.new(0, 30, 0, 30)
        currentColorBox.Position = UDim2.new(0, 0, 0, 0)
        currentColorBox.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 0, 0)
        currentColorBox.BorderSizePixel = 0
        currentColorBox.ZIndex = 103
        currentColorBox.Parent = currentColorFrame

        local currentColorBoxCorner = Instance.new("UICorner")
        currentColorBoxCorner.CornerRadius = UDim.new(0, 6)
        currentColorBoxCorner.Parent = currentColorBox

        local currentColorBoxStroke = Instance.new("UIStroke")
        currentColorBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        currentColorBoxStroke.Color = colors.textSecondary
        currentColorBoxStroke.Thickness = 1
        currentColorBoxStroke.Transparency = 0.5
        currentColorBoxStroke.Parent = currentColorBox

        local rgbText = Instance.new("TextLabel")
        rgbText.Name = "RGBText"
        rgbText.Size = UDim2.new(0.7, 0, 0.5, 0)
        rgbText.Position = UDim2.new(0, 35, 0, 0)
        rgbText.BackgroundTransparency = 1
        rgbText.Text = "RGB: 255, 0, 0"
        rgbText.TextColor3 = colors.text
        rgbText.TextSize = 11
        rgbText.Font = FONT_REGULAR
        rgbText.TextXAlignment = Enum.TextXAlignment.Left
        rgbText.ZIndex = 103
        rgbText.Parent = currentColorFrame

        local hexText = Instance.new("TextLabel")
        hexText.Name = "HexText"
        hexText.Size = UDim2.new(0.7, 0, 0.5, 0)
        hexText.Position = UDim2.new(0, 35, 0, 15)
        hexText.BackgroundTransparency = 1
        hexText.Text = "HEX: #FF0000"
        hexText.TextColor3 = colors.text
        hexText.TextSize = 11
        hexText.Font = FONT_REGULAR
        hexText.TextXAlignment = Enum.TextXAlignment.Left
        hexText.ZIndex = 103
        hexText.Parent = currentColorFrame

        local confirmButton = Instance.new("TextButton")
        confirmButton.Name = "ConfirmButton"
        confirmButton.Size = UDim2.new(1, 0, 0, 30)
        confirmButton.Position = UDim2.new(0, 0, 0, 230)
        confirmButton.BackgroundColor3 = colors.primary
        confirmButton.BorderSizePixel = 0
        confirmButton.Text = "Apply"
        confirmButton.TextColor3 = colors.text
        confirmButton.TextSize = 14
        confirmButton.Font = FONT_REGULAR
        confirmButton.ZIndex = 102
        confirmButton.AutoButtonColor = false
        confirmButton.Parent = contentFrame

        local confirmButtonCorner = Instance.new("UICorner")
        confirmButtonCorner.CornerRadius = UDim.new(0, 6)
        confirmButtonCorner.Parent = confirmButton
        
        local currentHue = 0
        local currentSaturation = 1
        local currentValue = 1
        local selectedColor = defaultColor or Color3.fromRGB(255, 0, 0)

        local function RGBToHex(color)
            return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
        end

        local function updateColor()
            selectedColor = Color3.fromHSV(currentHue, currentSaturation, currentValue)
            
            local xPos = currentSaturation
            local yPos = 1 - currentValue
            marker.Position = UDim2.new(xPos, -5, yPos, -5)
            
            hueButton.Position = UDim2.new(currentHue, -7, 0.5, -7)
            
            currentColorBox.BackgroundColor3 = selectedColor
            rgbText.Text = "RGB: " .. math.floor(selectedColor.R * 255) .. ", " .. math.floor(selectedColor.G * 255) .. ", " .. math.floor(selectedColor.B * 255)
            hexText.Text = "HEX: " .. RGBToHex(selectedColor)
            
            colorButton.BackgroundColor3 = selectedColor
            
            callback(selectedColor)
            
            local baseColor = Color3.fromHSV(currentHue, 1, 1)
            hsPickerFrame.BackgroundColor3 = baseColor
        end

        local function updateColorFromHS(input)
            local absolutePosition = hsPickerFrame.AbsolutePosition
            local absoluteSize = hsPickerFrame.AbsoluteSize
            
            local x = math.clamp((input.Position.X - absolutePosition.X) / absoluteSize.X, 0, 1)
            local y = math.clamp((input.Position.Y - absolutePosition.Y) / absoluteSize.Y, 0, 1)
            
            currentSaturation = x
            currentValue = 1 - y
            
            updateColor()
        end

        local function updateHue(input)
            local absolutePosition = hueSlider.AbsolutePosition
            local absoluteSize = hueSlider.AbsoluteSize
            
            local x = math.clamp((input.Position.X - absolutePosition.X) / absoluteSize.X, 0, 1)
            currentHue = x
            
            updateColor()
        end

        local hsDragging = false
        
        hsPickerFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hsDragging = true
                updateColorFromHS(input)
            end
        end)
        
        hsPickerFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hsDragging = false
            end
        end)
        
        hsPickerFrame.InputChanged:Connect(function(input)
            if hsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateColorFromHS(input)
            end
        end)

        local hueDragging = false
        
        hueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDragging = true
                updateHue(input)
            end
        end)
        
        hueSlider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDragging = false
            end
        end)
        
        hueSlider.InputChanged:Connect(function(input)
            if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateHue(input)
            end
        end)

        closeButton.MouseButton1Click:Connect(function()
            popup:Destroy()
        end)
        
        confirmButton.MouseButton1Click:Connect(function()
            popup:Destroy()
        end)
        
        if UserInputService.TouchEnabled then
            closeButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    popup:Destroy()
                end
            end)
            
            confirmButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    popup:Destroy()
                end
            end)
        end

        popup.BackgroundTransparency = 1
        createTween(popup, {BackgroundTransparency = 0}, 0.3)

        if defaultColor then
            local h, s, v = defaultColor:ToHSV()
            currentHue = h
            currentSaturation = s
            currentValue = v
            updateColor()
        end
    end

    colorButton.MouseButton1Click:Connect(createColorPickerPopup)

    colorButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            createColorPickerPopup()
        end
    end)

    table.insert(tab.Elements, colorPickerFrame)
    return colorPickerFrame
end

function Library:EnableRainbowCorners()
    if self.RainbowCorners then return end
    
    self.RainbowCorners = true
    local hue = 0
    
    local corners = {}
    
    table.insert(corners, self.MainFrame:FindFirstChildOfClass("UICorner"))
    
    for _, tab in ipairs(self.Tabs) do
        if tab.Button:FindFirstChildOfClass("UICorner") then
            table.insert(corners, tab.Button:FindFirstChildOfClass("UICorner"))
        end
        
        for _, element in ipairs(tab.Elements) do
            local corner = element:FindFirstChildOfClass("UICorner")
            if corner then
                table.insert(corners, corner)
            end
        end
    end
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not self.RainbowCorners then
            connection:Disconnect()
            return
        end
        
        hue = (hue + 0.005) % 1
        local color = HSVToRGB(hue, 1, 1)
        
        for _, corner in ipairs(corners) do
            if corner then
                corner.CornerRadius = UDim.new(0, 8 + math.sin(tick() * 2) * 2)
            end
        end
        
        local stroke = self.MainFrame:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = color
        end
    end)
end

function Library:DisableRainbowCorners()
    self.RainbowCorners = false
    
    local corners = {}
    
    local mainCorner = self.MainFrame:FindFirstChildOfClass("UICorner")
    if mainCorner then
        mainCorner.CornerRadius = UDim.new(0, 12)
    end
    
    for _, tab in ipairs(self.Tabs) do
        local tabCorner = tab.Button:FindFirstChildOfClass("UICorner")
        if tabCorner then
            tabCorner.CornerRadius = UDim.new(0, 8)
        end
        
        for _, element in ipairs(tab.Elements) do
            local corner = element:FindFirstChildOfClass("UICorner")
            if corner then
                corner.CornerRadius = UDim.new(0, 8)
            end
        end
    end
    
    local stroke = self.MainFrame:FindFirstChildOfClass("UIStroke")
    if stroke then
        stroke.Color = colors.primary
    end
end

function Library:Notification(title, message, duration, notifType)
    local screenGui = self.ScreenGui or game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("CustomLib")
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification"
    notificationFrame.Size = UDim2.new(0, 300, 0, 80)
    notificationFrame.Position = UDim2.new(1, -320, 1, -100)
    notificationFrame.BackgroundColor3 = colors.surface
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 100
    notificationFrame.Parent = screenGui

    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 8)
    notificationCorner.Parent = notificationFrame

    local notificationStroke = Instance.new("UIStroke")
    notificationStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    notificationStroke.Color = colors.primary
    notificationStroke.Thickness = 2
    notificationStroke.Transparency = 0.7
    notificationStroke.Parent = notificationFrame

    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -10, 0, 20)
    titleText.Position = UDim2.new(0, 10, 0, 10)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = colors.text
    titleText.TextSize = 16
    titleText.Font = FONT_REGULAR
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = 101
    titleText.Parent = notificationFrame

    local messageText = Instance.new("TextLabel")
    messageText.Name = "MessageText"
    messageText.Size = UDim2.new(1, -10, 0, 40)
    messageText.Position = UDim2.new(0, 10, 0, 30)
    messageText.BackgroundTransparency = 1
    messageText.Text = message
    messageText.TextColor3 = colors.textSecondary
    messageText.TextSize = 14
    messageText.Font = FONT_REGULAR
    messageText.TextXAlignment = Enum.TextXAlignment.Left
    messageText.TextYAlignment = Enum.TextYAlignment.Top
    messageText.TextWrapped = true
    messageText.ZIndex = 101
    messageText.Parent = notificationFrame

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = colors.textSecondary
    closeButton.TextSize = 18
    closeButton.Font = FONT_REGULAR
    closeButton.ZIndex = 101
    closeButton.Parent = notificationFrame

    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = colors.primary
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 101
    progressBar.Parent = notificationFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 1)
    progressCorner.Parent = progressBar

    notificationFrame.BackgroundTransparency = 1
    createTween(notificationFrame, {BackgroundTransparency = 0}, 0.3)

    closeButton.MouseButton1Click:Connect(function()
        createTween(notificationFrame, {BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        notificationFrame:Destroy()
    end)

    spawn(function()
        local startTime = tick()
        while tick() - startTime < duration do
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            progressBar.Size = UDim2.new(1 - progress, 0, 0, 3)
            RunService.RenderStepped:Wait()
        end
        createTween(notificationFrame, {BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        notificationFrame:Destroy()
    end)

    return notificationFrame
end

function Library:AddCheckbox(tab, name, callback)
    local checkboxFrame = Instance.new("Frame")
    checkboxFrame.Name = name
    checkboxFrame.Size = UDim2.new(1, -20, 0, 40)
    checkboxFrame.BackgroundTransparency = 1
    checkboxFrame.Parent = tab.Content
    checkboxFrame.LayoutOrder = #tab.Elements + 1
    checkboxFrame.Visible = true

    local checkboxText = Instance.new("TextLabel")
    checkboxText.Name = "Text"
    checkboxText.Size = UDim2.new(0.7, 0, 1, 0)
    checkboxText.Position = UDim2.new(0, 0, 0, 0)
    checkboxText.BackgroundTransparency = 1
    checkboxText.Text = name
    checkboxText.TextColor3 = colors.text
    checkboxText.TextSize = 14
    checkboxText.Font = FONT_REGULAR
    checkboxText.TextXAlignment = Enum.TextXAlignment.Left
    checkboxText.Parent = checkboxFrame

    local checkboxButton = Instance.new("TextButton")
    checkboxButton.Name = "Checkbox"
    checkboxButton.Size = UDim2.new(0, 25, 0, 25)
    checkboxButton.Position = UDim2.new(1, -25, 0.5, -12)
    checkboxButton.BackgroundColor3 = colors.surface
    checkboxButton.BorderSizePixel = 0
    checkboxButton.Text = ""
    checkboxButton.Parent = checkboxFrame
    checkboxButton.AutoButtonColor = false

    local checkboxCorner = Instance.new("UICorner")
    checkboxCorner.CornerRadius = UDim.new(0, 6)
    checkboxCorner.Parent = checkboxButton

    local checkIcon = Instance.new("TextLabel")
    checkIcon.Name = "CheckIcon"
    checkIcon.Size = UDim2.new(1, 0, 1, 0)
    checkIcon.Position = UDim2.new(0, 0, 0, 0)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Text = "✓"
    checkIcon.TextColor3 = colors.text
    checkIcon.TextSize = 16
    checkIcon.Font = FONT_REGULAR
    checkIcon.Visible = false
    checkIcon.Parent = checkboxButton

    local isChecked = false

    local function updateCheckbox()
        if isChecked then
            createTween(checkboxButton, {BackgroundColor3 = colors.primary}, 0.2)
            checkIcon.Visible = true
        else
            createTween(checkboxButton, {BackgroundColor3 = colors.surface}, 0.2)
            checkIcon.Visible = false
        end
        callback(isChecked)
    end

    checkboxButton.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        updateCheckbox()
    end)

    checkboxButton.MouseEnter:Connect(function()
        createTween(checkboxButton, {BackgroundColor3 = isChecked and Color3.fromRGB(110, 80, 210) or Color3.fromRGB(50, 50, 65)}, 0.2)
    end)

    checkboxButton.MouseLeave:Connect(function()
        createTween(checkboxButton, {BackgroundColor3 = isChecked and colors.primary or colors.surface}, 0.2)
    end)

    table.insert(tab.Elements, checkboxFrame)
    return checkboxFrame
end

function Library:AddInputText(tab, name, placeholder, callback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = name
    inputFrame.Size = UDim2.new(1, -20, 0, 50)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = tab.Content
    inputFrame.LayoutOrder = #tab.Elements + 1
    inputFrame.Visible = true

    local inputText = Instance.new("TextLabel")
    inputText.Name = "Text"
    inputText.Size = UDim2.new(1, 0, 0, 20)
    inputText.Position = UDim2.new(0, 0, 0, 0)
    inputText.BackgroundTransparency = 1
    inputText.Text = name
    inputText.TextColor3 = colors.text
    inputText.TextSize = 14
    inputText.Font = FONT_REGULAR
    inputText.TextXAlignment = Enum.TextXAlignment.Left
    inputText.Parent = inputFrame

    local textBox = Instance.new("TextBox")
    textBox.Name = "InputBox"
    textBox.Size = UDim2.new(1, 0, 0, 30)
    textBox.Position = UDim2.new(0, 0, 0, 20)
    textBox.BackgroundColor3 = colors.surface
    textBox.BorderSizePixel = 0
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = colors.text
    textBox.PlaceholderColor3 = colors.textSecondary
    textBox.TextSize = 14
    textBox.Font = FONT_REGULAR
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Parent = inputFrame

    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox

    local textBoxPadding = Instance.new("UIPadding")
    textBoxPadding.PaddingLeft = UDim.new(0, 10)
    textBoxPadding.Parent = textBox

    textBox.Focused:Connect(function()
        createTween(textBox, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}, 0.2)
    end)

    textBox.FocusLost:Connect(function()
        createTween(textBox, {BackgroundColor3 = colors.surface}, 0.2)
        callback(textBox.Text)
    end)

    table.insert(tab.Elements, inputFrame)
    return inputFrame
end

function Library:AddPlayerSelector(tab, name, callback)
    local playerSelectorFrame = Instance.new("Frame")
    playerSelectorFrame.Name = name .. "PlayerSelector"
    playerSelectorFrame.Size = UDim2.new(1, -20, 0, 40)
    playerSelectorFrame.BackgroundTransparency = 1
    playerSelectorFrame.Parent = tab.Content
    playerSelectorFrame.LayoutOrder = #tab.Elements + 1
    playerSelectorFrame.Visible = true

    local playerSelectorText = Instance.new("TextLabel")
    playerSelectorText.Name = "Text"
    playerSelectorText.Size = UDim2.new(0.7, 0, 1, 0)
    playerSelectorText.Position = UDim2.new(0, 0, 0, 0)
    playerSelectorText.BackgroundTransparency = 1
    playerSelectorText.Text = name
    playerSelectorText.TextColor3 = colors.text
    playerSelectorText.TextSize = 14
    playerSelectorText.Font = FONT_REGULAR
    playerSelectorText.TextXAlignment = Enum.TextXAlignment.Left
    playerSelectorText.Parent = playerSelectorFrame

    local playerSelectorButton = Instance.new("TextButton")
    playerSelectorButton.Name = "PlayerSelectorButton"
    playerSelectorButton.Size = UDim2.new(0.3, 0, 1, 0)
    playerSelectorButton.Position = UDim2.new(0.7, 0, 0, 0)
    playerSelectorButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    playerSelectorButton.BorderSizePixel = 0
    playerSelectorButton.Text = "Choose..."
    playerSelectorButton.TextColor3 = colors.text
    playerSelectorButton.TextSize = 13
    playerSelectorButton.Font = FONT_REGULAR
    playerSelectorButton.Parent = playerSelectorFrame

    local playerSelectorCorner = Instance.new("UICorner")
    playerSelectorCorner.CornerRadius = UDim.new(0, 6)
    playerSelectorCorner.Parent = playerSelectorButton

    local playerSelectorIcon = Instance.new("TextLabel")
    playerSelectorIcon.Name = "Icon"
    playerSelectorIcon.Size = UDim2.new(0, 20, 1, 0)
    playerSelectorIcon.Position = UDim2.new(1, -20, 0, 0)
    playerSelectorIcon.BackgroundTransparency = 1
    playerSelectorIcon.Text = "▼"
    playerSelectorIcon.TextColor3 = colors.textSecondary
    playerSelectorIcon.TextSize = 12
    playerSelectorIcon.Font = FONT_REGULAR
    playerSelectorIcon.Parent = playerSelectorButton

    local screenGui = self.ScreenGui or game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("CustomLib")
    local playerList = Instance.new("ScrollingFrame")
    playerList.Name = "PlayerList"
    playerList.Size = UDim2.new(0, 0, 0, 0)
    playerList.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    playerList.BorderSizePixel = 0
    playerList.ScrollBarThickness = 6
    playerList.ScrollBarImageColor3 = colors.textSecondary
    playerList.Visible = false
    playerList.ZIndex = 100
    playerList.Parent = screenGui

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = playerList

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = playerList
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)

    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingLeft = UDim.new(0, 5)
    listPadding.PaddingRight = UDim.new(0, 5)
    listPadding.Parent = playerList

    local isOpen = false
    local selectedPlayer = nil
    local renderConnection
    local playerAddedConnection
    local playerRemovingConnection
    local playerButtons = {}

    local function updatePlayerListPosition()
        if isOpen then
            local buttonAbsolutePos = playerSelectorButton.AbsolutePosition
            local buttonAbsoluteSize = playerSelectorButton.AbsoluteSize
            
            local listWidth = math.max(buttonAbsoluteSize.X * 1.5, 250)
            playerList.Position = UDim2.new(
                0, buttonAbsolutePos.X - (listWidth - buttonAbsoluteSize.X) / 2,
                0, buttonAbsolutePos.Y + buttonAbsoluteSize.Y + 5
            )
            
            playerList.Size = UDim2.new(0, listWidth, 0, playerList.AbsoluteSize.Y)
        end
    end

    local function updateListSize()
        if not isOpen then return end
        
        local contentHeight = listLayout.AbsoluteContentSize.Y + 10
        local maxHeight = math.min(contentHeight, 200)
        
        playerList.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        
        playerList.Size = UDim2.new(playerList.Size.X.Scale, playerList.Size.X.Offset, 0, maxHeight)
        
        updatePlayerListPosition()
    end

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateListSize)

    local function clearPlayerButtons()
        for _, button in pairs(playerButtons) do
            if button and button.Parent then
                button:Destroy()
            end
        end
        playerButtons = {}
    end

    local function createPlayerButtons()
        clearPlayerButtons()

        local players = game.Players:GetPlayers()

        for _, player in ipairs(players) do
            if player ~= game.Players.LocalPlayer then
                local playerButton = Instance.new("TextButton")
                playerButton.Name = player.Name .. "PlayerButton"
                playerButton.Size = UDim2.new(1, -10, 0, 40)
                playerButton.BackgroundColor3 = colors.surface
                playerButton.BorderSizePixel = 0
                playerButton.Text = ""
                playerButton.ZIndex = 101
                playerButton.AutoButtonColor = false
                playerButton.Parent = playerList

                playerButtons[player] = playerButton

                local playerButtonCorner = Instance.new("UICorner")
                playerButtonCorner.CornerRadius = UDim.new(0, 4)
                playerButtonCorner.Parent = playerButton

                local playerIcon = Instance.new("ImageLabel")
                playerIcon.Name = "PlayerIcon"
                playerIcon.Size = UDim2.new(0, 30, 0, 30)
                playerIcon.Position = UDim2.new(0, 5, 0.5, -15)
                playerIcon.BackgroundTransparency = 1
                
                pcall(function()
                    playerIcon.Image = game.Players:GetUserThumbnailAsync(
                        player.UserId, 
                        Enum.ThumbnailType.HeadShot, 
                        Enum.ThumbnailSize.Size100x100
                    )
                end)
                
                playerIcon.ZIndex = 102
                playerIcon.Parent = playerButton

                local playerName = Instance.new("TextLabel")
                playerName.Name = "PlayerName"
                playerName.Size = UDim2.new(1, -40, 1, 0)
                playerName.Position = UDim2.new(0, 40, 0, 0)
                playerName.BackgroundTransparency = 1
                
                local displayName = player.Name
                if #displayName > 15 then
                    displayName = string.sub(displayName, 1, 15) .. "..."
                end
                
                playerName.Text = displayName
                playerName.TextColor3 = colors.text
                playerName.TextSize = 13
                playerName.Font = FONT_REGULAR
                playerName.TextXAlignment = Enum.TextXAlignment.Left
                playerName.ZIndex = 102
                playerName.Parent = playerButton

                local tooltip = Instance.new("TextLabel")
                tooltip.Name = "Tooltip"
                tooltip.Size = UDim2.new(0, 0, 0, 0)
                tooltip.Position = UDim2.new(0, 0, 1, 5)
                tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                tooltip.BorderSizePixel = 0
                tooltip.Text = player.Name
                tooltip.TextColor3 = colors.text
                tooltip.TextSize = 12
                tooltip.Font = FONT_REGULAR
                tooltip.Visible = false
                tooltip.ZIndex = 105
                tooltip.Parent = playerButton

                local tooltipCorner = Instance.new("UICorner")
                tooltipCorner.CornerRadius = UDim.new(0, 4)
                tooltipCorner.Parent = tooltip

                local tooltipPadding = Instance.new("UIPadding")
                tooltipPadding.PaddingLeft = UDim.new(0, 5)
                tooltipPadding.PaddingRight = UDim.new(0, 5)
                tooltipPadding.Parent = tooltip

                playerButton.MouseEnter:Connect(function()
                    createTween(playerButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}, 0.2)
                    
                    local textSize = TextService:GetTextSize(
                        player.Name,
                        tooltip.TextSize,
                        tooltip.Font,
                        Vector2.new(1000, 1000)
                    )
                    tooltip.Size = UDim2.new(0, textSize.X + 10, 0, textSize.Y)
                    tooltip.Visible = true
                end)

                playerButton.MouseLeave:Connect(function()
                    createTween(playerButton, {BackgroundColor3 = colors.surface}, 0.2)
                    tooltip.Visible = false
                end)

                playerButton.MouseButton1Click:Connect(function()
                    selectedPlayer = player
                    
                    local buttonText = player.Name
                    if #buttonText > 12 then
                        buttonText = string.sub(buttonText, 1, 12) .. "..."
                    end
                    
                    playerSelectorButton.Text = buttonText
                    togglePlayerList()
                    callback(player)
                end)
            end
        end

        updateListSize()
    end

    local function togglePlayerList()
        isOpen = not isOpen
        
        if isOpen then
            createPlayerButtons()
            playerList.Visible = true
            playerSelectorIcon.Text = "▲"
            
            if playerAddedConnection then
                playerAddedConnection:Disconnect()
            end
            if playerRemovingConnection then
                playerRemovingConnection:Disconnect()
            end
            
            playerAddedConnection = game.Players.PlayerAdded:Connect(function(player)
                wait(0.1)
                createPlayerButtons()
            end)
            
            playerRemovingConnection = game.Players.PlayerRemoving:Connect(function(player)
                if selectedPlayer == player then
                    selectedPlayer = nil
                    playerSelectorButton.Text = "Choose..."
                end
                wait(0.1)
                createPlayerButtons()
            end)
            
            if not renderConnection then
                renderConnection = RunService.RenderStepped:Connect(updatePlayerListPosition)
            end
        else
            playerList.Visible = false
            playerSelectorIcon.Text = "▼"
            
            if playerAddedConnection then
                playerAddedConnection:Disconnect()
                playerAddedConnection = nil
            end
            
            if playerRemovingConnection then
                playerRemovingConnection:Disconnect()
                playerRemovingConnection = nil
            end
            
            if renderConnection then
                renderConnection:Disconnect()
                renderConnection = nil
            end
            
            clearPlayerButtons()
        end
    end

    playerSelectorButton.MouseButton1Click:Connect(togglePlayerList)

    local function closePlayerList(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local listPos = playerList.AbsolutePosition
            local listSize = playerList.AbsoluteSize
            
            local isClickInsideList = 
                mousePos.X >= listPos.X and 
                mousePos.X <= listPos.X + listSize.X and
                mousePos.Y >= listPos.Y and 
                mousePos.Y <= listPos.Y + listSize.Y
                
            local isClickOnButton = 
                mousePos.X >= playerSelectorButton.AbsolutePosition.X and 
                mousePos.X <= playerSelectorButton.AbsolutePosition.X + playerSelectorButton.AbsoluteSize.X and
                mousePos.Y >= playerSelectorButton.AbsolutePosition.Y and 
                mousePos.Y <= playerSelectorButton.AbsolutePosition.Y + playerSelectorButton.AbsoluteSize.Y
            
            if not isClickInsideList and not isClickOnButton then
                togglePlayerList()
            end
        end
    end

    UserInputService.InputBegan:Connect(closePlayerList)

    playerSelectorFrame.Destroying:Connect(function()
        if renderConnection then
            renderConnection:Disconnect()
        end
        if playerAddedConnection then
            playerAddedConnection:Disconnect()
        end
        if playerRemovingConnection then
            playerRemovingConnection:Disconnect()
        end
        clearPlayerButtons()
        playerList:Destroy()
    end)

    table.insert(tab.Elements, playerSelectorFrame)
    return playerSelectorFrame
end

return Library
