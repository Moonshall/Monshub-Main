-- MonsHub | Fish It Script - Standalone Version
-- by Mons
-- Version: v1.1.0 (No External Dependencies)

print("="..string.rep("=", 60))
print("🎣 MonsHub for Fish It - Standalone Version")
print("="..string.rep("=", 60))

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local Settings = {
    AutoFishing = false,
    FishingDelay = 2,
    AutoSell = false,
    WalkSpeed = 16,
    JumpPower = 50,
}

-- Simple Notification
local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🎣 " .. title,
            Text = text,
            Duration = duration or 5,
        })
    end)
    print("[MonsHub] " .. title .. ": " .. text)
end

-- Get Remote with retry
local function GetRemote(name, maxRetries)
    maxRetries = maxRetries or 3
    local retries = 0
    
    while retries < maxRetries do
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                if string.lower(v.Name):find(string.lower(name)) then
                    print("✅ Found remote:", v.Name)
                    return v
                end
            end
        end
        retries = retries + 1
        if retries < maxRetries then
            task.wait(0.5)
        end
    end
    
    warn("❌ Remote not found:", name)
    return nil
end

-- Auto Fishing
local function CastFishingRod()
    local success, err = pcall(function()
        local castRemote = GetRemote("cast", 1)
        if castRemote then
            if castRemote:IsA("RemoteEvent") then
                castRemote:FireServer("Old")
            elseif castRemote:IsA("RemoteFunction") then
                castRemote:InvokeServer("Old")
            end
            return true
        end
    end)
    return success
end

local function ReelFish()
    local success, err = pcall(function()
        local reelRemote = GetRemote("reel", 1)
        if reelRemote then
            if reelRemote:IsA("RemoteEvent") then
                reelRemote:FireServer()
            elseif reelRemote:IsA("RemoteFunction") then
                reelRemote:InvokeServer()
            end
            return true
        end
    end)
    return success
end

-- Auto Fishing Loop
spawn(function()
    while true do
        task.wait(0.1)
        if Settings.AutoFishing then
            local castSuccess = CastFishingRod()
            if castSuccess then
                task.wait(1.5)
                ReelFish()
                task.wait(Settings.FishingDelay)
            else
                task.wait(1)
            end
        end
    end
end)

-- Create Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = game.CoreGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(88, 166, 255)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.BackgroundColor3 = Color3.fromRGB(88, 166, 255)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎣 MonsHub | Fish It"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 77, 79)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Notify("MonsHub", "GUI closed", 3)
end)

-- Content Frame
local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = Content

-- Helper Functions
local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(35, 39, 48)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(230, 235, 245)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.BorderSizePixel = 0
    Button.Parent = Content
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    return Button
end

local function CreateToggle(text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 39, 48)
    Toggle.Text = "❌ " .. text
    Toggle.TextColor3 = Color3.fromRGB(230, 235, 245)
    Toggle.TextSize = 14
    Toggle.Font = Enum.Font.Gotham
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Content
    
    local TgCorner = Instance.new("UICorner")
    TgCorner.CornerRadius = UDim.new(0, 5)
    TgCorner.Parent = Toggle
    
    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        Toggle.Text = (enabled and "✅ " or "❌ ") .. text
        Toggle.BackgroundColor3 = enabled and Color3.fromRGB(82, 196, 26) or Color3.fromRGB(35, 39, 48)
        callback(enabled)
    end)
    
    return Toggle
end

-- UI Elements
CreateToggle("Auto Fishing", function(v)
    Settings.AutoFishing = v
    Notify("Auto Fishing", v and "Enabled" or "Disabled", 3)
end)

CreateButton("Teleport to Spawn", function()
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
        Notify("Teleport", "Teleported to spawn", 3)
    end
end)

CreateButton("Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)

CreateButton("Fly GUI", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)

CreateToggle("Noclip", function(v)
    Settings.Noclip = v
    if v then
        RunService.Stepped:Connect(function()
            if Settings.Noclip then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
    Notify("Noclip", v and "Enabled" or "Disabled", 3)
end)

-- Character Reset Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

print("="..string.rep("=", 60))
print("✅ MonsHub loaded successfully!")
print("="..string.rep("=", 60))

Notify("MonsHub", "Loaded successfully! Standalone version", 5)
