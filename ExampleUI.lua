-- Load NatUI Library
local NatUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/bmF0dWk-/refs/heads/main/ui.lua"))()

-- Create Window
local Window = NatUI:CreateWindow({
	Title = "MonsHub",
	Icon = "rbxassetid://81294956922394",
	Author = "by Mons",
	Folder = "MonsHub",
	Size = UDim2.fromOffset(580, 460),
	LiveSearchDropdown = true,
	AutoSave = true,
	FileSaveName = "MonsHub Config.json",
})

-- Create Tabs
local Tabs = {
	MainTab = Window:Tab({ Title = "Main", Icon = "settings", Desc = "Main features and information" }),
	FarmTab = Window:Tab({ Title = "Farm", Icon = "leaf", Desc = "Auto farm features" }),
	AutomaticTab = Window:Tab({ Title = "Automatic", Icon = "zap", Desc = "Automation features" }),
	WebhookTab = Window:Tab({ Title = "Webhook", Icon = "send", Desc = "Webhook configuration" }),
	MiscTab = Window:Tab({ Title = "Misc", Icon = "settings", Desc = "Miscellaneous settings" }),
	ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-bag", Desc = "Shop features" }),
	TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin", Desc = "Teleport locations" }),
	EventTab = Window:Tab({ Title = "Event", Icon = "calendar", Desc = "Event features" }),
}

-- Select first tab
Window:SelectTab(1)

-- Main Tab
Tabs.MainTab:Section({
	Title = "Information",
})

Tabs.MainTab:Paragraph({
	Title = "MonsHub Premium",
	Desc = "Welcome to MonsHub - Your premium scripting solution"
})

Tabs.MainTab:Button({
	Title = "Show Information",
	Desc = "Display hub information",
	Callback = function()
		NatUI:Notify({
			Title = "MonsHub Info",
			Content = "Version: v0.0.0.1\nDeveloped by Mons",
			Icon = "info",
			Duration = 5,
		})
	end
})

-- Farm Tab
Tabs.FarmTab:Section({
	Title = "Player",
})

Tabs.FarmTab:Toggle({
	Title = "Auto Farm",
	Default = false,
	Callback = function(state)
		print("Auto Farm:", state)
	end
})

Tabs.FarmTab:Toggle({
	Title = "Auto Collect",
	Default = false,
	Callback = function(state)
		print("Auto Collect:", state)
	end
})

Tabs.FarmTab:Slider({
	Title = "Farm Speed",
	Value = {
		Min = 1,
		Max = 10,
		Default = 5,
	},
	Callback = function(value)
		print("Farm Speed:", value)
	end
})

-- Automatic Tab
Tabs.AutomaticTab:Section({
	Title = "Identity",
})

Tabs.AutomaticTab:Button({
	Title = "Configure Identity",
	Desc = "Set up automatic identity",
	Callback = function()
		print("Identity configured")
	end
})

Tabs.AutomaticTab:Toggle({
	Title = "Auto Login",
	Default = false,
	Callback = function(state)
		print("Auto Login:", state)
	end
})

-- Webhook Tab
Tabs.WebhookTab:Section({
	Title = "Visual",
})

Tabs.WebhookTab:Input({
	Title = "Webhook URL",
	Default = "",
	Placeholder = "https://discord.com/api/webhooks/...",
	MultiLine = false,
	Callback = function(input)
		print("Webhook URL:", input)
	end
})

Tabs.WebhookTab:Button({
	Title = "Test Webhook",
	Desc = "Send test message to webhook",
	Callback = function()
		print("Testing webhook...")
	end
})

-- Misc Tab
Tabs.MiscTab:Section({
	Title = "External",
})

Tabs.MiscTab:Button({
	Title = "External Settings",
	Desc = "Configure external features",
	Callback = function()
		print("External settings")
	end
})

Tabs.MiscTab:Toggle({
	Title = "Show FPS",
	Default = false,
	Callback = function(state)
		print("Show FPS:", state)
	end
})

-- Shop Tab
Tabs.ShopTab:Section({
	Title = "Shop Items",
})

Tabs.ShopTab:Button({
	Title = "Open Shop",
	Desc = "Browse available items",
	Callback = function()
		print("Shop opened")
	end
})

Tabs.ShopTab:Dropdown({
	Title = "Select Item Category",
	Values = { "Weapons", "Tools", "Cosmetics", "Upgrades" },
	Value = "Weapons",
	Callback = function(option)
		print("Selected category:", option)
	end
})

-- Teleport Tab
Tabs.TeleportTab:Section({
	Title = "Locations",
})

Tabs.TeleportTab:Dropdown({
	Title = "Select Location",
	Values = { "Spawn", "Shop", "Arena", "Secret Area" },
	Value = "Spawn",
	Callback = function(option)
		print("Teleporting to:", option)
	end
})

Tabs.TeleportTab:Button({
	Title = "Teleport",
	Desc = "Teleport to selected location",
	Callback = function()
		print("Teleporting...")
	end
})

-- Event Tab
Tabs.EventTab:Section({
	Title = "Active Events",
})

Tabs.EventTab:Button({
	Title = "Check Events",
	Desc = "View current active events",
	Callback = function()
		NatUI:Notify({
			Title = "Events",
			Content = "No active events at the moment",
			Icon = "calendar",
			Duration = 5,
		})
	end
})

Tabs.EventTab:Toggle({
	Title = "Auto Join Events",
	Default = false,
	Callback = function(state)
		print("Auto Join Events:", state)
	end
})
