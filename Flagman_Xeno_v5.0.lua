local P,U,R,T,C,W,Ca=game:GetService("Players"),game:GetService("UserInputService"),game:GetService("RunService"),game:GetService("TweenService"),game:GetService("CoreGui"),game:GetService("Workspace"),workspace.CurrentCamera
local L,Ch,H,Rt,M=P.LocalPlayer,(P.LocalPlayer.Character or P.LocalPlayer.CharacterAdded:Wait()),nil,nil,L:GetMouse()
Ch=L.Character or L.CharacterAdded:Wait()
H=Ch:WaitForChild("Humanoid")
Rt=Ch:WaitForChild("HumanoidRootPart")
local S={fly=false,noclip=false,god=false,spider=false,scaffold=false,esp=false,aimbot=false,speed=1,jump=1,flySpeed=50,aimbotFOV=200}
local BV,BG,NP,SPC,ScC,EO,EC=nil,nil,nil,nil,nil,{},{}
local B={}
local G=Instance.new("ScreenGui")
G.Name,G.ResetOnSpawn,G.Parent="FlagmanXenoUI",false,C
local M=Instance.new("Frame")
M.Size,M.Position,M.BackgroundColor3,M.BackgroundTransparency,M.BorderSizePixel,M.BorderColor3,M.ClipsDescendants,M.Parent,M.Visible=UDim2.new(0,550,0,650),UDim2.new(0.5,-275,0.5,-325),Color3.fromRGB(12,12,25),0.08,2,Color3.fromRGB(255,50,80),true,G,false
local Bl=Instance.new("BlurEffect")
Bl.Size,Bl.Parent=0,M
local function ab(e)T:Create(Bl,TweenInfo.new(0.5),{Size=e and 12 or 0}):Play()end
local TF=Instance.new("Frame")
TF.Size,TF.Position,TF.BackgroundColor3,TF.BackgroundTransparency,TF.Parent=UDim2.new(1,0,0,60),UDim2.new(0,0,0,0),Color3.fromRGB(255,50,80),0.85,M
local TG=Instance.new("UIGradient")
TG.Color,TG.Parent=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,50,80)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(180,30,150)),ColorSequenceKeypoint.new(1,Color3.fromRGB(50,100,255))}),TF
local Tt=Instance.new("TextLabel")
Tt.Size,Tt.Position,Tt.BackgroundTransparency,Tt.Text,Tt.TextColor3,Tt.TextScaled,Tt.Font,Tt.Parent=UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),1,"✦ FLAGMAN XENO ✦",Color3.fromRGB(255,255,255),true,Enum.Font.GothamBold,TF
local ST=Instance.new("TextLabel")
ST.Size,ST.Position,ST.BackgroundTransparency,ST.Text,ST.TextColor3,ST.TextScaled,ST.Font,ST.Parent=UDim2.new(1,0,0,20),UDim2.new(0,0,1,-20),1,"v5.0 | Xeno | good",Color3.fromRGB(200,200,255),true,Enum.Font.GothamMedium,TF
local SB=Instance.new("TextBox")
SB.Size,SB.Position,SB.BackgroundColor3,SB.BackgroundTransparency,SB.TextColor3,SB.PlaceholderText,SB.PlaceholderColor3,SB.Text,SB.ClearTextOnFocus,SB.Font,SB.TextScaled,SB.BorderSizePixel,SB.BorderColor3,SB.Parent=UDim2.new(1,-20,0,35),UDim2.new(0,10,0,65),Color3.fromRGB(30,30,50),0.5,Color3.fromRGB(255,255,255),"🔍 Поиск...",Color3.fromRGB(150,150,200),"",false,Enum.Font.GothamMedium,true,1,Color3.fromRGB(255,50,80),M
local BC=Instance.new("ScrollingFrame")
BC.Size,BC.Position,BC.BackgroundTransparency,BC.CanvasSize,BC.ScrollBarThickness,BC.ScrollBarImageColor3,BC.Parent=UDim2.new(1,-20,1,-120),UDim2.new(0,10,0,105),1,UDim2.new(0,0,0,0),8,Color3.fromRGB(255,50,80),M
local UIL=Instance.new("UIListLayout")
UIL.Padding,UIL.SortOrder,UIL.Parent=UDim.new(0,8),Enum.SortOrder.LayoutOrder,BC
local AB={}
local function cb(t,cb,ca)
local b=Instance.new("TextButton")
b.Size,b.BackgroundColor3,b.BackgroundTransparency,b.Text,b.TextColor3,b.TextScaled,b.Font,b.BorderSizePixel,b.BorderColor3,b.Parent=UDim2.new(1,0,0,45),Color3.fromRGB(25,25,45),0.3,t,Color3.fromRGB(220,220,255),true,Enum.Font.GothamMedium,1,Color3.fromRGB(255,50,80),BC
local g=Instance.new("UIGradient")
g.Color,g.Transparency,g.Parent=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,50,80)),ColorSequenceKeypoint.new(1,Color3.fromRGB(50,100,255))}),NumberSequence.new(1),b
if ca then local cl=Instance.new("TextLabel")cl.Size,cl.Position,cl.BackgroundTransparency,cl.Text,cl.TextColor3,cl.TextScaled,cl.Font,cl.TextXAlignment,cl.Parent=UDim2.new(0,60,1,0),UDim2.new(0,5,0,0),1,ca,Color3.fromRGB(200,150,255),true,Enum.Font.GothamBold,Enum.TextXAlignment.Left,b end
b.MouseEnter:Connect(function()T:Create(g,TweenInfo.new(0.3),{Transparency=NumberSequence.new(0.3)}):Play()T:Create(b,TweenInfo.new(0.2),{BackgroundTransparency=0.1}):Play()end)
b.MouseLeave:Connect(function()T:Create(g,TweenInfo.new(0.3),{Transparency=NumberSequence.new(1)}):Play()T:Create(b,TweenInfo.new(0.2),{BackgroundTransparency=0.3}):Play()end)
b.MouseButton1Click:Connect(function()cb()T:Create(b,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(100,255,100)}):Play()wait(0.1)T:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(25,25,45)}):Play()end)
b.MouseButton2Click:Connect(function()
local d=Instance.new("TextBox")
d.Size,d.Position,d.BackgroundColor3,d.TextColor3,d.PlaceholderText,d.ClearTextOnFocus,d.Parent=UDim2.new(0,200,0,30),UDim2.new(0.5,-100,0.5,-15),Color3.fromRGB(30,30,50),Color3.fromRGB(255,255,255),"Нажмите клавишу...",false,M
d:CaptureFocus()
local co
co=U.InputBegan:Connect(function(inp,gp)if gp then return end if inp.KeyCode~=Enum.KeyCode.Unknown then B[inp.KeyCode]=cb print("[Xeno] Бинд на "..inp.KeyCode.Name)d:Destroy()co:Disconnect()end end)
d.FocusLost:Connect(function()d:Destroy()if co then co:Disconnect()end end)
end)
table.insert(AB,{button=b,text=t:lower(),category=ca or "Основные"})
return b
end
local function us(q)
q=q:lower()
local vc=0
for _,d in ipairs(AB)do if q==""or d.text:find(q,1,true)then d.button.Visible=true vc=vc+1 else d.button.Visible=false end end
BC.CanvasSize=UDim2.new(0,0,0,vc*53+20)
end
SB:GetPropertyChangedSignal("Text"):Connect(function()us(SB.Text)end)
local function tFly()S.fly=not S.fly if S.fly then if BV then BV:Destroy()end if BG then BG:Destroy()end BV=Instance.new("BodyVelocity")BV.MaxForce,BV.Velocity,BV.Parent=Vector3.new(1,1,1)*100000,Vector3.new(0,S.flySpeed,0),Rt BG=Instance.new("BodyGyro")BG.MaxTorque,BG.CFrame,BG.Parent=Vector3.new(1,1,1)*100000,Rt.CFrame,Rt else if BV then BV:Destroy()BV=nil end if BG then BG:Destroy()BG=nil end end end
local function tNoclip()S.noclip=not S.noclip if S.noclip then if not NP then NP=Instance.new("Part")NP.CanCollide,NP.Transparency,NP.Size,NP.Anchored,NP.Parent=false,1,Vector3.new(5,5,5),true,W end R.Heartbeat:Connect(function()if S.noclip and Rt and Rt.Parent then NP.Position=Rt.Position for _,p in ipairs(Ch:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end end end)else if NP then NP:Destroy()NP=nil end for _,p in ipairs(Ch:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=true end end end end
local function tGod()S.god=not S.god if S.god then H.MaxHealth,H.Health,H.BreakJointsOnDeath=math.huge,math.huge,false H:GetPropertyChangedSignal("Health"):Connect(function()if S.god and H.Health<=0 then H.Health=H.MaxHealth end end)else H.MaxHealth,H.Health,H.BreakJointsOnDeath=100,100,true end end
local function tSpider()S.spider=not S.spider if S.spider then if SPC then SPC:Disconnect()end SPC=R.Heartbeat:Connect(function()if S.spider and Rt and Rt.Parent and H then local r=Ray.new(Rt.Position,Rt.CFrame.LookVector*3)local h=W:FindPartOnRay(r,Ch)if h then H.WalkSpeed=20 Rt.Velocity=Rt.Velocity+Vector3.new(0,-2,0)Rt.CFrame=Rt.CFrame+Rt.CFrame.LookVector*1.5 end end end)else if SPC then SPC:Disconnect()SPC=nil end H.WalkSpeed=16*S.speed end end
local function tScaffold()S.scaffold=not S.scaffold if S.scaffold then if ScC then ScC:Disconnect()end ScC=R.Heartbeat:Connect(function()if S.scaffold and Rt and Rt.Parent then local p=Rt.Position local b=p-Vector3.new(0,2.5,0)local r=Ray.new(b,Vector3.new(0,-0.5,0))local h=W:FindPartOnRay(r,Ch)if not h then local bl=Instance.new("Part")bl.Size,bl.Position,bl.Anchored,bl.BrickColor,bl.Material,bl.Parent=Vector3.new(2,0.5,2),b+Vector3.new(0,-0.25,0),true,BrickColor.new("Bright red"),Enum.Material.SmoothPlastic,W game:GetService("Debris"):AddItem(bl,5)end end end)else if ScC then ScC:Disconnect()ScC=nil end end end
local function sS(v)S.speed=v H.WalkSpeed=16*v end
local function sJ(v)S.jump=v H.JumpPower=50*v end
local function cA()for _,p in ipairs(W:GetDescendants())do if p:IsA("BasePart")and p~=Rt and p.Parent~=Ch and not p:IsA("Terrain")then p:Destroy()end end end
local function tTP(n)if not n or n==""then return end for _,p in ipairs(P:GetPlayers())do if p.Name:lower():find(n:lower())then local c=p.Character if c and c:FindFirstChild("HumanoidRootPart")then Rt.CFrame=c.HumanoidRootPart.CFrame+Vector3.new(0,3,0)return end end end end
local function cESP(p)
if p==L then return end
local c=p.Character if not c then return end
local hrp=c:FindFirstChild("HumanoidRootPart")if not hrp then return end
local box=Instance.new("BoxHandleAdornment")
box.Size,box.Adornee,box.Color3,box.Transparency,box.AlwaysOnTop,box.ZIndex,box.Parent=Vector3.new(3,5,1.5),hrp,Color3.fromRGB(255,50,80),0.4,true,10,hrp
local bb=Instance.new("BillboardGui")
bb.Adornee,bb.Size,bb.StudsOffset,bb.AlwaysOnTop,bb.Parent=hrp,UDim2.new(0,200,0,50),Vector3.new(0,4,0),true,hrp
local nl=Instance.new("TextLabel")
nl.Size,nl.BackgroundTransparency,nl.Text,nl.TextColor3,nl.TextScaled,nl.Font,nl.Parent=UDim2.new(1,0,1,0),1,p.Name.." ["..math.floor((c.Humanoid and c.Humanoid.Health or 0)).." HP]",Color3.fromRGB(255,255,255),true,Enum.Font.GothamBold,bb
table.insert(EO,box)table.insert(EO,bb)
if c:FindFirstChild("Humanoid")then
local co=c.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
local h=c.Humanoid.Health
nl.Text=p.Name.." ["..math.floor(h).." HP]"
box.Color3=h<30 and Color3.fromRGB(255,0,0)or h<70 and Color3.fromRGB(255,255,0)or Color3.fromRGB(0,255,0)
end)
table.insert(EC,co)
end
end
local function tESP()
S.esp=not S.esp
if S.esp then
for _,o in ipairs(EO)do o:Destroy()end EO={}
for _,c in ipairs(EC)do c:Disconnect()end EC={}
for _,p in ipairs(P:GetPlayers())do cESP(p)end
P.PlayerAdded:Connect(function(p)p.CharacterAdded:Connect(function()wait(0.5)if S.esp then cESP(p)end end)end)
else for _,o in ipairs(EO)do o:Destroy()end EO={}for _,c in ipairs(EC)do c:Disconnect()end EC={}end
end
local function gCP()
local cl,cd=nil,S.aimbotFOV
for _,p in ipairs(P:GetPlayers())do
if p~=L then
local c=p.Character
if c and c:FindFirstChild("HumanoidRootPart")then
local hrp=c.HumanoidRootPart
local sp,os=Ca:WorldToScreenPoint(hrp.Position)
if os then
local d=(Vector2.new(Mouse.X,Mouse.Y)-Vector2.new(sp.X,sp.Y)).magnitude
if d<cd then cd=d cl=hrp end
end
end
end
end
return cl
end
local function tAimbot()S.aimbot=not S.aimbot end
U.InputBegan:Connect(function(i,gp)if gp then return end if S.aimbot and i.UserInputType==Enum.UserInputType.MouseButton2 then local t=gCP()if t then Ca.CFrame=CFrame.new(Ca.CFrame.Position,t.Position+Vector3.new(0,1.5,0))end end if B[i.KeyCode]then B[i.KeyCode]()end end)
cb("✈ Fly",tFly,"Движение")
cb("🌀 Noclip",tNoclip,"Движение")
cb("👑 Godmode",tGod,"Защита")
cb("🕷 Spider [X]",tSpider,"Движение")
cb("🏗 Scaffold",tScaffold,"Строительство")
cb("👁 ESP",tESP,"Визуал")
cb("🎯 Aimbot",tAimbot,"Визуал")
cb("⚡ Speed x2",function()sS(2)end,"Настройки")
cb("⚡ Speed x3",function()sS(3)end,"Настройки")
cb("🦘 Jump x2",function()sJ(2)end,"Настройки")
cb("🦘 Jump x3",function()sJ(3)end,"Настройки")
cb("🔄 Reset Speed",function()sS(1)end,"Настройки")
cb("🔄 Reset Jump",function()sJ(1)end,"Настройки")
cb("🧹 Clear",cA,"Утилиты")
cb("💀 Kill All",function()for _,p in ipairs(P:GetPlayers())do if p~=L then local c=p.Character if c and c:FindFirstChild("Humanoid")then c.Humanoid.Health=0 end end end end,"Утилиты")
cb("📡 TP",function()
local d=Instance.new("TextBox")
d.Size,d.Position,d.BackgroundColor3,d.TextColor3,d.PlaceholderText,d.ClearTextOnFocus,d.Parent=UDim2.new(0,200,0,30),UDim2.new(0.5,-100,0.5,-15),Color3.fromRGB(30,30,50),Color3.fromRGB(255,255,255),"Имя игрока",false,M
d:CaptureFocus()
d.FocusLost:Connect(function(ep)if ep and d.Text~=""then tTP(d.Text)end d:Destroy()end)
end,"Утилиты")
wait(0.1)BC.CanvasSize=UDim2.new(0,0,0,#AB*53+20)
U.InputBegan:Connect(function(i,gp)if gp then return end if i.KeyCode==Enum.KeyCode.Insert then M.Visible=not M.Visible if M.Visible then ab(true)T:Create(M,TweenInfo.new(0.4),{BackgroundTransparency=0.05}):Play()us("")else ab(false)T:Create(M,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()wait(0.3)M.Visible=false end end end)
U.InputBegan:Connect(function(i,gp)if gp then return end if i.KeyCode==Enum.KeyCode.X then tSpider()end end)
L.CharacterAdded:Connect(function(nc)
Ch=nc H=Ch:WaitForChild("Humanoid")Rt=Ch:WaitForChild("HumanoidRootPart")
S.fly,S.noclip,S.god,S.spider,S.scaffold=false,false,false,false,false
if BV then BV:Destroy()BV=nil end
if BG then BG:Destroy()BG=nil end
if NP then NP:Destroy()NP=nil end
if SPC then SPC:Disconnect()SPC=nil end
if ScC then ScC:Disconnect()ScC=nil end
sS(1)sJ(1)
end)
print("═══ FLAGMAN XENO v5.0 ═══\nINSERT - меню\nX - Spider\nПКМ по кнопке - бинд")
