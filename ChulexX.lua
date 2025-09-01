-- LocalScript ใน StarterGui

-- Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- UI References
local ScreenGui = script.Parent
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local MainFrame = ScreenGui:WaitForChild("MainFrame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.8, 0, 0.6, 0)

-- ให้ MainFrame มี AspectRatio ปรับตามขนาดหน้าจอ
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.Parent = MainFrame
aspect.AspectRatio = 1.6
aspect.AspectType = Enum.AspectType.ScaleWithParentSize

local UpdateFrame = MainFrame:WaitForChild("UpdateFrame")
local PlayerFrame = MainFrame:WaitForChild("PlayerFrame")
local Buttons = MainFrame:WaitForChild("Buttons")

-- ปรับ TextLabel ให้ขยายเต็ม Frame และปรับข้อความอัตโนมัติ
local function setupLabel(label)
    label.Size = UDim2.new(1, -10, 1, -10)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.TextScaled = true
    label.TextWrapped = true
end

setupLabel(UpdateFrame:WaitForChild("TextLabel"))
setupLabel(PlayerFrame:WaitForChild("TextLabel"))

-- Update Tab
UpdateFrame.TextLabel.Text = "🔹 ระบบ Anti AFK\n🔹 ระบบแสดงข้อมูลผู้เล่น\n🔹 UI ใหม่"

-- Player Info Tab
PlayerFrame.TextLabel.Text = "ชื่อ: " .. player.Name ..
                            "\nUserId: " .. player.UserId ..
                            "\nเวลาเข้า: " .. os.date("%H:%M:%S")

-- ปรับปุ่มให้ใหญ่พอแตะบนมือถือ
for _, button in pairs(Buttons:GetChildren()) do
    if button:IsA("TextButton") then
        button.Size = UDim2.new(0.4, 0, 0.1, 0)
        button.TextScaled = true
        button.TextWrapped = true

        button.MouseButton1Click:Connect(function()
            if button.Name == "UpdateButton" then
                UpdateFrame.Visible = true
                PlayerFrame.Visible = false
            elseif button.Name == "PlayerButton" then
                UpdateFrame.Visible = false
                PlayerFrame.Visible = true
            end
        end)
    end
end

-- เปิดหน้า Update เป็นหน้าแรก
UpdateFrame.Visible = true
PlayerFrame.Visible = false
