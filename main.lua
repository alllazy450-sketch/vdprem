-- ============================================================
--  W424HUB HUB – FULL VERSION (UI Included, No Key System)
-- ============================================================
print("=== LOADING W424HUB HUB FULL ===")

if not game:IsLoaded() then game.Loaded:Wait() end
local Players=game:GetService("Players")
while not Players.LocalPlayer do task.wait() end
while not workspace.CurrentCamera do task.wait() end
local cloneref=(cloneref or clonereference or function(v)return v end)
local RunService=cloneref(game:GetService("RunService"))
local UserInputService=cloneref(game:GetService("UserInputService"))
local Lighting=cloneref(game:GetService("Lighting"))
local Stats=cloneref(game:GetService("Stats"))
local VirtualInputManager=cloneref(game:GetService("VirtualInputManager"))
local CoreGui=cloneref(game:GetService("CoreGui"))
local GuiService=cloneref(game:GetService("GuiService"))
local ReplicatedStorage=cloneref(game:GetService("ReplicatedStorage"))
local PathfindingService=cloneref(game:GetService("PathfindingService"))
local ProximityPromptService=cloneref(game:GetService("ProximityPromptService"))
local HttpService=cloneref(game:GetService("HttpService"))
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local TargetGui = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or PlayerGui or CoreGui

-- ============================================================
--  W424HUB UI (No Key System)
-- ============================================================
local Kairo = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzzavi335/Kairo-Ui-Library/refs/heads/main/source.luau"))()
if not Kairo then warn("Kairo failed!") return end
local W424hub = Kairo
if not W424hub then
    warn("❌ W424hub UI gagal load! Pakai fallback...")
    -- Fallback UI sederhana
    local sg = Instance.new("ScreenGui")
    sg.Name = "W424hub_Fallback"
    sg.ResetOnSpawn = false
    sg.Parent = CoreGui
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 300, 0, 200)
    f.Position = UDim2.new(0.5, -150, 0.5, -100)
    f.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 40)
    t.Position = UDim2.new(0, 0, 0, 10)
    t.BackgroundTransparency = 1
    t.Text = "W424HUB HUB"
    t.TextColor3 = Color3.fromRGB(0, 200, 255)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 20
    local s = Instance.new("TextLabel", f)
    s.Size = UDim2.new(1, 0, 0, 30)
    s.Position = UDim2.new(0, 0, 0, 55)
    s.BackgroundTransparency = 1
    s.Text = "UI Loaded! Press K to open menu"
    s.TextColor3 = Color3.fromRGB(200, 200, 200)
    s.Font = Enum.Font.Gotham
    s.TextSize = 14
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.4, 0, 0, 40)
    btn.Position = UDim2.new(0.3, 0, 0.4, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    btn.Text = "Close"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() sg:Destroy() end)
    return
end
print("✅ W424hub UI loaded")

-- ============================================================
--  GLOBAL VARIABLES
-- ============================================================
getgenv().QUANTUM_CONNECTIONS = getgenv().QUANTUM_CONNECTIONS or {}
for _,conn in ipairs(getgenv().QUANTUM_CONNECTIONS) do
    pcall(function()
        RunService:UnbindFromRenderStep("SmoothFOV")
        if conn and conn.Disconnect then conn:Disconnect() end
    end)
end
table.clear(getgenv().QUANTUM_CONNECTIONS)

getgenv().QUANTUM_RUNNING = true
getgenv().AutoFarmSpeed = 17
getgenv().MoonwalkZigzagSpeed = 11
getgenv().MoonwalkBoostPower = 1.08
getgenv().ParryMatchup = "Auto"
getgenv().AimStrictness = 1.3
getgenv().ParryDelayOffset = 0
getgenv().AimbotSmoothness = 8
getgenv().AimbotPart = "Torso"
getgenv().AimbotTrigger = "Hold to Lock"
getgenv().GeneratorPerfectOffsetStart = 102
getgenv().GeneratorPerfectOffsetEnd = 108

local ESP_COLORS = {
    Killer    = Color3.fromRGB(255, 0, 60),
    Survivor  = Color3.fromRGB(0, 240, 255),
    Generator = Color3.fromRGB(255, 200, 0),
    Gate      = Color3.fromRGB(0, 255, 128),
    Pallet    = Color3.fromRGB(180, 0, 255),
    Hook      = Color3.fromRGB(255, 0, 150)
}
local MaskNames = {
    ["Abysswalker"] = "ABYSSWALKER",
    ["Cure"]        = "CURE",
    ["Hidden"]      = "HIDDEN",
    ["Killer"]      = "THE KILLER",
    ["Masked"]      = "PALA AYAM",
    ["Stalker"]     = "STALKER",
    ["Veil"]        = "VEIL",
    ["Slasher"]     = "SLASHER",
}
local MaskColors = {
    ["Abysswalker"] = Color3.fromRGB(255, 0, 60),
    ["Cure"]        = Color3.fromRGB(255, 0, 60),
    ["Hidden"]      = Color3.fromRGB(255, 0, 60),
    ["Killer"]      = Color3.fromRGB(255, 0, 60),
    ["Masked"]      = Color3.fromRGB(255, 0, 60),
    ["Stalker"]     = Color3.fromRGB(255, 0, 60),
    ["Veil"]        = Color3.fromRGB(255, 0, 60),
    ["Slasher"]     = Color3.fromRGB(255, 0, 60),
}
local CachedMapObjects = {Generators = {}, Pallets = {}, Hooks = {}, Gates = {}}
local PrevESPState = {Generator = false, Hook = false, Pallet = false, Gate = false}

local v3 = Vector3.new
local v2 = Vector2.new
local cnew = CFrame.new
local cangles = CFrame.Angles
local t_insert = table.insert
local t_remove = table.remove
local m_floor = math.floor
local m_round = math.round
local s_format = string.format

local SelfHeal = false
local MoonwalkEnabled = false
local MoonwalkConnection = nil
local KEY_TOGGLE = Enum.KeyCode.R
local AutoGenerator = false
local AutoGeneratorMode = "Perfect"
local AutoParry = false
local ParryDistance = 12
local RemoveParryCircle = false
local RemoveWarningMark = false
local ExactParryRemote = nil
local LastParryTick = 0
local CFG_AimPrediction = true
local CFG_BurstAmount = 8
local CFG_ParryCooldown = 0.45
local CFG_MaxVelocity = 32
local GenConnection = nil
local FailThread = nil
local SpeedBoost = false
local Aimbot = false
local TargetPartCache = {}
local WallCheck = true
local ShowFOVCircle = false
local CustomCameraFOV = false
local CameraFOVValue = 100
local AimRadius = getgenv().AimRadius or 60
local AimDistance = getgenv().AimDistance or 80
local AimKey = Enum.KeyCode.Q
local BoostSpeed = 30
local CachedTarget = nil
local LastTargetCheck = 0
local cachedChar, cachedRoot, cachedHum = nil, nil, nil
local AutoAttack = false
local AttackRange = 10
local WarnKiller = true
local ActiveGenerators = {}
local ThemeName = "W424hub HUB"
local Refreshing = false
local AutoFarmBot = false
local SilentAimPistol = false
local SilentAimFOV = 180
local SilentTarget = nil
local LastSilentCheck = 0
local LastSilentShot = 0
local DoubleDamageGen = false
local MobileRotateBtn = nil
local HitboxExpander = false
local HitboxSize = 15
local aimRayParams = RaycastParams.new()
aimRayParams.FilterType = Enum.RaycastFilterType.Blacklist
local SilentActions = false
local AntiFallDamage = false
local AntiLogger = true
local NotifyStun = false
local ESP_Enable = false
local ESP_Survivor_Name = true
local ESP_Survivor_Highlight = true
local ESP_Killer_Name = true
local ESP_Killer_Highlight = true
local ESP_Generator = true
local ESP_Gate = true
local ESP_Pallet = true
local ESP_Hook = true
local ActiveESP = {}
local LastKillerWarnCheck = 0
local closestKillerDist = 999
local LastUpdateTick = 0
local LastESPRefresh = 0
local TouchID = 8822
local FOVCircle = nil
local lastTouchCheck = 0
local cachedTouches = {}
local lastRenderCheck = 0
local cachedIsCarrying = false
local ESP_SCP = true
local SCPFolder = CoreGui:FindFirstChild("SCP_ESP") or Instance.new("Folder")
SCPFolder.Name = "SCP_ESP"
SCPFolder.Parent = CoreGui
local SCPCache = {}
local SCPConnection = nil
local isFPP = false
local fppHideConn = nil
local ESP_PlayerCache = {}
local GEN_COLOR_MID = Color3.fromRGB(255,140,0)
local GEN_COLOR_END = Color3.fromRGB(0,230,118)
local LastSkillHit = 0
local LastGoalRotation = 0
local LastTriggerTick = 0
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local CachedBasicAttack = nil
local SearchedAttackRemote = false
local lastAttackStrike = 0
local IgnoreSkills = {"Veil","Masked","Stalker","Invisible","Ghost","Phase","Dash","Warp","Teleport"}
local KillerProfiles = {
    Killer={BonusDist=1,Delay=0.04},
    Abysswalker={BonusDist=3.5,Delay=0.12},
    Hidden={BonusDist=2.2,Delay=0},
    Masked={BonusDist=1.5,Delay=0.05},
    Stalker={BonusDist=1.8,Delay=0},
    Veil={BonusDist=3.2,Delay=0.04},
    Slasher={BonusDist=1.2,Delay=0.05},
    Cure={BonusDist=2,Delay=0.03},
}
local CachedHBRemotes = {}
local SearchedHBRemotes = false
local CachedHealEvent = nil
local SearchHealRemote = false
local CrosshairImages = {
    Dot = "rbxassetid://9943168532",
    Scope = "rbxassetid://131437991032048",
    Circle = "rbxassetid://13441606488",
    Plus = "rbxassetid://125143421594685",
    Cross = "rbxassetid://139654963330788"
}

-- ============================================================
--  UI INDICATOR
-- ============================================================
local IndicatorGui = TargetGui:FindFirstChild("QUANTUM_Indicator") or Instance.new("ScreenGui")
IndicatorGui.Name = "QUANTUM_Indicator"
IndicatorGui.IgnoreGuiInset = true
IndicatorGui.ResetOnSpawn = false
IndicatorGui.Parent = TargetGui

if IndicatorGui:FindFirstChild("FOVCircle") then IndicatorGui.FOVCircle:Destroy() end
FOVCircle = Instance.new("Frame", IndicatorGui)
FOVCircle.Name = "FOVCircle"
FOVCircle.Size = UDim2.new(0, AimRadius * 2, 0, AimRadius * 2)
FOVCircle.AnchorPoint = v2(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = ShowFOVCircle
local corner = Instance.new("UICorner", FOVCircle)
corner.CornerRadius = UDim.new(1, 0)
local stroke = Instance.new("UIStroke", FOVCircle)
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.5
stroke.Thickness = 1.5

-- ============================================================
--  CROSSHAIR
-- ============================================================
if TargetGui:FindFirstChild("VeilCrosshair") then TargetGui.VeilCrosshair:Destroy() end
getgenv().CrosshairGui = Instance.new("ScreenGui")
getgenv().CrosshairGui.Name = "VeilCrosshair"
getgenv().CrosshairGui.IgnoreGuiInset = true
getgenv().CrosshairGui.ResetOnSpawn = false
getgenv().CrosshairGui.Enabled = false
getgenv().CrosshairGui.Parent = TargetGui
local crosshair = Instance.new("ImageLabel")
crosshair.Name = "Crosshair"
crosshair.Parent = getgenv().CrosshairGui
crosshair.AnchorPoint = Vector2.new(0.5,0.5)
crosshair.Position = UDim2.new(0.5,0,0.5,0)
crosshair.Size = UDim2.new(0,28,0,28)
crosshair.BackgroundTransparency = 1
crosshair.ImageColor3 = Color3.fromRGB(255,255,255)
crosshair.Image = "rbxassetid://9943168532"

-- ============================================================
--  PARRY RING
-- ============================================================
local oldRing = TargetGui:FindFirstChild("QUANTUM_ParryRing") or CoreGui:FindFirstChild("QUANTUM_ParryRing")
if oldRing then oldRing:Destroy() end
local ParryRing = Instance.new("CylinderHandleAdornment")
ParryRing.Name = "QUANTUM_ParryRing"
ParryRing.Color3 = Color3.fromRGB(0, 255, 128)
ParryRing.Transparency = 0.4
ParryRing.AlwaysOnTop = true
ParryRing.ZIndex = 10
ParryRing.Height = 0.05
ParryRing.CFrame = CFrame.new(0, -2.8, 0) * CFrame.Angles(math.rad(90), 0, 0)
ParryRing.Parent = CoreGui

-- ============================================================
--  MOONWALK UI BUTTON
-- ============================================================
local MoonwalkUI = Instance.new("ScreenGui")
local MoonwalkBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
pcall(function()
    MoonwalkUI.Name = "QUANTUM_MoonwalkUI"
    MoonwalkUI.Enabled = false
    MoonwalkUI.Parent = (game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
    MoonwalkUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end)
MoonwalkBtn.Name = "MoonwalkBtn"
MoonwalkBtn.Parent = MoonwalkUI
MoonwalkBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MoonwalkBtn.Position = UDim2.new(1, -95, 0.5, -35)
MoonwalkBtn.Size = UDim2.new(0, 65, 0, 65)
MoonwalkBtn.Font = Enum.Font.GothamBold
MoonwalkBtn.Text = "MW: OFF"
MoonwalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MoonwalkBtn.TextSize = 14
MoonwalkBtn.Draggable = true
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MoonwalkBtn
UIStroke.Color = Color3.fromRGB(100, 100, 100)
UIStroke.Thickness = 2
UIStroke.Parent = MoonwalkBtn

local function ToggleMoonwalk()
    getgenv().MoonwalkEnabled = not getgenv().MoonwalkEnabled
    if getgenv().MoonwalkEnabled then
        MoonwalkBtn.Text = "MW: ON"
        MoonwalkBtn.TextColor3 = Color3.fromRGB(247, 107, 28)
        UIStroke.Color = Color3.fromRGB(247, 107, 28)
    else
        MoonwalkBtn.Text = "MW: OFF"
        MoonwalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        UIStroke.Color = Color3.fromRGB(100, 100, 100)
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
end
MoonwalkBtn.MouseButton1Click:Connect(ToggleMoonwalk)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == KEY_TOGGLE then ToggleMoonwalk() end
end)

-- ============================================================
--  MOBILE BUTTONS
-- ============================================================
if IsMobile then
    local coreSuccess, coreResult = pcall(function() return cloneref(game:GetService("CoreGui")) end)
    local SafeGuiFolder = coreSuccess and coreResult or PlayerGui
    local combatGui = SafeGuiFolder:FindFirstChild("QUANTUM_MobileButtons") or Instance.new("ScreenGui")
    combatGui.Name = "QUANTUM_MobileButtons"
    combatGui.ResetOnSpawn = false
    combatGui.IgnoreGuiInset = true
    combatGui.Parent = SafeGuiFolder
    MobileRotateBtn = combatGui:FindFirstChild("RotateBtn") or Instance.new("TextButton")
    MobileRotateBtn.Name = "RotateBtn"
    MobileRotateBtn.Size = UDim2.new(0, 65, 0, 65)
    MobileRotateBtn.Position = UDim2.new(1, -85, 0.5, 30)
    MobileRotateBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MobileRotateBtn.BackgroundTransparency = 0.15
    MobileRotateBtn.AutoButtonColor = false
    MobileRotateBtn.Text = "TPP"
    MobileRotateBtn.TextColor3 = Color3.new(1, 1, 1)
    MobileRotateBtn.Font = Enum.Font.GothamBlack
    MobileRotateBtn.TextSize = 16
    MobileRotateBtn.Visible = false
    MobileRotateBtn.Parent = combatGui
    for _, child in ipairs(MobileRotateBtn:GetChildren()) do child:Destroy() end
    local corner2 = Instance.new("UICorner", MobileRotateBtn)
    corner2.CornerRadius = UDim.new(1, 0)
    local stroke2 = Instance.new("UIStroke", MobileRotateBtn)
    stroke2.Thickness = 2.5
    stroke2.Color = Color3.fromRGB(75, 150, 255)
    local gradient = Instance.new("UIGradient", MobileRotateBtn)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
    })
    gradient.Rotation = 45
    MobileRotateBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MobileRotateBtn.Size = UDim2.new(0, 58, 0, 58)
        end
    end)
    MobileRotateBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            MobileRotateBtn.Size = UDim2.new(0, 65, 0, 65)
            isFPP = not isFPP
            SwitchCameraMode(isFPP)
            stroke2.Color = isFPP and Color3.fromRGB(255, 100, 50) or Color3.fromRGB(75, 150, 255)
            MobileRotateBtn.Text = isFPP and "FPP" or "TPP"
        end
    end)
end

-- ============================================================
--  UI WINDOW
-- ============================================================
local Window = Kairo:CreateWindow({
    Title = "W424HUB",
    Theme = "Ocean",
    Size = UDim2.fromOffset(500, 480),
    Center = true,
    Draggable = true,
    Badges = {"v1.0"},
    MinimizeKey = Enum.KeyCode.K,
    MinimizeButton = true
})
warn("DEBUG Window="..tostring(Window~=nil))
if not Window then warn("Window failed!") return end

local TabInfo     = Window:CreateTab("Info")
local TabAuto     = Window:CreateTab("Auto")
local Tab4        = Window:CreateTab("Generator")
local Tab1        = Window:CreateTab("Survivor")
local TabKiller   = Window:CreateTab("Killer")
local Tab3        = Window:CreateTab("Combat")
local Tab2        = Window:CreateTab("Visuals")
local TabSettings = Window:CreateTab("Settings")

-- ===== TAB INFO =====
Window:AddDivider(TabInfo, "Informasi & Rules") local SecNotice = TabInfo --[[section]]
Window:AddParagraph(SecNotice, "⚠️ DILARANG DIPERJUALBELIKAN!", "")
Window:AddDivider(TabInfo, "Komunitas & Support") local SecCommunity = TabInfo --[[section]]
Window:AddParagraph(SecCommunity, "Official Discord Community", "")
Window:AddButton(SecCommunity, "Copy Discord Link", "", nil, function()
        local success = pcall(function() setclipboard("https://discord.gg/yGnU2sSWr") end)
        Window:Notify({
            Title = success and "Success" or "Clipboard Failed",
            Content = success and "Link Discord berhasil disalin: https://discord.gg/yGnU2sSWr" or "Executor tidak support clipboard.",
            Icon = success and "Check" or "X",
            Duration = 3
        })
    end)

-- ===== TAB AUTO =====
Window:AddDivider(TabAuto, "MoonWalk System") local MoonSection = TabAuto --[[section]]
Window:AddToggle(MoonSection, "Moonwalk", "", false, function(v)
        getgenv().MoonwalkEnabled = v
        if MoonwalkUI then MoonwalkUI.Enabled = v end
        if not v and cachedHum then cachedHum.AutoRotate = true end
        Window:Notify({
            Title = v and "Moonwalk Enabled" or "Moonwalk Disabled",
            Content = v and "Tekan tombol/R untuk mulai zigzag." or "Moonwalk dimatikan.",
            Icon = v and "RefreshCw" or "CircleOff",
            Duration = 3)
    end
})
Window:AddSlider(MoonSection, "MoonWalk Intensity", "", 5, 50, 11, function(v) getgenv().MoonwalkZigzagSpeed = v end)
Window:AddSlider(MoonSection, "Speed Boost MoonWalk", "", 1, 1, 1, function(v) getgenv().MoonwalkBoostPower = v end)

Window:AddDivider(TabAuto, "Auto Defense & Parry") local DefenseSection = TabAuto --[[section]]
Window:AddToggle(DefenseSection, "Enable Auto Parry", "", false, function(v)
        AutoParry = v
        UpdateParryRing()
        Window:Notify({
            Title = "Auto Parry",
            Content = v and "Enabled (Anti-Lag Ping Active)" or "Disabled",
            Icon = "Shield",
            Duration = 3)
    end
})
DefenseSection:CreateInput({
    Name = "Parry Range (studs)",
    Placeholder = "12",
    Default = tostring(ParryDistance),
    Desc = "Jarak deteksi studs untuk Auto Parry.",
    Callback = function(v)
        local num = tonumber(v)
        if num then
            ParryDistance = math.clamp(num, 1, 50)
            UpdateParryRing()
        end
    end
})
Window:AddToggle(DefenseSection, "Remove Parry Circle", "", false, function(v)
        RemoveParryCircle = v
        UpdateParryRing()
    end)
Window:AddToggle(DefenseSection, "Remove Warning Mark", "", false, function(v)
        RemoveWarningMark = v
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local warnGui = root:FindFirstChild("KillerWarn")
            if warnGui and v t