-- 📌 LocalScript: Chulex X UI + Anti-AFK
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Anti-AFK ตัวแปร
local antiAFKEnabled = false
local startTime = 0

-- UI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChulexX_UI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 50, 0, 50)
Logo.Position = UDim2.new(0, 10, 0, 5)
Logo.Image = "rbxassetid://12345678"
Logo.BackgroundTransparency = 1
Logo.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 70, 0, 5)
Title.Text = "Chulex X"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = TopBar

-- Version
local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 200, 0, 20)
Version.Position = UDim2.new(0, 70, 0, 35)
Version.Text = "v1.0"
Version.TextColor3 = Color3.fromRGB(200, 230, 255)
Version.TextScaled = true
Version.BackgroundTransparency = 1
Version.Font = Enum.Font.Gotham
Version.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 15)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Parent = TopBar

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(1, 0)
UICornerClose.Parent = CloseButton

-- Side Menu
local SideMenu = Instance.new("Frame")
SideMenu.Size = UDim2.new(0, 120, 1, -60)
SideMenu.Position = UDim2.new(0, 0, 0, 60)
SideMenu.BackgroundTransparency = 0.3
SideMenu.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
SideMenu.Parent = MainFrame

local UICornerSide = Instance.new("UICorner")
UICornerSide.CornerRadius = UDim.new(0, 10)
UICornerSide.Parent = SideMenu

-- Menu Buttons
local function createMenuButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    btn.Parent = SideMenu
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    return btn
end

local updateBtn = createMenuButton("Update", 10)
local antiAFKBtn = createMenuButton("Anti-AFK", 60)
local playerBtn = createMenuButton("Player Info", 110)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -140, 1, -80)
ContentFrame.Position = UDim2.new(0, 130, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Anti-AFK Panel
local AntiAFKPanel = Instance.new("Frame")
AntiAFKPanel.Size = UDim2.new(1, 0, 1, 0)
AntiAFKPanel.BackgroundTransparency = 1
AntiAFKPanel.Visible = false
AntiAFKPanel.Parent = ContentFrame

local AFKButton = Instance.new("TextButton")
AFKButton.Size = UDim2.new(0, 150, 0, 50)
AFKButton.Position = UDim2.new(0, 50, 0, 30)
AFKButton.Text = "Anti-AFK: OFF"
AFKButton.TextColor3 = Color3.new(1,1,1)
AFKButton.Font = Enum.Font.GothamBold
AFKButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
AFKButton.Parent = AntiAFKPanel

local UICornerAFK = Instance.new("UICorner")
UICornerAFK.CornerRadius = UDim.new(0, 12)
UICornerAFK.Parent = AFKButton

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0, 200, 0, 30)
TimeLabel.Position = UDim2.new(0, 50, 0, 100)
TimeLabel.Text = "⏱ เวลา: 0 วินาที"
TimeLabel.TextColor3 = Color3.new(1,1,1)
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.BackgroundTransparency = 1
TimeLabel.Parent = AntiAFKPanel

-- Toggle Anti-AFK
local function toggleAntiAFK()
    antiAFKEnabled = not antiAFKEnabled
    if antiAFKEnabled then
        AFKButton.Text = "Anti-AFK: ON"
        AFKButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startTime = tick()
    else
        AFKButton.Text = "Anti-AFK: OFF"
        AFKButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        TimeLabel.Text = "⏱ เวลา: 0 วินาที"
    end
end
AFKButton.MouseButton1Click:Connect(toggleAntiAFK)

-- Update Timer
game:GetService("RunService").RenderStepped:Connect(function()
    if antiAFKEnabled then
        local elapsed = math.floor(tick() - startTime)
        TimeLabel.Text = "⏱ เวลา: " .. elapsed .. " วินาที"
    end
end)

-- Prevent AFK
player.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("✅ Anti-AFK ส่ง fake input")
    end
end)

-- Menu Switching
updateBtn.MouseButton1Click:Connect(function()
    AntiAFKPanel.Visible = false
end)
antiAFKBtn.MouseButton1Click:Connect(function()
    AntiAFKPanel.Visible = true
end)
playerBtn.MouseButton1Click:Connect(function()
    AntiAFKPanel.Visible = false
end)

-- Show/Hide Animation
local function toggleUI()
    if MainFrame.Visible then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -250, 1.2, 0)})
        tween:Play()
        tween.Completed:Wait()
        MainFrame.Visible = false
    else
        MainFrame.Position = UDim2.new(0.5, -250, 1.2, 0)
        MainFrame.Visible = true
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -250, 0.5, -175)})
        tween:Play()
    end
end

CloseButton.MouseButton1Click:Connect(toggleUI)

-- Keybind (กด F4 เพื่อเปิด/ปิด UI)
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.F4 then
        toggleUI()
    end
end)
