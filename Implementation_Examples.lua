-- ========================================
-- EXAMPLE: How to Apply MonsUI Enhancements
-- ========================================

-- Load the enhanced library
local Enhanced = loadstring(game:HttpGet("path/to/MonsUI_Enhanced.lua"))()

-- Or if using module:
-- local Enhanced = require(script.MonsUI_Enhanced)

-- ========================================
-- EXAMPLE 1: Apply Theme to Entire UI
-- ========================================

-- Apply to main window
Enhanced.Theme.ApplyToWindow(MonsUI["2"])

-- Apply to all buttons
for _, button in pairs(MonsUI["14"]:GetChildren()) do
    if button:IsA("ImageButton") or button:IsA("TextButton") then
        Enhanced.Theme.ApplyToButton(button)
    end
end

-- ========================================
-- EXAMPLE 2: Enhanced Tab Switching
-- ========================================

local currentTab = nil

local function SwitchTab(tabButton, tabContent)
    -- Deactivate old tab
    if currentTab then
        Enhanced.Theme.ApplyToTab(currentTab, false)
        Enhanced.Animations.Fade(currentTab.Content, 0.2, 1)
    end
    
    -- Activate new tab
    Enhanced.Theme.ApplyToTab(tabButton, true)
    Enhanced.Animations.Fade(tabContent, 0.3, 0)
    Enhanced.Animations.Slide(tabContent, 0.3, UDim2.new(0, 0, 0, 0))
    
    currentTab = tabButton
    
    -- Show notification
    Enhanced.Notifications.Create({
        Title = "Tab Switched",
        Message = "Switched to " .. tabButton.Name,
        Type = "info",
        Duration = 2
    })
end

-- ========================================
-- EXAMPLE 3: Button Click with Effects
-- ========================================

local function SetupButton(button, onClick)
    -- Add all effects
    Enhanced.Effects.Hover(button)
    Enhanced.Effects.Ripple(button)
    Enhanced.Effects.Shadow(button, 0.8)
    
    button.MouseButton1Click:Connect(function()
        -- Bounce animation
        Enhanced.Animations.Bounce(button)
        
        -- Execute callback
        if onClick then
            onClick()
        end
    end)
end

-- Example usage
SetupButton(MonsUI["SomeButton"], function()
    print("Button clicked!")
    Enhanced.Notifications.Create({
        Title = "Success!",
        Message = "Action completed successfully",
        Type = "success",
        Duration = 3
    })
end)

-- ========================================
-- EXAMPLE 4: Dropdown with Animation
-- ========================================

local dropdownOpen = false

local function ToggleDropdown(dropdown)
    dropdownOpen = not dropdownOpen
    
    if dropdownOpen then
        dropdown.Visible = true
        Enhanced.Animations.Scale(dropdown, 0.3, 1)
        Enhanced.Animations.Fade(dropdown, 0.3, 0)
        
        -- Add glow effect
        Enhanced.Effects.Glow(dropdown, Enhanced.Colors.ACCENT_PRIMARY)
    else
        Enhanced.Animations.Scale(dropdown, 0.2, 0.8)
        Enhanced.Animations.Fade(dropdown, 0.2, 1)
        
        task.wait(0.2)
        dropdown.Visible = false
    end
end

-- ========================================
-- EXAMPLE 5: Search Bar Enhancement
-- ========================================

local function EnhanceSearchBar(searchBox)
    local originalBorder = searchBox.Parent.UIStroke.Color
    
    -- Focus effects
    searchBox.Focused:Connect(function()
        Enhanced.Effects.Glow(searchBox.Parent, Enhanced.Colors.ACCENT_PRIMARY)
        
        TweenService:Create(searchBox.Parent.UIStroke,
            TweenInfo.new(0.2),
            {
                Color = Enhanced.Colors.ACCENT_PRIMARY,
                Thickness = 2
            }
        ):Play()
    end)
    
    searchBox.FocusLost:Connect(function()
        if searchBox.Parent:FindFirstChild("UIStroke") then
            local glow = searchBox.Parent:FindFirstChildOfClass("UIStroke")
            if glow then glow:Destroy() end
        end
        
        TweenService:Create(searchBox.Parent.UIStroke,
            TweenInfo.new(0.2),
            {
                Color = originalBorder,
                Thickness = 1.5
            }
        ):Play()
    end)
end

-- ========================================
-- EXAMPLE 6: Loading Animation
-- ========================================

local function ShowLoadingAnimation(parentFrame)
    local loading = Instance.new("Frame")
    loading.Name = "Loading"
    loading.BackgroundTransparency = 1
    loading.Size = UDim2.new(1, 0, 1, 0)
    loading.ZIndex = 999
    loading.Parent = parentFrame
    
    local spinner = Instance.new("ImageLabel", loading)
    spinner.BackgroundTransparency = 1
    spinner.Image = "rbxassetid://7072721559" -- Loading icon
    spinner.ImageColor3 = Enhanced.Colors.ACCENT_PRIMARY
    spinner.Size = UDim2.new(0, 40, 0, 40)
    spinner.Position = UDim2.new(0.5, 0, 0.5, 0)
    spinner.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Rotate animation
    local rotate = TweenService:Create(spinner,
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1),
        {Rotation = 360}
    )
    rotate:Play()
    
    return loading
end

local function HideLoadingAnimation(loading)
    Enhanced.Animations.Fade(loading, 0.3, 1)
    task.wait(0.3)
    loading:Destroy()
end

-- ========================================
-- EXAMPLE 7: Window Open/Close Animation
-- ========================================

local function AnimateWindowOpen(window)
    window.Size = UDim2.new(0, 0, 0, 0)
    window.Visible = true
    
    -- Scale animation
    local openTween = TweenService:Create(window,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 528, 0, 334)}
    )
    openTween:Play()
    
    -- Add blur effect to background
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game.Lighting
    
    TweenService:Create(blur,
        TweenInfo.new(0.5),
        {Size = 20}
    ):Play()
end

local function AnimateWindowClose(window)
    -- Remove blur
    local blur = game.Lighting:FindFirstChildOfClass("BlurEffect")
    if blur then
        TweenService:Create(blur,
            TweenInfo.new(0.3),
            {Size = 0}
        ):Play()
        task.delay(0.3, function() blur:Destroy() end)
    end
    
    -- Scale down
    local closeTween = TweenService:Create(window,
        TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    )
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        window.Visible = false
    end)
end

-- ========================================
-- EXAMPLE 8: Toggle Switch with Animation
-- ========================================

local function CreateToggle(parent, defaultState, callback)
    local toggle = Instance.new("Frame", parent)
    toggle.BackgroundColor3 = defaultState and Enhanced.Colors.ACCENT_SUCCESS or Enhanced.Colors.BORDER
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", toggle)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = defaultState and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.BorderSizePixel = 0
    
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local isOn = defaultState
    
    local button = Instance.new("TextButton", toggle)
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    
    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        
        -- Animate toggle
        TweenService:Create(knob,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = isOn and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}
        ):Play()
        
        TweenService:Create(toggle,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = isOn and Enhanced.Colors.ACCENT_SUCCESS or Enhanced.Colors.BORDER}
        ):Play()
        
        -- Callback
        if callback then
            callback(isOn)
        end
    end)
    
    return toggle
end

-- ========================================
-- EXAMPLE 9: Progress Bar
-- ========================================

local function CreateProgressBar(parent, initialProgress)
    local bg = Instance.new("Frame", parent)
    bg.BackgroundColor3 = Enhanced.Colors.SECONDARY_BG
    bg.Size = UDim2.new(1, 0, 0, 6)
    bg.BorderSizePixel = 0
    
    local bgCorner = Instance.new("UICorner", bg)
    bgCorner.CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", bg)
    fill.BackgroundColor3 = Enhanced.Colors.ACCENT_PRIMARY
    fill.Size = UDim2.new(initialProgress or 0, 0, 1, 0)
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    -- Add gradient
    local gradient = Instance.new("UIGradient", fill)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Enhanced.Colors.ACCENT_PRIMARY),
        ColorSequenceKeypoint.new(1, Enhanced.Colors.ACCENT_SECONDARY)
    }
    
    return {
        SetProgress = function(progress)
            TweenService:Create(fill,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)}
            ):Play()
        end
    }
end

-- ========================================
-- EXAMPLE 10: Context Menu
-- ========================================

local function CreateContextMenu(position, options)
    local menu = Instance.new("Frame")
    menu.Name = "ContextMenu"
    menu.BackgroundColor3 = Enhanced.Colors.SECONDARY_BG
    menu.Size = UDim2.new(0, 150, 0, #options * 30)
    menu.Position = position
    menu.BorderSizePixel = 0
    menu.ZIndex = 1000
    
    local corner = Instance.new("UICorner", menu)
    corner.CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", menu)
    stroke.Color = Enhanced.Colors.BORDER
    stroke.Thickness = 1
    
    Enhanced.Effects.Shadow(menu, 0.7)
    
    local listLayout = Instance.new("UIListLayout", menu)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for i, option in ipairs(options) do
        local button = Instance.new("TextButton", menu)
        button.Name = "Option" .. i
        button.BackgroundColor3 = Enhanced.Colors.SECONDARY_BG
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BorderSizePixel = 0
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.TextColor3 = Enhanced.Colors.TEXT_PRIMARY
        button.Text = option.Text
        button.TextXAlignment = Enum.TextXAlignment.Left
        
        local padding = Instance.new("UIPadding", button)
        padding.PaddingLeft = UDim.new(0, 10)
        
        Enhanced.Effects.Hover(button)
        
        button.MouseButton1Click:Connect(function()
            if option.Callback then
                option.Callback()
            end
            menu:Destroy()
        end)
    end
    
    -- Fade in animation
    menu.BackgroundTransparency = 1
    Enhanced.Animations.Fade(menu, 0.2, 0)
    
    return menu
end

-- ========================================
-- COMPLETE SETUP EXAMPLE
-- ========================================

local function SetupCompleteUI()
    -- 1. Apply theme to window
    Enhanced.Theme.ApplyToWindow(MonsUI["2"])
    
    -- 2. Enhance all tabs
    for _, tab in pairs(MonsUI["14"]:GetChildren()) do
        if tab:IsA("ImageButton") and tab.Name == "TabButton" then
            Enhanced.Effects.Hover(tab)
            Enhanced.Effects.Ripple(tab)
        end
    end
    
    -- 3. Add window animations
    AnimateWindowOpen(MonsUI["2"])
    
    -- 4. Show welcome notification
    Enhanced.Notifications.Create({
        Title = "Welcome to MonsUI",
        Message = "Enhanced edition loaded successfully!",
        Type = "success",
        Duration = 3
    })
    
    print("✨ MonsUI Enhanced loaded successfully!")
end

-- Run setup
SetupCompleteUI()

-- ========================================
-- UTILITY: Apply to Existing UI
-- ========================================

-- Quick function to upgrade your current UI
local function UpgradeExistingUI()
    -- Colors
    MonsUI["2"].BackgroundColor3 = Enhanced.Colors.PRIMARY_BG
    MonsUI["13"].BackgroundColor3 = Enhanced.Colors.PRIMARY_BG
    
    -- All buttons
    for _, descendant in pairs(MonsUI["1"]:GetDescendants()) do
        if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
            Enhanced.Effects.Hover(descendant)
            Enhanced.Effects.Ripple(descendant)
        end
    end
    
    print("✅ UI upgraded with modern enhancements!")
end

-- Uncomment to auto-upgrade:
-- UpgradeExistingUI()
