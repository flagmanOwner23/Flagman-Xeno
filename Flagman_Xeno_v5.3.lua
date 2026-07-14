-- Flagman Xeno v5.3 ULTIMATE (меню по F4)
-- Автор: good
-- Все функции активны, бинды через колёсико + клавиша

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local state = {
    fly = false,
    noclip = false,
    god = false,
    spider = false,
    scaffold = false,
    esp = false,
    aimbot = false,
    antiAFK = false,
    infiniteJump = false,
    speed = 1,
    jump = 1,
    flySpeed = 50,
    aimbotFOV = 200,
    aimbotSmoothness = 0.3
}

local bodyVelocity = nil
local bodyGyro = nil
local noclipConnection = nil
local spiderConnection = nil
local scaffoldConnection = nil
local antiAFKConnection = nil
local infiniteJumpConnection = nil
local espObjects = {}
local espConnections = {}
local binds = {}
local flyKeys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

-- =================== FLY ===================
local flyConnection = nil
local function updateFly()
    if not state.fly or not RootPart then return end
    local direction = Vector3.new(0,0,0)
    local cf = Camera.CFrame
    if flyKeys.W then direction = direction + cf.LookVector end
    if flyKeys.S then direction = direction - cf.LookVector end
    if flyKeys.A then direction = direction - cf.RightVector end
    if flyKeys.D then direction = direction + cf.RightVector end
    if flyKeys.Space then direction = direction + Vector3.new(0,1,0) end
    if flyKeys.Shift then direction = direction - Vector3.new(0,1,0) end
    if direction.Magnitude > 0 then
        direction = direction.Unit * state.flySpeed
    end
    if bodyVelocity then bodyVelocity.Velocity = direction end
end

local function toggleFly()
    state.fly = not state.fly
    if state.fly then
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1,1,1)*100000
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = RootPart
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1,1,1)*100000
        bodyGyro.CFrame = RootPart.CFrame
        bodyGyro.Parent = RootPart
        flyConnection = RunService.Heartbeat:Connect(updateFly)
        Humanoid.PlatformStand = true
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        Humanoid.PlatformStand = false
    end
end

UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    local k = input.KeyCode
    if k == Enum.KeyCode.W then flyKeys.W = true
    elseif k == Enum.KeyCode.A then flyKeys.A = true
    elseif k == Enum.KeyCode.S then flyKeys.S = true
    elseif k == Enum.KeyCode.D then flyKeys.D = true
    elseif k == Enum.KeyCode.Space then flyKeys.Space = true
    elseif k == Enum.KeyCode.LeftShift then flyKeys.Shift = true end
end)
UserInputService.InputEnded:Connect(function(input,gp)
    if gp then return end
    local k = input.KeyCode
    if k == Enum.KeyCode.W then flyKeys.W = false
    elseif k == Enum.KeyCode.A then flyKeys.A = false
    elseif k == Enum.KeyCode.S then flyKeys.S = false
    elseif k == Enum.KeyCode.D then flyKeys.D = false
    elseif k == Enum.KeyCode.Space then flyKeys.Space = false
    elseif k == Enum.KeyCode.LeftShift then flyKeys.Shift = false end
end)

-- =================== NOCLIP ===================
local function toggleNoclip()
    state.noclip = not state.noclip
    if state.noclip then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Heartbeat:Connect(function()
            if state.noclip and Character and Character.Parent then
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- =================== GOD ===================
local function toggleGod()
    state.god = not state.god
    if state.god then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.BreakJointsOnDeath = false
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
        Humanoid.BreakJointsOnDeath = true
    end
end

-- =================== SPIDER ===================
local function toggleSpider()
    state.spider = not state.spider
    if state.spider then
        if spiderConnection then spiderConnection:Disconnect() end
        spiderConnection = RunService.Heartbeat:Connect(function()
            if state.spider and RootPart and RootPart.Parent then
                local ray = Ray.new(RootPart.Position, RootPart.CFrame.LookVector * 3)
                local hit = Workspace:FindPartOnRay(ray, Character)
                if hit then
                    Humanoid.WalkSpeed = 20
                    RootPart.Velocity = RootPart.Velocity + Vector3.new(0,-2,0)
                    RootPart.CFrame = RootPart.CFrame + RootPart.CFrame.LookVector * 1.5
                end
            end
        end)
    else
        if spiderConnection then spiderConnection:Disconnect() spiderConnection = nil end
        Humanoid.WalkSpeed = 16 * state.speed
    end
end

-- =================== SCAFFOLD ===================
local function toggleScaffold()
    state.scaffold = not state.scaffold
    if state.scaffold then
        if scaffoldConnection then scaffoldConnection:Disconnect() end
        scaffoldConnection = RunService.Heartbeat:Connect(function()
            if state.scaffold and RootPart and RootPart.Parent then
                local pos = RootPart.Position
                local below = pos - Vector3.new(0,2.5,0)
                local ray = Ray.new(below, Vector3.new(0,-0.5,0))
                local hit = Workspace:FindPartOnRay(ray, Character)
                if not hit then
                    local block = Instance.new("Part")
                    block.Size = Vector3.new(2,0.5,2)
                    block.Position = below + Vector3.new(0,-0.25,0)
                    block.Anchored = true
                    block.BrickColor = BrickColor.new("Bright red")
                    block.Material = Enum.Material.SmoothPlastic
                    block.Parent = Workspace
                    game:GetService("Debris"):AddItem(block, 5)
                end
            end
        end)
    else
        if scaffoldConnection then scaffoldConnection:Disconnect() scaffoldConnection = nil end
    end
end

-- =================== ANTI-AFK ===================
local function toggleAntiAFK()
    state.antiAFK = not state.antiAFK
    if state.antiAFK then
        if antiAFKConnection then antiAFKConnection:Disconnect() end
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            if state.antiAFK then
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end
        end)
    else
        if antiAFKConnection then antiAFKConnection:Disconnect() antiAFKConnection = nil end
    end
end

-- =================== INFINITE JUMP ===================
local function toggleInfiniteJump()
    state.infiniteJump = not state.infiniteJump
    if state.infiniteJump then
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if state.infiniteJump and Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if infiniteJumpConnection then infiniteJumpConnection:Disconnect() infiniteJumpConnection = nil end
    end
end

-- =================== SPEED / JUMP ===================
local function setSpeed(v)
    state.speed = v or 1
    Humanoid.WalkSpeed = 16 * state.speed
end
local function setJump(v)
    state.jump = v or 1
    Humanoid.JumpPower = 50 * state.jump
end

-- =================== CLEAR / KILL / TP ===================
local function clearAll()
    local count = 0
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part ~= RootPart and part.Parent ~= Character and not part:IsA("Terrain") then
            part:Destroy()
            count = count + 1
        end
    end
end

local function killAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    end
end

local function teleportToPlayer(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                RootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                return
            end
        end
    end
end

-- =================== ESP ===================
local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(3,5,1.5)
    box.Adornee = hrp
    box.Color3 = Color3.fromRGB(255,50,80)
    box.Transparency = 0.4
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = hrp
    
    local bill = Instance.new("BillboardGui")
    bill.Adornee = hrp
    bill.Size = UDim2.new(0,200,0,50)
    bill.StudsOffset = Vector3.new(0,4,0)
    bill.AlwaysOnTop = true
    bill.Parent = hrp
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = player.Name .. " [100 HP]"
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    table.insert(espObjects, box)
    table.insert(espObjects, bill)
    
    local function updateESP()
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            local hp = hum.Health
            label.Text = player.Name .. " [" .. math.floor(hp) .. " HP]"
            if hp < 30 then box.Color3 = Color3.fromRGB(255,0,0)
            elseif hp < 70 then box.Color3 = Color3.fromRGB(255,255,0)
            else box.Color3 = Color3.fromRGB(0,255,0) end
        end
    end
    
    local conn
    if char:FindFirstChild("Humanoid") then
        conn = char.Humanoid:GetPropertyChangedSignal("Health"):Connect(updateESP)
        table.insert(espConnections, conn)
    end
    
    local ancConn = char.AncestryChanged:Connect(function()
        if not char.Parent then
            for i,v in ipairs(espObjects) do
                if v == box or v == bill then
                    v:Destroy()
                    espObjects[i] = nil
                end
            end
            if conn then conn:Disconnect() end
            ancConn:Disconnect()
        end
    end)
    table.insert(espConnections, ancConn)
end

local function toggleESP()
    state.esp = not state.esp
    if state.esp then
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
        for _, conn in ipairs(espConnections) do conn:Disconnect() end
        espConnections = {}
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(0.5)
                if state.esp then createESP(player) end
            end)
        end)
    else
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
        for _, conn in ipairs(espConnections) do conn:Disconnect() end
        espConnections = {}
    end
end

-- =================== AIMBOT ===================
local function toggleAimbot()
    state.aimbot = not state.aimbot
end

RunService.Heartbeat:Connect(function()
    if not state.aimbot or not Mouse then return end
    local closest = nil
    local closestDist = state.aimbotFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = hrp
                    end
                end
            end
        end
    end
    if closest then
        local targetPos = closest.Position + Vector3.new(0,1.5,0)
        local screenPos = Camera:WorldToScreenPoint(targetPos)
        if screenPos then
            local current = Vector2.new(Mouse.X, Mouse.Y)
            local target = Vector2.new(screenPos.X, screenPos.Y)
            local newPos = current:Lerp(target, state.aimbotSmoothness)
            Mouse.Move(newPos)
        end
    end
end)

-- =================== GUI МЕНЮ ===================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlagmanXenoUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,500,0,600)
MainFrame.Position = UDim2.new(0.5,-250,0.5,-300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255,80,80)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundColor3 = Color3.fromRGB(40,40,70)
Title.BackgroundTransparency = 0.5
Title.Text = "FLAGMAN XENO v5.3 ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255,100,100)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-20,0,35)
SearchBox.Position = UDim2.new(0,10,0,55)
SearchBox.BackgroundColor3 = Color3.fromRGB(40,40,60)
SearchBox.TextColor3 = Color3.fromRGB(255,255,255)
SearchBox.PlaceholderText = "🔍 Поиск..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150,150,200)
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextScaled = true
SearchBox.BorderSizePixel = 1
SearchBox.BorderColor3 = Color3.fromRGB(255,80,80)
SearchBox.Parent = MainFrame

local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1,-20,1,-110)
ButtonContainer.Position = UDim2.new(0,10,0,95)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0,0,0,0)
ButtonContainer.ScrollBarThickness = 6
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

local allButtons = {}

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100,100,150)
    btn.Parent = ButtonContainer
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60,60,90) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40,40,60) end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        btn.BackgroundColor3 = Color3.fromRGB(100,255,100)
        wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
    end)
    
    -- Бинд через колёсико
    btn.MouseButton2Click:Connect(function()
        local dialog = Instance.new("TextBox")
        dialog.Size = UDim2.new(0,300,0,35)
        dialog.Position = UDim2.new(0.5,-150,0.5,-17)
        dialog.BackgroundColor3 = Color3.fromRGB(30,30,50)
        dialog.TextColor3 = Color3.fromRGB(255,255,255)
        dialog.PlaceholderText = "Нажмите клавишу..."
        dialog.ClearTextOnFocus = false
        dialog.Font = Enum.Font.GothamMedium
        dialog.TextScaled = true
        dialog.Parent = MainFrame
        dialog:CaptureFocus()
        
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                binds[input.KeyCode] = callback
                dialog:Destroy()
                conn:Disconnect()
            end
        end)
        dialog.FocusLost:Connect(function()
            dialog:Destroy()
            if conn then conn:Disconnect() end
        end)
    end)
    
    table.insert(allButtons, {button = btn, text = text:lower()})
    return btn
end

local function updateSearch(query)
    query = query:lower()
    local vis = 0
    for _, data in ipairs(allButtons) do
        if query == "" or data.text:find(query,1,true) then
            data.button.Visible = true
            vis = vis + 1
        else
            data.button.Visible = false
        end
    end
    ButtonContainer.CanvasSize = UDim2.new(0,0,0, vis * 46 + 20)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function() updateSearch(SearchBox.Text) end)

-- =================== КНОПКИ ===================
createButton("Fly (WASD+Space/Shift)", toggleFly)
createButton("Noclip", toggleNoclip)
createButton("Godmode", toggleGod)
createButton("Spider [X]", toggleSpider)
createButton("Scaffold", toggleScaffold)
createButton("ESP", toggleESP)
createButton("Aimbot", toggleAimbot)
createButton("Anti-AFK", toggleAntiAFK)
createButton("Infinite Jump", toggleInfiniteJump)
createButton("Speed x2", function() setSpeed(2) end)
createButton("Speed x3", function() setSpeed(3) end)
createButton("Jump x2", function() setJump(2) end)
createButton("Jump x3", function() setJump(3) end)
createButton("Reset Speed", function() setSpeed(1) end)
createButton("Reset Jump", function() setJump(1) end)
createButton("Clear Parts", clearAll)
createButton("Kill All", killAll)
createButton("Teleport", function()
    local dlg = Instance.new("TextBox")
    dlg.Size = UDim2.new(0,200,0,30)
    dlg.Position = UDim2.new(0.5,-100,0.5,-15)
    dlg.BackgroundColor3 = Color3.fromRGB(30,30,50)
    dlg.TextColor3 = Color3.fromRGB(255,255,255)
    dlg.PlaceholderText = "Имя игрока"
    dlg.ClearTextOnFocus = false
    dlg.Parent = MainFrame
    dlg:CaptureFocus()
    dlg.FocusLost:Connect(function(enter)
        if enter and dlg.Text ~= "" then teleportToPlayer(dlg.Text) end
        dlg:Destroy()
    end)
end)

wait(0.1)
ButtonContainer.CanvasSize = UDim2.new(0,0,0, #allButtons * 46 + 20)

-- =================== УПРАВЛЕНИЕ ===================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    -- ОТКРЫТИЕ МЕНЮ ПО F4
    if input.KeyCode == Enum.KeyCode.F4 then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then updateSearch("") end
    end
    if input.KeyCode == Enum.KeyCode.X then toggleSpider() end
    if binds[input.KeyCode] then binds[input.KeyCode]() end
end)

-- =================== СБРОС ПРИ РЕСПАВНЕ ===================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    state.fly = false
    state.noclip = false
    state.god = false
    state.spider = false
    state.scaffold = false
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if spiderConnection then spiderConnection:Disconnect() spiderConnection = nil end
    if scaffoldConnection then scaffoldConnection:Disconnect() scaffoldConnection = nil end
    Humanoid.PlatformStand = false
    setSpeed(1)
    setJump(1)
end)

print("═══════════════════════════════════════")
print("  ✦ FLAGMAN XENO v5.3 ULTIMATE ✦")
print("  F4 - меню | X - Spider")
print("  FLY: WASD + Space(вверх) + Shift(вниз)")
print("  БИНДЫ: нажмите колёсико на кнопке -> клавиша")
print("  ДОБАВЛЕНО: Anti-AFK, Infinite Jump")
print("═══════════════════════════════════════")
