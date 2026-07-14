-- Flagman Xeno v10.3 (FULL FIX)
-- Центр + its flagman справа снизу
-- Фиолетовая тема, все функции работают
-- Автор: good

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================
-- СОСТОЯНИЯ
-- ============================================
local flyActive = false
local flySpeed = 50
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil
local flyKeys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

local spiderActive = false
local spiderConnection = nil

local noclipActive = false
local noclipPart = nil

local godActive = false
local espActive = false
local espObjects = {}
local espConnections = {}

local infinityJumpActive = false
local infinityJumpConnection = nil

local binds = {}
local bindWaiting = nil

-- ============================================
-- FLY
-- ============================================
local function updateFly()
    if not flyActive or not RootPart then return end
    local dir = Vector3.new(0, 0, 0)
    local cf = Camera.CFrame
    local forward = cf.LookVector
    local right = cf.RightVector
    
    if flyKeys.W then dir = dir + forward end
    if flyKeys.S then dir = dir - forward end
    if flyKeys.A then dir = dir - right end
    if flyKeys.D then dir = dir + right end
    if flyKeys.Space then dir = dir + Vector3.new(0, 1, 0) end
    if flyKeys.Shift then dir = dir - Vector3.new(0, 1, 0) end
    
    if dir.Magnitude > 0 then
        dir = dir.Unit * flySpeed
    end
    if bodyVelocity then
        bodyVelocity.Velocity = dir
    end
end

local function toggleFly()
    flyActive = not flyActive
    if flyActive then
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVelocity.Parent = RootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
        bodyGyro.CFrame = RootPart.CFrame
        bodyGyro.Parent = RootPart
        
        flyConnection = RunService.Heartbeat:Connect(updateFly)
        Humanoid.PlatformStand = true
        print("[Xeno] Fly ON (Speed: " .. flySpeed .. ")")
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
        Humanoid.PlatformStand = false
        print("[Xeno] Fly OFF")
    end
end

local function setFlySpeed(val)
    flySpeed = val
    print("[Xeno] Fly Speed: " .. flySpeed)
end

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if flyActive then
        if inp.KeyCode == Enum.KeyCode.W then flyKeys.W = true end
        if inp.KeyCode == Enum.KeyCode.A then flyKeys.A = true end
        if inp.KeyCode == Enum.KeyCode.S then flyKeys.S = true end
        if inp.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
        if inp.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true end
        if inp.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true end
    end
end)

UserInputService.InputEnded:Connect(function(inp, gp)
    if gp then return end
    if flyActive then
        if inp.KeyCode == Enum.KeyCode.W then flyKeys.W = false end
        if inp.KeyCode == Enum.KeyCode.A then flyKeys.A = false end
        if inp.KeyCode == Enum.KeyCode.S then flyKeys.S = false end
        if inp.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
        if inp.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false end
        if inp.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false end
    end
end)

-- ============================================
-- SPIDER
-- ============================================
local function toggleSpider()
    spiderActive = not spiderActive
    if spiderActive then
        if spiderConnection then spiderConnection:Disconnect() end
        spiderConnection = RunService.Heartbeat:Connect(function()
            if spiderActive and RootPart and RootPart.Parent and Humanoid then
                local ray = Ray.new(RootPart.Position, RootPart.CFrame.LookVector * 3)
                local hit = Workspace:FindPartOnRay(ray, Character)
                if hit then
                    Humanoid.WalkSpeed = 20
                    RootPart.Velocity = RootPart.Velocity + Vector3.new(0, -2, 0)
                    RootPart.CFrame = RootPart.CFrame + RootPart.CFrame.LookVector * 1.5
                end
            end
        end)
        print("[Xeno] Spider ON")
    else
        if spiderConnection then
            spiderConnection:Disconnect()
            spiderConnection = nil
        end
        Humanoid.WalkSpeed = 16
        print("[Xeno] Spider OFF")
    end
end

-- ============================================
-- NOCLIP
-- ============================================
local function toggleNoclip()
    noclipActive = not noclipActive
    if noclipActive then
        if not noclipPart then
            noclipPart = Instance.new("Part")
            noclipPart.CanCollide = false
            noclipPart.Transparency = 1
            noclipPart.Size = Vector3.new(5, 5, 5)
            noclipPart.Anchored = true
            noclipPart.Parent = Workspace
        end
        for _, p in ipairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
        print("[Xeno] Noclip ON")
    else
        if noclipPart then noclipPart:Destroy() end
        for _, p in ipairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = true
            end
        end
        print("[Xeno] Noclip OFF")
    end
end

-- ============================================
-- GODMODE
-- ============================================
local function toggleGod()
    godActive = not godActive
    if godActive then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.BreakJointsOnDeath = false
        print("[Xeno] God ON")
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
        Humanoid.BreakJointsOnDeath = true
        print("[Xeno] God OFF")
    end
end

-- ============================================
-- ESP
-- ============================================
local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(3, 5, 1.5)
    box.Adornee = hrp
    box.Color3 = Color3.fromRGB(255, 50, 80)
    box.Transparency = 0.4
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = hrp
    
    local bill = Instance.new("BillboardGui")
    bill.Adornee = hrp
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.StudsOffset = Vector3.new(0, 4, 0)
    bill.AlwaysOnTop = true
    bill.Parent = hrp
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    table.insert(espObjects, box)
    table.insert(espObjects, bill)
end

local function toggleESP()
    espActive = not espActive
    if espActive then
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
        for _, conn in ipairs(espConnections) do conn:Disconnect() end
        espConnections = {}
        
        for _, plr in ipairs(Players:GetPlayers()) do
            createESP(plr)
        end
        print("[Xeno] ESP ON")
    else
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
        print("[Xeno] ESP OFF")
    end
end

-- ============================================
-- INFINITY JUMP
-- ============================================
local function toggleInfinityJump()
    infinityJumpActive = not infinityJumpActive
    if infinityJumpActive then
        if infinityJumpConnection then infinityJumpConnection:Disconnect() end
        infinityJumpConnection = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.KeyCode == Enum.KeyCode.Space then
                Humanoid.Jump = true
                task.wait(0.02)
                Humanoid.Jump = false
            end
        end)
        print("[Xeno] Infinity Jump ON")
    else
        if infinityJumpConnection then
            infinityJumpConnection:Disconnect()
            infinityJumpConnection = nil
        end
        print("[Xeno] Infinity Jump OFF")
    end
end

-- ============================================
-- БИНДЫ
-- ============================================
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    
    if binds[inp.KeyCode] then
        binds[inp.KeyCode]()
    end
    
    if bindWaiting then
        if inp.KeyCode == Enum.KeyCode.Delete then
            for k, f in pairs(binds) do
                if f == bindWaiting then
                    binds[k] = nil
                    print("[Xeno] ❌ Бинд снят: " .. tostring(k.Name))
                    break
                end
            end
            bindWaiting = nil
        elseif inp.KeyCode ~= Enum.KeyCode.Unknown then
            binds[inp.KeyCode] = bindWaiting
            print("[Xeno] ✅ Бинд: " .. tostring(inp.KeyCode.Name))
            bindWaiting = nil
        end
    end
end)

-- ============================================
-- ФИОЛЕТОВОЕ МЕНЮ (ЦЕНТР)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlagmanXenoUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(180, 100, 255)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
Title.BackgroundTransparency = 0.5
Title.Text = "✦ FLAGMAN XENO ✦"
Title.TextColor3 = Color3.fromRGB(200, 150, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -10, 0, 30)
SearchBox.Position = UDim2.new(0, 5, 0, 50)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "🔍 Поиск..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(180, 150, 200)
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextScaled = true
SearchBox.BorderSizePixel = 1
SearchBox.BorderColor3 = Color3.fromRGB(180, 100, 255)
SearchBox.Parent = MainFrame

local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -10, 1, -100)
ButtonContainer.Position = UDim2.new(0, 5, 0, 85)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.ScrollBarThickness = 6
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

local allButtons = {}

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 200, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(180, 100, 255)
    btn.Parent = ButtonContainer
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 40, 90)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    end)
    
    btn.MouseButton2Click:Connect(function()
        bindWaiting = callback
        print("[Xeno] ⏳ Ожидание клавиши для бинда...")
    end)
    
    table.insert(allButtons, {button = btn, text = text:lower()})
    return btn
end

local function updateSearch(query)
    query = query:lower()
    local count = 0
    for _, data in ipairs(allButtons) do
        if query == "" or string.find(data.text, query, 1, true) then
            data.button.Visible = true
            count = count + 1
        else
            data.button.Visible = false
        end
    end
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, count * 36 + 20)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateSearch(SearchBox.Text)
end)

-- ============================================
-- КНОПКИ ЦЕНТРАЛЬНОГО МЕНЮ
-- ============================================
createButton("Fly (WASD + Space/Shift)", toggleFly)
createButton("Fly Speed 25", function() setFlySpeed(25) end)
createButton("Fly Speed 50", function() setFlySpeed(50) end)
createButton("Fly Speed 75", function() setFlySpeed(75) end)
createButton("Fly Speed 100", function() setFlySpeed(100) end)
createButton("Fly Speed 150", function() setFlySpeed(150) end)
createButton("Fly Speed 200", function() setFlySpeed(200) end)

createButton("Noclip", toggleNoclip)
createButton("Godmode", toggleGod)
createButton("Spider [X]", toggleSpider)
createButton("ESP", toggleESP)
createButton("Infinity Jump", toggleInfinityJump)

createButton("Kill All", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    end
    print("[Xeno] All players killed")
end)

createButton("Teleport", function()
    local d = Instance.new("TextBox")
    d.Size = UDim2.new(0, 200, 0, 30)
    d.Position = UDim2.new(0.5, -100, 0.5, -15)
    d.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    d.TextColor3 = Color3.fromRGB(255, 255, 255)
    d.PlaceholderText = "Имя игрока"
    d.ClearTextOnFocus = false
    d.Font = Enum.Font.GothamMedium
    d.TextScaled = true
    d.Parent = MainFrame
    d:CaptureFocus()
    d.FocusLost:Connect(function(entered)
        if entered and d.Text ~= "" then
            for _, plr in ipairs(Players:GetPlayers()) do
                if string.find(plr.Name:lower(), d.Text:lower(), 1, true) then
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        RootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        print("[Xeno] TP to " .. plr.Name)
                        break
                    end
                end
            end
        end
        d:Destroy()
    end)
end)

createButton("Clear Parts", function()
    local count = 0
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part ~= RootPart and part.Parent ~= Character then
            if not part:IsA("Terrain") then
                part:Destroy()
                count = count + 1
            end
        end
    end
    print("[Xeno] Cleared " .. count .. " parts")
end)

task.wait(0.1)
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, #allButtons * 36 + 20)

-- ============================================
-- ITS FLAGMAN (СПРАВА СНИЗУ)
-- ============================================
local IYFrame = Instance.new("Frame")
IYFrame.Size = UDim2.new(0, 320, 0, 420)
IYFrame.Position = UDim2.new(1, -340, 1, -440)
IYFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
IYFrame.BackgroundTransparency = 0.05
IYFrame.BorderSizePixel = 2
IYFrame.BorderColor3 = Color3.fromRGB(180, 100, 255)
IYFrame.ClipsDescendants = true
IYFrame.Parent = ScreenGui
IYFrame.Visible = false

local IYTitle = Instance.new("TextLabel")
IYTitle.Size = UDim2.new(1, 0, 0, 35)
IYTitle.Position = UDim2.new(0, 0, 0, 0)
IYTitle.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
IYTitle.BackgroundTransparency = 0.5
IYTitle.Text = "✦ ITS FLAGMAN ✦"
IYTitle.TextColor3 = Color3.fromRGB(200, 150, 255)
IYTitle.TextScaled = true
IYTitle.Font = Enum.Font.GothamBold
IYTitle.Parent = IYFrame

local IYSearch = Instance.new("TextBox")
IYSearch.Size = UDim2.new(1, -10, 0, 30)
IYSearch.Position = UDim2.new(0, 5, 0, 40)
IYSearch.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
IYSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
IYSearch.PlaceholderText = "🔍 Поиск..."
IYSearch.PlaceholderColor3 = Color3.fromRGB(180, 150, 200)
IYSearch.Text = ""
IYSearch.ClearTextOnFocus = false
IYSearch.Font = Enum.Font.GothamMedium
IYSearch.TextScaled = true
IYSearch.BorderSizePixel = 1
IYSearch.BorderColor3 = Color3.fromRGB(180, 100, 255)
IYSearch.Parent = IYFrame

local IYContainer = Instance.new("ScrollingFrame")
IYContainer.Size = UDim2.new(1, -10, 1, -90)
IYContainer.Position = UDim2.new(0, 5, 0, 75)
IYContainer.BackgroundTransparency = 1
IYContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
IYContainer.ScrollBarThickness = 6
IYContainer.Parent = IYFrame

local IYLayout = Instance.new("UIListLayout")
IYLayout.Padding = UDim.new(0, 4)
IYLayout.SortOrder = Enum.SortOrder.LayoutOrder
IYLayout.Parent = IYContainer

local iyButtons = {}

local function createIYButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 200, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(180, 100, 255)
    btn.Parent = IYContainer
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(70, 40, 90)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    end)
    
    btn.MouseButton2Click:Connect(function()
        bindWaiting = callback
        print("[Xeno] ⏳ Ожидание клавиши для бинда...")
    end)
    
    table.insert(iyButtons, {button = btn, text = text:lower()})
    return btn
end

local function updateIYSearch(query)
    query = query:lower()
    local count = 0
    for _, data in ipairs(iyButtons) do
        if query == "" or string.find(data.text, query, 1, true) then
            data.button.Visible = true
            count = count + 1
        else
            data.button.Visible = false
        end
    end
    IYContainer.CanvasSize = UDim2.new(0, 0, 0, count * 32 + 20)
end

IYSearch:GetPropertyChangedSignal("Text"):Connect(function()
    updateIYSearch(IYSearch.Text)
end)

-- ============================================
-- КНОПКИ ITS FLAGMAN
-- ============================================
createIYButton("Fly", toggleFly)
createIYButton("Fly Speed 50", function() setFlySpeed(50) end)
createIYButton("Fly Speed 100", function() setFlySpeed(100) end)
createIYButton("Fly Speed 200", function() setFlySpeed(200) end)
createIYButton("Noclip", toggleNoclip)
createIYButton("Godmode", toggleGod)
createIYButton("Spider", toggleSpider)
createIYButton("ESP", toggleESP)
createIYButton("Infinity Jump", toggleInfinityJump)
createIYButton("Kill All", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    end
    print("[Xeno] All players killed")
end)
createIYButton("Teleport", function()
    local d = Instance.new("TextBox")
    d.Size = UDim2.new(0, 200, 0, 30)
    d.Position = UDim2.new(0.5, -100, 0.5, -15)
    d.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
    d.TextColor3 = Color3.fromRGB(255, 255, 255)
    d.PlaceholderText = "Имя игрока"
    d.ClearTextOnFocus = false
    d.Font = Enum.Font.GothamMedium
    d.TextScaled = true
    d.Parent = IYFrame
    d:CaptureFocus()
    d.FocusLost:Connect(function(entered)
        if entered and d.Text ~= "" then
            for _, plr in ipairs(Players:GetPlayers()) do
                if string.find(plr.Name:lower(), d.Text:lower(), 1, true) then
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        RootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        print("[Xeno] TP to " .. plr.Name)
                        break
                    end
                end
            end
        end
        d:Destroy()
    end)
end)

task.wait(0.1)
IYContainer.CanvasSize = UDim2.new(0, 0, 0, #iyButtons * 32 + 20)

-- ============================================
-- УПРАВЛЕНИЕ
-- ============================================
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then updateSearch("") end
    end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        IYFrame.Visible = not IYFrame.Visible
        if IYFrame.Visible then updateIYSearch("") end
    end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.X then
        toggleSpider()
    end
end)

-- ============================================
-- СБРОС ПРИ ПЕРЕРОЖДЕНИИ
-- ============================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    flyActive = false
    spiderActive = false
    noclipActive = false
    godActive = false
    espActive = false
    infinityJumpActive = false
    
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    if flyConnection then flyConnection:Disconnect() end
    if spiderConnection then spiderConnection:Disconnect() end
    if infinityJumpConnection then infinityJumpConnection:Disconnect() end
    if noclipPart then noclipPart:Destroy() end
    
    Humanoid.PlatformStand = false
    print("[Xeno] Character reset")
end)

print("═══════════════════════════════════════")
print("  ✦ FLAGMAN XENO v10.3 ✦")
print("  INSERT - центральное меню")
print("  Right Shift - ITS FLAGMAN (справа снизу)")
print("  X - Spider")
print("  БИНДЫ: ПКМ на кнопке -> нажать клавишу")
print("  DELETE - снять бинд")
print("═══════════════════════════════════════")
