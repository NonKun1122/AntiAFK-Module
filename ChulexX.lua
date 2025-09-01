-- Modern Script Hub UI
-- LocalScript

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Anti-AFK
local antiAFKEnabled = false
local elapsedTime = 0

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- ปุ่มเปิด/ปิด UI
local ToggleUIBtn = Instance.new("ImageButton")
ToggleUIBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleUIBtn.Position = UDim2.new(1, -50, 0, 10)
ToggleUIBtn.Image = "rbxassetid://3926305904"
ToggleUIBtn.ImageRectOffset = Vector2.new(964, 324)
ToggleUIBtn.ImageRectSize = Vector2.new(36, 36)
ToggleUIBtn.BackgroundTransparency = 1
ToggleUIBtn.Parent = ScreenGui

-- หน้าต่างหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Corner + Shadow
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageTransparency = 0.5
Shadow.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 50, 0, 50)
Logo.Position = UDim2.new(0, 10, 0.5, -25)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6031071050"
Logo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 70, 0, 10)
Title.Text = "Modern Script Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 200, 0, 20)
Version.Position = UDim2.new(0, 70, 0, 35)
Version.Text = "v1.0"
Version.Font = Enum.Font.Gotham
Version.TextSize = 14
Version.TextColor3 = Color3.fromRGB(200, 220, 255)
Version.BackgroundTransparency = 1
Version.Parent = Header

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Sidebar.Parent = MainFrame

local UICornerSide = Instance.new("UICorner")
UICornerSide.CornerRadius = UDim.new(0, 10)
UICornerSide.Parent = Sidebar

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -130, 1, -70)
Content.Position = UDim2.new(0, 130, 0, 70)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ฟังก์ชันจัดการปุ่ม Active + Hover
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        if button.BackgroundColor3 ~= Color3.fromRGB(0,200,255) then
            button.BackgroundColor3 = Color3.fromRGB(0,170,255)
        end
    end)
    button.MouseLeave:Connect(function()
        if button.BackgroundColor3 ~= Color3.fromRGB(0,200,255) then
            button.BackgroundColor3 = Color3.fromRGB(0,140,255)
        end
    end)
end

local function resetButtonColors()
    AntiAFKBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
    PlayerInfoBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
    UpdatesBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
end

local function selectButton(btn)
    resetButtonColors()
    btn.BackgroundColor3 = Color3.fromRGB(0,200,255) -- Active
end

-- ปุ่ม Sidebar
local AntiAFKBtn = Instance.new("TextButton")
AntiAFKBtn.Size = UDim2.new(1, -20, 0, 40)
AntiAFKBtn.Position = UDim2.new(0, 10, 0, 10)
AntiAFKBtn.Text = "Anti-AFK"
AntiAFKBtn.Font = Enum.Font.GothamBold
AntiAFKBtn.TextSize = 16
AntiAFKBtn.TextColor3 = Color3.new(1,1,1)
AntiAFKBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
AntiAFKBtn.Parent = Sidebar
local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0,8)
UICornerBtn.Parent = AntiAFKBtn
addHoverEffect(AntiAFKBtn)

local PlayerInfoBtn = Instance.new("TextButton")
PlayerInfoBtn.Size = UDim2.new(1, -20, 0, 40)
PlayerInfoBtn.Position = UDim2.new(0, 10, 0, 60)
PlayerInfoBtn.Text = "Player Info"
PlayerInfoBtn.Font = Enum.Font.GothamBold
PlayerInfoBtn.TextSize = 16
PlayerInfoBtn.TextColor3 = Color3.new(1,1,1)
PlayerInfoBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
PlayerInfoBtn.Parent = Sidebar
local UICornerPlayer = Instance.new("UICorner")
UICornerPlayer.CornerRadius = UDim.new(0,8)
UICornerPlayer.Parent = PlayerInfoBtn
addHoverEffect(PlayerInfoBtn)

local UpdatesBtn = Instance.new("TextButton")
UpdatesBtn.Size = UDim2.new(1, -20, 0, 40)
UpdatesBtn.Position = UDim2.new(0, 10, 0, 110)
UpdatesBtn.Text = "Updates"
UpdatesBtn.Font = Enum.Font.GothamBold
UpdatesBtn.TextSize = 16
UpdatesBtn.TextColor3 = Color3.new(1,1,1)
UpdatesBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
UpdatesBtn.Parent = Sidebar
local UICornerUpdates = Instance.new("UICorner")
UICornerUpdates.CornerRadius = UDim.new(0,8)
UICornerUpdates.Parent = UpdatesBtn
addHoverEffect(UpdatesBtn)

-- Timer Anti-AFK
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0, 200, 0, 30)
TimerLabel.Position = UDim2.new(0, 10, 0, 50)
TimerLabel.Text = "เวลา: 0 วินาที"
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.TextSize = 14
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Parent = Content

-- ฟังก์ชัน Anti-AFK
local function toggleAntiAFK()
    antiAFKEnabled = not antiAFKEnabled
    if antiAFKEnabled then
        AntiAFKBtn.Text = "Anti-AFK ✅"
        elapsedTime = 0
    else
        AntiAFKBtn.Text = "Anti-AFK ❌"
    end
end

AntiAFKBtn.MouseButton1Click:Connect(function()
    toggleAntiAFK()
    showAntiAFK()
end)

player.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if antiAFKEnabled then
            elapsedTime += 1
            TimerLabel.Text = "เวลา: " .. elapsedTime .. " วินาที"
        end
    end
end)

-- ฟังก์ชันแสดงเนื้อหา
function showAntiAFK()
    Content:ClearAllChildren()
    selectButton(AntiAFKBtn)

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1,0,0,50)
    infoLabel.Position = UDim2.new(0,0,0,0)
    infoLabel.Text = "ระบบ Anti-AFK\nสถานะ: " .. (antiAFKEnabled and "เปิด" or "ปิด")
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 16
    infoLabel.TextColor3 = Color3.new(1,1,1)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextWrapped = true
    infoLabel.Parent = Content
end

function showPlayerInfo()
    Content:ClearAllChildren()
    selectButton(PlayerInfoBtn)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,30)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.Text = "ชื่อผู้เล่น: " .. player.Name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = Content

    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(1,0,0,30)
    idLabel.Position = UDim2.new(0,0,0,35)
    idLabel.Text = "UserId: " .. player.UserId
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextSize = 16
    idLabel.TextColor3 = Color3.new(1,1,1)
    idLabel.BackgroundTransparency = 1
    idLabel.Parent = Content
end

function showUpdates()
    Content:ClearAllChildren()
    selectButton(UpdatesBtn)

    local updatesLabel = Instance.new("TextLabel")
    updatesLabel.Size = UDim2.new(1,0,1,0)
    updatesLabel.Position = UDim2.new(0,0,0,0)
    updatesLabel.Text = "- v1.0: เปิดตัว Modern Script Hub\n- เพิ่มระบบ Anti-AFK\n- เพิ่มเมนู Player Info และ Updates"
    updatesLabel.Font = Enum.Font.Gotham
    updatesLabel.TextSize = 16
    updatesLabel.TextColor3 = Color3.new(1,1,1)
    updatesLabel.TextWrapped = true
    updatesLabel.BackgroundTransparency = 1
    updatesLabel.Parent = Content
end

PlayerInfoBtn.MouseButton1Click:Connect(showPlayerInfo)
UpdatesBtn.MouseButton1Click:Connect(showUpdates)

-- เปิดหน้าเริ่มต้น
showAntiAFK()

-- Animation เปิด/ปิด UI
local uiOpen = true
local function toggleUI()
    uiOpen = not uiOpen
    local goal = {}
    if uiOpen then
        goal.Position = UDim2.new(0.5, -250, 0.5, -150)
    else
        goal.Position = UDim2.new(0.5, -250, 1.5, 0)
    end
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), goal):Play()
end

ToggleUIBtn.MouseButton1Click:Connect(toggleUI)
