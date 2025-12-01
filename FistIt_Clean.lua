-- MonsHub | Fish It Script (Error-Free Version)
-- by Mons
-- Version: v1.2.0

print("🎣 Loading MonsHub for Fish It...")

-- Load NatUI Library with error handling
local NatUI
local success, err = pcall(function()
    NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/bmF0dWk-/refs/heads/main/ui.lua"))()
end)

if not success or not NatUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ MonsHub Error",
        Text = "Failed to load NatUI library. Please check your internet connection.",
        Duration = 10,
    })
    warn("MonsHub: Failed to load NatUI - " .. tostring(err))
    return
end

print("✅ NatUI loaded successfully")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Wait for character safely
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    AutoFishingServer = false,
    AutoFishingLegit = false,
    AutoFishingNormal = false,
    AutoClaimNotifications = false,
    AutoSellAll = false,
    SellAllDelay = 5,
    FishingDelay = 1.5,
    InstantFishing = false,
    CastMethod = "Old",
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
}

-- Notification
local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5,
        })
    end)
end

print("✅ Functions loaded")

-- Get Remote
local function GetRemote(name)
    local success, remote = pcall(function()
        if name == "ChargeFishingRod" or name == "cast" then
            return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/ChargeFishingRod")
        elseif name == "UpdateAutoFishingState" or name == "autofishing" then
            return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/UpdateAutoFishingState")
        elseif name == "RequestFishingMinigameStarted" or name == "minigame" then
            return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/RequestFishingMinigameStarted")
        elseif name == "FishingCompleted" or name == "complete" then
            return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/FishingCompleted")
        elseif name == "ClaimNotification" or name == "claim" then
            return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/ClaimNotification")
        elseif name == "SellAllItems" or name == "sellall" then
            return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/SellAllItems")
        end
        -- Fallback: search in descendants
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                if string.lower(v.Name):find(string.lower(name)) then
                    return v
                end
            end
        end
        return nil
    end)
    return success and remote or nil
end

-- Auto Fishing Functions
local function CastFishingRod()
    pcall(function()
        local castRemote = GetRemote("ChargeFishingRod")
        if castRemote then
            if castRemote:IsA("RemoteEvent") then
                castRemote:FireServer()
            elseif castRemote:IsA("RemoteFunction") then
                castRemote:InvokeServer()
            end
        else
            warn("ChargeFishingRod remote not found")
        end
    end)
end

local function ReelFish()
    pcall(function()
        local reelRemote = GetRemote("FishingCompleted")
        if reelRemote then
            if reelRemote:IsA("RemoteEvent") then
                reelRemote:FireServer()
            elseif reelRemote:IsA("RemoteFunction") then
                reelRemote:InvokeServer()
            end
        else
            warn("FishingCompleted remote not found")
        end
    end)
end

-- Auto Fishing State Function
local function SetAutoFishing(enabled)
    pcall(function()
        local autoFishRemote = GetRemote("UpdateAutoFishingState")
        if autoFishRemote then
            if autoFishRemote:IsA("RemoteEvent") then
                autoFishRemote:FireServer(enabled)
            elseif autoFishRemote:IsA("RemoteFunction") then
                autoFishRemote:InvokeServer(enabled)
            end
        else
            warn("UpdateAutoFishingState remote not found")
        end
    end)
end

-- Start Fishing Minigame Function
local function StartFishingMinigame()
    pcall(function()
        local minigameRemote = GetRemote("RequestFishingMinigameStarted")
        if minigameRemote then
            if minigameRemote:IsA("RemoteEvent") then
                minigameRemote:FireServer()
            elseif minigameRemote:IsA("RemoteFunction") then
                minigameRemote:InvokeServer()
            end
        else
            warn("RequestFishingMinigameStarted remote not found")
        end
    end)
end

-- Complete Fishing Function
local function CompleteFishing()
    pcall(function()
        local completeRemote = GetRemote("FishingCompleted")
        if completeRemote then
            completeRemote:FireServer()
        else
            warn("FishingCompleted remote not found")
        end
    end)
end

-- Claim Notification Function
local function ClaimNotification()
    pcall(function()
        local claimRemote = GetRemote("ClaimNotification")
        if claimRemote then
            claimRemote:FireServer()
        else
            warn("ClaimNotification remote not found")
        end
    end)
end

-- Sell All Items Function
local function SellAllItems()
    pcall(function()
        local sellRemote = GetRemote("SellAllItems")
        if sellRemote then
            if sellRemote:IsA("RemoteFunction") then
                sellRemote:InvokeServer()
            else
                sellRemote:FireServer()
            end
        else
            warn("SellAllItems remote not found")
        end
    end)
end

-- Auto Functions
local function AutoClaimNotifications()
    spawn(function()
        while Settings.AutoClaimNotifications do
            ClaimNotification()
            wait(1)
        end
    end)
end

local function AutoSellAllItems()
    spawn(function()
        while Settings.AutoSellAll do
            SellAllItems()
            wait(Settings.SellAllDelay or 5)
        end
    end)
end

local function AutoFishingLegit()
    spawn(function()
        while Settings.AutoFishingLegit do
            CastFishingRod()
            wait(Settings.FishingDelay or 1.5)
            ReelFish()
            wait(Settings.FishingDelay or 1.5)
        end
    end)
end

local function AutoFishingNormal()
    spawn(function()
        while Settings.AutoFishingNormal do
            CastFishingRod()
            wait(0.5)
            ReelFish()
            wait(0.5)
        end
    end)
end

print("🎨 Creating UI...")

-- Create UI with error handling
local Window = NatUI:CreateWindow({
    Title = "MonsHub | Fish It",
    Icon = "rbxassetid://81294956922394",
    Author = "by Mons",
    Folder = "MonsHub_FishIt",
    Size = UDim2.fromOffset(580, 460),
    LiveSearchDropdown = true,
    AutoSave = true,
    FileSaveName = "MonsHub_FishIt.json",
})

print("✅ Window created successfully")

-- Create Tabs
local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "home", Desc = "Main settings" }),
    Farm = Window:Tab({ Title = "Farm", Icon = "leaf", Desc = "Auto farming" }),
    Automatic = Window:Tab({ Title = "Automatic", Icon = "zap", Desc = "Automation" }),
    Player = Window:Tab({ Title = "Player", Icon = "user", Desc = "Player modifications" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "map-pin", Desc = "Teleportation" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "settings", Desc = "Miscellaneous" })
}

-- Main Tab
Tabs.Main:Section({ Title = "Information" })
Tabs.Main:Paragraph({ Title = "MonsHub Fish It", Desc = "Premium script for Fish It game\nVersion: v1.2.0\nJoin our Discord for support!" })
Tabs.Main:Button({ Title = "Join Discord", Callback = function() setclipboard("https://discord.gg/monshub"); Notify("Discord", "Link copied to clipboard!", 3) end })

-- Farm Tab
Tabs.Farm:Section({ Title = "Auto Fishing" })
Tabs.Farm:Toggle({ Title = "Auto Fishing (Server)", Desc = "Toggle server-side auto fishing", Default = false, Callback = function(v) Settings.AutoFishingServer = v; SetAutoFishing(v) end })
Tabs.Farm:Toggle({ Title = "Auto Fishing Legit", Desc = "Auto Catch Fish with throw animation", Default = false, Callback = function(v) Settings.AutoFishingLegit = v if v then AutoFishingLegit() end end })
Tabs.Farm:Toggle({ Title = "Auto Fishing (Normal)", Desc = "Auto Catch Fish", Default = false, Callback = function(v) Settings.AutoFishingNormal = v if v then AutoFishingNormal() end end })
Tabs.Farm:Slider({ Title = "Delay", Min = 0.5, Max = 5, Default = 1.5, Callback = function(v) Settings.FishingDelay = v end })

Tabs.Farm:Section({ Title = "Manual Fishing" })
Tabs.Farm:Button({ Title = "Start Fishing Minigame", Desc = "Manually start fishing minigame", Callback = function() StartFishingMinigame() end })
Tabs.Farm:Button({ Title = "Cast Fishing Rod", Desc = "Manually cast fishing rod", Callback = function() CastFishingRod() end })
Tabs.Farm:Button({ Title = "Complete Fishing", Desc = "Manually complete fishing catch", Callback = function() CompleteFishing() end })
Tabs.Farm:Button({ Title = "Claim Notification", Desc = "Manually claim notification reward", Callback = function() ClaimNotification() end })
Tabs.Farm:Button({ Title = "Sell All Items", Desc = "Manually sell all items in inventory", Callback = function() SellAllItems() end })

-- Automatic Tab
Tabs.Automatic:Section({ Title = "Auto Collect" })
Tabs.Automatic:Toggle({ Title = "Auto Claim Notifications", Desc = "Automatically claim notification rewards", Default = false, Callback = function(v) Settings.AutoClaimNotifications = v if v then AutoClaimNotifications() end end })

Tabs.Automatic:Section({ Title = "Auto Sell" })
Tabs.Automatic:Toggle({ Title = "Auto Sell All Items", Desc = "Automatically sell all items with delay", Default = false, Callback = function(v) Settings.AutoSellAll = v if v then AutoSellAllItems() end end })
Tabs.Automatic:Slider({ Title = "Sell All Delay", Min = 1, Max = 30, Default = 5, Callback = function(v) Settings.SellAllDelay = v end })

-- Player Tab
Tabs.Player:Section({ Title = "Player Settings" })
Tabs.Player:Slider({ Title = "Walk Speed", Min = 16, Max = 200, Default = 16, Callback = function(v) Settings.WalkSpeed = v if Humanoid then Humanoid.WalkSpeed = v end end })
Tabs.Player:Slider({ Title = "Jump Power", Min = 50, Max = 300, Default = 50, Callback = function(v) Settings.JumpPower = v if Humanoid then Humanoid.JumpPower = v end end })
Tabs.Player:Toggle({ Title = "Infinite Jump", Default = false, Callback = function(v) Settings.InfiniteJump = v end })

-- Misc Tab
Tabs.Misc:Section({ Title = "Script" })
Tabs.Misc:Button({ Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })
Tabs.Misc:Button({ Title = "Destroy GUI", Callback = function() Window:Destroy() end })

-- Character handling
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Infinite Jump Handler
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Settings.InfiniteJump and Humanoid then
        Humanoid:ChangeState("Jumping")
    end
end)

-- Success notification
Notify("✅ MonsHub", "Fish It script loaded successfully!", 5)
print("✅ MonsHub Fish It script loaded successfully!")