local games = {
    [6739698191] = "https://raw.githubusercontent.com/ranz-coder/sc-roblox/refs/heads/main/ViolenceDistrict.lua"
}

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local gameId = game.GameId
local logo = "https://cdn.ranzzawok.my.id/media/images/med_eaaec621dbe5b13f.png"

local LOG_ENDPOINT = ""
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Icon = logo,
            Duration = duration or 5
        })
    end)
end

local function getRequestFunction()
    return request
        or http_request
        or (syn and syn.request)
        or (http and http.request)
end

local function sendUsageLog()
    local httprequest = getRequestFunction()

    if not httprequest then
        warn("HTTP request function not supported.")
        return
    end

    local player = Players.LocalPlayer

    local payload = {
        username = player and player.Name or "Unknown",
        userId = player and player.UserId or 0,
        gameId = game.GameId,
        placeId = game.PlaceId,
        jobId = game.JobId
    }

    local success, response = pcall(function()
        return httprequest({
            Url = LOG_ENDPOINT,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if success then
        print("ok.")
    else
        warn("Failed:", response)
    end
end

local function loadGameScript(url)
    local success, result = pcall(function()
        loadstring(game:HttpGet(url))()
    end)

    if not success then
        notify("LAPER-HUB Notification", "Gagal load script nya boss, LAPER GANK lagi kenyang!", 5)
        warn("Load error:", result)
    end
end

local selectedScript = games[gameId]

if selectedScript then
    notify("LAPER-HUB Notification", "Game Mendukung LAPER GANK! Loading...", 5)

    task.spawn(function()
        sendUsageLog()
    end)

    task.wait(1)
    loadGameScript(selectedScript)
else
    notify("LAPER-HUB Notification", "Game Gak support LAPER GANK! Sorry...", 5)
end
