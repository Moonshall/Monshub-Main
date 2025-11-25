--[[
    __  __                 _   _       _     
   |  \/  | ___  _ __  ___| | | |_   _| |__  
   | |\/| |/ _ \| '_ \/ __| |_| | | | | '_ \ 
   | |  | | (_) | | | \__ \  _  | |_| | |_) |
   |_|  |_|\___/|_| |_|___/_| |_|\__,_|_.__/ 
                                              
    Universal Game Loader
    Created by: Mons
    Version: 2.0.0
    © 2025 MonsHub - All Rights Reserved
]]

-- ============================================
-- 🔧 CONFIGURATION
-- ============================================

local Config = {
    -- Script URLs (GitHub Raw or your hosting)
    Scripts = {
        ["FishIt"] = "https://raw.githubusercontent.com/Moonshall/Monshub-Main/main/FistIt.lua",
        ["Default"] = "https://raw.githubusercontent.com/Moonshall/Monshub-Main/main/loadstring.lua"
    },
    
    -- Game IDs and their corresponding scripts
    Games = {
        -- Fist It / Fish It
        [123456789] = "FishIt",  -- Replace with actual game ID
        [987654321] = "FishIt",  -- Add more IDs if game has multiple places
        
        -- Add more games here:
        -- [gameId] = "ScriptName",
    },
    
    -- Display Settings
    ShowNotifications = true,
    LoadingDelay = 0.5,
    DebugMode = false,
    
    -- HTTP Settings
    MaxRetries = 3,
    RetryDelay = 2,
    RequestTimeout = 10
}

-- ============================================
-- 🛡️ RATE LIMITER
-- ============================================

local RateLimiter = {
    lastRequest = 0,
    minDelay = 1, -- Minimum 1 second between requests
}

function RateLimiter:Wait()
    local now = tick()
    local timeSinceLastRequest = now - self.lastRequest
    
    if timeSinceLastRequest < self.minDelay then
        local waitTime = self.minDelay - timeSinceLastRequest
        if Config.DebugMode then
            print("[MonsHub] Rate limiting: waiting " .. waitTime .. " seconds...")
        end
        task.wait(waitTime)
    end
    
    self.lastRequest = tick()
end

-- ============================================
-- 🎨 UI ELEMENTS
-- ============================================

local function CreateNotification(title, message, duration, color)
    if not Config.ShowNotifications then return end
    
    local StarterGui = game:GetService("StarterGui")
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 5,
            Icon = "rbxassetid://7733779730",
            Button1 = "OK"
        })
    end)
end

local function CreateLoadingUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MonsHubLoader"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Protection
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end
    
    -- Background Frame
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 150)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(88, 166, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = Frame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "MonsHub"
    Title.TextColor3 = Color3.fromRGB(230, 235, 245)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    -- Status Text
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 30)
    Status.Position = UDim2.new(0, 20, 0, 60)
    Status.BackgroundTransparency = 1
    Status.Text = "Detecting game..."
    Status.TextColor3 = Color3.fromRGB(160, 170, 190)
    Status.TextSize = 14
    Status.Font = Enum.Font.Gotham
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.Parent = Frame
    
    -- Loading Bar
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -40, 0, 6)
    BarBg.Position = UDim2.new(0, 20, 0, 100)
    BarBg.BackgroundColor3 = Color3.fromRGB(35, 39, 48)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Frame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = BarBg
    
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(88, 166, 255)
    Bar.BorderSizePixel = 0
    Bar.Parent = BarBg
    
    local BarCorner2 = Instance.new("UICorner")
    BarCorner2.CornerRadius = UDim.new(1, 0)
    BarCorner2.Parent = Bar
    
    -- Version
    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(1, 0, 0, 20)
    Version.Position = UDim2.new(0, 0, 1, -25)
    Version.BackgroundTransparency = 1
    Version.Text = "v2.0.0"
    Version.TextColor3 = Color3.fromRGB(120, 130, 150)
    Version.TextSize = 10
    Version.Font = Enum.Font.Gotham
    Version.Parent = Frame
    
    return ScreenGui, Status, Bar
end

-- ============================================
-- 🔍 GAME DETECTION
-- ============================================

local function GetGameInfo()
    local gameId = game.PlaceId
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(gameId).Name
    
    if Config.DebugMode then
        print("[MonsHub] Game ID:", gameId)
        print("[MonsHub] Game Name:", gameName)
    end
    
    return gameId, gameName
end

local function DetectGame()
    local gameId, gameName = GetGameInfo()
    
    -- Check if game is in our database
    if Config.Games[gameId] then
        return Config.Games[gameId], gameName
    end
    
    -- Check by game name (case insensitive)
    local lowerName = gameName:lower()
    
    if lowerName:find("fish") or lowerName:find("fist") then
        return "FishIt", gameName
    end
    
    -- Default fallback
    return "Default", gameName
end

-- ============================================
-- 📦 SCRIPT LOADER
-- ============================================

local function LoadScriptWithRetry(url, maxRetries)
    local retries = 0
    local delay = Config.RetryDelay
    
    while retries <= maxRetries do
        -- Apply rate limiting
        RateLimiter:Wait()
        
        if Config.DebugMode then
            print("[MonsHub] Attempting HTTP request (Attempt " .. (retries + 1) .. "/" .. (maxRetries + 1) .. ")")
        end
        
        local success, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        
        if success and result and #result > 0 then
            if Config.DebugMode then
                print("[MonsHub] Successfully loaded script (" .. #result .. " bytes)")
            end
            return true, result
        end
        
        -- Handle errors
        local errorMsg = tostring(result)
        if Config.DebugMode then
            warn("[MonsHub] Request failed:", errorMsg)
        end
        
        -- Check if it's a rate limit error
        if errorMsg:find("429") or errorMsg:find("Too Many Requests") then
            retries = retries + 1
            if retries <= maxRetries then
                local waitTime = delay * (2 ^ (retries - 1)) -- Exponential backoff
                if Config.DebugMode then
                    warn("[MonsHub] Rate limited! Waiting " .. waitTime .. " seconds before retry...")
                end
                CreateNotification(
                    "⏳ Rate Limited",
                    "Retrying in " .. waitTime .. " seconds... (" .. retries .. "/" .. maxRetries .. ")",
                    waitTime
                )
                task.wait(waitTime)
            end
        elseif errorMsg:find("404") or errorMsg:find("Not Found") then
            return false, "Script not found (404)"
        elseif errorMsg:find("403") or errorMsg:find("Forbidden") then
            return false, "Access forbidden (403)"
        else
            retries = retries + 1
            if retries <= maxRetries then
                if Config.DebugMode then
                    warn("[MonsHub] Retrying in " .. delay .. " seconds...")
                end
                task.wait(delay)
            end
        end
    end
    
    return false, "Max retries exceeded after " .. maxRetries .. " attempts"
end

local function LoadScript(scriptName, gameName)
    local scriptUrl = Config.Scripts[scriptName]
    
    if not scriptUrl then
        CreateNotification(
            "❌ Error",
            "Script not found: " .. scriptName,
            5
        )
        return false
    end
    
    -- Try loading from local file first (if in dev mode)
    if readfile then
        local localFiles = {
            ["FishIt"] = "FistIt.lua",
            ["Default"] = "loadstring.lua"
        }
        
        local localFile = localFiles[scriptName]
        if localFile then
            local success, content = pcall(readfile, localFile)
            if success and content then
                if Config.DebugMode then
                    print("[MonsHub] Loading from local file:", localFile)
                end
                
                local loadSuccess, loadResult = pcall(function()
                    return loadstring(content)()
                end)
                
                if loadSuccess then
                    CreateNotification(
                        "✅ Success",
                        "Loaded script for: " .. gameName,
                        3
                    )
                    return true
                end
            end
        end
    end
    
    -- Load from URL with retry mechanism
    if Config.DebugMode then
        print("[MonsHub] Loading from URL:", scriptUrl)
    end
    
    CreateNotification(
        "⏳ Loading",
        "Fetching script for " .. gameName .. "...",
        2
    )
    
    local httpSuccess, scriptContent = LoadScriptWithRetry(scriptUrl, Config.MaxRetries)
    
    if httpSuccess and scriptContent then
        -- Try to cache the script
        if writefile then
            pcall(function()
                writefile("MonsHub_Cache_" .. scriptName .. ".lua", scriptContent)
                if Config.DebugMode then
                    print("[MonsHub] Script cached successfully")
                end
            end)
        end
        
        local loadSuccess, loadResult = pcall(function()
            return loadstring(scriptContent)()
        end)
        
        if loadSuccess then
            CreateNotification(
                "✅ Success",
                "Loaded script for: " .. gameName,
                3
            )
            return true
        else
            CreateNotification(
                "❌ Execution Error",
                "Script loaded but failed to execute",
                5
            )
            
            if Config.DebugMode then
                warn("[MonsHub] Execution Error:", loadResult)
            end
            
            return false
        end
    else
        -- Try to load from cache as fallback
        if readfile then
            local cacheSuccess, cacheContent = pcall(readfile, "MonsHub_Cache_" .. scriptName .. ".lua")
            if cacheSuccess and cacheContent then
                if Config.DebugMode then
                    print("[MonsHub] Loading from cache...")
                end
                
                CreateNotification(
                    "📦 Cache",
                    "Loading from cached version...",
                    2
                )
                
                local loadSuccess, loadResult = pcall(function()
                    return loadstring(cacheContent)()
                end)
                
                if loadSuccess then
                    CreateNotification(
                        "✅ Success",
                        "Loaded from cache: " .. gameName,
                        3
                    )
                    return true
                end
            end
        end
        
        -- All methods failed
        local errorMsg = tostring(scriptContent)
        if errorMsg:find("429") or errorMsg:find("Too Many Requests") then
            CreateNotification(
                "⚠️ Rate Limited",
                "Too many requests. Please wait 1-2 minutes and try again.",
                7
            )
        elseif errorMsg:find("404") then
            CreateNotification(
                "❌ Not Found",
                "Script file not found on server",
                5
            )
        elseif errorMsg:find("403") then
            CreateNotification(
                "❌ Forbidden",
                "Access to script denied",
                5
            )
        else
            CreateNotification(
                "❌ Connection Error",
                "Failed to load script. Check your connection.",
                5
            )
        end
        
        if Config.DebugMode then
            warn("[MonsHub] HTTP Error:", scriptContent)
        end
        
        return false
    end
end

-- ============================================
-- 🚀 MAIN LOADER
-- ============================================

local function Main()
    print([[
    __  __                 _   _       _     
   |  \/  | ___  _ __  ___| | | |_   _| |__  
   | |\/| |/ _ \| '_ \/ __| |_| | | | | '_ \ 
   | |  | | (_) | | | \__ \  _  | |_| | |_) |
   |_|  |_|\___/|_| |_|___/_| |_|\__,_|_.__/ 
    ]])
    print("[MonsHub] Universal Loader v2.0.0")
    print("[MonsHub] Starting...")
    
    -- Create loading UI
    local LoadingUI, StatusLabel, ProgressBar = CreateLoadingUI()
    
    -- Animate progress bar
    local TweenService = game:GetService("TweenService")
    local progressTween = TweenService:Create(
        ProgressBar,
        TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.3, 0, 1, 0)}
    )
    progressTween:Play()
    
    task.wait(0.5)
    
    -- Detect game
    StatusLabel.Text = "Detecting game..."
    local scriptName, gameName = DetectGame()
    
    if Config.DebugMode then
        print("[MonsHub] Detected script:", scriptName)
        print("[MonsHub] Game name:", gameName)
    end
    
    task.wait(0.3)
    
    -- Update progress
    progressTween = TweenService:Create(
        ProgressBar,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.6, 0, 1, 0)}
    )
    progressTween:Play()
    
    StatusLabel.Text = "Loading script for " .. gameName .. "..."
    
    task.wait(0.5)
    
    -- Load script
    local success = LoadScript(scriptName, gameName)
    
    -- Complete progress
    progressTween = TweenService:Create(
        ProgressBar,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 1, 0)}
    )
    progressTween:Play()
    
    if success then
        StatusLabel.Text = "✅ Loaded successfully!"
        StatusLabel.TextColor3 = Color3.fromRGB(82, 196, 26)
        
        task.wait(1.5)
        
        -- Fade out
        local fadeTween = TweenService:Create(
            LoadingUI.Frame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        )
        fadeTween:Play()
        
        for _, child in pairs(LoadingUI.Frame:GetChildren()) do
            if child:IsA("GuiObject") then
                TweenService:Create(
                    child,
                    TweenInfo.new(0.5),
                    {TextTransparency = 1, BackgroundTransparency = 1}
                ):Play()
            end
        end
        
        task.wait(0.5)
        LoadingUI:Destroy()
        
        print("[MonsHub] Script loaded successfully!")
    else
        StatusLabel.Text = "❌ Failed to load!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 77, 79)
        
        task.wait(3)
        LoadingUI:Destroy()
        
        warn("[MonsHub] Failed to load script!")
    end
end

-- ============================================
-- 🛡️ ANTI-DETECTION
-- ============================================

local function CheckEnvironment()
    -- Check if executor is supported
    if not game:HttpGet then
        CreateNotification(
            "⚠️ Warning",
            "HttpGet not supported. Script may not work properly.",
            5
        )
        return false
    end
    
    return true
end

-- ============================================
-- 🎯 EXECUTION
-- ============================================

-- Check environment
if not CheckEnvironment() then
    warn("[MonsHub] Environment check failed!")
    return
end

-- Run main loader
local success, error = pcall(Main)

if not success then
    warn("[MonsHub] Fatal error:", error)
    CreateNotification(
        "❌ Fatal Error",
        "Loader failed: " .. tostring(error),
        5
    )
end
