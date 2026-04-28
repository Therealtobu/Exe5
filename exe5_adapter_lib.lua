-- EXE5 Adapter Library
-- Chạy SAU khi exe5_loader.lua đã build UI xong
-- Inject BananaHub tabs vào đúng scroll frame của EXE5

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tìm EXE5 UI (đã được build bởi exe5_loader.lua)
local exe5 = playerGui:WaitForChild("EXE5", 10)
if not exe5 then warn("[Adapter] EXE5 UI not found!") return end

local dashFrame = exe5:WaitForChild("frame"):WaitForChild("dashboard_frame")
local scroll = dashFrame:WaitForChild("scroll")

-- Xóa 3 section gốc, giữ lại padding + list layout
for _, child in pairs(scroll:GetChildren()) do
    if child:IsA("Frame") then child:Destroy() end
end

-- Helpers (clone y đúc EXE5 style)
local function tw(obj, p, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), p):Play()
end

local function makeSection(title, description)
    -- Clone y đúc moderator_tools structure
    local sec = Instance.new("Frame")
    sec.Name = title
    sec.BackgroundColor3 = Color3.new(0,0,0)
    sec.BackgroundTransparency = 1
    sec.Size = UDim2.new(1,0,0,130)
    sec.BorderSizePixel = 0
    sec.Parent = scroll

    -- Title label (y đúc inst[68])
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "title"
    titleLbl.Text = title
    titleLbl.TextSize = 22
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextColor3 = Color3.new(1,1,1)
    titleLbl.TextTransparency = 0.2
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size = UDim2.new(0,160,0,40)
    titleLbl.Position = UDim2.new(0,20,0,20)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextWrapped = true
    titleLbl.BorderSizePixel = 0
    titleLbl.Parent = sec

    -- Description label (y đúc inst[69])
    local descLbl = Instance.new("TextLabel")
    descLbl.Name = "description"
    descLbl.Text = description or ""
    descLbl.TextSize = 13
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextColor3 = Color3.new(1,1,1)
    descLbl.TextTransparency = 0.75
    descLbl.BackgroundTransparency = 1
    descLbl.Size = UDim2.new(0,150,0,30)
    descLbl.Position = UDim2.new(0,0,0,22)
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.BorderSizePixel = 0
    descLbl.Parent = titleLbl

    -- Separator line
    local sep = Instance.new("Frame")
    sep.Name = "separator"
    sep.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sep.BackgroundTransparency = 0
    sep.Size = UDim2.new(1,-40,0,1)
    sep.Position = UDim2.new(0,20,1,-1)
    sep.BorderSizePixel = 0
    sep.Parent = sec

    -- Features container (y đúc inst[71])
    local features = Instance.new("Frame")
    features.Name = "features"
    features.BackgroundTransparency = 1
    features.Size = UDim2.new(1,-195,1,0)
    features.Position = UDim2.new(1,0,0.5,0)
    features.AnchorPoint = Vector2.new(1,0.5)
    features.BorderSizePixel = 0
    features.Parent = sec

    -- Horizontal list for feature buttons
    local btnList = Instance.new("UIListLayout")
    btnList.FillDirection = Enum.FillDirection.Horizontal
    btnList.Padding = UDim.new(0,10)
    btnList.SortOrder = Enum.SortOrder.LayoutOrder
    btnList.Parent = features

    return sec, features
end

-- Feature button (y đúc inst[72] manage_bans style)
local function makeFeatureBtn(name, icon, features, onClick)
    local btn = Instance.new("ImageButton")
    btn.Name = name
    btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.BackgroundTransparency = 0.7
    btn.Size = UDim2.new(0,100,1,0)
    btn.Image = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = features

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0,10)
    uicorner.Parent = btn

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Vertical
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0,8)
    btnLayout.Parent = btn

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0,10)
    pad.PaddingBottom = UDim.new(0,10)
    pad.PaddingLeft = UDim.new(0,10)
    pad.PaddingRight = UDim.new(0,10)
    pad.Parent = btn

    -- Icon (y đúc inst[76])
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Name = "icon"
    iconLbl.Text = icon or "⚙"
    iconLbl.TextSize = 26
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextColor3 = Color3.new(1,1,1)
    iconLbl.TextTransparency = 0.15
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size = UDim2.new(0,30,0,30)
    iconLbl.BorderSizePixel = 0
    iconLbl.Parent = btn

    -- Label (y đúc inst[77])
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "label"
    nameLbl.Text = name
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextColor3 = Color3.new(1,1,1)
    nameLbl.TextTransparency = 0.2
    nameLbl.BackgroundTransparency = 1
    nameLbl.Size = UDim2.new(1,0,0,12)
    nameLbl.TextWrapped = true
    nameLbl.BorderSizePixel = 0
    nameLbl.Parent = btn

    btn.MouseEnter:Connect(function()
        tw(btn, {BackgroundTransparency=0.5})
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, {BackgroundTransparency=0.7})
    end)
    btn.MouseButton1Click:Connect(function()
        tw(btn, {BackgroundColor3=Color3.fromRGB(73,244,193)}, 0.07)
        task.wait(0.12)
        tw(btn, {BackgroundColor3=Color3.new(0,0,0)}, 0.2)
        if onClick then onClick() end
    end)
    return btn
end

-- Panel (slide in từ phải, y đúc EXE5 ban panel style)
local panelHolder = Instance.new("Frame")
panelHolder.Name = "panel_holder"
panelHolder.Size = UDim2.new(1,-260,1,0)
panelHolder.Position = UDim2.new(0,260,0,0)
panelHolder.BackgroundColor3 = Color3.fromRGB(15,15,15)
panelHolder.BackgroundTransparency = 1
panelHolder.BorderSizePixel = 0
panelHolder.ZIndex = 5
panelHolder.ClipDescendants = true
panelHolder.Parent = dashFrame

local activePanel = nil

local function makePanel(panelName)
    local panel = Instance.new("Frame")
    panel.Name = panelName
    panel.Size = UDim2.new(1,0,1,0)
    panel.Position = UDim2.new(1,0,0,0) -- start offscreen right
    panel.BackgroundColor3 = Color3.fromRGB(15,15,15)
    panel.BackgroundTransparency = 0
    panel.BorderSizePixel = 0
    panel.ZIndex = 5
    panel.Parent = panelHolder

    -- Panel header (y đúc EXE5 panel header)
    local header = Instance.new("Frame")
    header.Name = "header"
    header.Size = UDim2.new(1,0,0,50)
    header.BackgroundColor3 = Color3.fromRGB(10,10,10)
    header.BackgroundTransparency = 0
    header.BorderSizePixel = 0
    header.ZIndex = 5
    header.Parent = panel

    -- Back button (y đúc EXE5 close button style)
    local backBtn = Instance.new("ImageButton")
    backBtn.Size = UDim2.new(0,32,0,32)
    backBtn.Position = UDim2.new(0,12,0.5,-16)
    backBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    backBtn.Image = ""
    backBtn.BorderSizePixel = 0
    backBtn.AutoButtonColor = false
    backBtn.ZIndex = 6
    backBtn.Parent = header
    local bCorner = Instance.new("UICorner"); bCorner.CornerRadius=UDim.new(1,0); bCorner.Parent=backBtn
    local backIcon = Instance.new("TextLabel")
    backIcon.Text="‹"; backIcon.TextSize=22; backIcon.Font=Enum.Font.GothamBold
    backIcon.TextColor3=Color3.new(1,1,1); backIcon.BackgroundTransparency=1
    backIcon.Size=UDim2.new(1,0,1,0); backIcon.ZIndex=6; backIcon.Parent=backBtn

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Name = "title"
    headerTitle.Text = panelName
    headerTitle.TextSize = 16
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.TextColor3 = Color3.new(1,1,1)
    headerTitle.TextTransparency = 0.1
    headerTitle.BackgroundTransparency = 1
    headerTitle.Size = UDim2.new(1,-56,1,0)
    headerTitle.Position = UDim2.new(0,52,0,0)
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.ZIndex = 6
    headerTitle.Parent = header

    -- Separator
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1,0,0,1); sep.Position = UDim2.new(0,0,1,0)
    sep.BackgroundColor3 = Color3.fromRGB(40,40,40); sep.BorderSizePixel=0
    sep.ZIndex=5; sep.Parent=header

    -- Scroll content
    local scroll2 = Instance.new("ScrollingFrame")
    scroll2.Name = "content"
    scroll2.Size = UDim2.new(1,0,1,-50)
    scroll2.Position = UDim2.new(0,0,0,50)
    scroll2.BackgroundTransparency = 1
    scroll2.BorderSizePixel = 0
    scroll2.ScrollBarThickness = 3
    scroll2.ScrollBarImageColor3 = Color3.fromRGB(73,244,193)
    scroll2.CanvasSize = UDim2.new(0,0,0,0)
    scroll2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll2.ZIndex = 5
    scroll2.Parent = panel

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0,6)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = scroll2
    local contentPad = Instance.new("UIPadding")
    contentPad.PaddingTop=UDim.new(0,12); contentPad.PaddingBottom=UDim.new(0,12)
    contentPad.PaddingLeft=UDim.new(0,16); contentPad.PaddingRight=UDim.new(0,16)
    contentPad.Parent = scroll2

    -- Show/hide animation
    local function openPanel()
        if activePanel and activePanel ~= panel then
            tw(activePanel, {Position=UDim2.new(1,0,0,0)}, 0.2)
        end
        activePanel = panel
        panelHolder.BackgroundTransparency = 0
        tw(panel, {Position=UDim2.new(0,0,0,0)}, 0.22)
    end
    local function closePanel()
        tw(panel, {Position=UDim2.new(1,0,0,0)}, 0.2)
        task.delay(0.22, function() panelHolder.BackgroundTransparency=1 end)
        activePanel = nil
    end

    backBtn.MouseButton1Click:Connect(closePanel)
    backBtn.MouseEnter:Connect(function() tw(backBtn,{BackgroundColor3=Color3.fromRGB(50,50,50)}) end)
    backBtn.MouseLeave:Connect(function() tw(backBtn,{BackgroundColor3=Color3.fromRGB(30,30,30)}) end)

    return scroll2, openPanel
end

-- Controls builders (y đúc EXE5 toggle/button style)
local function addToggle(parent, labelText, default, callback)
    local state = default or false
    local row = Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,32); row.BackgroundTransparency=1; row.BorderSizePixel=0
    row.ZIndex=5; row.Parent=parent

    local lbl = Instance.new("TextLabel")
    lbl.Text=labelText; lbl.TextSize=13; lbl.Font=Enum.Font.GothamMedium
    lbl.TextColor3=Color3.new(1,1,1); lbl.TextTransparency=0.15
    lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,-52,1,0)
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextWrapped=false
    lbl.TextTruncate=Enum.TextTruncate.AtEnd; lbl.BorderSizePixel=0; lbl.ZIndex=5; lbl.Parent=row

    local track = Instance.new("TextButton")
    track.Size=UDim2.new(0,40,0,22); track.Position=UDim2.new(1,-40,0.5,-11)
    track.BackgroundColor3=state and Color3.fromRGB(73,244,193) or Color3.fromRGB(45,45,45)
    track.Text=""; track.BorderSizePixel=0; track.AutoButtonColor=false; track.ZIndex=5; track.Parent=row
    local tc=Instance.new("UICorner"); tc.CornerRadius=UDim.new(1,0); tc.Parent=track
    local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,16,0,16)
    knob.Position=UDim2.new(0,state and 20 or 3,0.5,-8); knob.BackgroundColor3=Color3.new(1,1,1)
    knob.BorderSizePixel=0; knob.ZIndex=6; knob.Parent=track
    local kc=Instance.new("UICorner"); kc.CornerRadius=UDim.new(1,0); kc.Parent=knob

    track.MouseButton1Click:Connect(function()
        state=not state
        tw(track,{BackgroundColor3=state and Color3.fromRGB(73,244,193) or Color3.fromRGB(45,45,45)})
        tw(knob,{Position=UDim2.new(0,state and 20 or 3,0.5,-8)})
        pcall(callback,state)
    end)
    if state then task.defer(callback,true) end
end

local function addButton(parent, labelText, callback)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(1,0,0,32); btn.BackgroundColor3=Color3.fromRGB(25,25,25)
    btn.Text=labelText; btn.TextSize=13; btn.Font=Enum.Font.GothamMedium
    btn.TextColor3=Color3.new(1,1,1); btn.TextTransparency=0.1
    btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.ZIndex=5; btn.Parent=parent
    local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,8); bc.Parent=btn
    local bs=Instance.new("UIStroke"); bs.Color=Color3.fromRGB(45,45,45); bs.Thickness=1; bs.Parent=btn

    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(35,35,35)}) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(25,25,25)}) end)
    btn.MouseButton1Click:Connect(function()
        tw(btn,{BackgroundColor3=Color3.fromRGB(73,244,193)},.06)
        task.wait(0.12); tw(btn,{BackgroundColor3=Color3.fromRGB(25,25,25)},.15)
        pcall(callback)
    end)
end

local function addSlider(parent, opts)
    local min=opts.Min or 0; local max=opts.Max or 100
    local val=opts.Default or min; local rnd=opts.Rounding or 0
    local cb=opts.Callback or function()end

    local box=Instance.new("Frame")
    box.Size=UDim2.new(1,0,0,46); box.BackgroundTransparency=1; box.BorderSizePixel=0
    box.ZIndex=5; box.Parent=parent

    local top=Instance.new("TextLabel")
    top.Text=(opts.Title or "Slider")..":  "..tostring(val); top.TextSize=12
    top.Font=Enum.Font.GothamMedium; top.TextColor3=Color3.new(1,1,1); top.TextTransparency=0.2
    top.BackgroundTransparency=1; top.Size=UDim2.new(1,0,0,16)
    top.TextXAlignment=Enum.TextXAlignment.Left; top.BorderSizePixel=0; top.ZIndex=5; top.Parent=box

    local track=Instance.new("Frame")
    track.Size=UDim2.new(1,0,0,6); track.Position=UDim2.new(0,0,0,24)
    track.BackgroundColor3=Color3.fromRGB(40,40,40); track.BorderSizePixel=0; track.ZIndex=5; track.Parent=box
    local trc=Instance.new("UICorner"); trc.CornerRadius=UDim.new(0,3); trc.Parent=track

    local fill=Instance.new("Frame")
    fill.Size=UDim2.new((val-min)/(max-min),0,1,0); fill.BackgroundColor3=Color3.fromRGB(73,244,193)
    fill.BorderSizePixel=0; fill.ZIndex=6; fill.Parent=track
    local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,3); fc.Parent=fill

    local hit=Instance.new("TextButton"); hit.Size=UDim2.new(1,0,0,22); hit.Position=UDim2.new(0,0,0,-8)
    hit.BackgroundTransparency=1; hit.Text=""; hit.BorderSizePixel=0; hit.ZIndex=7; hit.Parent=track

    local sliding=false
    hit.MouseButton1Down:Connect(function() sliding=true end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end end)
    UIS.InputChanged:Connect(function(i)
        if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rel=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            val=min+(max-min)*rel
            if rnd>0 then val=math.floor(val*(10^rnd)+.5)/(10^rnd) else val=math.floor(val+.5) end
            fill.Size=UDim2.new(rel,0,1,0)
            top.Text=(opts.Title or "Slider")..":  "..tostring(val)
            pcall(cb,val)
        end
    end)
end

local function addDropdown(parent, id, opts)
    local values=opts.Values or {}; local cb=opts.Callback or function()end
    local selected=opts.Default; local open=false

    local box=Instance.new("Frame")
    box.Size=UDim2.new(1,0,0,44); box.BackgroundTransparency=1; box.BorderSizePixel=0
    box.ClipDescendants=false; box.ZIndex=5; box.Parent=parent

    local topL=Instance.new("TextLabel"); topL.Text=opts.Title or "Select"; topL.TextSize=11
    topL.Font=Enum.Font.Gotham; topL.TextColor3=Color3.new(1,1,1); topL.TextTransparency=0.5
    topL.BackgroundTransparency=1; topL.Size=UDim2.new(1,0,0,14); topL.TextXAlignment=Enum.TextXAlignment.Left
    topL.BorderSizePixel=0; topL.ZIndex=5; topL.Parent=box

    local drop=Instance.new("TextButton"); drop.Size=UDim2.new(1,0,0,28); drop.Position=UDim2.new(0,0,0,14)
    drop.BackgroundColor3=Color3.fromRGB(25,25,25); drop.Text=selected or "Select..."
    drop.TextSize=12; drop.Font=Enum.Font.Gotham; drop.TextColor3=Color3.new(1,1,1)
    drop.BorderSizePixel=0; drop.AutoButtonColor=false; drop.TextXAlignment=Enum.TextXAlignment.Left
    drop.ZIndex=5; drop.Parent=box
    local dc=Instance.new("UICorner"); dc.CornerRadius=UDim.new(0,6); dc.Parent=drop
    local ds=Instance.new("UIStroke"); ds.Color=Color3.fromRGB(45,45,45); ds.Thickness=1; ds.Parent=drop
    local dp=Instance.new("UIPadding"); dp.PaddingLeft=UDim.new(0,10); dp.PaddingRight=UDim.new(0,28); dp.Parent=drop
    local arr=Instance.new("TextLabel"); arr.Text="▾"; arr.TextSize=13; arr.Font=Enum.Font.GothamBold
    arr.TextColor3=Color3.new(1,1,1); arr.TextTransparency=0.4; arr.BackgroundTransparency=1
    arr.Size=UDim2.new(0,24,1,0); arr.Position=UDim2.new(1,-24,0,0); arr.ZIndex=6; arr.Parent=drop

    local dList=Instance.new("Frame"); dList.Size=UDim2.new(1,0,0,#values*26)
    dList.Position=UDim2.new(0,0,0,44); dList.BackgroundColor3=Color3.fromRGB(20,20,20)
    dList.BorderSizePixel=0; dList.Visible=false; dList.ZIndex=8; dList.Parent=box
    local dlc=Instance.new("UICorner"); dlc.CornerRadius=UDim.new(0,6); dlc.Parent=dList
    local dls=Instance.new("UIStroke"); dls.Color=Color3.fromRGB(45,45,45); dls.Thickness=1; dls.Parent=dList
    local dll=Instance.new("UIListLayout"); dll.SortOrder=Enum.SortOrder.LayoutOrder; dll.Parent=dList

    for _,v in ipairs(values) do
        local it=Instance.new("TextButton"); it.Size=UDim2.new(1,0,0,26)
        it.BackgroundTransparency=1; it.Text=v; it.TextSize=12; it.Font=Enum.Font.Gotham
        it.TextColor3=Color3.new(1,1,1); it.BorderSizePixel=0; it.AutoButtonColor=false
        it.TextXAlignment=Enum.TextXAlignment.Left; it.ZIndex=9; it.Parent=dList
        local ip=Instance.new("UIPadding"); ip.PaddingLeft=UDim.new(0,10); ip.Parent=it
        it.MouseEnter:Connect(function() it.BackgroundColor3=Color3.fromRGB(73,244,193); it.BackgroundTransparency=0.8 end)
        it.MouseLeave:Connect(function() it.BackgroundTransparency=1 end)
        it.MouseButton1Click:Connect(function()
            selected=v; drop.Text=v; dList.Visible=false; open=false; arr.Text="▾"
            box.Size=UDim2.new(1,0,0,44); pcall(cb,v)
        end)
    end
    drop.MouseButton1Click:Connect(function()
        open=not open; dList.Visible=open; arr.Text=open and "▴" or "▾"
        box.Size=UDim2.new(1,0,0, open and 44+#values*26 or 44)
    end)
end

local function addInput(parent, id, opts)
    local cb=opts.Callback or function()end
    local box=Instance.new("Frame"); box.Size=UDim2.new(1,0,0,44); box.BackgroundTransparency=1
    box.BorderSizePixel=0; box.ZIndex=5; box.Parent=parent
    local topL=Instance.new("TextLabel"); topL.Text=opts.Title or "Input"; topL.TextSize=11
    topL.Font=Enum.Font.Gotham; topL.TextColor3=Color3.new(1,1,1); topL.TextTransparency=0.5
    topL.BackgroundTransparency=1; topL.Size=UDim2.new(1,0,0,14); topL.TextXAlignment=Enum.TextXAlignment.Left
    topL.BorderSizePixel=0; topL.ZIndex=5; topL.Parent=box
    local tb=Instance.new("TextBox"); tb.Size=UDim2.new(1,0,0,28); tb.Position=UDim2.new(0,0,0,14)
    tb.BackgroundColor3=Color3.fromRGB(25,25,25); tb.TextSize=12; tb.Font=Enum.Font.Gotham
    tb.TextColor3=Color3.new(1,1,1); tb.PlaceholderText=opts.Placeholder or "..."
    tb.PlaceholderColor3=Color3.fromRGB(70,70,70); tb.Text=""; tb.BorderSizePixel=0
    tb.ClearTextOnFocus=false; tb.ZIndex=5; tb.Parent=box
    local tc=Instance.new("UICorner"); tc.CornerRadius=UDim.new(0,6); tc.Parent=tb
    local ts=Instance.new("UIStroke"); ts.Color=Color3.fromRGB(45,45,45); ts.Thickness=1; ts.Parent=tb
    local tp=Instance.new("UIPadding"); tp.PaddingLeft=UDim.new(0,10); tp.Parent=tb
    tb.FocusLost:Connect(function() pcall(cb,tb.Text) end)
end

local function addLabel(parent, text)
    local l=Instance.new("TextLabel"); l.Text=text; l.TextSize=11; l.Font=Enum.Font.Gotham
    l.TextColor3=Color3.new(1,1,1); l.TextTransparency=0.5; l.BackgroundTransparency=1
    l.Size=UDim2.new(1,0,0,0); l.AutomaticSize=Enum.AutomaticSize.Y
    l.TextXAlignment=Enum.TextXAlignment.Left; l.TextWrapped=true; l.BorderSizePixel=0
    l.ZIndex=5; l.Parent=parent
end

-- Notification (y đúc EXE5 notification style)
local notifGui = playerGui:FindFirstChild("EXE5_Notif")
if not notifGui then
    notifGui = Instance.new("ScreenGui")
    notifGui.Name="EXE5_Notif"; notifGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    notifGui.IgnoreGuiInset=true; notifGui.ResetOnSpawn=false; notifGui.Parent=playerGui
end
local notifHolder = notifGui:FindFirstChild("holder")
if not notifHolder then
    notifHolder=Instance.new("Frame"); notifHolder.Name="holder"
    notifHolder.Size=UDim2.new(0,280,1,-20); notifHolder.Position=UDim2.new(1,-290,0,10)
    notifHolder.BackgroundTransparency=1; notifHolder.BorderSizePixel=0; notifHolder.Parent=notifGui
    local nl=Instance.new("UIListLayout"); nl.Padding=UDim.new(0,8)
    nl.SortOrder=Enum.SortOrder.LayoutOrder; nl.Parent=notifHolder
end

-- Library object
local Library = {}
Library._tabOrder = 0

function Library:Notify(opts)
    local card=Instance.new("Frame"); card.Size=UDim2.new(1,0,0,0); card.AutomaticSize=Enum.AutomaticSize.Y
    card.BackgroundColor3=Color3.fromRGB(18,18,18); card.BackgroundTransparency=1
    card.BorderSizePixel=0; card.Parent=notifHolder
    local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(0,8); cc.Parent=card
    local cs=Instance.new("UIStroke"); cs.Color=Color3.fromRGB(73,244,193); cs.Thickness=1; cs.Parent=card
    local cp=Instance.new("UIPadding"); cp.PaddingTop=UDim.new(0,10); cp.PaddingBottom=UDim.new(0,10)
    cp.PaddingLeft=UDim.new(0,14); cp.PaddingRight=UDim.new(0,14); cp.Parent=card
    local cl=Instance.new("UIListLayout"); cl.Padding=UDim.new(0,4); cl.Parent=card

    local tl=Instance.new("TextLabel"); tl.Text=opts.Title or "Notice"; tl.TextSize=13
    tl.Font=Enum.Font.GothamBold; tl.TextColor3=Color3.fromRGB(73,244,193)
    tl.BackgroundTransparency=1; tl.Size=UDim2.new(1,0,0,16)
    tl.TextXAlignment=Enum.TextXAlignment.Left; tl.BorderSizePixel=0; tl.Parent=card

    if opts.Description and opts.Description~="" then
        local dl=Instance.new("TextLabel"); dl.Text=opts.Description; dl.TextSize=11
        dl.Font=Enum.Font.Gotham; dl.TextColor3=Color3.new(1,1,1); dl.TextTransparency=0.3
        dl.BackgroundTransparency=1; dl.Size=UDim2.new(1,0,0,0); dl.AutomaticSize=Enum.AutomaticSize.Y
        dl.TextXAlignment=Enum.TextXAlignment.Left; dl.TextWrapped=true; dl.BorderSizePixel=0; dl.Parent=card
    end

    tw(card,{BackgroundTransparency=0},.2)
    task.delay(opts.Duration or 3, function()
        tw(card,{BackgroundTransparency=1},.3); task.wait(.35); card:Destroy()
    end)
end

function Library:CreateWindow(opts)
    if opts and opts.Title then
        -- Update EXE5 header title if possible
        local header = dashFrame:FindFirstChild("navigation_buttons")
        if header then
            local lbl = header:FindFirstChildWhichIsA("TextLabel")
            if lbl then lbl.Text = opts.Title end
        end
    end
    return self
end

local TAB_ICONS = {
    ["Report And Ideas"]="📋", ["Shop"]="🛒", ["Status And Server"]="📡",
    ["LocalPlayer"]="👤", ["Setting Farm"]="⚙", ["Hold and Select Skill"]="🎯",
    ["Farming"]="🌾", ["Stack Farming"]="📦", ["Farming Other"]="🔄",
    ["Fruit and Raid, Dungeon"]="🍇", ["Sea Event"]="🌊", ["Upgrade Race"]="🏆",
    ["Get and Upgrade Items"]="⚔", ["Volcano Event"]="🌋", ["ESP"]="👁", ["PVP"]="⚡",
}

function Library:AddTab(name)
    self._tabOrder = self._tabOrder + 1
    local _, features = makeSection(name, name)

    local Tab = {}
    local gbCount = 0

    local function makeGB(gbName)
        gbCount = gbCount + 1
        local panelContent, openFn = makePanel(gbName)

        local icon = TAB_ICONS[name] or "⚙"
        makeFeatureBtn(gbName, icon, features, openFn)

        local GB = {}
        function GB:AddToggle(id, opts) addToggle(panelContent, opts.Title or id, opts.Default, opts.Callback or function()end) end
        function GB:AddButton(opts) addButton(panelContent, opts.Title or "Button", opts.Callback or function()end) end
        function GB:AddSlider(opts) addSlider(panelContent, opts) end
        function GB:AddDropdown(id, opts) addDropdown(panelContent, id, opts) end
        function GB:AddLabel(text) addLabel(panelContent, text) end
        function GB:AddInput(id, opts) addInput(panelContent, id, opts) end
        return GB
    end

    function Tab:AddLeftGroupbox(gbName) return makeGB(gbName) end
    function Tab:AddRightGroupbox(gbName) return makeGB(gbName) end
    return Tab
end

return Library
