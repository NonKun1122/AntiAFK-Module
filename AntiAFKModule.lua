local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- สถานะ Anti-AFK
local antiAFKEnabled = false
local antiAFKStartTime = 0

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- ปุ่มเล็กมุมขวาบน (เปิด/ปิด UI) พร้อมไอคอน
local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0,50,0,50)
MainButton.Position = UDim2.new(0.93,0,0.05,0)
MainButton.BackgroundTransparency = 0.2
MainButton.Text = "≡" -- ไอคอน
MainButton.TextColor3 = Color3.fromRGB(255,255,255)
MainButton.TextScaled = true
MainButton.Parent = ScreenGui
MainButton.AutoButtonColor = true
MainButton.BackgroundColor3 = Color3.fromRGB(20,50,150)
MainButton.Font = Enum.Font.GothamBold

-- กรอบ UI โมเดิร์น พร้อม Gradient
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,280,0,180)
Frame.Position = UDim2.new(0.7,0,0.05,0)
Frame.BackgroundColor3 = Color3.fromRGB(0,100,255)
Frame.BackgroundTransparency = 0
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

-- Gradient ให้กรอบ UI
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
}
uiGradient.Rotation = 45
uiGradient.Parent = Frame

-- ข้อมูลผู้เล่น
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1,-20,0.5,0)
InfoLabel.Position = UDim2.new(0,10,0,10)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
InfoLabel.TextScaled = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.Text = ""
InfoLabel.Font = Enum.Font.GothamSemibold
InfoLabel.Parent = Frame

-- ปุ่ม Toggle Anti-AFK โมเดิร์น พร้อม Gradient และไอคอน
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0,240,0,45)
ToggleButton.Position = UDim2.new(0.5,-120,0.55,0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,150,255)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Text = "⚡ Anti-AFK: OFF" -- ไอคอน ⚡
ToggleButton.TextScaled = true
ToggleButton.Parent = Frame
ToggleButton.AutoButtonColor = true
ToggleButton.Font = Enum.Font.GothamBold

-- Gradient ให้ปุ่ม
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,180,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,200))
}
buttonGradient.Rotation = 90
buttonGradient.Parent = ToggleButton

-- ปุ่มปิด UI
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,35,0,35)
CloseButton.Position = UDim2.new(1,-40,0,5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Text = "✖" -- ไอคอน X
CloseButton.TextScaled = true
CloseButton.Parent = Frame
CloseButton.AutoButtonColor = true
CloseButton.Font = Enum.Font.GothamBold

-- ฟังก์ชัน Toggle Anti-AFK
local function toggleAntiAFK()
    antiAFKEnabled = not antiAFKEnabled
    if antiAFKEnabled then
        ToggleButton.Text = "⚡ Anti-AFK: ON"
        antiAFKStartTime = tick()
    else
        ToggleButton.Text = "⚡ Anti-AFK: OFF"
        antiAFKStartTime = 0
    end
end
ToggleButton.MouseButton1Click:Connect(toggleAntiAFK)

-- เปิด/ปิด UI
MainButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- กัน AFK
player.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- อัปเดตข้อมูลผู้เล่น + เวลาเรียลไทม์
RunService.RenderStepped:Connect(function()
    local elapsed = antiAFKStartTime > 0 and math.floor(tick() - antiAFKStartTime) or 0
    local minutes = math.floor(elapsed / 60)
    local seconds = elapsed % 60
    local timeText = string.format("%02d:%02d", minutes, seconds)
    InfoLabel.Text = string.format("Name: %s\nUserId: %d\nAnti-AFK: %s\nElapsed: %s",
        player.Name, player.UserId, antiAFKEnabled and "ON" or "OFF", antiAFKEnabled and timeText or "--:--")
end)
