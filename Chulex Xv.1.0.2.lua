-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti-AFK
local antiAFKEnabled = false
local antiAFKStartTime = 0

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- ปุ่มเปิด/ปิด UI มุมขวาบน
local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0,50,0,50)
MainButton.Position = UDim2.new(0.93,0,0.05,0)
MainButton.BackgroundColor3 = Color3.fromRGB(20,50,150)
MainButton.BackgroundTransparency = 0.2
MainButton.Text = "☰"
MainButton.TextColor3 = Color3.fromRGB(255,255,255)
MainButton.TextScaled = true
MainButton.Parent = ScreenGui
MainButton.AutoButtonColor = true
MainButton.Font = Enum.Font.GothamBold

-- หน้าต่างหลัก (Frame)
local Window = Instance.new("Frame")
Window.Size = UDim2.new(0,400,0,300)
Window.Position = UDim2.new(0.5,-200,-0.5,0) -- เริ่มซ่อนบนจอ (สำหรับ Animation)
Window.BackgroundColor3 = Color3.fromRGB(0,100,255)
Window.BackgroundTransparency = 0.5
Window.BorderSizePixel = 0
Window.Parent = ScreenGui
Window.ClipsDescendants = true

-- Gradient
local WindowGradient = Instance.new("UIGradient")
WindowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,180,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,80,200))
}
WindowGradient.Rotation = 45
WindowGradient.Parent = Window

-- Header (โลโก้ + ชื่อ + เวอร์ชั่น)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundTransparency = 1
Header.Parent = Window

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0,50,0,50)
Logo.Position = UDim2.new(0,10,0.5,-25)
Logo.Text = "⚡"
Logo.TextScaled = true
Logo.TextColor3 = Color3.fromRGB(255,255,255)
Logo.BackgroundTransparency = 1
Logo.Parent = Header
Logo.Font = Enum.Font.GothamBold

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0,200,0,25)
Title.Position = UDim2.new(0,70,0,10)
Title.Text = "Chulex X Script"
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Parent = Header
Title.Font = Enum.Font.GothamBold

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0,200,0,20)
Version.Position = UDim2.new(0,70,0,35)
Version.Text = "v1.0.0"
Version.TextScaled = true
Version.TextColor3 = Color3.fromRGB(200,200,200)
Version.BackgroundTransparency = 1
Version.Parent = Header
Version.Font = Enum.Font.GothamSemibold

-- เมนูด้านซ้าย
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0,150,1,0)
MenuFrame.Position = UDim2.new(0,0,0,60)
MenuFrame.BackgroundTransparency = 0.4
MenuFrame.BackgroundColor3 = Color3.fromRGB(0,50,150)
MenuFrame.Parent = Window

-- ปุ่ม Anti-AFK
local AFKButton = Instance.new("TextButton")
AFKButton.Size = UDim2.new(1,-20,0,40)
AFKButton.Position = UDim2.new(0,10,0,20)
AFKButton.Text = "⚡ Anti-AFK: OFF"
AFKButton.TextColor3 = Color3.fromRGB(255,255,255)
AFKButton.BackgroundColor3 = Color3.fromRGB(0,120,255)
AFKButton.AutoButtonColor = true
AFKButton.TextScaled = true
AFKButton.Font = Enum.Font.GothamBold
AFKButton.Parent = MenuFrame

-- แถบนับเวลา
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(1,-20,0,30)
TimeLabel.Position = UDim2.new(0,10,0,70)
TimeLabel.Text = "Elapsed: --:--"
TimeLabel.TextColor3 = Color3.fromRGB(255,255,255)
TimeLabel.BackgroundTransparency = 1
TimeLabel.TextScaled = true
TimeLabel.Font = Enum.Font.GothamSemibold
TimeLabel.Parent = MenuFrame

-- ข้อมูลผู้เล่น
local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0,200,0,150)
InfoFrame.Position = UDim2.new(1,-210,0,60)
InfoFrame.BackgroundTransparency = 0.4
InfoFrame.BackgroundColor3 = Color3.fromRGB(0,50,150)
InfoFrame.Parent = Window

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1,-10,1,-10)
InfoLabel.Position = UDim2.new(0,5,0,5)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
InfoLabel.TextScaled = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.Font = Enum.Font.GothamSemibold
InfoLabel.Parent = InfoFrame

-- Toggle Anti-AFK function
AFKButton.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    if antiAFKEnabled then
        AFKButton.Text = "⚡ Anti-AFK: ON"
        antiAFKStartTime = tick()
        AFKButton.BackgroundColor3 = Color3.fromRGB(0,200,255)
    else
        AFKButton.Text = "⚡ Anti-AFK: OFF"
        antiAFKStartTime = 0
        AFKButton.BackgroundColor3 = Color3.fromRGB(0,120,255)
    end
end)

-- ปุ่มเปิด/ปิด UI Animated
local uiOpen = true
MainButton.MouseButton1Click:Connect(function()
    uiOpen = not uiOpen
    local targetPos = uiOpen and UDim2.new(0.5,-200,0.5,-150) or UDim2.new(0.5,-200,-0.5,0)
    TweenService:Create(Window, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
end)

-- กัน AFK
player.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- อัปเดตข้อมูล + เวลาเรียลไทม์
RunService.RenderStepped:Connect(function()
    local elapsed = antiAFKStartTime > 0 and math.floor(tick() - antiAFKStartTime) or 0
    local minutes = math.floor(elapsed/60)
    local seconds = elapsed % 60
    local timeText = string.format("%02d:%02d", minutes, seconds)
    TimeLabel.Text = "Elapsed: " .. (antiAFKEnabled and timeText or "--:--")
    
    InfoLabel.Text = string.format("Name: %s\nUserId: %d\nAnti-AFK: %s\nElapsed: %s",
        player.Name, player.UserId, antiAFKEnabled and "ON" or "OFF", antiAFKEnabled and timeText or "--:--")
end)
