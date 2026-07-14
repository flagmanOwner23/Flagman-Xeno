-- Flagman Xeno v4.0
-- Полная совместимость с Xeno
-- Автор: good
-- GitHub Ready

local Xeno = {}
if getgenv and getgenv().Xeno then
    Xeno = getgenv().Xeno
else
    Xeno = {
        Library = {
            CreateWindow = function(title, config)
                return {
                    CreateTab = function(name, icon)
                        return {
                            CreateSection = function(name) return {} end,
                            CreateButton = function(name, callback) 
                                return { OnClick = callback, Set = function() end }
                            end,
                            CreateToggle = function(name, default, callback) 
                                return { Set = function(val) callback(val) end }
                            end,
                            CreateSlider = function(name, min, max, default, callback)
                                return { Set = function(val) callback(val) end }
                            end,
                            CreateDropdown = function(name, options, default, callback)
                                return { Set = function(val) callback(val) end }
                            end,
                            CreateTextbox = function(name, default, callback)
                                return { Set = function(val) callback(val) end }
                            end
                        }
                    end
                }
            end
        }
    }
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = LocalPlayer:GetMouse()

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
    aimbotFOV = 200,
    aimbotSmoothness = 0.3
}

local bodyVelocity = nil
local bodyGyro = nil
local noclipPart = nil
local spiderConnection = nil
local scaffoldConnection = nil
local espObjects = {}
local espConnections = {}
local aimbotTarget = nil

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
MainFrame.Visible = false

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = MainFrame

local function applyBlur(enabled)
    if enabled then
        TweenService:Create(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = 12}):Play()
    else
        TweenService:Create(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = 0}):Play()
    end
end

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
Title.Position = UDim2.new(0, 0, 0, 0)
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
SubTitle.Text = "v4.0 | Xeno Ready | good"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.Parent = TitleFrame

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

local allButtons = {}

local function createStyledButton(text, callback, category)
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
    
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
    })
    glow.Transparency = NumberSequence.new(1)
    glow.Parent = btn
    
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
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(glow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Transparency = NumberSequence.new(0.3)
        }):Play()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(glow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Transparency = NumberSequence.new(1)
        }):Play()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        }):Play()
        wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 45)
        }):Play()
    end)
    
    table.insert(allButtons, {
        button = btn,
        text = text:lower(),
        category = category or "Основные"
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
    ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 53 + 20)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateSearch(SearchBox.Text)
end)

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
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    end
end

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
        RunService.Heartbeat:Connect(function()
            if state.noclip and RootPart and RootPart.Parent then
                noclipPart.Position = RootPart.Position
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipPart then noclipPart:Destroy() noclipPart = nil end
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function toggleGod()
    state.god = not state.god
    if state.god then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.BreakJointsOnDeath = false
        Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if state.god and Humanoid.Health <= 0 then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
        Humanoid.BreakJointsOnDeath = true
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
    else
        if spiderConnection then spiderConnection:Disconnect() spiderConnection = nil end
        Humanoid.WalkSpeed = 16 * state.speed
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
                    Debris:AddItem(block, 5)
                end
            end
        end)
    else
        if scaffoldConnection then scaffoldConnection:Disconnect() scaffoldConnection = nil end
    end
end

local function setSpeed(val)
    state.speed = val
    Humanoid.WalkSpeed = 16 * val
end

local function setJump(val)
    state.jump = val
    Humanoid.JumpPower = 50 * val
end

local function clearAll()
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part ~= RootPart and part.Parent ~= Character then
            if not part:IsA("Terrain") then
                part:Destroy()
            end
        end
    end
end

local function teleportToPlayer(targetName)
    if not targetName or targetName == "" then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) then
            local targetChar = plr.Character
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                RootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                return
            end
        end
    end
end

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
        
        for _, plr in ipairs(Players:GetPlayers()) do
            createESP(plr)
        end
        
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                wait(0.5)
                if state.esp then createESP(plr) end
            end)
        end)
    else
        for _, obj in ipairs(espObjects) do obj:Destroy() end
        espObjects = {}
        for _, conn in ipairs(espConnections) do conn:Disconnect() end
        espConnections = {}
    end
end

local function getClosestPlayer()
    local closest, closestDist = nil, state.aimbotFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
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
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if state.aimbot and input.UserInputType == Enum.UserInputType.MouseButton2 then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position + Vector3.new(0, 1.5, 0))
        end
    end
end)

createStyledButton("✈ Fly (F)", toggleFly, "Движение")
createStyledButton("🌀 Noclip (N)", toggleNoclip, "Движение")
createStyledButton("👑 Godmode (G)", toggleGod, "Защита")
createStyledButton("🕷 Spider (S)", toggleSpider, "Движение")
createStyledButton("🏗 Scaffold (B)", toggleScaffold, "Строительство")
createStyledButton("👁 ESP (E)", toggleESP, "Визуал")
createStyledButton("🎯 Aimbot (A)", toggleAimbot, "Визуал")
createStyledButton("⚡ Speed x2", function() setSpeed(2) end, "Настройки")
createStyledButton("⚡ Speed x3", function() setSpeed(3) end, "Настройки")
createStyledButton("🦘 Jump x2", function() setJump(2) end, "Настройки")
createStyledButton("🦘 Jump x3", function() setJump(3) end, "Настройки")
createStyledButton("🔄 Reset Speed", function() setSpeed(1) end, "Настройки")
createStyledButton("🔄 Reset Jump", function() setJump(1) end, "Настройки")
createStyledButton("🧹 Clear Parts (C)", clearAll, "Утилиты")
createStyledButton("💀 Kill All (K)", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.Health = 0
            end
        end
    end
end, "Утилиты")
createStyledButton("📡 TP to Player (T)", function()
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

wait(0.1)
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, #allButtons * 53 + 20)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            applyBlur(true)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0.05
            }):Play()
            updateSearch("")
        else
            applyBlur(false)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
            wait(0.3)
            MainFrame.Visible = false
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then toggleFly() end
    if input.KeyCode == Enum.KeyCode.N then toggleNoclip() end
    if input.KeyCode == Enum.KeyCode.G then toggleGod() end
    if input.KeyCode == Enum.KeyCode.S then toggleSpider() end
    if input.KeyCode == Enum.KeyCode.B then toggleScaffold() end
    if input.KeyCode == Enum.KeyCode.E then toggleESP() end
    if input.KeyCode == Enum.KeyCode.A then toggleAimbot() end
    if input.KeyCode == Enum.KeyCode.C then clearAll() end
    if input.KeyCode == Enum.KeyCode.K then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Health = 0
                end
            end
        end
    end
    if input.KeyCode == Enum.KeyCode.T then
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
    end
end)

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
    if noclipPart then noclipPart:Destroy() noclipPart = nil end
    if spiderConnection then spiderConnection:Disconnect() spiderConnection = nil end
    if scaffoldConnection then scaffoldConnection:Disconnect() scaffoldConnection = nil end
    setSpeed(1)
    setJump(1)
end)

print("═══════════════════════════════════════")
print("  ✦ FLAGMAN XENO v4.0 ЗАГРУЖЕН ✦")
print("  Полная совместимость с Xeno")
print("  Нажмите INSERT для открытия меню")
print("  Хоткеи: F N G S B E A C K T")
print("═══════════════════════════════════════")
