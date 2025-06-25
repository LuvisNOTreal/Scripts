local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    warn("Can't find LocalPlayer")
    return
end

if localPlayer.PlayerGui:FindFirstChild("AutoFarmMenu") then
    localPlayer.PlayerGui.AutoFarmMenu:Destroy()
end

local colors={base=Color3.fromRGB(30,30,46),mantle=Color3.fromRGB(24,24,37),text=Color3.fromRGB(205,214,244),subtext1=Color3.fromRGB(186,194,222),surface0=Color3.fromRGB(49,50,68),green=Color3.fromRGB(166,227,161),red=Color3.fromRGB(243,139,168)}
local screenGui=Instance.new("ScreenGui")
screenGui.Name="AutoFarmMenu"
screenGui.Parent=localPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn=false
local mainFrame=Instance.new("Frame")
mainFrame.Name="MainFrame"
mainFrame.Size=UDim2.new(0,250,0,80)
mainFrame.Position=UDim2.new(0.5,-125,0.5,-40)
mainFrame.BackgroundColor3=colors.base
mainFrame.BorderSizePixel=0
mainFrame.Parent=screenGui
local mainCorner=Instance.new("UICorner")
mainCorner.CornerRadius=UDim.new(0,8)
mainCorner.Parent=mainFrame
local titleLabel=Instance.new("TextLabel")
titleLabel.Name="TitleLabel"
titleLabel.Size=UDim2.new(1,-20,0,30)
titleLabel.Position=UDim2.new(0,10,0,5)
titleLabel.BackgroundTransparency=1
titleLabel.Text="Auto Farm"
titleLabel.TextColor3=colors.text
titleLabel.Font=Enum.Font.GothamBold
titleLabel.TextSize=20
titleLabel.TextXAlignment=Enum.TextXAlignment.Left
titleLabel.Parent=mainFrame
local buttonContainer=Instance.new("Frame")
buttonContainer.Name="ButtonContainer"
buttonContainer.Size=UDim2.new(1,-20,0,30)
buttonContainer.Position=UDim2.new(0,10,0,40)
buttonContainer.BackgroundTransparency=1
buttonContainer.Parent=mainFrame
local listLayout=Instance.new("UIListLayout")
listLayout.FillDirection=Enum.FillDirection.Horizontal
listLayout.SortOrder=Enum.SortOrder.LayoutOrder
listLayout.VerticalAlignment=Enum.VerticalAlignment.Center
listLayout.Padding=UDim.new(0,6)
listLayout.Parent=buttonContainer
local toggleButton=Instance.new("TextButton")
toggleButton.Name="ToggleButton"
toggleButton.Size=UDim2.new(1,-36,1,0)
toggleButton.LayoutOrder=1
toggleButton.BackgroundColor3=colors.red
toggleButton.Text="Auto-Farm: OFF"
toggleButton.TextColor3=colors.text
toggleButton.TextSize=14
toggleButton.Font=Enum.Font.Gotham
toggleButton.Parent=buttonContainer
local toggleCorner=Instance.new("UICorner")
toggleCorner.CornerRadius=UDim.new(0,6)
toggleCorner.Parent=toggleButton
local consoleButton=Instance.new("TextButton")
consoleButton.Name="ConsoleButton"
consoleButton.Size=UDim2.new(0,30,1,0)
consoleButton.LayoutOrder=2
consoleButton.BackgroundColor3=colors.surface0
consoleButton.Text=""
consoleButton.Parent=buttonContainer
local consoleCorner=Instance.new("UICorner")
consoleCorner.CornerRadius=UDim.new(0,6)
consoleCorner.Parent=consoleButton
local ArrowImage=Instance.new("ImageLabel")
ArrowImage.Image="rbxassetid://116068720797786"
ArrowImage.ImageColor3=colors.text
ArrowImage.BackgroundTransparency=1
ArrowImage.Size=UDim2.new(0.8,0,0.8,0)
ArrowImage.AnchorPoint=Vector2.new(0.5,0.5)
ArrowImage.Position=UDim2.new(0.5,0,0.5,0)
ArrowImage.Parent=consoleButton
local consoleFrame=Instance.new("Frame")
consoleFrame.Name="ConsoleFrame"
consoleFrame.Size=UDim2.new(1,-20,0,0)
consoleFrame.Position=UDim2.new(0,10,0,80)
consoleFrame.BackgroundColor3=colors.mantle
consoleFrame.ClipsDescendants=true
consoleFrame.Parent=mainFrame
local consoleFrameCorner=Instance.new("UICorner")
consoleFrameCorner.CornerRadius=UDim.new(0,6)
consoleFrameCorner.Parent=consoleFrame
local consoleLabel=Instance.new("TextLabel")
consoleLabel.Name="ConsoleLabel"
consoleLabel.Size=UDim2.new(1,-20,1,-20)
consoleLabel.Position=UDim2.new(0,10,0,10)
consoleLabel.BackgroundTransparency=1
consoleLabel.Text=""
consoleLabel.TextColor3=colors.subtext1
consoleLabel.TextSize=12
consoleLabel.Font=Enum.Font.Code
consoleLabel.TextXAlignment=Enum.TextXAlignment.Left
consoleLabel.TextYAlignment=Enum.TextYAlignment.Top
consoleLabel.TextWrapped=true
consoleLabel.Parent=consoleFrame



-- Variables
local isToggledOn, isExpanded, isDragging = false, false, false
local dragStart, startPos = nil, nil
local consoleHistory, MAX_CONSOLE_LINES = {}, 15
local notFoundMessageSent = false
local lastTargetModel, failedAttempts = nil, 0

local function logToConsole(message)
    table.insert(consoleHistory, 1, "> " .. message)
    if #consoleHistory > MAX_CONSOLE_LINES then table.remove(consoleHistory) end
    consoleLabel.Text = "Console Output:\n" .. table.concat(consoleHistory, "\n")
end

local function updateButtonAppearance()
    if isToggledOn then
        toggleButton.Text = "Enabled"
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.green}):Play()
        toggleButton.TextColor3 = colors.base
        logToConsole("Auto Farm Enable")
    else
        toggleButton.Text = "Disabled"
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.red}):Play()
        toggleButton.TextColor3 = colors.text
        logToConsole("Auto Farm Disabled")
        failedAttempts, lastTargetModel = 0, nil
    end
end

local function toggleConsole()
    isExpanded = not isExpanded
    local newMainSize = isExpanded and UDim2.new(0, 250, 0, 175) or UDim2.new(0, 250, 0, 80)
    local newConsoleSize = isExpanded and UDim2.new(1, -20, 0, 85) or UDim2.new(1, -20, 0, 0)
    local arrowRotation = isExpanded and 180 or 0
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, tweenInfo, {Size = newMainSize}):Play()
    TweenService:Create(consoleFrame, tweenInfo, {Size = newConsoleSize}):Play()
    TweenService:Create(ArrowImage, tweenInfo, {Rotation = arrowRotation}):Play()
end

local function doTeleport()
    local character = localPlayer.Character
    if not (character and character:FindFirstChild("HumanoidRootPart")) then return end
    
    local humanoidRootPart = character.HumanoidRootPart
    local bestModel, highestValue = nil, -1

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name == "Money" then
            local targetPart, bundlePart, cashValueObj = descendant:FindFirstChild("Part"), descendant:FindFirstChild("Bundle"), descendant:FindFirstChild("Cash")
            
            if targetPart and bundlePart and bundlePart:FindFirstChild("TouchInterest") and cashValueObj and cashValueObj:IsA("IntValue") then
                raycastParams.FilterDescendantsInstances = {descendant}
                local rayOrigin = targetPart.Position
                local rayDirection = Vector3.new(0, -20, 0) 
                local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

                if raycastResult then
                    if cashValueObj.Value > highestValue then
                        highestValue, bestModel = cashValueObj.Value, descendant
                        bestModel.PrimaryPart = targetPart
                    end
                else
                end
            end
        end
    end

    if not bestModel then
        if not notFoundMessageSent then logToConsole("No valid money found. Waiting..."); notFoundMessageSent = true end
        return
    end
    
    notFoundMessageSent = false
    
    if bestModel == lastTargetModel then failedAttempts += 1 else failedAttempts = 0 end
    
    logToConsole("Targeting money (value: " .. highestValue .. ")")
    
    local finalCFrame, targetPosition = nil, bestModel.PrimaryPart.Position
    local currentRotation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position

    if failedAttempts >= 2 then
        logToConsole("Using aggressive teleport.")
        finalCFrame, failedAttempts = CFrame.new(targetPosition) * currentRotation, 0
    else
        logToConsole("Using passive teleport.")
        finalCFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0)) * currentRotation
    end
    
    local skyCFrame = CFrame.new(humanoidRootPart.CFrame.Position + Vector3.new(0, 5000, 0))
    humanoidRootPart.CFrame = skyCFrame
    task.wait()
    humanoidRootPart.CFrame = finalCFrame
    
    lastTargetModel = bestModel
end

-- DO NOT REMOVE THIS 
local function disableSitting(char)
    local humanoid = char:WaitForChild("Humanoid")
    if humanoid then humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false); logToConsole("Sitting has been disabled.") end
end


toggleButton.MouseButton1Click:Connect(function() isToggledOn = not isToggledOn; updateButtonAppearance() end)
consoleButton.MouseButton1Click:Connect(toggleConsole)
titleLabel.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging, dragStart, startPos = true, input.Position, mainFrame.AbsolutePosition end end)
UserInputService.InputChanged:Connect(function(input) if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; mainFrame.Position = UDim2.fromOffset(startPos.X + delta.X, startPos.Y + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end end)
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) if gameProcessedEvent then return end; if input.KeyCode == Enum.KeyCode.K then screenGui.Enabled = not screenGui.Enabled end end)
 
task.spawn(function()
    while true do
        local waitTime = math.random(5, 10) / 10
        task.wait(waitTime)
        if isToggledOn then
            local success, err = pcall(doTeleport)
            if not success then logToConsole("Error:" .. tostring(err)) end
        end
    end
end)

logToConsole("Loaded. Press 'K' to hide.")
updateButtonAppearance()
if localPlayer.Character then disableSitting(localPlayer.Character) end
localPlayer.CharacterAdded:Connect(disableSitting)
