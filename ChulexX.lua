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
local dragging = false
local dragInput, dragStart, startPos

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

-- Draggable
local function drag(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

drag(MainFrame)

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

-- Sidebar Tabs (แนวตั้ง)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,120,1,-60)
Sidebar.Position = UDim2.new(0,10,0,70)
Sidebar.BackgroundColor3 = Color3.fromRGB(30,30,30)
Sidebar.Parent = MainFrame
local UICornerSide = Instance.new("UICorner", Sidebar)
UICornerSide.CornerRadius = UDim.new(0,10)

local function createTab(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,40)
    btn.Position = UDim2.new(0,5,0,posY)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Parent = Sidebar
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,6)
    return btn
end

local UpdateTab = createTab("Update |", 0)
local MissTab = createTab("Miss |", 50)
local InfoTab = createTab("Info", 100)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-150,1,-80)
ContentFrame.Position = UDim2.new(0,140,0,70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Pages
local Pages = {}

-- Page Update
local UpdatePage = Instance.new("ScrollingFrame")
UpdatePage.Size = UDim2.new(1,0,1,0)
UpdatePage.BackgroundTransparency = 1
UpdatePage.ScrollBarThickness = 8
UpdatePage.CanvasSize = UDim2.new(0,0,0,200)
UpdatePage.Parent = ContentFrame

local UpdateLabel = Instance.new("TextLabel")
UpdateLabel.Text = "- v1.0.0: Initial Release\n- v1.0.1: Added God Mode toggle\n- v1.0.2: Added Player Info tab"
UpdateLabel.Font = Enum.Font.Gotham
UpdateLabel.TextSize = 16
UpdateLabel.TextColor3 = Color3.fromRGB(255,255,255)
UpdateLabel.TextWrapped = true
UpdateLabel.BackgroundTransparency = 1
UpdateLabel.Size = UDim2.new(1,0,0,200)
UpdateLabel.Parent = UpdatePage

Pages["Update"] = UpdatePage

-- Page Miss
local MissPage = Instance.new("Frame")
MissPage.Size = UDim2.new(1,0,1,0)
MissPage.BackgroundTransparency = 1
MissPage.Visible = false
MissPage.Parent = ContentFrame

local AntiAFKBtn = Instance.new("TextButton")
AntiAFKBtn.Size = UDim2.new(0,200,0,50)
AntiAFKBtn.Position = UDim2.new(0,10,0,20)
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

local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(0,200,0,50)
GodBtn.Position = UDim2.new(0,10,0,90)
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
local InfoPage = Instance.new("ScrollingFrame")
InfoPage.Size = UDim2.new(1,0,1,0)
InfoPage.BackgroundTransparency = 1
InfoPage.ScrollBarThickness = 8
InfoPage.CanvasSize = UDim2.new(0,0,0,200)
InfoPage.Visible = false
InfoPage.Parent = ContentFrame

local playerInfo = Instance.new("TextLabel")
playerInfo.Font = Enum.Font.Gotham
playerInfo.TextSize = 16
playerInfo.TextColor3 = Color3.fromRGB(255,255,255)
playerInfo.BackgroundTransparency = 1
playerInfo.Size = UDim2.new(1,0,0,200)
playerInfo.TextWrapped = true
playerInfo.Parent = InfoPage

Pages["Info"] = InfoPage

-- Tab switching with Active Highlight & Hover
local activeTab = "Update"
local function setActiveTab(tabName)
    activeTab = tabName
    local tabs = {UpdateTab, MissTab, InfoTab}
    for _,btn in pairs(tabs) do
        if btn.Text:find(tabName) then
            btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
        else
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        end
    end
    switchTab(tabName)
end

local function addHover(btn, name)
    btn.MouseEnter:Connect(function() if activeTab ~= name then btn.BackgroundColor3 = Color3.fromRGB(70,70,70) end end)
    btn.MouseLeave:Connect(function() if activeTab ~= name then btn.BackgroundColor3 = Color3.fromRGB(50,50,50) end end)
end

addHover(UpdateTab,"Update")
addHover(MissTab,"Miss")
addHover(InfoTab,"Info")

UpdateTab.MouseButton1Click:Connect(function() setActiveTab("Update") end)
MissTab.MouseButton1Click:Connect(function() setActiveTab("Miss") end)
InfoTab.MouseButton1Click:Connect(function() setActiveTab("Info") end)

-- Default page
setActiveTab("Update")

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

-- UI Toggle Button (ติด MainFrame)
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
