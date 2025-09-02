-- Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti-AFK Variables
local antiAFKEnabled = false
local antiAFKConnection

-- God Mode Variables
local godModeEnabled = false
local humanoid

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 260)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- UICorner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = MainFrame

-- TitleBar
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Text = "⚡ Chulex X Hub ⚡"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.TextSize = 20
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.Parent = MainFrame

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -120, 1, -40)
Content.Position = UDim2.new(0, 120, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Content.Parent = MainFrame

-- UI Template
local function createButton(name, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.AutoButtonColor = true
    btn.Parent = Sidebar
    return btn
end

-- Glow Effect
local function setGlow(button, color)
    local uiStroke = button:FindFirstChild("Glow")
    if not uiStroke then
        uiStroke = Instance.new("UIStroke")
        uiStroke.Name = "Glow"
        uiStroke.Thickness = 3
        uiStroke.Parent = button
    end
    uiStroke.Color = color
    uiStroke.Enabled = true
end

local function clearGlow(button)
    local uiStroke = button:FindFirstChild("Glow")
    if uiStroke then
        uiStroke.Enabled = false
    end
end

-- Sidebar Buttons
local AntiAFKBtn = createButton("AntiAFKBtn", "Anti-AFK")
AntiAFKBtn.Position = UDim2.new(0, 5, 0, 10)

local GodModeBtn = createButton("GodModeBtn", "God Mode")
GodModeBtn.Position = UDim2.new(0, 5, 0, 60)

local PlayerInfoBtn = createButton("PlayerInfoBtn", "Player Info")
PlayerInfoBtn.Position = UDim2.new(0, 5, 0, 110)

local UpdatesBtn = createButton("UpdatesBtn", "Updates")
UpdatesBtn.Position = UDim2.new(0, 5, 0, 160)

-- Header for Content
local function createHeader(text)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    header.Text = text
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.TextColor3 = Color3.new(1, 1, 1)
    header.Parent = Content
end

-- Clear Content
local function clearContent()
    Content:ClearAllChildren()
end

-- Functions
local function toggleAntiAFK()
    antiAFKEnabled = not antiAFKEnabled
    if antiAFKEnabled then
        antiAFKConnection = player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        setGlow(AntiAFKBtn, Color3.fromRGB(0, 255, 100))
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
        clearGlow(AntiAFKBtn)
    end
    clearContent()
    createHeader("Anti-AFK")
end

local function toggleGodMode()
    godModeEnabled = not godModeEnabled
    humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if godModeEnabled and humanoid then
        humanoid.NameDisplayDistance = 0 -- แค่กัน reset name
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        setGlow(GodModeBtn, Color3.fromRGB(255, 255, 0))
    else
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
        clearGlow(GodModeBtn)
    end
    clearContent()
    createHeader("God Mode")
end

local function showPlayerInfo()
    clearContent()
    createHeader("Player Info")

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 30)
    nameLabel.Position = UDim2.new(0, 0, 0, 50)
    nameLabel.Text = "ชื่อผู้เล่น: " .. player.Name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = Content
end

local function showUpdates()
    clearContent()
    createHeader("Updates")

    local updatesLabel = Instance.new("TextLabel")
    updatesLabel.Size = UDim2.new(1, -10, 1, -50)
    updatesLabel.Position = UDim2.new(0, 5, 0, 50)
    updatesLabel.Text = "- v1.0: Modern Hub เปิดตัว\n- เพิ่ม Anti-AFK\n- เพิ่ม Player Info\n- เพิ่ม God Mode"
    updatesLabel.Font = Enum.Font.Gotham
    updatesLabel.TextSize = 16
    updatesLabel.TextColor3 = Color3.new(1, 1, 1)
    updatesLabel.TextWrapped = true
    updatesLabel.BackgroundTransparency = 1
    updatesLabel.Parent = Content
end

-- Button Events
AntiAFKBtn.MouseButton1Click:Connect(toggleAntiAFK)
GodModeBtn.MouseButton1Click:Connect(toggleGodMode)
PlayerInfoBtn.MouseButton1Click:Connect(showPlayerInfo)
UpdatesBtn.MouseButton1Click:Connect(showUpdates)

-- Default Page
showUpdates()
