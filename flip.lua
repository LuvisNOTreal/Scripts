local ui_enabled = false -- Set this to true if you're on mobile 

local FrontflipKey = Enum.KeyCode.Z
local BackflipKey = Enum.KeyCode.X
local AirjumpKey = Enum.KeyCode.C

local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    return
end

local h = 0.0174533

local function doFrontflip()
    local character = localPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end

    humanoid:ChangeState("Jumping")
    task.wait()
    humanoid.Sit = true
    for i = 1, 360 do 
        task.delay(i/720, function()
            if humanoid and hrp and humanoid.Parent then
                humanoid.Sit = true
                hrp.CFrame *= CFrame.Angles(-h, 0, 0)
            end
        end)
    end
    task.wait(0.55)
    if humanoid and humanoid.Parent then humanoid.Sit = false end
end

local function doBackflip()
    local character = localPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end

    humanoid:ChangeState("Jumping")
    task.wait()
    humanoid.Sit = true
    for i = 1, 360 do
        task.delay(i/720, function()
            if humanoid and hrp and humanoid.Parent then
                humanoid.Sit = true
                hrp.CFrame *= CFrame.Angles(h, 0, 0)
            end
        end)
    end
    task.wait(0.55)
    if humanoid and humanoid.Parent then humanoid.Sit = false end
end

local function doAirjump()
    local character = localPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
    
    humanoid:ChangeState("Seated")
    task.wait()
    humanoid:ChangeState("Jumping")
end

local function handleFrontflipInput(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        task.spawn(doFrontflip)
    end
end

local function handleBackflipInput(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        task.spawn(doBackflip)
    end
end

local function handleAirjumpInput(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        task.spawn(doAirjump)
    end
end

ContextActionService:BindAction("CustomFrontflipAction", handleFrontflipInput, false, FrontflipKey)
ContextActionService:BindAction("CustomBackflipAction", handleBackflipInput, false, BackflipKey)
ContextActionService:BindAction("CustomAirjumpAction", handleAirjumpInput, false, AirjumpKey)

if ui_enabled then
    if localPlayer.PlayerGui:FindFirstChild("FlipUI") then
        localPlayer.PlayerGui.FlipUI:Destroy()
    end

    local colors = {
        base = Color3.fromHex("181825"),
        mantle = Color3.fromHex("13131a"),
        outline = Color3.fromHex("1e1e2e"),
        text = Color3.fromHex("cdd6f4"),
        surface0 = Color3.fromHex("313244"),
        subtext1 = Color3.fromRGB(186, 194, 222),
        overlay2 = Color3.fromRGB(108, 112, 134),
        red = Color3.fromRGB(243, 139, 168),
    }

    local isCollapsed = false

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlipUI"
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999999999

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 220, 0, 160) 
    mainFrame.Position = UDim2.new(0.5, -110, 0.5, -80) 
    mainFrame.BackgroundColor3 = colors.base
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = colors.outline
    mainStroke.Thickness = 2
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainStroke.Parent = mainFrame

    local titleBarFrame = Instance.new("Frame")
    titleBarFrame.Name = "TitleBarFrame"
    titleBarFrame.Size = UDim2.new(1, 0, 0, 35)
    titleBarFrame.Position = UDim2.new(0, 0, 0, 0)
    titleBarFrame.BackgroundColor3 = colors.mantle
    titleBarFrame.BorderSizePixel = 0
    titleBarFrame.Active = true
    titleBarFrame.ClipsDescendants = true 
    titleBarFrame.Parent = mainFrame

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 10) 
    titleBarCorner.Parent = titleBarFrame

    local bottomCornerRectifier = Instance.new("Frame")
    bottomCornerRectifier.Name = "BottomCornerRectifier"
    bottomCornerRectifier.Parent = titleBarFrame
    bottomCornerRectifier.BackgroundColor3 = colors.mantle
    bottomCornerRectifier.BorderSizePixel = 0
    bottomCornerRectifier.ZIndex = 2
    bottomCornerRectifier.Size = UDim2.new(1, 0, 0.5, 0)
    bottomCornerRectifier.Position = UDim2.new(0, 0, 0.5, 0)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -45, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Flip"
    titleLabel.TextColor3 = colors.text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3 
    titleLabel.Parent = titleBarFrame

    local collapseButton = Instance.new("ImageButton")
    collapseButton.Name = "CollapseButton"
    collapseButton.Size = UDim2.new(0, 14, 0, 14)
    collapseButton.Position = UDim2.new(1, -26, 0.5, -7)
    collapseButton.BackgroundTransparency = 1
    collapseButton.Image = "rbxassetid://109757326745560"
    collapseButton.ImageColor3 = colors.subtext1
    collapseButton.ZIndex = 3 
    collapseButton.Parent = titleBarFrame

    local newDivider = Instance.new("Frame")
    newDivider.Name = "DividerLine"
    newDivider.Parent = mainFrame
    newDivider.BackgroundColor3 = colors.outline
    newDivider.BorderSizePixel = 0
    newDivider.Size = UDim2.new(1, 0, 0, 2)
    newDivider.Position = UDim2.new(0, 0, 0, 35) 
    newDivider.ZIndex = 2

    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Position = UDim2.new(0, 10, 0, 45)
    buttonContainer.Size = UDim2.new(1, -20, 0, 105) 
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center 
    listLayout.Parent = buttonContainer

    local function createButton(name, text, order)
        local button = Instance.new("TextButton")
        button.Name = name
        button.LayoutOrder = order
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = colors.surface0
        button.Text = text
        button.TextColor3 = colors.text
        button.TextSize = 16
        button.Font = Enum.Font.Gotham
        button.Parent = buttonContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button

        local defaultColor = colors.surface0
        local hoverColor = colors.overlay2
        local clickFlashColor = Color3.new(hoverColor.R * 0.9, hoverColor.G * 0.9, hoverColor.B * 0.9) 

        local currentButtonTween

        local function playColorTween(targetColor, duration)
            if currentButtonTween then
                currentButtonTween:Cancel()
                currentButtonTween = nil
            end
            currentButtonTween = TweenService:Create(button, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor})
            currentButtonTween:Play()
        end

        button.MouseEnter:Connect(function()
            if button.BackgroundColor3 ~= hoverColor and button.BackgroundColor3 ~= clickFlashColor then
                playColorTween(hoverColor, 0.15)
            end
        end)

        button.MouseLeave:Connect(function()
            if button.BackgroundColor3 ~= defaultColor and button.BackgroundColor3 ~= clickFlashColor then
                playColorTween(defaultColor, 0.15)
            end
        end)

        button.MouseButton1Down:Connect(function()
            if currentButtonTween then
                currentButtonTween:Cancel()
                currentButtonTween = nil
            end
            button.BackgroundColor3 = clickFlashColor
        end)

        button.MouseButton1Up:Connect(function()
            task.delay(0.05, function()
                playColorTween(defaultColor, 0.2)
            end)
        end)
        
        return button
    end

    local frontflipButton = createButton("FrontflipButton", "Frontflip", 1)
    local backflipButton = createButton("BackflipButton", "Backflip", 2)
    local airJumpButton = createButton("AirJumpButton", "Air Jump", 3)
    
    frontflipButton.MouseButton1Click:Connect(function() task.spawn(doFrontflip) end)
    backflipButton.MouseButton1Click:Connect(function() task.spawn(doBackflip) end)
    airJumpButton.MouseButton1Click:Connect(function() task.spawn(doAirjump) end)
    
    local isDragging = false
    local dragStart, startPos

    titleBarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.AbsolutePosition
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.fromOffset(startPos.X + delta.X, startPos.Y + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == Enum.KeyCode.K then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    local function toggleCollapse()
        isDragging = false
        isCollapsed = not isCollapsed
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local targetSize

        if isCollapsed then
            targetSize = UDim2.new(0, 220, 0, 35)
            newDivider.Visible = false
            buttonContainer.Visible = false
            bottomCornerRectifier.Visible = false
        else
            targetSize = UDim2.new(0, 220, 0, 160)
            newDivider.Visible = true
            buttonContainer.Visible = true
            bottomCornerRectifier.Visible = true
        end

        TweenService:Create(mainFrame, tweenInfo, {Size = targetSize}):Play()
    end

    collapseButton.MouseButton1Click:Connect(toggleCollapse)

    collapseButton.MouseEnter:Connect(function()
        TweenService:Create(collapseButton, TweenInfo.new(0.2), {ImageColor3 = colors.red}):Play()
    end)

    collapseButton.MouseLeave:Connect(function()
        TweenService:Create(collapseButton, TweenInfo.new(0.2), {ImageColor3 = colors.subtext1}):Play()
    end)
end

print("Flip script loaded.")
