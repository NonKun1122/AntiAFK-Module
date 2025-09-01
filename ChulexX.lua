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
local ScreenGui = script.Parent -- ให้เป็นตัว UI หลัก
local MainFrame = ScreenGui:WaitForChild("MainFrame") -- เปลี่ยนเป็นชื่อ Frame หลัก
local UpdateFrame = MainFrame:WaitForChild("UpdateFrame") -- ช่อง Update
local PlayerFrame = MainFrame:WaitForChild("PlayerFrame") -- ช่อง Player Info
local Buttons = MainFrame:WaitForChild("Buttons")

-- Update Tab
local updateText = UpdateFrame:WaitForChild("TextLabel")
updateText.Text = "🔹 ระบบ Anti AFK\n🔹 ระบบแสดงข้อมูลผู้เล่น\n🔹 UI ใหม่"

-- Player Info Tab
local playerInfo = PlayerFrame:WaitForChild("TextLabel")
playerInfo.Text = "ชื่อ: " .. player.Name ..
                  "\nUserId: " .. player.UserId ..
                  "\nเวลาเข้า: " .. os.date("%H:%M:%S")

-- ปุ่มกดสลับเมนู
for _, button in pairs(Buttons:GetChildren()) do
    if button:IsA("TextButton") then
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
