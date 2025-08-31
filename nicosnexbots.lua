local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NicoByLuv"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 280, 0, 185)
mainFrame.BackgroundColor3 = Color3.fromHex("13131a")
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromHex("1e1e2e")
mainStroke.Thickness = 2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local dragArea = Instance.new("Frame")
dragArea.Name = "DragArea"
dragArea.Size = UDim2.new(1, 0, 0, 36)
dragArea.BackgroundTransparency = 1
dragArea.Parent = mainFrame

local TITLE_TEXT_COLOR = Color3.fromHex("cdd6f4")

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -24, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.MontserratBold
titleLabel.Text = "Nico's Nexbots"
titleLabel.TextColor3 = TITLE_TEXT_COLOR
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = dragArea

local collapseButton = Instance.new("ImageButton")
collapseButton.Name = "CollapseButton"
collapseButton.Size = UDim2.new(0, 14, 0, 14)
collapseButton.Position = UDim2.new(1, -26, 0.5, -7)
collapseButton.BackgroundTransparency = 1
collapseButton.Image = "rbxassetid://109757326745560"
collapseButton.ImageColor3 = TITLE_TEXT_COLOR
collapseButton.ZIndex = 3
collapseButton.Parent = dragArea

local separator = Instance.new("Frame")
separator.Name = "Separator"
separator.Position = UDim2.new(0, 0, 0, 36)
separator.Size = UDim2.new(1, 0, 0, 2)
separator.BackgroundColor3 = Color3.fromHex("1e1e2e")
separator.BorderSizePixel = 0
separator.ZIndex = 2
separator.Parent = mainFrame

local mainBody = Instance.new("Frame")
mainBody.Name = "MainBody"
mainBody.Position = UDim2.new(0, 0, 0, 38)
mainBody.Size = UDim2.new(1, 0, 1, -38)
mainBody.BackgroundColor3 = Color3.fromHex("181825")
mainBody.BorderSizePixel = 0
mainBody.ClipsDescendants = true
mainBody.Parent = mainFrame

local mainBodyCorner = Instance.new("UICorner")
mainBodyCorner.CornerRadius = UDim.new(0, 10)
mainBodyCorner.Parent = mainBody

local topCover = Instance.new("Frame")
topCover.Name = "TopCover"
topCover.Size = UDim2.new(1, 0, 0, 10)
topCover.Position = UDim2.new(0, 0, 0, 0)
topCover.BackgroundColor3 = mainBody.BackgroundColor3
topCover.BorderSizePixel = 0
topCover.ZIndex = 3
topCover.Parent = mainBody

local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainBody

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = contentContainer

local topPadding = Instance.new("UIPadding")
topPadding.PaddingTop = UDim.new(0, 10)
topPadding.PaddingLeft = UDim.new(0, 12)
topPadding.PaddingRight = UDim.new(0, 12)
topPadding.Parent = contentContainer

local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SliderFrame"
sliderFrame.LayoutOrder = 1
sliderFrame.Size = UDim2.new(1, 0, 0, 40)
sliderFrame.BackgroundTransparency = 1
sliderFrame.Parent = contentContainer

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Name = "SliderLabel"
sliderLabel.Size = UDim2.new(0.5, 0, 0, 16)
sliderLabel.Position = UDim2.new(0, 0, 0, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.MontserratBold
sliderLabel.Text = "Speed"
sliderLabel.TextColor3 = TITLE_TEXT_COLOR
sliderLabel.TextSize = 14
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = sliderFrame

local valueLabel = Instance.new("TextLabel")
valueLabel.Name = "ValueLabel"
valueLabel.Size = UDim2.new(0.5, -4, 0, 16)
valueLabel.Position = UDim2.new(0.5, 4, 0, 0)
valueLabel.BackgroundTransparency = 1
valueLabel.Font = Enum.Font.MontserratBold
valueLabel.Text = "Default"
valueLabel.TextColor3 = TITLE_TEXT_COLOR
valueLabel.TextSize = 14
valueLabel.TextXAlignment = Enum.TextXAlignment.Right
valueLabel.Parent = sliderFrame

local sliderBar = Instance.new("Frame")
sliderBar.Name = "SliderBar"
sliderBar.AnchorPoint = Vector2.new(0.5, 0.5)
sliderBar.Size = UDim2.new(1, -10, 0, 6)
sliderBar.Position = UDim2.new(0.5, 0, 1, -10)
sliderBar.BackgroundColor3 = Color3.fromHex("313244")
sliderBar.BorderSizePixel = 0
sliderBar.Parent = sliderFrame

local sliderBarCorner = Instance.new("UICorner")
sliderBarCorner.CornerRadius = UDim.new(0, 4)
sliderBarCorner.Parent = sliderBar

local fillBar = Instance.new("Frame")
fillBar.Name = "FillBar"
fillBar.Size = UDim2.new(0, 0, 1, 0)
fillBar.BackgroundColor3 = Color3.fromRGB(150, 227, 150)
fillBar.BorderSizePixel = 0
fillBar.Parent = sliderBar

local fillBarCorner = Instance.new("UICorner")
fillBarCorner.CornerRadius = UDim.new(0, 4)
fillBarCorner.Parent = fillBar

local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.Size = UDim2.new(0, 12, 0, 12)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = Color3.fromRGB(205, 214, 244)
knob.BorderSizePixel = 0
knob.Parent = sliderBar

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

local espButton = Instance.new("TextButton")
espButton.LayoutOrder = 2
espButton.Size = UDim2.new(1, 0, 0, 32)
espButton.BackgroundColor3 = Color3.fromHex("313244")
espButton.Font = Enum.Font.MontserratMedium
espButton.Text = "ESP"
espButton.TextColor3 = TITLE_TEXT_COLOR
espButton.TextSize = 14
espButton.Parent = contentContainer

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espButton

local bhopButton = Instance.new("TextButton")
bhopButton.LayoutOrder = 3
bhopButton.Size = UDim2.new(1, 0, 0, 32)
bhopButton.BackgroundColor3 = Color3.fromHex("313244")
bhopButton.Font = Enum.Font.MontserratMedium
bhopButton.Text = "B-hop"
bhopButton.TextColor3 = TITLE_TEXT_COLOR
bhopButton.TextSize = 14
bhopButton.Parent = contentContainer

local bhopCorner = Instance.new("UICorner")
bhopCorner.CornerRadius = UDim.new(0, 8)
bhopCorner.Parent = bhopButton

local guiVisible = true
local isMinimized = false
local dragging = false
local espEnabled = false
local bhopEnabled = false
local espHidden = false

local toggleColors = {
    On = { Background = Color3.fromRGB(150, 227, 150), Text = Color3.fromRGB(24, 24, 37) },
    Off = { Background = Color3.fromHex("313244"), Text = TITLE_TEXT_COLOR },
}

local BOTS_FOLDER_NAME = "bots"
local MAX_DIST = 500
local Y_OFFSET = 4
local OUTLINE_COLOR = Color3.fromRGB(255, 0, 0)
local OUTLINE_THICK = 2
local ESP_SUFFIX = "_ESP_OUTLINE"

local function getHRP(model)
    return model and model:FindFirstChild("HumanoidRootPart")
end

local function getLocalHRP()
    if localPlayer and localPlayer.Character then
        return localPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function createOutlineESP(botModel)
    if not botModel or not botModel:IsA("Model") then return end
    local hrp = getHRP(botModel)
    local humanoid = botModel:FindFirstChild("bot")
    if not hrp or not humanoid then return end

    local orig = hrp:FindFirstChild("icon")
    if not orig or not orig:IsA("BillboardGui") then return end

    local espName = botModel.Name .. ESP_SUFFIX
    local old = CoreGui:FindFirstChild(espName)
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = espName
    bb.Adornee = hrp
    bb.AlwaysOnTop = true
    bb.Size = orig.Size
    bb.StudsOffset = orig.StudsOffset + Vector3.new(0, Y_OFFSET, 0)
    bb.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = bb

    local stroke = Instance.new("UIStroke")
    stroke.Name = "ESP_Outline"
    stroke.Color = OUTLINE_COLOR
    stroke.Thickness = OUTLINE_THICK
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Name = "ESP_Label"
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Position = UDim2.new(0, 0, 1, 0)
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.TextSize = 14
    lbl.TextColor3 = OUTLINE_COLOR
    lbl.TextStrokeTransparency = 0
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.ZIndex = 10
    lbl.Text = ""
    lbl.Parent = bb

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not bb.Parent or not hrp or not hrp.Parent then
            if conn then conn:Disconnect() end
            return
        end

        if not orig or not orig.Parent then
            bb.Enabled = false
            return
        end

        bb.Size = orig.Size
        bb.StudsOffset = orig.StudsOffset + Vector3.new(0, Y_OFFSET, 0)

        local lhrp = getLocalHRP()
        if lhrp and espEnabled and not espHidden then
            local dist = (lhrp.Position - hrp.Position).Magnitude
            if dist <= MAX_DIST then
                bb.Enabled = true
                lbl.Text = botModel.Name .. " | " .. math.floor(dist) .. " studs"
            else
                bb.Enabled = false
            end
        else
            bb.Enabled = false
        end
    end)

    botModel.AncestryChanged:Connect(function(_, parent)
        if not parent and bb then
            bb:Destroy()
        end
    end)
end

local function scanFolder(folder)
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Folder") then
            scanFolder(child)
        elseif child:IsA("Model") then
            if child:FindFirstChild("bot") and getHRP(child) then
                createOutlineESP(child)
                local hrp = getHRP(child)
                if hrp then
                    hrp.ChildAdded:Connect(function(c)
                        if c.Name == "icon" and c:IsA("BillboardGui") then
                            createOutlineESP(child)
                        end
                    end)
                end
            end
        end
    end

    folder.ChildAdded:Connect(function(child)
        if child:IsA("Folder") then
            scanFolder(child)
        elseif child:IsA("Model") then
            if child:FindFirstChild("bot") and getHRP(child) then
                createOutlineESP(child)
                local hrp = getHRP(child)
                if hrp then
                    hrp.ChildAdded:Connect(function(c)
                        if c.Name == "icon" and c:IsA("BillboardGui") then
                            createOutlineESP(child)
                        end
                    end)
                end
            end
        end
    end)
end

local bots = Workspace:FindFirstChild(BOTS_FOLDER_NAME)
if bots then
    scanFolder(bots)
else
    warn("No folder '" .. BOTS_FOLDER_NAME .. "' in workspace")
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espButton.BackgroundColor3 = toggleColors.On.Background
        espButton.TextColor3 = toggleColors.On.Text
    else
        espButton.BackgroundColor3 = toggleColors.Off.Background
        espButton.TextColor3 = toggleColors.Off.Text
    end
end)

bhopButton.MouseButton1Click:Connect(function()
    bhopEnabled = not bhopEnabled
    if bhopEnabled then
        bhopButton.BackgroundColor3 = toggleColors.On.Background
        bhopButton.TextColor3 = toggleColors.On.Text
    else
        bhopButton.BackgroundColor3 = toggleColors.Off.Background
        bhopButton.TextColor3 = toggleColors.Off.Text
    end
end)

local sliderMin = 0
local sliderMax = 200
local sliderValue = 0
local draggingSlider = false

local function updateSlider(inputX)
    local barAbsPos = sliderBar.AbsolutePosition.X
    local barAbsSize = sliderBar.AbsoluteSize.X
    local relativeX = math.clamp(inputX - barAbsPos, 0, barAbsSize)
    local percent = (barAbsSize > 0) and (relativeX / barAbsSize) or 0
    sliderValue = math.floor(sliderMin + (sliderMax - sliderMin) * percent + 0.5)
    local alpha = (sliderValue - sliderMin) / (sliderMax - sliderMin)
    fillBar.Size = UDim2.new(alpha, 0, 1, 0)
    knob.Position = UDim2.new(alpha, 0, 0.5, 0)
    if sliderValue == 0 then
        valueLabel.Text = "Default"
    else
        valueLabel.Text = tostring(sliderValue)
    end
end

updateSlider(sliderBar.AbsolutePosition.X)

knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateSlider(input.Position.X)
        draggingSlider = true
    end
end)

fillBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateSlider(input.Position.X)
        draggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input.Position.X)
    end
end)

RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    if sliderValue > 0 then
        humanoid.WalkSpeed = sliderValue
    end
end)

local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
localPlayer.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
end)

local COOLDOWN = 0
local lastJump = 0

RunService.Heartbeat:Connect(function()
    if not bhopEnabled then return end
    if not humanoid then return end

    local now = tick()
    local isGrounded = humanoid.FloorMaterial ~= Enum.Material.Air
    local isFast = humanoid.WalkSpeed > 25

    if isGrounded and isFast and (now - lastJump) >= COOLDOWN then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        lastJump = now
    end
end)

local function clampGuiPosition()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local viewportSize = camera.ViewportSize
    local frameSize = mainFrame.AbsoluteSize

    local minX = frameSize.X / 2
    local maxX = viewportSize.X - frameSize.X / 2
    local minY = 0
    local maxY = viewportSize.Y - frameSize.Y

    local currentPos = mainFrame.Position
    local currentPixelX = viewportSize.X * currentPos.X.Scale + currentPos.X.Offset
    local currentPixelY = viewportSize.Y * currentPos.Y.Scale + currentPos.Y.Offset

    local clampedPixelX = math.clamp(currentPixelX, minX, maxX)
    local clampedPixelY = math.clamp(currentPixelY, minY, maxY)

    local newOffsetX = clampedPixelX - viewportSize.X * currentPos.X.Scale
    local newOffsetY = clampedPixelY - viewportSize.Y * currentPos.Y.Scale

    mainFrame.Position = UDim2.new(currentPos.X.Scale, newOffsetX, currentPos.Y.Scale, newOffsetY)
end

local function toggleMinimize()
    if dragging then return end
    isMinimized = not isMinimized

    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local targetSize

    if isMinimized then
        targetSize = UDim2.new(0, 280, 0, 36)
        mainBody.Visible = false
        separator.Visible = false
    else
        mainBody.Visible = true
        separator.Visible = true
        targetSize = UDim2.new(0, 280, 0, 185)
    end

    local tween = TweenService:Create(mainFrame, tweenInfo, { Size = targetSize })
    tween.Completed:Connect(clampGuiPosition)
    tween:Play()
end

local dragStart
local startPos

dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        clampGuiPosition()
    end
end)

collapseButton.MouseButton1Click:Connect(toggleMinimize)

collapseButton.MouseEnter:Connect(function()
    TweenService:Create(collapseButton, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(243, 139, 168) }):Play()
end)

collapseButton.MouseLeave:Connect(function()
    TweenService:Create(collapseButton, TweenInfo.new(0.2), { ImageColor3 = TITLE_TEXT_COLOR }):Play()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.Z then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    elseif input.KeyCode == Enum.KeyCode.X then
        toggleMinimize()
    end
end)

Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampGuiPosition)
clampGuiPosition()
