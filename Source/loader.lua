-- GetKey.lua
-- Deprecated
getgenv().COREGUI = game:GetService("CoreGui")
if not game:IsLoaded() then
	local notLoaded = Instance.new("Message")
	notLoaded.Parent = getgenv().COREGUI
	notLoaded.Text = 'MaddHub is waiting for the game to load'
	game.Loaded:Wait()
	notLoaded:Destroy()
end

getgenv().URL = 'https://maddhub.replit.app'
getgenv().INPUT = ''

local CustomTheme = { Main = Color3.fromRGB(0, 0, 0), Second = Color3.fromRGB(25, 25, 25), Stroke = Color3.fromRGB(60, 140, 255), Divider = Color3.fromRGB(0, 150, 225), Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(60, 140, 255) }
local Lib = { Orion = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))() }
local Window = Lib.Orion:MakeWindow({ Name = "MaddHub | Key System", HidePremium = false, SaveConfig = false, IntroEnabled = false })
Lib.Orion.Themes["Custom"], Lib.Orion.SelectedTheme = CustomTheme, "Custom"

local function getHwid()
	local can_request = assert(request, "This executor does not support request function.")
    if not can_request then return end
    local body = request({Url = 'https://httpbin.org/get'; Method = 'GET'}).Body
    local decoded = game:GetService('HttpService'):JSONDecode(body)
    for k, v in pairs(decoded.headers) do
        if string.find(k, "-Fingerprint") then
            return v
        end
    end
    return '0'
end

local function discordNotification()
	Lib.Orion:MakeNotification({
        Name = "Welcome, "..game:GetService("Players").LocalPlayer.Name.."!",
        Content = "Discord Invite Copied!\nPress Ctrl + V to Paste the Link into a browser and join the MaddHub Official Discord to get the key.",
        Image = "rbxassetid://14389377814",
        Time = 15
    })
end

local function correctKeyNotification()
    Lib.Orion:MakeNotification({
        Name = "Correct Key!",
        Content = "You have entered the correct key!\nPlease wait while MaddHub loads.",
        Image = "rbxassetid://10871266112",
        Time = 5
    })
end

local function incorrectKeyNotification()
    Lib.Orion:MakeNotification({
        Name = "Incorrect Key!",
        Content = "You have entered an incorrect key!\nPlease join MaddHub Official Discord and get a valid key.",
        Image = "rbxassetid://10871266112",
        Time = 5
    })
end

local function checkKey(input)
	local query = '/validate?key='..input
	local url = getgenv().URL..query
    local response = game:HttpGet(url)
    if string.find(response, "([[This file was protected with MoonSec V3 by federal9999 on discord]])") ~= nil then
    	return response
	else
		return nil
	end
end

local Tab = Window:MakeTab({
	Name = "Key System",
	Icon = "rbxassetid://10871266112",
	PremiumOnly = false
})

Tab:AddParagraph("Discord Key Required\n","Copy and Paste the link into a browser.\n\n( https://scwz.me/okcQum )")

Tab:AddButton({
	Name = "Copy Link",
	Callback = function()
		setclipboard('https://scwz.me/okcQum')
        discordNotification()
	end
})

Tab:AddTextbox({
	Name = "Paste Key Here",
	Default = getgenv().INPUT,
	TextDisappear = true,
	Callback = function(Value)
		if Value == "" then
			return
		elseif #Value ~= 32 then
			getgenv().INPUT = ""
			incorrectKeyNotification()
			return
		else
			getgenv().INPUT = Value
		end
	end
})

Tab:AddButton({
	Name = "Activate",
	Callback = function()
		if getgenv().INPUT == "" then
			return
		end
		local payload
		pcall(function()
			payload = checkKey(getgenv().INPUT)
		end)
		if payload ~= nil then
			correctKeyNotification()
			return loadstring(payload)()
		else
			incorrectKeyNotification()
			return discordNotification()
		end
	end
})

discordNotification()
