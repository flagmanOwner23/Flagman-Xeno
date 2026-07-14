-- Flagman Xeno v6.3 (ПКМ БИНДЫ + DELETE + BANG FIX)
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

local state = {
    fly = false,
    fly2 = false,
    noclip = false,
    god = false,
    spider = false,
    scaffold = false,
    esp = false,
    aimbot = false,
    bang = false,
    speed = 1,
    jump = 1,
    flySpeed = 50,
    fly2Speed = 100,
    aimbotFOV = 200
}

local bodyVelocity = nil
local bodyGyro = nil
local noclipPart = nil
local spiderConnection = nil
local scaffoldConnection = nil
local espObjects = {}
local espConnections = {}
local binds = {}  -- {[KeyCode] = function}
local bindToDelete = nil  -- Функция, которую нужно удалить по Delete

-- ============================================
-- ПОЛЁТ (обычный)
-- ============================================
local flyConnection = nil
local flyKeys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

local function updateFly()
    if not state.fly or not RootPart then return end
    local direction = Vector3.new(0, 0, 0)
    local camCF = Camera.CFrame
    local forward = camCF.LookVector
    local right = camCF.RightVector
    
    if flyKeys.W then direction = direction + forward end
    if flyKeys.S then direction = direction - forward end
    if flyKeys.A then direction = direction - right end
    if flyKeys.D then direction = direction + right end
    if flyKeys.Space then direction = direction + Vector3.new(0, 1, 0) end
    if flyKeys.Shift then direction = direction - Vector3.new(0, 1, 0) end
    
    if direction.Magnitude > 0 then
        direction = direction.Unit * state.flySpeed
    end
    if bodyVelocity then
        bodyVelocity.Velocity = direction
    end
end

local function toggleFly()
    if state.fly2 then toggleFly2() end
    state.fly = not state.fly
    if state.fly then
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = RootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
        bodyGyro.CFrame = RootPart.CFrame
        bodyGyro.Parent = RootPart
        
        flyConnection = RunService.Heartbeat:Connect(updateFly)
        Humanoid.PlatformStand = true
        print("[Xeno] Fly ON")
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        Humanoid.PlatformStand = false
        print("[Xeno] Fly OFF")
    end
end

-- ============================================
-- ПОЛЁТ X2
-- ============================================
local fly2Connection = nil
local fly2Keys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

local function updateFly2()
    if not state.fly2 or not RootPart then return end
    local direction = Vector3.new(0, 0, 0)
    local camCF = Camera.CFrame
    local forward = camCF.LookVector
    local right = camCF.RightVector
    
    if fly2Keys.W then direction = direction + forward end
    if fly2Keys.S then direction = direction - forward end
    if fly2Keys.A then direction = direction - right end
    if fly2Keys.D then direction = direction + right end
    if fly2Keys.Space then direction = direction + Vector3.new(0, 1, 0) end
    if fly2Keys.Shift then direction = direction - Vector3.new(0, 1, 0) end
    
    if direction.Magnitude > 0 then
        direction = direction.Unit * state.fly2Speed
    end
    if bodyVelocity then
        bodyVelocity.Velocity = direction
    end
end

local function toggleFly2()
    if state.fly then toggleFly() end
    state.fly2 = not state.fly2
    if state.fly2 then
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if fly2Connection then fly2Connection:Disconnect() end
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = RootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
        bodyGyro.CFrame = RootPart.CFrame
        bodyGyro.Parent = RootPart
        
        fly2Connection = RunService.Heartbeat:Connect(updateFly2)
        Humanoid.PlatformStand = true
        print("[Xeno] Fly X2 ON")
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if fly2Connection then fly2Connection:Disconnect() fly2Connection = nil end
        Humanoid.PlatformStand = false
        print("[Xeno] Fly X2 OFF")
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if state.fly then
        if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true end
        if input.KeyCode == Enum.KeyCode.A then flyKeys.A = true end
        if input.KeyCode == Enum.KeyCode.S then flyKeys.S = true end
        if input.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
        if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true end
    end
    if state.fly2 then
        if input.KeyCode == Enum.KeyCode.W then fly2Keys.W = true end
        if input.KeyCode == Enum.KeyCode.A then fly2Keys.A = true end
        if input.KeyCode == Enum.KeyCode.S then fly2Keys.S = true end
        if input.KeyCode == Enum.KeyCode.D then fly2Keys.D = true end
        if input.KeyCode == Enum.KeyCode.Space then fly2Keys.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then fly2Keys.Shift = true end
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if state.fly then
        if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false end
        if input.KeyCode == Enum.KeyCode.A then flyKeys.A = false end
        if input.KeyCode == Enum.KeyCode.S then flyKeys.S = false end
        if input.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
        if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false end
    end
    if state.fly2 then
        if input.KeyCode == Enum.KeyCode.W then fly2Keys.W = false end
        if input.KeyCode == Enum.KeyCode.A then fly2Keys.A = false end
        if input.KeyCode == Enum.KeyCode.S then fly2Keys.S = false end
        if input.KeyCode == Enum.KeyCode.D then fly2Keys.D = false end
        if input.KeyCode == Enum.KeyCode.Space then fly2Keys.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then fly2Keys.Shift = false end
    end
end)

-- ============================================
-- BANG (ПРЕСЛЕДОВАНИЕ + ПИНГ-ПОНГ 1 МЕТР)
-- ============================================
local bangConnection = nil
local bangTarget = nil
local bangActive = false
local bangPingPong = 1
local bangStep = 1

local function stopBang()
    bangActive = false
    bangTarget = nil
    bangPingPong = 1
    if bangConnection then
        bangConnection:Disconnect()
        bangConnection = nil
    end
    print("[Xeno] Bang: остановлен")
end

local function startBang(targetName)
    if not targetName or targetName == "" then
        print("[Xeno] Bang: ник не указан")
        return
    end
    
    local target = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower()) then
            target = player
            break
        end
    end
    
    if not target then
        print("[Xeno] Bang: игрок не найден: " .. targetName)
        return
    end
    
    if bangActive then stopBang() end
    
    bangTarget = target
    bangActive = true
    bangPingPong = 1
    print("[Xeno] Bang: преследую " .. target.Name)
    
    if not state.fly and not state.fly2 then
        toggleFly()
    end
    
    local lastMove = 0
    local cooldown = 0.3  -- МИНИМАЛЬНАЯ ЗАДЕРЖКА
    
    bangConnection = RunService.Heartbeat:Connect(function()
        if not bangActive or not bangTarget or not bangTarget.Character then
            stopBang()
            return
        end
        
        local targetRoot = bangTarget.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot or not RootPart then
            return
        end
        
        local distance = (RootPart.Position - targetRoot.Position).Magnitude
        
        if distance > 5 then
            local dir = (targetRoot.Position - RootPart.Position).Unit
            if bodyVelocity then
                bodyVelocity.Velocity = dir * state.flySpeed
            end
        else
            local now = tick()
            if now - lastMove >= cooldown then
                local offset = Vector3.new(0, 0, bangStep * bangPingPong)
                local targetPos = targetRoot.Position + offset
                local dir = (targetPos - RootPart.Position).Unit
                
                if bodyVelocity then
                    bodyVelocity.Velocity = dir * state.flySpeed * 0.5
                end
                
                bangPingPong = bangPingPong * -1
                lastMove = now
                print("[Xeno] Bang: " .. (bangPingPong == 1 and "вперёд" or "назад") .. " 1м")
            end
        end
    end)
end

local function toggleBang(targetName)
    if bangActive then
        stopBang()
    else
        startBang(targetName or "")
    end
end

-- ============================================
-- ОСТАЛЬНЫЕ ФУНКЦИИ
-- ============================================

local function toggleNoclip()
    state.noclip = not state.noclip
    if state.noclip then
        if not noclipPart then
            noclipPart = Instance.new("Part")
            noclipPart.CanCollide = false
            noclipPart.Transparency = 1
            noclipPart.Size = Vector3.new(5, 5, 5)
            noclipPart.Anchored = true
            noclipPart.Parent = Workspace
        end
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        print("[Xeno] Noclip ON")
    else
        if noclipPart then noclipPart:Destroy() noclipPart = nil end
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        print("[Xeno] Noclip OFF")
    end
end

local function toggleGod()
    state.god = not state.god
    if state.god then
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

local function toggleSpider()
    state.spider = not state.spider
    if state.spider then
        if spiderConnection then spiderConnection:Disconnect() end
        spiderConnection = RunService.Heartbeat:Connect(function()
            if state.spider and RootPart and RootPart.Parent and Humanoid then
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
        Humanoid.WalkSpeed = 16 * state.speed
        print("[Xeno] Spider OFF")
    end
end

local function toggleScaffold()
    state.scaffold = not state.scaffold
    if state.scaffold then
        if scaffoldConnection then scaffoldConnection:Disconnect() end
        scaffoldConnection = RunService.Heartbeat:Connect(function()
            if state.scaffold and RootPart and RootPart.Parent then
                local pos = RootPart.Position
                local below = pos - Vector3.new(0, 2.5, 0)
                local ray = Ray.new(below, Vector3.new(0, -0.5, 0))
                local hit = Workspace:FindPartOnRay(ray, Character)
                if not hit then
                    local block = Instance.new("Part")
                    block.Size = Vector3.new(2, 0.5, 2)
                    block.Position = below + Vector3.new(0, -0.25, 0)
                    block.Anchored = true
                    block.BrickColor = BrickColor.new("Bright red")
                    block.Material = Enum.Material.SmoothPlastic
                    block.Parent = Workspace
                    game:GetService("Debris"):AddItem(block, 5)
                end
            end
        end)
        print("[Xeno] Scaffold ON")
    else
        if scaffoldConnection then
            scaffoldConnection:Disconnect()
            scaffoldConnection = nil
        end
        print("[Xeno] Scaffold OFF")
    end
end

local function setSpeed(value)
    state.speed = value or 1
    Humanoid.WalkSpeed = 16 * state.speed
    print("[Xeno] Speed: " .. Humanoid.WalkSpeed)
end

local function setJump(value)
    state.jump = value or 1
    Humanoid.JumpPower = 50 * state.jump
    print("[Xeno] Jump: " .. Humanoid.JumpPower)
end

local function clearAll()
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
end

local function teleportToPlayer(targetName)
    if not targetName or targetName == "" then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(targetName:lower()) then
            local targetChar = player.Character
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                RootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                print("[Xeno] TP to " .. player.Name)
                return
            end
        end
    end
    print("[Xeno] Player not found")
end

-- ESP
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
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name .. " [" .. math.floor((char.Humanoid and char.Humanoid.Health or 0)) .. " HP]"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    table.insert(espObjects, box)
    table.insert(espObjects, billboard)
    
    if char:FindFirstChild("Humanoid") then
        local conn = char.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            local health = char.Humanoid.Health
            nameLabel.Text = player.Name .. " [" .. math.floor(health) .. " HP]"
            if health < 30 then
                box.Color3 = Color3.fromRGB(255, 0, 0)
            elseif health < 70 then
                box.Color3 = Color3.fromRGB(255, 255, 0)
            else
                box.Color3 = Color3.fromRGB(0, 255, 0)
            end
        end)
        table.insert(espConnections, conn)
    end
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
        print("[Xeno] ESP ON")
    else
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
        for _, conn in ipairs(espConnections) do conn:Disconnect() end
        espConnections = {}
        print("[Xeno] ESP OFF")
    end
end

-- AIMBOT
local function getClosestPlayer()
    local closest, closestDist = nil, state.aimbotFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = hrp
                    end
                end
            end
        end
    end
    return closest
end

local function toggleAimbot()
    state.aimbot = not state.aimbot
    print("[Xeno] Aimbot " .. (state.aimbot and "ON" or "OFF"))
end

-- ============================================
-- СИСТЕМА БИНДОВ (ПКМ + DELETE)
-- ============================================
local function bindFunction(key, func)
    -- Удаляем старый бинд на эту клавишу
    if binds[key] then
        binds[key] = nil
    end
    binds[key] = func
    print("[Xeno] ✅ Бинд: " .. tostring(key) .. " -> " .. tostring(func))
end

local function unbindFunction(key)
    if binds[key] then
        binds[key] = nil
        print("[Xeno] ❌ Бинд снят: " .. tostring(key))
        return true
    end
    return false
end

-- Обработка биндов
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if binds[input.KeyCode] then
        binds[input.KeyCode]()
    end
    
    -- DELETE для удаления текущего бинда (если есть выделенный)
    if input.KeyCode == Enum.KeyCode.Delete and bindToDelete then
        for key, func in pairs(binds) do
            if func == bindToDelete then
                unbindFunction(key)
                bindToDelete = nil
                break
            end
        end
    end
end)

-- ============================================
-- МЕНЮ
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlagmanXenoUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 650)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 80, 80)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
Title.BackgroundTransparency = 0.5
Title.Text = "FLAGMAN XENO v6.3"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -20, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 55)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "🔍 Поиск функции..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 200)
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextScaled = true
SearchBox.BorderSizePixel = 1
SearchBox.BorderColor3 = Color3.fromRGB(255, 80, 80)
SearchBox.Parent = MainFrame

local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -110)
ButtonContainer.Position = UDim2.new(0, 10, 0, 95)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.ScrollBarThickness = 6
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

local allButtons = {}

-- ============================================
-- КНОПКИ (ПКМ ДЛЯ БИНДА)
-- ============================================
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 100, 150)
    btn.Parent = ButtonContainer
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end)
    
    -- БИНД: ПРАВАЯ КНОПКА МЫШИ
    btn.MouseButton2Click:Connect(function()
        bindToDelete = callback  -- Запоминаем функцию для удаления по Delete
        
        local dialog = Instance.new("TextBox")
        dialog.Size = UDim2.new(0, 300, 0, 35)
        dialog.Position = UDim2.new(0.5, -150, 0.5, -17)
        dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        dialog.TextColor3 = Color3.fromRGB(255, 255, 255)
        dialog.PlaceholderText = "Нажмите клавишу для бинда (Delete для удаления)"
        dialog.ClearTextOnFocus = false
        dialog.Font = Enum.Font.GothamMedium
        dialog.TextScaled = true
        dialog.Parent = MainFrame
        dialog:CaptureFocus()
        
        local connection = nil
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                if input.KeyCode == Enum.KeyCode.Delete then
                    -- Удаляем бинд у этой функции
                    for key, func in pairs(binds) do
                        if func == callback then
                            unbindFunction(key)
                            break
                        end
                    end
                    bindToDelete = nil
                else
                    bindFunction(input.KeyCode, callback)
                end
                dialog:Destroy()
                if connection then connection:Disconnect() end
            end
        end)
        
        dialog.FocusLost:Connect(function()
            dialog:Destroy()
            if connection then connection:Disconnect() end
        end)
    end)
    
    table.insert(allButtons, {
        button = btn,
        text = text:lower()
    })
    
    return btn
end

local function updateSearch(query)
    query = query:lower()
    local visibleCount = 0
    for _, data in ipairs(allButtons) do
        if query == "" or data.text:find(query, 1, true) then
            data.button.Visible = true
            visibleCount = visibleCount + 1
        else
            data.button.Visible = false
        end
    end
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 46 + 20)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateSearch(SearchBox.Text)
end)

-- ============================================
-- КНОПКИ МЕНЮ
-- ============================================
createButton("Fly (WASD + Space/Shift)", toggleFly)
createButton("Fly X2 (WASD + Space/Shift)", toggleFly2)
createButton("Noclip", toggleNoclip)
createButton("Godmode", toggleGod)
createButton("Spider [X]", toggleSpider)
createButton("Scaffold", toggleScaffold)
createButton("ESP", toggleESP)
createButton("Aimbot", toggleAimbot)

createButton("Bang (преследование)", function()
    local dialog = Instance.new("TextBox")
    dialog.Size = UDim2.new(0, 250, 0, 35)
    dialog.Position = UDim2.new(0.5, -125, 0.5, -17)
    dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    dialog.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialog.PlaceholderText = "Введите ник игрока для Bang"
    dialog.ClearTextOnFocus = false
    dialog.Font = Enum.Font.GothamMedium
    dialog.TextScaled = true
    dialog.Parent = MainFrame
    dialog:CaptureFocus()
    dialog.FocusLost:Connect(function(enterPressed)
        if enterPressed and dialog.Text ~= "" then
            toggleBang(dialog.Text)
        end
        dialog:Destroy()
    end)
end)

createButton("Speed x2", function() setSpeed(2) end)
createButton("Speed x3", function() setSpeed(3) end)
createButton("Jump x2", function() setJump(2) end)
createButton("Jump x3", function() setJump(3) end)
createButton("Reset Speed", function() setSpeed(1) end)
createButton("Reset Jump", function() setJump(1) end)
createButton("Clear Parts", clearAll)
createButton("Kill All", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    end
    print("[Xeno] All players killed")
end)
createButton("Teleport", function()
    local dialog = Instance.new("TextBox")
    dialog.Size = UDim2.new(0, 200, 0, 30)
    dialog.Position = UDim2.new(0.5, -100, 0.5, -15)
    dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    dialog.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialog.PlaceholderText = "Имя игрока"
    dialog.ClearTextOnFocus = false
    dialog.Parent = MainFrame
    dialog:CaptureFocus()
    dialog.FocusLost:Connect(function(enterPressed)
        if enterPressed and dialog.Text ~= "" then
            teleportToPlayer(dialog.Text)
        end
        dialog:Destroy()
    end)
end)

task.wait(0.1)
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, #allButtons * 46 + 20)

-- ============================================
-- УПРАВЛЕНИЕ
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            updateSearch("")
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
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
    
    state.fly = false
    state.fly2 = false
    state.noclip = false
    state.god = false
    state.spider = false
    state.scaffold = false
    state.bang = false
    
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if fly2Connection then fly2Connection:Disconnect() fly2Connection = nil end
    if noclipPart then noclipPart:Destroy() noclipPart = nil end
    if spiderConnection then spiderConnection:Disconnect() spiderConnection = nil end
    if scaffoldConnection
