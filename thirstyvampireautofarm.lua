local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("Could not find LocalPlayer.")
    return
end

local MainModule = require(ReplicatedStorage:WaitForChild("Main"))
repeat task.wait() until MainModule.Loaded
local Network = MainModule.Network 

if LocalPlayer.PlayerGui:FindFirstChild("SilverCollectorMenu") then
    LocalPlayer.PlayerGui.SilverCollectorMenu:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmMenu"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local colors = {
    base = Color3.fromRGB(30, 30, 46),
    mantle = Color3.fromRGB(24, 24, 37),
    text = Color3.fromRGB(205, 214, 244),
    subtext1 = Color3.fromRGB(186, 194, 222),
    surface0 = Color3.fromRGB(49, 50, 68),
    green = Color3.fromRGB(166, 227, 161),
    red = Color3.fromRGB(243, 139, 168)
}

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 80)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -40)
mainFrame.BackgroundColor3 = colors.base
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Farm"
titleLabel.TextColor3 = colors.text
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -20, 0, 30)
buttonContainer.Position = UDim2.new(0, 10, 0, 40)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = buttonContainer

local masterToggleButton = Instance.new("TextButton")
masterToggleButton.Name = "MasterToggleButton"
masterToggleButton.LayoutOrder = 1
masterToggleButton.Size = UDim2.new(1, -36, 1, 0)
masterToggleButton.BackgroundColor3 = colors.red
masterToggleButton.Text = "Disabled"
masterToggleButton.TextColor3 = colors.text
masterToggleButton.TextSize = 14
masterToggleButton.Font = Enum.Font.Gotham
masterToggleButton.Parent = buttonContainer

local buttonCorner1 = Instance.new("UICorner")
buttonCorner1.CornerRadius = UDim.new(0, 6)
buttonCorner1.Parent = masterToggleButton

local consoleButton = Instance.new("TextButton")
consoleButton.Name = "ConsoleButton"
consoleButton.LayoutOrder = 2
consoleButton.Size = UDim2.new(0, 30, 1, 0)
consoleButton.BackgroundColor3 = colors.surface0
consoleButton.Text = ""
consoleButton.Parent = buttonContainer

local consoleCorner = Instance.new("UICorner")
consoleCorner.CornerRadius = UDim.new(0, 6)
consoleCorner.Parent = consoleButton

local arrowImage = Instance.new("ImageLabel")
arrowImage.Image = "rbxassetid://116068720797786"
arrowImage.ImageColor3 = colors.text
arrowImage.BackgroundTransparency = 1
arrowImage.Size = UDim2.new(0.8, 0, 0.8, 0)
arrowImage.AnchorPoint = Vector2.new(0.5, 0.5)
arrowImage.Position = UDim2.new(0.5, 0, 0.5, 0)
arrowImage.Parent = consoleButton

local consoleFrame = Instance.new("Frame")
consoleFrame.Name = "ConsoleFrame"
consoleFrame.Size = UDim2.new(1, -20, 0, 0)
consoleFrame.Position = UDim2.new(0, 10, 0, 80)
consoleFrame.BackgroundColor3 = colors.mantle
consoleFrame.ClipsDescendants = true
consoleFrame.Parent = mainFrame

local consoleFrameCorner = Instance.new("UICorner")
consoleFrameCorner.CornerRadius = UDim.new(0, 6)
consoleFrameCorner.Parent = consoleFrame

local consoleLabel = Instance.new("TextLabel")
consoleLabel.Name = "ConsoleLabel"
consoleLabel.Size = UDim2.new(1, -20, 1, -20)
consoleLabel.Position = UDim2.new(0, 10, 0, 10)
consoleLabel.BackgroundTransparency = 1
consoleLabel.Text = ""
consoleLabel.TextColor3 = colors.subtext1
consoleLabel.TextSize = 12
consoleLabel.Font = Enum.Font.Code
consoleLabel.TextXAlignment = Enum.TextXAlignment.Left
consoleLabel.TextYAlignment = Enum.TextYAlignment.Top
consoleLabel.TextWrapped = true
consoleLabel.Parent = consoleFrame

local isMasterEnabled, isExpanded, isDragging = false, false, false
local isCollecting = false 
local dragStart, startPos = nil, nil
local consoleHistory, MAX_CONSOLE_LINES = {}, 15
local FLY_SPEED, SEARCH_RADIUS = 80, 2000
local AXIS_ALIGNMENT_THRESHOLD, FINAL_ARRIVAL_DISTANCE = 2, 6
local isFlyingToTarget, currentTarget, lastTarget, flightPhase = false, nil, nil, 1
local espTransparency, espColor = 0.4, Color3.fromRGB(57, 255, 20)
local character, hrp, humanoid, bodyGyro, bodyVelocity

local function logToConsole(message)
    table.insert(consoleHistory, 1, "> " .. message)
    if #consoleHistory > MAX_CONSOLE_LINES then table.remove(consoleHistory) end
    consoleLabel.Text = "Console Output:\n" .. table.concat(consoleHistory, "\n")
end

local function updateMasterButton()
    if isMasterEnabled then
        masterToggleButton.Text = "Enabled"
        masterToggleButton.TextColor3 = colors.base
        TweenService:Create(masterToggleButton, TweenInfo.new(0.2), { BackgroundColor3 = colors.green }):Play()
        logToConsole("Autofarm Enabled")
    else
        masterToggleButton.Text = "Disabled"
        masterToggleButton.TextColor3 = colors.text
        TweenService:Create(masterToggleButton, TweenInfo.new(0.2), { BackgroundColor3 = colors.red }):Play()
        logToConsole("Autofarm Disabled")
    end
end

local function toggleConsole()
    isExpanded = not isExpanded
    local newMainSize = isExpanded and UDim2.new(0, 250, 0, 210) or UDim2.new(0, 250, 0, 80)
    local newConsoleSize = isExpanded and UDim2.new(1, -20, 0, 120) or UDim2.new(1, -20, 0, 0)
    local arrowRotation = isExpanded and 180 or 0
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, tweenInfo, { Size = newMainSize }):Play()
    TweenService:Create(consoleFrame, tweenInfo, { Size = newConsoleSize }):Play()
    TweenService:Create(arrowImage, tweenInfo, { Rotation = arrowRotation }):Play()
end

local function stopFlightAndRestoreControl()
    isFlyingToTarget, currentTarget, flightPhase = false, nil, 1
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if humanoid and humanoid.Parent then 
        humanoid.PlatformStand = false 
    end
    if hrp and hrp.Parent then
         hrp.Anchored = false 
    end
    logToConsole("Autofarm Stopped.")
end

local function initializeCharacterComponents()
    character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    hrp = character:WaitForChild("HumanoidRootPart", 10)
    humanoid = character:WaitForChild("Humanoid", 10)

    if not hrp or not humanoid then
        logToConsole("Error: Could not find HumanoidRootPart or Humanoid.")
        return false
    end

    if bodyGyro and bodyGyro.Parent ~= hrp then bodyGyro:Destroy(); bodyGyro = nil end
    if bodyVelocity and bodyVelocity.Parent ~= hrp then bodyVelocity:Destroy(); bodyVelocity = nil end

    if not bodyGyro then
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    end
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.zero
    end

    logToConsole("Character ready.")
    return true
end

local function autoCollectLoop()
    if not isMasterEnabled or not hrp or not hrp.Parent then return end

    humanoid.PlatformStand = true
    for _, part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end

    if not isFlyingToTarget and not isCollecting then
        local closestTarget, minDistance = nil, SEARCH_RADIUS
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part.Name == "SilverIngot" and part.Parent and part.Parent.Name == "SilverPile" and part ~= lastTarget then
                local distance = (hrp.Position - part.Position).Magnitude
                if distance < minDistance then minDistance, closestTarget = distance, part end
            end
        end
        if closestTarget then
            currentTarget, isFlyingToTarget, flightPhase = closestTarget, true, 1
            logToConsole("Silver found, flying started.")
        end
    end

    if isFlyingToTarget then
        if not currentTarget or not currentTarget.Parent then isFlyingToTarget, currentTarget = false, nil; return end
        local currentPos, targetPos = hrp.Position, currentTarget.Position
        if flightPhase == 1 then
            if math.abs(targetPos.X - currentPos.X) > AXIS_ALIGNMENT_THRESHOLD then
                bodyVelocity.Velocity = Vector3.new(math.sign(targetPos.X - currentPos.X) * FLY_SPEED, 0, 0)
                bodyGyro.CFrame = CFrame.new(currentPos, Vector3.new(targetPos.X, currentPos.Y, currentPos.Z))
            else flightPhase, bodyVelocity.Velocity = 2, Vector3.zero end
        elseif flightPhase == 2 then
            if math.abs(targetPos.Z - currentPos.Z) > AXIS_ALIGNMENT_THRESHOLD then
                bodyVelocity.Velocity = Vector3.new(0, 0, math.sign(targetPos.Z - currentPos.Z) * FLY_SPEED)
                bodyGyro.CFrame = CFrame.new(currentPos, Vector3.new(currentPos.X, currentPos.Y, targetPos.Z))
            else flightPhase, bodyVelocity.Velocity = 3, Vector3.zero end
        elseif flightPhase == 3 then
            if math.abs(targetPos.Y - currentPos.Y) > FINAL_ARRIVAL_DISTANCE then
                bodyVelocity.Velocity = Vector3.new(0, math.sign(targetPos.Y - currentPos.Y) * FLY_SPEED, 0)
                bodyGyro.CFrame = CFrame.new(currentPos, Vector3.new(currentPos.X, targetPos.Y, currentPos.Z))
            else
                bodyVelocity.Velocity = Vector3.zero
                logToConsole("Collecting silver...")
                isCollecting, isFlyingToTarget = true, false 
                Network:FireServer("SilverEvent", "RequestCollection", { SilverPart = currentTarget })
                lastTarget, currentTarget = currentTarget, nil
                
                task.delay(1, function()
                    logToConsole("Searching...")
                    isCollecting = false 
                end)
            end
        end
    end
end

local function initializeEsp()
    local function createEspForPart(part)
        if part:FindFirstChild("Ingot_ESP") then return end
        if part.Name:lower() == "silveringot" then
            local espBox = Instance.new("BoxHandleAdornment", part)
            espBox.Name = "Ingot_ESP"; espBox.Adornee = part; espBox.AlwaysOnTop = true; espBox.ZIndex = 0;
            espBox.Size = part.Size; espBox.Transparency = espTransparency; espBox.Color3 = espColor
        end
    end
    logToConsole("Scanning for ingots...")
    for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BasePart") then createEspForPart(d) end end
    Workspace.DescendantAdded:Connect(function(d) if d:IsA("BasePart") then createEspForPart(d) end end)
    logToConsole("ESP is now enabled.")
end

masterToggleButton.MouseButton1Click:Connect(function()
    isMasterEnabled = not isMasterEnabled
    updateMasterButton()
    if isMasterEnabled then
        if not initializeCharacterComponents() then
            logToConsole("Initialization failed. Turning off.")
            isMasterEnabled = false
            updateMasterButton()
        end
    else
        stopFlightAndRestoreControl()
    end
end)
consoleButton.MouseButton1Click:Connect(toggleConsole)
titleLabel.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then isDragging, dragStart, startPos = true, i.Position, mainFrame.AbsolutePosition end end)
UserInputService.InputChanged:Connect(function(i) if isDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; mainFrame.Position = UDim2.fromOffset(startPos.X + d.X, startPos.Y + d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then isDragging = false end end)
UserInputService.InputBegan:Connect(function(i, gpe) if gpe then return end; if i.KeyCode == Enum.KeyCode.K then screenGui.Enabled = not screenGui.Enabled end end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    logToConsole("Character respawned. Reinitializing...")
        isFlyingToTarget, currentTarget, flightPhase = false, nil, 1
    
    character, hrp, humanoid = newChar, newChar:WaitForChild("HumanoidRootPart"), newChar:WaitForChild("Humanoid")
    
    if isMasterEnabled then
        if not initializeCharacterComponents() then
            logToConsole("Failed to reinitialize on respawn. Disabling autofarm.")
            isMasterEnabled = false
            updateMasterButton()
        end
    end
end)

RunService.Heartbeat:Connect(function() if isMasterEnabled then pcall(autoCollectLoop) end end)

logToConsole("Autofarm loaded. Press 'K' to hide/show.")
character, hrp, humanoid = LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
initializeEsp()
updateMasterButton()

task.spawn(function()
    while true do
        task.wait(30)
        local count = 0
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part.Name == "Lava" and part:IsA("BasePart") then pcall(function() part:Destroy() end); count = count + 1 end
        end
        if count > 0 then logToConsole(string.format("Destroyed %d 'Lava' part(s).", count)) end
    end
end)
