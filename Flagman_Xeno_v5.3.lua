-- =================== ESP (исправлен баг с удалением) ===================
local espObjects = {}          -- все объекты (BoxHandleAdornment, BillboardGui)
local espConnections = {}       -- все подключения (Health, AncestryChanged, CharacterAdded)
local espActivePlayers = {}     -- список игроков, для которых уже создан ESP (защита от дублей)

local function createESP(player)
    if player == LocalPlayer then return end
    if espActivePlayers[player] then return end -- уже есть ESP для этого игрока
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Блокируем повторное создание
    espActivePlayers[player] = true
    
    -- Box
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(3, 5, 1.5)
    box.Adornee = hrp
    box.Color3 = Color3.fromRGB(255, 50, 80)
    box.Transparency = 0.4
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = hrp
    
    -- Billboard
    local bill = Instance.new("BillboardGui")
    bill.Adornee = hrp
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.StudsOffset = Vector3.new(0, 4, 0)
    bill.AlwaysOnTop = true
    bill.Parent = hrp
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name .. " [100 HP]"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    -- Сохраняем объекты
    table.insert(espObjects, box)
    table.insert(espObjects, bill)
    table.insert(espObjects, label)
    
    -- Функция обновления HP
    local function updateESP()
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Parent then
            local hp = hum.Health
            label.Text = player.Name .. " [" .. math.floor(hp) .. " HP]"
            if hp < 30 then box.Color3 = Color3.fromRGB(255, 0, 0)
            elseif hp < 70 then box.Color3 = Color3.fromRGB(255, 255, 0)
            else box.Color3 = Color3.fromRGB(0, 255, 0) end
        else
            -- Если гуманоид пропал — помечаем как мёртвого
            label.Text = player.Name .. " [DEAD]"
            box.Color3 = Color3.fromRGB(128, 128, 128)
        end
    end
    
    -- Подписка на изменение здоровья
    local hum = char:FindFirstChild("Humanoid")
    local healthConn = nil
    if hum then
        healthConn = hum:GetPropertyChangedSignal("Health"):Connect(updateESP)
        table.insert(espConnections, healthConn)
        updateESP()
    end
    
    -- Отслеживание уничтожения персонажа
    local ancConn = char.AncestryChanged:Connect(function()
        if not char.Parent then
            -- Удаляем объекты этого игрока
            for i = #espObjects, 1, -1 do
                local obj = espObjects[i]
                if obj and (obj == box or obj == bill or obj == label) then
                    obj:Destroy()
                    table.remove(espObjects, i)
                end
            end
            if healthConn then healthConn:Disconnect() end
            ancConn:Disconnect()
            espActivePlayers[player] = nil
        end
    end)
    table.insert(espConnections, ancConn)
    
    -- Отслеживание перерождения персонажа (если игрок переродился — обновляем ESP)
    local charAddedConn = player.CharacterAdded:Connect(function(newChar)
        wait(0.5)
        if state.esp and newChar and newChar:FindFirstChild("HumanoidRootPart") then
            -- Удаляем старый ESP для этого игрока
            for i = #espObjects, 1, -1 do
                local obj = espObjects[i]
                if obj and (obj == box or obj == bill or obj == label) then
                    obj:Destroy()
                    table.remove(espObjects, i)
                end
            end
            espActivePlayers[player] = nil
            -- Создаём заново
            createESP(player)
        end
    end)
    table.insert(espConnections, charAddedConn)
end

local function toggleESP()
    state.esp = not state.esp
    if state.esp then
        -- Включаем ESP
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        -- Подписываемся на новых игроков
        local playerAddedConn = Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(0.5)
                if state.esp then createESP(player) end
            end)
        end)
        table.insert(espConnections, playerAddedConn)
        
        print("[Xeno] ESP ON")
    else
        -- ВЫКЛЮЧАЕМ ESP - ПОЛНАЯ ОЧИСТКА
        -- 1. Удаляем все объекты ESP
        for i = #espObjects, 1, -1 do
            local obj = espObjects[i]
            if obj and obj.Parent then
                obj:Destroy()
            end
            table.remove(espObjects, i)
        end
        
        -- 2. Отключаем все подключения
        for i = #espConnections, 1, -1 do
            local conn = espConnections[i]
            if conn then
                pcall(function() conn:Disconnect() end)
            end
            table.remove(espConnections, i)
        end
        
        -- 3. Очищаем список активных игроков
        espActivePlayers = {}
        
        -- 4. Дополнительная чистка: удаляем все BoxHandleAdornment и BillboardGui, которые могли остаться
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BoxHandleAdornment") or obj:IsA("BillboardGui") then
                if obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent.Parent and obj.Parent.Parent:IsA("Model") then
                    local model = obj.Parent.Parent
                    if model:FindFirstChild("Humanoid") and model ~= Character then
                        obj:Destroy()
                    end
                end
            end
        end
        
        print("[Xeno] ESP OFF - полная очистка выполнена")
    end
end
