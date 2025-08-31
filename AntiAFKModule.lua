-- AntiAFKModule.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local module = {}
module.isActive = false -- สถานะ Anti-AFK

function module.Start()
    local player = Players.LocalPlayer

    -- ป้องกัน AFK
    player.Idled:Connect(function()
        if module.isActive then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            warn("✅ Anti-AFK: Fake input sent")
        end
    end)

    -- เคลื่อนที่เล็กน้อย
    RunService.RenderStepped:Connect(function()
        if module.isActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.new(math.sin(tick())*0.1,0,0)
        end
    end)
end

function module.Toggle()
    module.isActive = not module.isActive
    return module.isActive
end

return module
