-- COPY THIS: loadstring(game:HttpGet("https://raw.githubusercontent.com/909scripts/Scripts/refs/heads/main/LGBTQ%2B%20Hangout%20Panel"))()

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local customizeFlag = workspace:FindFirstChild("CustomizeFlag")
if not customizeFlag then
    error("Cannot find the model 'CustomizeFlag.'")
    return
end

local updateNameTag: RemoteEvent = replicatedStorage:FindFirstChild("UpdateNameTag")
if not updateNameTag then
    error("Cannot find the remote event 'UpdateNameTag.'")
    return
end

local updateNameTagFlair: RemoteEvent = replicatedStorage:FindFirstChild("UpdateNameTagFlair")
if not updateNameTagFlair then
    error("Cannot find the remote event 'UpdateNameTagFlair.'")
    return
end

local renderStepped

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
    name = "LGBTQ+ Hangout Panel",
    subtitle = "909 Scripts",
    sidebarLayout = true,
})

local function notifyError(errorMsg: string)
    window:Notify({
        title = "Error",
        content = errorMsg,
        duration = 5,
    })
end

local function getCurrentNameTagData()
    local nameTagGui: BillboardGui = char.Head:FindFirstChild("NameTagGui")
    if not nameTagGui then
        notifyError("Cannot find your name tag.")
        return
    end
    
    local frame = nameTagGui:FindFirstChild("Frame")
    if not frame then
        notifyError("Cannot find the frame in the name tag GUI.")
        return
    end
    
    local nameRow: Frame = frame:FindFirstChild("NameRow")
    if not nameRow then
        notifyError("Cannot find the frame 'NameRow.'")
        return
    end
    
    local nameLabel: TextLabel = nameRow:FindFirstChild("NameLabel")
    if not nameLabel then
        notifyError("Cannot find the name label.")
        return
    end
    
    local uiGradient: UIGradient = nameLabel:FindFirstChild("UIGradient")
    if not uiGradient then
        notifyError("Cannot find the UI Gradient.")
        return
    end
    
    local pronounsLabel: TextLabel = nameTagGui:FindFirstChild("PronounsLabel")
    if not pronounsLabel then
        notifyError("Cannot find the pronouns label.")
        return
    end
    
    local nameTagData = {
        player.DisplayName,
        pronounsLabel.Text,
        Color3.new(1, 1, 1),
        uiGradient.Color,
        player.Team.Name
    }
    
    return nameTagData
end

local nameTagData = getCurrentNameTagData() or {
    player.DisplayName,
    "",
    Color3.new(1, 1, 1),
    nil,
    "Undecided"
}

local nameTagTab = window:CreateTab({ name = "Name Tag" })
--[[

NAME TAG
-------
Pronouns   [ Input ]
Name Color [ Color ]
Gradient   [ Toggle ] (This will toggle a panel, coming soon)

-------
Flairs

Left Flair  [ Input ]
Right Flair [ Input ]

]]

local function applyChange(tableVariable: number, value)
    nameTagData[tableVariable] = value
    updateNameTag:FireServer(nameTagData)
end

nameTagTab:CreateInput({
    name = "Pronouns",
    numeric = true,
    value = "16",
    placeholder = "Pro/Nouns",
    callback = function(text)
        applyChange(1, text)
    end
})

nameTagTab:CreateColorPicker({
    name = "Name Color",
    color = Color3.fromRGB(255, 255, 255),
    callback = function(color, alpha)
        local colorSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(1, color)
        })
        applyChange(2, colorSeq)
    end,
})

nameTagTab:CreateDivider()
nameTagTab:CreateText({
    name = "Flairs",
    text = "Edit Flairs"
})

nameTagTab:CreateInput({
    name = "Left Flair",
    numeric = true,
    value = "1",
    placeholder = "🌈",
    callback = function(text)
        updateNameTagFlair:FireServer("Left", text)
    end
})

nameTagTab:CreateInput({
    name = "Right Flair",
    numeric = true,
    value = "1",
    placeholder = "❤️",
    callback = function(text)
        updateNameTagFlair:FireServer("Right", text)
    end
})

local flagSectionTab = window:CreateTab({ name = "Flag Section" })
--[[

FLAG SECTION
------------
Fill Color [ Dropdown ]
Spam Color [ Toggle ]
]]

local brickColorOptions = {}
for i = 0, 127 do
    brickColorOptions[i] = BrickColor.palette(i)
end

local function isStandingOnFlag()
    local value = false
    
    char.PrimaryPart.Touched:Once(function(hit)
        if hit.Parent == customizeFlag then
            value = true
        end
    end)
    
    return value
end

local function fillColor(brickColorName: string)
    for _, child in customizeFlag:GetChildren() do
        if child:IsA("BasePart") and child.Name ~= "Border" then
            child.BrickColor = BrickColor.new(brickColorName)
        end
    end
end

local selectedColor

flagSectionTab:CreateDropdown({
    name = "Fill Color",
    multiSelect = true,
    options = brickColorOptions,
    value = { "Institutional white" },
    callback = function(selected)
        selectedColor = selected
        fillColor(selectedColor)
    end,
})

flagSectionTab:CreateToggle({
    name = "Spam Color",
    callback = function(value)
        if value then
            if renderStepped then renderStepped:Disconnect() end
            renderStepped = runService.RenderStepped:Connect(function()
                fillColor(selectedColor)
            end)
        else
            if renderStepped then renderStepped:Disconnect() end
        end
    end,
})
