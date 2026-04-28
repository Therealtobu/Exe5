-- EXE5-Style UI Library for Executor Scripts
-- Replaces Linoria/Rayfield with EXE5 aesthetic
-- Colors: Dark #0F0F0F bg, #1F1F1F panels, #49F4C1 teal accent, #4179FF blue accent

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old if exists
local oldGui = playerGui:FindFirstChild("EXE5_Hub")
if oldGui then oldGui:Destroy() end

-- Colors
local C = {
    bg         = Color3.fromRGB(12, 12, 12),
    panel      = Color3.fromRGB(20, 20, 20),
    sidebar    = Color3.fromRGB(15, 15, 15),
    card       = Color3.fromRGB(28, 28, 28),
    cardHover  = Color3.fromRGB(35, 35, 35),
    accent     = Color3.fromRGB(73, 244, 193),
    accentBlue = Color3.fromRGB(65, 121, 255),
    border     = Color3.fromRGB(45, 45, 45),
    text       = Color3.fromRGB(255, 255, 255),
    textDim    = Color3.fromRGB(160, 160, 160),
    textMuted  = Color3.fromRGB(100, 100, 100),
    toggleOn   = Color3.fromRGB(73, 244, 193),
    toggleOff  = Color3.fromRGB(55, 55, 55),
    red        = Color3.fromRGB(255, 75, 75),
}

local function tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function corner(r, parent)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 6); c.Parent = parent; return c
end

local function stroke(color, thickness, parent)
    local s = Instance.new("UIStroke"); s.Color = color or C.border; s.Thickness = thickness or 1; s.Parent = parent; return s
end

local function label(text, size, color, parent, font)
    local l = Instance.new("TextLabel")
    l.Text = text; l.TextSize = size or 13; l.TextColor3 = color or C.text
    l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = font or Enum.Font.GothamMedium; l.Size = UDim2.new(1,0,0,size and size+4 or 18)
    l.Parent = parent; return l
end

local function newFrame(bg, parent, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or C.panel
    f.BorderSizePixel = 0
    f.Size = size or UDim2.new(1,0,1,0)
    f.Position = pos or UDim2.new(0,0,0,0)
    f.Parent = parent
    return f
end

local function padding(top, bottom, left, right, parent)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft = UDim.new(0, left or 10)
    p.PaddingRight = UDim.new(0, right or 10)
    p.Parent = parent
    return p
end

local function listLayout(spacing, dir, parent)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, spacing or 6)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.HorizontalAlignment = Enum.HorizontalAlignment.Left
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

-- Build ScreenGui
local screen = Instance.new("ScreenGui")
screen.Name = "EXE5_Hub"
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.IgnoreGuiInset = true
screen.ResetOnSpawn = false

-- Main container
local main = newFrame(C.bg, screen, UDim2.new(0,860,0,520))
main.Position = UDim2.new(0.5,-430,0.5,-260)
main.ClipDescendants = true
corner(10, main)
stroke(C.border, 1, main)

-- Shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1,30,1,30)
shadow.Position = UDim2.new(0,-15,0,-15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0,0,0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49,49,450,450)
shadow.ZIndex = 0
shadow.Parent = main

-- Sidebar
local sidebar = newFrame(C.sidebar, main, UDim2.new(0,180,1,0))
stroke(C.border, 1, sidebar)

-- Logo area
local logoArea = newFrame(C.sidebar, sidebar, UDim2.new(1,0,0,60))
local logoText = Instance.new("TextLabel")
logoText.Text = "🍌 Banana Hub"
logoText.TextSize = 15
logoText.Font = Enum.Font.GothamBold
logoText.TextColor3 = C.accent
logoText.BackgroundTransparency = 1
logoText.Size = UDim2.new(1,-20,1,0)
logoText.Position = UDim2.new(0,15,0,0)
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.Parent = logoArea

local logoSub = Instance.new("TextLabel")
logoSub.Text = "Blox Fruit"
logoSub.TextSize = 11
logoSub.Font = Enum.Font.Gotham
logoSub.TextColor3 = C.textMuted
logoSub.BackgroundTransparency = 1
logoSub.Size = UDim2.new(1,-20,0,14)
logoSub.Position = UDim2.new(0,15,0,36)
logoSub.TextXAlignment = Enum.TextXAlignment.Left
logoSub.Parent = logoArea

local divider = newFrame(C.border, sidebar, UDim2.new(1,-20,0,1), UDim2.new(0,10,0,60))

-- Nav buttons list
local navList = newFrame(C.sidebar, sidebar, UDim2.new(1,0,1,-70), UDim2.new(0,0,0,68))
navList.ClipDescendants = true
local navScroll = Instance.new("ScrollingFrame")
navScroll.Size = UDim2.new(1,0,1,0)
navScroll.BackgroundTransparency = 1
navScroll.BorderSizePixel = 0
navScroll.ScrollBarThickness = 2
navScroll.ScrollBarImageColor3 = C.accent
navScroll.CanvasSize = UDim2.new(0,0,0,0)
navScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
navScroll.Parent = navList
local navLayout = listLayout(2, nil, navScroll)
padding(8,8,8,8, navScroll)

-- Content area
local content = newFrame(C.panel, main, UDim2.new(1,-180,1,0), UDim2.new(0,180,0,0))

-- Content header
local contentHeader = newFrame(C.sidebar, content, UDim2.new(1,0,0,50))
stroke(C.border, 1, contentHeader)
local headerTitle = Instance.new("TextLabel")
headerTitle.Text = "Banana Cat Hub"
headerTitle.TextSize = 16
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextColor3 = C.text
headerTitle.BackgroundTransparency = 1
headerTitle.Size = UDim2.new(1,-20,1,0)
headerTitle.Position = UDim2.new(0,16,0,0)
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = contentHeader

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-40,0.5,-14)
closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
closeBtn.Text = "✕"
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = C.textDim
closeBtn.BorderSizePixel = 0
closeBtn.Parent = contentHeader
corner(6, closeBtn)

closeBtn.MouseButton1Click:Connect(function()
    screen.Enabled = false
end)

-- Tab scroll area
local tabContainer = newFrame(C.panel, content, UDim2.new(1,0,1,-50), UDim2.new(0,0,0,50))
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Size = UDim2.new(1,0,1,0)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel = 0
tabScroll.ScrollBarThickness = 3
tabScroll.ScrollBarImageColor3 = C.accent
tabScroll.CanvasSize = UDim2.new(0,0,0,0)
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabScroll.Parent = tabContainer
padding(12,12,12,12, tabScroll)

-- Column layout for groupboxes
local colLayout = Instance.new("UIGridLayout")
colLayout.CellSize = UDim2.new(0.5,-8,0,0)
colLayout.CellPadding = UDim2.new(0,8,0,8)
colLayout.FillDirection = Enum.FillDirection.Horizontal
colLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
colLayout.SortOrder = Enum.SortOrder.LayoutOrder
colLayout.Parent = tabScroll

-- Toggle button to show GUI
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,34,0,34)
toggleBtn.Position = UDim2.new(0,10,1,-44)
toggleBtn.BackgroundColor3 = C.accent
toggleBtn.Text = "🍌"
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 10
toggleBtn.Parent = playerGui:WaitForChild("PlayerGui") or screen
corner(8, toggleBtn)

-- Actually put toggle in a separate ScreenGui layer
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "EXE5_Toggle"
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.IgnoreGuiInset = true
toggleGui.ResetOnSpawn = false
toggleGui.Parent = playerGui
toggleBtn.Parent = toggleGui

toggleBtn.MouseButton1Click:Connect(function()
    screen.Enabled = not screen.Enabled
end)

-- Dragging
local dragging, dragStart, startPos = false, nil, nil
contentHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Notification system
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "EXE5_Notif"
notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
notifGui.IgnoreGuiInset = true
notifGui.ResetOnSpawn = false
notifGui.Parent = playerGui
local notifList = newFrame(Color3.fromRGB(0,0,0), notifGui, UDim2.new(0,280,1,0), UDim2.new(1,-290,0,0))
notifList.BackgroundTransparency = 1
listLayout(6, nil, notifList)
padding(10,10,0,0, notifList)

-- Library object
local Library = {}
Library._tabs = {}
Library._activeTab = nil

function Library:Notify(opts)
    local title = opts.Title or "Notice"
    local desc = opts.Description or ""
    local dur = opts.Duration or 3

    local card = newFrame(C.card, notifList, UDim2.new(1,0,0,0))
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundTransparency = 1
    corner(8, card)
    stroke(C.border, 1, card)
    padding(10,10,12,12, card)

    local innerList = listLayout(4, nil, card)

    local t = label(title, 13, C.accent, card, Enum.Font.GothamBold)
    t.Size = UDim2.new(1,0,0,16)
    if desc ~= "" then
        local d = label(desc, 11, C.textDim, card)
        d.TextWrapped = true
        d.Size = UDim2.new(1,0,0,0)
        d.AutomaticSize = Enum.AutomaticSize.Y
    end

    tween(card, {BackgroundTransparency = 0}, 0.2)

    task.delay(dur, function()
        tween(card, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        card:Destroy()
    end)
end

-- Tab system
local tabPages = {}
local navBtns = {}

function Library:_switchTab(name)
    for n, page in pairs(tabPages) do
        page.Visible = (n == name)
    end
    for n, btn in pairs(navBtns) do
        if n == name then
            tween(btn, {BackgroundColor3 = Color3.fromRGB(35,35,35)}, 0.1)
            btn.indicator.Visible = true
            btn.lbl.TextColor3 = C.accent
        else
            tween(btn, {BackgroundColor3 = Color3.fromRGB(0,0,0)}, 0.1)
            btn.indicator.Visible = false
            btn.lbl.TextColor3 = C.textDim
        end
    end
    headerTitle.Text = name
    Library._activeTab = name
end

function Library:CreateWindow(opts)
    -- already built, just update title
    if opts.Title then
        logoText.Text = "🍌 " .. opts.Title
    end
    screen.Parent = playerGui
    return self
end

function Library:AddTab(name)
    -- Nav button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,34)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = navScroll
    corner(6, btn)

    local indicator = newFrame(C.accent, btn, UDim2.new(0,3,0.6,0), UDim2.new(0,0,0.2,0))
    indicator.Visible = false
    corner(2, indicator)
    btn.indicator = indicator

    local lbl = Instance.new("TextLabel")
    lbl.Text = name
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextColor3 = C.textDim
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,-16,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = btn
    btn.lbl = lbl

    btn.MouseEnter:Connect(function()
        if Library._activeTab ~= name then
            tween(btn, {BackgroundTransparency = 0.8}, 0.1)
            tween(btn, {BackgroundColor3 = Color3.fromRGB(40,40,40)}, 0.1)
        end
    end)
    btn.MouseLeave:Connect(function()
        if Library._activeTab ~= name then
            tween(btn, {BackgroundTransparency = 1}, 0.1)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        Library:_switchTab(name)
    end)

    navBtns[name] = btn

    -- Page (invisible frame in tabScroll)
    local page = newFrame(C.panel, tabScroll, UDim2.new(1,0,1,0))
    page.Visible = false
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    tabPages[name] = page

    -- Activate first tab
    if Library._activeTab == nil then
        Library:_switchTab(name)
    end

    -- Tab object
    local Tab = {}
    Tab._page = page
    Tab._name = name

    function Tab:AddLeftGroupbox(gbname)
        return Library:_makeGroupbox(gbname, page)
    end
    Tab.AddRightGroupbox = Tab.AddLeftGroupbox

    return Tab
end

function Library:_makeGroupbox(name, parent)
    local box = newFrame(C.card, parent, UDim2.new(1,0,0,0))
    box.AutomaticSize = Enum.AutomaticSize.Y
    corner(8, box)
    stroke(C.border, 1, box)

    local header = newFrame(Color3.fromRGB(22,22,22), box, UDim2.new(1,0,0,32))
    corner(8, header)

    -- Fix bottom corners of header
    local headerFix = newFrame(Color3.fromRGB(22,22,22), box, UDim2.new(1,0,0,6), UDim2.new(0,0,0,26))

    local hLabel = label(name, 12, C.textDim, header, Enum.Font.GothamBold)
    hLabel.Size = UDim2.new(1,-20,1,0)
    hLabel.Position = UDim2.new(0,12,0,0)
    hLabel.TextColor3 = C.textMuted

    -- Accent dot
    local dot = newFrame(C.accent, header, UDim2.new(0,4,0,4), UDim2.new(0,5,0.5,-2))
    corner(2, dot)

    local body = newFrame(C.card, box, UDim2.new(1,0,0,0), UDim2.new(0,0,0,32))
    body.AutomaticSize = Enum.AutomaticSize.Y
    local bodyList = listLayout(4, nil, body)
    padding(6,8,10,10, body)

    local Groupbox = {}

    function Groupbox:AddToggle(id, opts)
        opts = opts or {}
        local state = opts.Default or false
        local cb = opts.Callback or function() end

        local row = newFrame(Color3.fromRGB(0,0,0), body, UDim2.new(1,0,0,30))
        row.BackgroundTransparency = 1

        local rowLabel = label(opts.Title or id, 12, C.text, row)
        rowLabel.Size = UDim2.new(1,-46,1,0)
        rowLabel.Position = UDim2.new(0,0,0,0)
        rowLabel.TextYAlignment = Enum.TextYAlignment.Center

        local track = Instance.new("TextButton")
        track.Size = UDim2.new(0,36,0,18)
        track.Position = UDim2.new(1,-36,0.5,-9)
        track.BackgroundColor3 = state and C.toggleOn or C.toggleOff
        track.Text = ""
        track.BorderSizePixel = 0
        track.AutoButtonColor = false
        track.Parent = row
        corner(9, track)

        local knob = newFrame(Color3.fromRGB(255,255,255), track, UDim2.new(0,14,0,14), UDim2.new(0, state and 18 or 2, 0.5,-7))
        corner(7, knob)

        track.MouseButton1Click:Connect(function()
            state = not state
            tween(track, {BackgroundColor3 = state and C.toggleOn or C.toggleOff}, 0.15)
            tween(knob, {Position = UDim2.new(0, state and 18 or 2, 0.5,-7)}, 0.15)
            pcall(cb, state)
        end)

        if state then pcall(cb, true) end
        return track
    end

    function Groupbox:AddButton(opts)
        opts = opts or {}
        local cb = opts.Callback or function() end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,28)
        btn.BackgroundColor3 = Color3.fromRGB(38,38,38)
        btn.Text = opts.Title or "Button"
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamMedium
        btn.TextColor3 = C.text
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = body
        corner(6, btn)
        stroke(C.border, 1, btn)

        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(50,50,50)}, 0.1) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(38,38,38)}, 0.1) end)
        btn.MouseButton1Click:Connect(function()
            tween(btn, {BackgroundColor3 = C.accent}, 0.05)
            task.wait(0.1)
            tween(btn, {BackgroundColor3 = Color3.fromRGB(38,38,38)}, 0.15)
            pcall(cb)
        end)
        return btn
    end

    function Groupbox:AddSlider(opts)
        opts = opts or {}
        local min = opts.Min or 0
        local max = opts.Max or 100
        local val = opts.Default or min
        local round = opts.Rounding or 0
        local cb = opts.Callback or function() end

        local container = newFrame(Color3.fromRGB(0,0,0), body, UDim2.new(1,0,0,42))
        container.BackgroundTransparency = 1

        local titleLbl = label((opts.Title or "Slider") .. ": " .. tostring(val), 12, C.text, container)
        titleLbl.Size = UDim2.new(1,0,0,16)

        local track = newFrame(Color3.fromRGB(45,45,45), container, UDim2.new(1,0,0,6), UDim2.new(0,0,0,22))
        corner(3, track)

        local fill = newFrame(C.accent, track, UDim2.new((val-min)/(max-min),0,1,0))
        corner(3, fill)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,6)
        btn.Position = UDim2.new(0,0,0,0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = track

        local dragging = false
        btn.MouseButton1Down:Connect(function() dragging = true end)
        game:GetService("UserInputService").InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local abs = track.AbsolutePosition.X
                local width = track.AbsoluteSize.X
                local rel = math.clamp((i.Position.X - abs) / width, 0, 1)
                local newVal = min + (max-min)*rel
                if round > 0 then
                    newVal = math.floor(newVal * (10^round) + 0.5) / (10^round)
                else
                    newVal = math.floor(newVal + 0.5)
                end
                val = newVal
                fill.Size = UDim2.new(rel, 0, 1, 0)
                titleLbl.Text = (opts.Title or "Slider") .. ": " .. tostring(val)
                pcall(cb, val)
            end
        end)
        return container
    end

    function Groupbox:AddDropdown(id, opts)
        opts = opts or {}
        local values = opts.Values or {}
        local cb = opts.Callback or function() end
        local selected = opts.Default
        local open = false

        local container = newFrame(Color3.fromRGB(0,0,0), body, UDim2.new(1,0,0,28))
        container.BackgroundTransparency = 1
        container.ClipDescendants = false

        local titleLbl = label(opts.Title or "Select", 11, C.textDim, container)
        titleLbl.Size = UDim2.new(1,0,0,14)

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(1,0,0,26)
        dropBtn.Position = UDim2.new(0,0,0,14)
        dropBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        dropBtn.Text = selected or "Select..."
        dropBtn.TextSize = 12
        dropBtn.Font = Enum.Font.Gotham
        dropBtn.TextColor3 = selected and C.text or C.textDim
        dropBtn.BorderSizePixel = 0
        dropBtn.AutoButtonColor = false
        dropBtn.TextXAlignment = Enum.TextXAlignment.Left
        dropBtn.Parent = container
        corner(6, dropBtn)
        stroke(C.border, 1, dropBtn)
        padding(0,0,10,30, dropBtn)

        local arrow = label("▾", 14, C.textDim, dropBtn)
        arrow.Size = UDim2.new(0,20,1,0)
        arrow.Position = UDim2.new(1,-24,0,0)
        arrow.TextXAlignment = Enum.TextXAlignment.Center

        -- Dropdown list
        local listFrame = newFrame(Color3.fromRGB(28,28,28), container, UDim2.new(1,0,0,0))
        listFrame.Position = UDim2.new(0,0,0,42)
        listFrame.Visible = false
        listFrame.AutomaticSize = Enum.AutomaticSize.Y
        listFrame.ZIndex = 10
        corner(6, listFrame)
        stroke(C.border, 1, listFrame)

        local itemList = listLayout(0, nil, listFrame)
        for _, v in ipairs(values) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1,0,0,26)
            item.BackgroundTransparency = 1
            item.Text = v
            item.TextSize = 12
            item.Font = Enum.Font.Gotham
            item.TextColor3 = C.textDim
            item.BorderSizePixel = 0
            item.AutoButtonColor = false
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.ZIndex = 10
            item.Parent = listFrame
            padding(0,0,10,10, item)

            item.MouseEnter:Connect(function() item.TextColor3 = C.text end)
            item.MouseLeave:Connect(function() item.TextColor3 = item.TextColor3 == C.text and C.textDim or item.TextColor3 end)
            item.MouseButton1Click:Connect(function()
                selected = v
                dropBtn.Text = v
                dropBtn.TextColor3 = C.text
                listFrame.Visible = false
                open = false
                arrow.Text = "▾"
                pcall(cb, v)
            end)
        end

        dropBtn.MouseButton1Click:Connect(function()
            open = not open
            listFrame.Visible = open
            arrow.Text = open and "▴" or "▾"
            if open then container.Size = UDim2.new(1,0,0,42 + #values*26 + 4) end
        end)

        return container
    end

    function Groupbox:AddLabel(text)
        local l = label(text, 11, C.textDim, body)
        l.TextWrapped = true
        l.Size = UDim2.new(1,0,0,0)
        l.AutomaticSize = Enum.AutomaticSize.Y
        return l
    end

    function Groupbox:AddInput(id, opts)
        opts = opts or {}
        local cb = opts.Callback or function() end

        local container = newFrame(Color3.fromRGB(0,0,0), body, UDim2.new(1,0,0,42))
        container.BackgroundTransparency = 1

        local titleLbl = label(opts.Title or "Input", 11, C.textDim, container)
        titleLbl.Size = UDim2.new(1,0,0,14)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1,0,0,26)
        box.Position = UDim2.new(0,0,0,14)
        box.BackgroundColor3 = Color3.fromRGB(35,35,35)
        box.TextSize = 12
        box.Font = Enum.Font.Gotham
        box.TextColor3 = C.text
        box.PlaceholderText = opts.Placeholder or "Type here..."
        box.PlaceholderColor3 = C.textMuted
        box.Text = ""
        box.BorderSizePixel = 0
        box.ClearTextOnFocus = false
        box.Parent = container
        corner(6, box)
        stroke(C.border, 1, box)
        padding(0,0,10,10, box)

        box.FocusLost:Connect(function()
            pcall(cb, box.Text)
        end)
        return box
    end

    return Groupbox
end

-- Disable grid layout after initial setup (tabs handle their own layout)
colLayout:Destroy()
listLayout(8, nil, tabScroll)
padding(12,12,12,12, tabScroll)

return Library
