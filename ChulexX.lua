-- ฟังก์ชันรีเซ็ตสีปุ่ม
local function resetButtonColors()
    AntiAFKBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
    PlayerInfoBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
    UpdatesBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
end

-- ฟังก์ชันเลือกปุ่ม
local function selectButton(btn)
    resetButtonColors()
    btn.BackgroundColor3 = Color3.fromRGB(0,200,255) -- สีปุ่ม Active
end

-- ฟังก์ชันแสดงเนื้อหา
local function showAntiAFK()
    Content:ClearAllChildren()
    selectButton(AntiAFKBtn)

    -- ตัวอย่างเนื้อหา Anti-AFK
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1,0,0,50)
    infoLabel.Position = UDim2.new(0,0,0,0)
    infoLabel.Text = "ระบบ Anti-AFK\nสถานะ: " .. (antiAFKEnabled and "เปิด" or "ปิด")
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 16
    infoLabel.TextColor3 = Color3.new(1,1,1)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextWrapped = true
    infoLabel.Parent = Content
end

local function showPlayerInfo()
    Content:ClearAllChildren()
    selectButton(PlayerInfoBtn)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0,30)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.Text = "ชื่อผู้เล่น: " .. player.Name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 16
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = Content

    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(1,0,0,30)
    idLabel.Position = UDim2.new(0,0,0,35)
    idLabel.Text = "UserId: " .. player.UserId
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextSize = 16
    idLabel.TextColor3 = Color3.new(1,1,1)
    idLabel.BackgroundTransparency = 1
    idLabel.Parent = Content
end

local function showUpdates()
    Content:ClearAllChildren()
    selectButton(UpdatesBtn)

    local updatesLabel = Instance.new("TextLabel")
    updatesLabel.Size = UDim2.new(1,0,1,0)
    updatesLabel.Position = UDim2.new(0,0,0,0)
    updatesLabel.Text = "- v1.0: เปิดตัว Modern Script Hub\n- เพิ่มระบบ Anti-AFK\n- เพิ่มเมนู Player Info และ Updates"
    updatesLabel.Font = Enum.Font.Gotham
    updatesLabel.TextSize = 16
    updatesLabel.TextColor3 = Color3.new(1,1,1)
    updatesLabel.TextWrapped = true
    updatesLabel.BackgroundTransparency = 1
    updatesLabel.Parent = Content
end

-- เชื่อมปุ่มกับฟังก์ชัน
AntiAFKBtn.MouseButton1Click:Connect(showAntiAFK)
PlayerInfoBtn.MouseButton1Click:Connect(showPlayerInfo)
UpdatesBtn.MouseButton1Click:Connect(showUpdates)

-- เปิดหน้าเริ่มต้น
showAntiAFK()
