-- Flagman Xeno v5.0
-- Полная версия для Xeno
-- Автор: good

local Players, UIS, RS, TS, CG, WS, Cam = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("TweenService"), game:GetService("CoreGui"), game:GetService("Workspace"), workspace.CurrentCamera
local LP, Char, Hum, Root, Mouse = Players.LocalPlayer, (Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()), nil, nil, LP:GetMouse()
Char = LP.Character or LP.CharacterAdded:Wait()
Hum = Char:WaitForChild("Humanoid")
Root = Char:WaitForChild("HumanoidRootPart")

local S = {fly=false,noclip=false,god=false,spider=false,scaffold=false,esp=false,aimbot=false,bang=false,jerk=false,speed=1,jump=1,flySpeed=50,aimbotFOV=200}
local BV, BG, NP, SC, SPConn, ScaConn, ESPObjs, ESPConns = nil, nil, nil, nil, nil, nil, {}, {}
local Binds = {}

local SG = Instance.new("ScreenGui")
SG.Name, SG.ResetOnSpawn, SG.Parent = "FlagmanXenoUI", false, CG

local MF = Instance.new("Frame")
MF.Size, MF.Position, MF.BackgroundColor3, MF.BackgroundTransparency, MF.BorderSizePixel, MF.BorderColor3, MF.ClipsDescendants, MF.Parent, MF.Visible = UDim2.new(0,550,0,650), UDim2.new(0.5,-275,0.5,-325), Color3.fromRGB(12,12,25), 0.08, 2, Color3.fromRGB(255,50,80), true, SG, false

local Blur = Instance.new("BlurEffect")
Blur.Size, Blur.Parent = 0, MF
local function aB(e) TS:Create(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = e and 12 or 0}):Play() end

local TF = Instance.new("Frame")
TF.Size, TF.Position, TF.BackgroundColor3, TF.BackgroundTransparency, TF.Parent = UDim2.new(1,0,0,60), UDim2.new(0,0,0,0), Color3.fromRGB(255,50,80), 0.85, MF
local TG = Instance.new("UIGradient")
TG.Color, TG.Parent = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,50,80)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180,30,150)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50,100,255))}), TF
local T = Instance.new("TextLabel")
T.Size, T.Position, T.BackgroundTransparency, T.Text, T.TextColor3, T.TextScaled, T.Font, T.Parent = UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), 1, "✦ FLAGMAN XENO ✦", Color3.fromRGB(255,255,255), true, Enum.Font.GothamBold, TF
local ST = Instance.new("TextLabel")
ST.Size, ST.Position, ST.BackgroundTransparency, ST.Text, ST.TextColor3, ST.TextScaled, ST.Font, ST.Parent = UDim2.new(1,0,0,20), UDim2.new(0,0,1,-20), 1, "v5.0 | Xeno | good", Color3.fromRGB(200,200,255), true, Enum.Font.GothamMedium, TF

local SB = Instance.new("TextBox")
SB.Size, SB.Position, SB.BackgroundColor3, SB.BackgroundTransparency, SB.TextColor3, SB.PlaceholderText, SB.PlaceholderColor3, SB.Text, SB.ClearTextOnFocus, SB.Font, SB.TextScaled, SB.BorderSizePixel, SB.BorderColor3, SB.Parent = UDim2.new(1,-20,0,35), UDim2.new(0,10,0,65), Color3.fromRGB(30,30,50), 0.5, Color3.fromRGB(255,255,255), "🔍 Поиск...", Color3.fromRGB(150,150,200), "", false, Enum.Font.GothamMedium, true, 1, Color3.fromRGB(255,50,80), MF

local BC = Instance.new("ScrollingFrame")
BC.Size, BC.Position, BC.BackgroundTransparency, BC.CanvasSize, BC.ScrollBarThickness, BC.ScrollBarImageColor3, BC.Parent = UDim2.new(1,-20,1,-120), UDim2.new(0,10,0,105), 1, UDim2.new(0,0,0,0), 8, Color3.fromRGB(255,50,80), MF
local UIL = Instance.new("UIListLayout")
UIL.Padding, UIL.SortOrder, UIL.Parent = UDim.new(0,8), Enum.SortOrder.LayoutOrder, BC

local AllBtns = {}

local function cB(txt, cb, cat)
    local btn = Instance.new("TextButton")
    btn.Size, btn.BackgroundColor3, btn.BackgroundTransparency, btn.Text, btn.TextColor3, btn.TextScaled, btn.Font, btn.BorderSizePixel, btn.BorderColor3, btn.Parent = UDim2.new(1,0,0,45), Color3.fromRGB(25,25,45), 0.3, txt, Color3.fromRGB(220,220,255), true, Enum.Font.GothamMedium, 1, Color3.fromRGB(255,50,80), BC
    local glow = Instance.new("UIGradient")
    glow.Color, glow.Transparency, glow.Parent = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,50,80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50,100,255))}), NumberSequence.new(1), btn
    if cat then local cl = Instance.new("TextLabel")
        cl.Size, cl.Position, cl.BackgroundTransparency, cl.Text, cl.TextColor3, cl.TextScaled, cl.Font, cl.TextXAlignment, cl.Parent = UDim2.new(0,60,1,0), UDim2.new(0,5,0,0), 1, cat, Color3.fromRGB(200,150,255), true, Enum.Font.GothamBold, Enum.TextXAlignment.Left, btn
    end
    btn.MouseEnter:Connect(function() TS:Create(glow, TweenInfo.new(0.3), {Transparency = NumberSequence.new(0.3)}):Play() TS:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play() end)
    btn.MouseLeave:Connect(function() TS:Create(glow, TweenInfo.new(0.3), {Transparency = NumberSequence.new(1)}):Play() TS:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play() end)
    btn.MouseButton1Click:Connect(function() cb() TS:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100,255,100)}):Play() wait(0.1) TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,45)}):Play() end)
    btn.MouseButton2Click:Connect(function()
        local d = Instance.new("TextBox")
        d.Size, d.Position, d.BackgroundColor3, d.TextColor3, d.PlaceholderText, d.ClearTextOnFocus, d.Parent = UDim2.new(0,200,0,30), UDim2.new(0.5,-100,0.5,-15), Color3.fromRGB(30,30,50), Color3.fromRGB(255,255,255), "Нажмите клавишу...", false, MF
        d:CaptureFocus()
        local conn
        conn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                Binds[input.KeyCode] = cb
                print("[Xeno] Бинд на " .. input.KeyCode.Name)
                d:Destroy()
                conn:Disconnect()
            end
        end)
        d.FocusLost:Connect(function() d:Destroy() if conn then conn:Disconnect() end end)
    end)
    table.insert(AllBtns, {button=btn, text=txt:lower(), category=cat or "Основные"})
    return btn
end

local function uS(q)
    q = q:lower()
    local vc = 0
    for _, d in ipairs(AllBtns) do
        if q == "" or d.text:find(q, 1, true) then d.button.Visible = true vc = vc + 1 else d.button.Visible = false end
    end
    BC.CanvasSize = UDim2.new(0,0,0, vc * 53 + 20)
end
SB:GetPropertyChangedSignal("Text"):Connect(function() uS(SB.Text) end)

-- ============================================
-- ФУНКЦИИ
-- ============================================
local function tFly()
    S.fly = not S.fly
    if S.fly then
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
        BV = Instance.new("BodyVelocity")
        BV.MaxForce, BV.Velocity, BV.Parent = Vector3.new(1,1,1) * 100000, Vector3.new(0, S.flySpeed, 0), Root
        BG = Instance.new("BodyGyro")
        BG.MaxTorque, BG.CFrame, BG.Parent = Vector3.new(1,1,1) * 100000, Root.CFrame, Root
    else
        if BV then BV:Destroy() BV = nil end
        if BG then BG:Destroy() BG = nil end
    end
end

local function tNoclip()
    S.noclip = not S.noclip
    if S.noclip then
        if not NP then NP = Instance.new("Part") NP.CanCollide, NP.Transparency, NP.Size, NP.Anchored, NP.Parent = false, 1, Vector3.new(5,5,5), true, WS end
        RS.Heartbeat:Connect(function() if S.noclip and Root and Root.Parent then NP.Position = Root.Position for _, p in ipairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
    else if NP then NP:Destroy() NP = nil end for _, p in ipairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end

local function tGod()
    S.god = not S.god
    if S.god then Hum.MaxHealth, Hum.Health, Hum.BreakJointsOnDeath = math.huge, math.huge, false
        Hum:GetPropertyChangedSignal("Health"):Connect(function() if S.god and Hum.Health <= 0 then Hum.Health = Hum.MaxHealth end end)
    else Hum.MaxHealth, Hum.Health, Hum.BreakJointsOnDeath = 100, 100, true end
end

local function tSpider()
    S.spider = not S.spider
    if S.spider then if SPConn then SPConn:Disconnect() end
        SPConn = RS.Heartbeat:Connect(function() if S.spider and Root and Root.Parent and Hum then local r = Ray.new(Root.Position, Root.CFrame.LookVector * 3) local h = WS:FindPartOnRay(r, Char) if h then Hum.WalkSpeed = 20 Root.Velocity = Root.Velocity + Vector3.new(0, -2, 0) Root.CFrame = Root.CFrame + Root.CFrame.LookVector * 1.5 end end end)
    else if SPConn then SPConn:Disconnect() SPConn = nil end Hum.WalkSpeed = 16 * S.speed end
end

local function tScaffold()
    S.scaffold = not S.scaffold
    if S.scaffold then if ScaConn then ScaConn:Disconnect() end
        ScaConn = RS.Heartbeat:Connect(function() if S.scaffold and Root and Root.Parent then local pos = Root.Position local below = pos - Vector3.new(0,2.5,0) local r = Ray.new(below, Vector3.new(0,-0.5,0)) local h = WS:FindPartOnRay(r, Char) if not h then local b = Instance.new("Part") b.Size, b.Position, b.Anchored, b.BrickColor, b.Material, b.Parent = Vector3.new(2,0.5,2), below + Vector3.new(0,-0.25,0), true, BrickColor.new("Bright red"), Enum.Material.SmoothPlastic, WS game:GetService("Debris"):AddItem(b,5) end end end)
    else if ScaConn then ScaConn:Disconnect() ScaConn = nil end end
end

-- BANG (рывок с торможением)
local function Bang()
    if not Root or not Root.Parent then return end
    local dir, power = Root.CFrame.LookVector, 120
    Root.Velocity = dir * power
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce, bv.Velocity, bv.Parent = Vector3.new(1,1,1) * 100000, dir * power * 0.7, Root
    game:GetService("Debris"):AddItem(bv, 0.3)
    local fl = Instance.new("Part")
    fl.Size, fl.Position, fl.Anchored, fl.CanCollide, fl.BrickColor, fl.Material, fl.Transparency, fl.Parent = Vector3.new(2,2,2), Root.Position, true, false, BrickColor.new("Bright red"), Enum.Material.Neon, 0.5, workspace
    game:GetService("Debris"):AddItem(fl, 0.5)
    game:GetService("TweenService"):Create(fl, TweenInfo.new(0.5), {Transparency = 1}):Play()
end

-- JERK (рывок с инерцией и следом)
local function Jerk()
    if not Root or not Root.Parent then return end
    local dir, power = Root.CFrame.LookVector, 200
    Root.Velocity = dir * power
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce, bv.Velocity, bv.Parent = Vector3.new(1,1,1) * 50000, dir * power * 0.3, Root
    game:GetService("Debris"):AddItem(bv, 1.5)
    for i = 1, 10 do
        local tr = Instance.new("Part")
        tr.Size, tr.Position, tr.Anchored, tr.CanCollide, tr.BrickColor, tr.Material, tr.Transparency, tr.Parent = Vector3.new(0.5,0.5,0.5), Root.Position - dir * (i * 2), true, false, BrickColor.new("Cyan"), Enum.Material.Neon, 0.8 - (i * 0.07), workspace
        game:GetService("Debris"):AddItem(tr, 2)
        game:GetService("TweenService"):Create(tr, TweenInfo.new(2), {Transparency = 1}):Play()
    end
end

local function sS(v) S.speed = v Hum.WalkSpeed = 16 * v end
local function sJ(v) S.jump = v Hum.JumpPower = 50 * v end

local function cA() for _, p in ipairs(WS:GetDescendants()) do if p:IsA("BasePart") and p ~= Root and p.Parent ~= Char and not p:IsA("Terrain") then p:Destroy() end end end

local function tTP(n)
    if not n or n == "" then return end
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower():find(n:lower()) then local c = p.Character if c and c:FindFirstChild("HumanoidRootPart") then Root.CFrame = c.HumanoidRootPart.CFrame + Vector3.new(0,3,0) return end end end
end

local function cESP(p)
    if p == LP then return end
    local c = p.Character if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Size, box.Adornee, box.Color3, box.Transparency, box.AlwaysOnTop, box.ZIndex, box.Parent = Vector3.new(3,5,1.5), hrp, Color3.fromRGB(255,50,80), 0.4, true, 10, hrp
    local bb = Instance.new("BillboardGui")
    bb.Adornee, bb.Size, bb.StudsOffset, bb.AlwaysOnTop, bb.Parent = hrp, UDim2.new(0,200,0,50), Vector3.new(0,4,0), true, hrp
    local nl = Instance.new("TextLabel")
    nl.Size, nl.BackgroundTransparency, nl.Text, nl.TextColor3, nl.TextScaled, nl.Font, nl.Parent = UDim2.new(1,0,1,0), 1, p.Name .. " [" .. math.floor((c.Humanoid and c.Humanoid.Health or 0)) .. " HP]", Color3.fromRGB(255,255,255), true, Enum.Font.GothamBold, bb
    table.insert(ESPObjs, box) table.insert(ESPObjs, bb)
    if c:FindFirstChild("Humanoid") then
        local conn = c.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            local h = c.Humanoid.Health
            nl.Text = p.Name .. " [" .. math.floor(h) .. " HP]"
            box.Color3 = h < 30 and Color3.fromRGB(255,0,0) or h < 70 and Color3.fromRGB(255,255,0) or Color3.fromRGB(0,255,0)
        end)
        table.insert(ESPConns, conn)
    end
end

local function tESP()
    S.esp = not S.esp
    if S.esp then
        for _, o in ipairs(ESPObjs) do o:Destroy() end ESPObjs = {}
        for _, c in ipairs(ESPConns) do c:Disconnect() end ESPConns = {}
        for _, p in ipairs(Players:GetPlayers()) do cESP(p) end
        Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() wait(0.5) if S.esp then cESP(p) end end) end)
    else for _, o in ipairs(ESPObjs) do o:Destroy() end ESPObjs = {} for _, c in ipairs(ESPConns) do c:Disconnect() end ESPConns = {} end
end

local function gCP()
    local closest, cd = nil, S.aimbotFOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local c = p.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                local hrp = c.HumanoidRootPart
                local sp, os = Cam:WorldToScreenPoint(hrp.Position)
                if os then
                    local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(sp.X, sp.Y)).magnitude
                    if d < cd then cd = d closest = hrp end
                end
            end
        end
    end
    return closest
end

local function tAimbot() S.aimbot = not S.aimbot end

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if S.aimbot and i.UserInputType == Enum.UserInputType.MouseButton2 then
        local t = gCP()
        if t then Cam.CFrame = CFrame.new(Cam.CFrame.Position, t.Position + Vector3.new(0,1.5,0)) end
    end
    if Binds[i.KeyCode] then Binds[i.KeyCode]() end
end)

-- ============================================
-- МЕНЮ
-- ============================================
cB("✈ Fly (F)", tFly, "Движение")
cB("🌀 Noclip (N)", tNoclip, "Движение")
cB("👑 Godmode (G)", tGod, "Защита")
cB("🕷 Spider (X)", tSpider, "Движение")
cB("🏗 Scaffold (B)", tScaffold, "Строительство")
cB("💥 Bang (J)", Bang, "Движение")
cB("⚡ Jerk (K)", Jerk, "Движение")
cB("👁 ESP (E)", tESP, "Визуал")
cB("🎯 Aimbot (A)", tAimbot, "Визуал")
cB("⚡ Speed x2", function() sS(2) end, "Настройки")
cB("⚡ Speed x3", function() sS(3) end, "Настройки")
cB("🦘 Jump x2", function() sJ(2) end, "Настройки")
cB("🦘 Jump x3", function() sJ(3) end, "Настройки")
cB("🔄 Reset Speed", function() sS(1) end, "Настройки")
cB("🔄 Reset Jump", function() sJ(1) end, "Настройки")
cB("🧹 Clear (C)", cA, "Утилиты")
cB("💀 Kill All (K)", function() for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then local c = p.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health = 0 end end end end, "Утилиты")
cB("📡 TP (T)", function()
    local d = Instance.new("TextBox")
    d.Size, d.Position, d.BackgroundColor3, d.TextColor3, d.PlaceholderText, d.ClearTextOnFocus, d.Parent = UDim2.new(0,200,0,30), UDim2.new(0.5,-100,0.5,-15), Color3.fromRGB(30,30,50), Color3.fromRGB(255,255,255), "Имя игрока", false, MF
    d:CaptureFocus()
    d.FocusLost:Connect(function(ep) if ep and d.Text ~= "" then tTP(d.Text) end d:Destroy() end)
end, "Утилиты")

wait(0.1)
BC.CanvasSize = UDim2.new(0,0,0, #AllBtns * 53 + 20)

-- ============================================
-- УПРАВЛЕНИЕ
-- ============================================
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Insert then
        MF.Visible = not MF.Visible
        if MF.Visible then aB(true) TS:Create(MF, TweenInfo.new(0.4), {BackgroundTransparency = 0.05}):Play() uS("") else aB(false) TS:Create(MF, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play() wait(0.3) MF.Visible = false end
    end
end)

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.F then tFly() end
    if i.KeyCode == Enum.KeyCode.N then tNoclip() end
    if i.KeyCode == Enum.KeyCode.G then tGod() end
    if i.KeyCode == Enum.KeyCode.X then tSpider() end
    if i.KeyCode == Enum.KeyCode.B then tScaffold() end
    if i.KeyCode == Enum.KeyCode.J then Bang() end
    if i.KeyCode == Enum.KeyCode.K then Jerk() end
    if i.KeyCode == Enum.KeyCode.E then tESP() end
    if i.KeyCode == Enum.KeyCode.A then tAimbot() end
    if i.KeyCode == Enum.KeyCode.C then cA() end
    if i.KeyCode == Enum.KeyCode.K then for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then local c = p.Character if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health = 0 end end end end
    if i.KeyCode == Enum.KeyCode.T then
        local d = Instance.new("TextBox")
        d.Size, d.Position, d.BackgroundColor3, d.TextColor3, d.PlaceholderText, d.ClearTextOnFocus, d.Parent = UDim2.new(0,200,0,30), UDim2.new(0.5,-100,0.5,-15), Color3.fromRGB(30,30,50), Color3.fromRGB(255,255,255), "Имя игрока", false, MF
        d:CaptureFocus()
        d.FocusLost:Connect(function(ep) if ep and d.Text ~= "" then tTP(d.Text) end d:Destroy() end)
    end
end)

LP.CharacterAdded:Connect(function(nc)
    Char = nc Hum = Char:WaitForChild("Humanoid") Root = Char:WaitForChild("HumanoidRootPart")
    S.fly, S.noclip, S.god, S.spider, S.scaffold = false, false, false, false, false
    if BV then BV:Destroy() BV = nil end
    if BG then BG:Destroy() BG = nil end
    if NP then NP:Destroy() NP = nil end
    if SPConn then SPConn:Disconnect() SPConn = nil end
    if ScaConn then ScaConn:Disconnect() ScaConn = nil end
    sS(1) sJ(1)
end)

print("═══════════════════════════════════════")
print("  ✦ FLAGMAN XENO v5.0 ЗАГРУЖЕН ✦")
print("  Нажмите INSERT для открытия меню")
print("  ПКМ по кнопке -> бинд на любую клавишу")
print("  Хоткеи: F N G X B J K E A C K T")
print("═══════════════════════════════════════")
