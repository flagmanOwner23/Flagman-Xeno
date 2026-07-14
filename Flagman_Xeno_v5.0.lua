-- Flagman Xeno v5.0 (FIXED)
-- Полностью переписан и исправлен
-- Автор: good

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Ожидание загрузки персонажа
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Состояния
local state = {
    fly = false,
    noclip = false,
    god = false,
    spider = false,
    scaffold = false,
    esp = false,
    aimbot = false,
    speed = 1,
    jump = 1,
    flySpeed = 50,
    aimbotFOV = 200
}

-- Переменные для объектов
local bodyVelocity = nil
local bodyGyro = nil
local noclipPart = nil
local spiderConnection = nil
local scaffoldConnection = nil
local espObjects = {}
local espConnections = {}
local binds = {}

-- ============================================
-- СОЗДАНИЕ МЕНЮ (исправленное)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlagmanXenoUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 650)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 25)
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 80)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = false  -- По умолчанию скрыто

-- Размытие (эффект стекла)
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = MainFrame

local function applyBlur(enabled)
    if enabled then
        TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 12}):Play()
    else
        TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
    end
end

-- Заголовок
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 60)
TitleFrame.Position = UDim2.new(0, 0, 0, 0)
TitleFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
TitleFrame.BackgroundTransparency = 0.85
TitleFrame.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 30, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
})
TitleGradient.Parent = TitleFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "✦ FLAGMAN XENO ✦"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = TitleFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 1, -20)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "v5.0 | Xeno | good"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.Parent = TitleFrame

-- Поле поиска
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -20, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 65)
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SearchBox.BackgroundTransparency = 0.5
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "🔍 Поиск функции..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 200)
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextScaled = true
SearchBox.BorderSizePixel = 1
SearchBox.BorderColor3 = Color3.fromRGB(255, 50, 80)
SearchBox.Parent = MainFrame

-- Контейнер для кнопок
local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -20, 1, -120)
ButtonContainer.Position = UDim2.new(0, 10, 0, 105)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.ScrollBarThickness = 8
ButtonContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 80)
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

-- Хранилище всех кнопок для поиска
local allButtons = {}

-- Функция создания кнопки
local function createButton(text, callback, category)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 50, 80)
    btn.Parent = ButtonContainer
    
    -- Эффект свечения
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
    })
    glow.Transparency = NumberSequence.new(1)
    glow.Parent = btn
    
    -- Метка категории
    if category then
        local catLabel = Instance.new("TextLabel")
        catLabel.Size = UDim2.new(0, 60, 1, 0)
        catLabel.Position = UDim2.new(0, 5, 0, 0)
        catLabel.BackgroundTransparency = 1
        catLabel.Text = category
        catLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
        catLabel.TextScaled = true
        catLabel.Font = Enum.Font.GothamBold
        catLabel.TextXAlignment = Enum.TextXAlignment.Left
        catLabel.Parent = btn
    end
    
    -- Анимации при наведении
    btn.MouseEnter:Connect(function()
        TweenService:Create(glow, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new(0.3)
        }):Play()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(glow, TweenInfo.new(0.3), {
            Transparency = NumberSequence.new(1)
        }):Play()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
    
    -- Клик левой кнопкой
    btn.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        }):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 45)
        }):Play()
    end)
    
    -- Клик правой кнопкой (бинды)
    btn.MouseButton2Click:Connect(function()
        local dialog = Instance.new("TextBox")
        dialog.Size = UDim2.new(0, 200, 0, 30)
        dialog.Position = UDim2.new(0.5, -100, 0.5, -15)
        dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        dialog.TextColor3 = Color3.fromRGB(255, 255, 255)
        dialog.PlaceholderText = "Нажмите клавишу..."
        dialog.ClearTextOnFocus = false
        dialog.Parent = MainFrame
        dialog:CaptureFocus()
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                binds[input.KeyCode] = callback
                print("[Xeno] Бинд на " .. input.KeyCode.Name)
                dialog:Destroy()
                connection:Disconnect()
            end
        end)
        
        dialog.FocusLost:Connect(function()
            dialog:Destroy()
            if connection then connection:Disconnect() end
        end)
    end)
    
    table.insert(allButtons, {
        button = btn,
        text = text:lower(),
        category = category or "Основные"
    })
    
    return btn
end

-- Функция поиска
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
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 53 + 20)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateSearch(SearchBox.Text)
end)

-- ============================================
-- ФУНКЦИИ (все исправлены)
-- ============================================

-- FLY
local function toggleFly()
    state.fly = not state.fly
    if state.fly then
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVelocity.Velocity = Vector3.new(0, state.flySpeed, 0)
        bodyVelocity.Parent = RootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 100000
        bodyGyro.CFrame = RootPart.CFrame
        bodyGyro.Parent = RootPart
        print("[Xeno] Fly ON")
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        print("[Xeno] Fly OFF")
    end
end

-- NOCLIP
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
        -- Отключаем коллизии
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        print("[Xeno] Noclip ON")
    else
        if noclipPart then noclipPart:Destroy() noclipPart = nil end
        -- Восстанавливаем коллизии
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        print("[Xeno] Noclip OFF")
    end
end

-- GODMODE
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

-- SPIDER (ИСПРАВЛЕН)
local function toggleSpider()
    state.spider = not state.spider
    
    if state.spider then
        -- Отключаем предыдущее соединение, если есть
        if spiderConnection then
            spiderConnection:Disconnect()
            spiderConnection = nil
        end
        
        -- Создаём новое соединение
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
        -- Отключаем соединение
        if spiderConnection then
            spiderConnection:Disconnect()
            spiderConnection = nil
        end
        Humanoid.WalkSpeed = 16 * state.speed
        print("[Xeno] Spider OFF")
    end
end

-- SCAFFOLD
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

-- SPEED
local function setSpeed(value)
    state.speed = value or 1
    Humanoid.WalkSpeed = 16 * state.speed
    print("[Xeno] Speed: " .. Humanoid.WalkSpeed)
end

-- JUMP
local function setJump(value)
    state.jump = value or 1
    Humanoid.JumpPower = 50 * state.jump
    print("[Xeno] Jump: " .. Humanoid.JumpPower)
end

-- CLEAR PARTS
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

-- TELEPORT
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
        -- Очищаем старые объекты
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
        for _, conn in ipairs(espConnections) do conn:Disconnect() end
        espConnections = {}
        
        -- Создаём ESP для всех игроков
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        -- Следим за новыми игроками
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(0.5)
                if state.esp then createESP(player) end
            end)
        end)
        print("[Xeno] ESP ON")
    else
        -- Отключаем ESP
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

-- Обработка AIMBOT (ПКМ)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if state.aimbot and input.UserInputType == Enum.UserInputType.MouseButton2 then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position + Vector3.new(0, 1.5, 0))
        end
    end
    -- Обработка биндов
    if binds[input.KeyCode] then
        binds[input.KeyCode]()
    end
end)

-- ============================================
-- СОЗДАНИЕ КНОПОК МЕНЮ
-- ============================================
createButton("✈ Fly", toggleFly, "Движение")
createButton("🌀 Noclip", toggleNoclip, "Движение")
createButton("👑 Godmode", toggleGod, "Защита")
createButton("🕷 Spider [X]", toggleSpider, "Движение")
createButton("🏗 Scaffold", toggleScaffold, "Строительство")
createButton("👁 ESP", toggleESP, "Визуал")
createButton("🎯 Aimbot", toggleAimbot, "Визуал")
createButton("⚡ Speed x2", function() setSpeed(2) end, "Настройки")
createButton("⚡ Speed x3", function() setSpeed(3) end, "Настройки")
createButton("🦘 Jump x2", function() setJump(2) end, "Настройки")
createButton("🦘 Jump x3", function() setJump(3) end, "Настройки")
createButton("🔄 Reset Speed", function() setSpeed(1) end, "Настройки")
createButton("🔄 Reset Jump", function() setJump(1) end, "Настройки")
createButton("🧹 Clear", clearAll, "Утилиты")
createButton("💀 Kill All", function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    end
    print("[Xeno] All players killed")
end, "Утилиты")
createButton("📡 TP", function()
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
end, "Утилиты")

-- Обновление размера контейнера
wait(0.1)
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, #allButtons * 53 + 20)

-- ============================================
-- УПРАВЛЕНИЕ (открытие меню и хоткеи)
-- ============================================

-- Открытие по INSERT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            applyBlur(true)
            TweenService:Create(MainFrame, TweenInfo.new(0.4), {
                BackgroundTransparency = 0.05
            }):Play()
            updateSearch("")
        else
            applyBlur(false)
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                BackgroundTransparency = 1
            }):Play()
            wait(0.3)
            MainFrame.Visible = false
        end
    end
end)

-- Хоткей для SPIDER (X) — ИСПРАВЛЕН
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
    
    -- Сбрасываем состояния
    state.fly = false
    state.noclip = false
    state.god = false
    state.spider = false
    state.scaffold = false
    
    -- Удаляем объекты
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if noclipPart then noclipPart:Destroy() noclipPart = nil end
    if spiderConnection then spiderConnection:Disconnect() spiderConnection = nil end
    if scaffoldConnection then scaffoldConnection:Disconnect() scaffoldConnection = nil end
    
    -- Сбрасываем скорость и прыжок
    setSpeed(1)
    setJump(1)
    
    print("[Xeno] Character reset, states cleared")
end)

print("═══════════════════════════════════════")
print("  ✦ FLAGMAN XENO v5.0 (FIXED) ✦")
print("  Нажмите INSERT для открытия меню")
print("  X - Spider (вкл/выкл)")
print("  ПКМ по кнопке - бинд на любую клавишу")
print("═══════════════════════════════════════")
