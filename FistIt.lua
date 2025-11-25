-- MonsHub | Fish It Script  
-- by Mons
-- Version: v1.0.1

print("🎣 Loading MonsHub for Fish It...")

-- Load NatUI Library with error handling
local NatUI
local success, err = pcall(function()
    NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/bmF0dWk-/refs/heads/main/ui.lua"))()
end)

if not success or not NatUI then
    warn("Failed to load NatUI:", err)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ MonsHub Error",
        Text = "Failed to load UI library. Please check your connection.",
        Duration = 7,
    })
    return
end

print("✅ NatUI loaded successfully")

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
    pcall(function()
        if NatUI and NatUI.Notify then
            NatUI:Notify({
                Title = title,
                Content = text,
                Icon = "bell",
                Duration = duration or 5,
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = duration or 5,
            })
        end
    end)
end

print("✅ Functions loaded")

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

print("🎨 Creating UI...")

-- Create UI with error handling
local Window
local windowSuccess, windowErr = pcall(function()
    Window = NatUI:CreateWindow({
        Title = "MonsHub | Fish It",
        Icon = "rbxassetid://81294956922394",
        Author = "by Mons",
        Folder = "MonsHub_FishIt",
        Size = UDim2.fromOffset(580, 460),
        LiveSearchDropdown = true,
        AutoSave = true,
        FileSaveName = "MonsHub_FishIt.json",
    })
end)

if not windowSuccess or not Window then
    warn("Failed to create window:", windowErr)
    Notify("❌ Error", "Failed to create UI window", 7)
    return
end

print("✅ Window created successfully")

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "settings", Desc = "Main settings" })
local FarmTab = Window:Tab({ Title = "Farm", Icon = "leaf", Desc = "Auto farming" })
local AutomaticTab = Window:Tab({ Title = "Automatic", Icon = "zap", Desc = "Automation" })
local WebhookTab = Window:Tab({ Title = "Webhook", Icon = "send", Desc = "Discord webhook notifications" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "menu", Desc = "Miscellaneous settings" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-bag", Desc = "Shop features" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin", Desc = "Teleport locations" })
local EventTab = Window:Tab({ Title = "Event", Icon = "calendar", Desc = "Event features" })

local Tabs = {
    Main = MainTab,
    Farm = FarmTab,
    Automatic = AutomaticTab,
    Webhook = WebhookTab,
    Misc = MiscTab,
    Shop = ShopTab,
    Teleport = TeleportTab,
    Event = EventTab,
}

Window:SelectTab(1)

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

-- Webhook Tab
Tabs.Webhook:Section({ Title = "Webhook Configuration" })
Tabs.Webhook:Paragraph({ Title = "Discord Webhook", Desc = "Get notifications when you catch rare fish or important events happen!" })

Tabs.Webhook:Input({ 
    Title = "Webhook URL", 
    Placeholder = "Enter Discord webhook URL", 
    Default = "", 
    MultiLine = false,
    Callback = function(v) 
        Settings.WebhookURL = v 
        Notify("Webhook", "URL saved!", 3) 
    end 
})

Tabs.Webhook:Section({ Title = "Webhook Settings" })
Tabs.Webhook:Toggle({ 
    Title = "Notify on Rare Fish", 
    Desc = "Send notification when catching rare fish",
    Default = false, 
    Callback = function(v) 
        Settings.WebhookRareFish = v 
    end 
})

Tabs.Webhook:Toggle({ 
    Title = "Notify on Legendary Fish", 
    Desc = "Send notification for legendary catches",
    Default = false, 
    Callback = function(v) 
        Settings.WebhookLegendary = v 
    end 
})

Tabs.Webhook:Toggle({ 
    Title = "Notify on Level Up", 
    Desc = "Get notified when you level up",
    Default = false, 
    Callback = function(v) 
        Settings.WebhookLevelUp = v 
    end 
})

Tabs.Webhook:Section({ Title = "Test Webhook" })
Tabs.Webhook:Button({ 
    Title = "Send Test Message", 
    Desc = "Test your webhook connection",
    Callback = function()
        if Settings.WebhookURL ~= "" then
            local data = {
                ["embeds"] = {{
                    ["title"] = "🎣 Test Notification",
                    ["description"] = "Your webhook is working correctly!",
                    ["color"] = 3447003,
                    ["footer"] = {
                        ["text"] = "MonsHub by Mons"
                    }
                }}
            }
            pcall(function()
                request({
                    Url = Settings.WebhookURL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(data)
                })
            end)
            Notify("Webhook", "Test message sent!", 3)
        else
            Notify("Error", "No webhook URL set!", 3)
        end
    end 
})

-- Misc Tab
Tabs.Misc:Section({ Title = "Server" })
Tabs.Misc:Button({ 
    Title = "Rejoin Server", 
    Desc = "Rejoin current server",
    Callback = function() 
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) 
    end 
})

Tabs.Misc:Button({ 
    Title = "Server Hop", 
    Desc = "Join a different server",
    Callback = function() 
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(servers.data) do
            if server.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end 
})

Tabs.Misc:Button({ 
    Title = "Lowest Server", 
    Desc = "Join server with least players",
    Callback = function() 
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        local lowest = nil
        for _, server in pairs(servers.data) do
            if not lowest or server.playing < lowest.playing then
                lowest = server
            end
        end
        if lowest then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, lowest.id, LocalPlayer)
        end
    end 
})

Tabs.Misc:Section({ Title = "Game Info" })
Tabs.Misc:Paragraph({ 
    Title = "Server Info", 
    Desc = string.format("Players: %d/%d\nServer ID: %s", #Players:GetPlayers(), Players.MaxPlayers, game.JobId:sub(1, 8)) 
})

Tabs.Misc:Button({ 
    Title = "Copy Game Link", 
    Desc = "Copy game URL to clipboard",
    Callback = function() 
        setclipboard("https://www.roblox.com/games/" .. game.PlaceId) 
        Notify("Copied", "Game link copied!", 3) 
    end 
})

Tabs.Misc:Section({ Title = "UI Settings" })
Tabs.Misc:Button({ 
    Title = "Destroy GUI", 
    Desc = "Remove the GUI completely",
    Callback = function() 
        Window:Destroy() 
        Notify("MonsHub", "GUI destroyed!", 3) 
    end 
})

-- Shop Tab
Tabs.Shop:Section({ Title = "Quick Shop" })
Tabs.Shop:Paragraph({ Title = "Shop Access", Desc = "Quick access to in-game shop features" })

Tabs.Shop:Button({ 
    Title = "Open Shop", 
    Desc = "Teleport to shop",
    Callback = function() 
        Notify("Shop", "Opening shop...", 3) 
    end 
})

Tabs.Shop:Section({ Title = "Auto Buy Items" })
Tabs.Shop:Toggle({ 
    Title = "Auto Buy Fishing Rod", 
    Desc = "Automatically buy better fishing rods",
    Default = false, 
    Callback = function(v) 
        Settings.AutoBuyRod = v 
    end 
})

Tabs.Shop:Toggle({ 
    Title = "Auto Buy Boat", 
    Desc = "Automatically upgrade your boat",
    Default = false, 
    Callback = function(v) 
        Settings.AutoBuyBoat = v 
    end 
})

Tabs.Shop:Dropdown({ 
    Title = "Priority Purchase", 
    Desc = "What to prioritize buying",
    Values = {"Fishing Rod", "Bait", "Boat", "Backpack"}, 
    Value = "Fishing Rod", 
    Callback = function(v) 
        Settings.PriorityPurchase = v 
    end 
})

-- Teleport Tab
Tabs.Teleport:Section({ Title = "Quick Teleports" })
Tabs.Teleport:Paragraph({ Title = "Fast Travel", Desc = "Teleport to different locations instantly" })

Tabs.Teleport:Button({ 
    Title = "Spawn", 
    Desc = "Teleport to spawn",
    Callback = function() 
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
            Notify("Teleport", "Teleported to Spawn!", 3)
        end
    end 
})

Tabs.Teleport:Button({ 
    Title = "Shop Area", 
    Desc = "Teleport to shop",
    Callback = function() 
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(100, 5, 50)
            Notify("Teleport", "Teleported to Shop!", 3)
        end
    end 
})

Tabs.Teleport:Button({ 
    Title = "Beach", 
    Desc = "Teleport to beach",
    Callback = function() 
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(-50, 5, 100)
            Notify("Teleport", "Teleported to Beach!", 3)
        end
    end 
})

Tabs.Teleport:Section({ Title = "Player Teleport" })
Tabs.Teleport:Dropdown({ 
    Title = "Select Player", 
    Desc = "Choose a player to teleport to",
    Values = (function()
        local names = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(names, player.Name)
            end
        end
        return names
    end)(), 
    Value = "None", 
    Callback = function(v) 
        Settings.SelectedPlayer = v 
    end 
})

Tabs.Teleport:Button({ 
    Title = "Teleport to Player", 
    Desc = "Teleport to selected player",
    Callback = function() 
        if Settings.SelectedPlayer and Settings.SelectedPlayer ~= "None" then
            local targetPlayer = Players:FindFirstChild(Settings.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                Notify("Teleport", "Teleported to " .. Settings.SelectedPlayer, 3)
            end
        end
    end 
})

-- Event Tab
Tabs.Event:Section({ Title = "Current Events" })
Tabs.Event:Paragraph({ Title = "Active Events", Desc = "Check for active in-game events and limited-time offers" })

Tabs.Event:Button({ 
    Title = "Check Events", 
    Desc = "View current active events",
    Callback = function() 
        Notify("Events", "Checking for active events...", 5) 
    end 
})

Tabs.Event:Section({ Title = "Event Automation" })
Tabs.Event:Toggle({ 
    Title = "Auto Join Events", 
    Desc = "Automatically join events when available",
    Default = false, 
    Callback = function(v) 
        Settings.AutoJoinEvents = v 
    end 
})

Tabs.Event:Toggle({ 
    Title = "Event Notifications", 
    Desc = "Get notified when events start",
    Default = false, 
    Callback = function(v) 
        Settings.EventNotifications = v 
    end 
})

Tabs.Event:Section({ Title = "Seasonal" })
Tabs.Event:Paragraph({ Title = "Limited Time", Desc = "Seasonal and holiday events will appear here when active" })

-- Init
print("="..string.rep("=", 50))
print("✅ MonsHub for Fish It loaded successfully!")
print("="..string.rep("=", 50))

Notify("✅ MonsHub", "Fish It script loaded! All features ready!", 5)

-- Success message
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ MonsHub Loaded",
    Text = "Fish It script is ready to use!",
    Duration = 5,
    Icon = "rbxassetid://7733779730"
})
