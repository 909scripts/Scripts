-- COPY THIS: 

-- NOTIF
loadstring(game:HttpGet("https://raw.githubusercontent.com/909scripts/Resources/refs/heads/main/notification.lua"))()

local replicatedStorage = game:GetService("ReplicatedStorage")

local booths = {}
for _, child in workspace:GetChildren() do
    if child.Name == "Booth" then
        table.insert(booths, child)
    end
end

local submitText: RemoteEvent = replicatedStorage.BoothRemotes:FindFirstChild("SubmitText")
if not submitText then
    error("Cannot find the remote event responsible for updating booths.")
    return
end

local boothInput = ""

local function updateBooth(boothText: Model)
    for _, booth in booths do
        submitText:FireServer(booth, boothText)
    end
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
    name = "Larp Yard Panel",
    subtitle = "909 Scripts",
    sidebarLayout = true,
})

local boothTab = window:CreateTab({ name = "Booth"})

boothTab:CreateText({
    name = "Edit Your Booth",
    text = "Equip a booth before using this. Edit your booth without going near it."
})

boothTab:CreateDivider()

boothTab:CreateInput({
    name = "Booth Text",
    numeric = false,
    value = "909 Scripts",
    placeholder = "Anything",
    callback = function(text)
        boothInput = text
        updateBooth(boothInput)
    end,
})
