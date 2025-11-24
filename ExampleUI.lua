-- Load WindUI Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Create Window
local Window = WindUI:CreateWindow({
	Title = "Monshub  | v0.0.0.0",
	Author = "by Mons",
	Folder = "Monshub",
	NewElements = true,
	Icon = "rbxassetid://81294956922394",
	
	HideSearchBar = false,
	Keybind = Enum.KeyCode.RightControl,
	
	OpenButton = {
		Title = "Open Monshub",
		Size = UDim2.fromOffset(180, 50),
		Position = UDim2.new(0.5, -90, 0, 20),
		CornerRadius = UDim.new(0.3, 0),
		StrokeThickness = 2,
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		Icon = "rbxassetid://81294956922394",
		
		Color = ColorSequence.new(
			Color3.fromRGB(26, 82, 118),
			Color3.fromRGB(73, 160, 157)
		)
	}
})

-- Force enable draggable for open button
task.wait(0.5)
local OpenButton = game:GetService("CoreGui"):FindFirstChild("WindUI")
if OpenButton then
	local Button = OpenButton:FindFirstChild("OpenButton", true)
	if Button and Button:IsA("GuiButton") or Button:IsA("Frame") then
		local UserInputService = game:GetService("UserInputService")
		local dragging, dragInput, dragStart, startPos
		
		local function update(input)
			local delta = input.Position - dragStart
			Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
		
		Button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = Button.Position
				
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		
		Button.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end
end

-- Dark Teal Theme (matching the image)
WindUI:AddTheme({
	Name = "MonsHubDark",
	
	Accent = Color3.fromRGB(44, 130, 145),
	Dialog = Color3.fromRGB(31, 41, 51),
	Outline = Color3.fromRGB(44, 130, 145),
	Text = Color3.fromRGB(255, 255, 255),
	Placeholder = Color3.fromRGB(150, 150, 150),
	Button = Color3.fromRGB(45, 55, 65),
	Icon = Color3.fromRGB(44, 130, 145),
	
	WindowBackground = Color3.fromRGB(38, 50, 56),
	
	TopbarButtonIcon = Color3.fromRGB(44, 130, 145),
	TopbarTitle = Color3.fromRGB(255, 255, 255),
	TopbarAuthor = Color3.fromRGB(176, 190, 197),
	TopbarIcon = Color3.fromRGB(44, 130, 145),
	
	TabBackground = Color3.fromRGB(31, 41, 51),
	TabTitle = Color3.fromRGB(255, 255, 255),
	TabIcon = Color3.fromRGB(120, 144, 156),
	
	ElementBackground = Color3.fromRGB(45, 55, 65),
	ElementTitle = Color3.fromRGB(255, 255, 255),
	ElementDesc = Color3.fromRGB(176, 190, 197),
	ElementIcon = Color3.fromRGB(44, 130, 145),
})

WindUI:SetTheme("MonsHubDark")

-- Tab: Main
local MainTab = Window:Tab({
	Title = "Main",
	Icon = "settings"
})

local InfoSection = MainTab:Section({
	Title = "Information"
})

InfoSection:Button({
	Title = "Show Information",
	Desc = "Display hub information",
	Callback = function()
		print("Monshub Information")
	end
})

-- Tab: Farm
local FarmTab = Window:Tab({
	Title = "Farm",
	Icon = "leaf"
})

local PlayerSection = FarmTab:Section({
	Title = "Player"
})

PlayerSection:Toggle({
	Title = "Auto Farm",
	Desc = "Automatically farm resources",
	Default = false,
	Callback = function(value)
		print("Auto Farm:", value)
	end
})

-- Tab: Automatic
local AutoTab = Window:Tab({
	Title = "Automatic",
	Icon = "zap"
})

local IdentitySection = AutoTab:Section({
	Title = "Identity"
})

IdentitySection:Button({
	Title = "Configure Identity",
	Desc = "Set up automatic identity",
	Callback = function()
		print("Identity configured")
	end
})

-- Tab: Webhook
local WebhookTab = Window:Tab({
	Title = "Webhook",
	Icon = "send"
})

local VisualSection = WebhookTab:Section({
	Title = "Visual"
})

VisualSection:Input({
	Title = "Webhook URL",
	Desc = "Enter your Discord webhook URL",
	Placeholder = "https://discord.com/api/webhooks/...",
	Callback = function(value)
		print("Webhook URL:", value)
	end
})

-- Tab: Misc
local MiscTab = Window:Tab({
	Title = "Misc",
	Icon = "menu"
})

local ExternalSection = MiscTab:Section({
	Title = "External"
})

ExternalSection:Button({
	Title = "External Settings",
	Desc = "Configure external features",
	Callback = function()
		print("External settings")
	end
})

-- Tab: Shop
local ShopTab = Window:Tab({
	Title = "Shop",
	Icon = "shopping-bag"
})

ShopTab:Section({
	Title = "Shop Items"
}):Button({
	Title = "Open Shop",
	Desc = "Browse available items",
	Callback = function()
		print("Shop opened")
	end
})

-- Tab: Teleport
local TeleportTab = Window:Tab({
	Title = "Teleport",
	Icon = "map-pin"
})

TeleportTab:Section({
	Title = "Locations"
}):Button({
	Title = "Teleport to Spawn",
	Desc = "Return to spawn location",
	Callback = function()
		print("Teleporting to spawn")
	end
})

-- Tab: Event
local EventTab = Window:Tab({
	Title = "Event",
	Icon = "calendar"
})

EventTab:Section({
	Title = "Active Events"
}):Button({
	Title = "Check Events",
	Desc = "View current active events",
	Callback = function()
		print("Checking events")
	end
})
