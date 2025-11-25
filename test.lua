-- MonsHub Test Script
-- Simple script to verify loader is working

print("="..string.rep("=", 50))
print("✅ MonsHub Script Loaded Successfully!")
print("Script Version: 1.0.0")
print("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
print("="..string.rep("=", 50))

-- Show notification
local function ShowNotification()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ MonsHub",
            Text = "Script loaded successfully!",
            Duration = 5,
            Icon = "rbxassetid://7733779730"
        })
    end)
end

ShowNotification()

-- Return success
return true
