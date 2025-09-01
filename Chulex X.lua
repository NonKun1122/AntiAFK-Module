-- Modern_AntiAFK_UI.lua
-- LocalScript (วางใน StarterPlayer > StarterPlayerScripts)
-- UI โมเดิร์นกลางจอ, Sidebar, Pages system, Anti-AFK, Animated show/hide
-- วิธีใช้ (สรุป):
-- 1) วางไฟล์นี้เป็น LocalScript ใน StarterPlayerScripts
-- 2) ปรับค่า logoAssetId ถ้าต้องการ
-- 3) เพิ่มหน้าใหม่ด้วย UI.AddPage(name, iconAssetId, builderFunction)
-- 4) เพิ่มข้อความอัปเดต: UI.AddUpdate(text)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- === ปรับค่าตรงนี้ ===
local logoAssetId = "rbxassetid://6031075930" -- เปลี่ยนเป็นโลโก้ของคุณ
local defaultVersion = "v1.0.0"
-- ======================

-- State
local antiAFKEnabled = false
local antiAFKStart = 0
local afkSeconds = 0

-- UI root
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernScriptHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Helper
local function makeUICorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function makeLabel(parent, props)
    local lbl = Instance.new("TextLabel")
    for k,v in pairs(props or {}) do lbl[k] = v end
    lbl.BackgroundTransparency = lbl.BackgroundTransparency or 1
    lbl.Parent = parent
    return lbl
end

local function makeButton(parent, props)
    local btn = Instance.new("TextButton")
    for k,v in pairs(props or {}) do btn[k] = v end
    btn.AutoButtonColor = true
    btn.Parent = parent
    return btn
end

-- Open toggle (เล็กๆ ติดมุม) ----------------------------------
local openBtn = Instance.new("ImageButton")
openBtn.Name = "OpenUIBtn"
openBtn.Size = UDim2.new(0,44,0,44)
openBtn.Position = UDim2.new(0, 12, 0, 12)
openBtn.AnchorPoint = Vector2.new(0,0)
openBtn.BackgroundTransparency = 0
openBtn.BackgroundColor3 = Color3.fromRGB(6,85,179)
openBtn.Image = "rbxassetid://3926305904" -- generic icon sheet
openBtn.ImageRectOffset = Vector2.new(964, 324)
openBtn.ImageRectSize = Vector2.new(36, 36)
makeUICorner(openBtn, 12)
openBtn.Parent = screenGui

-- Main window frame -----------------------------------------
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 640, 0, 420)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundTransparency = 0.5
main.BackgroundColor3 = Color3.fromRGB(10,30,80)
main.Visible = false
main.Parent = screenGui
makeUICorner(main, 14)

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,60,160))
}
grad.Rotation = 40
grad.Parent = main

-- Shadow (optional subtle)
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.6
shadow.Parent = main

-- Header area ------------------------------------------------
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 80)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundTransparency = 1
header.Parent = main

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,72,0,72)
logo.Position = UDim2.new(0,12,0,4)
logo.BackgroundTransparency = 1
logo.Image = logoAssetId
logo.Parent = header

local titleLabel = makeLabel(header, {
    Size = UDim2.new(0, 300, 0, 28),
    Position = UDim2.new(0, 96, 0, 12),
    Text = "Script Name",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextXAlignment = Enum.TextXAlignment.Left
})

local versionLabel = makeLabel(header, {
    Size = UDim2.new(0, 300, 0, 20),
    Position = UDim2.new(0, 96, 0, 40),
    Text = defaultVersion,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(200,220,255),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Close button ------------------------------------------------
local closeBtn = makeButton(main, {
    Name = "CloseBtn",
    Size = UDim2.new(0,40,0,40),
    Position = UDim2.new(1, -52, 0, 12),
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundColor3 = Color3.fromRGB(200,60,60)
})
makeUICorner(closeBtn, 8)

-- Body: sidebar + content -----------------------------------
local body = Instance.new("Frame")
body.Size = UDim2.new(1, -24, 1, -100)
body.Position = UDim2.new(0,12,0,88)
body.BackgroundTransparency = 1
body.Parent = main

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.Position = UDim2.new(0,0,0,0)
sidebar.BackgroundTransparency = 0.35
sidebar.BackgroundColor3 = Color3.fromRGB(6,60,140)
sidebar.Parent = body
makeUICorner(sidebar, 12)

local contentHolder = Instance.new("Frame")
contentHolder.Size = UDim2.new(1, -200, 1, 0)
contentHolder.Position = UDim2.new(0, 200, 0, 0)
contentHolder.BackgroundTransparency = 1
contentHolder.Parent = body

-- Pages container (each page is a Frame parented here)
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, 0, 1, 0)
pagesContainer.Position = UDim2.new(0,0,0,0)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = contentHolder

-- Sidebar header (logo + name placed inside header area already)
-- Menu buttons function
local menuButtons = {}
local pages = {}

local function createSidebarButton(text, iconAsset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 44)
    btn.Position = UDim2.new(0, 12, 0, 12 + (#menuButtons * 52))
    btn.BackgroundColor3 = Color3.fromRGB(0,120,220)
    btn.Text = "    " .. text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    makeUICorner(btn, 10)

    -- icon
    if iconAsset then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 22, 0, 22)
        icon.Position = UDim2.new(0, 8, 0, 11)
        icon.BackgroundTransparency = 1
        icon.Image = iconAsset
        icon.Parent = btn
    end

    btn.Parent = sidebar
    table.insert(menuButtons, btn)
    return btn
end

-- Page registration API
local UI = {}
function UI.AddPage(name, iconAsset, builder)
    -- create page frame
    local pageFrame = Instance.new("Frame")
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.Visible = false
    pageFrame.Parent = pagesContainer

    -- call builder to populate page content
    if type(builder) == "function" then
        builder(pageFrame)
    end

    -- create sidebar button
    local btn = createSidebarButton(name, iconAsset)
    btn.MouseButton1Click:Connect(function()
        -- hide other pages
        for _,p in pairs(pages) do p.frame.Visible = false end
        pageFrame.Visible = true
    end)

    pages[name] = {frame = pageFrame, button = btn}
    -- auto-show first page added
    if not next(pages) or (#(table.move or {} ) == 0 and #menuButtons == 1) then
        pageFrame.Visible = true
    end
    return pageFrame
end

-- Helper: add update log area
local updatesList
local function createUpdatePage()
    local page = UI.AddPage("Update", "rbxassetid://6031097221", function(frame)
        local title = makeLabel(frame, {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0,10,0,0), Text = "Update log:", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(255,255,255)})

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, -20, 1, -40)
        scroll.Position = UDim2.new(0,10,0,40)
        scroll.BackgroundTransparency = 1
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.ScrollBarThickness = 6
        scroll.Parent = frame

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = scroll

        updatesList = scroll

        -- helper to add an update
        function UI.AddUpdate(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 40)
            lbl.BackgroundTransparency = 0.4
            lbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
            lbl.TextColor3 = Color3.fromRGB(230,230,230)
            lbl.TextWrapped = true
            lbl.Text = text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            makeUICorner(lbl, 8)
            lbl.Parent = scroll

            -- update canvas
            scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 12)
        end
    end)
end

-- Create Anti-AFK page
local function createAntiAFKPage()
    local page = UI.AddPage("Anti AFK", "rbxassetid://6034509993", function(frame)
        local title = makeLabel(frame, {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0,10,0,0), Text = "Anti-AFK", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(255,255,255)})

        local desc = makeLabel(frame, {Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0,10,0,34), Text = "Prevent idle kick by sending small input.", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.fromRGB(220,220,220), TextWrapped = true})

        local timerLabel = makeLabel(frame, {Size = UDim2.new(0, 200, 0, 26), Position = UDim2.new(0,10,0,80), Text = "Elapsed: --:--", Font = Enum.Font.GothamSemibold, TextSize = 16, TextColor3 = Color3.fromRGB(200,200,255)})

        local toggleBtn = makeButton(frame, {Size = UDim2.new(0,140,0,40), Position = UDim2.new(0,10,0,120), Text = "Start Anti-AFK", BackgroundColor3 = Color3.fromRGB(0,120,220), Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255)})
        makeUICorner(toggleBtn, 10)

        -- page-specific behaviour
        local startTime = 0
        local running = false

        toggleBtn.MouseButton1Click:Connect(function()
            running = not running
            antiAFKEnabled = running
            if running then
                toggleBtn.Text = "Stop Anti-AFK"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(40,200,140)
                startTime = tick()
            else
                toggleBtn.Text = "Start Anti-AFK"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(0,120,220)
                startTime = 0
                timerLabel.Text = "Elapsed: --:--"
            end
        end)

        -- update timer
        RunService.Heartbeat:Connect(function()
            if running and startTime > 0 then
                local dt = math.floor(tick() - startTime)
                local mm = math.floor(dt/60)
                local ss = dt % 60
                timerLabel.Text = string.format("Elapsed: %02d:%02d", mm, ss)
            end
        end)

        -- store references if needed
        pages["Anti AFK"].timerLabel = timerLabel
        pages["Anti AFK"].toggle = toggleBtn
    end)
end

-- Create Player page
local function createPlayerPage()
    local page = UI.AddPage("Player", "rbxassetid://6034509992", function(frame)
        local title = makeLabel(frame, {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0,10,0,0), Text = "Player Info", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.fromRGB(255,255,255)})

        local nameLbl = makeLabel(frame, {Size = UDim2.new(0,300,0,26), Position = UDim2.new(0,10,0,40), Text = "Name: " .. player.Name, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(240,240,255)})
        local idLbl = makeLabel(frame, {Size = UDim2.new(0,300,0,26), Position = UDim2.new(0,10,0,68), Text = "UserId: " .. tostring(player.UserId), Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(240,240,255)})

        -- playtime placeholder (local) - you can implement server-tracked playtime
        local playtimeLbl = makeLabel(frame, {Size = UDim2.new(0,300,0,26), Position = UDim2.new(0,10,0,96), Text = "Session time: 0s", Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(200,200,255)})

        -- update playtime
        local sessStart = tick()
        RunService.Heartbeat:Connect(function()
            local t = math.floor(tick() - sessStart)
            playtimeLbl.Text = "Session time: " .. t .. "s"
        end)
    end)
end

-- Build pages
createUpdatePage()
createAntiAFKPage()
createPlayerPage()

-- Convenience: select first page
for name, p in pairs(pages) do
    p.frame.Visible = false
end
-- show Update by default if exists
if pages.Update then pages.Update.frame.Visible = true end

-- UI.AddPage usage example is available in the script header
-- Extra helper: AddUpdate function (already defined in createUpdatePage as UI.AddUpdate)

-- Toggle show/hide main window (animated)
local showing = false
local function showWindow()
    if showing then return end
    showing = true
    main.Visible = true
    main.Position = UDim2.new(0.5, 0, 1.5, 0)
    TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
end
local function hideWindow()
    if not showing then return end
    showing = false
    local t = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1.5, 0)})
    t:Play()
    t.Completed:Wait()
    main.Visible = false
end

openBtn.MouseButton1Click:Connect(function()
    if main.Visible then hideWindow() else showWindow() end
end)

closeBtn.MouseButton1Click:Connect(hideWindow)

-- Prevent AFK kick (global listener)
player.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Example: pre-populate some updates
if UI.AddUpdate then
    UI.AddUpdate("v1.0.0 - Initial release: Modern UI + Anti-AFK + Player info")
    UI.AddUpdate("v1.0.1 - Minor UI tweaks and bugfixes")
end

-- Expose UI table for runtime extension (developer can call via command bar in Studio for testing)
getgenv = getgenv or function() return _G end
getgenv().ModernUI = UI

-- End of script
