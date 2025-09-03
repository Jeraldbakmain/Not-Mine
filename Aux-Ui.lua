-- // Library for ( DNS ) \\ --
local GuiLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- // Helper for simple hover ( free to modify )
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.25), {
            BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        }):Play()
    end)
end

-- // Helper
local function style(obj)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = obj

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
end

-- // Create a Main Window
function GuiLib:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GuiLibUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    -- Main frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 300)
    frame.Position = UDim2.new(0, 30, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    style(frame)

    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Gui Library"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = frame

    -- Scrolling frame container
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -10, 1, -35)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 30)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = frame

    -- Layout for scrolling content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = scrollingFrame

    -- Auto-update canvas size
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    -- Make it draggable
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    self.Frame = scrollingFrame
    return self
end

-- // Add Button
function GuiLib:Button(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = self.Frame
    style(button)
    addHoverEffect(button)

    button.MouseButton1Click:Connect(callback or function() end)
    return button
end

-- // Add Toggle
function GuiLib:Toggle(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.Text = text .. " : OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = self.Frame
    style(button)
    addHoverEffect(button)

    local toggled = false
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.Text = text .. (toggled and " : ON" or " : OFF")
        if callback then callback(toggled) end
    end)

    return button
end

-- // Add TextBox
function GuiLib:TextBox(placeholder, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 180, 0, 32)
    textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = false
    textBox.Parent = self.Frame
    style(textBox)

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(textBox.Text)
        end
    end)

    return textBox
end

return GuiLib
