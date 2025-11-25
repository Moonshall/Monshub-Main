-- MonsUI Enhanced Library
-- Modern UI improvement script
-- Place this at the beginning of your source UI file

local TweenService = game:GetService("TweenService")

-- ========================================
-- 🎨 MODERN COLOR PALETTE
-- ========================================
local COLORS = {
    -- Backgrounds
    PRIMARY_BG = Color3.fromRGB(20, 23, 30),
    SECONDARY_BG = Color3.fromRGB(28, 32, 40),
    TERTIARY_BG = Color3.fromRGB(35, 39, 48),
    
    -- Accents
    ACCENT_PRIMARY = Color3.fromRGB(88, 166, 255),
    ACCENT_SECONDARY = Color3.fromRGB(138, 99, 255),
    ACCENT_SUCCESS = Color3.fromRGB(82, 196, 26),
    ACCENT_WARNING = Color3.fromRGB(250, 173, 20),
    ACCENT_DANGER = Color3.fromRGB(255, 77, 79),
    
    -- Text
    TEXT_PRIMARY = Color3.fromRGB(230, 235, 245),
    TEXT_SECONDARY = Color3.fromRGB(160, 170, 190),
    TEXT_MUTED = Color3.fromRGB(120, 130, 150),
    
    -- UI Elements
    BORDER = Color3.fromRGB(45, 52, 65),
    BORDER_LIGHT = Color3.fromRGB(55, 62, 75),
    HOVER = Color3.fromRGB(35, 40, 50),
    ACTIVE = Color3.fromRGB(40, 45, 55),
}

-- ========================================
-- 🎬 ANIMATION UTILITIES
-- ========================================
local Animations = {}

-- Smooth fade animation
function Animations.Fade(element, duration, targetTransparency)
    local tween = TweenService:Create(element, 
        TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = targetTransparency or 0}
    )
    tween:Play()
    return tween
end

-- Scale animation
function Animations.Scale(element, duration, targetScale)
    local originalSize = element.Size
    local tween = TweenService:Create(element,
        TweenInfo.new(duration or 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(
            originalSize.X.Scale * targetScale,
            originalSize.X.Offset * targetScale,
            originalSize.Y.Scale * targetScale,
            originalSize.Y.Offset * targetScale
        )}
    )
    tween:Play()
    return tween
end

-- Slide animation
function Animations.Slide(element, duration, targetPosition)
    local tween = TweenService:Create(element,
        TweenInfo.new(duration or 0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
        {Position = targetPosition}
    )
    tween:Play()
    return tween
end

-- Bounce animation
function Animations.Bounce(element)
    local originalSize = element.Size
    local grow = TweenService:Create(element,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(
            originalSize.X.Scale * 1.05,
            originalSize.X.Offset * 1.05,
            originalSize.Y.Scale * 1.05,
            originalSize.Y.Offset * 1.05
        )}
    )
    
    local shrink = TweenService:Create(element,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = originalSize}
    )
    
    grow:Play()
    grow.Completed:Connect(function()
        shrink:Play()
    end)
end

-- ========================================
-- ✨ EFFECT UTILITIES
-- ========================================
local Effects = {}

-- Add ripple effect on click
function Effects.Ripple(button)
    button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.7
        ripple.ZIndex = button.ZIndex + 10
        ripple.BorderSizePixel = 0
        ripple.Parent = button
        
        local corner = Instance.new("UICorner", ripple)
        corner.CornerRadius = UDim.new(1, 0)
        
        local expand = TweenService:Create(ripple,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(2, 0, 2, 0),
                BackgroundTransparency = 1
            }
        )
        
        expand:Play()
        expand.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

-- Add glow effect
function Effects.Glow(element, glowColor)
    local stroke = Instance.new("UIStroke", element)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = glowColor or COLORS.ACCENT_PRIMARY
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    
    -- Pulsing animation
    local pulse = TweenService:Create(stroke,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.2}
    )
    pulse:Play()
    
    return stroke
end

-- Add hover effect
function Effects.Hover(button, hoverColor)
    local originalColor = button.BackgroundColor3
    local originalSize = button.Size
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor or COLORS.HOVER,
            Size = UDim2.new(
                originalSize.X.Scale, originalSize.X.Offset + 2,
                originalSize.Y.Scale, originalSize.Y.Offset + 2
            )
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            Size = originalSize
        }):Play()
    end)
end

-- Add shadow effect
function Effects.Shadow(element, shadowIntensity)
    local shadow = Instance.new("ImageLabel", element)
    shadow.Name = "DropShadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = shadowIntensity or 0.75
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.ZIndex = element.ZIndex - 1
    
    return shadow
end

-- ========================================
-- 🔔 NOTIFICATION SYSTEM
-- ========================================
local Notifications = {}

function Notifications.Create(config)
    local title = config.Title or "Notification"
    local message = config.Message or ""
    local duration = config.Duration or 3
    local notifType = config.Type or "info" -- info, success, warning, error
    
    local colors = {
        info = COLORS.ACCENT_PRIMARY,
        success = COLORS.ACCENT_SUCCESS,
        warning = COLORS.ACCENT_WARNING,
        error = COLORS.ACCENT_DANGER
    }
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.BackgroundColor3 = COLORS.SECONDARY_BG
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, 20, 1, 20)
    notif.AnchorPoint = Vector2.new(0, 1)
    notif.BorderSizePixel = 0
    notif.ZIndex = 1000
    
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = colors[notifType]
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Size = UDim2.new(1, -30, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = COLORS.TEXT_PRIMARY
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    
    local messageLabel = Instance.new("TextLabel", notif)
    messageLabel.Name = "Message"
    messageLabel.BackgroundTransparency = 1
    messageLabel.Position = UDim2.new(0, 15, 0, 35)
    messageLabel.Size = UDim2.new(1, -30, 0, 35)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 12
    messageLabel.TextColor3 = COLORS.TEXT_SECONDARY
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Text = message
    
    -- Animation
    local slideIn = TweenService:Create(notif,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -320, 1, -20)}
    )
    
    slideIn:Play()
    
    -- Auto dismiss
    task.delay(duration, function()
        local slideOut = TweenService:Create(notif,
            TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 20, 1, 20)}
        )
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notif:Destroy()
        end)
    end)
    
    return notif
end

-- ========================================
-- 🎨 UI THEME APPLICATOR
-- ========================================
local Theme = {}

function Theme.ApplyToWindow(window)
    window.BackgroundColor3 = COLORS.PRIMARY_BG
    
    -- Add gradient
    if not window:FindFirstChild("UIGradient") then
        local gradient = Instance.new("UIGradient", window)
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, COLORS.SECONDARY_BG),
            ColorSequenceKeypoint.new(1, COLORS.PRIMARY_BG)
        }
        gradient.Rotation = 45
    end
end

function Theme.ApplyToButton(button)
    button.BackgroundColor3 = COLORS.SECONDARY_BG
    button.TextColor3 = COLORS.TEXT_PRIMARY
    
    Effects.Hover(button)
    Effects.Ripple(button)
end

function Theme.ApplyToTab(tab, isActive)
    if isActive then
        tab.BackgroundColor3 = COLORS.TERTIARY_BG
        if tab:FindFirstChild("TextLabel") then
            tab.TextLabel.TextColor3 = COLORS.TEXT_PRIMARY
            tab.TextLabel.TextTransparency = 0
        end
        if tab:FindFirstChild("Bar") then
            tab.Bar.Size = UDim2.new(0, 5, 0, 25)
            tab.Bar.BackgroundColor3 = COLORS.ACCENT_PRIMARY
        end
    else
        tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tab.BackgroundTransparency = 1
        if tab:FindFirstChild("TextLabel") then
            tab.TextLabel.TextColor3 = COLORS.TEXT_SECONDARY
            tab.TextLabel.TextTransparency = 0.5
        end
        if tab:FindFirstChild("Bar") then
            tab.Bar.Size = UDim2.new(0, 5, 0, 0)
        end
    end
end

-- ========================================
-- 📦 EXPORT MODULE
-- ========================================
return {
    Colors = COLORS,
    Animations = Animations,
    Effects = Effects,
    Notifications = Notifications,
    Theme = Theme
}
