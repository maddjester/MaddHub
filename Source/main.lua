-- MaddHub.lua
local Svc={Ws=game:GetService("Workspace"),Light=game:GetService("Lighting"),RepStor=game:GetService("ReplicatedStorage"),Plrs=game:GetService("Players"),MrkPlc=game:GetService("MarketplaceService"),VirtUsr=game:GetService("VirtualUser"),UsrInp=game:GetService("UserInputService"),RunSvc=game:GetService("RunService"),Core=game:GetService("CoreGui"),Vim=game:GetService("VirtualInputManager"),Tween=game:GetService("TweenService")}local Lp=Svc.Plrs.LocalPlayer;local Chr=Lp.Character;local Hum=Chr:WaitForChild("Humanoid")local HumRP=Chr:WaitForChild("HumanoidRootPart")local function false_if_dev()local devIds={4342810381,4320929007}local result=true;for _,devId in pairs(devIds)do if Lp.UserId==devId then result=false end end;return result end
if not false_if_dev() then loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end
local Icons={Intro="rbxassetid://14282025997",Character="rbxassetid://7992557358",Controller="rbxassetid://1557343445",Gear="rbxassetid://11385265073",Players="rbxassetid://11577689639",Money="rbxassetid://7939405279",Boss="rbxassetid://10653372143",Pet="rbxassetid://13001190533",Egg="rbxassetid://7939410236",Dojo="rbxassetid://11183649951",Runner="rbxassetid://9525535512",Inventory="rbxassetid://12166530009",Keyboard="rbxassetid://11738672671",Teleport="rbxassetid://6723742952",Quest="rbxassetid://12905962634",Server="rbxassetid://9692125126",Upgrade="rbxassetid://12338897538",Arm="rbxassetid://13769779209"}
local CustomTheme={Main=Color3.fromRGB(0,0,0),Second=Color3.fromRGB(25,25,25),Stroke=Color3.fromRGB(60,140,255),Divider=Color3.fromRGB(0,150,225),Text=Color3.fromRGB(255,255,255),TextDark=Color3.fromRGB(60,140,255)}local Lib={Orion=loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))(),Esp=loadstring(game:HttpGet('https://sirius.menu/rayfield'))}local Gui={Settings={Name=Svc.MrkPlc:GetProductInfo(game.PlaceId).Name.." | MaddHub",HidePremium=false,SaveConfig=false_if_dev(),IntroEnabled=false_if_dev(),IntroIcon=Icons.Intro,IntroText="maddhub.webador.com",ConfigFolder="MaddHub_"..Lp.Name}}local Window=Lib.Orion:MakeWindow(Gui.Settings)Lib.Orion.Themes["Custom"],Lib.Orion.SelectedTheme=CustomTheme,"Custom"

local function alert(name, msg, dur)
    Lib.Orion:MakeNotification({
        Name = name,
        Content = msg,
        Image = "rbxassetid://7634887649",
        Time = dur
    })
end

local function sendMessage(Message, Recipients)
	local r = Svc.RepStor.DefaultChatSystemChatEvents.SayMessageRequest
    if r then
        local args = {
           Message,
           Recipients,
        }
        r:FireServer(unpack(args))
    end
end

local function serverHop()
    local module = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()
    if game and module then
        task.spawn(function()
            module:Teleport(game.PlaceId)
        end)
    end
end

local function clickTp(Bind)
    local Mouse = Lp:GetMouse()
    Mouse.Button1Down:Connect(function()
        if not game:GetService("UserInputService"):IsKeyDown(Bind) then return end
        if Mouse.Target then
            Chr:MoveTo(Mouse.Hit.p)
        end
    end)
end

local function noClip()
    task.spawn(function()
        while task.wait() do
            repeat task.wait() until Chr
            if getgenv().NOCLIP then
                for _, v in pairs(Chr:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            else
                for _, v in pairs(Chr:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                break   
            end
        end
    end)
end

local function getPlayerNames()
    local results = {}
    for _, v in pairs(Svc.Plrs:GetPlayers()) do
        if v.Name ~= Lp.Name then
            table.insert(results, v.Name)
        end
    end
    return results
end

local function sort_alphabetical(a, b)
    return a:lower() < b:lower()
end

local function addBinds(Binds, tabName)
    for _, v in next, Binds do
        tabName:AddBind({
            Name = v.Name,
            Default = v.Default,
            Hold = v.Hold,
            Callback = v.Callback
        })
    end
end

local function expandHb(char)
    if char then
        local part = char:FindFirstChild("HumanoidRootPart")
        if part then
            pcall(function()
                part.Size = Vector3.new(getgenv().HitSize, getgenv().HitSize, getgenv().HitSize)
                part.Transparency = getgenv().HitTrans
                part.BrickColor = BrickColor.new(getgenv().HitColor)
                part.Material = "Neon"
                part.CanCollide = false
            end)
        end
    end
end

local function expandHbs()
    for _, v in ipairs(Svc.Plrs:GetPlayers()) do
        if v.Character and v.Name ~= Lp.Name then
            expandHb(v.Character)
        end
    end
    Svc.Plrs.PlayerAdded:Connect(function(plr)
        if getgenv().EXPANDHB and plr.Name ~= Lp.Name then
            plr.CharacterAdded:Connect(function(chr)
                expandHb(chr)
            end)
        end
    end)
end

local function autoTp()
    local plr = Svc.Ws:FindFirstChild(getgenv().PLAYER)
    if plr then
        local hrp = plr:FindFirstChild("HumanoidRootPart")
        task.spawn(function()
            while task.wait() do
                repeat task.wait(0.5) until hrp
                if not getgenv().TP then break end
                if Chr and hrp then
                    local r = math.random(-2, 2)
                    Chr:PivotTo(hrp:GetPivot() + Vector3.new(r,0,r))
                end
            end
        end)
    end
end

local function diedTP()
    local pos = CFrame.new()
    local stationaryrespawn = false; local needsrespawning = false; local haspos = false

    Svc.RunSvc.Stepped:Connect(function()
        if getgenv().DIEDTP then
            if stationaryrespawn == true and Hum.Health == 0 then
                if haspos == false then
                    pos = HumRP.CFrame
                    haspos = true
                end
                needsrespawning = true
            end
            if needsrespawning == true then
                HumRP.CFrame = pos
            end
        end
    end)

    Lp.CharacterAdded:Connect(function()
        if getgenv().DIEDTP then
            task.wait(0.6)
            needsrespawning = false
            haspos = false
        end
    end)
end

local function fullBright()
    loadstring(game:HttpGet("https://pastebin.com/raw/06iG6YkU"))()
end

local function getState(b)
    local r
    if b then
        r = "Activated."
    else
        r = "Deactivated."
    end
    return r
end

if not assert(fireproximityprompt, "Your exploit does not support fireproximityprompt.") then
	local function fireproximityprompt(Obj, Amount, Skip)
	    if Obj.ClassName == "ProximityPrompt" then 
	        Amount = Amount or 1
	        local PromptTime = Obj.HoldDuration
	        if Skip then 
	            Obj.HoldDuration = 0
	        end
	        for i = 1, Amount do 
	            Obj:InputHoldBegin()
	            if not Skip then 
	                wait(Obj.HoldDuration)
	            end
	            Obj:InputHoldEnd()
	        end
	        Obj.HoldDuration = PromptTime
	    else 
	        error("userdata<ProximityPrompt> expected")
	    end
	end
end

local function fireRedeem(Event, Codes)
    for _, v in pairs(Codes) do
        pcall(function()
            Event:FireServer(v)
            Event:InvokeServer(v)
        end)
        task.wait(3)
    end
    print("Codes Redeemed:",unpack(Codes))
end

local function invisMe()
    for _, v in pairs(Chr:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Hat") then
            if getgenv().INVIS then
                v:Destroy()
            end
        end
        if v:IsA("Part") or v:IsA("MeshPart") then
            if getgenv().INVIS then
                v.Transparency = 1
                if v.Name == "Head" then
                    if v:FindFirstChild("face") then
                        v.face:Destroy()
                    end
                end
            else
                if v.Transparency == 1 and v.Name ~= HumRP.Name then
                    v.Transparency = 0
                end
            end
        end
    end
end

local function loopInvis()
    task.spawn(function()
        while task.wait() do
            if not getgenv().LOOPINVIS then break end
            invisMe()
        end
    end)
end

local function pressKey(key)
    Svc.Vim:SendKeyEvent(true, key, false, game)
end

local function releaseKey(key)
    Svc.Vim:SendKeyEvent(false, key, false, game)
end

local function loopSpeed()
    if Hum.WalkSpeed < getgenv().SPEED then
        Hum.WalkSpeed = getgenv().SPEED
    end
end

local function randString()
    local n = {}
    for i = 1, 2 do
        local randuppercase = string.char(math.random(65, 65 + 25))
        local randlowercase = string.char(math.random(65, 65 + 25)):lower()
        table.insert(n, randuppercase)
        table.insert(n, randlowercase)
    end
    return table.concat(n)
end

local function walkToPart(part, speaker)
	if Lp.Character:FindFirstChildOfClass('Humanoid') and Lp.Character:FindFirstChildOfClass('Humanoid').SeatPart then
		speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
		wait(.1)
	end
	Lp.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = part.Position
end

local function walkToPos(pos)
	if Lp.Character:FindFirstChildOfClass('Humanoid') and Lp.Character:FindFirstChildOfClass('Humanoid').SeatPart then
		speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
		wait(.1)
	end
	Lp.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = pos
end


getgenv().makeHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/maddjester/MaddHub/main/MaddHub.lua'))

repeat task.wait(1) until Svc.Ws.Gravity
local gravReset, swimbeat
local oldgrav = Svc.Ws.Gravity
getgenv().SWIMMING = false

local function swim()
    if not getgenv().SWIMMING and Chr and Hum then
        oldgrav = Svc.Ws.Gravity
        Svc.Ws.Gravity = 0
        local swimDied = function()
            Svc.Ws.Gravity = oldgrav
            getgenv().SWIMMING = false
        end
        gravReset = Hum.Died:Connect(swimDied)
        local enums = Enum.HumanoidStateType:GetEnumItems()
        table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
        for i, v in pairs(enums) do
            Hum:SetStateEnabled(v, false)
        end
        Hum:ChangeState(Enum.HumanoidStateType.Swimming)
        swimbeat = Svc.RunSvc.Heartbeat:Connect(function()
            pcall(function()
                HumRP.Velocity = ((Hum.MoveDirection ~= Vector3.new() or Svc.UsrInp:IsKeyDown(Enum.KeyCode.Space)) and HumRP.Velocity or Vector3.new())
            end)
        end)
        getgenv().SWIMMING = true
    end
end

local function unswim()
    if Chr and Hum then
        Svc.Ws.Gravity = oldgrav
        getgenv().SWIMMING = false
        if gravReset then
            gravReset:Disconnect()
        end
        if swimbeat ~= nil then
            swimbeat:Disconnect()
            swimbeat = nil
        end
        local enums = Enum.HumanoidStateType:GetEnumItems()
        table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
        for i, v in pairs(enums) do
            Hum:SetStateEnabled(v, true)
        end
    end
end

local function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

local function breakVelocity()
    local BeenASecond, V3 = false, Vector3.new(0, 0, 0)
	delay(1, function()
		BeenASecond = true
	end)
	while not BeenASecond do
		for _, v in ipairs(Chr:GetDescendants()) do
			if v.IsA(v, "BasePart") then
				v.Velocity, v.RotVelocity = V3, V3
			end
		end
		wait()
	end
end

local function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

local function breakVelocity()
    local BeenASecond, V3 = false, Vector3.new(0, 0, 0)
	delay(1, function()
		BeenASecond = true
	end)
	while not BeenASecond do
		for _, v in ipairs(Chr:GetDescendants()) do
			if v.IsA(v, "BasePart") then
				v.Velocity, v.RotVelocity = V3, V3
			end
		end
		wait()
	end
end

local function tweenTo(v3, tweenSpeed, speaker)
	local char = speaker.Character
	if char and getRoot(char) then
		local Tween = Svc.Tween:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(v3)}):Play()
    end
end

local function clickAbs(Button)
    mousemoveabs(Button.AbsolutePosition.X + Button.AbsoluteSize.X / 2, Button.AbsolutePosition.Y + 50)
    Svc.Vim:SendMouseButtonEvent(Button.AbsolutePosition.X + Button.AbsoluteSize.X / 2, Button.AbsolutePosition.Y + 50, 0, true, Button, 1)
    task.wait()
    Svc.Vim:SendMouseButtonEvent(Button.AbsolutePosition.X + Button.AbsoluteSize.X / 2, Button.AbsolutePosition.Y + 50, 0, false, Button, 1)
end

local Binds, Codes = {}, {}

Binds[1] = {
    Name = "No Clipping",
    Default = Enum.KeyCode.F1,
    Hold = false,
    Callback = function()
        getgenv().NOCLIP = not getgenv().NOCLIP
        alert(Binds[1].Name, getState(getgenv().NOCLIP))
        noClip()
    end
}

Binds[2] = {
    Name = "Died Teleport",
    Default = Enum.KeyCode.F2,
    Hold = false,
    Callback = function()
        getgenv().DIEDTP = not getgenv().DIEDTP
        alert(Binds[2].Name, getState(getgenv().DIEDTP))
        diedTP()
    end
}

Binds[3] = {
    Name = "Fullbright",
    Default = Enum.KeyCode.F3,
    Hold = false,
    Callback = function()
        getgenv().FullBrightEnabled = not getgenv().FullBrightEnabled
        alert(Binds[3].Name, getState(getgenv().DIEDTP))
        fullBright()
    end
}

Binds[4] = {
    Name = "Server Hop",
    Default = Enum.KeyCode.F4,
    Hold = false,
    Callback = function()
        alert(Svc.MrkPlc:GetProductInfo(game.PlaceId).Name, "Hopping to a new server...")
        serverHop()
    end
}

Binds[5] = {
    Name = "Reload GUI",
    Default = Enum.KeyCode.F5,
    Hold = false,
    Callback = function()
        getgenv().makeHub()
    end
}

Binds[8] = {
    Name = "Destroy MaddHub",
    Default = Enum.KeyCode.F8,
    Hold = false,
    Callback = function()
        if Lib.Esp then
            Lib.Esp:Unload()
        end
        Lib.Orion:Destroy()
    end
}

Binds[9] = {
    Name = "Key bind + Click to Teleport",
    Default = Enum.KeyCode.LeftControl,
    Hold = false,
    Callback = function()
        clickTp(Enum.KeyCode.LeftControl)
    end
}


local CharTab = Window:MakeTab({
    Name = "Character",
    Icon = Icons.Character,
    PremiumOnly = false
})

local ViewSect = CharTab:AddSection({
	Name = "Camera Settings"
})

ViewSect:AddSlider({
    Name = "Field Of View",
    Min = 60,
    Max = 120,
    Default = Svc.Ws.Camera.FieldOfView or 60,
    Save = true,
    Flag = "FOV",
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "",
    Callback = function(Value)
        Svc.Ws.Camera.FieldOfView = Value
    end
})

ViewSect:AddToggle({
    Name = "Third Person Camera Mode",
    Default = Lp.CameraMode,
    Save = true,
    Flag = "CAM",
    Callback = function(Value)
        if Value then
            Lp.CameraMode = "Classic"
            Lp.CameraMinZoomDistance = 0
            Lp.CameraMaxZoomDistance = 1000
        else
            Lp.CameraMode = "LockFirstPerson"
        end
    end
})

local ChrSect = CharTab:AddSection({
	Name = "Character Properties"
})

ChrSect:AddButton({
    Name = "Randomize Display Name",
    Callback = function()
        local names = {"Bob","Kevin","Ron","Alice","Eve","Charlie","David","Becky","Sue","Jeremy","Chris","Natalia"}
        local name = names[math.random(#names)]..randString().."_"..tostring(math.floor(os.time()/math.random(10, 400)))
        game:GetService("Players").LocalPlayer.DisplayName = name
        game:GetService("Players").LocalPlayer:WaitForChild("Character"):FindFirstChild("Humanoid").DisplayName = name
    end
})

ChrSect:AddLabel("Movement")

repeat task.wait(1) until Hum.WalkSpeed
ChrSect:AddSlider({
    Name = "Walk Speed",
    Min = 1,
    Max = 500,
    Default = Hum.WalkSpeed,
    Save = true,
    Flag = "WALK",
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "",
    Callback = function(Value)
        if Value ~= Hum.WalkSpeed then
            getgenv().SPEED = Value
            Hum:GetPropertyChangedSignal("WalkSpeed"):Connect(loopSpeed)
        end
    end
})

ChrSect:AddSlider({
    Name = "Jump Power",
    Min = 1,
    Max = 500,
    Default = Hum.JumpPower or 50,
    Save = true,
    Flag = "JUMP",
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "",
    Callback = function(Value)
        local loopJump = task.spawn(function()
            while task.wait() do
                if Hum.JumpPower ~= getgenv().POWER then
                    Hum.JumpPower = getgenv().POWER
                end
            end
        end)
        getgenv().POWER = Value
    end
})

ChrSect:AddLabel("Visibility")

local invisToggle = ChrSect:AddToggle({
    Name = "Invisibility",
    Default = false,
    Save = true,
    Flag = "INVIS",
    Callback = function(Value)
        getgenv().INVIS = Value
        invisMe()
    end
})

local loopInvisToggle = ChrSect:AddToggle({
    Name = "Loop Invisibility",
    Default = false,
    Save = true,
    Flag = "LOOPINVIS",
    Callback = function(Value)
        getgenv().LOOPINVIS = Value
        if Value then
            if Chr then
                loopInvis()
            end
        end
    end
})

local PlayersTab = Window:MakeTab({
    Name = "Players",
    Icon = Icons.Players,
    PremiumOnly = false
})

local TeleportSect = PlayersTab:AddSection({
	Name = "Teleports"
})

TeleportSect:AddDropdown({
    Name = "Teleport to Player",
    Default = Lp.Name,
    Options = getPlayerNames(),
    Callback = function(Value)
        local looping = getgenv().TP
        getgenv().LoopToggle:Set(false)
        getgenv().PLAYER = Value
        getgenv().LoopToggle:Set(looping)
        local tarChr = Svc.Ws:FindFirstChild(getgenv().PLAYER)
        if Chr and tarChr then
            HumRP:PivotTo(tarChr:GetPivot() + Vector3.new(0,5,-3))
        end
    end
})

getgenv().LoopToggle = TeleportSect:AddToggle({
    Name = "Loop Teleport to Player",
    Default = false,
    Save = true,
    Flag = "TP",
    Callback = function(Value)
        getgenv().TP = Value
        if Value then
            if Chr then
                autoTp()
            end
        end
    end
})

local ESPSect = PlayersTab:AddSection({
	Name = "ESP/Chams/Nametags/Healthbars"
})

ESPSect:AddButton({
    Name = "Sense ESP",
    Callback = function()
        Lib.Esp()
    end
})

local HitSect = PlayersTab:AddSection({
	Name = "Hitbox Expander"
})

HitSect:AddButton({
    Name = "Expand Hitboxes",
    Callback = function()
        getgenv().EXPANDHB = not getgenv().EXPANDHB
        expandHbs()
    end
})

HitSect:AddSlider({
    Name = "Size",
    Min = 0,
    Max = 500,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Studs",
    Callback = function(Value)
        getgenv().HitSize = Value
        if getgenv().EXPANDHB then
            expandHbs()
        end
    end
})

HitSect:AddColorpicker({
	Name = "Color",
	Default = Color3.fromRGB(0, 0, 220),
    Save = true,
    Flag = "HBCOLOR",
	Callback = function(Value)
		getgenv().HitColor = Color3.new(Value)
        if getgenv().EXPANDHB then
            expandHbs()
        end
	end
})

HitSect:AddSlider({
    Name = "Transparency",
    Min = 0,
    Max = 100,
    Default = 70,
    Save = true,
    Flag = "HBTRANS",
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Percent",
    Callback = function(Value)
        getgenv().HitTrans = Value / 100
        if getgenv().EXPANDHB then
            expandHbs()
        end
    end
})

Lp.Idled:Connect(function()
    Svc.VirtUsr:Button2Down(Vector2.new(0, 0), Svc.Ws.CurrentCamera.CFrame)
    task.wait(1)
    Svc.VirtUsr:Button2Up(Vector2.new(0, 0), Svc.Ws.CurrentCamera.CFrame)
    alert("Anti-Idle", "Prevented Idle.", 5)
end)

if not assert(firesignal, "Your exploit does not support firesignal.") then
    Svc.UsrInp.WindowFocusReleased:Connect(function()
        Svc.RunSvc.Stepped:Wait()
        pcall(firesignal, Svc.UsrInp.WindowFocused)
    end)
end

local GameTab = Window:MakeTab({
    Name = "Game",
    Icon = Icons.Controller,
    PremiumOnly = false
})

local GuiSect = GameTab:AddSection({
    Name = "Roblox GUI"
})

GuiSect:AddToggle({
    Name = "Disable Robux Purchase Prompts",
    Default = false,
    Save = true,
    Flag = "PURCHASEPROMPT",
    Callback = function(Value)
        Svc.Core.PurchasePrompt.Enabled = not Value
    end
})

if game.PlaceId == 3956818381 then -- Ninja Legends
    -- Values

    Codes = {
        Remote = Svc.RepStor.rEvents.codeRemote,
        List = {
            "soulninja1000",
            "epictrain15",
            "roboninja15",
            "christmasninja500",
            "zenmaster15k",
            "innerpeace5k",
            "skyblades10k",
            "darkelements2000",
            "silentshadows1000",
            "omegasecrets5000",
            "ultrasecrets10k",
            "elementmaster750",
            "secretcrystal1000",
            "skymaster750",
            "legends700m",
            "dojomasters500",
            "dragonlegend750",
            "zenmaster500",
            "epicelements500",
            "goldninja500",
            "goldupdate500",
            "legends500M",
            "senseisanta500",
            "blizzardninja500",
            "mythicalninja500",
            "legendaryninja500",
            "shadowninja500",
            "legends200M",
            "epicflyingninja500",
            "flyingninja500",
            "dragonwarrior500",
            "swiftblade300",
            "DesertNinja250",
            "fastninja100",
            "epicninja250",
            "masterninja750",
            "sparkninja20",
            "soulhunter5",
        }
    }

    -- Functions

    local function autoBlade()
        local Backpack = Lp.Backpack
        task.spawn(function()
            while task.wait() do
                if not getgenv().EQUIPSWORD then break end;
                pcall(function()
                    Hum:UnequipTools()
                    for _, v in pairs(Backpack:GetDescendants()) do
                        if v.Name == "attackKatanaScript" then
                            local tool = v.Parent
                            Hum:EquipTool(tool)
                            task.wait(10)
                            break
                        end
                    end
                end)
            end
        end)
    end

    local function swing()
        local A_1 = "swingKatana"
        local Event = Lp.ninjaEvent
        Event:FireServer(A_1)
    end

    local function autoSwing()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SWING then break end;
                swing()
                task.wait(0.2)
            end
        end)
    end

    local function sell()
        local sellArea = Svc.Ws.sellAreaCircles.sellAreaCircle16.circleInner
        if not HumRP then
            repeat task.wait(1) until HumRP
        end
        firetouchinterest(HumRP, sellArea, 0)
        task.wait(0.2)
        firetouchinterest(HumRP, sellArea, 1)
    end

    local function autoSell()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SELL then break end;
                sell()
                task.wait(0.5)
            end
        end)
    end

    local function autoBoss(name)
        local bossFolder = Svc.Ws.bossFolder
        task.spawn(function()
            while task.wait() do
                if not getgenv().AUTOBOSS then break end
                if Chr and bossFolder:FindFirstChild(name) then
                    Chr:PivotTo(bossFolder:FindFirstChild(name):FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0,12,0))
                end
            end
        end)
    end

    local function dailyChests()
        local k = Lp.Karma
        local ignoreChest
        if k.Value < 0 then
            ignoreChest = "lightKarmaChest"
        else
            ignoreChest = "evilKarmaChest"
        end
        for _, v in pairs(Svc.Ws:GetDescendants()) do
            if not getgenv().CHESTS then break end;
            if v.Name == "Chest" and v.Parent.Name ~= ignoreChest then
                if not HumRP then
                    repeat task.wait(1) until HumRP
                end
                firetouchinterest(HumRP, v.Parent.circleInner, 0)
                task.wait(0.5)
                firetouchinterest(HumRP, v.Parent.circleInner, 1)
                task.wait(3)
            end
        end
    end

    local function autoChests()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CHESTS then break end;
                dailyChests()
                task.wait(60)
            end
        end)
    end

    local function autoEvolve()
        task.spawn(function()
            while task.wait() do
                if not getgenv().EVOLVE then break end;
                local A_1 = "autoEvolvePets"
                local Event = Svc.RepStor.rEvents.autoEvolveRemote
                Event:InvokeServer(A_1)
                task.wait(1)
            end
        end)
    end

    local function sellPet(pet)
        local A_1 = "sellPet"
        local Event = Svc.RepStor.rEvents.sellPetEvent
        Event:FireServer(A_1, pet)
    end

    local function getTypes()
        local t = {}
        for _, v in ipairs(Lp.petsFolder:GetChildren()) do
            local c = v:GetChildren()
            if #c > 0 then
                table.insert(t, v)
            end
        end
        return t
    end

    local function getCrystalNames()
        local CrystalsFolder = Svc.Ws.mapCrystalsFolder
        local t = {}
        for _, v in pairs(CrystalsFolder:GetChildren()) do
            table.insert(t, v.Name)
        end
        return t
    end

    local function petCount()
        local petsLabel = Lp.PlayerGui.gameGui.petsMenu.petInfoMenu.petsLabel.Text
        local l = string.gsub(petsLabel, "Pets: ", "")
        local s = string.gsub(l, "/"," ")
        local t = {}
        for i in string.gmatch(s, "%S+") do
            table.insert(t, i)
        end
        return t
    end

    local function returnEvolved()
        local petsFrames = Lp.PlayerGui.gameGui.petsMenu.petsFrames
        local e = {}
        for _, f in pairs(petsFrames:GetChildren()) do
            for i, v in pairs(f:GetDescendants()) do
                if v.ClassName == "TextButton" then
                    for _, l in pairs(v.evolutionLabels:GetChildren()) do
                        if l.Visible then
                            table.insert(e, v)
                        end
                    end
                end
            end
        end
        return e
    end

    local function checkPets()
        repeat task.wait(1) until Lp.PlayerGui;
        local unequipAllButton = Lp.PlayerGui.gameGui.petsMenu.bottomPetMenu.unequipAllButton
        local equipButton = Lp.PlayerGui.gameGui.petsMenu.sidePetMenu.equipButton
        local tot = petCount()[1] == petCount()[2]
        if not tot then
            firesignal(unequipAllButton.Activated)
            task.wait(3)
            local pets = returnEvolved()
            for _, p in pairs(pets) do
                pcall(function()
                    firesignal(p.Activated)
                    task.wait(1)
                    firesignal(equipButton.Activated)
                    task.wait(1)
                end)
            end
        end
    end

    local function autoEquip()
        task.spawn(function()
            while task.wait() do
                if not getgenv().EQUIP then break end;
                checkPets()
                task.wait(5)
            end
        end)
    end

    local function sellAll()
        local t = getTypes()
        for i, v in pairs(t) do
            if i == #t then break end;
            if i == #t - 1 then break end;
            task.spawn(function()
                for _, p in ipairs(v:GetChildren()) do
                    sellPet(p)
                    task.wait(1)
                end
            end)
        end
    end

    local function autoSellPets()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SELLPETS then break end;
                sellAll()
                task.wait(5)
            end
        end)
    end

    local function autoCrates()
        local Valley = Svc.Ws.spawnedCoins.Valley
        task.spawn(function()
            while task.wait() do
                for _, v in pairs(Valley:GetChildren()) do
                    if not getgenv().CRATES then break end
                    if #v:GetChildren() > 0 and HumRP and v.Position then
                        Chr:MoveTo(v.Position + Vector3.new(0, 3, 0))
                        task.wait(2)
                    end
                end
            end
        end)
    end

    local function buyRank(rank)
        local A_1 = "buyRank"
        local Event = Lp.ninjaEvent
        Event:FireServer(A_1, rank)
    end

    local function autoRank()
        local Ranks = Svc.RepStor.Ranks
        task.spawn(function()
            while task.wait() do
                if not getgenv().RANKS then break end;
                for _, v in pairs(Ranks.Ground:GetChildren()) do
                    if not getgenv().RANKS then break end;
                    buyRank(v.Name)
                    task.wait(0.2)
                end
            end
        end)
    end

    local function goInvisible()
        local A_1 = "goInvisible"
        local Event = Lp.ninjaEvent
        Event:FireServer(A_1)
    end

    local function autoInvisibility()
        task.spawn(function()
            while task.wait() do
                if not getgenv().INVISIBILITY then break end;
                goInvisible()
                task.wait(1)
            end
        end)
    end

    local function hoop(h)
        local A_1 = "useHoop"
        local Event = Svc.RepStor.rEvents.hoopEvent
        Event:FireServer(A_1, h)
    end

    local function getHoops()
        local Hoops = Svc.Ws.Hoops
        for _, v in pairs(Hoops:GetChildren()) do
            hoop(v)
        end
    end

    local function autoHoops()
        task.spawn(function()
            while task.wait() do
                if not getgenv().HOOPS then break end;
                getHoops()
                task.wait(8)
            end
        end)
    end

    local function getIslandNames()
        local islandUnlockParts = Svc.Ws.islandUnlockParts
        local t = {}
        for _, v in pairs(islandUnlockParts:GetChildren()) do
            table.insert(t, v.Name)
        end
        return t
    end

    local function getIslandCFrames()
        local islandUnlockParts = Svc.Ws.islandUnlockParts
        local t = {}
        for _, v in pairs(islandUnlockParts:GetChildren()) do
            table.insert(t, v.islandSignPart.CFrame)
        end
        return t
    end

    local function unlockIslands()
        local a = getIslandCFrames()
        repeat task.wait(1) until HumRP
        task.spawn(function()
            for _, v in pairs(a) do
                Chr:SetPrimaryPartCFrame(v + Vector3.new(0,-10,0))
                task.wait(0.75)
            end
        end)
    end

    local function buy(i)
        local items = {
            [1] = "buyAllSwords",
            [2] = "buyAllBelts",
            [3] = "buyAllSkills",
            [4] = "buyAllShurikens"
        }
        local foundIslands = Lp.foundIslands
        local A_1 = items[i]
        local A_2 = "Blazing Vortex Island"
        local Event = Lp.ninjaEvent
        Event:FireServer(A_1, A_2)
    end

    local function autoDojo()
        local c = Svc.Ws.dojoCircles.dojoCollectCircle.circleInner
        task.spawn(function()
            while task.wait() do
                if not getgenv().DOJO then break end;
                if not HumRP then
                    repeat task.wait(1) until HumRP
                end
                firetouchinterest(HumRP, c, 0)
                task.wait(0.1)
                firetouchinterest(HumRP, c, 1)
                task.wait(1)
            end
        end)
    end

    local function autoSword()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SWORD then break end;
                buy(1)
                task.wait(1)
            end
        end)
    end

    local function autoBelt()
        task.spawn(function()
            while task.wait() do
                if not getgenv().BELT then break end;
                buy(2)
                task.wait(1)
            end
        end)
    end

    local function autoSkill()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SKILLS then break end
                buy(3)
                task.wait(1)
            end
        end)
    end

    local function autoShuriken()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SHURIKEN then break end;
                buy(4)
                task.wait(1)
            end
        end)
    end

    local function openCrystal(name)
        local A_1 = "openCrystal"
        local Event = Svc.RepStor.rEvents.openCrystalRemote
        Event:InvokeServer(A_1, name)
    end

    local function autoCrystals(name)
        repeat task.wait(1) until getgenv().CRYSTAL
        task.spawn(function()
            while task.wait() do
                if not getgenv().CRYSTALS then break end;
                openCrystal(name)
                task.wait(2)
            end
        end)
    end

    local function upgradeDojo(num)
        local item = {
            [1] = "Ninja Training",
            [2] = "Sensei Training",
            [3] = "Dojo Capacity"
        }
        local A_1 = "upgradeTrainer"
        local Event = Svc.RepStor.rEvents.upgradeDojoTrainerRemote
        Event:InvokeServer(A_1, item[num])
    end

    local function autoNinja(num)
        task.spawn(function()
            while task.wait() do
                if not getgenv().NINJA then break end;
                upgradeDojo(num)
                task.wait(5)
            end
        end)
    end

    local function autoSensei(num)
        task.spawn(function()
            while task.wait() do
                if not getgenv().SENSEI then break end;
                upgradeDojo(num)
                task.wait(5)
            end
        end)
    end

    local function autoCapacity(num)
        task.spawn(function()
            while task.wait() do
                if not getgenv().CAPACITY then break end;
                upgradeDojo(num)
                task.wait(5)
            end
        end)
    end

    local function rankBoost()
        local name = "Ultra Genesis Shadow"
        local ownedRanks = Lp.ownedRanks
        local Ground = Svc.RepStor.Ranks.Ground
        for _, v in pairs(Ground:GetChildren()) do
            local rank = Instance.new("BoolValue")
            rank.Name = v.Name
            rank.Parent = ownedRanks
            if v.Name == name then
                Lp.equippedRank.Value = v
                break
            end
        end
    end

    -- Tabs

    GameTab:AddToggle({
        Name = "Auto Invisibility",
        Default = false,
        Save = true,
        Flag = "INVISIBILITY",
        Callback = function(Value)
            getgenv().INVISIBILITY = Value
            if Value then
                autoInvisibility()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Auto Equip Sword",
        Default = false,
        Save = true,
        Flag = "EQUIPSWORD",
        Callback = function(Value)
            getgenv().EQUIPSWORD = Value
            if Value then
                autoBlade()
            end
        end
    })

    GameTab:AddButton({
        Name = "Rank Boost",
        Callback = function()
            rankBoost()
        end
    })

    TeleportSect:AddLabel("Island Teleports")

    TeleportSect:AddButton({
        Name = "Unlock All Islands",
        Callback = function()
            unlockIslands()
        end
    })

    TeleportSect:AddDropdown({
        Name = "Teleport to Island",
        Default = "",
        Options = getIslandNames(),
        Callback = function(Value)
            local islandUnlockParts = Svc.Ws.islandUnlockParts
            HumRP.CFrame = islandUnlockParts[Value].islandSignPart.CFrame
        end
    })

    local FarmTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    FarmTab:AddToggle({
        Name = "Swing Sword",
        Default = false,
        Save = true,
        Flag = "SWING",
        Callback = function(Value)
            getgenv().SWING = Value
            if Value then
                autoSwing()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Sell Ninjitsu",
        Default = false,
        Save = true,
        Flag = "SELL",
        Callback = function(Value)
            getgenv().SELL = Value
            if Value then
                autoSell()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Collect Hoops",
        Default = false,
        Save = true,
        Flag = "HOOPS",
        Callback = function(Value)
            getgenv().HOOPS = Value
            if Value then
                autoHoops()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Collect Chests",
        Default = false,
        Save = true,
        Flag = "CHESTS",
        Callback = function(Value)
            getgenv().CHESTS = Value
            if Value then
                autoChests()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Collect Coins & Chi Spawns",
        Default = false,
        Save = true,
        Flag = "CRATES",
        Callback = function(Value)
            getgenv().CRATES = Value
            if Value then
                autoCrates()
            end
        end
    })

    local BuyTab = Window:MakeTab({
        Name = "Auto Buy",
        Icon = Icons.Money,
        PremiumOnly = false
    })

    BuyTab:AddToggle({
        Name = "Buy Swords",
        Default = false,
        Save = true,
        Flag = "SWORD",
        Callback = function(Value)
            getgenv().SWORD = Value
            if Value then
                autoSword()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Buy Belts",
        Default = false,
        Save = true,
        Flag = "BELT",
        Callback = function(Value)
            getgenv().BELT = Value
            if Value then
                autoBelt()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Buy Ranks",
        Default = false,
        Save = true,
        Flag = "RANKS",
        Callback = function(Value)
            getgenv().RANKS = Value
            if Value then
                autoRank()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Buy Skills",
        Default = false,
        Save = true,
        Flag = "SKILLS",
        Callback = function(Value)
            getgenv().SKILLS = Value
            if Value then
                autoSkill()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Buy Shurikens",
        Default = false,
        Save = true,
        Flag = "SHURIKEN",
        Callback = function(Value)
            getgenv().SHURIKEN = Value
            if Value then
                autoShuriken()
            end
        end
    })

    local BossTab = Window:MakeTab({
        Name = "Boss",
        Icon = Icons.Boss,
        PremiumOnly = false
    })

    BossTab:AddDropdown({
        Name = "Boss Type",
        Default = "RobotBoss",
        Save = true,
        Flag = "BOSS",
        Options = {"RobotBoss", "EternalBoss", "AncientMagmaBoss"},
        Callback = function(Value)
            getgenv().BOSS = Value
        end
    })

    BossTab:AddToggle({
        Name = "Kill Boss",
        Default = false,
        Save = true,
        Flag = "AUTOBOSS",
        Callback = function(Value)
            getgenv().AUTOBOSS = Value
            if Value and getgenv().BOSS then
                autoBoss(getgenv().BOSS)
            end
        end
    })

    local PetsTab = Window:MakeTab({
        Name = "Pets",
        Icon = Icons.Pet,
        PremiumOnly = false
    })

    PetsTab:AddDropdown({
        Name = "Select a Crystal",
        Default = "",
        Save = true,
        Flag = "CRYSTAL",
        Options = getCrystalNames(),
        Callback = function(Value)
            getgenv().CRYSTAL = Value
            if Value then
                autoCrystals(Value)
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Buy Pets",
        Default = false,
        Save = true,
        Flag = "CRYSTALS",
        Callback = function(Value)
            getgenv().CRYSTALS = Value
            if Value then
                autoCrystals(getgenv().CRYSTAL)
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Equip Best Pets",
        Default = false,
        Save = true,
        Flag = "EQUIP",
        Callback = function(Value)
            getgenv().EQUIP = Value
            if Value then
                autoEquip()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Evolve Pets",
        Default = false,
        Save = true,
        Flag = "EVOLVE",
        Callback = function(Value)
            getgenv().EVOLVE = Value
            if Value then
                autoEvolve()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Sell Old Pets",
        Default = false,
        Save = true,
        Flag = "SELLPETS",
        Callback = function(Value)
            getgenv().SELLPETS = Value
            if Value then
                autoSellPets()
            end
        end
    })

    local DojoTab = Window:MakeTab({
        Name = "Auto Dojo",
        Icon = Icons.Dojo,
        PremiumOnly = false
    })

    DojoTab:AddToggle({
        Name = "Auto Collect Ninjitsu",
        Default = false,
        Save = true,
        Flag = "DOJO",
        Callback = function(Value)
            getgenv().DOJO = Value
            if Value then
                autoDojo()
            end
        end
    })

    DojoTab:AddToggle({
        Name = "Auto Upgrade Ninja",
        Default = false,
        Save = true,
        Flag = "NINJA",
        Callback = function(Value)
            getgenv().NINJA = Value
            if Value then
                autoNinja(1)
            end
        end
    })

    DojoTab:AddToggle({
        Name = "Auto Upgrade Sensei",
        Default = false,
        Save = true,
        Flag = "SENSEI",
        Callback = function(Value)
            getgenv().SENSEI = Value
            if Value then
                autoSensei(2)
            end
        end
    })

    DojoTab:AddToggle({
        Name = "Auto Upgrade Capacity",
        Default = false,
        Save = true,
        Flag = "CAPACITY",
        Callback = function(Value)
            getgenv().CAPACITY = Value
            if Value then
                autoCapacity(3)
            end
        end
    })

    GameTab:AddButton({
        Name = "Toggle Collection Effects",
        Callback = function()
            Lp.PlayerGui.statEffectsGui.Enabled = not Lp.PlayerGui.statEffectsGui.Enabled
        end
    })

elseif game.PlaceId == 8884433153 then -- Collect All Pets

    -- Values

    Codes = {
        Remote = Svc.RepStor.Remotes.RedeemCode,
        List = {
            "ItsAlwaysADesert",
            "Mountaineer",
            "SticksAndStonesAndLevers",
            "ThingsThatHaveWaves",
            "ArcticMoon",
            "ConcaveForward",
            "StrobeLight",
            "FourCrystals",
            "TooMuchBalanceChanges",
            "OverEasy",
            "FiveNewCodes",
            "Stadium",
            "Electromagnetism",
            "Ocean",
            "NotEnoughDrops",
            "ToPointOh",
            "Buttertom_1m",
            "FromTheMachine",
            "Amebas ",
            "MrPocket ",
            "FusionIndy ",
            "LookOut ",
            "Sub2PHMittens ",
            "Chocolatemilk ",
            "Meerkat ",
            "CommonLoon ",
            "Unihorns ",
            "Viper_Toffi ",
            "CrazyDiamond ",
            "eaglenight222 ",
            "GenAutoCalc ",
            "Plasmatic_void",
            "Metallic",
            "OneOutOfEight",
            "MusketeersAndAmigos",
            "OneZero",
            "AndIThinkToMyself",
            "SeasonsAndAMovie",
            "LookOut",
            "InfiniteLoop",
            "BurgersAndFries",
            "ProsperousGrounds",
            "Mountin",
            "DuneBuggy ",
            "FFR",
            "FinalForm ",
            "Shinier",
            "Massproduction",
            "GlitteringGold",
            "FastTyper",
            "ItsTheGrotto",
            "shipwrecked",
            "NewCode",
            "ItsAChicken",
            "SpeedPlayzTree",
            "ImFlying",
            "WhoLetTheDogsOut",
            "ItsAlwaysADesert",
            "DuelingDragons",
            "FewAndFarBetween",
            "KlausWasHere",
            "ShinyHunting",
            "TooManyDrops",
            "TheGreatCodeInTheSky",
            "PillarsOfCreation",
            "TreeSauce",
            "TillFjalls",
            "Orion",
            "HorseWithNoName",
            "IfYouAintFirst",
            "MemoryLeak",
            "SecretCodeWasHere",
            "Taikatalvi",
            "Brrrrr",
            "Click",
            "4815162342",
            "Erdentempel",
            "FirstCodeEver",
            "Groupie"
        }
    }

    local ScreenGui = Lp.PlayerGui.ScreenGui
    local Pets = ScreenGui.Main.Pets
    local container = Pets.PetsContainer.ScrollingFrame
    local fuseBtn = Pets.FuseFrame.FuseButton
    local FuseFrame = Pets.FuseFrame
    local fuseTab = Pets.FuseButton
    local Areas = Svc.Ws.Areas:GetChildren()
    local areas = { "Meadow", "Forest", "Desert", "Arctic", "Beach", "Mountains", "Jungle", "Grotto", "Grove", "Main" }
    local filterList = Pets.FilterFrame.Inset.List
    local petsBtn = Lp.PlayerGui.ScreenGui.Main.Bottom.PetsButton
    local fuseLabel = Pets.FuseFrame.FuseButton.FuseLabel

    -- Functions

    local function getRarity()
        local CheckList = Lp.PlayerGui.ScreenGui.Main.Left.Checklist
        local t
        for _, v in ipairs(CheckList:GetDescendants()) do
            if v.Name == "Checkmark" then
                if not v.Check.Visible then
                    t = v.Parent.RarityLabel.Text
                    break
                end
            end
        end
        return t
    end

    local function buySlot(area)
        local Event = Svc.RepStor.Remotes.BuyPetEquipSlot
        Event:FireServer(area)
    end

    local function autoSlots()
        while task.wait() do
            if not getgenv().SLOTS then break end;
            for i = 1, 5 do
                buySlot(i)
            end
            task.wait(10)
        end
    end

    local function buyEgg(name)
        local eggs = {
            ["Common"] = 1,
            ["Uncommon"] = 2,
            ["Rare"] = 3,
            ["Epic"] = 4,
            ["Legendary"] = 5,
            ["Prodigious"] = 6
        }
        local Event = Svc.RepStor.Remotes.BuyEgg
        Event:FireServer(eggs[name])
    end

    local function fireRebirth()
        local Event = Svc.RepStor.UI.Remotes.OnRebirth
        Event:FireServer()
    end

    local function autoDiscover()
        while task.wait(1) do
            if not getgenv().DISCOVER then break end
            local r = getRarity()
            if r then
                if r == "Ascended" or r == "Mythical" then
                    buyEgg("Prodigious")
                else
                    buyEgg(r)
                end
                task.wait(1)
            else
                if getgenv().REBIRTH then
                    fireRebirth()
                end
            end
        end
    end

    local function shuffleObjs(t)
        local shuffled = {}
        for _, v in ipairs(t) do
            local pos = math.random(1, #shuffled+1)
            table.insert(shuffled, pos, v)
        end
        return shuffled
    end

    local function removeBarriers(bool)
        local AreaBarriers = Svc.Ws.AreaBarriers
        if bool then
            i = 1
        else
            i = 0
        end
        for _, v in pairs(AreaBarriers:GetDescendants()) do
            if v.Name == "Part" or v.Name == "Wall" then
                if bool then
                    v.Transparency = 1
                end
                v.CanCollide = not bool
            end
        end
    end

    local function clickSlots()
        local modifier = {
            "PetSlot_1",
            "PetSlot_2",
            "PetSlot_3",
            "PetSlot_4",
            "PetSlot_5",
        }
        for i = 1, #modifier do
            local slot = Lp.PlayerGui.ScreenGui.Main.Pets.FuseFrame[modifier[i]]
            pcall(function()
                firesignal(slot.Button.Activated)
                task.wait(0.1)
            end)
        end
    end

    local function fusePets()
        local filters = {}
        for _, f in pairs(filterList:GetChildren()) do
            if f.Name ~= "Equipped" and f.ClassName == "ImageButton" then
                table.insert(filters, f)
            end
        end

        while task.wait() do
            if not getgenv().FUSE then break end;
            for _, f in pairs(filters) do
                if not getgenv().FUSE then break end;
                pcall(function()
                    firesignal(f.Activated)
                    task.wait(0.1)
                end)
                if not FuseFrame.Visible then
                    pcall(function()
                        firesignal(fuseTab.Activated)
                        task.wait(0.1)
                    end)
                end
                if Pets and not Pets.Visible then
                    pcall(function()
                        firesignal(petsBtn.Activated)
                        task.wait(0.1)
                    end)
                end
                clickSlots()
                local pets = shuffleObjs(container:GetChildren())
                for _, v in ipairs(pets) do
                    if not getgenv().FUSE then break end;
                    if fuseLabel.Text == "Fuse" then break end;
                    if v.ClassName == "TextButton" then
                        pcall(function()
                            firesignal(v.Activated)
                            task.wait(0.1)
                        end)
                    end
                end
                task.wait(2)
                if fuseLabel.Text == "Fuse" then
                    firesignal(fuseBtn.Activated)
                else
                    clickSlots()
                end
            end
            task.wait(1)
        end
    end

    local function claimReward()
        Svc.RepStor:WaitForChild("Remotes"):WaitForChild("ClaimQuestReward"):FireServer()
    end

    local function claimDailyEgg()
        local Event = Svc.RepStor.Remotes.ClaimDailyEgg
        task.spawn(function()
            while task.wait(60) do
                if not getgenv().DAILY then break end
                Event:FireServer()
            end
        end)
    end

    local function collectHiddenEggs()
        local Eggs = Svc.Ws.HiddenEggs
        for _, v in pairs(Eggs:GetChildren()) do
            if v.Area.Value <= Lp.UnlockedArea.Value then
                firetouchinterest(v, HumRP, 0)
                task.wait(0.3)
                firetouchinterest(v, HumRP, 1)
            end
            task.wait(1)
        end
    end

    local function alwaysEquipBest()
        task.spawn(function()
            while task.wait() do
                if not getgenv().EQUIPBEST then break end
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EquipBest"):FireServer()
                task.wait(20)
            end
        end)
    end

    local function getSuperArea()
        local result
        local Super = Svc.Ws.Crystals:FindFirstChild("Super")
        if #Super:GetChildren() > 0 then
            for _, v in pairs(Super:GetChildren()) do
                if v.Active.Value then
                    if v.Area.Value <= Lp.UnlockedArea.Value then
                        result = v.Area.Value
                    end
                end
            end
        end
        return result
    end

    local function autoQuest()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().QUEST then break end
                if Hum.Sit then Hum.Sit = not Hum.Sit end
                local targetArea = Lp.QuestArea.Value
                if targetArea == 0 then targetArea = 1 end
                local areaName = "Area"..targetArea

                if getgenv().SUPER and getSuperArea() then
                    targetArea = getSuperArea()
                end
                if Lp.Area.Value ~= targetArea then
                    local targetCf = Svc.Ws.Areas[areaName].CFrame + Vector3.new(0, 6, 0)
                    if targetCf and HumRP.CFrame ~= targetCf then
                        HumRP.CFrame = targetCf
                        task.wait(10)
                    end
                else
                    if getgenv().EXOTIC then
                        for _, v in pairs(Svc.Ws.Crystals[areaName]:GetChildren()) do
                            if v.ClassName == "Model" then
                                HumRP.CFrame = v:FindFirstChild("Base").CFrame + Vector3.new(0, 6, 0)
                                task.wait(5)
                            end
                        end
                    end
                    claimReward()
                end
            end
        end)
    end

    local function tpTo(areaIndex)
        local areaPart
        if areaIndex == 10 then
            areaPart = Svc.Ws.Areas:FindFirstChild("Main")
        else
            areaPart = Svc.Ws.Areas:FindFirstChild("Area"..areaIndex)
        end
        if areaPart then
            alert("Teleport", areaPart.Name)
            Chr:MoveTo(areaPart.Position)
        end
    end

    local function getEggNames()
        local Eggs = Svc.RepStor.Eggs
        local t = {}
        for _, v in pairs(Eggs:GetChildren()) do
            if v.Name ~= "Ascended" then
                table.insert(t, v.Name)
            end
        end
        return t
    end

    local function getBadges(bool)
        local cDestroyed = Lp.Badge_CrystalsDestroyed
        local goldGamePass = Lp.HasGoldGamePass
        local hasFuseAllGamePass = Lp.HasFuseAllGamePass
        local autoCalcify = Lp.AutoCalcify
        local HasPetEquipGamePass = Lp.HasPetEquipGamePass
        local AutoFuse = Lp.AutoFuse
        local AutoEquip = Lp.AutoEquip
        local InRebirthArea = Lp.InRebirthArea

        goldGamePass.Value = bool
        hasFuseAllGamePass.Value = bool
        autoCalcify.Value = bool
        HasPetEquipGamePass.Value = bool
        AutoFuse.Value = bool
        AutoEquip.Value = bool
        InRebirthArea.Value = bool
        local oldVal = cDestroyed.Value
        if bool then
            if cDestroyed.Value < 9e9 then
                cDestroyed.Value = 9e9
            end
        else
            cDestroyed.Value = oldVal
        end
    end

    -- Tabs

    GameTab:AddToggle({
        Name = "Give Badges",
        Default = false,
        Save = true,
        Flag = "BADGES",
        Callback = function(Value)
            getBadges(Value)
        end
    })

    GameTab:AddToggle({
        Name = "Remove Barriers",
        Default = false,
        Save = true,
        Flag = "BARRIERS",
        Callback = function(Value)
            removeBarriers(Value)
        end
    })

    TeleportSect:AddLabel("Area Teleports")

    TeleportSect:AddDropdown({
        Name = "Teleport to Area",
        Default = "",
        Options = areas,
        Callback = function(Value)
            local areaIndex = table.find(areas, Value)
            if areaIndex then
                tpTo(areaIndex)
            end
        end
    })

    local QuestTab = Window:MakeTab({
        Name = "Questing",
        Icon = Icons.Quest,
        PremiumOnly = false
    })

    QuestTab:AddToggle({
        Name = "Auto Quest",
        Default = false,
        Save = true,
        Flag = "QUEST",
        Callback = function(Value)
            getgenv().QUEST = Value
            if Value then
                autoQuest()
            end
        end
    })

    QuestTab:AddToggle({
        Name = "Move to Super Crystal",
        Default = false,
        Save = true,
        Flag = "SUPER",
        Callback = function(Value)
            getgenv().SUPER = Value
        end
    })

    QuestTab:AddToggle({
        Name = "Move to Exotic Crystals",
        Default = false,
        Save = true,
        Flag = "EXOTIC",
        Callback = function(Value)
            getgenv().EXOTIC = Value
        end
    })

    QuestTab:AddToggle({
        Name = "Auto Rebirth",
        Default = false,
        Save = true,
        Flag = "REBIRTH",
        Callback = function(Value)
            getgenv().REBIRTH = Value
        end
    })

    local PetsTab = Window:MakeTab({
        Name = "Pets",
        Icon = Icons.Pet,
        PremiumOnly = false
    })

    PetsTab:AddToggle({
        Name = "Always Equip Best Pets",
        Default = false,
        Save = true,
        Flag = "ALWAYSEQUIPBEST",
        Callback = function(Value)
            getgenv().EQUIPBEST = Value
            if Value then
                alwaysEquipBest()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Auto Buy Pet Slots",
        Default = false,
        Save = true,
        Flag = "SLOTS",
        Callback = function(Value)
            getgenv().SLOTS = Value
            if Value then
                task.spawn(function()
                    autoSlots()
                end)
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Auto Fuse Pets",
        Default = false,
        Save = true,
        Flag = "FUSE",
        Callback = function(Value)
            getgenv().FUSE = Value
            if Value then
                task.spawn(function()
                    fusePets()
                end)
            end
        end
    })

    local EggsTab = Window:MakeTab({
        Name = "Eggs",
        Icon = Icons.Egg,
        PremiumOnly = false
    })

    EggsTab:AddToggle({
        Name = "Auto Claim Daily Egg",
        Default = false,
        Save = true,
        Flag = "DAILY",
        Callback = function(Value)
            getgenv().DAILY = Value
            if Value then
                claimDailyEgg()
            end
        end
    })

    EggsTab:AddToggle({
        Name = "Auto Buy Missing Eggs",
        Default = false,
        Save = true,
        Flag = "DISCOVER",
        Callback = function(Value)
            getgenv().DISCOVER = Value
            if Value then
                task.spawn(function()
                    autoDiscover()
                end)
            end
        end
    })

    EggsTab:AddButton({
        Name = "Collect Hidden Eggs",
        Callback = function()
            collectHiddenEggs()
        end
    })

    EggsTab:AddDropdown({
        Name = "Select Egg Type",
        Default = "Common",
        Options = getEggNames(),
        Callback = function(Value)
            getgenv().EGGTYPE = Value
        end
    })

    EggsTab:AddButton({
        Name = "Buy Egg Type",
        Callback = function()
            buyEgg(getgenv().EGGTYPE)
        end
    })

    GameTab:AddButton({
        Name = "Toggle Hatcher Overlay",
        Callback = function()
            Lp.PlayerGui.ScreenGui.Hatcher.Hatcher.Enabled = not Lp.PlayerGui.ScreenGui.Hatcher.Hatcher.Enabled
        end
    })


elseif game.PlaceId == 3623096087 then -- Muscle Legends

    -- Values

    Codes = {
            Remote = Svc.RepStor.rEvents.codeRemote,
            List = {
                "epicreward500",
                "MillionWarriors",
                "frostgems10",
                "Musclestorm50",
                "spacegems50",
                "megalift50",
                "speedy50",
                "Skyagility50",
                "galaxycrystal50",
                "supermuscle100",
                "superpunch100",
                "epicreward500",
                "launch250"
            }
        }

    -- Functions

    local function getIslandNames()
        local t = {
            "Tiny Island",
            "Beach",
            "Frost Gym",
            "Mythical Gym",
            "Muscle King",
            "Legends Gym"
        }
        return t
    end

    local function travelTo(area)
        local areaCircles = Svc.Ws.areaCircles
        local A_1 = "travelToArea"
        local Event = Svc.RepStor.rEvents.areaTravelRemote
        for _, v in pairs(areaCircles:GetDescendants()) do
            if v.Name == "areaName" and area == v.Value then
                Event:InvokeServer(A_1, v.Parent)
                break
            end
        end
    end

    local function muscleEvent(event)
        local Event = Lp.muscleEvent
        Event:FireServer(event)
    end

    local function dailyChests()
        local names = {}
        for _, v in pairs(Svc.Ws:GetDescendants()) do
            if v.Name == "chestNamePart" then
                local name = v.nameGui.nameLabel.Text
                table.insert(names, name)
            end
        end
        for _, v in pairs(names) do
            Svc.RepStor.rEvents.checkChestRemote:InvokeServer(v)
            task.wait()
        end
    end

    local function autoChests()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CHESTS then break end;
                dailyChests()
                task.wait(60)
            end
        end)
    end

    local function switchTools()
        for _, v in pairs(Lp.Backpack:GetChildren()) do
            if v.ClassName == "Tool" and v.Name == "Handstands" or v.Name == "Situps" or v.Name == "Pushups" or v.Name == "Weight" then
                v:FindFirstChildOfClass("NumberValue").Value = 0
                repeat task.wait() until Lp.Backpack:FindFirstChildOfClass("Tool")
                Chr:WaitForChild("Humanoid"):EquipTool(v)
            end
        end
    end

    local function returnBestItem(list)
        local cPetShopFolder = Svc.RepStor.cPetShopFolder
        local bestVal = 0
        local bestItem
        for _, n in ipairs(list) do
            if n.Name ~= "Default Trail" then
                if cPetShopFolder[n.Name].priceValue.Value > bestVal then
                    bestVal = cPetShopFolder[n.Name].priceValue.Value
                    bestItem = n
                end
            end
        end
        return bestItem
    end

    local function autoTrain()
        Svc.RunSvc.Stepped:Connect(function()
            pcall(function()
                if getgenv().TRAIN then
                    Hum:ChangeState(10)
                end
            end)
        end)
        task.spawn(function()
            local oldCf = HumRP.CFrame
            while task.wait() do
                if not getgenv().TRAIN then break end;
                pcall(function()
                    muscleEvent("rep")
                    switchTools()
                    HumRP.CFrame = CFrame.new(9e9,9e9,9e9)
                end)
                task.wait(0.5)
            end
            HumRP.CFrame = oldCf
            Hum:UnequipTools()
        end)
    end

    local function getCrystalNames()
        local t = {}
        for _, v in pairs(Svc.Ws.mapCrystalsFolder:GetChildren()) do
            table.insert(t, v.Name)
        end
        return t
    end

    local function openCrystal(name)
        local A_1 = "openCrystal"
        local Event = Svc.RepStor.rEvents.openCrystalRemote
        Event:InvokeServer(A_1, name)
    end

    local function autoCrystals(name)
        task.spawn(function()
            while task.wait() do
                if not getgenv().CRYSTALS then break end;
                openCrystal(name)
                task.wait(2)
            end
        end)
    end

    local function changeSize(int)
        local A_1 = "changeSize"
        local Event = Svc.RepStor.rEvents.changeSpeedSizeRemote
        Event:InvokeServer(A_1, int)
    end

    local function rebirth()
        local A_1 = "rebirthRequest"
        local Event = Svc.RepStor.rEvents.rebirthRemote
        Event:InvokeServer(A_1)
    end

    local function autoRebirth()
        task.spawn(function()
            while task.wait() do
                if not getgenv().REBIRTH then break end;
                rebirth()
                task.wait(10)
            end
        end)
    end

    local function evolvePet(name)
        local A_1 = "evolvePet"
        local Event = Svc.RepStor.rEvents.petEvolveEvent
        Event:FireServer(A_1, name)
    end

    local function evolvePets()
        local petsFrames = Lp.PlayerGui.gameGui.itemsMenu.petsFrames
        local names, counts = {}, {}
        for _, v in ipairs(petsFrames:GetDescendants()) do
            if v.ClassName == "TextButton" then
                table.insert(names, v.nameLabel.Text)
            end
        end
        for _, v in ipairs(names) do
            counts[v] = counts[v] and counts[v] + 1 or 1
        end
        for k, v in next, counts do
            if v >= 5 then
                evolvePet(k)
            end
        end
    end

    local function autoEvolvePets()
        task.spawn(function()
            while task.wait() do
                if not getgenv().EVOLVEPETS then break end;
                evolvePets()
                task.wait(1)
            end
        end)
    end

    local function sellPet(pet)
        local A_1 = "sellPet"
        local Event = Svc.RepStor.rEvents.sellPetEvent
        Event:FireServer(A_1, pet)
    end

    local function getPetCap()
        local capacityLabel = Lp.PlayerGui.gameGui.itemsMenu.bottomItemsMenu.capacityLabel
        local t = string.gsub(capacityLabel.Text, "Capacity: ", "")
        local s = string.gsub(t, "/"," ")
        local result = {}
        for i in string.gmatch(s, "%S+") do
            table.insert(result, i)
        end
        return result[2] - result[1]
    end

    local function petEquipped(name)
        local equippedPets = Lp.equippedPets
        local r = false
        for _, v in (equippedPets:GetDescendants()) do
            if v.ClassName == "ObjectValue" and name == v.Value then
                r = true
            end
        end
        return r
    end

    local function sellPets()
        local c = getPetCap()
        if c < 1 then
            local petsFolder = Lp.petsFolder
            for _, v in ipairs(petsFolder:GetDescendants()) do
                if v.ClassName == "StringValue" and #v:GetChildren() > 0 then
                    if not petEquipped(v.Name) then
                        sellPet(v)
                        task.wait(1)
                    end
                end
            end
        end
    end

    local function autoSellPets()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SELLPETS then break end;
                sellPets()
                task.wait(1)
            end
        end)
    end

    local function returnPets()
        local petsFrames = Lp.PlayerGui.gameGui.itemsMenu.petsFrames
        local pets = {}
        for _, v in ipairs(petsFrames:GetDescendants()) do
            if v.Name == "petButton" then
                table.insert(pets, v.petReference.Value)
            end
        end
        return pets
    end

    local function equipPet(pet)
        local A_1 = "equipPet"
        local Event = Svc.RepStor.rEvents.equipPetEvent
        Event:FireServer(A_1, pet)
    end

    local function autoEquipPet()
        task.spawn(function()
            while task.wait() do
                if not getgenv().PETEQUIP then break end;
                equipPet(returnBestItem(returnPets()))
                task.wait(5)
            end
        end)
    end

    -- Tabs

    GameTab:AddSlider({
        Name = "Size",
        Min = 0.1,
        Max = 500,
        Default = 1,
        Save = true,
        Flag = "SIZE",
        Color = Color3.fromRGB(255,255,255),
        Increment = 0.1,
        ValueName = "",
        Callback = function(Value)
            changeSize(Value)
        end
    })

    TeleportSect:AddDropdown({
        Name = "TP to Island",
        Default = "",
        Options = getIslandNames(),
        Callback = function(Value)
            travelTo(Value)
        end
    })

    local FarmTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    FarmTab:AddToggle({
        Name = "Automatic Training",
        Default = false,
        Save = true,
        Flag = "TRAIN",
        Callback = function(Value)
            getgenv().TRAIN = Value
            if Value then
                autoTrain()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Collect Chests",
        Default = false,
        Save = true,
        Flag = "CHESTS",
        Callback = function(Value)
            getgenv().CHESTS = Value
            if Value then
                autoChests()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Rebirth",
        Default = false,
        Save = true,
        Flag = "REBIRTH",
        Callback = function(Value)
            getgenv().REBIRTH = Value
            if Value then
                autoRebirth()
            end
        end
    })

    local PetsTab = Window:MakeTab({
        Name = "Pets",
        Icon = Icons.Pet,
        PremiumOnly = false
    })

    PetsTab:AddDropdown({
        Name = "Select a Crystal",
        Default = "Blue Crystal",
        Save = true,
        Flag = "CRYSTAL",
        Options = getCrystalNames(),
        Callback = function(Value)
            getgenv().CRYSTAL = Value
        end
    })

    PetsTab:AddToggle({
        Name = "Open Crystal",
        Default = false,
        Save = true,
        Flag = "CRYSTALS",
        Callback = function(Value)
            getgenv().CRYSTALS = Value
            if Value then
                autoCrystals(getgenv().CRYSTAL)
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Evolve Pets",
        Default = false,
        Save = true,
        Flag = "EVOLVEPETS",
        Callback = function(Value)
            getgenv().EVOLVEPETS = Value
            if Value then
                autoEvolvePets()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Sell Pets",
        Default = false,
        Save = true,
        Flag = "SELLPETS",
        Callback = function(Value)
            getgenv().SELLPETS = Value
            if Value then
                autoSellPets()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Equip Pets",
        Default = false,
        Save = true,
        Flag = "PETEQUIP",
        Callback = function(Value)
            getgenv().PETEQUIP = Value
            if Value then
                autoEquipPet()
            end
        end
    })

elseif game.PlaceId == 3101667897 then -- Legends of Speed

    -- Values

    Codes = {
        Remote = Svc.RepStor.rEvents.codeRemote,
        List = {
            "speedchampion000",
            "racer300",
            "SPRINT250",
            "hyper250",
            "legends500",
            "sparkles300",
            "launch200"
        }
    }

    -- Functions

    local function collectOrbs()
        local orbFolder = Svc.Ws.orbFolder
        for _, v in pairs(orbFolder:GetDescendants()) do
            if v.Name == "TouchInterest" and v.Parent then
                firetouchinterest(HumRP, v.Parent, 0)
                task.wait()
            end
        end
    end

    local function autoCollectOrbs()
        task.spawn(function()
            while task.wait() do
                if not getgenv().ORBS then break end;
                collectOrbs()
                task.wait()
            end
        end)
    end

    local function collectChests()
        local rewardChests = Svc.Ws.rewardChests
        for _, v in pairs(rewardChests:GetDescendants()) do
            if v.Name == "TouchInterest" and v.Parent then
                firetouchinterest(HumRP, v.Parent, 0)
                task.wait()
            end
        end
    end

    local function autoCollectChests()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CHESTS then break end;
                collectChests()
                task.wait(60)
            end
        end)
    end

    local function collectHoops()
        local Hoops = Svc.Ws.Hoops
        for _, v in pairs(Hoops:GetChildren()) do
            firetouchinterest(HumRP, v, 0)
            task.wait()
            firetouchinterest(HumRP, v, 1)
        end
    end

    local function autoCollectHoops()
        task.spawn(function()
            while task.wait() do
                if not getgenv().HOOPS then break end;
                collectHoops()
            end
        end)
    end

    local function rebirth()
        local A_1 = "rebirthRequest"
        local Event = Svc.RepStor.rEvents.rebirthEvent
        Event:FireServer(A_1)
    end

    local function autoRebirth()
        task.spawn(function()
            while task.wait() do
                if not getgenv().REBIRTH then break end;
                rebirth()
                task.wait(10)
            end
        end)
    end

    local function evolvePet(name)
        local A_1 = "evolvePet"
        local Event = Svc.RepStor.rEvents.petEvolveEvent
        Event:FireServer(A_1, name)
    end

    local function evolvePets()
        local petsFrames = Lp.PlayerGui.gameGui.petsMenu.petsFrames
        local names, counts = {}, {}
        for _, v in ipairs(petsFrames:GetDescendants()) do
            if v.ClassName == "TextButton" then
                table.insert(names, v.nameLabel.Text)
            end
        end
        for _, v in ipairs(names) do
            counts[v] = counts[v] and counts[v] + 1 or 1
        end
        for k, v in next, counts do
            if v >= 5 then
                evolvePet(k)
            end
        end
    end

    local function autoEvolvePets()
        task.spawn(function()
            while task.wait() do
                if not getgenv().EVOLVEPETS then break end;
                evolvePets()
                task.wait(1)
            end
        end)
    end

    local function sellPet(pet)
        local A_1 = "sellPet"
        local Event = Svc.RepStor.rEvents.sellPetEvent
        Event:FireServer(A_1, pet)
    end

    local function getPetCap()
        local capacityLabel = Lp.PlayerGui.gameGui.petsMenu.bottomPetMenu.capacityLabel
        local t = string.gsub(capacityLabel.Text, "Capacity: ", "")
        local s = string.gsub(t, "/"," ")
        local result = {}
        for i in string.gmatch(s, "%S+") do
            table.insert(result, i)
        end
        return result[2] - result[1]
    end

    local function petEquipped(name)
        local equippedPets = Lp.equippedPets
        local r = false
        for _, v in (equippedPets:GetDescendants()) do
            if v.ClassName == "ObjectValue" and name == v.Value then
                r = true
            end
        end
        return r
    end

    local function sellPets()
        local c = getPetCap()
        if c < 1 then
            local petsFolder = Lp.petsFolder
            for _, v in ipairs(petsFolder:GetDescendants()) do
                if v.ClassName == "StringValue" and #v:GetChildren() > 0 then
                    if not petEquipped(v.Name) then
                        sellPet(v)
                        task.wait(1)
                    end
                end
            end
        end
    end

    local function autoSellPets()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SELLPETS then break end;
                sellPets()
                task.wait(1)
            end
        end)
    end

    local function getTrailCap()
        local capacityLabel = Lp.PlayerGui.gameGui.trailsMenu.bottomTrailMenu.capacityLabel
        local t = string.gsub(capacityLabel.Text, "Capacity: ", "")
        local s = string.gsub(t, "/"," ")
        local result = {}
        for i in string.gmatch(s, "%S+") do
            table.insert(result, i)
        end
        return result[2] - result[1]
    end

    local function sellTrail(trail)
        local A_1 = "sellTrail"
        local Event = Svc.RepStor.rEvents.sellTrailEvent
        Event:FireServer(A_1, trail)
    end

    local function trailEquipped(name)
        local r = false
        if name == Lp.equippedTrail.Value then
            r = true
        end
        return r
    end

    local function sellTrails()
        local c = getTrailCap()
        if c < 1 then
            local trailsFolder = Lp.trailsFolder
            for _, v in ipairs(trailsFolder:GetDescendants()) do
                if v.ClassName == "Trail" and #v:GetChildren() > 0 then
                    if not trailEquipped(v.Name) then
                        sellTrail(v)
                        task.wait(1)
                    end
                end
            end
        end
    end

    local function returnBestItem(list)
        local cPetShopFolder = Svc.RepStor.cPetShopFolder
        local bestVal = 0
        local bestItem
        for _, n in ipairs(list) do
            if n.Name ~= "Default Trail" then
                if cPetShopFolder[n.Name].priceValue.Value > bestVal then
                    bestVal = cPetShopFolder[n.Name].priceValue.Value
                    bestItem = n
                end
            end
        end
        return bestItem
    end

    local function autoSellTrails()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SELLTRAILS then break end;
                sellTrails()
                task.wait(3)
            end
        end)
    end

    local function returnTrails()
        local trailFrames = Lp.PlayerGui.gameGui.trailsMenu.trailFrames
        local trails = {}
        for _, v in ipairs(trailFrames:GetDescendants()) do
            if v.Name == "trailButton" then
                table.insert(trails, v.trailReference.Value)
            end
        end
        return trails
    end

    local function equipTrail(trail)
        local A_1 = "equipTrail"
        local Event = Lp.equipTrailEvent
        Event:FireServer(A_1, trail)
    end

    local function autoEquipTrail()
        task.spawn(function()
            while task.wait() do
                if not getgenv().TRAILEQUIP then break end;
                equipTrail(returnBestItem(returnTrails()))
                task.wait(5)
            end
        end)
    end

    local function returnPets()
        local petsFrames = Lp.PlayerGui.gameGui.petsMenu.petsFrames
        local pets = {}
        for _, v in ipairs(petsFrames:GetDescendants()) do
            if v.Name == "petButton" then
                table.insert(pets, v.petReference.Value)
            end
        end
        return pets
    end

    local function equipPet(pet)
        local A_1 = "equipPet"
        local Event = Svc.RepStor.rEvents.equipPetEvent
        Event:FireServer(A_1, pet)
    end

    local function autoEquipPet()
        task.spawn(function()
            while task.wait() do
                if not getgenv().PETEQUIP then break end;
                equipPet(returnBestItem(returnPets()))
                task.wait(5)
            end
        end)
    end

    local function getCrystalNames()
        local CrystalsFolder = Svc.Ws.mapCrystalsFolder
        local t = {}
        for _, v in pairs(CrystalsFolder:GetChildren()) do
            table.insert(t, v.Name)
        end
        return t
    end

    local function openCrystal(name)
        local A_1 = "openCrystal"
        local Event = Svc.RepStor.rEvents.openCrystalRemote
        Event:InvokeServer(A_1, name)
    end

    local function autoCrystals()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CRYSTALS then break end;
                openCrystal(getgenv().CRYSTAL)
                task.wait(2)
            end
        end)
    end

    -- Tabs

    local FarmTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    FarmTab:AddToggle({
        Name = "Collect Orbs",
        Default = false,
        Save = true,
        Flag = "ORBS",
        Callback = function(Value)
            getgenv().ORBS = Value
            if Value then
                autoCollectOrbs()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Collect Daily Chests",
        Default = false,
        Save = true,
        Flag = "CHESTS",
        Callback = function(Value)
            getgenv().CHESTS = Value
            if Value then
               autoCollectChests()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Collect Hoops",
        Default = false,
        Save = true,
        Flag = "HOOPS",
        Callback = function(Value)
            getgenv().HOOPS = Value
            if Value then
               autoCollectHoops()
            end
        end
    })

    FarmTab:AddToggle({
        Name = "Rebirth",
        Default = false,
        Save = true,
        Flag = "REBIRTH",
        Callback = function(Value)
            getgenv().REBIRTH = Value
            if Value then
               autoRebirth()
            end
        end
    })

    local PetsTab = Window:MakeTab({
        Name = "Pets",
        Icon = Icons.Pet,
        PremiumOnly = false
    })

    PetsTab:AddDropdown({
        Name = "Select a Crystal",
        Default = "Blue Crystal",
        Save = true,
        Flag = "CRYSTAL",
        Options = getCrystalNames(),
        Callback = function(Value)
            getgenv().CRYSTAL = Value
        end
    })

    PetsTab:AddToggle({
        Name = "Buy Pets",
        Default = false,
        Save = true,
        Flag = "CRYSTALS",
        Callback = function(Value)
            getgenv().CRYSTALS = Value
            if Value then
                autoCrystals()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Equip Best Pets",
        Default = false,
        Save = true,
        Flag = "PETEQUIP",
        Callback = function(Value)
            getgenv().PETEQUIP = Value
            if Value then
                autoEquipPet()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Evolve Pets",
        Default = false,
        Save = true,
        Flag = "EVOLVEPETS",
        Callback = function(Value)
            getgenv().EVOLVEPETS = Value
            if Value then
                autoEvolvePets()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Sell Pets",
        Default = false,
        Save = true,
        Flag = "SELLPETS",
        Callback = function(Value)
            getgenv().SELLPETS = Value
            if Value then
                autoSellPets()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Equip Best Trail",
        Default = false,
        Save = true,
        Flag = "TRAILEQUIP",
        Callback = function(Value)
            getgenv().TRAILEQUIP = Value
            if Value then
                autoEquipTrail()
            end
        end
    })

    PetsTab:AddToggle({
        Name = "Sell Trails",
        Default = false,
        Save = true,
        Flag = "SELLTRAILS",
        Callback = function(Value)
            getgenv().SELLTRAILS = Value
            if Value then
                autoSellTrails()
            end
        end
    })

elseif game.PlaceId == 6953291455 then -- Eating Simulator

    -- Values

    local destMod = require(Lp.PlayerScripts.Client.Modules.Destinations)

    Codes = {
        Remote = Svc.RepStor.Knit.Services.CodeService.RF.redeemCode,
        List = {
            "BURGER700K",
            "GINGERBREAD675K",
            "OMG60K",
            "CRAZY50K",
            "FREEFAT40K",
            "YAY10K",
            "RELEASE",
            "THANKS20K",
            "BIGBELLY70K",
            "FATNECK80K",
            "BECOMEHUGE100K",
            "REALLYCOOL110K",
            "EXTRAORDINARY120K",
            "BIGTHANKS130K",
            "BUGFIXES140K",
            "FAT170K",
            "BIGFAT180K",
            "ALMOSTTHERE190K",
            "FREEPET200K",
            "FATBOOST210K",
            "COINSBOOST220K",
            "GETFATNOW230K",
            "OPCODE240K",
            "BIGMILESTONE250K",
            "LIVEEVENT260K",
            "SOMECOINS270K",
            "SOMEFOOD280K",
            "VERYCLOSE290K",
            "THANKSSOMUCH300K",
            "REALLYHYPE90K",
            "EAT320K",
            "GETBIGTODAY350K",
            "FREE375K",
            "GODLYPET400K",
            "INSANEPET450K",
            "GG475K",
            "HALFWAY500K",
            "PETREWARD530K",
            "SECRETCODE575K",
            "MILESTONE600K",
            "CHRISTMAS625K",
            "GINGERBREAD675K",
            "SUMMERUPDATE"
        }
    }

    -- Functions

    local function equipTool()
        local tool = Lp.Backpack:FindFirstChildOfClass("Tool")
        repeat task.wait(1) until tool
        Chr:WaitForChild("Humanoid"):EquipTool(tool)
    end

    local function eat()
        local t = Svc.Ws[Lp.Name]:FindFirstChild("swing")
        if not t then
            equipTool()
        end
        if t then
            t:Activate()
        end
    end

    local function autoEat()
        task.spawn(function()
            while task.wait(1) do
                if not getgenv().EAT then break end
                eat()
                task.wait()
            end
        end)
    end

    local function buyAll(item)
        local r = Svc.RepStor:WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RE"):WaitForChild("buyAll")
        r:FireServer(item)
    end

    local function buyRank()
        local r = Svc.RepStor:WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RE")
        local Ranks = Lp.PlayerGui.Main.Frames.Shop.Categories.Ranks:FindFirstChildWhichIsA("ScrollingFrame")
        local results = {}
        for _, v in ipairs(Ranks:GetChildren()) do
            if v.ClassName == "Frame" then
                table.insert(results, v.Name)
            end
        end
        local buyNext = false
        for _, v in ipairs(results) do
            if buyNext then
                r:WaitForChild("buy"):FireServer(v, "Ranks")
                task.wait(1)
                r:WaitForChild("equip"):FireServer(v, "Ranks")
                Lp.PlayerGui.Main.Frames.Store.Visible = false
                game:GetService("CoreGui").PurchasePrompt.Enabled = false
                buyNext = false
            end
            if v == Lp.Data.EquippedRank.Value then
                buyNext = true
            end
        end
    end

    local function autoSell()
        local Title = Lp.PlayerGui.Main.Right.Sell.Front.Title
        local Button = Lp.PlayerGui.Main.Right.Sell.Front.Button
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().SELL then break end
                if Title.Text == "SELL" then
                    firesignal(Button.MouseButton1Click)
                    task.wait(1)
                    destMod:teleportToUpgrade()
                end
            end
        end)
    end

    local function autoBuyFood()
        task.spawn(function()
            while task.wait() do
                if not getgenv().BUYFOOD then break end
                destMod:teleportToUpgrade()
                task.wait(0.2)
                buyAll("Bats")
                task.wait(5)
            end
        end)
    end

    local function autoBuyRank()
        task.spawn(function()
            while task.wait() do
                if not getgenv().BUYRANKS then break end
                destMod:teleportToUpgrade()
                task.wait(0.2)
                buyRank()
                task.wait(20)
            end
        end)
    end

    local function autoBuyDNA()
        task.spawn(function()
            while task.wait() do
                if not getgenv().BUYDNA then break end
                destMod:teleportToUpgrade()
                task.wait(0.2)
                buyAll("DNA")
                task.wait(5)
            end
        end)
    end

    local function claimDailyChest()
        local t = Svc.Ws.Chests.Daily.step.status.time.Text
        if t == "READY TO OPEN" then
            repeat task.wait(1) until HumRP
            HumRP.CFrame = Svc.Ws.Chests.Daily.obj.Part.CFrame
            task.wait(0.5)
            local A_1 = "Daily"
            local Event = Svc.RepStor.Knit.Services.ChestService.RE.claimChest
            Event:FireServer(A_1)
        end
    end

    local function autoClaimDailyChest()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CLAIMDAILY then break end
                claimDailyChest()
                task.wait(60)
            end
        end)
    end

    local function getIslandNames()
        local ZoneRegions = Svc.Ws.ZoneRegions
        local t = {}
        for _, v in pairs(ZoneRegions:GetChildren()) do
            table.insert(t, v.Name)
        end
        return t
    end

    -- Tabs

    TeleportSect:AddDropdown({
        Name = "TP to Island",
        Default = "",
        Options = getIslandNames(),
        Callback = function(Value)
            local ZoneRegions = Svc.Ws.ZoneRegions
            HumRP.CFrame = (ZoneRegions[Value].CFrame + Vector3.new(0, 30, 0))
        end
    })

    local FarmingTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })
    
    FarmingTab:AddToggle({
        Name = "Eat",
        Default = false,
        Save = true,
        Flag = "EAT",
        Callback = function(Value)
            getgenv().EAT = Value
            if Value then
                autoEat()
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Sell",
        Default = false,
        Save = true,
        Flag = "SELL",
        Callback = function(Value)
            getgenv().SELL = Value
            if Value then
                autoSell()
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Claim Daily Chest",
        Default = false,
        Save = true,
        Flag = "CLAIMDAILY",
        Callback = function(Value)
            getgenv().CLAIMDAILY = Value
            if Value then
                autoClaimDailyChest()
            end
        end
    })

    local BuyTab = Window:MakeTab({
        Name = "Buy",
        Icon = Icons.Money,
        PremiumOnly = false
    })

    BuyTab:AddToggle({
        Name = "Buy Food",
        Default = false,
        Save = true,
        Flag = "BUYFOOD",
        Callback = function(Value)
            getgenv().BUYFOOD = Value
            if Value then
                autoBuyFood()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Buy DNA",
        Default = false,
        Save = true,
        Flag = "BUYDNA",
        Callback = function(Value)
            getgenv().BUYDNA = Value
            if Value then
                autoBuyDNA()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Buy Ranks",
        Default = false,
        Save = true,
        Flag = "BUYRANKS",
        Callback = function(Value)
            getgenv().BUYRANKS = Value
            if Value then
                autoBuyRank()
            end
        end
    })

elseif game.PlaceId == 11040063484 then -- Sword Fighters Simulator

    -- Values

    Codes = {
        Remote = Svc.RepStor:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CodeService"):WaitForChild("RF"):WaitForChild("RedeemCode"),
        List = {
            "GetRich",
            "Secret",
            "Valentine",
            "BugsSquashed",
            "SisterGuard",
            "Ascend",
            "LUCKY100",
            "Strongest",
            "Oatsz",
            "SORRYSHUT1",
            "Spraden",
            "Celestial",
            "Kolapo",
            "GODLIKE",
            "FeelingLucky",
            "Sharpen",
            "Climb",
            "Christmas",
            "NewYear",
            "Eggmaster",
            "COLLECTOR",
            "Striker",
            "Holiday",
            "X2POWER20MIN",
            "Dungeons",
            "RICH",
            "GETRICHQUICK"
        }
    }

    local CurrentQuest = Lp.PlayerGui.RightSidebar.Background.Frame.Window.Items.CurrentQuest
    local WeaponScrolling = Lp.PlayerGui.WeaponInv.Background.ImageFrame.Window.WeaponHolder.WeaponScrolling
    local Areas = { "Dark Forest", "Skull Cove", "Demon Hill", "Polar Tundra", "Aether City", "Underworld", "Ancient Sands", "Enchanted Woods", "Mystic Mines", "Sacred Land", "Marine Castle", "High Havens", "Cracked Canyons", "Colossus Meadows", "Underwater", "Blazing Abyss", "Hangug Hollows", "Taiping Towers", "Viking Valley", "Jungle Oasis", "Space Odyssey", "Robot Realm", "Acidic Abyss", "Kingdom of Mythralis", "Steamhaven", "Dread Hollow", "Mythos Realm" }
    local Area = Lp:GetAttribute("Area")
    local Region = Lp:GetAttribute("Region")
    local regionConnection, areaConnection
    
    if not regionConnection then
        regionConnection = Lp:GetAttributeChangedSignal("Region"):Connect(function()
            Region = Lp:GetAttribute("Region")
        end)
    end
    if not areaConnection then
        areaConnection = Lp:GetAttributeChangedSignal("Area"):Connect(function()
            Area = Lp:GetAttribute("Area")
        end)
    end

    -- Functions

    local function castSpells()
        pcall(function()
            local Skills = Lp.PlayerGui.SkillsBottom.Skills
            local Buttons = { "Template", "Template2", "Template3" }
            for i = 1, #Buttons do
                local button = Skills:FindFirstChild(Buttons[i]):FindFirstChild("Main")
                if button then
                    firesignal(button.MouseButton1Click)
                    task.wait(10)
                end
            end
        end)
    end

    local function autoSpells()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().SPELLS then break end
                castSpells()
            end
        end)
    end

    local function autoSwing()
        local clickMod = require(Svc.RepStor.ClientModules.Controllers.AfterLoad.InputController)
        task.spawn(function()
            while task.wait() do
                if not getgenv().SWING then break end
                clickMod:Click()
            end
        end)
    end

    local function tpTo(Index)
        local tpMod = require(Svc.RepStor.ClientModules.Controllers.AfterLoad.TeleportController)
        local Name = "Area "..Index
        if tpMod then
            tpMod:TeleportArea(Name)
        end
    end

    local function returnLockedAreas()
        local Locks = Svc.Ws.Assets.Locks
        local t = {}
        for _, v in ipairs(Locks:GetChildren()) do
            if v.Transparency == 0 then
                table.insert(t, v.Name)
            end
        end
        table.sort(t)
        return t
    end

    local function returnMobs()
        local NPCs = Svc.Ws.Live.NPCs.Client
        local t = {}
        for i, v in pairs(NPCs:GetChildren()) do
            if v.HumanoidRootPart then
                table.insert(t, v)
            end
        end
        return t
    end

    local function toQuestArea()
        if Area ~= "Area 1" or Region == "Dungeon" then
            tpTo(1)
            task.wait(3)
        end
        if not CurrentQuest.Visible then
            alert("Auto Questing", "Searching for quest area.")
            for i = 2, #Areas do
                if not getgenv().AUTOQUEST then break end
                tpTo(i)
                task.wait(3)
                if CurrentQuest.Visible and Region ~= "Dungeon" then
                    alert("Auto Questing", "Found current quest area.")
                    break
                end
            end
        end
    end

    local function buyPortal(name)
        local Event = Svc.RepStor.Packages.Knit.Services.AreaService.RF.BuyArea
        Event:InvokeServer(name)
    end

    local function autoBuyPortals()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().BUYPORTALS then break end
                for _, v in ipairs(Lp.PlayerGui:GetChildren()) do
                    if not getgenv().BUYPORTALS then break end
                    if v.ClassName == "BillboardGui" and v.Name == "Portal" then
                        if v.Text2.Text ~= "Owned" and v.Text2.Text ~= "Unlocked" then
                            for _, v in pairs(returnLockedAreas()) do
                                if not getgenv().BUYPORTALS then break end
                                buyPortal(v)
                                task.wait(3)
                            end
                        end
                    end
                end
            end
        end)
    end

    local function returnQuestMob()
        local r
        if CurrentQuest.Visible then
            local ProgressLabel = CurrentQuest.ProgressLabel
            local txt = ProgressLabel.Text
            local t = string.split(txt, " ")
            table.remove(t, 1)
            r = table.concat(t, " ")
        end
        return r
    end

    local function returnTargets()
        local mobName = returnQuestMob()
        local t = {}
        for _, v in pairs(returnMobs()) do
            local NPCTag = v:FindFirstChild("HumanoidRootPart"):FindFirstChild("NPCTag")
            if NPCTag then
                if NPCTag.NameLabel.Text == mobName then
                    table.insert(t, v)
                end
            end
        end
        return t
    end

    local function getCF(target)
        local r = HumRP.CFrame
        if HumRP and target then
            local mob = target.HumanoidRootPart
            if mob then
                r = (mob.CFrame + Vector3.new(-3, 2, 3))
            end
        end
        return r
    end

    local function killMobs()
        local target = false
        if not getgenv().SWING then
            getgenv().swingToggle:Set(true)
            getgenv().spellToggle:Set(true)
        end

        task.spawn(function()
            while task.wait() do
                if not getgenv().MOBS then break end
                if target then
                    HumRP.CFrame = getCF(target)
                    task.wait(1)
                    target = nil
                else
                    if #returnTargets() > 0 then
                        for _, t in pairs(returnTargets()) do
                            if not getgenv().MOBS then break end
                            target = t
                        end
                    else
                        for _, m in pairs(returnMobs()) do
                            if not getgenv().MOBS then break end
                            target = m
                        end
                    end
                end
                if not getgenv().SWING then
                    getgenv().swingToggle:Set(true)
                    getgenv().spellToggle:Set(true)
                end
            end
        end)
    end

    local function ascend()
        local Event = Svc.RepStor.Packages.Knit.Services.AscendService.RF.Ascend
        Event:InvokeServer()
    end

    local function autoAscend()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().ASCEND then break end
                ascend()
            end
        end)
    end

    local function sellWeapon(name)
        local r = Svc.RepStor.Packages.Knit.Services.WeaponInvService.RF.SellWeapon
        if r then
            r:InvokeServer(name)
        end
    end

    local function returnWeapons()
        local t = {}
        for _, v in pairs(WeaponScrolling:GetChildren()) do
            if v.Name ~= "Sorter" then
                table.insert(t, v)
            end
        end
        return t
    end

    local function equipBest()
        local r = Svc.RepStor.Packages.Knit.Services.WeaponInvService.RF.EquipBest
        if r then
            r:InvokeServer()
        end
    end

    local function autoSell()
        local TextLabel = Lp.PlayerGui.WeaponInv.Background.ImageFrame.Window.Owned.TextLabel
        local t = returnQuestMob()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().AUTOSELL then break end
                if #returnWeapons() >= tonumber(string.split(TextLabel.Text, "/")[2]) then
                    local s = ""
                    if t then
                        s = string.split(t, "Find ")[2]
                    end
                    for _, v in next, returnWeapons() do
                        if not getgenv().AUTOSELL then break end
                        if s and v then
                            if s ~= v.TextLabel then
                                if v.Frame.Equipped and not v.Frame.Equipped.Visible then
                                    sellWeapon(v.Name)
                                    task.wait()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    local function upgradeAll()
        Area = Lp:GetAttribute("Area")
        local r = Svc.RepStor.Packages.Knit.Services.UpgradeService.RF.Upgrade
        if r then
            local u = { "Power Gain", "More Storage", "WalkSpeed" }
            for _, upgrade in pairs(u) do
                r:InvokeServer(Area, upgrade)
                task.wait(1)
            end
        end
    end

    local function autoUpgrade()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().UPGRADE then break end
                upgradeAll()
            end
        end)
    end

    local function autoEquipBest()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().EQUIPBEST then break end
                equipBest()
            end
        end)
    end

    local function getQuestDummies()
        local results = {}
        for _, v in pairs(Svc.Ws.Resources.QuestDummy:GetChildren()) do
            table.insert(results, v.Name)
        end
        return results
    end

    local function actionQuest()
        local r1 = Svc.RepStor:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RF"):WaitForChild("SelectGift")
        local r2 = Svc.RepStor:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("QuestService"):WaitForChild("RF"):WaitForChild("ActionQuest")
        if r1 and r2 then
            for _, v in getQuestDummies() do
                r1:InvokeServer()
                r2:InvokeServer(v)
                r1:InvokeServer()
                task.wait(0.5)
            end
        end
    end

    local function levelIndex()
        local r = Svc.RepStor.Packages.Knit.Services.IndexService.RF.Claim
        if r then
            for i = 1, 10 do
                r:InvokeServer(i)
                task.wait(0.5)
            end
        end
    end

    local function autoQuest()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().AUTOQUEST then break end
                if not CurrentQuest.Visible or Region == "Dungeon" then
                    getgenv().mobsToggle:Set(false)
                    toQuestArea()
                    task.wait(3)
                else
                    if not getgenv().MOBS then
                        getgenv().mobsToggle:Set(true)
                    end
                    actionQuest()
                    levelIndex()
                end
            end
            getgenv().mobsToggle:Set(false)
        end)
    end

    local function forge(item)
        local r = Svc.RepStor.Packages.Knit.Services.ForgeService.RF.Forge
        if r then
            r:InvokeServer(item)
        end
    end

    local function autoForge()
        local last
        task.spawn(function()
            while task.wait(10) do
                for i, v in pairs(WeaponScrolling:GetChildren()) do
                    if not getgenv().FORGE then break end
                    if v.Name ~= last and v.ClassName == "Frame" then
                        forge(v.Name)
                        task.wait()
                    end
                    last = v.Name
                end
            end
        end)
    end

    local function buyEgg(Name)
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("EggService"):WaitForChild("RF"):WaitForChild("BuyEgg")
        if r then
            local Eggs = { 
                ["Weak Egg"] = 1, 
                ["Strong Egg"] = 2,
                ["Paradise Egg"] = 3,
                ["Bamboo Egg"] = 5,
                ["Frozen Egg"] = 7,
                ["Soft Egg"] = 9,
                ["Lava Egg"] = 11,
                ["Mummified Egg"] = 13,
                ["Lost Egg"] = 15,
                ["Ore Egg"] = 17,
                ["Leaf Egg"] = 19,
                ["Aquatic Egg"] = 21,
                ["Holy Egg"] = 23,
                ["Canyon Egg"] = 26,
                ["Titanic Egg"] = 28,
                ["Underwated Egg"] = 30,
                ["Molten Egg"] = 32,
                ["Mystic Kitsune Egg"] = 34,
                ["Lantern Egg"] = 36,
                ["Timber Knight Egg"] = 38,
                ["Armored Cocoon Egg"] = 40,
                ["Cosmic Egg"] = 42,
                ["Cyborg Egg"] = 44,
                ["Toxic Tesseract Egg"] = 46, 
                ["Royal Crest Egg"] = 48,
                ["Stellarite Egg"] = 50,
                ["Skull Cracker Egg"] = 52,
                ["Draconic Azure Egg"] = 54
            }
            local args = {
                [1] = {
                    ["eggName"] = "Egg "..Eggs[Name],
                    ["auto"] = false,
                    ["amount"] = 1
                }
            }
            r:InvokeServer(unpack(args))
        end
    end

    local function autoBuyEggs()
        local eggMod = require(game:GetService("ReplicatedStorage").ClientModules.Controllers.AfterLoad.EggOpenController)
        task.spawn(function()
            while task.wait() do
                if not getgenv().BUYEGGS then break end
                buyEgg(getgenv().EGG)
                task.wait(3)
                eggMod:Reset()
            end
        end)
    end

    local function equipBestPets()
        local r = Svc.RepStor.Packages.Knit.Services.PetInvService.RF.EquipBest
        if r then
            r:InvokeServer()
        end
    end

    local function autoEquipBestPets()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().EQUIPBESTPETS then break end
                equipBestPets()
            end
        end)
    end

    local function claimChests()
        local Chests = Svc.RepStor.SharedAssets.Chests
        for _, v in pairs(Chests:GetChildren()) do
            local Event = Svc.RepStor.Packages.Knit.Services.ChestService.RF.ClaimChest
            Event:InvokeServer(v.Name)
        end
    end

    local function autoClaimChests()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CLAIMCHESTS then break end
                claimChests()
                task.wait(7200)
            end
        end)
    end

    local function claimVIP()
        pcall(function()
            local VIP = Lp.PlayerGui.VIP
            local Background = VIP:FindFirstChild("Background")
            if Background then
                local ClaimButton = Background.InfoDisplay.ClaimBox.ClaimButton
                local FreeClaim = Background.Main.ExclusiveChests.List["1"].PurchaseButton.Button
                if ClaimButton then
                    firesignal(ClaimButton.Activated)
                end
                if FreeClaim then
                    firesignal(FreeClaim.Activated)
                end
            end
        end)
    end

    local function claimGifts()
        local r = Svc.RepStor.Packages.Knit.Services.TimedPacksService.RF.ClaimFreePack
        local g = { "Daily", "Weekly" }
        if r then
            for i, v in pairs(g) do
                r:InvokeServer(v)
            end
        end
        claimVIP()
    end

    local function autoClaimGifts()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CLAIMGIFTS then break end
                claimGifts()
                task.wait(43200)
            end
        end)
    end

    local function useBoosts()
        local r = Svc.RepStor.Packages.Knit.Services.BoostService.RF.UseBoost
        if r then
            local t = {"Power", "Damage", "Luck", "Coins", "SecretLuck"}
            local d = {"300", "600", "900", "1200", "1500"}
            for _, type in pairs(t) do
                for _, dur in pairs(d) do
                    if not getgenv().USEBOOSTS then break end
                    r:InvokeServer(type, dur)
                    task.wait(0.3)
                end
            end
        end
    end

    local function autoUseBoosts()
        task.spawn(function()
            while task.wait() do
                if not getgenv().USEBOOSTS then break end
                useBoosts()
                task.wait(5)
            end

        end)
    end

    local function getButtons()
        local results = {}
        for _, v in ipairs(Svc.Ws.Live.Dungeons:GetDescendants()) do
            if v.Name == "ContinueButton" then
               table.insert(results, v)
            end
        end
        return results
    end

    local function continueDungeon()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DungeonService"):WaitForChild("RF"):WaitForChild("ContinueDungeon")
        if r then
            local UIDs = {}
            for _, v in pairs(Svc.Ws.Live.Dungeons:GetDescendants()) do
                local UID = v:GetAttribute("UID")
                if UID then
                    table.insert(UIDs, UID)
                end
            end
            for _, v in pairs(UIDs) do
                r:InvokeServer(v)
            end
        end
    end

    local function joinDungeonLobby()
        getgenv().mobsToggle:Set(false)
        getgenv().questToggle:Set(false)
        task.wait(2)
        local Input = Svc.Ws.Resources.Gamemodes.DungeonLobby.Input
        Chr:PivotTo(Input:GetPivot())
        task.wait(2)
        pressKey(Enum.KeyCode.E)
        task.wait()
        releaseKey(Enum.KeyCode.E)
        repeat task.wait(1) until Region == "Dungeon"
    end

    local function runDungeon()
        repeat task.wait(1) until Lp:GetAttribute("InDungeon")
        getgenv().mobsToggle:Set(true)
        task.spawn(function()
            while Lp:GetAttribute("InDungeon") do
                if not getgenv().DUNGEONS then break end
                if #returnMobs() < 1 then
                    continueDungeon()
                end
                task.wait(3)
            end
            tpTo(1)
        end)
    end

    local function autoDungeons()
        local Timers = Svc.Ws.Resources.Gamemodes.DungeonLobby.Timers
        local JoinParts = Svc.Ws.Resources.Gamemodes.DungeonLobby.JoinParts
        local wasQuesting = getgenv().AUTOQUEST
        local timerConnection
        if Region ~= "Dungeon" then
            alert("Dungeon Farm", "Joining dungeon Lobby to check timers.")
            joinDungeonLobby()
        end
        for _, v in ipairs(Timers:GetChildren()) do
            if v.Name == getgenv().SELDUNGEON then
                if timerConnection then
                    timerConnection:Disconnect()
                    timerConnection = nil
                end
                timerConnection = v.Timer.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
                    if getgenv().DUNGEONS and v.Name == getgenv().SELDUNGEON and v.Timer.TextLabel.Text == "01:01" then
                        alert(v.Name, "Opening soon...", 5)
                        joinDungeonLobby()
                        task.wait(5)
                        local JoinPart = JoinParts:WaitForChild(v.Name)
                        Chr:PivotTo(JoinPart:GetPivot())
                        alert(v.Name, "Waiting for Dungeon to start...", 50)
                        runDungeon()
                    end
                end)
                break
            end
        end
        task.wait(3)
        tpTo(1)
        if wasQuesting then
            alert("Auto Questing", "Continuing to Quest.")
            getgenv().questToggle:Set(true)
        end
    end

    local function getEquippedPets()
        local PetScrolling = Lp.PlayerGui.PetInv.Background.ImageFrame.Window.PetHolder.PetScrolling
        local results = {}
        for _, v in pairs(PetScrolling:GetChildren()) do
            if v:FindFirstChild("Frame").Equipped.Visible then
                table.insert(results, v)
            end
        end
        return results
    end

    local function farmBoss()
        alert("Boss Farm", "Checking if Global Boss is available.")
        local wasQuesting = getgenv().AUTOQUEST
        local Input = Svc.Ws.Resources.Teleports["Global Boss"].Input
        Chr:PivotTo(Input:GetPivot())
        task.wait(2)
        pressKey(Enum.KeyCode.E)
        releaseKey(Enum.KeyCode.E)
        task.wait(3)
        if #returnMobs() > 0 then
            alert("Boss Farm", "Fighting Global Boss.")
            getgenv().mobsToggle:Set(true)
            repeat task.wait(1) until #returnMobs() < 1
        else
            tpTo(1)
            task.wait(3)
            if wasQuesting then
                alert("Auto Questing", "Continuing to Quest.")
                getgenv().questToggle = true
            end
        end
    end

    local function autoBoss()
        task.spawn(function()
            while task.wait() do
                if not getgenv().FARMBOSS then break end
                farmBoss()
            end
        end)
    end

    -- Tabs

    local AreaTeleportSect = GameTab:AddSection({
        Name = "Teleports"
    })

    AreaTeleportSect:AddDropdown({
        Name = "Teleport to Area",
        Default = "",
        Options = Areas,
        Callback = function(Value)
            local areaIndex = table.find(Areas, Value)
            if areaIndex then
                tpTo(areaIndex)
            end
        end
    })

    local GameToggleSect = GameTab:AddSection({
        Name = "Auto Claim Toggles"
    })

    GameToggleSect:AddToggle({
        Name = "Daily Chests",
        Default = false,
        Save = true,
        Flag = "CLAIMCHESTS",
        Callback = function(Value)
            getgenv().CLAIMCHESTS = Value
            if Value then
                autoClaimChests()
            end
        end
    })

    GameToggleSect:AddToggle({
        Name = "Daily VIP & Daily/Weekly Gifts",
        Default = false,
        Save = true,
        Flag = "CLAIMGIFTS",
        Callback = function(Value)
            getgenv().CLAIMGIFTS = Value
            if Value then
                autoClaimGifts()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Use Boosts",
        Default = false,
        Save = true,
        Flag = "USEBOOSTS",
        Callback = function(Value)
            getgenv().USEBOOSTS = Value
            if Value then
                autoUseBoosts()
            end
        end
    })

    local FarmingTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    local AreaSect = FarmingTab:AddSection({
        Name = "Auto Toggles"
    })

    getgenv().swingToggle = AreaSect:AddToggle({
        Name = "Swing Weapon",
        Default = false,
        Save = true,
        Flag = "SWING",
        Callback = function(Value)
            getgenv().SWING = Value
            if Value then
                autoSwing()
            end
        end
    })

    getgenv().spellToggle = AreaSect:AddToggle({
        Name = "Cast Spells",
        Default = false,
        Save = true,
        Flag = "SPELLS",
        Callback = function(Value)
            getgenv().SPELLS = Value
            if Value then
                autoSpells()
            end
        end
    })

    getgenv().mobsToggle = AreaSect:AddToggle({
        Name = "Kill Mobs",
        Default = false,
        Save = true,
        Flag = "MOBS",
        Callback = function(Value)
            getgenv().MOBS = Value
            if Value then
                killMobs()
            end
        end
    })

    local DungeonSect = FarmingTab:AddSection({
        Name = "Dungeons"
    })

    DungeonSect:AddDropdown({
        Name = "Select Dungeon Difficulty",
        Default = "Easy",
        Options = { "Easy", "Hard", "Insane" },
        Callback = function(Value)
            local translateName = {
                ["Easy"] = "Dungeon 1",
                ["Hard"] = "Dungeon 2",
                ["Insane"] = "Dungeon 3"
            }
            getgenv().SELDUNGEON = translateName[Value]
        end
    })

    getgenv().dungeonToggle = DungeonSect:AddToggle({
        Name = "Farm Selected Dungeon",
        Default = false,
        Save = true,
        Flag = "DUNGEONS",
        Callback = function(Value)
            getgenv().DUNGEONS = Value
            if Value then
                autoDungeons()
            end
        end
    })

    local BossSect = FarmingTab:AddSection({
        Name = "Global Boss"
    })

    local QuestSect = FarmingTab:AddSection({
        Name = "Auto Questing"
    })

    getgenv().questToggle = QuestSect:AddToggle({
        Name = "Complete Quests",
        Default = false,
        Save = true,
        Flag = "AUTOQUEST",
        Callback = function(Value)
            getgenv().AUTOQUEST = Value
            if Value then
                getgenv().bossToggle:Set(false)
                autoQuest()
            end
        end
    })

    getgenv().bossToggle = BossSect:AddToggle({
        Name = "Farm Global Boss",
        Default = false,
        Save = true,
        Flag = "FARMBOSS",
        Callback = function(Value)
            getgenv().FARMBOSS = Value
            if Value then
                autoBoss()
            end
        end
    })

    local UpgradeTab = Window:MakeTab({
        Name = "Upgrades",
        Icon = Icons.Upgrade,
        PremiumOnly = false
    })

    local WeaponSect = UpgradeTab:AddSection({
        Name = "Weapons"
    })

    WeaponSect:AddToggle({
        Name = "Always Equip Best Weapon",
        Default = false,
        Save = true,
        Flag = "EQUIPBEST",
        Callback = function(Value)
            getgenv().EQUIPBEST = Value
            if Value then
                autoEquipBest()
            end
        end
    })

    WeaponSect:AddToggle({
        Name = "Auto Forge Weapons",
        Default = false,
        Save = true,
        Flag = "FORGE",
        Callback = function(Value)
            getgenv().FORGE = Value
            if Value then
                autoForge()
            end
        end
    })

    WeaponSect:AddToggle({
        Name = "Sell Weapons When Full",
        Default = false,
        Save = true,
        Flag = "AUTOSELL",
        Callback = function(Value)
            getgenv().AUTOSELL = Value
            if Value then
                autoSell()
            end
        end
    })

    local PortalSkillSect = UpgradeTab:AddSection({
        Name = "Skills & Portals"
    })

    PortalSkillSect:AddToggle({
        Name = "Upgrade Skills",
        Default = false,
        Save = true,
        Flag = "UPGRADE",
        Callback = function(Value)
            getgenv().UPGRADE = Value
            if Value then
                autoUpgrade()
            end
        end
    })

    PortalSkillSect:AddToggle({
        Name = "Buy Portals",
        Default = false,
        Save = true,
        Flag = "BUYPORTALS",
        Callback = function(Value)
            getgenv().BUYPORTALS = Value
            if Value then
                autoBuyPortals()
            end
        end
    })

    local RebirthSect = UpgradeTab:AddSection({
        Name = "Rebirths"
    })

    RebirthSect:AddToggle({
        Name = "Ascend",
        Default = false,
        Save = true,
        Flag = "ASCEND",
        Callback = function(Value)
            getgenv().ASCEND = Value
            if Value then
                autoAscend()
            end
        end
    })

    local PetsTab = Window:MakeTab({
        Name = "Pets & Eggs",
        Icon = Icons.Egg,
        PremiumOnly = false
    })

    local PetsSect = PetsTab:AddSection({
        Name = "Pets"
    })

    PetsSect:AddToggle({
        Name = "Always Equip Best Pets",
        Default = false,
        Save = true,
        Flag = "EQUIPBESTPETS",
        Callback = function(Value)
            getgenv().EQUIPBESTPETS = Value
            if Value then
                autoEquipBestPets()
            end
        end
    })

    local EggSect = PetsTab:AddSection({
        Name = "Auto Buy Eggs"
    })

    EggSect:AddDropdown({
        Name = "Select an Egg Type",
        Default = "Weak Egg",
        Options = { "Weak Egg", "Strong Egg", "Paradise Egg", "Bamboo Egg", "Frozen Egg", "Soft Egg", "Lava Egg", "Mummified Egg", "Lost Egg", "Ore Egg", "Leaf Egg", "Aquatic Egg", "Holy Egg", "Canyon Egg", "Titanic Egg", "Underwated Egg", "Molten Egg", "Mystic Kitsune Egg", "Lantern Egg", "Timber Knight Egg", "Armored Cocoon Egg", "Cosmic Egg", "Cyborg Egg", "Toxic Tesseract Egg", "Royal Crest Egg", "Stellarite Egg", "Skull Cracker Egg", "Draconic Azure Egg" },
        Callback = function(Value)
            getgenv().EGG = Value
        end
    })

    EggSect:AddToggle({
        Name = "Enabled",
        Default = false,
        Save = true,
        Flag = "BUYEGGS",
        Callback = function(Value)
            getgenv().BUYEGGS = Value
            if Value then
                autoBuyEggs()
            end
        end
    })

elseif game.PlaceId == 11542692507 then -- Anime Souls Simulator

    -- Values

    Codes = {
        Remote = Svc.RepStor.Remotes.Server,
        List = {
            '80klikes',
            'morebuffs',
            'fastshutdown',
            'update10',
            'subopen',
            'l3ni',
            'leozimgamers',
            'OPENSAMU',
            'sorryforkaido',
            '35klikes',
            'badaccessories',
            'infinitesouls',
            'sorryforglobalboss',
            'update9',
            'sorryguys',
            'update8',
            '70klikes',
            'update7',
            'UPDATE6',
            '60KLIKES',
            'update5',
            'update4.5',
            'update4',
            'THXGUYS1',
            'THXGUYS2',
            '45klikes',
            '35klikes',
            'sorryforshutdowns2',
            'UPDATE3',
            'UPDATE3DELAY',
            'update2.5',
            '10kfavorites',
            '5MVISITS',
            '25klikes',
            'UPDATE2',
            'sorryforshutdowns',
            'UPD1.5',
            '15klikes',
            '10kactives',
            'update1',
            '5kfavorites',
            '200kmembers',
            '150KMEMBERS',
            '1MVISITS',
            '10KLIKES',
            'freespins',
            '5KLIKES',
            '1KLIKES',
            '1KACTIVES',
            '1KFAVORITES',
            '50KVISITS',
            '1KMEMBERS',
            'RELEASE'
        }
    }

    for i, v in pairs(Codes.List) do
        Codes.List[i] = { [1] = "Codes", [2] = v }
    end

    -- Functions

    local function getAchievements()
        local Scroll = Lp.PlayerGui.CenterUI.Achievements.Main.Scroll
        local r = {}
        for _, v in pairs(Scroll:GetChildren()) do
            if v.ClassName == "ImageLabel" then
                table.insert(r, v.Name)
            end
        end
        return r
    end

    local function claim()
        local Event = Svc.RepStor.Remotes.Server
        local a = getAchievements()
        for _, v in pairs(a) do
            local args = {[1] = "Achievements", [2] = v}
            Event:FireServer(args)
            task.wait()
        end
    end

    local function autoClaim()
        task.spawn(function()
            while task.wait() do
                if not getgenv().AUTOCLAIM then break end
                claim()
                task.wait(60)
            end
        end)
    end

    local function class()
        local A_1 = {[1] = "Class"}
        local Event = Svc.RepStor.Remotes.Server
        Event:FireServer(A_1)
    end

    local function autoClass()
        task.spawn(function()
            while task.wait() do
                if not getgenv().AUTOCLASS then break end
                class()
                task.wait(5)
            end
        end)
    end

    local function TP(num)
        if num == 1 then
            num = "Cave"
        else
            num = num - 1
        end
        local A_1 = {[1] = "Teleport", [2] = num}
        local Event = Svc.RepStor.Remotes.Server
        Event:FireServer(A_1)
    end

    local function isMeteor()
        return #Svc.Ws["_METEORS"]:GetChildren() > 0
    end

    local function isBoss()
        return #Svc.Ws["_GLOBAL_BOSSES"]:GetChildren() > 0
    end

    local function area()
        local Scroll = Lp.PlayerGui.CenterUI.Teleport.Main.Scroll
        local r = {}
        for _, v in pairs(Scroll:GetDescendants()) do
            if v.ClassName == "ImageButton" and v.Name == "TP" then
                if v.Visible then
                    table.insert(r, v)
                end
            end
        end
        return r
    end

    local function areaNames()
        local n = {}
        for i, v in ipairs(area()) do
            local t = v.Parent.Title.Text
            table.insert(n, i, t)
        end
        return n
    end

    local function questTurnIn()
        local A_1 = {[1] = "Quest"}
        local Event = Svc.RepStor.Remotes.Server
        Event:FireServer(A_1)
    end

    local function questCompleted()
        local completed = Lp.PlayerGui["_QUEST"].Background.Objectives.main.completed
        return completed.Visible
    end

    local function autoQuest()
        task.spawn(function()
            while task.wait() do
                if not getgenv().AUTOQUEST then break end
                if not isMeteor() and not isBoss() and questCompleted() then
                    TP(#area())
                end
                questTurnIn()
                task.wait(10)
            end
        end)
    end

    local function usePotions()
        local Event = Svc.RepStor.Remotes.Server
        local p = {"energy", "souls", "damage", "lucky"}
        for _, v in pairs(p) do
            local args = {[1] = "Potions", [2] = v}   
            Event:FireServer(args)
            task.wait(0.5)
        end
    end

    local function autoPotions()
        task.spawn(function()
            while task.wait() do
                if not getgenv().POTIONS then break end
                usePotions()
                task.wait(30)
            end
        end)
    end

    local function upgradeSword()
        local Event = Svc.RepStor.Remotes.Server
        local A_1 = {[1] = "Swords"}
        Event:FireServer(A_1)
    end

    local function autoSwords()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SWORDS then break end
                upgradeSword()
                task.wait(5)
            end
        end)
    end

    local function swordMaster()
        local Event = Svc.RepStor.Remotes.Server
        local A_1 = {[1] = "SpecialQuest", [2] = "Swordmaster"}
        Event:FireServer(A_1)
    end

    local function autoMaster()
        task.spawn(function()
            while task.wait() do
                if not getgenv().MASTER then break end
                swordMaster()
                task.wait(5)
            end
        end)
    end

    -- local function redeemCode(code)
    --     local code = {[1] = "Codes", [2] = code}
    --     local Event = Svc.RepStor.Remotes.Server
    --     Event:FireServer(code)
    -- end

    -- local function redeemCodes()
    --     local codes = {
    --         '80klikes',
    --         'morebuffs',
    --         'fastshutdown',
    --         'update10',
    --         'subopen',
    --         'l3ni',
    --         'leozimgamers',
    --         'OPENSAMU',
    --         'sorryforkaido',
    --         '35klikes',
    --         'badaccessories',
    --         'infinitesouls',
    --         'sorryforglobalboss',
    --         'update9',
    --         'sorryguys',
    --         'update8',
    --         '70klikes',
    --         'update7',
    --         'UPDATE6',
    --         '60KLIKES',
    --         'update5',
    --         'update4.5',
    --         'update4',
    --         'THXGUYS1',
    --         'THXGUYS2',
    --         '45klikes',
    --         '35klikes',
    --         'sorryforshutdowns2',
    --         'UPDATE3',
    --         'UPDATE3DELAY',
    --         'update2.5',
    --         '10kfavorites',
    --         '5MVISITS',
    --         '25klikes',
    --         'UPDATE2',
    --         'sorryforshutdowns',
    --         'UPD1.5',
    --         '15klikes',
    --         '10kactives',
    --         'update1',
    --         '5kfavorites',
    --         '200kmembers',
    --         '150KMEMBERS',
    --         '1MVISITS',
    --         '10KLIKES',
    --         'freespins',
    --         '5KLIKES',
    --         '1KLIKES',
    --         '1KACTIVES',
    --         '1KFAVORITES',
    --         '50KVISITS',
    --         '1KMEMBERS',
    --         'RELEASE'
    --     }
    --     for _, v in pairs(codes) do
    --         redeemCode(v)
    --         task.wait(0.5)
    --     end
    -- end

    local function claimReward(number)
        local Event = Svc.RepStor.Remotes.Server
        local A_1 = {[1] = "DailyRewards", [2] = tostring(number)}
        Event:FireServer(A_1)
    end

    local function resetRewards()
        local Event = Svc.RepStor.Remotes.Server
        local A_1 = {[1] = "DailyRewards", [2] = "reset"}
        Event:FireServer(A_1)
    end

    local function autoRewards()
        task.spawn(function()
            while task.wait() do
                if not getgenv().REWARDS then break end
                for i = 1, 10 do
                    claimReward(i)
                    task.wait(0.5)
                end
                resetRewards()
                task.wait(60)
            end
        end)
    end

    local function buyHero(args)
        local Event = Svc.RepStor.Remotes.Server
        local A_1 = {[1] = "BuyHeroes", [2] = args}
        Event:FireServer(A_1)
    end

    local function buyHeroes()
        local EGGS = Svc.Ws["_EGGS"]
        for _, v in pairs(EGGS:GetDescendants()) do
            if v.Name == "Range" and v.ClassName == "Part" then
                if v and HumRP then
                    local mycf = HumRP.CFrame
                    HumRP.CFrame = v.CFrame + Vector3.new(3, 0, 0)
                    task.wait(1)
                    buyHero(v.Parent.Name)
                end
            end
        end
    end

    local function autoHeroes()
        task.spawn(function()
            while task.wait() do
                if not getgenv().HEROES then break end
                buyHeroes()
                task.wait(5)
            end
        end)
    end

    local function hit(target)
        local t = {}
        table.insert(t, "Hit")
        if target then
            table.insert(t, target)
        end
        local Event = Svc.RepStor:WaitForChild("Remotes"):WaitForChild("Server")
        Event:FireServer(t)
    end

    local function autoClick()
        task.spawn(function()
            while task.wait() do
                if not getgenv().CLICK then break end
                local t = Chr:FindFirstChild("_target")
                hit(t.Value)
            end
        end)
    end

    local function getTarget()
        local e = Svc.Ws["_ENEMIES"]
        local desc = Lp.PlayerGui["_QUEST"].Background.Objectives.main["in_progress"]["_desc"]
        local text = string.split(desc.Text, " ")
        local string = string.lower(text[3])
        local letter = string:sub(1, 1)
        local qe, en = {}, {}
        local target
        for _, v in pairs(e:GetDescendants()) do
            if v.ClassName == "Model" and v:FindFirstChild("HumanoidRootPart") then
                table.insert(en, v)
            end
        end
        for _, v in pairs(en) do
            local n = string.split(v.Name, "_")[1]
            local f = string.sub(n, 1, 1)
            if f == letter then
                table.insert(qe, v)
            end
        end
        if #qe < 1 and letter == "c" then
            desc = Lp.PlayerGui["_QUEST"].Background.Objectives.main["final_stage"]["_desc"]
            text = string.split(desc.Text, " ")
            string = string.lower(text[3])
            letter = string:sub(1, 1)
        end
        for _, v in pairs(en) do
            local n = string.split(v.Name, "_")[1]
            local f = string.sub(n, 1, 1)
            if f == letter then
                table.insert(qe, v)
            end
        end
        if #qe > 0 then
            target = qe[math.random(1, #qe)]
        elseif not target and #en > 0 then
            target = en[math.random(1, #en)]
        end
        if HumRP and target then
            HumRP.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
        end
    end

    local function farmMobs()
        getTarget()
        Svc.Ws[Lp.Name]:FindFirstChild("_target"):GetPropertyChangedSignal("Value"):Connect(function()
            task.wait(3)
            if getgenv().FARM and Svc.Ws[Lp.Name]["_target"].Value == nil and not isMeteor() then
                if not isMeteor() then
                    getTarget()
                    task.wait(5)
                end
            end
        end)
    end

    local function getMeteor(model)
        for _, v in pairs(model:GetChildren()) do
            local stats = model:FindFirstChildWhichIsA()
        end
    end

    local function farmMeteors()
        local m = Svc.Ws["_METEORS"]
        task.spawn(function()
            while task.wait() do
                if not getgenv().METEORS then break end
                if isMeteor() then
                    local ms = m:GetChildren()
                    getMeteor(ms[math.random(1, #ms)])
                end
                task.wait(1)
            end
        end)
    end

    local function getBoss()
        local b = Svc.Ws["_GLOBAL_BOSSES"]
        for _, v in pairs(b:GetChildren()) do
            local bhrp = v:FindFirstChild("HumanoidRootPart")
            if bhrp then
                if v.Position then
                    Chr:MoveTo(v.Position)
                    break
                end
            end
        end
    end

    local function farmGlobalBoss()
        local v = Lp.PlayerGui.GlobalBoss.Request
        task.spawn(function()
            while task.wait() do
                if not getgenv().GLOBALBOSS then break end
                if v.Visible then
                    task.wait(3)
                    firesignal(v.Accept.Activated)
                end
                if isBoss() then
                    getBoss()
                    task.wait(10)
                end
                task.wait(1)
            end
        end)
    end

    local function aura()
        local A_1 = 
        {
            [1] = "Auras"
        }
        local Event = Svc.RepStor.Remotes.Server
        Event:FireServer(A_1)
    end

    -- Tabs

    GameTab:AddToggle({
        Name = "Claim Achievements",
        Default = false,
        Save = true,
        Flag = "AUTOCLAIM",
        Callback = function(Value)
            getgenv().AUTOCLAIM = Value
            if Value then
                autoClaim()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Claim Daily Rewards",
        Default = false,
        Save = true,
        Flag = "REWARDS",
        Callback = function(Value)
            getgenv().REWARDS = Value
            if Value then
                autoRewards()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Use Potions",
        Default = false,
        Save = true,
        Flag = "POTIONS",
        Callback = function(Value)
            getgenv().POTIONS = Value
            if Value then
                autoPotions()
            end
        end
    })

    TeleportSect:AddDropdown({
        Name = "Teleport to Area",
        Default = areaNames()[1],
        Options = areaNames(),
        Callback = function(Value)
            TP(table.find(areaNames(), Value))
        end
    })

    local FarmingTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    FarmingTab:AddToggle({
        Name = "Auto Click",
        Default = false,
        Save = true,
        Flag = "CLICK",
        Callback = function(Value)
            getgenv().CLICK = Value
            if Value then
                autoClick()
            end
        end
    })

    getgenv().mobsToggle = FarmingTab:AddToggle({
        Name = "Mobs",
        Default = false,
        Save = true,
        Flag = "FARM",
        Callback = function(Value)
            getgenv().FARM = Value
            if Value then
                farmMobs()
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Meteors",
        Default = false,
        Save = true,
        Flag = "METEORS",
        Callback = function(Value)
            getgenv().METEORS = Value
            if Value then
                farmMeteors()
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Global Boss",
        Default = false,
        Save = true,
        Flag = "GLOBALBOSS",
        Callback = function(Value)
            getgenv().GLOBALBOSS = Value
            if Value then
                farmGlobalBoss()
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Auto Complete Quests",
        Default = false,
        Save = true,
        Flag = "AUTOQUEST",
        Callback = function(Value)
            getgenv().AUTOQUEST = Value
            if Value then
                autoQuest()
            end
        end
    })

    FarmingTab:AddToggle({
        Name = "Auto Complete Swordmaster Quests",
        Default = false,
        Save = true,
        Flag = "MASTER",
        Callback = function(Value)
            getgenv().MASTER = Value
            if Value then
                autoMaster()
            end
        end
    })

    local BuyTab = Window:MakeTab({
        Name = "Upgrades",
        Icon = Icons.Money,
        PremiumOnly = false
    })

    BuyTab:AddToggle({
        Name = "Auto Upgrade Class",
        Default = false,
        Save = true,
        Flag = "AUTOCLASS",
        Callback = function(Value)
            getgenv().AUTOCLASS = Value
            if Value then
                autoClass()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Auto Upgrade Swords",
        Default = false,
        Save = true,
        Flag = "SWORDS",
        Callback = function(Value)
            getgenv().SWORDS = Value
            if Value then
                autoSwords()
            end
        end
    })

    BuyTab:AddToggle({
        Name = "Auto Buy Heroes",
        Default = false,
        Save = true,
        Flag = "HEROES",
        Callback = function(Value)
            getgenv().HEROES = Value
            if Value then
                autoHeroes()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Hide Achievement Spam",
        Default = false,
        Save = true,
        Flag = "SPAM",
        Callback = function(Value)
            if Value then
                Lp.PlayerGui.Notification.Enabled = false
            else
                Lp.PlayerGui.Notification.Enabled = true
            end
        end
    })

    GameTab:AddToggle({
        Name = "Hide Name Tag",
        Default = false,
        Save = true,
        Flag = "TAG",
        Callback = function(Value)
            if Value then
                Chr.Head["player_tag"].Enabled = false
            else
                Chr.Head["player_tag"].Enabled = true
            end
        end
    })

elseif game.PlaceId == 12017032683 then -- 096: SCP

    -- Values



    -- Functions

    local function returnObjs(loc, typ)
        local results = {}
        for _, v in pairs(loc:GetChildren()) do
            local t = v:GetAttribute("Type")
            if t == typ then
                table.insert(results, v)
            end
        end
        return results
    end

    local function consumeFood()
        local foods = returnObjs(Svc.RepStor.Foods, "Food")
        if #foods > 0 then
            local n = foods[math.random(1, #foods)].Name
            if n then
                Svc.RepStor:WaitForChild("Remotes"):WaitForChild("Backpack"):FireServer("Consume", n)
            end
        end
    end

    local function maxStats()
        local my = {"Health", "Hunger", "Energy"}
        for _, v in ipairs(my) do
            local attr = Lp:GetAttribute(v)
            if attr then
                Lp:GetAttributeChangedSignal(v):Connect(function()
                    if getgenv().MAXSTATS and attr < 100 then
                        consumeFood()
                        task.wait(1)
                    end
                end)
            end
        end
    end

    local function maxBackpack()
        Lp:SetAttribute("HasExplorer", true)
        task.wait()
        Lp:SetAttribute("BackpackSlots", 70)
        task.wait()
        Lp:SetAttribute("BackpackSpace", 70)
    end

    local function getPartNames()
        local results = {}
        local lastPart = ""
        for _, v in ipairs(Svc.Ws.Interact:GetChildren()) do
            if v.Name ~= lastPart and not v:GetAttribute("Type") and v:FindFirstChild("Hitbox") then
                lastPart = v.Name
                table.insert(results, v.Name)
            end
        end
        table.sort(results, sort_alphabetical)
        return results
    end

    local function getMatches(partName)
        local matches = {}
        for _, v in pairs(Svc.Ws.Interact:GetChildren()) do
            if v.Name == partName then
                table.insert(matches, v)
            end
        end
        return matches
    end

    local function spawnPart(partName)
        local rnd = math.random(-10, 10)
        local m = getMatches(partName)
        local newPart = m[math.random(1, #m)].PrimaryPart
        if newPart then
            local newCf = HumRP.CFrame + Vector3.new(rnd, 0, rnd)
            newPart.Anchored = not newPart.Anchored
            newPart:SetAttribute("CFrame", newCf)
            newPart.CFrame = newCf
            newPart.CanCollide = true
        end
    end

    local function grantPerms()
        local s = Instance.new("StringValue")
        s.Name = Lp.Name
        for _, p in pairs(Svc.Plrs:GetPlayers()) do
            if not p["Perms"]:FindFirstChild(Lp.Name) then
                s:Clone().Parent = p["Perms"]
            end
        end
    end

    local function getSCP()
        local scp096 = Svc.Ws:FindFirstChild("SCP-096") or Svc.RepStor:FindFirstChild("SCP-096")
        -- local scp173 = Svc.Ws:FindFirstChild("SCP-173") or Svc.RepStor:FindFirstChild("SCP-173")
        return scp096
    end

    local function toolAction()
        Svc.RepStor:WaitForChild("Remotes"):WaitForChild("ToolAction"):FireServer()
    end

     local function equipTool(toolName)
         local mats = {"Wood", "Stone", "Iron"}
         for _, m in ipairs(mats) do
             local t = m.." "..toolName
             local args = {
                    [1] = "Equip",
                    [2] = t,
                    [3] = "Tool"
                }
             Svc.RepStor:WaitForChild("Remotes"):WaitForChild("Backpack"):FireServer(unpack(args))
             task.wait(0.1)
         end
     end

    local function farmMats(resource)
        local Decoration = Svc.Ws.Decoration
        local nodes = {}
        if resource == "Stone" then
            equipTool("Pickaxe")
        elseif resource == "Tree" then
            equipTool("Axe")
        end
        for _, v in ipairs(Decoration:GetChildren()) do
            if not getgenv().FARM then break end
            if v:GetAttribute("Type") == resource then
                table.insert(nodes, v)
            end
        end
        task.spawn(function()
            while getgenv().FARM do
                for _, v in pairs(nodes) do
                    local u = v:FindFirstChild("Union")
                    if u and u.CanCollide then
                        u.CanCollide = not u.CanCollide
                    end
                    while v.Parent ~= nil do
                        Chr:PivotTo(v:GetPivot())
                        if not getgenv().FARM then break end
                        toolAction()
                        task.wait(0.2)
                    end
                end
            end
        end)
    end

    -- Tabs

    GameTab:AddToggle({
        Name = "Maximum Health, Energy, Hunger",
        Default = false,
        Save = true,
        Flag = "MAXSTATS",
        Callback = function(Value)
            getgenv().MAXSTATS = Value
            if Value then
                maxStats()
            end
        end
    })

    getgenv().scpDropdown = TeleportSect:AddDropdown({
        Name = "Teleport SCP To Player",
        Default = "",
        Options = getPlayerNames(),
        Callback = function(Value)
            getgenv().scpDropdown:Refresh(getPlayerNames(), true)
            task.spawn(function()
                local scp = getSCP():FindFirstChildOfClass("Humanoid")
                if scp then
                    local tar = Svc.Ws:FindFirstChild(Value)
                    if tar then
                        scp.WalkSpeed = 300
                        scp.Parent:PivotTo(tar:GetPivot() + Vector3.new(5, 5, 0))
                        scp:SetAttribute("CanAggro", true)
                    end
                end
            end)
        end
    })

    local EnvTab = Window:MakeTab({
        Name = "Environment",
        Icon = Icons.Runner,
        PremiumOnly = false
    })

    EnvTab:AddToggle({
        Name = "Unlock Map",
        Default = false,
        Save = true,
        Flag = "MAP",
        Callback = function(Value)
            if Value then
                task.spawn(function()
                    local env = getsenv(Lp.PlayerGui.Main.Controller)
                    if env then
                        env:startMap()
                    end
                end)
            end
        end
    })

    EnvTab:AddToggle({
        Name = "Bypass Permissions",
        Default = false,
        Save = true,
        Flag = "PERMS",
        Callback = function(Value)
            if Value then
                grantPerms()
            end
        end
    })

    local InvTab = Window:MakeTab({
        Name = "Inventory",
        Icon = Icons.Inventory,
        PremiumOnly = false
    })

    InvTab:AddToggle({
        Name = "Maximum Backpack Space",
        Default = false,
        Save = true,
        Flag = "BACKPACK",
        Callback = function(Value)
            if Value then
                maxBackpack()
            end
        end
    })

    getgenv().partsDropdown = InvTab:AddDropdown({
        Name = "Bring Parts",
        Default = "",
        Options = getPartNames(),
        Callback = function(Value)
            spawnPart(Value)
            getgenv().partsDropdown:Refresh(getPartNames(), true)
        end
    })

    InvTab:AddDropdown({
        Name = "Select a Resource",
        Default = "Tree",
        Options = {"Stone", "Tree"},
        Callback = function(Value)
            getgenv().RESOURCE = Value
        end
    })

    InvTab:AddToggle({
        Name = "Auto Farm Resources",
        Default = false,
        Save = true,
        Flag = "FARM",
        Callback = function(Value)
            getgenv().FARM = Value
            if Value then
                farmMats(getgenv().RESOURCE)
            end
        end
    })

elseif game.PlaceId == 10534865425 then -- Hoop Simulator

    local function patchNotice()
        alert("Features Disabled...", "MaddHub detected the game is patched, some features will not be available.\nTo request an update join the discord:\n(discord.gg/tF4wX9e7SZ)", 3)
    end

    local function funcPath()
        local result
        for _, v in pairs(Svc.RepStor:GetChildren()) do
            if string.find(v.Name, "functions-") then
                result = Svc.RepStor:WaitForChild(v.Name)
                break
            end
        end
        return result
    end

    -- Values

    Codes = {
        Remote = funcPath():FindFirstChild("s:e3b986ff-f3be-437a-879c-07304fe93c08"),
        List = {
            '5KLIKES',
            'RELEASE',
            '10KLIKES',
            '25KLIKES'
        }
    }

    if not Codes.Remote then patchNotice() end

    function fireRedeem(Remote, List)
        for i = 1, #List do
            Remote:FireServer(List[i])
            task.wait(0.5)
        end
    end

    local function eventsPath()
        local result
        for _, v in pairs(Svc.RepStor:GetChildren()) do
            if string.find(v.Name, "events-") then
                result = Svc.RepStor:WaitForChild(v.Name)
                break
            end
        end
        return result
    end

    -- Functions

    local function claimRewards()
        local r = eventsPath():FindFirstChild("f9490bc2-4d9b-44bf-944a-c7dbba4a2274")
        if not r then return patchNotice() end
        for i = 0, 9 do
            if not getgenv().CLAIM then break end
            r:FireServer(i)
            task.wait(5)
        end
    end

    local function ballThrow()
        local storeExpanded = game:GetService("Players").LocalPlayer.PlayerGui.RightSideMenu["1"]:GetChildren()[4]
        repeat task.wait(1) until Svc.Ws.Camera.CameraSubject == Hum
        local btn = Lp.PlayerGui.BallThrow["1"]["2"]
        local buttonVisible = btn:GetChildren()[2]["2"].BackgroundTransparency == 0
        if not buttonVisible and storeExpanded.Visible then
            firesignal(storeExpanded.MouseButton1Click)
        else
            repeat task.wait(1) until btn:GetChildren()[2]["2"].Icon.ClassName == "Frame"
            firesignal(btn.MouseButton1Down)
            repeat task.wait() until Svc.Ws.Camera.BallThrow.Value < -2.9
            firesignal(btn.MouseButton1Up)
        end
    end

    local function upgradeSkills()
        local r = eventsPath():FindFirstChild("abdb2c68-7f53-454f-aaea-3f84b2766328")
        if not r then return patchNotice() end
        local s = { "speed", "strength", "accuracy" }
        for w = 1, 2 do
            for _, v in next, s do
                local args = {
                    [1] = v,
                    [2] = w
                }
                if not getgenv().UPGRADE then break end
                r:FireServer(unpack(args))
                task.wait(3)
            end
        end
    end

    local function getWorldNames()
        local results = {}
        for _, v in ipairs(Svc.Ws.Worlds:GetChildren()) do
            if v.ClassName == "Folder" then
                if tonumber(string.sub(v.Name, -1)) then
                    table.insert(results, v.Name)
                end
            end
        end
        return results
    end

    local function buyWorlds()
        local r = eventsPath():FindFirstChild("cce2ea4a-4b1c-4db0-8dc8-70859cfccf63")
        if not r then return patchNotice() end
        for i = 1, #getWorldNames() do
            if not getgenv().WORLDS then break end
            r:FireServer(i)
            task.wait(5)
        end
    end

    local function activateBoosts()
        local Store = game:GetService("Players").LocalPlayer.PlayerGui.Store.Store
        for _, v in pairs(Store:GetDescendants()) do
            if v.Name == "Use" then
                firesignal(v.MouseButton1Click)
            end
        end
    end

    local function getBalls()
        local Balls
        local Inventory = Lp.PlayerGui.Inventory:FindFirstChild("Inventory")
        if not Inventory then
            firesignal(Lp.PlayerGui.RightSideMenu["1"]["3"].MouseButton1Click)
            Inventory = Lp.PlayerGui.Inventory:WaitForChild("Inventory")
        end
        if Inventory then
            Balls = Inventory["1"]["1"].WindowContent.Balls:WaitForChild("2")
        end
        return Balls
    end

    local function getEquippedBall()
        local Balls = getBalls()
        task.wait(1)
        local result
        for _, v in ipairs(Balls:GetDescendants()) do
            if v.Name == "Checkmark" and v.Visible then
                result = v.Parent.Parent.Parent.Parent.Name
            end
        end
        return result
    end

    local function getCapsules()
        local Capsules = Svc.RepStor.GameObjects.Capsules
        local results = {}
        for _, v in pairs(Capsules:GetChildren()) do
            table.insert(results, v.Name)
        end
        return results
    end

    local function buyTeleports(worlds)
        local r = eventsPath():FindFirstChild("0feeb1b0-96b1-40ae-af1f-e105fb2be565")
        if not r then return patchNotice() end
        if #worlds > 0 then
            for i = 1, #worlds do
                if not getgenv().TELEPORTS then break end
                r:FireServer(i)
                task.wait(5)
            end
        end
    end

    local function togglePopups()
        local items = {
            Store = Lp.PlayerGui.Store,
            Notifications = Lp.PlayerGui.Notifications,
            Blur = Svc.Light:FindFirstChildOfClass("BlurEffect")
        }
        for _, v in pairs(items) do
            v.Enabled = not v.Enabled
        end
    end

    local function enchantEquippedBall()
        local r = eventsPath():FindFirstChild("e720c159-19b5-46f6-83e5-570f622a7362")
        if not r then return patchNotice() end
        local arg = getEquippedBall()
        firesignal(Lp.PlayerGui.RightSideMenu["1"]["3"].MouseButton1Click)
        if arg then
            r:FireServer(arg)
        end
    end

    local function buyBalls(name)
        local r = eventsPath():FindFirstChild("b8b300e0-f535-4641-b3dd-bc4f64081838")
        if not r then return patchNotice() end
        if name ~= "" then
            r:FireServer(name, false)
        end
    end

    local function levelUp(arg)
        local r = eventsPath():FindFirstChild("45f0de40-ffc2-45a0-8a85-b159353af86d")
        if not r then return patchNotice() end
        if arg then
            r:FireServer(arg)
        end
    end

    -- local function nextRing()
    --     local r = eventsPath():WaitForChild("dfcb7da9-269b-4976-881c-bb86d563d16f")
    --     if not r then return patchNotice() end
    --     local Rings = Svc.Ws.Game.Rings
    --     local lastPos, ring
    --     if #Rings:GetChildren() > 0 then
    --         lastPos = Chr:GetPivot()
    --         ring = table.remove(Rings:GetChildren(), table.maxn(Rings:GetChildren()))
    --         if ring and ring:GetPivot() then
    --             Chr:PivotTo(ring:GetPivot())
    --             task.wait()
    --             r:FireServer(1)
    --             Chr:PivotTo(lastPos)
    --             repeat task.wait(1) until Svc.Ws.Camera.BallThrow == 0
    --             lastPos, ring = nil, nil
    --         end
    --     end
    -- end

    -- Loops
    -- local worker
    -- local function autoRings()
    --     getgenv().ThrowToggle:Set(false)
    --     worker = Svc.Ws.Camera.CameraSubject.Changed:Connect(function()
    --         task.wait()
    --         if not getgenv().RINGS then worker:Disconnect() end
    --         if Svc.Ws.Camera.CameraSubject == Hum then
    --             nextRing()
    --         end
    --     end)
    --     nextRing()
    -- end

    local function autoTeleports()
        local worlds = getWorldNames()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().TELEPORTS then break end
                buyTeleports(worlds)
            end
        end)
    end

    local function autoLevel()
        local b = getEquippedBall()
        firesignal(Lp.PlayerGui.RightSideMenu["1"]["3"].MouseButton1Click)
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().LEVELUP then break end
                if b then
                    levelUp(b)
                end
            end
        end)
    end

    local function autoBuyBalls()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().AUTOBUY then break end
                buyBalls(getgenv().BALL)
            end
        end)
    end

    local function autoWorlds()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().WORLDS then break end
                buyWorlds()
            end
        end)
    end

    local function autoThrow()
        getgenv().RingsToggle:Set(false)
        task.spawn(function()
            while task.wait(1) do
                if not getgenv().THROW then break end
                ballThrow()
            end
        end)
    end

    local function autoClaim()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().CLAIM then break end
                claimRewards()
            end
        end)
    end

    local function autoBoosts()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().BOOSTS then break end
                activateBoosts()
            end
        end)
    end

    local function autoUpgrade()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().UPGRADE then break end
                upgradeSkills()
            end
        end)
    end

    -- Tabs

    local AutoGameSect = GameTab:AddSection({
        Name = "Auto Toggles"
    })

    AutoGameSect:AddToggle({
        Name = "Claim Rewards",
        Default = false,
        Save = true,
        Flag = "REWARDS",
        Callback = function(Value)
            getgenv().CLAIM = Value
            autoClaim()
        end
    })

    AutoGameSect:AddToggle({
        Name = "Activate Boosts",
        Default = false,
        Save = true,
        Flag = "BOOSTS",
        Callback = function(Value)
            getgenv().BOOSTS = Value
            autoBoosts()
        end
    })

    local FarmTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    local BallRingsSect = FarmTab:AddSection({
        Name = "Ball & Rings"
    })

    getgenv().ThrowToggle = BallRingsSect:AddToggle({
        Name = "Throw Ball",
        Default = false,
        Save = true,
        Flag = "THROW",
        Callback = function(Value)
            getgenv().THROW = Value
            if Value then
                autoThrow()
            end
        end
    })

    -- getgenv().RingsToggle = BallRingsSect:AddToggle({
    --     Name = "Collect Rings",
    --     Default = false,
    --     Save = true,
    --     Flag = "FARMRINGS",
    --     Callback = function(Value)
    --         getgenv().RINGS = Value
    --         if Value then
    --             autoRings()
    --         end
    --     end
    -- })

    local UpgradeSect = FarmTab:AddSection({
        Name = "Upgrades"
    })

    UpgradeSect:AddToggle({
        Name = "Upgrade Skills",
        Default = false,
        Save = true,
        Flag = "UPSKILLS",
        Callback = function(Value)
            getgenv().UPGRADE = Value
            autoUpgrade()
        end
    })

    UpgradeSect:AddToggle({
        Name = "Level-Up Equipped Ball",
        Default = false,
        Save = true,
        Flag = "LEVELUP",
        Callback = function(Value)
            getgenv().LEVELUP = Value
            autoLevel()
        end
    })

    FarmTab:AddButton({
        Name = "Enchant Equipped Ball",
        Callback = function()
            enchantEquippedBall()
        end
    })

    local PurchaseTab = Window:MakeTab({
        Name = "Purchase",
        Icon = Icons.Money,
        PremiumOnly = false
    })

    local AutoPurchaseSect = PurchaseTab:AddSection({
        Name = "Auto Toggles"
    })

    AutoPurchaseSect:AddToggle({
        Name = "Buy Worlds",
        Default = false,
        Save = true,
        Flag = "BUYWORLDS",
        Callback = function(Value)
            getgenv().WORLDS = Value
            autoWorlds()
        end
    })

    AutoPurchaseSect:AddToggle({
        Name = "Buy Teleports",
        Default = false,
        Save = true,
        Flag = "TELEPORTS",
        Callback = function(Value)
            getgenv().TELEPORTS = Value
            autoTeleports()
        end
    })

    local BallBuySect = PurchaseTab:AddSection({
        Name = "Ball Capsules"
    })

    BallBuySect:AddDropdown({
        Name = "Select Ball Capsule",
        Default = "spawn",
        Options = getCapsules(),
        Callback = function(Value)
            getgenv().BALL = Value
        end
    })

    BallBuySect:AddToggle({
        Name = "Auto-Buy Capsule",
        Default = false,
        Save = true,
        Flag = "BUYBALLS",
        Callback = function(Value)
            getgenv().AUTOBUY = Value
            if Value then
                if getgenv().BALL then
                    autoBuyBalls()
                else
                    alert("Auto Buy Balls", "Select a capsule type.")
                end
            end
        end
    })

    PurchaseTab:AddButton({
        Name = "Buy Ball Capsule",
        Callback = function()
            if getgenv().BALL then
                buyBalls(getgenv().BALL)
            else
                alert("Buy 1 Ball", "Select a ball type.")
            end
        end
    })

    GameTab:AddButton({
        Name = "Toggle Store & Notification Popups",
        Callback = function()
            togglePopups()
        end
    })

elseif game.PlaceId == 13127800756 then -- Arm Wrestle Simulator

    -- Values

    local CurrentZone = Lp:GetAttribute("CurrentZone") or "1"

    Lp:GetAttributeChangedSignal("CurrentZone"):Connect(function()
        CurrentZone = Lp:GetAttribute("CurrentZone")
    end)

    Codes = {
        Remote = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("CodeRedemptionService"):WaitForChild("RE"):WaitForChild("onRedeem"),
        List = {
            '200m ',
            'enchant ',
            'Leagues ',
            'pinksandcastle',
            'secret',
            'gullible',
            'knighty',
            'noob',
            'axel',
            'noobs',
            'release',
            'So'
        }

    }

    -- Functions

    local function claimSeason() -- Claim Season Pass rewards
        local Rewards = Lp.PlayerGui.GameUI.Menus.SeasonPass.Rewards:FindFirstChild("Rewards")
        if Rewards then
            for i = 1, 20 do
                local Button = Rewards[i]["Main"]["Claim"]
                if Button and Button.Visible then
                    pcall(function()
                        firesignal(Button.MouseButton1Click)
                        task.wait(1)
                    end)
                end
            end
        end
    end

    local function autoClaimEggs() -- Claim event eggs
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("EventService"):WaitForChild("RF"):WaitForChild("ClaimEgg")
        if r then
            task.spawn(function()
                while task.wait(10) do
                    if not getgenv().CLAIMEGGS then break end
                    r:InvokeServer()
                end
            end)
        end
    end

    local function getEggs() -- Returns list of egg names in the current zone
        local Eggs
        local results = {}
        for _, v in pairs(Svc.Ws:WaitForChild("Zones"):WaitForChild(CurrentZone):GetDescendants()) do
            if v.Name == "Eggs" then
                Eggs = v
            end
        end
        if Eggs then
            for _, v in pairs(Eggs:GetChildren()) do
                local name = string.gsub(v.Name, "Egg", "")
                name = string.gsub(name, " ", "")
                table.insert(results, name)
            end
        end
        return results
    end

    local function purchaseEgg(Type)
        local mod = {}
        if Type == "Molton" then
            Type = "Molten"
            mod["Quasar"] = true
        end
        local args = {
            [1] = Type,
            [2] = mod,
            [4] = false
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("EggService"):WaitForChild("RF"):WaitForChild("purchaseEgg"):InvokeServer(unpack(args))
    end

    local function autoBuyEggs()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().BUYEGGS then break end
                purchaseEgg(getgenv().EGGTYPE)
            end
        end)
    end

    local function getBestArm()
        local bestArm
        local bestNum = 0
        local Arms = Lp.PlayerGui.GameUI.Menus.Arms.Container.Arms
        for _, v in pairs(Arms:GetDescendants()) do
            if v.ClassName == "TextLabel" and v.Name == "Stat" then
                local n = string.gsub(v.ContentText, "%%", "")
                if n and n ~= "test" then
                    if tonumber(n) > bestNum then
                        bestNum = tonumber(n)
                        bestArm = v.Parent.Parent.Name
                    end
                end
            end
        end
        return bestArm
    end

    local function equipArm(name)
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ArmsService"):WaitForChild("RF"):WaitForChild("EquipArm")
        if r then
            r:InvokeServer(name)
        end
    end

    local function autoEquipArms()
        task.spawn(function()
            while task.wait(15) do
                if not getgenv().EQUIPARMS then break end
                equipArm(getBestArm())
            end
        end)
    end

    local function autoOpenCrates()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ArmsService"):WaitForChild("RF"):WaitForChild("RollAllCratesForPlayer")
        if r then
            task.spawn(function()
                while task.wait(15) do
                    if not getgenv().OPENCRATES then break end
                    r:InvokeServer()
                end
            end)
        end
    end

    local function spinWheel()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("SpinService"):WaitForChild("RE"):WaitForChild("onSpinRequest")
        if r then
            r:FireServer()
        end
    end

    local function autoSpinWheel()
        task.spawn(function()
            while task.wait() do
                if not getgenv().SPIN then break end
                spinWheel()
                task.wait(60)
            end
        end)
    end

    local function removeOverlay()
        task.spawn(function()
            Lp.PlayerGui.OpenerUI.Enabled = false
            while task.wait() do
                if not getgenv().OVERLAY then break end
                for _, v in pairs(Lp.PlayerGui.GameUI:GetDescendants()) do
                    if v.Name == "RoutePromptOverlay" then
                        v.Visible = false
                    end
                end
            end
            Lp.PlayerGui.OpenerUI.Enabled = true
        end)
    end

    local function getActiveRank()
        local result = "Rank: "
        result = result..Lp.PlayerGui.GameUI.Menus.Rebirth.Container.OldTier.Text
        return result
    end

    local function autoRebirth()
        local r_1 = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("RebirthService"):WaitForChild("RE"):WaitForChild("onSuperRebirth")
        local r_2 = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("RebirthService"):WaitForChild("RE"):WaitForChild("onRebirthRequest")
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().REBIRTH then break end
                if getgenv().SUPERREBIRTH then
                    r_1:FireServer()
                end
                r_2:FireServer()
                getgenv().RebirthLabel:Set(getActiveRank())
            end
        end)
    end

    local function giveGamePasses()
        local gpMod = require(game:GetService("ReplicatedStorage").Enums.GamepassTypes)
        for _, v in next, gpMod do
            Lp:SetAttribute(v, true)
            task.wait()
        end
    end

    local function getTrails()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PurchaseService"):WaitForChild("RE"):WaitForChild("onPurchaseRequest")
        if r then
            local Trails = Svc.RepStor.Trails
            for _, v in pairs(Trails:GetChildren()) do
                local args = { [1] = "Trails", [2] = v.Name }
                r:FireServer(unpack(args))
                task.wait(0.5)
            end
        end
    end

    local function getActiveTrail()
        local result = "Equipped: "
        local Content = Lp.PlayerGui.GameUI.Menus.Trails.Content
        for _, v in pairs(Content:GetDescendants()) do
            if v.ClassName == "TextLabel" and v.Name == "Cost" then
                if v.Text == "Active" then
                    result = result..v.Parent.Parent.Name
                    break
                end
            end
        end
        return result
    end

    local function autoTrails()
        task.spawn(function()
            while task.wait() do 
                if not getgenv().TRAILS then break end
                getTrails()
                getgenv().TrailLabel:Set(getActiveTrail())
                task.wait(20)
            end
        end)
    end

    local function claimAllRewards()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TimedRewardService"):WaitForChild("RE"):WaitForChild("onClaim")
        local r2 = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("DailyRewardService"):WaitForChild("RE"):WaitForChild("onClaimReward")
        if r then
            for i = 1, 12 do
                r:FireServer(i)
                task.wait(0.5)
            end
        end
        if r2 then
            r2:FireServer()
        end
        claimSeason()
    end

    local function autoClaimRewards()
        task.spawn(function()
            while task.wait(15) do
                if not getgenv().CLAIMREWARDS then break end
                claimAllRewards()
            end
        end)
    end

    local function useBoosts()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("BoostService"):WaitForChild("RE"):WaitForChild("useBoost")
        if r then
            local b = { "Wins", "Luck", "Void", "Golden" }
            for _, v in next, b do
                r:FireServer(v)
            end
        end
    end

    local function autoBoosts()
        task.spawn(function()
            while task.wait(15) do
                if not getgenv().USEBOOSTS then break end
                useBoosts()
            end
        end)
    end

    local function equipBest()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("RF"):WaitForChild("equipBest")
        if r then
            r:InvokeServer(Lp)
        end
    end

    local function autoEquipBest()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().EQUIPBESTPETS then break end
                equipBest()
            end
        end)
    end

    local function autoCraftAll()
        local PetInventory = getsenv(Lp.PlayerScripts.Gui.Main.PetInventory)
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().CRAFTALL then break end
                PetInventory:craftAllPets()
            end
        end)
    end

    local function clickTable()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ArmWrestleService"):WaitForChild("RE"):WaitForChild("onClickRequest")
        if r and Lp:GetAttribute("BarOpen") then
            repeat
                if not getgenv().AUTOFIGHT then break end
                r:FireServer()
                task.wait()
            until not Lp:GetAttribute("BarOpen")
        end
    end

    local function autoTrain()
        local autoMod = require(game:GetService("ReplicatedStorage").Controllers.AutoController)
        local trainTypes = { "Biceps", "Hands", "Knuckles" }
        local setTime = ((tonumber(getgenv().AUTODELAY) or 60) / 3)
        local i = 1
        local isVIP = Lp:GetAttribute("VIP")
        local trainTime = tick()
        if Lp:GetAttribute("IsAtTable") then
            clickTable()
        end
        autoMod:autoTrain(trainTypes[i])
        task.spawn(function()
            while task.wait(1) do
                if not getgenv().AUTOTRAIN then break end
                if getgenv().AUTOFIGHT then break end
                if Lp:GetAttribute("BarOpen") then
                    clickTable()
                end
                if tick() - trainTime >= setTime then
                    if i == 3 then
                        i = 1
                    else
                        i = i + 1
                    end
                    autoMod:stop()
                    if trainTypes[i] == "Knuckles" then
                        Lp:SetAttribute("VIP", false)
                    else
                        Lp:SetAttribute("VIP", isVIP)
                    end
                    trainTime = tick()
                    autoMod:autoTrain(trainTypes[i])
                end
            end
            autoMod:stop()
        end)
    end

    local function getZoneModels() -- Returns ordered list of NPC's in the current zone
        local NPCFolder = Svc.Ws.Zones:WaitForChild(CurrentZone):WaitForChild("Interactables"):WaitForChild("ArmWrestling"):WaitForChild("NPC")
        local results = {}
        for _, v in pairs(NPCFolder:GetDescendants()) do
            if v.ClassName == "TextLabel" and v.Name == "Tier" then
                local t = v.ContentText
                local p = v.Parent.Parent.Parent.Parent.Parent
                if t and p then
                    local n
                    if t == "STARTER" then n = 1 end
                    if t == "MEDIUM" then n = 2 end
                    if t == "HARD" then n = 3 end
                    if t == "EXTREME" then n = 4 end
                    if t == "FINAL BOSS" then n = 5 end
                    table.insert(results, n, p)
                end
            end
        end
        -- table.remove(results, 3)
        return results
    end

    local function fightOnce(model) -- Returns wins after fighting NPC
        local Prompt = Svc.Ws.Zones[CurrentZone].Interactables.ArmWrestling.NPC[model.Name].Table.Proximity.Attachment:FindFirstChildOfClass("ProximityPrompt")
        if Prompt then
            repeat
                if Prompt then
                    fireproximityprompt(Prompt)
                end
                task.wait(1)
            until Lp:GetAttribute("BarOpen")
            clickTable()
            return Lp:GetAttribute("Wins")
        end
    end

    local function autoFight()
        local models = getZoneModels()
        local wins = 0
        local boss, autoFighting
        task.spawn(function()
            while task.wait(0.5) do
                if not getgenv().AUTOFIGHT then break end
                if Lp:GetAttribute("BicepPower") == 0 then
                    getgenv().TrainToggle:Set(true)
                    break
                end
                if not autoFighting then
                    boss = table.remove(models)
                    if boss then
                        wins = Lp:GetAttribute("Wins")
                        if wins == fightOnce(boss) then
                            if #models == 0 then
                                clickTable()
                                task.wait(3)
                                getgenv().TrainToggle:Set(true)
                                break
                            end
                        else
                            autoFighting = true
                            -- firesignal(Lp.PlayerGui.GameUI.Menus.AutoFight.Content:WaitForChild(CurrentZone):WaitForChild(boss.Name):WaitForChild("Button").MouseButton1Up)
                            fightOnce(boss)
                        end
                    end
                else
                    if Lp:GetAttribute("BarOpen") then
                        Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ArmWrestleService"):WaitForChild("RE"):WaitForChild("onClickRequest"):FireServer()
                    else
                        fightOnce(boss)
                    end
                end
            end
        end)
    end

    local function afkMode()
        local afkTime = tick()
        local delayTime = (tonumber(getgenv().AUTODELAY) or 60)
        task.spawn(function()
            while task.wait(1) do
                if not getgenv().AFKMODE then break end
                if tick() - afkTime >= delayTime then
                    if getgenv().AUTOTRAIN then
                        getgenv().FightToggle:Set(true)
                    elseif getgenv().AUTOFIGHT then
                        if Lp:GetAttribute("BarOpen") then
                            repeat task.wait(1) until not Lp:GetAttribute("BarOpen")
                        end
                        getgenv().TrainToggle:Set(true)
                    end
                    afkTime = tick()
                end
            end
            getgenv().TrainToggle:Set(false)
            getgenv().FightToggle:Set(false)
            getgenv().TrailsToggle:Set(false)
            getgenv().RebirthToggle:Set(false)
            getgenv().SuperRebirthToggle:Set(false)
        end)
    end

    local function getEventName()
        local result = ""
        result = result..Lp.PlayerGui.GameUI.Menus.Event["Golden Egg"].TextLabel.Text
        return result
    end

    local function getPets()
        local Pets = Lp.PlayerGui.GameUI.Menus.PetInventory.Container.ScrollingFrame.Pets
        local petTbl = {}
        for _, v in pairs(Pets:GetChildren()) do
            if v.ClassName == "Frame" then
                if not v.Toggle:GetAttribute("Equipped") and not v.Toggle:GetAttribute("Locked") then
                    table.insert(petTbl, v)
                end
            end
        end
        return petTbl
    end

    local function fireGoldify(Matches)
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PetService"):WaitForChild("RF"):WaitForChild("goldify")
        if r then
            r:InvokeServer(Matches)
        end
    end

    local function tryGoldify()
        local petTbl = getPets()
        for i = 1, #petTbl do
            local Toggle = petTbl[i]:FindFirstChild("Toggle")
            if Toggle and not Toggle:GetAttribute("Locked") then
                local Key = Toggle:GetAttribute("Key")
                local results = {}
                for _, m in pairs(petTbl) do
                    local mToggle = m:FindFirstChild("Toggle")
                    if mToggle then
                        if mToggle:GetAttribute("Key") == Key and mToggle:GetAttribute("GUID") ~= Toggle:GetAttribute("GUID") then
                            if mToggle:GetAttribute("Tier") == Toggle:GetAttribute("Tier") and
                            mToggle:GetAttribute("Rarity") == Toggle:GetAttribute("Rarity") and
                            mToggle:GetAttribute("CraftType") == Toggle:GetAttribute("CraftType") then
                                table.insert(results, mToggle:GetAttribute("GUID"))
                            end
                        end
                        if #results > 4 then
                            fireGoldify(results)
                            break
                        end
                    end
                end
            end
        end
    end

    local function autoGoldify()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().GOLDIFY then break end
                tryGoldify()
            end
        end)
    end

    local function tpTo(Name)
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ZoneService"):WaitForChild("RE"):WaitForChild("teleport")
        local Zone = {
            ["School"] = "BackToSchool",
            ["Gym"] = "Futuristic",
            ["Beach"] = "Beach",
            ["Atlantis"] = "Aqua",
            ["Nuclear Bunker"] = "NuclearBunker",
            ["Dino World"] = "DinoWorld"
        }
        if r then
            for _, v in pairs(Svc.Ws.Zones:GetDescendants()) do
                if v.ClassName == "Part" and v.Name == Zone[Name] then
                    r:FireServer(v)
                end
            end
        end
    end

    local function tpAll()
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ZoneService"):WaitForChild("RE"):WaitForChild("teleport")
        local Names = { [1] = "BackToSchool", [2] = "Futuristic", [3] = "Beach", [4] = "NuclearBunker", [5] = "DinoWorld" }
        if r then
            if tonumber(CurrentZone) < #Names then
                local n = CurrentZone + 1
                local p = Svc.Ws:WaitForChild("Zones"):FindFirstChild(n):FindFirstChild("Interactables"):FindFirstChild("Teleports"):FindFirstChild("Locations"):FindFirstChild(Names[n])
                if p then
                    r:FireServer(p)
                    task.wait(3)
                end
            end
        end
    end

    local function autoMove()
        task.spawn(function()
            while task.wait() do
                if not getgenv().AUTOMOVE then break end
                tpAll()
                task.wait(25)
            end
        end)
    end

    local function buyCrates(Type, Quanity) -- Buy the specified amount and type of crates
        local args = { [1] = Type, [2] = Quanity }
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ArmsService"):WaitForChild("RF"):WaitForChild("PurchaseCrates")
        if r then
            r:InvokeServer(unpack(args))
        end
    end

    local function autoBuyCrates()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().BUYCRATES then break end
                buyCrates(getgenv().CRATETYPE, "1")
            end
        end)
    end

    local function evolveArms(Arms) -- Evolves specified arms names
        local Arms = { Arms }
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ArmsService"):WaitForChild("RF"):WaitForChild("EvolveArms")
        if r then
            r:InvokeServer(unpack(Arms))
        end
    end

    local function ownedArms()
        return Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ArmsService"):WaitForChild("RF"):WaitForChild("getOwned"):InvokeServer(Lp)
    end

    local function tryEvolveArms()
        local Arms = Svc.RepStor.Arms
        local armTypes = {}
        for _, v in pairs(Arms:GetChildren()) do
            table.insert(armTypes, v.Name)
        end
        for _, armType in pairs(armTypes) do
            local results = {}
            for id, v in pairs(ownedArms()) do
                if not v.Locked and v.Tier == "Normal" and v.ArmKey == armType then
                    table.insert(results, id)
                    if #results > 4 then
                        evolveArms(results)
                        break
                    end
                end
            end
        end
    end

    local function autoEvolveArms()
        task.spawn(function()
            while task.wait(10) do
                if not getgenv().EVOLVEARMS then break end
                tryEvolveArms()
            end
        end)
    end

    local function fireVoidify(Name)
        local r = Svc.RepStor:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.4.7"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("PetVoidService"):WaitForChild("RE"):WaitForChild("onCraftToVoid")
        if r then
            r:FireServer(Name)
        end
    end

    local function tryVoidify()
        local petTbl = getPets()
        local results = {}
        for i = 1, #petTbl do
            local Toggle = petTbl[i]:FindFirstChild("Toggle")
            if Toggle and not Toggle:GetAttribute("Locked") then
                if Toggle:GetAttribute("Tier") == "Golden" then
                    table.insert(results, Toggle:GetAttribute("GUID"))
                end
            end
        end
        for _, v in pairs(results) do
            fireVoidify(v)
            task.wait()
        end
    end

    local function autoVoidify()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().VOIDIFY then break end
                tryVoidify()
            end
        end)
    end

    -- Tabs

    local GameTeleportSect = GameTab:AddSection({
        Name = "Zone Teleports"
    })

    GameTeleportSect:AddDropdown({
        Name = "Teleport to Zone",
        Default = "",
        Options = { "School", "Gym", "Beach", "Atlantis", "Nuclear Bunker", "Dino World" },
        Callback = function(Value)
            tpTo(Value)
        end
    })

    GameTeleportSect:AddToggle({
        Name = "Teleport to Unlocked Zones",
        Default = false,
        Save = true,
        Flag = "AUTOMOVE",
        Callback = function(Value)
            getgenv().AUTOMOVE = Value
            if Value then
                autoMove()
            end
        end
    })

    local GamepassSect = GameTab:AddSection({
        Name = "Gamepasses"
    })

    GamepassSect:AddButton({
        Name = "Get Gamepasses",
        Callback = function()
            giveGamePasses()
        end
    })

    local ClaimSect = GameTab:AddSection({
        Name = "Auto Rewards & Boosts Toggles"
    })

    ClaimSect:AddToggle({
        Name = "Spin Wheel",
        Default = false,
        Save = true,
        Flag = "SPIN",
        Callback = function(Value)
            getgenv().SPIN = Value
            if Value then
                autoSpinWheel()
            end
        end
    })

    ClaimSect:AddToggle({
        Name = "Claim Gifts & Rewards",
        Default = false,
        Save = true,
        Flag = "CLAIMREWARDS",
        Callback = function(Value)
            getgenv().CLAIMREWARDS = Value
            if Value then
                autoClaimRewards()
            end
        end
    })

    ClaimSect:AddToggle({
        Name = "Use Potions",
        Default = false,
        Save = true,
        Flag = "USEBOOSTS",
        Callback = function(Value)
            getgenv().USEBOOSTS = Value
            if Value then
                autoBoosts()
            end
        end
    })

    local FarmTab = Window:MakeTab({
        Name = "Farming",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    local AutoSect = FarmTab:AddSection({
        Name = "Auto Train, Fight, Buy Trails & Rebirth"
    })

    getgenv().AFKMode = AutoSect:AddToggle({
        Name = "Enabled",
        Default = false,
        Save = true,
        Flag = "AFKMODE",
        Callback = function(Value)
            getgenv().AFKMODE = Value
            if Value then
                getgenv().TrailsToggle:Set(Value)
                getgenv().RebirthToggle:Set(Value)
                getgenv().TrainToggle:Set(Value)
                afkMode()
            end
        end
    })

    getgenv().AUTODELAY = "180"
    AutoSect:AddTextbox({
        Name = "Amount of Seconds to Train/Fight:",
        Default = getgenv().AUTODELAY,
        TextDisappear = false,
        Callback = function(Value)
            if tonumber(Value) then
                getgenv().AUTODELAY = tonumber(Value)
            else
                alert("Value Error", "Must be a number value.")
            end
        end
    })

    local RebirthSect = FarmTab:AddSection({
        Name = "Rebirths"
    })

    getgenv().RebirthLabel = RebirthSect:AddLabel(getActiveRank())

    getgenv().RebirthToggle = RebirthSect:AddToggle({
        Name = "Rebirth",
        Default = false,
        Save = true,
        Flag = "REBIRTH",
        Callback = function(Value)
            getgenv().REBIRTH = Value
            if Value then
                autoRebirth()
            end
        end
    })

    getgenv().SuperRebirthToggle = RebirthSect:AddToggle({
        Name = "Super Rebirth",
        Default = false,
        Save = true,
        Flag = "REBIRTH",
        Callback = function(Value)
            getgenv().SUPERREBIRTH = Value
        end
    })

    local TrailSect = FarmTab:AddSection({
        Name = "Trails"
    })

    getgenv().TrailLabel = TrailSect:AddLabel(getActiveTrail())


    getgenv().TrailsToggle = TrailSect:AddToggle({
        Name = "Buy Trails",
        Default = false,
        Save = true,
        Flag = "TRAILS",
        Callback = function(Value)
            getgenv().TRAILS = Value
            if Value then
                autoTrails()
            end
        end
    })

    local OnlySect = FarmTab:AddSection({
        Name = "Train or Fight Toggle"
    })

    getgenv().TrainToggle = OnlySect:AddToggle({
        Name = "Train Biceps, Hands, Knuckles",
        Default = false,
        Save = true,
        Flag = "AUTOTRAIN",
        Callback = function(Value)
            getgenv().AUTOTRAIN = Value
            if Value then
                getgenv().FightToggle:Set(false)
                task.wait(2)
                autoTrain()
            end
        end
    })

    getgenv().FightToggle = OnlySect:AddToggle({
        Name = "Fight All Zone Bosses",
        Default = false,
        Save = true,
        Flag = "AUTOFIGHT",
        Callback = function(Value)
            getgenv().AUTOFIGHT = Value
            if Value then
                getgenv().TrainToggle:Set(false)
                task.wait(2)
                autoFight()
            else
                firesignal(Lp.PlayerGui.GameUI.RightMenu.Auto.AutoFight.MouseButton1Up)
            end
        end
    })

    local ArmTab = Window:MakeTab({
        Name = "Crates & Arms",
        Icon = Icons.Arm,
        PremiumOnly = false
    })

    local AutoSect = ArmTab:AddSection({
        Name = "Auto Toggles"
    })

    AutoSect:AddToggle({
        Name = "Always Equip Best Arms",
        Default = false,
        Save = true,
        Flag = "EQUIPARMS",
        Callback = function(Value)
            getgenv().EQUIPARMS = Value
            if Value then
                autoEquipArms()
            end
        end
    })

    AutoSect:AddToggle({
        Name = "Open Crates",
        Default = false,
        Save = true,
        Flag = "OPENCRATES",
        Callback = function(Value)
            getgenv().OPENCRATES = Value
            if Value then
                autoOpenCrates()
            end
        end
    })

    AutoSect:AddToggle({
        Name = "Evolve Arms",
        Default = false,
        Save = true,
        Flag = "EVOLVEARMS",
        Callback = function(Value)
            getgenv().EVOLVEARMS = Value
            if Value then
                autoEvolveArms()
            end
        end
    })

    local CrateBuySect = ArmTab:AddSection({
        Name = "Auto Buy Crates"
    })

    CrateBuySect:AddDropdown({
        Name = "Select Crate Type",
        Default = "Rust",
        Options = { "Rust", "Silver", "Gold", "Diamond" },
        Callback = function(Value)
            getgenv().CRATETYPE = Value.."Crate"
        end
    })

    CrateBuySect:AddToggle({
        Name = "Buy Crates",
        Default = false,
        Save = true,
        Flag = "BUYCRATES",
        Callback = function(Value)
            getgenv().BUYCRATES = Value
            if Value and getgenv().CRATETYPE then
                autoBuyCrates()
            end
        end
    })

    local PetsTab = Window:MakeTab({
        Name = "Eggs & Pets",
        Icon = Icons.Egg,
        PremiumOnly = false
    })

    local PetToggleSect = PetsTab:AddSection({
        Name = "Auto Toggles"
    })

    PetToggleSect:AddToggle({
        Name = "Equip Best Pets",
        Default = false,
        Save = true,
        Flag = "EQUIPBESTPETS",
        Callback = function(Value)
            getgenv().EQUIPBESTPETS = Value
            if Value then
                autoEquipBest()
            end
        end
    })

    PetToggleSect:AddToggle({
        Name = "Craft Bigger Pets",
        Default = false,
        Save = true,
        Flag = "CRAFTALL",
        Callback = function(Value)
            getgenv().CRAFTALL = Value
            if Value then
                autoCraftAll()
            end
        end
    })

    PetToggleSect:AddToggle({
        Name = "Goldify Pets",
        Default = false,
        Save = true,
        Flag = "GOLDIFY",
        Callback = function(Value)
            getgenv().GOLDIFY = Value
            if Value then
                autoGoldify()
            end
        end
    })

    PetToggleSect:AddToggle({
        Name = "Voidify Pets",
        Default = false,
        Save = true,
        Flag = "VOIDIFY",
        Callback = function(Value)
            getgenv().VOIDIFY = Value
            if Value then
                autoVoidify()
            end
        end
    })

    local EventSect = PetsTab:AddSection({
        Name = getEventName()
    })

    EventSect:AddToggle({
        Name = "Claim Event Eggs",
        Default = false,
        Save = true,
        Flag = "CLAIMEGGS",
        Callback = function(Value)
            getgenv().CLAIMEGGS = Value
            if Value then
                autoClaimEggs()
            end
        end
    })

    local PetBuySect = PetsTab:AddSection({
        Name = "Auto Buy Eggs"
    })

    getgenv().EggTypes = PetBuySect:AddDropdown({
        Name = "Select Egg Type",
        Default = "",
        Options = getEggs(),
        Callback = function(Value)
            getgenv().EGGTYPE = Value
            getgenv().EggTypes:Refresh(getEggs(), true)
        end
    })

    PetBuySect:AddToggle({
        Name = "Buy Eggs",
        Default = false,
        Save = true,
        Flag = "BUYEGGS",
        Callback = function(Value)
            getgenv().BUYEGGS = Value
            if Value then
                if not getgenv().EGGTYPE then
                    return alert("Buy Egg", "Select an Egg first!")
                end
                autoBuyEggs()
            end
        end
    })

    GameTab:AddSection({
        Name = "Server & UI"
    })

    GameTab:AddToggle({
        Name = "Remove Popups and Overlays",
        Default = false,
        Save = true,
        Flag = "OVERLAY",
        Callback = function(Value)
            getgenv().OVERLAY = Value
            if Value then
                removeOverlay()
            end
        end
    })

elseif game.PlaceId == 11696357981 then -- SuperPower Simulator
    
    -- Values

    local statTypes = { "Strength", "Agility", "Defense" }

    -- Functions

    local function autoKoth()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().KOTH then break end
                if HumRP then
                    Chr:PivotTo(Svc.Ws.KOTH:GetPivot())
                end
            end
        end)
    end

    local function attackModel(Model)
        local NpcRP = Model:FindFirstChild("HumanoidRootPart")
        if NpcRP and HumRP then
            HumRP.CFrame = NpcRP.CFrame + Vector3.new(0, -9, 0)
            local args = {
                [1] = "Punch",
                [2] = false,
                [3] = false,
                [4] = Model
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UseSkill"):FireServer(unpack(args))
        end
    end

    local function autoFight(Name)
        while task.wait() do
            if not getgenv().NPCFARM then break end
            attackModel(Svc.Ws:FindFirstChild("NPCs"):FindFirstChild(Name))
        end
    end

    local function questInteract()
        local r = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("QuestGiverInteract")
        local questGivers = { "Chakra", "Boss Yama" }
        if r then
            for _, name in pairs(questGivers) do
                r:FireServer(name)
            end
        end
    end

    local function autoQuest()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().QUEST then break end
                questInteract()
            end
        end)
    end

    local function autoTrain()
        local r = Svc.RepStor:WaitForChild("Events"):WaitForChild("Training")
        task.spawn(function()
            while task.wait() do
                if not getgenv().TRAIN then break end
                for i = 1, #statTypes do
                    r:FireServer(statTypes[i])
                    task.wait()
                end
            end
        end)
    end

    local function getLowestStat()
        local StatisticScroll = Lp.PlayerGui.Main.Pages.Stats.Main.Bottom.StatisticScroll
        local statName = statTypes[math.random(1, #statTypes)]
        local lowestAmt
        for i = 1, #statTypes do
            local Frame = StatisticScroll:FindFirstChild(statTypes[i])
            if Frame then
                local Multiplier = Frame:FindFirstChild("Multiplier").Text
                if Multiplier then
                    local n = tonumber(string.split(Multiplier, "x multiplier")[1])
                    if n then
                        if not lowestAmt or n < lowestAmt then
                            statName = Frame.Name
                            lowestAmt = n
                        end
                    end
                end
            end
        end
        return statName
    end

    local function autoUpgrade()
        local r = Svc.RepStor:WaitForChild("Events"):WaitForChild("UpgradeMultiplier")
        task.spawn(function()
            while task.wait(3) do
                if not getgenv().UPGRADE then break end
                r:FireServer(getLowestStat())
            end
        end)
    end

    local function autoHatch()
        local r = Svc.RepStor:WaitForChild("Events"):WaitForChild("Hatch")
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().HATCH then break end
                r:FireServer(getgenv().EGG)
            end
        end)
    end

    local function autoHide()
        task.spawn(function()
            while task.wait() do
                if not getgenv().HIDE then break end
                local popup = Lp.PlayerGui.Main.Pages:FindFirstChild("NEEDCURRENCY")
                if popup and popup.Visible then
                    popup.Visible = false
                end
            end
        end)
    end

    -- Tabs

    GameTab:AddToggle({
        Name = "Auto-Hide Currency Prompt",
        Default = false,
        Save = true,
        Flag = "HIDE",
        Callback = function(Value)
            getgenv().HIDE = Value
            if Value then
                autoHide()
            end
        end
    })

    local TrainTab = Window:MakeTab({
        Name = "Training",
        Icon = Icons.Gear,
        PremiumOnly = false
    })

    local TrainSect = TrainTab:AddSection({
        Name = "Auto Train"
    })

    getgenv().TrainToggle = TrainSect:AddToggle({
        Name = "Enabled",
        Default = false,
        Save = true,
        Flag = "TRAIN",
        Callback = function(Value)
            getgenv().TRAIN = Value
            if Value then
                autoTrain()
            end
        end
    })

    local KingSect = TrainTab:AddSection({
        Name = "Auto Farm King of the Hill"
    })

    KingSect:AddToggle({
        Name = "Enabled",
        Default = false,
        Save = true,
        Flag = "KOTH",
        Callback = function(Value)
            getgenv().KOTH = Value
            if Value then
                autoKoth()
            end
        end
    })
    local QuestSect = TrainTab:AddSection({
        Name = "Auto Quest Complete"
    })

    QuestSect:AddToggle({
        Name = "Enabled",
        Default = false,
        Save = true,
        Flag = "QUEST",
        Callback = function(Value)
            getgenv().QUEST = Value
            if Value then
                autoQuest()
            end
        end
    })

    local FightSect = TrainTab:AddSection({
        Name = "Auto Fight"
    })

    FightSect:AddDropdown({
        Name = "Select Npc",
        Default = "Brawler",
        Options = { "Brawler", "Goon", "Crook", "Purger", "Brute", "Destroyer" },
        Callback = function(Value)
            getgenv().NPC = Value
        end
    })

    FightSect:AddToggle({
        Name = "Enabled",
        Default = false,
        Save = true,
        Flag = "AUTOFIGHT",
        Callback = function(Value)
            if getgenv().NPC then
                getgenv().NPCFARM = Value
                autoFight(getgenv().NPC)
            end
        end
    })

    local UpgradesTab = Window:MakeTab({
        Name = "Upgrades",
        Icon = Icons.Upgrade,
        PremiumOnly = false
    })

    local AutoMultiSect = UpgradesTab:AddSection({
        Name = "Auto Upgrade Stat Multipliers"
    })

    AutoMultiSect:AddToggle({
        Name = "Enabled",
        Default = false,
        Save = true,
        Flag = "UPGRADE",
        Callback = function(Value)
            getgenv().UPGRADE = Value
            if Value then
                autoUpgrade()
            end
        end
    })

    local PetsTab = Window:MakeTab({
        Name = "Pets",
        Icon = Icons.Pet,
        PremiumOnly = false
    })

    PetsTab:AddDropdown({
        Name = "Select Pet Dispenser",
        Default = "DemonDispenser",
        Options = { "DemonDispenser", "RoyalDispenser", "HeroDispenser" },
        Callback = function(Value)
            getgenv().EGG = Value
        end
    })

    PetsTab:AddToggle({
        Name = "Auto-Hatch Dispenser",
        Default = false,
        Save = true,
        Flag = "HATCH",
        Callback = function(Value)
            getgenv().HATCH = Value
            if Value then
                autoHatch()
            end
        end
    })


elseif game.PlaceId == 6263431107 then -- Imposters and Roles

    -- Values

    local Temp = Lp.PlayerGui.Temp
    local Bin = Lp:WaitForChild("bin")
    local isImposter = function() return (Bin:WaitForChild("Role").Value == "Imposter") end
    local isCrewmate = function() return (Bin:WaitForChild("Role").Value == "Crewmate") end

    -- Functions

    
    local function fireEvent(Event)
        task.wait(2)
        Svc.RepStor:WaitForChild("RemoteEvents"):WaitForChild(Event):FireServer()
    end

    local function spamEmotes()
        for i = 1, 4 do
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PlayEmotion"):FireServer(i)
            task.wait(3)
        end
    end

    local function removeCooldowns()
        for _, v in pairs(Lp.GameTemp:GetChildren()) do
            if v.Name:find("Cooldown") then
                v.Value = os.time() - 60
            end
        end
    end

    local function getImposters()
        local results = {}
        for _, v in pairs(Svc.Plrs:GetDescendants()) do
            if v.ClassName == "StringValue" and v.Name == "Role" and v.Value == "Imposter" and v.Parent.Parent.Name ~= Lp.Name then
                table.insert(results, v.Parent.Parent.Name)
            end
        end
        return results
    end
    
    local function showRoles()
        local Humanoids = Svc.Ws:WaitForChild("Humanoids")
        for _, v in pairs(Svc.Plrs:GetPlayers()) do
            local char = Humanoids:FindFirstChild(v.Name)
            if char then
                local bin = v:WaitForChild("bin")
                if bin.Alive.Value then
                    local n = char.Hat.NameGui
                    local role = bin.Role.Value
                    local subRole = bin.SubRole.Value
                    if role and subRole then
                        n.NameLabel.Text = "["..subRole.."] "..v.Name
                        local roleColor = Svc.RepStor:FindFirstChild("Roles"):FindFirstChild(subRole):FindFirstChild("BookInfo"):FindFirstChild("BackgroundColor")
                        if roleColor then
                            n.NameLabel.TextColor3 = roleColor.Value
                        end
                    end
                end
            end
        end
    end

    local function autoFog()
        task.spawn(function()
            while task.wait(0.5) do
                if not getgenv().AUTOFOG then break end
                Bin.Lighting:FindFirstChild("FogStart").Value = 9e9
                Bin.Lighting:FindFirstChild("FogEnd").Value = 9e9
            end
        end)
    end

    local function skip()
        local args = {
            [1] = game:GetService("ReplicatedStorage"):WaitForChild("Settings"):WaitForChild("Game"):WaitForChild("Discussion"):WaitForChild("SkipPointer")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Vote"):FireServer(unpack(args))
    end
    
    local function vote(name)
        if not getgenv().AUTOVOTE then return end
        local args = {
            [1] = game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Discussion"):WaitForChild("Players"):WaitForChild(name)
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Vote"):FireServer(unpack(args))
    end
    
    local function sendMessage(colorName)
        if not getgenv().AUTOCHAT then return end
        local pre = { "is ", "it is ", "it's ", "imposter is ", "i think is ", "OMG ", "bruh gotta be ", "i saw ", "i know its ", "it " }
        local suf = { " was in the room"," is sus"," is a imposter"," was chasing me"," was near body"," vented" }
        local fix = { [1] = tostring(pre[math.random(1, #pre)]..colorName), [2] = tostring(colorName..suf[math.random(1, #suf)]) }
        local s = fix[math.random(1, #fix)]
        local strings = { [1]=s:upper(), [2]=s:lower() }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SendGameMessage"):FireServer(strings[math.random(1, #strings)])
    end
    
    local function getColor(int)
        local result
        local colors = {
            [1] = "red",
            [2] = "blue",
            [3] = "dark green",
            [4] = "pink",
            [5] = "orange",
            [6] = "yellow",
            [7] = "black",
            [8] = "white",
            [9] = "purple",
            [10] = "brown",
            [11] = "teal",
            [12] = "green",
            [13] = "gray",
            [14] = "lemon",
            [15] = "bubble gum"
        }
        result = colors[int]
        return result
    end
    
    local function voteRandomPlayer()
        for i = #game:GetService("Players"):GetChildren(), 1, -1 do
            local v = game:GetService("Players"):GetChildren()[i]
            if v.bin.Alive.Value and v.bin.Role.Value ~= "Imposter" and v.bin.SubRole.Value ~= "Captain" and v.bin.SubRole.Value ~= "Unspeaker" and v.bin.SubRole.Value ~= "VIP" and v.Name ~= Lp.Name then
                local c = getColor(v.bin.Color.Value)
                if c then
                    sendMessage(c)
                end
                vote(v.Name)
                break
            end
        end
    end
    
    local function autoDiscuss()
        task.wait(10)
        local Temp = game:GetService("Players").LocalPlayer.PlayerGui.Temp
        if Bin.Alive.Value then
            local Players = Temp:WaitForChild("DiscussGui"):FindFirstChild("MeetingFrame"):FindFirstChild("DiscussLabel"):FindFirstChild("Players")
            for _, v in pairs(Players:GetDescendants()) do
                if v.Name == "NameLabel" then
                    local player = game:GetService("Players"):FindFirstChild(v.Parent.Name)
                    if player and player:WaitForChild("bin").Role.Value == "Imposter" then
                        if Bin.Role.Value ~= "Imposter" then
                            
                            local c = getColor(player.bin.Color.Value)
                            if c then
                                sendMessage(c)
                            end
                            vote(player.Name)
                            break
                        else
                            voteRandomPlayer()
                            break
                        end
                    end
                end
            end
            getgenv().VOTED = true
        end
    end

    local function kill(name)
        local player = game:GetService("Players"):WaitForChild(name)
        if player then
            local args = {
                [1] = player
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Kill"):InvokeServer(unpack(args))
        end
    end
    
    local function xrayVision()
        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
            if v.ClassName == "Part" or v.ClassName == "MeshPart" or v.ClassName == "Decal" and v.Name ~= "Floor" then
                local trans = v.Transparency
                if trans < 0.8 and v.Parent.Parent.Name ~= "Humanoids" then
                    v.Transparency = 0.8
                end
            end
        end
    end

    local function switchSkin()
        if not getgenv().SKINCHANGER then return end
        if not Bin.InGame.Value then
            local oldColor = Bin.Color.Value
            while task.wait(2) do
                if oldColor ~= Bin.Color.Value then break end
                local n = math.random(1, 15)
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SetPlayerColor"):InvokeServer(n)
            end
        end
    end

    local function startDiscussion()
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("StartDiscussion"):InvokeServer()
    end
    
    local function spamDiscussion()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().SPAMDISCUSSION then break end
                startDiscussion()
            end
        end)
    end

    local function foundBody(DeadBody)
        if not Bin.InGame.Value then return end
        if DeadBody then
            if Bin.SubRole.Value == "Chimera" then
                Svc.RepStor:WaitForChild("RemoteEvents"):WaitForChild("ChimeraEatBody"):InvokeServer(DeadBody)
            else
                DeadBody:WaitForChild("Interact"):InvokeServer(DeadBody)
            end
        end
    end

    local autoReport
    local function autoBodies()
        if autoReport then
            autoReport:Disconnect()
        end
        autoReport = Svc.Ws.Bodies.ChildAdded:Connect(function(child)
            task.wait(3)
            foundBody()
        end)
    end

    local function showPlayers()
        local Humanoids = workspace.Humanoids
        for _, v in pairs(Humanoids:GetDescendants()) do
            if v.ClassName == "MeshPart" then
                v:GetPropertyChangedSignal("Transparency"):Connect(function()
                    if not getgenv().XRAY then return end
                    if v.Transparency > 0 then
                        v.Transparency = 0
                    end
                end)
            end
        end
    end
    
    local function alwaysShowPlayers()
    	task.spawn(function()
    		while task.wait(5) do
    			if not getgenv().XRAY then break end
    			showPlayers()
			end
		end)
    end

    local function collectEventItems()
        local hrp = Svc.Ws.Humanoids[Lp.Name]:WaitForChild("HumanoidRootPart")
        for _, v in pairs(Svc.Ws.GameEvents:GetDescendants()) do
            if v.Name == "TouchInterest" then
                firetouchinterest(hrp, v.Parent, 0)
                task.wait()
                firetouchinterest(hrp, v.Parent, 1)
            end
        end
    end
    
    local function autoCollectEventItems()
        local InGame = Bin.InGame 
        local eventHandler
        eventHandler = InGame:GetPropertyChangedSignal("Value"):Connect(function()
            if getgenv().AUTOCOLLECT then
                if not InGame.Value then return end
                task.wait(5)
                collectEventItems()
            end
        end)
    end

    local function getCoffins()
        local coffin = Svc.Ws:WaitForChild("GameEvents"):WaitForChild("Coffin")
        if coffin then
            for i = 1, 15 do
                Svc.Ws:WaitForChild("GameEvents"):WaitForChild("Coffin"):WaitForChild("Interact"):InvokeServer(coffin)
                task.wait(math.random(1, 5))
            end
        end
    end

    local function sabotageHandler()
        if not game:GetService("Players").LocalPlayer.bin.InGame.Value then return end
        local RemoteEvents = game:GetService("ReplicatedStorage").RemoteEvents
        local events = {}
        for _, v in pairs(RemoteEvents:GetChildren()) do
            if v.ClassName == "RemoteEvent" then
                if game:GetService("Players").LocalPlayer.bin.Role.Value == "Imposter" and string.find(v.Name, "Sabotage") and not string.find(v.Name, "FixSabotage") then
                    table.insert(events, v)
                end
                if game:GetService("Players").LocalPlayer.bin.Role.Value == "Crewmate" and string.find(v.Name, "FixSabotage") and not string.find(v.Name, "Sabotage") then
                    table.insert(events, v)
                end     
            end
        end
        events[math.random(1, #events)]:FireServer()
    end
    
    local function autoSabotage()
        task.spawn(function() 
            while task.wait(3) do
                if not getgenv().SABOTAGE then break end
                sabotageHandler()
            end
        end)
    end

    local function autoDefuse()
        task.spawn(function()
            for _, v in pairs(game:GetService("Players"):GetChildren()) do
                if v.bin.Role == "Imposter" and v.bin.SubRole == "Bomber" then
                    warn("Bomber Found")
                    if #BombsPlanted:GetChildren() > 0 then
                        warn("Bomb(s) Detected")
                        for _, b in pairs(v.GameTemp.BombsPlanted:GetChildren()) do
                            print(v.Value.Name)
                        end
                    end
                end
            end
        end)
    end

    local function digGrave()
        local g = game:GetService("Workspace"):FindFirstChild("GraveyardRoom"):FindFirstChild("Functional"):FindFirstChild("Grave")
        if g then
            g:WaitForChild("Interact"):InvokeServer(g)
            repeat task.wait(1) until g:FindFirstChild("OpenGrave")
            g:WaitForChild("OpenGrave"):FireServer()
        end
    end

    local function closeDoors()
        local d = workspace:WaitForChild("ElectricalRoom"):WaitForChild("Doors")
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CloseDoors"):FireServer(d)
    end
    
    local function closeDoors()
        if Bin.Role.Value ~= "Imposter" or not Bin.InGame.Value then return end
        local d = workspace:WaitForChild("ElectricalRoom"):FindFirstChild("Doors")
        if d then
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CloseDoors"):FireServer(d)
        end
    end

    local function autoCloseDoors()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().CLOSEDOORS then break end
                closeDoors()
            end
        end)
    end

    --finish
    local function placeBombs()
        local args = {
            [1] = CFrame.new(20.715557098388672, 6.4089789390563965, 116.03788757324219, 0.8190091848373413, 0.018730906769633293, 0.5734745860099792, 1.862645371275562e-09, 0.9994668960571289, -0.03264473378658295, -0.5737804174423218, 0.026736339554190636, 0.8185725808143616),
            [2] = CFrame.new(38.54813003540039, 6.0499982833862305, 131.14395141601562, 0, 0, 1, 0, 1, 0, -1, 0, 0),
            [3] = CFrame.new(145.1122589111328, 6.049995422363281, 186.8518829345703, -1, 0, 0, 0, 1, 0, 0, 0, -1),
            [4] = CFrame.new(142.45187377929688, 6.0499982833862305, 106.44219970703125, -0, -0, -1, 0, 1, 0, 1, 0, 0),
            [5] = CFrame.new(93.54812622070312, 6.049315452575684, 56.93755340576172, 0, 0, 1, 0, 1, 0, -1, 0, 0),
            [6] = CFrame.new(93.54812622070312, 6.049315452575684, 56.93755340576172, 0, 0, 1, 0, 1, 0, -1, 0, 0)
        }
        for i = 1, #args do
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PlantExploderC4"):InvokeServer(args[i])
            task.wait(15)
        end
    end
    
    local function autoCloseDoors()
        task.spawn(function()
            while task.wait(5) do
                if not getgenv().CLOSEDOORS then break end
                closeDoors()
            end
        end)
    end

    local function finishTaskWithId(id)
        if not getgenv().AUTOTASK then return end
        for _, v in pairs(Lp.Tasks:GetChildren()) do
            if v:FindFirstChild("Id") and v.Id.Value == id.Value then
                warn("Task Opened:", v.Name)
                fireEvent("FinishTask")
                break
            end
        end
    end

    -- make this work
    local function fixValve()
        task.wait(2)
        local v = Svc.Ws:WaitForChild("FridgesRoom"):WaitForChild("Functional"):WaitForChild("Valve")
        clickAbs(Lp.PlayerGui.Temp:WaitForChild("ValveFixGui").ActiveFrame)
        Svc.RepStor:WaitForChild("RemoteEvents"):WaitForChild("FixFridgesSabotage"):FireServer(v)
    end

    local function labelImposters()
        if not getgenv().LABELIMPOSTERS then return end
        local imp = getImposters()
        for i = 1, #imp do
            local nameLabel = Lp.PlayerGui.Temp:WaitForChild("DiscussGui").MeetingFrame.DiscussLabel.Players:FindFirstChild(imp[i])
            if nameLabel then
                nameLabel.ImposterLabel.Visible = true
            end
        end
    end

    local function collectSample()
        for _, v in pairs(Svc.Plrs:GetChildren()) do
            if v.Name ~= Lp.Name then
                local bin = v:FindFirstChild("bin")
                if bin and bin.Alive.Value then
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("TakeShapeSample"):FireServer(v)
                end
            end
        end
    end
    
    local function shapeShift()
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Shapeshift"):InvokeServer()
    end

    local function fixSabotages()
        fireEvent("HackerFixSabotage")
    end

    local function infectVirus()
        for _, v in pairs(Svc.Plrs:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("InfectWithVirus"):InvokeServer(v)
            task.wait(1)
        end
    end
    
    local function removeBlackblocks()
        for _, m in pairs(Svc.Ws.BlackBlocks:GetChildren()) do
            for _, v in pairs(m:GetChildren()) do
                if v.ClassName == "Part" or v.ClassName == "WedgePart" or v.ClassName == "Union" or v.ClassName == "UnionOperation" then
                    v.Position = v.Position + Vector3.new(0, 100, 0)
                end
            end
        end
    end
    
    local function hidePlayer()
        local endPos = Svc.Ws.ArmoryRoom.Room.Floor.Position + Vector3.new(0, 3, 0)
        tweenTo(endPos, 2, Lp)
    end

    local function autoImposter()
        if Bin.Role.Value == "Imposter" then
            local Button = Lp.PlayerGui.GameGui:WaitForChild("ObjectInteractionsGui"):WaitForChild("InteractButton")
            for _, v in pairs(Svc.Plrs:GetChildren()) do
                local pos = v.Character:FindFirstChildWhichIsA("BasePart").Position
                tweenTo(pos, 3, Lp)
                task.wait()
                walkToPos(pos)
                task.wait()
                clickAbs(Button)
            end
        end
    end

    local function toggleWalls()
        for _, v in pairs(Svc.Ws:GetDescendants()) do
            if v.Name == "Wall" then
                v.CanCollide = not v.CanCollide
                v.CanTouch = not v.CanTouch
                v.Anchored = not v.Anchored
            end
        end
    end

    local function tasksDone()
        local result = true
        for _, v in pairs(Lp.Tasks:GetChildren()) do
            if not Bin.InGame.Value then break end
            if v and v:WaitForChild("Completed") and not v:FindFirstChild("Completed").Value then
                result = false
                break
            end
        end
        return result
    end

    local function completeTasks()
        if isCrewmate and #Lp.Tasks:GetChildren() > 0 then
            if not tasksDone() then
                getgenv().AUTOTASK = true
                removeBlackblocks()
                toggleWalls()
                for _, v in pairs(Lp.Tasks:GetChildren()) do
                    if not Bin.InGame.Value then break end
                    if v and v:WaitForChild("Completed") and not v:FindFirstChild("Completed").Value then
                        local obj = v.ActiveObject.Value
                        local pos = obj.Position + Vector3.new(0, 3, 0)
                        while task.wait(5) do
                            if v:FindFirstChild("Completed").Value then break end
                            if not Bin.InGame.Value then break end
                            tweenTo(pos, 3, Lp)
                            walkToPos(pos)
                            clickAbs(Lp.PlayerGui.GameGui:WaitForChild("ObjectInteractionsGui"):WaitForChild("InteractButton"))
                        end
                    end
                end
            end
            hidePlayer()
            toggleWalls()
        end
    end

    local function completeAwards()
        local AwardProgress = Lp:FindFirstChild("AwardProgress")
        if AwardProgress then
            task.wait(5)
            for _, v in pairs(AwardProgress:GetChildren()) do
                warn("Award Needed: ", v.Name)
                if v.Name == "FindBody" or v.Name == "EjectImposter" then
                    -- if Bin.SubRole == "Guard" then
                    --     removeCooldowns()
                    --     task.wait(1)
                    --     fireEvent("EnterCamera")
                    --     task.wait()
                    --     fireEvent("EnterCamera")
                    -- end
                    -- getgenv().AUTOREPORT = true
                    -- autoBodies()
                end
                if v.Name == "FixSabotage" then
                    -- getgenv().FIXSABOTAGE = true
                    -- removeCooldowns()
                    -- fixSabotages()
                end
                if v.Name == "HostMeeting" then
                    -- task.wait(60)
                    -- fireEvent("CaptainMeetingCall")
                end
                if v.Name == "Resurrect" then
                    -- game:GetService("ReplicatedStorage").Effects.EffectEvents.Roles.Priest.PriestResurrection:InvokeServer()
                end
            end
        end
    end

    local function guiHandler(Gui)
        warn("Gui: ", Gui.Name)
        local id = Gui:FindFirstChild("TaskId")
        if id then
            finishTaskWithId(id)
        end
        if Gui.Name == "DiscussGui" then
            task.wait(5)
            if not getgenv().VOTED then
                labelImposters()
                autoDiscuss()
                task.wait(25)
                getgenv().VOTED = false
            end
        end
        if Gui.Name == "FadeGui" then
            -- completeAwards()
            if inGame then
                task.wait(10)
                completeTasks()
            else
                task.wait(5)
                switchSkin()
            end
        end
        if Gui.Name == "ValveFixGui" then
            -- fixValve()
        end
        if getgenv().UNFREEZE then
            if Gui.Name == "UnfreezeInterfaceGui" then
                fireEvent("UnfreezePlayer")
            elseif Gui.Name == "BreakOutOfWebGui" then
                fireEvent("UnstuckFromWeb")
            end
        end
        showRoles()
    end
    
    local function moveTo(humanoid, targetPoint, andThen)
        local targetReached = false
        Lp.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = targetPoint.Position
        -- listen for the humanoid reaching its target
        local connection
        connection = humanoid.MoveToFinished:Connect(function(reached)
            targetReached = true
            connection:Disconnect()
            connection = nil
            if andThen then
                andThen(reached)
            end
        end)
    end

    local function hogDummies()
        task.spawn(function()
            while task.wait(3) do
                if Bin.InGame.Value then return end
                if not getgenv().HOGDUMMIES then break end
                for i = 1, #Svc.Ws.Debug:GetChildren() do
                    local d = Svc.Ws.Debug:GetChildren()[i]
                    local p = d:WaitForChild("HumanoidRootPart")
                    if d and p then
                        moveTo(Hum, p, game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("DebugUseWeapon"):InvokeServer(d)):Wait()
                    end
                end
            end 
        end)
    end

    if getgenv().guiHandler then
        getgenv().guiHandler:Disconnect()
    end
    getgenv().guiHandler = Temp.ChildAdded:Connect(function(child)
        guiHandler(child)
    end)

    -- Tabs

    GameTab:AddToggle({
        Name = "Show Roles",
        Default = false,
        Save = true,
        Flag = "AUTOSHOW",
        Callback = function(Value)
            getgenv().AUTOSHOW = Value
            getgenv().LABELIMPOSTERS = Value
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Sabotage",
        Default = false,
        Save = true,
        Flag = "AUTOSABOTAGE",
        Callback = function(Value)
            getgenv().AUTOSABOTAGE = Value
            if Value then
                autoSabotage()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Close Doors",
        Default = false,
        Save = true,
        Flag = "CLOSEDOORS",
        Callback = function(Value)
            getgenv().CLOSEDOORS = Value
            if Value then
                autoCloseDoors()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Remove Fog",
        Default = false,
        Save = true,
        Flag = "AUTOFOG",
        Callback = function(Value)
            getgenv().AUTOFOG = Value
            if Value then
                autoFog()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Finish Tasks",
        Default = false,
        Save = true,
        Flag = "AUTOTASK",
        Callback = function(Value)
            getgenv().AUTOTASK = Value
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Unfreeze & Unweb",
        Default = false,
        Save = true,
        Flag = "UNFREEZE",
        Callback = function(Value)
            getgenv().UNFREEZE = Value
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Vote",
        Default = false,
        Save = true,
        Flag = "AUTOVOTE",
        Callback = function(Value)
            getgenv().AUTOVOTE = Value
        end
    })

    GameTab:AddToggle({
        Name = "X-Ray Vision",
        Default = false,
        Save = true,
        Flag = "XRAY",
        Callback = function(Value)
            getgenv().XRAY = Value
            if Value then
                xrayVision()
                alwaysShowPlayers()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Change Colors",
        Default = false,
        Save = true,
        Flag = "SKINCHANGER",
        Callback = function(Value)
            getgenv().SKINCHANGER = Value
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Blame Chat",
        Default = false,
        Save = true,
        Flag = "AUTOCHAT",
        Callback = function(Value)
            getgenv().AUTOCHAT = Value
            if not Value then
                getgenv().VOTED = false
            end
        end
    })

    GameTab:AddToggle({
        Name = "Discussion Spam",
        Default = false,
        Save = true,
        Flag = "SPAMDISCUSSION",
        Callback = function(Value)
            getgenv().SPAMDISCUSSION = Value
            if Value then
                spamDiscussion()
            end
        end
    })

    GameTab:AddToggle({
        Name = "Auto-Collect Event Items",
        Default = false,
        Save = true,
        Flag = "AUTOCOLLECT",
        Callback = function(Value)
            getgenv().AUTOCOLLECT = Value
            if Value then
                autoCollectEventItems()
            end
        end
    })

    GameTab:AddButton({
        Name = "Get Coffins Achievement",
        Callback = function()
            getCoffins()
        end
    })

    GameTab:AddToggle({
        Name = "Spam-Kill Lobby Dummies",
        Default = false,
        Save = true,
        Flag = "HOGDUMMIES",
        Callback = function(Value)
            getgenv().HOGDUMMIES = Value
            if Value then
                hogDummies()
            end
        end
    })

end

local BindTab = Window:MakeTab({
    Name = "Keybinds",
    Icon = Icons.Keyboard,
    PremiumOnly = false
})

addBinds(Binds, BindTab)

if Codes.Remote then
    GameTab:AddButton({
        Name = "Redeem Codes",
        Callback = function()
            fireRedeem(Codes.Remote, Codes.List)
        end
    })
end

Lib.Orion:Init()
