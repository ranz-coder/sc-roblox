-- =============================================================================
-- PROJECT NAME: Laper Gank Admin - Lightweight ESP & TP Edition
-- STATUS: 100% Anti-Ghost UI / Solid Click Detection
-- =============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local selectedPlayer = nil
local isTeleporting = false

local ESPSettings = {
    Box = false,
    Name = false
}

-- -----------------------------------------------------------------------------
-- PEMBERSIHAN GUI LAMA (Agar tidak double)
-- -----------------------------------------------------------------------------
local guiName = "LaperGankHub"
local targetParent = CoreGui
if not pcall(function() local a = CoreGui.Name end) then
    targetParent = localPlayer:WaitForChild("PlayerGui")
end

local oldGui = targetParent:FindFirstChild(guiName)
if oldGui then oldGui:Destroy() end

-- -----------------------------------------------------------------------------
-- FUNGSI DRAGGABLE (Bisa digeser)
-- -----------------------------------------------------------------------------
local function makeDraggable(gui, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- -----------------------------------------------------------------------------
-- PEMBUATAN UI UTAMA
-- -----------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = targetParent

-- FRAME UTAMA
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 320)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- TOP BAR (Untuk Geser)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
topBar.BorderSizePixel = 0
topBar.Active = true
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

-- PENUTUP SUDUT BAWAH TOPBAR
local topBarCover = Instance.new("Frame")
topBarCover.Size = UDim2.new(1, 0, 0, 10)
topBarCover.Position = UDim2.new(0, 0, 1, -10)
topBarCover.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
topBarCover.BorderSizePixel = 0
topBarCover.Parent = topBar

makeDraggable(mainFrame, topBar)

-- JUDUL TEXT
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LAPER GANK ADMIN"
title.TextColor3 = Color3.fromRGB(255, 60, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- TOMBOL CLOSE
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -27, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- TOMBOL MINIMIZE
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -54, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

-- SCROLLING FRAME (DAFTAR PEMAIN)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0, 130)
scrollFrame.Position = UDim2.new(0.05, 0, 0, 45)
scrollFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
scrollFrame.Active = true
scrollFrame.Parent = mainFrame
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 6)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.Name
uiListLayout.Padding = UDim.new(0, 4)
uiListLayout.Parent = scrollFrame

-- TOMBOL EKSEKUSI TELEPORT
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.9, 0, 0, 35)
teleportBtn.Position = UDim2.new(0.05, 0, 0, 185)
teleportBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
teleportBtn.Text = "PILIH PEMAIN DI LIST"
teleportBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 12
teleportBtn.Parent = mainFrame
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 6)

-- TOMBOL TOGGLE ESP BOX
local espBoxBtn = Instance.new("TextButton")
espBoxBtn.Size = UDim2.new(0.9, 0, 0, 32)
espBoxBtn.Position = UDim2.new(0.05, 0, 0, 230)
espBoxBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
espBoxBtn.Text = "TOGGLE ESP BOX: OFF"
espBoxBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
espBoxBtn.Font = Enum.Font.GothamBold
espBoxBtn.TextSize = 11
espBoxBtn.Parent = mainFrame
Instance.new("UICorner", espBoxBtn).CornerRadius = UDim.new(0, 5)

-- TOMBOL TOGGLE ESP NAME
local espNameBtn = Instance.new("TextButton")
espNameBtn.Size = UDim2.new(0.9, 0, 0, 32)
espNameBtn.Position = UDim2.new(0.05, 0, 0, 272)
espNameBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
espNameBtn.Text = "TOGGLE ESP NAME: OFF"
espNameBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
espNameBtn.Font = Enum.Font.GothamBold
espNameBtn.TextSize = 11
espNameBtn.Parent = mainFrame
Instance.new("UICorner", espNameBtn).CornerRadius = UDim.new(0, 5)

-- ICON MINIMIZE (Logo Laper Gank)
local minIcon = Instance.new("ImageButton")
minIcon.Size = UDim2.new(0, 50, 0, 50)
minIcon.Position = UDim2.new(0.5, -25, 0.8, -25)
minIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
minIcon.Image = "rbxassetid://128042443413755"
minIcon.ScaleType = Enum.ScaleType.Fit
minIcon.Visible = false
minIcon.Active = true
minIcon.Parent = screenGui
Instance.new("UICorner", minIcon).CornerRadius = UDim.new(1, 0)
makeDraggable(minIcon, minIcon)

-- -----------------------------------------------------------------------------
-- SISTEM ESP RINGAN (HIGHLIGHT & BILLBOARD)
-- -----------------------------------------------------------------------------
local function refreshESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local char = player.Character
            
            -- LOGIKA ESP BOX (HIGHLIGHT)
            local hl = char:FindFirstChild("LaperESPBox")
            if ESPSettings.Box then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "LaperESPBox"
                    hl.FillColor = Color3.fromRGB(255, 60, 60)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.Parent = char
                end
                hl.Enabled = true
            else
                if hl then hl.Enabled = false end
            end
            
            -- LOGIKA ESP NAME (BILLBOARD GUI)
            local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if head then
                local bb = head:FindFirstChild("LaperESPName")
                if ESPSettings.Name then
                    if not bb then
                        bb = Instance.new("BillboardGui")
                        bb.Name = "LaperESPName"
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.StudsOffset = Vector3.new(0, 2, 0)
                        bb.AlwaysOnTop = true
                        
                        local txt = Instance.new("TextLabel")
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = player.Name
                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                        txt.TextStrokeTransparency = 0
                        txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 13
                        txt.Parent = bb
                        bb.Parent = head
                    end
                    bb.Enabled = true
                else
                    if bb then bb.Enabled = false end
                end
            end
        end
    end
end

-- Looping Ringan untuk Update ESP ke pemain yang baru respawn
RunService.RenderStepped:Connect(function()
    refreshESP()
end)

-- -----------------------------------------------------------------------------
-- SISTEM PLAYER LIST OTOMATIS
-- -----------------------------------------------------------------------------
local function updatePlayerList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 28)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            btn.Text = "  " .. player.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = scrollFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            -- MENGGUNAKAN MouseButton1Down AGAR 100% TERBACA EXECUTOR
            btn.MouseButton1Down:Connect(function()
                selectedPlayer = player
                
                -- Hapus warna tombol lain, warnai yang diklik
                for _, b in ipairs(scrollFrame:GetChildren()) do
                    if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
                end
                btn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
                
                teleportBtn.Text = "TELEPORT KE: " .. player.Name
                teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
                teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- -----------------------------------------------------------------------------
-- BINDING INTERAKSI UI (Menggunakan MouseButton1Down agar fix)
-- -----------------------------------------------------------------------------
closeBtn.MouseButton1Down:Connect(function() 
    screenGui:Destroy() 
end)

minBtn.MouseButton1Down:Connect(function()
    mainFrame.Visible = false
    minIcon.Visible = true
    minIcon.Position = mainFrame.Position
end)

minIcon.MouseButton1Down:Connect(function()
    minIcon.Visible = false
    mainFrame.Visible = true
    mainFrame.Position = minIcon.Position
end)

espBoxBtn.MouseButton1Down:Connect(function()
    ESPSettings.Box = not ESPSettings.Box
    if ESPSettings.Box then
        espBoxBtn.Text = "TOGGLE ESP BOX: ON"
        espBoxBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        espBoxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        espBoxBtn.Text = "TOGGLE ESP BOX: OFF"
        espBoxBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        espBoxBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

espNameBtn.MouseButton1Down:Connect(function()
    ESPSettings.Name = not ESPSettings.Name
    if ESPSettings.Name then
        espNameBtn.Text = "TOGGLE ESP NAME: ON"
        espNameBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        espNameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        espNameBtn.Text = "TOGGLE ESP NAME: OFF"
        espNameBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        espNameBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

teleportBtn.MouseButton1Down:Connect(function()
    if isTeleporting or not selectedPlayer then return end
    
    local targetChar = selectedPlayer.Character
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        teleportBtn.Text = "TARGET HILANG!"
        teleportBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        task.wait(1.5)
        teleportBtn.Text = "PILIH PEMAIN DI LIST"
        teleportBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        selectedPlayer = nil
        return
    end
    
    local myChar = localPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    
    isTeleporting = true
    teleportBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
    
    for i = 3, 1, -1 do
        teleportBtn.Text = "MENYIAPKAN TP " .. i .. "..."
        task.wait(1)
    end
    
    if selectedPlayer and targetChar:FindFirstChild("HumanoidRootPart") then
        myChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
    
    teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    teleportBtn.Text = "TELEPORT KE: " .. selectedPlayer.Name
    isTeleporting = false
end)
