-- MonsHub | Fist It Script - Fixed Version
-- by Mons
-- Version: v1.1.0

-- Simple notification function
local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5,
        })
    end)
end

-- Try to load UI library
local NatUI
local success = pcall(function()
    NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/bmF0dWk-/refs/heads/main/ui.lua"))()
end)

if not success or not NatUI then
    Notify("MonsHub Error", "Failed to load UI library. Please try again later.", 10)
    warn("MonsHub: Failed to load NatUI library")
    return
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Wait for character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    AutoFishingLegit = false,
    AutoFishingNormal = false,
    FishingDelay = 1.5,
    InstantFishing = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
}

-- Create Window
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

-- Create Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "settings", Desc = "Main settings" })
local FarmTab = Window:Tab({ Title = "Farm", Icon = "leaf", Desc = "Auto farming" })
local AutomaticTab = Window:Tab({ Title = "Automatic", Icon = "zap", Desc = "Automation" })

-- Main Tab Content
MainTab:Section({ Title = "Information" })
MainTab:Paragraph({ Title = "MonsHub Fist It", Desc = "Premium script for Fist It game\nJoin our Discord for support!" })

MainTab:Button({ 
    Title = "Join Discord", 
    Callback = function() 
        setclipboard("https://discord.gg/monshub") 
        Notify("Discord", "Link copied to clipboard!", 3) 
    end 
})

MainTab:Section({ Title = "Player Settings" })
MainTab:Slider({ 
    Title = "Walk Speed", 
    Min = 16, 
    Max = 200, 
    Default = 16, 
    Callback = function(v) 
        Settings.WalkSpeed = v 
        if Humanoid then Humanoid.WalkSpeed = v end 
    end 
})

MainTab:Slider({ 
    Title = "Jump Power", 
    Min = 50, 
    Max = 300, 
    Default = 50, 
    Callback = function(v) 
        Settings.JumpPower = v 
        if Humanoid then Humanoid.JumpPower = v end 
    end 
})

MainTab:Toggle({ 
    Title = "Infinite Jump", 
    Default = false, 
    Callback = function(v) 
        Settings.InfiniteJump = v 
    end 
})

MainTab:Button({ 
    Title = "Reset Character", 
    Callback = function() 
        LocalPlayer.Character:BreakJoints() 
    end 
})

-- Farm Tab Content
FarmTab:Section({ Title = "Auto Click/Punch" })
FarmTab:Toggle({ 
    Title = "Auto Click", 
    Desc = "Automatically click/punch", 
    Default = false, 
    Callback = function(v) 
        Settings.AutoClick = v
        if v then
            spawn(function()
                while Settings.AutoClick do
                    wait(0.1)
                    -- Simulate click
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    wait(0.01)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end)
        end
    end 
})

FarmTab:Slider({ 
    Title = "Click Delay", 
    Min = 0.01, 
    Max = 1, 
    Default = 0.1, 
    Callback = function(v) 
        Settings.ClickDelay = v 
    end 
})

FarmTab:Section({ Title = "Auto Rebirth" })
FarmTab:Toggle({ 
    Title = "Auto Rebirth", 
    Desc = "Automatically rebirth when possible", 
    Default = false, 
    Callback = function(v) 
        Settings.AutoRebirth = v 
    end 
})

-- Automatic Tab Content
AutomaticTab:Section({ Title = "Auto Collect" })
AutomaticTab:Toggle({ 
    Title = "Auto Collect Coins", 
    Default = false, 
    Callback = function(v) 
        Settings.AutoCollectCoins = v 
    end 
})

AutomaticTab:Section({ Title = "Auto Upgrade" })
AutomaticTab:Toggle({ 
    Title = "Auto Upgrade Strength", 
    Default = false, 
    Callback = function(v) 
        Settings.AutoUpgradeStrength = v 
    end 
})

AutomaticTab:Section({ Title = "Utilities" })
AutomaticTab:Button({ 
    Title = "Rejoin Server", 
    Callback = function() 
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) 
    end 
})

AutomaticTab:Button({ 
    Title = "Destroy GUI", 
    Callback = function() 
        Window:Destroy() 
    end 
})

-- Character Reset Handler
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

-- Success message
Notify("MonsHub", "Fist It script loaded successfully!", 5)
print("MonsHub: Script loaded successfully")