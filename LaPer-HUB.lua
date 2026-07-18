-- =============================================================================
-- LAPER GANK - MOBILE DASHBOARD (BUILD FROM 0)
-- =============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local guiName = "LaperMobileUI"

-- Clean old UI
if (type(gethui) == "function" and gethui():FindFirstChild(guiName)) then gethui():FindFirstChild(guiName):Destroy() end

-- ScreenGui Setup
local screen = Instance.new("ScreenGui", type(gethui) == "function" and gethui() or CoreGui)
screen.Name = guiName
screen.ResetOnSpawn = false

-- Frame Utama (Dashboard Card)
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Dark Grey
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- Fitur bawaan Roblox untuk Mobile Dragging
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Judul (Aksen Ungu)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(80, 50, 150) -- Purple
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)
title.Text = "LAPER GANK DASHBOARD"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Tombol Aksi (Aksen Biru)
local function createButton(name, pos, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- Kontrol
local tpBtn = createButton("TELEPORT KE TARGET", UDim2.new(0.05, 0, 0, 60), Color3.fromRGB(40, 100, 200)) -- Blue
local espBtn = createButton("TOGGLE ESP BOX", UDim2.new(0.05, 0, 0, 110), Color3.fromRGB(40, 100, 200))
local closeBtn = createButton("TUTUP PANEL", UDim2.new(0.05, 0, 0, 240), Color3.fromRGB(150, 40, 40))

-- Fungsi Teleport Dasar (Testing)
tpBtn.Activated:Connect(function()
    local target = Players:GetPlayers()[2] -- Ambil player pertama di list untuk testing
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

-- Fungsi Tutup
closeBtn.Activated:Connect(function() screen:Destroy() end)

-- [TIPS] Tambahkan ESP atau list pemain di bawah sini setelah ini berhasil muncul
-- -----------------------------------------------------------------------------
-- SISTEM PLAYER LIST OTOMATIS
-- -----------------------------------------------------------------------------
local function updatePlayerList()
    -- Bersihkan list lama
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    -- Isi dengan player aktif
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            btn.Text = "  " .. player.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = scrollFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            -- [DELTA FIX] Menggunakan .Activated untuk sentuhan layar
            btn.Activated:Connect(function()
                selectedPlayer = player
                
                -- Reset warna tombol lain
                for _, b in ipairs(scrollFrame:GetChildren()) do
                    if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
                end
                -- Beri warna pada tombol yang dipilih
                btn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
                
                teleportBtn.Text = "TP KE: " .. player.Name
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
-- SISTEM ESP (HIGHLIGHT BOX & NAME BILLBOARD)
-- -----------------------------------------------------------------------------
local function cleanESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local hl = player.Character:FindFirstChild("LaperBox")
            if hl then hl:Destroy() end
            
            local head = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if head then
                local bb = head:FindFirstChild("LaperName")
                if bb then bb:Destroy() end
            end
        end
    end
end

local function refreshESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local char = player.Character
            
            -- LOGIKA ESP BOX
            if ESPSettings.Box then
                local hl = char:FindFirstChild("LaperBox")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "LaperBox"
                    hl.FillColor = Color3.fromRGB(255, 60, 60)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.6
                    hl.OutlineTransparency = 0
                    hl.Parent = char
                end
            else
                local hl = char:FindFirstChild("LaperBox")
                if hl then hl:Destroy() end
            end
            
            -- LOGIKA ESP NAME
            if ESPSettings.Name then
                local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if head then
                    local bb = head:FindFirstChild("LaperName")
                    if not bb then
                        bb = Instance.new("BillboardGui")
                        bb.Name = "LaperName"
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.StudsOffset = Vector3.new(0, 2.5, 0)
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
                end
            else
                local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if head then
                    local bb = head:FindFirstChild("LaperName")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end

-- Update ESP menggunakan Heartbeat agar stabil di Eksekutor
RunService.Heartbeat:Connect(function()
    pcall(refreshESP)
end)
