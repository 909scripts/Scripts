-- COPY THIS: loadstring(game:HttpGet("https://raw.githubusercontent.com/909scripts/Scripts/refs/heads/main/Angel%20Island%20Admin%20Panel.lua"))()

-- NOTIF
loadstring(game:HttpGet("https://raw.githubusercontent.com/909scripts/Resources/refs/heads/main/notification.lua"))()

local playerGui = game.Players.LocalPlayer.PlayerGui

local function notifyError(errorMsg: string)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = errorMsg
    })
end

local adminGui: ScreenGui = playerGui:FindFirstChild("AdminGui")
if not adminGui then
    notifyError("Cannot find the admin panel.")
    return
end

local modmenus: Frame = adminGui:FindFirstChild("modmenus")
if not modmenus then
    notifyError("Cannot find the frame 'modmenus'")
    return
end

local notifs: TextLabel = adminGui:FindFirstChild("notifs")
if notifs then
    notifs.Visible = true
end

modmenus.Visible = true
