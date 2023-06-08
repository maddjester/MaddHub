local ws = game:GetService("Workspace")

getgenv().UPGRADE = false
getgenv().SHOOT = true
getgenv().REWARDS = false

-- Functions

local function openBall()
    local args = {
        [1] = "spawn",
        [2] = true
        }
    game:GetService("ReplicatedStorage"):WaitForChild("events-shared/core/events.module@GlobalEvents"):WaitForChild("hatchCapsule"):FireServer(unpack(args))
end

local function upgradeAll()
    local stats = {"speed", "strength", "accuracy"}
    local args = ""
    for _, item in pairs(stats) do
        args = item
        game:GetService("ReplicatedStorage"):FindFirstChild("events-shared/core/events.module@GlobalEvents").upgrade:FireServer(args)
    end
end

local function autoUpgrade()
    task.spawn(function()
        while task.wait() do
            if not getgenv().UPGRADE then break end
            upgradeAll()
            task.wait(10)
        end
    end)
end

autoUpgrade()

local function shootBall()
    -- add check for button
    local args = {[1] = 0.7667316372301672}
    game:GetService("ReplicatedStorage"):WaitForChild("events-shared/core/events.module@GlobalEvents"):WaitForChild("throwBall"):FireServer(unpack(args))
end

local function farmHoops()
    local oldVal, newVal
    task.spawn(function()
        while task.wait() do
            if not getgenv().SHOOT then break end
            repeat
                oldVal = ws.Camera.BallEffects.Value
                task.wait(1)
                newVal = ws.Camera.BallEffects.Value    
            until
                oldVal ~= newVal and newVal ~= 10
            shootBall()
        end
    end)
end

farmHoops()

local function claimRewrds()
    local args = {[1] = 0}
    for i = 0, 8 do
        args[1] = i
        game:GetService("ReplicatedStorage"):WaitForChild("events-shared/core/events.module@GlobalEvents"):WaitForChild("claimReward"):FireServer(unpack(args))
    end
end

local function autoRewards()
    task.spawn(function()
        while task.wait() do
            if not getgenv().REWARDS then break end
            claimRewrds()
            task.wait(60)
        end
    end)
end

autoRewards()