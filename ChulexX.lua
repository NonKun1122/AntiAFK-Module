-- LocalScript ใน StarterGui

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local AntiAFKEnabled = false
local GodModeEnabled = false
local startTime = tick()
local uiVisible = true

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChulexX_HUB"
ScreenGui.Parent = playerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.3, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0,12)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Chulex X HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,10)
Title.Parent = MainFrame

local Version = Instance.new("TextLabel")
Version.Text = "V1.0.0"
Version.Font = Enum.Font.Gotham
Version.TextSize = 16
Version.TextColor3 = Color3.fromRGB(255,255,255)
Version.BackgroundTransparency = 1
Version.Size = UDim2.new(1,0,0,20)
Version.Position = UDim2.new(0,0,0,40)
Version.Parent = MainFrame

-- Header Tabs
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1,0,0,30)
HeaderFrame.Position = UDim2.new(0,0,0,70)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.Parent = MainFrame

local function createTab(name, positionX)
    local tab = Instance.new("TextButton")
    tab.Text = name
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 16
    tab.TextColor3 = Color3.fromRGB(255,255,255)
    tab.BackgroundColor3 = Color3.fromRGB(30,30,30)
    tab.Size = UDim2.new(0,150,1,0)
    tab.Position = UDim2.new(0,positionX,0,0)
    tab.Parent = HeaderFrame
    local corner = Instance.new("UICorner", tab)
    corner.CornerRadius = UDim.new(0,8)
    return tab
end

local UpdateTab = createTab("Update", 10)
local MissTab = createTab("Miss", 170)
local InfoTab = createTab("Info", 330)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-20,1,-120)
ContentFrame.Position = UDim2.new(0,10,0,110)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Pages
local Pages = {}

-- Page Update
local UpdatePage = Instance.new("Frame")
UpdatePage.Size = UDim2.new(1,0,1,0)
UpdatePage.BackgroundTransparency = 1
UpdatePage.Parent = ContentFrame

local UpdateLabel = Instance.new("TextLabel")
UpdateLabel.Text = "- v1.0.0: Initial Release\n- v1.0.1: Added God Mode toggle\n- v1.0.2: Added Player Info tab"
UpdateLabel.Font = Enum.Font.Gotham
UpdateLabel.TextSize = 16
UpdateLabel.TextColor3 = Color3.fromRGB(255,255,255)
UpdateLabel.TextWrapped = true
UpdateLabel.BackgroundTransparency = 1
UpdateLabel.Size = UDim2.new(1,0,1,0)
UpdateLabel.Parent = UpdatePage

Pages["Update"] = UpdatePage

-- Page Miss
local MissPage = Instance.new("Frame")
MissPage.Size = UDim2.new(1,0,1,0)
MissPage.BackgroundTransparency = 1
MissPage.Visible = false
MissPage.Parent = ContentFrame

-- Anti-AFK Toggle
local AntiAFKBtn = Instance.new("TextButton")
AntiAFKBtn.Size = UDim2.new(0,200,0,50)
AntiAFKBtn.Position = UDim2.new(0,20,0,20)
AntiAFKBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
AntiAFKBtn.TextColor3 = Color3.fromRGB(255,255,255)
AntiAFKBtn.Font = Enum.Font.GothamBold
AntiAFKBtn.TextSize = 18
AntiAFKBtn.Text = "Anti-AFK [OFF]"
AntiAFKBtn.Parent = MissPage
local corner1 = Instance.new("UICorner", AntiAFKBtn)
corner1.CornerRadius = UDim.new(0,8)

AntiAFKBtn.MouseButton1Click:Connect(function()
    AntiAFKEnabled = not AntiAFKEnabled
    AntiAFKBtn.Text = "Anti-AFK ["..(AntiAFKEnabled and "ON" or "OFF").."]"
    if AntiAFKEnabled then
        setHighlight(Color3.fromRGB(0,255,0))
    else
        setHighlight(nil)
    end
end)

-- God Mode Toggle
local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(0,200,0,50)
GodBtn.Position = UDim2.new(0,20,0,90)
GodBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
GodBtn.TextColor3 = Color3.fromRGB(255,255,255)
GodBtn.Font = Enum.Font.GothamBold
GodBtn.TextSize = 18
GodBtn.Text = "God Mode [OFF]"
GodBtn.Parent = MissPage
local corner2 = Instance.new("UICorner", GodBtn)
corner2.CornerRadius = UDim.new(0,8)

GodBtn.MouseButton1Click:Connect(function()
    GodModeEnabled = not GodModeEnabled
    GodBtn.Text = "God Mode ["..(GodModeEnabled and "ON" or "OFF").."]"
    if GodModeEnabled then
        setHighlight(Color3.fromRGB(255,255,0))
    else
        setHighlight(nil)
    end
end)

Pages["Miss"] = MissPage

-- Page Info
local InfoPage = Instance.new("Frame")
InfoPage.Size = UDim2.new(1,0,1,0)
InfoPage.BackgroundTransparency = 1
InfoPage.Visible = false
InfoPage.Parent = ContentFrame

local playerInfo = Instance.new("TextLabel")
playerInfo.Font = Enum.Font.Gotham
playerInfo.TextSize = 16
playerInfo.TextColor3 = Color3.fromRGB(255,255,255)
playerInfo.BackgroundTransparency = 1
playerInfo.Size = UDim2.new(1,0,1,0)
playerInfo.TextWrapped = true
playerInfo.Parent = InfoPage

Pages["Info"] = InfoPage

-- Tab Buttons
local function switchTab(name)
    for k,v in pairs(Pages) do
        v.Visible = false
    end
    Pages[name].Visible = true
end

UpdateTab.MouseButton1Click:Connect(function() switchTab("Update") end)
MissTab.MouseButton1Click:Connect(function() switchTab("Miss") end)
InfoTab.MouseButton1Click:Connect(function() switchTab("Info") end)

-- Default page
switchTab("Update")

-- Anti-AFK behavior
player.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Highlight function
function setHighlight(color)
    if player.Character then
        local old = player.Character:FindFirstChild("GlowHighlight")
        if old then old:Destroy() end
        if color then
            local hl = Instance.new("Highlight")
            hl.Name = "GlowHighlight"
            hl.FillTransparency = 1
            hl.OutlineTransparency = 0
            hl.OutlineColor = color
            hl.Parent = player.Character
        end
    end
end

-- Update Player Info every second
RunService.RenderStepped:Connect(function()
    local elapsed = math.floor(tick() - startTime)
    local mins = math.floor(elapsed/60)
    local secs = elapsed%60
    playerInfo.Text = "Player: "..player.Name.."\nPlayTime: "..mins.."m "..secs.."s"
end)

-- UI Toggle Button (มุมขวาบน)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0,40,0,40)
ToggleBtn.Position = UDim2.new(1,-50,0,10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
ToggleBtn.Text = "☰"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextScaled = true
ToggleBtn.Parent = MainFrame
local cornerToggle = Instance.new("UICorner", ToggleBtn)
cornerToggle.CornerRadius = UDim.new(0,8)

ToggleBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
end)

-- Hotkey RightShift
UserInputService.InputBegan:Connect(function(input,gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        uiVisible = not uiVisible
        MainFrame.Visible = uiVisible
    end
end)
