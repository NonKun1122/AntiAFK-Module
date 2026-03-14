-- Brainrot Hub V3.2 (Ultimate Wave Proof) for Escape Tsunami For Brainrots
-- Created by Manus AI
-- Features: Ultimate God Mode (Walk through all waves), Speed, Jump, Teleport, Anti-Ban, Movable UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local Config = {
    AntiAFK = false,
    GodMode = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    UIVisible = true,
    AntiBan = true
}

-- Safe Anti-Ban / Bypass (Optimized)
if Config.AntiBan then
    pcall(function()
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
                return (k == "WalkSpeed" and 16 or 50)
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end)
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHub_V3_2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Optimized Draggable Function
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = Config.UIVisible
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
makeDraggable(MainFrame, Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🧠 BRAINROT HUB V3.2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 0, 550)
Content.ScrollBarThickness = 2
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout", Content)
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- UI Elements Helpers
local function createToggle(name, default, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 160, 90) or Color3.fromRGB(160, 50, 50)
    button.Text = name .. ": " .. (default and "ON" or "OFF")
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Parent = Content
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    
    local enabled = default
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and Color3.fromRGB(0, 160, 90) or Color3.fromRGB(160, 50, 50)
        button.Text = name .. ": " .. (enabled and "ON" or "OFF")
        callback(enabled)
    end)
end

local function createSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 65)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = Content
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Parent = frame
    
    local btnMinus = Instance.new("TextButton")
    btnMinus.Size = UDim2.new(0, 45, 0, 25)
    btnMinus.Position = UDim2.new(0, 10, 0, 32)
    btnMinus.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btnMinus.Text = "-"
    btnMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnMinus.Parent = frame
    Instance.new("UICorner", btnMinus).CornerRadius = UDim.new(0, 6)
    
    local btnPlus = Instance.new("TextButton")
    btnPlus.Size = UDim2.new(0, 45, 0, 25)
    btnPlus.Position = UDim2.new(1, -55, 0, 32)
    btnPlus.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btnPlus.Text = "+"
    btnPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnPlus.Parent = frame
    Instance.new("UICorner", btnPlus).CornerRadius = UDim.new(0, 6)
    
    local current = default
    local function update()
        label.Text = name .. ": " .. current
        callback(current)
    end
    btnMinus.MouseButton1Click:Connect(function() current = math.max(min, current - 5) update() end)
    btnPlus.MouseButton1Click:Connect(function() current = math.min(max, current + 5) update() end)
end

local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.Parent = Content
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    button.MouseButton1Click:Connect(callback)
end

-- Features
createToggle("Ultimate God Mode (เดินลุยทุกคลื่น)", Config.GodMode, function(v) Config.GodMode = v end)
createSlider("WalkSpeed (วิ่งเร็ว)", 16, 300, Config.WalkSpeed, function(v) Config.WalkSpeed = v end)
createSlider("JumpPower (กระโดดสูง)", 50, 500, Config.JumpPower, function(v) Config.JumpPower = v end)
createToggle("Infinite Jump (โดดไม่จำกัด)", Config.InfiniteJump, function(v) Config.InfiniteJump = v end)
createToggle("Anti-AFK (กันหลุด)", Config.AntiAFK, function(v) Config.AntiAFK = v end)

-- Teleport System
local TPLabel = Instance.new("TextLabel")
TPLabel.Size = UDim2.new(1, 0, 0, 25)
TPLabel.BackgroundTransparency = 1
TPLabel.Text = "--- Teleport System ---"
TPLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TPLabel.Font = Enum.Font.GothamBold
TPLabel.Parent = Content

local function teleportTo(pos)
    pcall(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = pos
        end
    end)
end

createButton("Teleport to Start (จุดเริ่ม)", function() teleportTo(CFrame.new(0, 15, 0)) end)
createButton("Teleport to End (จุดจบ)", function() 
    local finish = workspace:FindFirstChild("Finish") or workspace:FindFirstChild("End") or workspace:FindFirstChild("Goal")
    if finish then teleportTo(finish.CFrame + Vector3.new(0, 5, 0)) else print("Finish not found") end
end)

-- Optimized Heartbeat Loop (Runs at 30 FPS to save resources)
local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastUpdate < 0.033 then return end -- Limit to ~30 FPS
    lastUpdate = now
    
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            
            -- Ultimate God Mode (Wave Proof)
            if Config.GodMode then
                hum.MaxHealth = 999999
                hum.Health = 999999
                
                -- Lock State to prevent dying or falling
                if hum:GetState() == Enum.HumanoidStateType.Dead then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                
                -- Remove Kill Parts / Scripts dynamically
                for _, v in pairs(player.Character:GetChildren()) do
                    if v:IsA("Script") and (v.Name:lower():find("kill") or v.Name:lower():find("death")) then
                        v.Disabled = true
                    end
                end
                
                -- No-Clip Wave Bypass (Optional: Make character ignore wave collision)
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find("wave") or v.Name:lower():find("tsunami") then
                        if v:IsA("BasePart") then
                            v.CanTouch = false
                        end
                    end
                end
            end
            
            -- Movement Persistence
            hum.WalkSpeed = Config.WalkSpeed
            hum.UseJumpPower = true
            hum.JumpPower = Config.JumpPower
        end
    end)
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Anti-AFK
player.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Toggle UI Function
local function toggleUI()
    Config.UIVisible = not Config.UIVisible
    MainFrame.Visible = Config.UIVisible
end

-- Toggle UI with RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        toggleUI()
    end
end)

-- Floating Toggle Button (Movable)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBtn.Text = "HUB"
ToggleBtn.TextSize = 20
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 30)
Instance.new("UIStroke", ToggleBtn).Thickness = 2
makeDraggable(ToggleBtn, ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(toggleUI)

print("Brainrot Hub V3.2 Ultimate Wave Proof Loaded! UI & Button are movable.")
