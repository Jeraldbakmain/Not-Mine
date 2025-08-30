
if not isfile("femboyz real.png") then
    writefile("femboyz real.png", game:HttpGet("https://github.com/fuckg1thub/assets/raw/refs/heads/main/main_icon.png"))
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "join our discord 🙏",
    Text = "https://discord.gg/dWdkWHXRCn (copied to clipboard)",
    Icon = getcustomasset("femboyz real.png"),
    Duration = 15
})
setclipboard("https://discord.gg/h6jTe4C5")
