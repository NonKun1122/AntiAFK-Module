-- LocalScript
-- Modern UI + Anti-AFK + Sidebar Menu

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Anti-AFK สถานะ
local antiAFKEnabled = false
local afkTime = 0
local counting = false

-- UI หลัก
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

-- Frame หลัก (หน้าต่างใหญ่)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Parent = ScreenGui

-- Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 120))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,15)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundTransparency = 0.5
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,10)

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 60, 0, 60)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6031071057" -- ไอคอน (เปลี่ยนตามต้องการ)
Logo.Parent = Sidebar

-- ชื่อสคริปต์
local ScriptName = Instance.new("TextLabel")
ScriptName.Text = "My Script"
ScriptName.Font = Enum.Font.GothamBold
ScriptName.TextSize = 16
ScriptName.TextColor3 = Color3.fromRGB(255,255,255)
ScriptName.Position = UDim2.new(0, 80, 0, 15)
ScriptName.BackgroundTransparency = 1
ScriptName.Parent = Sidebar

-- เวอร์ชัน
local Version = Instance.new("TextLabel")
Version.Text = "v1.0.0"
Version.Font = Enum.Font.Gotham
Version.TextSize = 12
Version.TextColor3 = Color3.fromRGB(180,180,180)
Version.Position = UDim2.new(0, 80, 0, 40)
Version.BackgroundTransparency = 1
Version.Parent = Sidebar

-- ปุ่มเมนู
local function createMenuButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 80 + (order*45))
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(0,120,255)
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    btn.Parent = Sidebar
    return btn
end

local btnUpdate = createMenuButton("Update",0)
local btnAntiAFK = createMenuButton("Anti AFK",1)
local btnPlayer = createMenuButton("Player",2)

-- Content Panel
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-160,1,-20)
Content.Position = UDim2.new(0,160,0,10)
Content.BackgroundTransparency = 0.3
Content.BackgroundColor3 = Color3.fromRGB(10,30,60)
Content.Parent = MainFrame
Instance.new("UICorner", Content).CornerRadius = UDim.new(0,10)

-- หัวข้อ
local Title = Instance.new("TextLabel")
Title.Text = "Update"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Position = UDim2.new(0,10,0,10)
Title.BackgroundTransparency = 1
Title.Parent = Content

-- Anti-AFK UI (นับเวลา)
local AFKLabel = Instance.new("TextLabel")
AFKLabel.Text = "Anti-AFK: OFF | Time: 0s"
AFKLabel.Font = Enum.Font.Gotham
AFKLabel.TextSize = 14
AFKLabel.TextColor3 = Color3.fromRGB(255,255,255)
AFKLabel.Position = UDim2.new(0,10,0,50)
AFKLabel.BackgroundTransparency = 1
AFKLabel.Parent = Content

-- ปุ่มสลับ Anti-AFK
local ToggleAFK = Instance.new("TextButton")
ToggleAFK.Size = UDim2.new(0,120,0,40)
ToggleAFK.Position = UDim2.new(0,10,0,90)
ToggleAFK.Text = "Start Anti-AFK"
ToggleAFK.Font = Enum.Font.GothamBold
ToggleAFK.TextSize = 14
ToggleAFK.TextColor3 = Color3.fromRGB(255,255,255)
ToggleAFK.BackgroundColor3 = Color3.fromRGB(0,120,255)
Instance.new("UICorner", ToggleAFK).CornerRadius = UDim.new(0,8)
ToggleAFK.Parent = Content

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-45,0,5)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)
CloseBtn.Parent = MainFrame

-- Animation เปิด/ปิด UI
local uiVisible = true
local function toggleUI()
    if uiVisible then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5,-250,1.5,0)})
        tween:Play()
        uiVisible = false
    else
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5,-250,0.5,-150)})
        tween:Play()
        uiVisible = true
    end
end
CloseBtn.MouseButton1Click:Connect(toggleUI)

-- Toggle Anti-AFK
ToggleAFK.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    if antiAFKEnabled then
        ToggleAFK.Text = "Stop Anti-AFK"
        ToggleAFK.BackgroundColor3 = Color3.fromRGB(50,200,50)
        AFKLabel.Text = "Anti-AFK: ON | Time: 0s"
        afkTime = 0
        counting = true
    else
        ToggleAFK.Text = "Start Anti-AFK"
        ToggleAFK.BackgroundColor3 = Color3.fromRGB(0,120,255)
        AFKLabel.Text = "Anti-AFK: OFF | Time: 0s"
        counting = false
    end
end)

-- กัน AFK
player.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("Anti-AFK: Fake input sent")
    end
end)

-- นับเวลา
task.spawn(function()
    while true do
        task.wait(1)
        if counting then
            afkTime = afkTime + 1
            AFKLabel.Text = "Anti-AFK: ON | Time: "..afkTime.."s"
        end
    end
end)
