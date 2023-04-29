local gameName = hubName.."Ninja Legends"
local Window = OrionLib:MakeWindow({Name = gameName, HidePremium = false, SaveConfig = true, IntroEnabled = true, IntroText = "Thank you.", ConfigFolder = "MaddHub_"..lp.Name})

-- Functions

local function redeemCodes()
    local codes = {
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
    for _, v in pairs(codes) do
        local Event = game:GetService("ReplicatedStorage").rEvents.codeRemote
        Event:InvokeServer(v)
        task.wait(0.5)
    end
end

local function noclip()
    for i, v in pairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
            lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end

local function autoBlade()
    local Backpack = lp.Backpack
    task.spawn(function()
        while task.wait() do
            if not getgenv().EQUIPSWORD then break end;
            pcall(function()
                lp.Character.Humanoid:UnequipTools()
                for _, v in pairs(Backpack:GetDescendants()) do
                    -- print(v)
                    if v.Name == "attackKatanaScript" then
                        local tool = v.Parent
                        lp.Character.Humanoid:EquipTool(tool)
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
    local Event = lp.ninjaEvent
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
    local sellArea = ws.sellAreaCircles.sellAreaCircle16.circleInner
    if not part then
        repeat task.wait(1) until part
    end
    firetouchinterest(part, sellArea, 0)
    task.wait(0.2)
    firetouchinterest(part, sellArea, 1)
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
    local bossFolder = ws.bossFolder
    if not getgenv().SWING then
        getgenv().SWING = true
        autoSwing()
    end
    task.spawn(function()
        noclip()
        local oldPos
        while task.wait() do
            if not getgenv().AUTOBOSS then break end;
            repeat task.wait(1) until bossFolder[name] ~= nil;
            pcall(function()
                local b = bossFolder[name].Name
                if bossFolder[b].HumanoidRootPart.Position then
                    oldPos = bossFolder[b].HumanoidRootPart.Position
                    task.wait(0.25)
                    if oldPos == bossFolder[b].HumanoidRootPart.Position then
                        local newPos = oldPos + Vector3.new(0, 0, -7)
                        lp.Character:MoveTo(newPos)
                        task.wait(0.1)
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function dailyChests()
    local k = lp.Karma
    local ignoreChest
    if k.Value < 0 then
        ignoreChest = "lightKarmaChest"
    else
        ignoreChest = "evilKarmaChest"
    end
    for _, v in pairs(ws:GetDescendants()) do
        if not getgenv().CHESTS then break end;
        if v.Name == "Chest" and v.Parent.Name ~= ignoreChest then
            -- print(v.Parent)
            if not part then
                repeat task.wait(1) until part
            end
            firetouchinterest(part, v.Parent.circleInner, 0)
            task.wait(0.5)
            firetouchinterest(part, v.Parent.circleInner, 1)
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
            local Event = game:GetService("ReplicatedStorage").rEvents.autoEvolveRemote
            Event:InvokeServer(A_1)
            task.wait(1)
        end
    end)
end

local function sellPet(pet)
    local A_1 = "sellPet"
    local Event = game:GetService("ReplicatedStorage").rEvents.sellPetEvent
    Event:FireServer(A_1, pet)
end

local function getTypes()
    local t = {}
    for _, v in ipairs(lp.petsFolder:GetChildren()) do
        local c = v:GetChildren()
        if #c > 0 then
            table.insert(t, v)
        end
    end
    return t
end

local function getCrystalNames()
    local CrystalsFolder = ws.mapCrystalsFolder
    local t = {}
    for _, v in pairs(CrystalsFolder:GetChildren()) do
        table.insert(t, v.Name)
    end
    return t
end

local function petCount()
    local petsLabel = lp.PlayerGui.gameGui.petsMenu.petInfoMenu.petsLabel.Text
    local l = string.gsub(petsLabel, "Pets: ", "")
    local s = string.gsub(l, "/"," ")
    local t = {}
    for i in string.gmatch(s, "%S+") do
        table.insert(t, i)
    end
    return t
end

local function returnEvolved()
    local petsFrames = lp.PlayerGui.gameGui.petsMenu.petsFrames
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
    repeat task.wait(1) until lp.PlayerGui;
    local unequipAllButton = lp.PlayerGui.gameGui.petsMenu.bottomPetMenu.unequipAllButton
    local equipButton = lp.PlayerGui.gameGui.petsMenu.sidePetMenu.equipButton
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

local function collect()
    local Valley = ws.spawnedCoins.Valley
    for _, v in pairs(Valley:GetChildren()) do
        if not getgenv().CRATES then break end;
        -- print(v.Name, v.spawnValue.Value, v.Position)
        if #v:GetChildren() > 0 then
            lp.Character:MoveTo(v.Position)
            task.wait(0.5)
        end
    end
end

local function autoCrates()
    task.spawn(function()
        while task.wait() do
            if not getgenv().CRATES then break end;
            collect()
            task.wait(1)
        end
    end)
end

local function buyRank(rank)
    local A_1 = "buyRank"
    local Event = lp.ninjaEvent
    Event:FireServer(A_1, rank)
end

local function autoRank()
    local Ranks = game:GetService("ReplicatedStorage").Ranks
    task.spawn(function()
        while task.wait() do
            if not getgenv().RANKS then break end;
            for _, v in pairs(Ranks.Ground:GetChildren()) do
                -- print(v.Name)
                if not getgenv().RANKS then break end;
                buyRank(v.Name)
                task.wait(0.2)
            end
        end
    end)
end

local function goInvisible()
    local A_1 = "goInvisible"
    local Event = lp.ninjaEvent
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
    local Event = game:GetService("ReplicatedStorage").rEvents.hoopEvent
    Event:FireServer(A_1, h)
end

local function getHoops()
    local Hoops = ws.Hoops
    for i, v in pairs(Hoops:GetChildren()) do
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
    local islandUnlockParts = ws.islandUnlockParts
    local t = {}
    for _, v in pairs(islandUnlockParts:GetChildren()) do
        table.insert(t, v.Name)
    end
    return t
end

local function getIslandCFrames()
    local islandUnlockParts = ws.islandUnlockParts
    local t = {}
    for _, v in pairs(islandUnlockParts:GetChildren()) do
        table.insert(t, v.islandSignPart.CFrame)
    end
    return t
end

local function unlockIslands()
    local a = getIslandCFrames()
    repeat task.wait(1) until part
    task.spawn(function()
        for _, v in pairs(a) do
            pcall(function()
                part.CFrame = v
                task.wait(0.5)
            end)
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
    local foundIslands = lp.foundIslands
    local A_1 = items[i]
    local A_2 = "Blazing Vortex Island"
    local Event = lp.ninjaEvent
    Event:FireServer(A_1, A_2)
    -- for _, v in pairs(foundIslands:GetChildren()) do
    --     Event:FireServer(A_1, v.Name)
    --     task.wait(0.1)
    -- end
end

local function autoDojo()
    local c = ws.dojoCircles.dojoCollectCircle.circleInner
    task.spawn(function()
        while task.wait() do
            if not getgenv().DOJO then break end;
            if not part then
                repeat task.wait(1) until part
            end
            firetouchinterest(part, c, 0)
            task.wait(0.1)
            firetouchinterest(part, c, 1)
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
            if not getgenv().SKILLS then break end;
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
    local Event = game:GetService("ReplicatedStorage").rEvents.openCrystalRemote
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

local function autoTp(player)
    task.spawn(function()
        while task.wait() do
            if not getgenv().TP then break end;
            repeat task.wait(1) until ws[player]
            local r = math.random(-10, 5)
            pcall(function()
                local cf = (ws[player].HumanoidRootPart.CFrame + Vector3.new(r, 0, r))
                part.CFrame = cf
                task.wait(0.3)
            end)
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
    local Event = game:GetService("ReplicatedStorage").rEvents.upgradeDojoTrainerRemote
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
    local ownedRanks = lp.ownedRanks
    local Ground = game:GetService("ReplicatedStorage").Ranks.Ground
    for _, v in pairs(Ground:GetChildren()) do
        -- print(v)
        local rank = Instance.new("BoolValue")
        rank.Name = v.Name
        rank.Parent = ownedRanks
        if v.Name == name then lp.equippedRank.Value = v; break end;
    end
end

-- Tabs

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://7992557358",
    PremiumOnly = false
})

PlayerTab:AddButton({
    Name = "Aimbot & ESP",
    Callback = function()
        alert("Aimbot & ESP Toggled.")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/AirHub.lua"))()
        end    
})

_G.infinjump = false
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Callback = function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Infinite%20Jump.txt"))()
        if _G.infinjump == false then
            alert("Infinite Jump", "Off.")
        else
            alert("Infinite Jump", "On.")
        end
        end
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 1,
    Max = 500,
    Default = 30,
    Save = true,
    Flag = "JUMP",
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "",
    Callback = function(Value)
        lp.Character.Humanoid.JumpPower = Value
    end
})

getgenv().ANTIAFK = false
PlayerTab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Save = true,
    Flag = "ANTIAFK",
    Callback = function(Value)
        getgenv().ANTIAFK = Value
        if Value then
            antiIdle()
        end
    end
})

getgenv().INVISIBILITY = false
PlayerTab:AddToggle({
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

getgenv().EQUIPSWORD = false
PlayerTab:AddToggle({
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

PlayerTab:AddButton({
    Name = "Rank Boost",
    Callback = function()
        rankBoost()
        end
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://6723742952",
    PremiumOnly = false
})

TeleportTab:AddToggle({
    Name = "Ctrl+Click to Teleport",
    Default = false,
    Save = true,
    Flag = "CTRLTP",
    Callback = function(Value)
        if Value then
            ctrlTp()
        end
    end
})

TeleportTab:AddButton({
    Name = "Unlock All Islands",
    Callback = function()
        unlockIslands()
        end
})

TeleportTab:AddDropdown({
    Name = "TP to Island",
    Default = "",
    Options = getIslandNames(),
    Callback = function(Value)
        local islandUnlockParts = ws.islandUnlockParts
        lp.Character.HumanoidRootPart.CFrame = islandUnlockParts[Value].islandSignPart.CFrame
    end
})

getgenv().PLAYER = lp.Name
TeleportTab:AddDropdown({
    Name = "TP to Player",
    Default = "",
    Options = getPlayerNames(),
    Callback = function(Value)
        getgenv().PLAYER = Value
        local p = ws[Value]
        if p then
            local cf = p.HumanoidRootPart.CFrame
            lp.Character.HumanoidRootPart.CFrame = cf
        end
    end
})

getgenv().TP = false
TeleportTab:AddToggle({
    Name = "Always TP to Player",
    Default = false,
    Save = true,
    Flag = "TP",
    Callback = function(Value)
        getgenv().TP = Value
        if Value then
            autoTp(getgenv().PLAYER)
        end
    end
})

local FarmTab = Window:MakeTab({
    Name = "Farming",
    Icon = "rbxassetid://11385265073",
    PremiumOnly = false
})

getgenv().SWING = false
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

getgenv().SELL = false
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

getgenv().HOOPS = false
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

getgenv().CHESTS = false
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

getgenv().CRATES = false
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
    Icon = "rbxassetid://7939405279",
    PremiumOnly = false
})

getgenv().SWORD = false
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

getgenv().BELT = false
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

getgenv().RANKS = false
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

getgenv().SKILLS = false
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

getgenv().SHURIKEN = false
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
    Icon = "rbxassetid://10653372143",
    PremiumOnly = false
})

getgenv().BOSS = "RobotBoss"
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

getgenv().AUTOBOSS = false
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
    Icon = "rbxassetid://7939410236",
    PremiumOnly = false
})

getgenv().CRYSTAL = false
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

getgenv().CRYSTALS = false
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

getgenv().EQUIP = false
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

getgenv().EVOLVE = false
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

getgenv().SELLPETS = false
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
    Icon = "rbxassetid://11183649951",
    PremiumOnly = false
})

getgenv().DOJO = false
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

getgenv().NINJA = false
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

getgenv().SENSEI = false
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

getgenv().CAPACITY = false
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

local UITab = Window:MakeTab({
    Name = "Server/GUI",
    Icon = "rbxassetid://9692125126",
    PremiumOnly = false
})

getgenv().FX = false
UITab:AddToggle({
    Name = "Disable Collection FX",
    Default = false,
    Save = true,
    Flag = "FX",
    Callback = function(Value)
        getgenv().FX = Value
        if Value then
            lp.PlayerGui.statEffectsGui.Enabled = not Value
        else
            lp.PlayerGui.statEffectsGui.Enabled = Value
        end
    end
})

UITab:AddButton({
    Name = "Redeem Codes",
    Callback = function()
        redeemCodes()
        end
})

UITab:AddButton({
    Name = "Server Hop",
    Callback = function()
        serverHop()
        end
})

UITab:AddButton({
    Name = "Close GUI",
    Callback = function()
        OrionLib:Destroy()
        end
})
