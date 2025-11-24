-- Load WindUI Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Create Window
local Window = WindUI:CreateWindow({
	Title = "Monshub | V0.0.01",
	Author = "Premium Hub Script",
	Folder = "Monshub",
	NewElements = true,
	
	HideSearchBar = false,
	
	OpenButton = {
		Title = "Open Monshub",
		CornerRadius = UDim.new(0.2, 0),
		StrokeThickness = 2,
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		
		Color = ColorSequence.new(
			Color3.fromRGB(41, 128, 185),
			Color3.fromRGB(109, 213, 250)
		)
	}
})

-- Blue Sky Theme
WindUI:AddTheme({
	Name = "BlueSkye",
	
	Accent = Color3.fromRGB(52, 152, 219),
	Dialog = Color3.fromRGB(23, 32, 42),
	Outline = Color3.fromRGB(52, 152, 219),
	Text = Color3.fromRGB(236, 240, 241),
	Placeholder = Color3.fromRGB(149, 165, 166),
	Button = Color3.fromRGB(44, 62, 80),
	Icon = Color3.fromRGB(52, 152, 219),
	
	WindowBackground = Color3.fromRGB(23, 32, 42),
	
	TopbarButtonIcon = Color3.fromRGB(52, 152, 219),
	TopbarTitle = Color3.fromRGB(236, 240, 241),
	TopbarAuthor = Color3.fromRGB(149, 165, 166),
	TopbarIcon = Color3.fromRGB(52, 152, 219),
	
	TabBackground = Color3.fromRGB(44, 62, 80),
	TabTitle = Color3.fromRGB(236, 240, 241),
	TabIcon = Color3.fromRGB(52, 152, 219),
	
	ElementBackground = Color3.fromRGB(44, 62, 80),
	ElementTitle = Color3.fromRGB(236, 240, 241),
	ElementDesc = Color3.fromRGB(189, 195, 199),
	ElementIcon = Color3.fromRGB(52, 152, 219),
})

WindUI:SetTheme("BlueSkye")

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
