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
