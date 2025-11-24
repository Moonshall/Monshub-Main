-- MonsHub | Fist It Script  
-- by Mons
-- Version: v1.0.0

-- Load NatUI Library
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/bmF0dWk-/refs/heads/main/ui.lua"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    AutoFishingLegit = false,
    AutoFishingNormal = false,
    FishingDelay = 1.5,
    InstantFishing = false,
    CastMethod = "Old",
    CancelDelay = 1.7,
    CompleteDelay = 1.4,
    NoAnimation = false,
    RemoveFishNotification = false,
    RemoveCutscene = false,
    RemoveSkinEffect = false,
    SelectedFishingArea = "None",
    FreezeAtArea = false,
    SavedPosition = nil,
    FreezeAtSavedPosition = false,
    AutoSell = false,
    AutoCollect = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    HideUsername = false,
    BoostFPS = false,
    Disable3DRendering = false,
    PlayerESP = false,
    WebhookURL = "",
}

-- Notification
local function Notify(title, text, duration)
    NatUI:Notify({
        Title = title,
        Content = text,
        Icon = "bell",
        Duration = duration or 5,
    })
end

-- Get Remote
local function GetRemote(name)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if string.lower(v.Name):find(string.lower(name)) then
                return v
            end
        end
    end
    return nil
end

-- Auto Fishing Functions
local function CastFishingRod()
    pcall(function()
        local castRemote = GetRemote("cast")
        if castRemote then
            if castRemote:IsA("RemoteEvent") then
                castRemote:FireServer(Settings.CastMethod)
            elseif castRemote:IsA("RemoteFunction") then
                castRemote:InvokeServer(Settings.CastMethod)
            end
        end
    end)
end

local function ReelFish()
    pcall(function()
        local reelRemote = GetRemote("reel")
        if reelRemote then
            if reelRemote:IsA("RemoteEvent") then
                reelRemote:FireServer()
            elseif reelRemote:IsA("RemoteFunction") then
                reelRemote:InvokeServer()
            end
        end
    end)
end

local function AutoFishingLegit()
    spawn(function()
        while Settings.AutoFishingLegit do
            task.wait(Settings.FishingDelay)
            pcall(function()
                CastFishingRod()
                task.wait(Settings.CancelDelay)
                ReelFish()
                task.wait(Settings.CompleteDelay)
            end)
        end
    end)
end

local function AutoFishingNormal()
    spawn(function()
        while Settings.AutoFishingNormal do
            task.wait(0.1)
            pcall(function()
                CastFishingRod()
                task.wait(0.5)
                ReelFish()
            end)
        end
    end)
end

local function InstantFishing()
    spawn(function()
        while Settings.InstantFishing do
            task.wait()
            pcall(function()
                ReelFish()
            end)
        end
    end)
end

-- Position Functions
local function SavePosition()
    Settings.SavedPosition = HumanoidRootPart.CFrame
    Notify("Position", "Saved!", 3)
end

local function TeleportToSavedPosition()
    if Settings.SavedPosition then
        HumanoidRootPart.CFrame = Settings.SavedPosition
        Notify("Teleport", "Success!", 3)
    else
        Notify("Error", "No saved position!", 3)
    end
end

local FreezeConnection
local function FreezeAtPosition(position)
    if FreezeConnection then FreezeConnection:Disconnect() end
    if position then
        FreezeConnection = RunService.Heartbeat:Connect(function()
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = position
                HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end

-- Fishing Areas
local FishingAreas = {
    ["Spawn"] = CFrame.new(0, 5, 0),
    ["Beach"] = CFrame.new(100, 5, 50),
    ["Pier"] = CFrame.new(-50, 5, 100),
}

-- Player Mods
local NoclipConnection
local function SetNoclip(enabled)
    if NoclipConnection then NoclipConnection:Disconnect() end
    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end

-- Character Reset
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Create UI
local Window = NatUI:CreateWindow({
    Title = "MonsHub | Fist It",
    Icon = "rbxassetid://81294956922394",
    Author = "by Mons",
    Folder = "MonsHub_FistIt",
    Size = UDim2.fromOffset(580, 460),
    LiveSearchDropdown = true,
    AutoSave = true,
    FileSaveName = "MonsHub_FistIt.json",
})

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "settings", Desc = "Main settings" })
local FarmTab = Window:Tab({ Title = "Farm", Icon = "leaf", Desc = "Auto farming" })
local AutomaticTab = Window:Tab({ Title = "Automatic", Icon = "zap", Desc = "Automation" })

local Tabs = {
    Main = MainTab,
    Farm = FarmTab,
    Automatic = AutomaticTab,
}

Window:SelectTab(2) -- Select Farm tab by default

-- Main Tab
Tabs.Main:Section({ Title = "Information" })
Tabs.Main:Paragraph({ Title = "Having Problem Using Our Script?", Desc = "Join our Discord!" })
Tabs.Main:Button({ Title = "Join Our Discord Server!", Callback = function() setclipboard("https://discord.gg/monshub") Notify("Discord", "Link copied!", 3) end })

Tabs.Main:Section({ Title = "Player" })
Tabs.Main:Slider({ Title = "WalkSpeed", Min = 16, Max = 200, Default = 16, Callback = function(v) Settings.WalkSpeed = v if Humanoid then Humanoid.WalkSpeed = v end end })
Tabs.Main:Slider({ Title = "JumpPower", Min = 50, Max = 300, Default = 50, Callback = function(v) Settings.JumpPower = v if Humanoid then Humanoid.JumpPower = v end end })
Tabs.Main:Button({ Title = "Reset Speed & Jump", Callback = function() if Humanoid then Humanoid.WalkSpeed = 16 Humanoid.JumpPower = 50 end Notify("Reset", "Done!", 3) end })
Tabs.Main:Toggle({ Title = "Infinite Jump", Default = false, Callback = function(v) Settings.InfiniteJump = v end })
Tabs.Main:Toggle({ Title = "Noclip", Desc = "Turn Off if you want to go underwater places", Default = false, Callback = function(v) Settings.Noclip = v SetNoclip(v) end })
Tabs.Main:Button({ Title = "Reset Character", Callback = function() LocalPlayer.Character:BreakJoints() end })

Tabs.Main:Section({ Title = "Identity" })
Tabs.Main:Toggle({ Title = "Hide Username", Desc = "Sets name to discord.gg/monshub. Rejoin to disable.", Default = false, Callback = function(v) if v then LocalPlayer.Character.Humanoid.DisplayName = "discord.gg/monshub" end end })

Tabs.Main:Section({ Title = "Visual" })
Tabs.Main:Toggle({ Title = "Boost FPS", Default = false, Callback = function(v) if v then settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end end })
Tabs.Main:Toggle({ Title = "Disable 3D Rendering", Default = false, Callback = function(v) RunService:Set3dRenderingEnabled(not v) end })
Tabs.Main:Toggle({ Title = "Player ESP", Default = false, Callback = function(v) Settings.PlayerESP = v end })

Tabs.Main:Section({ Title = "External" })
Tabs.Main:Button({ Title = "Fly GUI", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end })

-- Farm Tab
Tabs.Farm:Section({ Title = "Auto Fishing" })
Tabs.Farm:Toggle({ Title = "Auto Fishing Legit", Desc = "Auto Catch Fish with throw animation", Default = false, Callback = function(v) Settings.AutoFishingLegit = v if v then AutoFishingLegit() end end })
Tabs.Farm:Toggle({ Title = "Auto Fishing (Normal)", Desc = "Auto Catch Fish", Default = false, Callback = function(v) Settings.AutoFishingNormal = v if v then AutoFishingNormal() end end })
Tabs.Farm:Slider({ Title = "Delay", Min = 0.5, Max = 5, Default = 1.5, Callback = function(v) Settings.FishingDelay = v end })

Tabs.Farm:Section({ Title = "Fast Instant Fishing" })
Tabs.Farm:Toggle({ Title = "Instant Fishing", Desc = "Instant Catch a Fish", Default = false, Callback = function(v) Settings.InstantFishing = v if v then InstantFishing() end end })
Tabs.Farm:Dropdown({ Title = "Cast Method", Desc = "Use Old or New Method for Instant Cast", Values = {"Old", "New"}, Value = "Old", Callback = function(v) Settings.CastMethod = v end })
Tabs.Farm:Slider({ Title = "Cancel Delay", Min = 0.1, Max = 3, Default = 1.7, Callback = function(v) Settings.CancelDelay = v end })
Tabs.Farm:Slider({ Title = "Complete Delay", Min = 0.1, Max = 3, Default = 1.4, Callback = function(v) Settings.CompleteDelay = v end })

Tabs.Farm:Section({ Title = "Others" })
Tabs.Farm:Toggle({ Title = "No Animation", Desc = "Remove Fish Caught Animation", Default = false, Callback = function(v) Settings.NoAnimation = v end })
Tabs.Farm:Toggle({ Title = "Remove Fish Caught Notification", Desc = "Removes the popup notification for new fish.", Default = false, Callback = function(v) Settings.RemoveFishNotification = v end })
Tabs.Farm:Toggle({ Title = "Remove Cutscene", Desc = "Remove the fishing cutscene when you catch a fish.", Default = false, Callback = function(v) Settings.RemoveCutscene = v end })
Tabs.Farm:Toggle({ Title = "Remove Skin Effect", Default = false, Callback = function(v) Settings.RemoveSkinEffect = v end })

Tabs.Farm:Section({ Title = "Fishing Area" })
Tabs.Farm:Dropdown({ Title = "Select Fishing Area", Values = {"Spawn", "Beach", "Pier"}, Value = "Spawn", Callback = function(v) Settings.SelectedFishingArea = v if FishingAreas[v] then HumanoidRootPart.CFrame = FishingAreas[v] end end })
Tabs.Farm:Toggle({ Title = "Freeze at Selected Area", Default = false, Callback = function(v) Settings.FreezeAtArea = v if v and FishingAreas[Settings.SelectedFishingArea] then FreezeAtPosition(FishingAreas[Settings.SelectedFishingArea]) else if FreezeConnection then FreezeConnection:Disconnect() end end end })

Tabs.Farm:Section({ Title = "Custom Position" })
Tabs.Farm:Button({ Title = "Save Current Position", Callback = SavePosition })
Tabs.Farm:Button({ Title = "Teleport to Saved Position", Callback = TeleportToSavedPosition })
Tabs.Farm:Toggle({ Title = "Freeze at Saved Position", Default = false, Callback = function(v) Settings.FreezeAtSavedPosition = v if v and Settings.SavedPosition then FreezeAtPosition(Settings.SavedPosition) else if FreezeConnection then FreezeConnection:Disconnect() end end end })

-- Automatic Tab
Tabs.Automatic:Section({ Title = "Auto Collect" })
Tabs.Automatic:Toggle({ Title = "Auto Collect Coins", Desc = "Automatically collect coins", Default = false, Callback = function(v) Settings.AutoCollect = v end })
Tabs.Automatic:Toggle({ Title = "Auto Collect Gems", Desc = "Automatically collect gems", Default = false, Callback = function(v) Settings.AutoCollectGems = v end })

Tabs.Automatic:Section({ Title = "Auto Sell" })
Tabs.Automatic:Toggle({ Title = "Auto Sell Fish", Desc = "Automatically sell fish", Default = false, Callback = function(v) Settings.AutoSell = v end })
Tabs.Automatic:Toggle({ Title = "Auto Sell at Full Inventory", Desc = "Sell when inventory is full", Default = false, Callback = function(v) Settings.AutoSellFull = v end })

Tabs.Automatic:Section({ Title = "Auto Buy" })
Tabs.Automatic:Toggle({ Title = "Auto Buy Bait", Desc = "Automatically buy bait when empty", Default = false, Callback = function(v) Settings.AutoBuyBait = v end })
Tabs.Automatic:Dropdown({ Title = "Select Bait", Values = {"Basic Bait", "Advanced Bait", "Premium Bait"}, Value = "Basic Bait", Callback = function(v) Settings.SelectedBait = v end })

Tabs.Automatic:Section({ Title = "Auto Upgrade" })
Tabs.Automatic:Toggle({ Title = "Auto Upgrade Rod", Desc = "Automatically upgrade fishing rod", Default = false, Callback = function(v) Settings.AutoUpgradeRod = v end })
Tabs.Automatic:Toggle({ Title = "Auto Upgrade Backpack", Desc = "Automatically upgrade backpack", Default = false, Callback = function(v) Settings.AutoUpgradeBackpack = v end })

Tabs.Automatic:Section({ Title = "Utilities" })
Tabs.Automatic:Button({ Title = "Rejoin Server", Desc = "Rejoin current server", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })
Tabs.Automatic:Button({ Title = "Server Hop", Desc = "Join different server", Callback = function() 
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    for _, server in pairs(servers.data) do
        if server.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
            break
        end
    end
end })
Tabs.Automatic:Button({ Title = "Destroy GUI", Desc = "Remove the GUI", Callback = function() Window:Destroy() end })

-- Init
Notify("MonsHub", "Fist It loaded!", 5)
