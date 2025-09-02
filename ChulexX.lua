-- LocalScript ใส่ใน StarterPlayerScripts

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernHubUI"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

-- กรอบหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- UI Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Text = "⚡ Chulex X Hub"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = MainFrame

-- แถบเมนูด้านบน
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 30)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local UIListLayoutTabs = Instance.new("UIListLayout")
UIListLayoutTabs.FillDirection = Enum.FillDirection.Horizontal
UIListLayoutTabs.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutTabs.Padding = UDim.new(0, 8)
UIListLayoutTabs.Parent = TabFrame

-- กรอบเนื้อหา
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Highlight ฟังก์ชัน
local function setHighlight(color)
    if player.Character then
        local old = player.Character:FindFirstChild("GlowHighlight")
        if old then old:Destroy() end

        if color then
            local highlight = Instance.new("Highlight")
            highlight.Name = "GlowHighlight"
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.OutlineColor = color
            highlight.Parent = player.Character
        end
    end
end

-- ฟังก์ชันสร้างแท็บ
local Tabs = {}
local function createTab(name)
    local Button = Instance.new("TextButton")
    Button.Text = name
    Button.Size = UDim2.new(0, 100, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextScaled = true
    Button.Parent = TabFrame

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    Frame.Parent = ContentFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = Frame

    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentFrame:GetChildren()) do
            if v:IsA("Frame") then v.Visible = false end
        end
        Frame.Visible = true
    end)

    Tabs[name] = Frame
end

-- ฟังก์ชันสร้าง Toggle ปุ่ม
local function createToggle(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = text .. " [OFF]"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextScaled = true
    Button.Parent = parent

    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- สร้างแท็บ Misc
createTab("Misc")

-- Anti AFK Toggle
local AntiAFKEnabled = false
createToggle(Tabs["Misc"], "Anti-AFK", function(state)
    AntiAFKEnabled = state
    if state then
        player.Idled:Connect(function()
            if AntiAFKEnabled then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
        setHighlight(Color3.fromRGB(0, 255, 0)) -- เขียว
    else
        setHighlight(nil)
    end
end)

-- God Mode Toggle
local GodModeEnabled = false
createToggle(Tabs["Misc"], "God Mode", function(state)
    GodModeEnabled = state
    if state then
        setHighlight(Color3.fromRGB(255, 255, 0)) -- เหลือง
    else
        setHighlight(nil)
    end
end)

-- เปิดแท็บแรกตอนเริ่ม
Tabs["Misc"].Visible = true

-- Hotkey เปิด/ปิด UI
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
