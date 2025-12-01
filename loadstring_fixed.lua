-- MonsHub Fist It Loader
-- Fixed version with error handling

local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Moonshall/Monshub-Main/main/FistIt_Fixed.lua"))()
end)

if not success then
    -- Fallback notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "MonsHub Error",
        Text = "Failed to load script. Check console for details.",
        Duration = 10,
    })
    warn("MonsHub Load Error: " .. tostring(result))
end