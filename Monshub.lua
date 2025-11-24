repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)
local _function = {
    ["getid"] = function()
        local g = game.GameId
        if premium then
            if g == 6701277882 then return "" -- Fish It
           
        else
            if g == 6701277882 then return "" -- Fish It
           
    end,
    ["gamename"] = function()
        local g = game.GameId
           if g == 6701277882 then return "Fish It"
       
        end
    end,
    ["load"] = function(url)
        local game_url = game:HttpGet(url)
        return (load or loadstring)(game_url)()
    end
}
local keyless_script = {

}
local script_id, game_name = _function.getid(), _function.gamename()
if script_id then
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "MonsHub Loaded!",
            Text = game_name .. " Script Loaded!",
            Icon = "rbxassetid://99764942615873",
            Duration = 5
        }
   