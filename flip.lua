local FrontflipKey = Enum.KeyCode.Z
local BackflipKey = Enum.KeyCode.X
local AirjumpKey = Enum.KeyCode.C
local ca = game:GetService("ContextActionService")
local zeezy = game:GetService("Players").LocalPlayer
local h = 0.0174533

function zeezyFrontflip(act, inp, obj)
	if inp == Enum.UserInputState.Begin then
		zeezy.Character.Humanoid:ChangeState("Jumping")
		task.wait()
		zeezy.Character.Humanoid.Sit = true
		for i = 1, 360 do 
			task.delay(i/720, function()
				if zeezy.Character and zeezy.Character:FindFirstChild("HumanoidRootPart") then
					zeezy.Character.Humanoid.Sit = true
					zeezy.Character.HumanoidRootPart.CFrame *= CFrame.Angles(-h, 0, 0)
				end
			end)
		end
		task.wait(0.55)
		zeezy.Character.Humanoid.Sit = false
	end
end

function zeezyBackflip(act, inp, obj)
	if inp == Enum.UserInputState.Begin then
		zeezy.Character.Humanoid:ChangeState("Jumping")
		task.wait()
		zeezy.Character.Humanoid.Sit = true
		for i = 1, 360 do
			task.delay(i/720, function()
				if zeezy.Character and zeezy.Character:FindFirstChild("HumanoidRootPart") then
					zeezy.Character.Humanoid.Sit = true
					zeezy.Character.HumanoidRootPart.CFrame *= CFrame.Angles(h, 0, 0)
				end
			end)
		end
		task.wait(0.55)
		zeezy.Character.Humanoid.Sit = false
	end
end

function zeezyAirjump(act, inp, obj)
	if inp == Enum.UserInputState.Begin then
		local hum = zeezy.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState("Seated")
			task.wait()
			hum:ChangeState("Jumping")
		end
	end
end

ca:BindAction("zeezyFrontflip", zeezyFrontflip, false, FrontflipKey)
ca:BindAction("zeezyBackflip", zeezyBackflip, false, BackflipKey)
ca:BindAction("zeezyAirjump", zeezyAirjump, false, AirjumpKey)
