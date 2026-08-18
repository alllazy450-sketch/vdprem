-- link ui baru: https://github.com/Footagesus/WindUI



-- ============================================================
--  W424HUB HUB â€“ FULL VERSION (UI Included, No Key System)
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
--  W424HUB UI (Linoria)
-- ============================================================
local Debris = game:GetService("Debris")

-- KICAU KICAU, KICAU MANIAAAðŸ¤‘
local Library = nil
local LinWindow = nil
local _usingLinoria = false

local _lsrc
local _lok = pcall(function() _lsrc = game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua") end)
if _lok and _lsrc and #_lsrc > 100 then
    local _lfn, _lerr = loadstring(_lsrc)
    if _lfn then
        local _lok2, _lib = pcall(_lfn)
        if _lok2 and _lib then
            Library = _lib
            _usingLinoria = true
            -- Ocean theme
            Library.AccentColor     = Color3.fromRGB(0, 130, 200)
            Library.MainColor       = Color3.fromRGB(15, 25, 42)
            Library.BackgroundColor = Color3.fromRGB(10, 18, 30)
            Library.OutlineColor    = Color3.fromRGB(40, 60, 90)
            Library.FontColor       = Color3.fromRGB(210, 230, 255)
            LinWindow = Library:CreateWindow({Title = "W424HUB", Center = true, AutoShow = true})
            print("[W424HUB] Linoria UI loaded OK")
        else
            warn("[W424HUB] Linoria init failed, using NoUI mode")
        end
    else
        warn("[W424HUB] Linoria loadstring failed, using NoUI mode")
    end
else
    warn("[W424HUB] Linoria fetch failed (executor tidak support HttpGet), using NoUI mode")
end

-- ============================================================
--  KAIRO COMPATIBILITY SHIM (Linoria backend + NoUI fallback)
-- ============================================================
local _flagIdx = 0
local function _flag() _flagIdx = _flagIdx + 1 return "f"..tostring(_flagIdx) end
local _tabBoxes = {} -- tab -> {boxes={}, lastBox=nil}

-- Sentinel tab/box untuk NoUI mode â€” objek dummy agar tidak ada nil crash
local _DUMMY = setmetatable({}, {
    __index = function(_, k)
        return function(...) return _DUMMY end
    end,
    __newindex = function() end,
})

-- Window shim object
local Window = {}
setmetatable(Window, {__index = Window})

function Window:CreateTab(name)
    if not _usingLinoria or not LinWindow then return _DUMMY end
    local ok, tab = pcall(function() return LinWindow:AddTab(name) end)
    if not ok or not tab then return _DUMMY end
    _tabBoxes[tab] = {boxes={}, lastBox=nil}
    return tab
end

local function getBox(tab, title)
    if tab == _DUMMY then return _DUMMY end
    if not _tabBoxes[tab] then _tabBoxes[tab] = {boxes={}, lastBox=nil} end
    local t = _tabBoxes[tab]
    local bname = title or "Section"
    if not t.boxes[bname] then
        local ok, box = pcall(function() return tab:AddLeftGroupbox(bname) end)
        t.boxes[bname] = (ok and box) or _DUMMY
    end
    t.lastBox = t.boxes[bname]
    return t.lastBox
end


local function resolveBox(section)
    if not section or section == _DUMMY then return _DUMMY end

    local mt = getmetatable(section)
    local isLinoriaBox = mt == nil and type(rawget(section, "AddToggle")) == "function"
    if isLinoriaBox then return section end
    -- Cek via _tabBoxes
    local t = _tabBoxes[section]
    if t and t.lastBox then return t.lastBox end
    return _DUMMY
end

function Window:AddCollapsible(tab, title, open)
    return getBox(tab, title)
end

function Window:AddDivider(tab, title)
    return getBox(tab, title)
end

function Window:AddParagraph(tab, title, text)
    local box = getBox(tab, title)
    if box ~= _DUMMY then pcall(function() box:AddLabel(text or title) end) end
    return {Text = text}
end

function Window:AddToggle(section, title, desc, default, fn)
    local box = resolveBox(section)
    if box == _DUMMY then return end
    pcall(function()
        box:AddToggle(_flag(), {
            Text = title or "",
            Default = default or false,
            Callback = fn or function() end
        })
    end)
end

function Window:AddButton(section, title, desc, icon, fn)
    local box = resolveBox(section)
    if box == _DUMMY then return end
    pcall(function()
        box:AddButton({Text = title or "", Func = fn or function() end})
    end)
end

function Window:AddSlider(section, title, desc, min, max, default, fn)
    local box = resolveBox(section)
    if box == _DUMMY then return end
    pcall(function()
        box:AddSlider(_flag(), {
            Text = title or "",
            Min = min or 0,
            Max = max or 100,
            Default = default or 0,
            Rounding = 0,
            Callback = fn or function() end
        })
    end)
end

function Window:AddDropdown(section, title, desc, options, multi, default, fn)
    local box = resolveBox(section)
    if box == _DUMMY then return end
    pcall(function()
        box:AddDropdown(_flag(), {
            Text = title or "",
            Values = options or {},
            Default = 1,
            Multi = multi or false,
            Callback = fn or function() end
        })
    end)
end

function Window:AddInput(section, title, desc, placeholder, fn)
    local box = resolveBox(section)
    if box == _DUMMY then return end
    pcall(function()
        box:AddInput(_flag(), {
            Text = title or "",
            Default = placeholder or "",
            Numeric = false,
            Finished = false,
            Callback = fn or function() end
        })
    end)
end

function Window:Notify(t)
    if type(t) == "table" and _usingLinoria and Library and Library.Notify then
        pcall(function()
            Library:Notify({
                Title    = t.Title or "W424HUB",
                Content  = t.Description or t.Content or "",
                Duration = t.Duration or 3,
            })
        end)
    end
end

print("[W424HUB] Shim OK, usingLinoria=" .. tostring(_usingLinoria))

-- ============================================================
--  UI WINDOW
-- ============================================================
-- Window already created above (custom UI)

local TabInfo     = Window:CreateTab("Info")
local TabAuto     = Window:CreateTab("Auto")
local Tab4        = Window:CreateTab("Generator")
local Tab1        = Window:CreateTab("Survivor")
local TabKiller   = Window:CreateTab("Killer")
local Tab3        = Window:CreateTab("Combat")
local Tab2        = Window:CreateTab("Visuals")
local TabSettings = Window:CreateTab("Settings")

-- ===== TAB INFO =====
local SecNotice = TabInfo
Window:AddDivider(TabInfo, "Informasi & Rules")
-- Paragraph: âš ï¸ DILARANG DIPERJUALBELIKAN! - 
local SecCommunity = TabInfo
Window:AddDivider(TabInfo, "Komunitas & Support")
-- Paragraph: Official Discord Community - 
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
local MoonSection = TabAuto
Window:AddDivider(TabAuto, "MoonWalk System")
Window:AddToggle(MoonSection, "Moonwalk", "", false, function(v)
        getgenv().MoonwalkEnabled = v
        if MoonwalkUI then MoonwalkUI.Enabled = v end
        if not v and cachedHum then cachedHum.AutoRotate = true end
        Window:Notify({
            Title = v and "Moonwalk Enabled" or "Moonwalk Disabled",
            Content = v and "Tekan tombol/R untuk mulai zigzag." or "Moonwalk dimatikan.",
            Icon = v and "RefreshCw" or "CircleOff",
            Duration = 3})
    end)
Window:AddSlider(MoonSection, "MoonWalk Intensity", "", 5, 50, 11, function(v) getgenv().MoonwalkZigzagSpeed = v end)
Window:AddSlider(MoonSection, "Speed Boost MoonWalk", "", 1, 1, 1, function(v) getgenv().MoonwalkBoostPower = v end)

local DefenseSection = TabAuto
Window:AddDivider(TabAuto, "Auto Defense & Parry")
Window:AddToggle(DefenseSection, "Enable Auto Parry", "", false, function(v)
        AutoParry = v
        UpdateParryRing()
        Window:Notify({
            Title = "Auto Parry",
            Content = v and "Enabled (Anti-Lag Ping Active)" or "Disabled",
            Icon = "Shield",
            Duration = 3})
    end)
Window:AddInput(getBox(TabAuto, "Auto Defense & Parry"), "Parry Range (studs)", "Jarak deteksi studs untuk Auto Parry.", "12", function(v)
    local num = tonumber(v)
    if num then
        ParryDistance = math.clamp(num, 1, 50)
        UpdateParryRing()
    end
end)
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
            if warnGui and v then warnGui:Destroy() end
        end
    end)

local SurAutoSection = TabAuto
Window:AddDivider(TabAuto, "Auto Heal & Recovery")
Window:AddToggle(SurAutoSection, "Self Heal", "", false, function(v)
        SelfHeal = v
        Window:Notify({
            Title = v and "Self Heal Enabled" or "Self Heal Disabled",
            Content = v and "Heal remote diarahkan ke diri sendiri." or "Self Heal dimatikan.",
            Icon = v and "Heart" or "CircleOff",
            Duration = 3})
    end)

local FarmSection = TabAuto
Window:AddDivider(TabAuto, "Auto Farm Bot")
Window:AddToggle(FarmSection, "Auto Farm Bot", "", false, function(v)
        AutoFarmBot = v
        if not v then
            getgenv().CachedWaypoints = nil
            getgenv().AIFinalTarget = nil
        end
        Window:Notify({
            Title = v and "Auto Farm Enabled" or "Auto Farm Disabled",
            Content = v and "Bot aktif: repair gen, heal, evade killer." or "Auto Farm dimatikan.",
            Icon = v and "Bot" or "CircleOff",
            Duration = 3})
    end)

-- ===== TAB GENERATOR =====
local GenSec = Tab4
Window:AddDivider(Tab4, "Generator Automation")
Window:AddToggle(GenSec, "Auto Generator", "", false, function(v)
        AutoGenerator = v
        if not v then
            for _,con in pairs(HeartbeatConnections or {}) do pcall(function() con:Disconnect() end) end
            if HeartbeatConnections then table.clear(HeartbeatConnections) end
        end
    end)
Window:AddDropdown(GenSec, "SkillCheck Mode", "", {"Perfect", "Neutral"}, false, "Perfect", function(option)
        AutoGeneratorMode = option
        if option == "Perfect" then
            getgenv().GeneratorPerfectOffsetStart = 102
            getgenv().GeneratorPerfectOffsetEnd = 108
        else
            getgenv().GeneratorPerfectOffsetStart = 102
            getgenv().GeneratorPerfectOffsetEnd = 114
        end
    end)

-- ===== TAB SURVIVOR =====
local MoveSec = Tab1
Window:AddDivider(Tab1, "Movement Modification")
Window:AddToggle(MoveSec, "Speed Boost", "", false, function(v) SpeedBoost = v end)
Window:AddSlider(MoveSec, "Speed Boost Power", "", 0, 150, 8, function(v) BoostSpeed = tonumber(v) or 0 end)

local MoreSec = Tab1
Window:AddDivider(Tab1, "Survivor Utilities")
Window:AddToggle(MoreSec, "Silent Actions (Anti-Noise)", "", false, function(v) SilentActions = v end)
Window:AddToggle(MoreSec, "Anti Fall Slow", "", false, function(v) AntiFallDamage = v end)
Window:AddToggle(MoreSec, "Anti Aura (No Detect)", "", false, function(v) getgenv().AntiAura = v end)
Window:AddToggle(MoreSec, "Notify Killer Stun", "", false, function(v) NotifyStun = v end)
Window:AddToggle(MoreSec, "No Slowdown", "", false, function(v) NoSlowdown = v end)
Window:AddButton(MoreSec, "Force Reset State (Anti-Stuck)", "", nil, function() TriggerAntiStuck() end)
do
    local _box = getBox(Tab1, "Survivor Utilities")
    if _box and _box.AddKeybind then
        _box:AddKeybind(_flag(), {Text = "Anti-Stuck Hotkey (PC Only)", Default = Enum.KeyCode.L, Callback = function() TriggerAntiStuck() end})
    end
end

-- ===== TAB KILLER =====
local KAdvSec = TabKiller
Window:AddDivider(TabKiller, "Killer Advantages")
Window:AddToggle(KAdvSec, "Double Damage Generator", "", false, function(v) DoubleDamageGen = v end)
Window:AddButton(KAdvSec, "Activate Killer Power", "", nil, function()
    pcall(function() ReplicatedStorage.Remotes.Killers.Killer.ActivatePower:FireServer() end)
end)

local KAttackSec = TabKiller
Window:AddDivider(TabKiller, "Auto Attack System")
Window:AddToggle(KAttackSec, "Enable Auto Attack", "", false, function(v) AutoAttack = v end)
Window:AddSlider(KAttackSec, "Attack Range (Studs)", "", 5, 25, 10, function(v) AttackRange = tonumber(v) or 10 end)

-- ===== TAB COMBAT =====
local AimSec = Tab3
Window:AddDivider(Tab3, "Targeting System")
Window:AddToggle(AimSec, "Aimbot", "", false, function(v) Aimbot = v; if not v then CachedTarget = nil end end)
Window:AddToggle(AimSec, "Wall Check (Aimbot/Silent)", "", false, function(v) WallCheck = v end)
Window:AddToggle(AimSec, "Silent Aim Pistol", "", false, function(v)
        SilentAimPistol = v
        if not v then SilentTarget = nil; ResetScope() end
        Window:Notify({
            Title = v and "Silent Aim Enabled" or "Silent Aim Disabled",
            Content = v and "Auto lock aktif." or "Silent Aim dimatikan.",
            Icon = v and "Crosshair" or "CircleOff",
            Duration = 3})
    end)
Window:AddDropdown(AimSec, "Aimbot Target", "", {"Head", "Torso", "Body (RootPart)"}, false, "Torso", function(v) getgenv().AimbotPart = v end)
Window:AddDropdown(AimSec, "Aimbot Trigger", "", {"Hold to Lock", "Auto Lock (Always)"}, false, "Hold to Lock", function(v) getgenv().AimbotTrigger = v end)
Window:AddSlider(AimSec, "Aim Radius", "", 30, 150, 55, function(v)
        local val = tonumber(v) or 55
        AimRadius = val
        if FOVCircle then FOVCircle.Size = UDim2.new(0, val*2, 0, val*2) end
    end)
Window:AddToggle(AimSec, "Show Aim Radius", "", false, function(v) ShowFOVCircle = v; if FOVCircle then FOVCircle.Visible = v end end)

local HitboxSec = Tab3
Window:AddDivider(Tab3, "Hitbox Expander")
Window:AddToggle(HitboxSec, "Killer Hitbox", "", false, function(v)
        HitboxExpander = v
        if not v then
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hb = p.Character:FindFirstChild("QUANTUM_HITBOX") or p.Character:FindFirstChild("FORKT_HITBOX")
                    if hb then hb:Destroy() end
                end
            end
        end
    end)
Window:AddSlider(HitboxSec, "Hitbox Size", "", 2, 50, 15, function(v) HitboxSize = tonumber(v) or 15 end)

-- ===== TAB VISUALS =====
local CameraSection = Tab2
Window:AddDivider(Tab2, "Camera Settings")
Window:AddToggle(CameraSection, "Custom FOV", "", false, function(v) CustomCameraFOV = v end)
Window:AddSlider(CameraSection, "Field Of View", "", 70, 120, 100, function(v) CameraFOVValue = tonumber(v) or 100 end)
Window:AddToggle(CameraSection, "FPP / TPP Mode", "", false, function(v)
        local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        if isMobile then
            if MobileRotateBtn then
                MobileRotateBtn.Visible = v
                if not v then
                    isFPP = false
                    SwitchCameraMode(false)
                    MobileRotateBtn.BackgroundColor3 = Color3.fromRGB(75, 150, 255)
                    MobileRotateBtn.Text = "TPP"
                end
            end
        else
            isFPP = v
            SwitchCameraMode(v)
        end
    end)

local CrosshairSection = Tab2
Window:AddDivider(Tab2, "Crosshair Customization")
Window:AddToggle(CrosshairSection, "Crosshair", "", false, function(v) local gui = getgenv().CrosshairGui; if gui then gui.Enabled = v end end)
Window:AddDropdown(CrosshairSection, "Crosshair Style", "", {"Dot", "Scope", "Circle", "Plus", "Cross"}, false, "Dot", function(v) local gui = getgenv().CrosshairGui; if gui and gui:FindFirstChild("Crosshair") then gui.Crosshair.Image = CrosshairImages[v] end end)
Window:AddSlider(CrosshairSection, "Crosshair Size", "", 10, 80, 28, function(v)
        local size = tonumber(v) or 28
        local gui = getgenv().CrosshairGui
        if gui and gui:FindFirstChild("Crosshair") then gui.Crosshair.Size = UDim2.new(0, size, 0, size) end
    end)

local VisSec = Tab2
Window:AddDivider(Tab2, "Player & Entity Visuals")
Window:AddToggle(VisSec, "Enable ESP", "", false, function(v) ESP_Enable = v; RefreshESP() end)
Window:AddToggle(VisSec, "ESP Survivor (Name)", "", true, function(v) ESP_Survivor_Name = v; RefreshESP() end)
Window:AddToggle(VisSec, "ESP Survivor (Highlight)", "", true, function(v) ESP_Survivor_Highlight = v; RefreshESP() end)
Window:AddToggle(VisSec, "ESP Killer (Name)", "", true, function(v) ESP_Killer_Name = v; RefreshESP() end)
Window:AddToggle(VisSec, "ESP Killer (Highlight)", "", true, function(v) ESP_Killer_Highlight = v; RefreshESP() end)
Window:AddToggle(VisSec, "ESP SCP/Zombie", "", true, function(v) ESP_SCP = v end)

local ObjVisSec = Tab2
Window:AddDivider(Tab2, "Object Visuals")
Window:AddToggle(ObjVisSec, "ESP Generator", "", true, function(v) ESP_Generator = v; RefreshESP() end)
Window:AddToggle(ObjVisSec, "ESP Pallet", "", true, function(v) ESP_Pallet = v; RefreshESP() end)
Window:AddToggle(ObjVisSec, "ESP Exit Gate", "", true, function(v) ESP_Gate = v; RefreshESP() end)
Window:AddToggle(ObjVisSec, "ESP Hook", "", true, function(v) ESP_Hook = v; RefreshESP() end)

local OptSec = Tab2
Window:AddDivider(Tab2, "World Optimization")
Window:AddToggle(OptSec, "Remove All Visual Effects", "", false, function(v)
        if v then
            getgenv().QUANTUM_HiddenEffects = getgenv().QUANTUM_HiddenEffects or {}
            table.clear(getgenv().QUANTUM_HiddenEffects)
            local function hideEffects(parent)
                for _, effect in ipairs(parent:GetDescendants()) do
                    local n = string.lower(effect.Name)
                    if effect:IsA("PostEffect") or effect:IsA("Clouds") or effect:IsA("Atmosphere") or n:find("bloom") or n:find("dof") or n:find("sunray") or n:find("blur") then
                        if effect:IsA("Atmosphere") then
                            t_insert(getgenv().QUANTUM_HiddenEffects, {Obj = effect, OldParent = effect.Parent})
                            effect.Parent = nil
                        else
                            pcall(function()
                                if effect.Enabled then
                                    t_insert(getgenv().QUANTUM_HiddenEffects, {Obj = effect, WasEnabled = true})
                                    effect.Enabled = false
                                end
                            end)
                        end
                    end
                end
            end
            hideEffects(Lighting)
            hideEffects(workspace.CurrentCamera)
            getgenv().QUANTUM_OldFogStart = Lighting.FogStart
            getgenv().QUANTUM_OldFogEnd = Lighting.FogEnd
            Lighting.FogStart = 9e9
            Lighting.FogEnd = 9e9
            Window:Notify({ Title = "Vision Cleared", Description = "Semua filter layar dan kabut berhasil disembunyikan!", Icon = "EyeOff", Duration = 3 })
        else
            if getgenv().QUANTUM_HiddenEffects then
                for _, data in ipairs(getgenv().QUANTUM_HiddenEffects) do
                    if data.Obj then
                        if data.OldParent then data.Obj.Parent = data.OldParent
                        elseif data.WasEnabled then pcall(function() data.Obj.Enabled = true end) end
                    end
                end
                table.clear(getgenv().QUANTUM_HiddenEffects)
            end
            if getgenv().QUANTUM_OldFogStart then
                Lighting.FogStart = getgenv().QUANTUM_OldFogStart
                Lighting.FogEnd = getgenv().QUANTUM_OldFogEnd
            end
            Window:Notify({ Title = "Vision Restored", Description = "Efek visual bawaan game dikembalikan.", Icon = "Eye", Duration = 3 })
        end
    end
})
Window:AddButton(OptSec, "Force Fullbright", "", nil, function()
        Lighting.Ambient = Color3.fromRGB(170, 170, 170)
        Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.Brightness = 1.9
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.FogStart = 9e9
        Lighting.FogEnd = 9e9
        for _, effect in ipairs(Lighting:GetDescendants()) do
            if effect:IsA("Atmosphere") or effect:IsA("Sky") then pcall(function() effect:Destroy() end)
            elseif effect:IsA("PostEffect") or effect:IsA("Clouds") then pcall(function() effect.Enabled = false end) end
        end
    end)
Window:AddButton(OptSec, "Potato Mode", "", nil, function()
        Window:Notify({ Title = "Potato Mode", Description = "Mengoptimalkan map untuk HP kentang...", Icon = "Cpu", Duration = 3})
        task.spawn(function()
            Lighting.GlobalShadows = false
            Lighting.ShadowSoftness = 0
            Lighting.FogEnd = 9e9
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            for _, effect in ipairs(Lighting:GetDescendants()) do
                if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Clouds") then pcall(function() effect.Enabled = false end) end
            end
            local terrain = workspace.Terrain
            if terrain then
                pcall(function()
                    terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0; terrain.WaterReflectance = 0; terrain.WaterTransparency = 0; terrain.Decoration = false
                end)
            end
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local v = descendants[i]
                local class = v.ClassName
                if class == "Part" or class == "MeshPart" or class == "UnionOperation" then
                    pcall(function()
                        if v.Material ~= Enum.Material.SmoothPlastic then v.Material = Enum.Material.SmoothPlastic end
                        if v.Reflectance ~= 0 then v.Reflectance = 0 end
                        if v.CastShadow then v.CastShadow = false end
                    end)
                elseif class == "Decal" or class == "Texture" or class == "SurfaceAppearance" then
                    pcall(function() if v.Parent then v:Destroy() end end)
                elseif class == "ParticleEmitter" or class == "Trail" or class == "Beam" or class == "Smoke" or class == "Fire" or class == "Sparkles" or class == "BloomEffect" or class == "BlurEffect" or class == "SunRaysEffect" or class == "ColorCorrectionEffect" or class == "DepthOfFieldEffect" then
                    pcall(function() if v.Enabled then v.Enabled = false end end)
                end
                if i % 300 == 0 then task.wait() end
            end
            Window:Notify({ Title = "Optimization Complete!", Description = "Potato Mode berhasil diterapkan. Tekstur dihapus, FPS Boosted!", Icon = "Check", Duration = 3 })
        end)
    end)

-- ===== TAB SETTINGS =====
local SecProtect = TabSettings
Window:AddDivider(TabSettings, "Security & Protection")
Window:AddToggle(SecProtect, "Anti-Logger (Bypass Anti-Cheat)", "", true, function(v) AntiLogger = v end)

local InterfaceSec = TabSettings
Window:AddDivider(TabSettings, "Window & Interface")
Window:AddButton(InterfaceSec, "Unload W424hub HUB", "", nil, function()
        getgenv().QUANTUM_RUNNING = false
        pcall(function() if MainWindowScreen then MainWindowScreen:Destroy() end end)
        pcall(function() RunService:UnbindFromRenderStep("SmoothFOV") end)
        if getgenv().QUANTUM_CONNECTIONS then
            for _, conn in ipairs(getgenv().QUANTUM_CONNECTIONS) do
                if conn.Disconnect then conn:Disconnect() end
            end
            table.clear(getgenv().QUANTUM_CONNECTIONS)
        end
        if CrosshairGui then CrosshairGui:Destroy(); CrosshairGui = nil end
        if ParryRing then ParryRing:Destroy(); ParryRing = nil end
        if IndicatorGui then IndicatorGui:Destroy(); IndicatorGui = nil end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local h = p.Character:FindFirstChild("H")
                if h then h:Destroy() end
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local tag = root:FindFirstChild("TagESP")
                    if tag then tag:Destroy() end
                end
            end
        end
        if CachedMapObjects then
            for _, list in pairs(CachedMapObjects) do
                for _, obj in ipairs(list) do
                    local h = obj:FindFirstChild("H")
                    if h then h:Destroy() end
                end
            end
        end
    end)

-- ============================================================
--  VARIABLE INITIALIZATION
-- ============================================================

-- Lua shorthand aliases
local t_insert = table.insert
local t_remove = table.remove
local m_floor  = math.floor
local m_round  = math.round or function(n) return math.floor(n + 0.5) end
local s_format = string.format
local v3       = Vector3.new
local cnew     = CFrame.new
local cangles  = CFrame.Angles

-- Runtime / system flags
getgenv().QUANTUM_RUNNING     = true
getgenv().QUANTUM_CONNECTIONS = getgenv().QUANTUM_CONNECTIONS or {}

-- Feature toggles (default off unless set by UI)
local SpeedBoost         = false
local BoostSpeed         = 0
local NoSlowdown         = false
local SilentActions      = false
local AntiFallDamage     = false
local NotifyStun         = false
local AutoGenerator      = false
local AutoGeneratorMode  = "Perfect"
local AutoParry          = false
local ParryDistance      = 12
local RemoveParryCircle  = false
local RemoveWarningMark  = false
local SelfHeal           = false
local DoubleDamageGen    = false
local AutoAttack         = false
local AttackRange        = 10
local HitboxExpander     = false
local HitboxSize         = 15
local Aimbot             = false
local SilentAimPistol    = false
local AimRadius          = 55
local ShowFOVCircle      = false
local CustomCameraFOV    = false
local CameraFOVValue     = 100
local AntiLogger         = true
local AutoFarmBot        = false
local WallCheck          = false
local SilentAimFOV       = 250
local AimDistance        = 500

-- ESP flags
local ESP_Enable          = false
local ESP_Survivor_Name   = true
local ESP_Survivor_Highlight = true
local ESP_Killer_Name     = true
local ESP_Killer_Highlight = true
local ESP_SCP             = true
local ESP_Generator       = true
local ESP_Pallet          = true
local ESP_Gate            = true
local ESP_Hook            = true

-- ESP color palette
local ESP_COLORS = {
    Killer    = Color3.fromRGB(255, 50,  50),
    Survivor  = Color3.fromRGB(80,  200, 255),
    Generator = Color3.fromRGB(255, 220, 50),
    Gate      = Color3.fromRGB(50,  255, 100),
    Hook      = Color3.fromRGB(200, 80,  255),
    Pallet    = Color3.fromRGB(255, 160, 30),
}
local GEN_COLOR_MID = Color3.fromRGB(255, 200, 30)
local GEN_COLOR_END = Color3.fromRGB(50,  255, 80)

-- Killer mask name map
local MaskNames = {
    Trapper       = "TRAPPER",    Wraith       = "WRAITH",
    Hillbilly     = "HILLBILLY",  Nurse        = "NURSE",
    Shape         = "SHAPE",      Hag          = "HAG",
    Doctor        = "DOCTOR",     Huntress     = "HUNTRESS",
    Cannibal      = "CANNIBAL",   Nightmare    = "NIGHTMARE",
    Pig           = "PIG",        Clown        = "CLOWN",
    Spirit        = "SPIRIT",     Legion       = "LEGION",
    Plague        = "PLAGUE",     GhostFace    = "GHOSTFACE",
    Demogorgon    = "DEMOGORGON", Oni          = "ONI",
    Deathslinger  = "DEATH",      Executioner  = "PYRAMID",
    Blight        = "BLIGHT",     Twins        = "TWINS",
    Trickster     = "TRICKSTER",  Nemesis      = "NEMESIS",
    Cenobite      = "CENOBITE",   Artist       = "ARTIST",
    Onryo         = "ONRYO",      Dredge       = "DREDGE",
    Mastermind    = "MASTER",     Knight       = "KNIGHT",
    Skull         = "SKULL",      Singularity  = "SINGULAR",
    Xenomorph     = "XENO",       Chucky       = "CHUCKY",
    Unknown       = "UNKNOWN",    Lich         = "LICH",
    Dark          = "DARK",
}

-- Killer profiles for Auto Parry
local KillerProfiles = {
    Trapper = {BonusDist=1, Delay=0}, Wraith = {BonusDist=2, Delay=0},
    Hillbilly = {BonusDist=2, Delay=0}, Nurse = {BonusDist=0, Delay=0},
    Shape = {BonusDist=1, Delay=0}, Hag = {BonusDist=1, Delay=0},
    Doctor = {BonusDist=1, Delay=0}, Huntress = {BonusDist=3, Delay=0.05},
    Cannibal = {BonusDist=2, Delay=0}, Nightmare = {BonusDist=1, Delay=0},
    Blight = {BonusDist=2, Delay=0}, Trickster = {BonusDist=3, Delay=0.05},
}
local IgnoreSkills = {"IsPhasing","IsBlinking","IsTeleporting","IsCharging","IsCloaked","IsWraith"}

-- Map object cache
local CachedMapObjects = {Generators = {}, Pallets = {}, Hooks = {}, Gates = {}}
local ActiveGenerators = {}
local PrevESPState = {Generator = false, Pallet = false, Gate = false, Hook = false}
local ESP_PlayerCache = {}

-- SCP ESP
local SCPCache = {}
local SCPFolder = Instance.new("Folder")
SCPFolder.Name = "SCPESP_Folder"
SCPFolder.Parent = workspace
local SCPConnection = nil

-- Crosshair images
local CrosshairImages = {
    Dot    = "rbxassetid://6765464380",
    Scope  = "rbxassetid://6765464578",
    Circle = "rbxassetid://6765464500",
    Plus   = "rbxassetid://6765464644",
    Cross  = "rbxassetid://6765464700",
}

-- Parry / combat state
local ExactParryRemote = nil
local LastParryTick    = 0
local ParryRing        = nil

-- Aimbot / targeting state
local CachedTarget      = nil
local FOVCircle         = nil
local SilentTarget      = nil
local TargetPartCache   = {}
local cachedRayFilter   = {}
local aimRayParams      = RaycastParams.new()
aimRayParams.FilterType = Enum.RaycastFilterType.Exclude

-- Generator automation state
local GenConnection    = nil
local HeartbeatConnections = {}
local LastGoalRotation = 0
local LastSkillHit     = 0
local LastTriggerTick  = 0

-- Anti-stuck / movement
local TriggerAntiStuck = function() end -- defined later; forward reference
local ForceUnstuck     = function() end -- defined later
local lastAttackStrike = 0

-- Remote caches
local CachedHealEvent      = nil
local SearchHealRemote     = false
local CachedBasicAttack    = nil
local SearchedAttackRemote = false
local CachedHBRemotes      = {DisplayBlood = nil, FallDamage = nil, HealEvent = nil}
local SearchedHBRemotes    = false

-- Camera / FPP
local isFPP        = false
local fppHideConn  = nil
local MobileRotateBtn = nil

-- Mobile detection
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ESP timing
local LastESPRefresh = 0
local closestKillerDist = 999

-- Moonwalk state
local cachedHum          = nil
local MoonwalkUI         = nil
local CurrentMoonwalkYaw  = 0
local CurrentMoonwalkSway = 0

-- Indicator / warning GUI
local IndicatorGui    = nil
local CrosshairGui    = nil
local MainWindowScreen = nil

-- ============================================================
--  CORE FUNCTIONS (Dari W424hub Hub Original)
-- ============================================================

local function UpdateMapCache()
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    CachedMapObjects.Generators = {}
    CachedMapObjects.Pallets = {}
    CachedMapObjects.Hooks = {}
    CachedMapObjects.Gates = {}
    local descendants = map:GetDescendants()
    for i = 1, #descendants do
        local obj = descendants[i]
        local n = obj.Name
        if n == "Generator" then t_insert(CachedMapObjects.Generators, obj)
        elseif n == "Hook" then t_insert(CachedMapObjects.Hooks, obj)
        elseif n == "Gate" then t_insert(CachedMapObjects.Gates, obj)
        elseif n == "Pallet" or n == "Palletwrong" then t_insert(CachedMapObjects.Pallets, obj)
        end
        if i % 500 == 0 then task.wait() end
    end
    if PrevESPState then
        PrevESPState.Generator = false; PrevESPState.Hook = false
        PrevESPState.Pallet = false; PrevESPState.Gate = false
    end
end

task.spawn(function()
    local mapWasEmpty = true
    local descendantConn = nil
    while task.wait(2) do
        if not getgenv().QUANTUM_RUNNING then
            if descendantConn then descendantConn:Disconnect() end
            break
        end
        local currentMap = workspace:FindFirstChild("Map")
        local hasContents = currentMap and #currentMap:GetChildren() > 0
        if hasContents and mapWasEmpty then
            mapWasEmpty = false
            task.delay(8, function()
                if currentMap and #currentMap:GetChildren() > 0 then
                    UpdateMapCache()
                    if descendantConn then descendantConn:Disconnect() end
                    descendantConn = currentMap.DescendantAdded:Connect(function(obj)
                        local n = obj.Name
                        if n == "Generator" then t_insert(CachedMapObjects.Generators, obj)
                        elseif n == "Hook" then t_insert(CachedMapObjects.Hooks, obj)
                        elseif n == "Gate" then t_insert(CachedMapObjects.Gates, obj)
                        elseif n == "Pallet" or n == "Palletwrong" then t_insert(CachedMapObjects.Pallets, obj)
                        end
                    end)
                    local palletCount = CachedMapObjects.Pallets and #CachedMapObjects.Pallets or 0
                    local genCount = CachedMapObjects.Generators and #CachedMapObjects.Generators or 0
                    print("[W424hub] Map Loaded: " .. palletCount .. " Pallet & " .. genCount .. " Gen.")
                end
            end)
        elseif not hasContents and not mapWasEmpty then
            mapWasEmpty = true
            if descendantConn then descendantConn:Disconnect(); descendantConn = nil end
            CachedMapObjects.Generators = {}; CachedMapObjects.Pallets = {}
            CachedMapObjects.Hooks = {}; CachedMapObjects.Gates = {}
            if ActiveGenerators then table.clear(ActiveGenerators) end
            if PrevESPState then
                PrevESPState.Generator = false; PrevESPState.Hook = false
                PrevESPState.Pallet = false; PrevESPState.Gate = false
            end
        end
    end
end)

local function IsSCP(v)
    if not(v and v:IsA("Model")) then return false end
    local n = v.Name:lower()
    return n == "scp" or n:match("^scp%d*$") or n:match("^scp[%-%_]?%d+$") or n:find("zombie") or n:find("monster") or n:find("infected") or n:find("mutant")
end

local function RemoveSCP(v)
    local h = SCPCache[v]
    if h then pcall(function() h:Destroy() end) end
    SCPCache[v] = nil
end

local function CreateSCP(v)
    if not ESP_Enable or not ESP_SCP or SCPCache[v] or not(v and v.Parent) or not IsSCP(v) then return end
    local root = v:FindFirstChild("HumanoidRootPart",true) or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart",true)
    if not root then return end
    local h = Instance.new("Highlight")
    h.Name = "SCPESP"
    h.Adornee = v
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillColor = Color3.fromRGB(170,0,255)
    h.OutlineColor = Color3.fromRGB(255,220,255)
    h.FillTransparency = 0.78
    h.OutlineTransparency = 0.03
    h.Parent = SCPFolder
    SCPCache[v] = h
    v.AncestryChanged:Connect(function(_,p) if not p then RemoveSCP(v) end end)
    local hum = v:FindFirstChildOfClass("Humanoid")
    if hum then hum.Died:Connect(function() RemoveSCP(v) end) end
end

local function ScanSCP()
    for _,v in ipairs(workspace:GetChildren()) do if IsSCP(v) then CreateSCP(v) end end
end

local function ConnectSCP()
    if SCPConnection then SCPConnection:Disconnect() end
    SCPConnection = workspace.ChildAdded:Connect(function(v)
        if not ESP_SCP or not(v and v:IsA("Model")) then return end
        task.delay(0.12, function() if v and v.Parent and IsSCP(v) then CreateSCP(v) end end)
    end)
end
ConnectSCP()
ScanSCP()

task.spawn(function()
    while task.wait(0.7) do
        if not getgenv().QUANTUM_RUNNING then break end
        if not ESP_Enable or not ESP_SCP then
            for v in pairs(SCPCache) do RemoveSCP(v) end
        else
            for v,h in pairs(SCPCache) do
                if not(v and v.Parent and h and h.Parent) then RemoveSCP(v)
                else
                    if h.Adornee ~= v then h.Adornee = v end
                    if h.FillTransparency ~= 0.78 then h.FillTransparency = 0.78 end
                    if h.OutlineTransparency ~= 0.03 then h.OutlineTransparency = 0.03 end
                end
            end
            ScanSCP()
        end
    end
end)

local function GetGameValue(obj, name)
    if typeof(obj) ~= "Instance" then return nil end
    local attr = obj:GetAttribute(name)
    if attr ~= nil then return attr end
    local child = obj:FindFirstChild(name)
    if child then
        if child:IsA("ValueBase") then return child.Value end
    end
    return nil
end

local function ApplyHighlight(object,color)
    local h = object:FindFirstChild("H")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "H"
        h.Adornee = object
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillTransparency = 0.82
        h.OutlineTransparency = 0.03
        h.LineThickness = 2
        h.Parent = object
    end
    if h.FillColor ~= color then
        h.FillColor = color
        h.OutlineColor = color:Lerp(Color3.new(1,1,1), 0.15)
    end
    local root = object:FindFirstChild("HumanoidRootPart") or object.PrimaryPart
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and myRoot then
        local dist = (root.Position - myRoot.Position).Magnitude
        if dist > 120 then
            h.FillTransparency = 0.92; h.OutlineTransparency = 0
        elseif dist > 70 then
            h.FillTransparency = 0.88; h.OutlineTransparency = 0.02
        else
            h.FillTransparency = 0.82; h.OutlineTransparency = 0.05
        end
    end
    if not h.Enabled then h.Enabled = true end
end

local function RemoveHighlight(object)
    if object then
        local h = object:FindFirstChild("H")
        if h then h:Destroy() end
    end
end

local function CreateBillboardTag(text, color, size, textSize)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TagESP"
    billboard.AlwaysOnTop = true
    billboard.Size = size or UDim2.new(0, 150, 0, 40)
    billboard.LightInfluence = 0
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = Enum.Font.GothamBold
    label.TextSize = textSize or 12
    label.TextWrapped = true
    label.RichText = true
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Transparency = 0.2
    stroke.Parent = label
    label.Parent = billboard
    return billboard
end

local function RemovePlayerESP(player)
    local char = player.Character
    if char then
        RemoveHighlight(char)
        local bg = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("TagESP")
        if bg then bg:Destroy() end
    end
end

local function CreatePlayerESP(player,isKiller)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then
        RemovePlayerESP(player)
        ESP_PlayerCache[player.UserId] = nil
        return
    end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local dist = m_floor((root.Position - myRoot.Position).Magnitude)
    local color = isKiller and ESP_COLORS.Killer or ESP_COLORS.Survivor
    local statusText = ""
    if isKiller then
        local detectedMask = char:GetAttribute("CachedMask") or char:GetAttribute("KillerType") or char:GetAttribute("SelectedKiller") or GetGameValue(char,"SelectedKiller") or GetGameValue(player,"SelectedKiller") or GetGameValue(char,"Mask") or GetGameValue(player,"Mask") or char.Name
        if detectedMask then char:SetAttribute("CachedMask",detectedMask) end
        statusText = MaskNames[detectedMask] or "KILLER"
        color = ESP_COLORS.Killer
    else
        local function IsActive(v) return v == true or (type(v) == "number" and v > 0) end
        local hooked = IsActive(GetGameValue(char,"IsHooked")) or IsActive(GetGameValue(player,"IsHooked"))
        local carried = IsActive(GetGameValue(char,"Carried")) or IsActive(GetGameValue(char,"IsCarried")) or IsActive(GetGameValue(char,"Grabbed")) or IsActive(GetGameValue(player,"Carried"))
        local knocked = IsActive(GetGameValue(char,"Knocked")) or IsActive(GetGameValue(char,"IsKnocked"))
        if hooked then
            color = Color3.fromRGB(255,40,120); statusText = "HOOKED"
        elseif carried then
            color = Color3.fromRGB(160,70,255); statusText = "CARRIED"
        elseif knocked then
            color = Color3.fromRGB(255,160,0); statusText = "KNOCKED"
        elseif hum.Health < hum.MaxHealth then
            color = Color3.fromRGB(255,215,0); statusText = "INJURED"
        else
            statusText = nil; color = ESP_COLORS.Survivor
        end
    end
    local statusDisplay = statusText or (isKiller and "KILLER" or "SURVIVOR")
    local finalName = s_format('<b><font color="#FFFFFF">%s</font></b> <font color="#%s">[%s]</font>', player.Name, color:ToHex(), string.upper(statusDisplay))
    ESP_PlayerCache[player.UserId] = {dist = dist, status = statusText}
    local showName = isKiller and ESP_Killer_Name or ESP_Survivor_Name
    local showHighlight = isKiller and ESP_Killer_Highlight or ESP_Survivor_Highlight
    if showHighlight then ApplyHighlight(char,color) else RemoveHighlight(char) end
    local bg = root:FindFirstChild("TagESP")
    if showName then
        if not bg then
            bg = Instance.new("BillboardGui")
            bg.Name = "TagESP"
            bg.Parent = root
            bg.Adornee = root
            bg.AlwaysOnTop = true
            bg.LightInfluence = 0
            bg.ResetOnSpawn = false
            bg.MaxDistance = 1800
            bg.Size = UDim2.new(0,160,0,22)
            bg.StudsOffset = v3(0,3.2,0)
            local lbl = Instance.new("TextLabel")
            lbl.Name = "Label"
            lbl.Parent = bg
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.fromScale(1,1)
            lbl.RichText = true
            lbl.TextScaled = false
            lbl.TextWrapped = false
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextStrokeTransparency = 1
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.Text = finalName
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            local stroke = Instance.new("UIStroke")
            stroke.Parent = lbl
            stroke.Thickness = 1.2
            stroke.Transparency = 0.2
            stroke.Color = Color3.new(0,0,0)
            local constraint = Instance.new("UITextSizeConstraint")
            constraint.Parent = lbl
            constraint.MaxTextSize = 12
            constraint.MinTextSize = 8
        else
            local lbl = bg:FindFirstChild("Label")
            if lbl then
                lbl.Text = finalName
                if dist > 220 then
                    bg.Size = UDim2.new(0,130,0,18); bg.StudsOffset = v3(0,2.6,0); lbl.TextSize = 9; lbl.TextTransparency = 0.15
                elseif dist > 150 then
                    bg.Size = UDim2.new(0,145,0,20); bg.StudsOffset = v3(0,2.9,0); lbl.TextSize = 10; lbl.TextTransparency = 0.08
                elseif dist > 90 then
                    bg.Size = UDim2.new(0,160,0,22); bg.StudsOffset = v3(0,3.2,0); lbl.TextSize = 11; lbl.TextTransparency = 0
                else
                    bg.Size = UDim2.new(0,175,0,24); bg.StudsOffset = v3(0,3.5,0); lbl.TextSize = 11.5; lbl.TextTransparency = 0
                end
            end
        end
    elseif bg then
        bg:Destroy()
    end
end

local function updateGeneratorProgress(generator)
    if not generator or not generator.Parent then return true end
    local percent = GetGameValue(generator,"RepairProgress") or GetGameValue(generator,"Progress") or 0
    local billboard = generator:FindFirstChild("GenBitchHook")
    if percent >= 100 or not ESP_Generator then
        if billboard then billboard:Destroy() end
        RemoveHighlight(generator)
        generator:SetAttribute("LastESPPercent",nil)
        return percent >= 100
    end
    local rounded = math.floor(percent * 10) / 10
    if generator:GetAttribute("LastESPPercent") == rounded and billboard then return false end
    generator:SetAttribute("LastESPPercent", rounded)
    local cp = math.clamp(percent,0,100)
    local finalColor = cp < 50 and ESP_COLORS.Generator:Lerp(GEN_COLOR_MID, cp/50) or GEN_COLOR_MID:Lerp(GEN_COLOR_END, (cp-50)/50)
    ApplyHighlight(generator, finalColor)
    local targetPart = generator:FindFirstChild("RootPart",true) or generator:FindFirstChild("defaultMaterial",true) or generator.PrimaryPart or generator:FindFirstChildWhichIsA("BasePart",true)
    if not targetPart then return false end
    local percentStr = s_format("%.1f%%", rounded)
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "GenBitchHook"
        billboard.Parent = generator
        billboard.Adornee = targetPart
        billboard.AlwaysOnTop = true
        billboard.LightInfluence = 0
        billboard.ResetOnSpawn = false
        billboard.MaxDistance = 300
        billboard.Size = UDim2.new(0,125,0,24)
        local yOffset = 2.8
        pcall(function() yOffset = math.clamp((targetPart.Size.Y * 0.5) + 1.15, 2.8, 4.2) end)
        billboard.StudsOffset = v3(0,yOffset,0)
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.Parent = billboard
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.fromScale(1,1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 8
        lbl.TextScaled = false
        lbl.TextWrapped = false
        lbl.RichText = false
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Text = percentStr
        lbl.TextColor3 = finalColor
        local stroke = Instance.new("UIStroke")
        stroke.Parent = lbl
        stroke.Thickness = 1
        stroke.Transparency = 0.2
        stroke.Color = Color3.new(0,0,0)
        local constraint = Instance.new("UITextSizeConstraint")
        constraint.Parent = lbl
        constraint.MaxTextSize = 8
        constraint.MinTextSize = 6
    else
        if billboard.Adornee ~= targetPart then billboard.Adornee = targetPart end
        local yOffset = 2.8
        pcall(function() yOffset = math.clamp((targetPart.Size.Y * 0.5) + 1.15, 2.8, 4.2) end)
        billboard.StudsOffset = v3(0,yOffset,0)
        local lbl = billboard:FindFirstChild("Label")
        if lbl then lbl.Text = percentStr; lbl.TextColor3 = finalColor end
    end
    return false
end

local function RefreshESP()
    if not workspace.CurrentCamera then return end
    if not ESP_Enable then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then RemovePlayerESP(p) end
        end
        if CachedMapObjects then
            if PrevESPState.Generator then
                for _, obj in ipairs(CachedMapObjects.Generators or {}) do
                    if obj and obj.Parent then
                        RemoveHighlight(obj)
                        local b = obj:FindFirstChild("GenBitchHook")
                        if b then b:Destroy() end
                        if obj:GetAttribute("LastESPPercent") then obj:SetAttribute("LastESPPercent", nil) end
                    end
                end
                PrevESPState.Generator = false
            end
            if PrevESPState.Pallet then
                for _, pallet in ipairs(CachedMapObjects.Pallets or {}) do
                    if pallet then
                        local tag = pallet:FindFirstChild("PalletTag")
                        if tag then tag:Destroy() end
                    end
                end
                PrevESPState.Pallet = false
            end
            if PrevESPState.Gate then
                for _, gate in ipairs(CachedMapObjects.Gates or {}) do
                    if gate and gate.Parent then RemoveHighlight(gate) end
                end
                PrevESPState.Gate = false
            end
            if PrevESPState.Hook then
                for _, hook in ipairs(CachedMapObjects.Hooks or {}) do
                    if hook and hook.Parent then
                        local m = hook:FindFirstChild("Model")
                        if m then
                            for _, p in ipairs(m:GetDescendants()) do
                                if p:IsA("MeshPart") then RemoveHighlight(p) end
                            end
                        else
                            RemoveHighlight(hook)
                        end
                    end
                end
                PrevESPState.Hook = false
            end
        end
        return
    end
    if #Players:GetPlayers() <= 1 then return end
    local players = Players:GetPlayers()
    for _, p in ipairs(players) do
        if p ~= LocalPlayer then
            local team = p.Team
            local isKiller = false
            if team and team.Name then isKiller = string.find(string.lower(team.Name), "killer") ~= nil end
            local shouldESP = false
            if isKiller and (ESP_Killer_Name or ESP_Killer_Highlight) then shouldESP = true
            elseif not isKiller and (ESP_Survivor_Name or ESP_Survivor_Highlight) then shouldESP = true end
            if shouldESP then CreatePlayerESP(p, isKiller)
            else RemovePlayerESP(p) end
        end
    end
    if not CachedMapObjects then return end
    if ESP_Generator then
        if not PrevESPState.Generator then PrevESPState.Generator = true end
        local gens = CachedMapObjects.Generators
        local newActiveGens = {}
        for i = 1, #gens do
            local obj = gens[i]
            if obj and obj.Parent then
                local isFinished = updateGeneratorProgress(obj)
                if not isFinished then t_insert(newActiveGens, obj) end
            end
        end
        CachedMapObjects.Generators = newActiveGens
        ActiveGenerators = newActiveGens
    elseif PrevESPState.Generator then
        local gens = CachedMapObjects.Generators
        for _, obj in ipairs(gens) do
            if obj and obj.Parent then
                RemoveHighlight(obj)
                local b = obj:FindFirstChild("GenBitchHook")
                if b then b:Destroy() end
                if obj:GetAttribute("LastESPPercent") then obj:SetAttribute("LastESPPercent", nil) end
            end
        end
        PrevESPState.Generator = false
    end
    if ESP_Pallet then
        if not PrevESPState.Pallet then PrevESPState.Pallet = true end
        local pallets = CachedMapObjects.Pallets
        local MAX_DISTANCE = 140
        for i = #pallets, 1, -1 do
            local pallet = pallets[i]
            local isValid = pallet and pallet.Parent and pallet:IsDescendantOf(workspace)
            if isValid then
                local targetPart = (pallet:IsA("Model") and pallet.PrimaryPart) or pallet:FindFirstChildWhichIsA("BasePart", true) or (pallet:IsA("BasePart") and pallet)
                local hasVisibleParts = false
                if targetPart then
                    if pallet:IsA("BasePart") then
                        hasVisibleParts = pallet.Transparency < 1
                    else
                        local parts = pallet:GetDescendants()
                        for j = 1, #parts do
                            local p = parts[j]
                            if p:IsA("BasePart") and p.Transparency < 1 then hasVisibleParts = true; break end
                        end
                    end
                end
                local nLower = string.lower(pallet.Name)
                local function IsActive(val) return val == true or (type(val) == "number" and val > 0) end
                local isDropped = IsActive(GetGameValue(pallet, "Dropped")) or IsActive(GetGameValue(pallet, "IsDropped"))
                local isBroken = IsActive(GetGameValue(pallet, "Broken")) or IsActive(GetGameValue(pallet, "IsBroken")) or IsActive(GetGameValue(pallet, "Destroyed"))
                local isFake = string.find(nLower, "fake") or string.find(nLower, "broken") or string.find(nLower, "destroyed")
                if isDropped or isBroken or isFake or not hasVisibleParts or not targetPart then
                    local tag = pallet:FindFirstChild("PalletTag")
                    if tag then tag:Destroy() end
                    if isDropped or isBroken or isFake then t_remove(pallets, i) end
                else
                    local tag = pallet:FindFirstChild("PalletTag")
                    if not tag then
                        local b = CreateBillboardTag("<b>[PALLET]</b>", ESP_COLORS.Pallet, UDim2.new(0, 50, 0, 18), 6)
                        b.Name = "PalletTag"
                        b.Parent = pallet
                        b.Adornee = targetPart
                        b.MaxDistance = MAX_DISTANCE
                    else
                        if not tag.Adornee then tag.Adornee = targetPart end
                        local lbl = tag:FindFirstChild("Label")
                        if lbl and lbl.TextColor3 ~= ESP_COLORS.Pallet then lbl.TextColor3 = ESP_COLORS.Pallet end
                    end
                end
            else
                if pallet then
                    local tag = pallet:FindFirstChild("PalletTag")
                    if tag then tag:Destroy() end
                end
                t_remove(pallets, i)
            end
        end
    elseif PrevESPState.Pallet then
        for _, pallet in ipairs(CachedMapObjects.Pallets) do
            if pallet then
                local tag = pallet:FindFirstChild("PalletTag")
                if tag then tag:Destroy() end
            end
        end
        PrevESPState.Pallet = false
    end
    if ESP_Gate then
        if not PrevESPState.Gate then PrevESPState.Gate = true end
        local gates = CachedMapObjects.Gates
        for i = #gates, 1, -1 do
            local gate = gates[i]
            if gate and gate.Parent then ApplyHighlight(gate, ESP_COLORS.Gate)
            else t_remove(gates, i) end
        end
    elseif PrevESPState.Gate then
        for _, gate in ipairs(CachedMapObjects.Gates) do if gate and gate.Parent then RemoveHighlight(gate) end end
        PrevESPState.Gate = false
    end
    if ESP_Hook then
        if not PrevESPState.Hook then PrevESPState.Hook = true end
        local hooks = CachedMapObjects.Hooks
        for i = #hooks, 1, -1 do
            local hook = hooks[i]
            if hook and hook.Parent then
                local m = hook:FindFirstChild("Model")
                if m then
                    for _, p in ipairs(m:GetDescendants()) do
                        if p:IsA("MeshPart") then ApplyHighlight(p, ESP_COLORS.Hook) end
                    end
                else
                    ApplyHighlight(hook, ESP_COLORS.Hook)
                end
            else
                t_remove(hooks, i)
            end
        end
    elseif PrevESPState.Hook then
        for _, hook in ipairs(CachedMapObjects.Hooks) do
            if hook and hook.Parent then
                local m = hook:FindFirstChild("Model")
                if m then
                    for _, p in ipairs(m:GetDescendants()) do
                        if p:IsA("MeshPart") then RemoveHighlight(p) end
                    end
                else
                    RemoveHighlight(hook)
                end
            end
        end
        PrevESPState.Hook = false
    end
end

local function IsVisible(targetPart)
    if not WallCheck then return true end
    local cam = workspace.CurrentCamera
    local origin = cam.CFrame.Position
    local direction = (targetPart.Position - origin)
    local myChar = LocalPlayer.Character
    table.clear(cachedRayFilter)
    if cam then table.insert(cachedRayFilter, cam) end
    if myChar then table.insert(cachedRayFilter, myChar) end
    aimRayParams.FilterDescendantsInstances = cachedRayFilter
    local result = workspace:Raycast(origin, direction, aimRayParams)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function ResetScope()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
            local anim = track.Animation
            local name = ((anim and anim.Name) or ""):lower()
            if name:find("aim") or name:find("scope") or name:find("gun") then
                pcall(function() track:Stop(0) end)
            end
        end
    end
    workspace.CurrentCamera.FieldOfView = 70
end

local function GetClosestSilentTarget()
    local camera = workspace.CurrentCamera
    local center = camera.ViewportSize * 0.5
    local closest = nil
    local shortest = SilentAimFOV or 250
    local myTeam = ((LocalPlayer.Team and LocalPlayer.Team.Name:lower()) or "")
    local survivor = not myTeam:find("killer")
    if not survivor then return nil end
    for _,p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        local enemyTeam = ((p.Team and p.Team.Name:lower()) or "")
        if not enemyTeam:find("killer") then continue end
        local char = p.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not (root and hum and hum.Health > 0) then continue end
        local pos, visible = camera:WorldToViewportPoint(root.Position)
        if not visible then continue end
        if WallCheck and not IsVisible(root) then continue end
        local dist = (Vector2.new(pos.X,pos.Y) - center).Magnitude
        if dist < shortest then shortest = dist; closest = root end
    end
    return closest
end

local function GetClosestPlayer(currentTarget)
    local camera = workspace.CurrentCamera
    local center = camera.ViewportSize * 0.5
    local shortest = AimRadius
    local myTeam = ((LocalPlayer.Team and LocalPlayer.Team.Name:lower()) or "")
    local isKiller = myTeam:find("killer")
    local camPos = camera.CFrame.Position
    if currentTarget and currentTarget.Parent then
        local hum = currentTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            local pos, visible = camera:WorldToViewportPoint(currentTarget.Position)
            if visible then
                local dist = (Vector2.new(pos.X,pos.Y) - center).Magnitude
                if dist <= AimRadius then
                    if not WallCheck or IsVisible(currentTarget) then return currentTarget end
                end
            end
        end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        local char = p.Character
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local enemyTeam = ((p.Team and p.Team.Name:lower()) or "")
        local enemyKiller = enemyTeam:find("killer")
        if isKiller and enemyKiller then continue end
        if not isKiller and not enemyKiller then continue end
        if isKiller then
            if GetGameValue(char,"Knocked") or GetGameValue(char,"IsHooked") then continue end
        end
        local targetPart = TargetPartCache[char]
        if not targetPart or not targetPart.Parent then
            targetPart = (getgenv().AimbotPart == "Head" and char:FindFirstChild("Head")) or (getgenv().AimbotPart == "Body (RootPart)" and char:FindFirstChild("HumanoidRootPart")) or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
            TargetPartCache[char] = targetPart
        end
        if not targetPart then continue end
        if (targetPart.Position - camPos).Magnitude > AimDistance then continue end
        local pos, visible = camera:WorldToViewportPoint(targetPart.Position)
        if not visible then continue end
        local dist = (Vector2.new(pos.X,pos.Y) - center).Magnitude
        if dist < shortest then
            if not WallCheck or IsVisible(targetPart) then
                shortest = dist
                CachedTarget = targetPart
            end
        end
    end
    return CachedTarget
end

ForceUnstuck = function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not(char and hum and root) then return end
    for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
        local anim = track.Animation
        local name = ((anim and anim.Name) or ""):lower()
        if name:find("repair") or name:find("generator") or name:find("fix") or name:find("interaction") then
            pcall(function() track:Stop(0) end)
        end
    end
    for _,v in ipairs({"Repairing","IsRepairing","Interacting","Busy","Action","Using"}) do
        pcall(function()
            if char:GetAttribute(v) ~= nil then char:SetAttribute(v,false) end
            local obj = char:FindFirstChild(v)
            if obj and obj:IsA("ValueBase") then
                if typeof(obj.Value) == "boolean" then obj.Value = false
                elseif typeof(obj.Value) == "number" then obj.Value = 0 end
            end
        end)
    end
    root.Anchored = false
    hum.PlatformStand = false
    hum.AutoRotate = true
    hum.Sit = false
    hum:ChangeState(Enum.HumanoidStateType.Running)
end

local function PressSkill()
    if tick() - LastTriggerTick < 0.08 then return end
    LastTriggerTick = tick()
    if IsMobile then
        local btn = PlayerGui:FindFirstChild("check",true)
        if btn and btn:IsA("GuiObject") then
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            local inset = GuiService:GetGuiInset()
            local x = pos.X + (size.X/2) + inset.X
            local y = pos.Y + (size.Y/2) + inset.Y
            pcall(function()
                VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.Begin.Value, x, y)
                task.wait()
                VirtualInputManager:SendTouchEvent(8822, Enum.UserInputState.End.Value, x, y)
            end)
            pcall(function()
                if firesignal and btn.MouseButton1Click then firesignal(btn.MouseButton1Click) end
            end)
        end
    else
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait()
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    end
end

local function GetSkillCheck()
    local pg = PlayerGui
    if not pg then return nil, nil end
    for _, guiName in ipairs({"SkillCheckPromptGui", "SkillCheckPromptGui-con", "SkillCheckGui", "SkillCheck"}) do
        local gui = pg:FindFirstChild(guiName, true)
        if gui then
            local check = gui:FindFirstChild("Check", true) or gui:FindFirstChild("SkillCheck", true) or gui
            if check and (check.Visible == true or check.Transparency < 1) then
                local line = check:FindFirstChild("Line", true) or check:FindFirstChild("Needle", true) or check:FindFirstChild("Pointer", true)
                local goal = check:FindFirstChild("Goal", true) or check:FindFirstChild("Zone", true) or check:FindFirstChild("Bar", true)
                if line and goal then return line, goal end
            end
        end
    end
    for _, obj in ipairs(pg:GetDescendants()) do
        if obj.Name == "Check" and obj:IsA("GuiObject") and obj.Visible then
            local line = obj:FindFirstChild("Line", true)
            local goal = obj:FindFirstChild("Goal", true)
            if line and goal then return line, goal end
        end
    end
    return nil, nil
end

if GenConnection then GenConnection:Disconnect() end
GenConnection = RunService.Heartbeat:Connect(function()
    if not AutoGenerator then return end
    local line, goal = GetSkillCheck()
    if not (line and goal) then return end
    local lr = (line.Rotation or 0) % 360
    local gr = (goal.Rotation or 0) % 360
    local goalVelocity = math.abs(gr - LastGoalRotation)
    LastGoalRotation = gr
    local dynamicOffset = math.clamp(goalVelocity * 0.35, 0, 8)
    local startPos, endPos
    if AutoGeneratorMode == "Neutral" then
        startPos = (gr + 90 - dynamicOffset) % 360
        endPos = (gr + 128 + dynamicOffset) % 360
    else
        startPos = (gr + (getgenv().GeneratorPerfectOffsetStart or 100) - dynamicOffset) % 360
        endPos = (gr + (getgenv().GeneratorPerfectOffsetEnd or 110) + dynamicOffset) % 360
    end
    local inside = false
    if startPos > endPos then
        inside = (lr >= startPos or lr <= endPos)
    else
        inside = (lr >= startPos and lr <= endPos)
    end
    if inside then
        LastSkillHit = tick()
        PressSkill()
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if not AutoGenerator then continue end
        local line = GetSkillCheck()
        if not line and tick() - LastSkillHit > 1.1 then
            pcall(function() ForceUnstuck() end)
        end
    end
end)

TriggerAntiStuck = function()
    pcall(function()
        local char = workspace:FindFirstChild(LocalPlayer.Name) or LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local cam = workspace.CurrentCamera
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if not remotes then return end
            local healing = remotes:FindFirstChild("Healing")
            local reset = healing and healing:FindFirstChild("Reset")
            if reset then reset:FireServer() end
        end)
        if hum and root then
            root.Anchored = false
            hum.PlatformStand = false
            hum.AutoRotate = true
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum.WalkSpeed = SpeedBoost and (17 + (17 * ((tonumber(BoostSpeed) or 0) / 100))) or 17
            for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0) end)
            end
            local badStates = {"Stunned","IsStunned","Healing","IsHealing","Repairing","IsRepairing","Interacting","Attacking","Using","Busy","Action"}
            for _,v in ipairs(badStates) do
                if char:GetAttribute(v) ~= nil then char:SetAttribute(v,false) end
                local obj = char:FindFirstChild(v)
                if obj and obj:IsA("ValueBase") then
                    pcall(function()
                        if typeof(obj.Value) == "boolean" then obj.Value = false
                        elseif typeof(obj.Value) == "number" then obj.Value = 0 end
                    end)
                end
            end
            local map = workspace:FindFirstChild("Map")
            if map then
                local genFolder = map:FindFirstChild("new Generators") or map:FindFirstChild("Generators")
                if genFolder then
                    local nearestGen, nearestDist
                    for _,gen in ipairs(genFolder:GetChildren()) do
                        local part = gen:FindFirstChildWhichIsA("BasePart",true)
                        if part then
                            local dist = (root.Position - part.Position).Magnitude
                            if not nearestDist or dist < nearestDist then
                                nearestDist = dist
                                nearestGen = part
                            end
                        end
                    end
                    if nearestGen and nearestDist <= 15 then
                        local dir = (root.Position - nearestGen.Position).Unit
                        if dir.Magnitude <= 0 then dir = root.CFrame.LookVector end
                        local escapePos = root.Position + (dir * 20)
                        root.CFrame = CFrame.new(escapePos, escapePos + root.CFrame.LookVector)
                    end
                end
            end
            task.wait()
            hum:ChangeState(Enum.HumanoidStateType.Running)
            hum.Jump = true
            if cam and cam.CameraType ~= Enum.CameraType.Custom then
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = hum
            end
        end
        print("[W424hub] Anti-Stuck Triggered.")
    end)
end

local function SwitchCameraMode(toFPP)
    local lp = Players.LocalPlayer
    if toFPP then
        lp.CameraMode = Enum.CameraMode.LockFirstPerson
        if not fppHideConn then
            fppHideConn = RunService.RenderStepped:Connect(function()
                local char = lp.Character
                if char then
                    local head = char:FindFirstChild("Head")
                    if head then head.LocalTransparencyModifier = 1 end
                    for _, obj in ipairs(char:GetChildren()) do
                        if obj:IsA("Accessory") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle then handle.LocalTransparencyModifier = 1 end
                        end
                    end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    local cam = workspace.CurrentCamera
                    if hrp and hum and cam then
                        hum.AutoRotate = false
                        local lookY = select(2, cam.CFrame:ToEulerAnglesYXZ())
                        local currentLook = hrp.Orientation.Y
                        local targetLook = math.deg(lookY)
                        if math.abs(currentLook - targetLook) > 1 then
                            hrp.CFrame = cnew(hrp.Position) * cangles(0, lookY, 0)
                        end
                    end
                end
            end)
        end
    else
        lp.CameraMode = Enum.CameraMode.Classic
        lp.CameraMaxZoomDistance = 128
        local char = lp.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.AutoRotate = true end
        if fppHideConn then fppHideConn:Disconnect(); fppHideConn = nil end
        local char = lp.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then head.LocalTransparencyModifier = 0 end
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("Accessory") then
                    local handle = obj:FindFirstChild("Handle")
                    if handle then handle.LocalTransparencyModifier = 0 end
                end
            end
        end
    end
end

local function UpdateParryRing()
    if not ParryRing or not ParryRing.Parent then return end
    if RemoveParryCircle or not AutoParry then
        ParryRing.Visible = false
    else
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            ParryRing.Adornee = root
            ParryRing.Visible = true
            local r = tonumber(ParryDistance) or 12
            ParryRing.Radius = r
            ParryRing.InnerRadius = math.max(0, r - 0.15)
        else
            ParryRing.Visible = false
        end
    end
end

local function UpdateWarningMark(myRoot, closestKillerDist)
    if not myRoot then return end
    local warnGui = myRoot:FindFirstChild("KillerWarn")
    if (not RemoveWarningMark) and closestKillerDist and closestKillerDist <= 65 then
        local isVeryClose = closestKillerDist <= 35
        local txt = isVeryClose and "!!" or "!"
        local neonGreen = Color3.fromRGB(0, 255, 128)
        if not warnGui then
            warnGui = Instance.new("BillboardGui")
            warnGui.Name = "KillerWarn"
            warnGui.AlwaysOnTop = true
            warnGui.Size = UDim2.new(0, 60, 0, 60)
            warnGui.StudsOffset = Vector3.new(0, 4.2, 0)
            warnGui.LightInfluence = 0
            warnGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = txt
            label.TextColor3 = neonGreen
            label.Font = Enum.Font.GothamBlack
            label.TextSize = isVeryClose and 30 or 24
            label.RichText = true
            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 2.5
            stroke.Color = Color3.fromRGB(0, 40, 15)
            stroke.Transparency = 0.1
            stroke.Parent = label
            label.Parent = warnGui
            warnGui.Parent = myRoot
        else
            if warnGui.Adornee ~= myRoot then warnGui.Adornee = myRoot end
            local lbl = warnGui:FindFirstChild("Label")
            if lbl then
                lbl.Text = txt
                lbl.TextColor3 = neonGreen
                lbl.TextSize = isVeryClose and 30 or 24
            end
        end
    elseif warnGui then
        warnGui:Destroy()
    end
end

local function GetParryRemote()
    if ExactParryRemote and ExactParryRemote.Parent then return ExactParryRemote end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return end
    local items = remotes:FindFirstChild("Items")
    local dagger = items and items:FindFirstChild("Parrying Dagger")
    if dagger and dagger:FindFirstChild("parry") then
        ExactParryRemote = dagger.parry
    else
        for _,v in ipairs(remotes:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower() == "parry" then
                ExactParryRemote = v
                break
            end
        end
    end
    return ExactParryRemote
end

local function GetPing()
    local ping = 0.08
    pcall(function()
        local statsPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        if statsPing and statsPing > 0 then ping = statsPing end
    end)
    return math.clamp(ping, 0.03, 1.5)
end

local function IsKillerUsingSkill(char)
    for _,skill in ipairs(IgnoreSkills) do
        if char:GetAttribute(skill) or GetGameValue(char,skill) then return true end
    end
    return false
end

local function GetKillerProfile(char)
    local selected = getgenv().ParryMatchup or "Auto"
    if selected ~= "Auto" then return KillerProfiles[selected] or {BonusDist=1,Delay=0} end
    local detect = string.upper(tostring(char:GetAttribute("KillerType") or char:GetAttribute("Mask") or char.Name))
    for profile,mask in pairs(MaskNames) do
        if detect:find(mask) then return KillerProfiles[profile] end
    end
    return {BonusDist=1,Delay=0}
end

local function TriggerParryDagger()
    local now = tick()
    if now - LastParryTick < 0.04 then return end
    local remote = GetParryRemote()
    if not remote then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (root and hum) or hum.Health <= 0 then return end
    local tool = char:FindFirstChild("Parrying Dagger") or char:FindFirstChildWhichIsA("Tool")
    if not tool then return end
    local ping = GetPing()
    local bestTarget = nil
    local bestDistance = math.huge
    local currentRange = tonumber(ParryDistance) or 12
    local players = Players:GetPlayers()
    for i = 1, #players do
        local plr = players[i]
        if plr ~= LocalPlayer and plr.Team and plr.Team.Name:lower():find("killer") and plr.Character then
            local eChar = plr.Character
            local eRoot = eChar:FindFirstChild("HumanoidRootPart")
            local eHum = eChar:FindFirstChildOfClass("Humanoid")
            if eRoot and eHum and eHum.Health > 0 then
                if IsKillerUsingSkill(eChar) then continue end
                local profile = GetKillerProfile(eChar)
                local vel = eRoot.AssemblyLinearVelocity or Vector3.zero
                local myVel = root.AssemblyLinearVelocity or Vector3.zero
                local relVel = vel - myVel
                local toMe = (root.Position - eRoot.Position)
                local currentDist = toMe.Magnitude
                local dirToMe = toMe.Unit
                local approachSpeed = relVel:Dot(dirToMe)
                local pingCompensationDistance = math.max(0, approachSpeed) * ping * 1.3
                local effectiveMaxRange = currentRange + (profile.BonusDist or 0) + pingCompensationDistance
                local predictedPos = eRoot.Position + (vel * (ping + 0.03))
                local predictedDist = (predictedPos - root.Position).Magnitude
                local isAttacking = false
                for _, track in ipairs(eHum:GetPlayingAnimationTracks()) do
                    if track.IsPlaying then
                        local animName = track.Animation and track.Animation.Name:lower() or ""
                        if animName:find("attack") or animName:find("slash") or animName:find("swing") or animName:find("m1") or animName:find("strike") or animName:find("hit") or animName:find("heavy") then
                            isAttacking = true
                            break
                        end
                    end
                end
                if (currentDist <= effectiveMaxRange or predictedDist <= currentRange or (isAttacking and currentDist <= effectiveMaxRange + 3)) then
                    if currentDist < bestDistance then
                        bestDistance = currentDist
                        bestTarget = {Root = eRoot, Profile = profile, IsAttacking = isAttacking}
                    end
                end
            end
        end
    end
    if not bestTarget then return end
    LastParryTick = now
    local burstCount = ping > 0.18 and 6 or 4
    task.spawn(function()
        for i = 1, burstCount do
            if not AutoParry or not remote or not remote.Parent then break end
            pcall(function() remote:FireServer() end)
            task.wait(0.005)
        end
    end)
end

local oldNamecall
local _hookOk = pcall(function()
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if checkcaller() or method ~= "FireServer" or typeof(self) ~= "Instance" then
        return oldNamecall(self, ...)
    end
    local args = {...}
    local n = tostring(self):lower()
    if SelfHeal and n:find("healevent") then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 then
            args[1] = root
            if args[2] == nil then args[2] = true end
            return oldNamecall(self, unpack(args))
        end
    end
    if DoubleDamageGen and n:find("breakgenevent") then
        local team = LocalPlayer.Team
        if team and team.Name:lower():find("killer") then
            local saved = table.clone(args)
            local result = oldNamecall(self, unpack(saved))
            task.spawn(function()
                for i=1,4 do
                    task.wait(0.08)
                    pcall(function() oldNamecall(self, unpack(saved)) end)
                end
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    root.Anchored = false
                    hum.PlatformStand = false
                    hum.AutoRotate = true
                    hum.Sit = false
                    for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
                        local anim = track.Animation
                        local name = ((anim and anim.Name) or ""):lower()
                        if name:find("break") or name:find("generator") or name:find("kick") then
                            pcall(function() track:Stop(0) end)
                        end
                    end
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            return result
        end
    end
    if SilentActions then
        for _,w in ipairs({"noise","scream","vaultalert","spotted","alert","ping","loud","notify","notification","sound"}) do
            local firstArg = typeof(args[1]) == "string" and args[1]:lower() or ""
            if n:find(w) or firstArg:find(w) then return end
        end
    end
    if AntiLogger and (n:find("log") or n:find("error") or n:find("report") or n:find("anticheat") or n:find("ban")) then return end
    if AntiFallDamage and (n:find("falldamage") or n:find("fall") or n:find("ragdollfall")) then return end
    if getgenv().AntiAura then
        getgenv().AuraRemoteCache = getgenv().AuraRemoteCache or {}
        local cache = getgenv().AuraRemoteCache
        local key = tostring(self)
        if cache[key] == nil then
            local score = 0
            for _,w in ipairs({"aura","reveal","highlight","sense","spotted","vision","radar","detect","tracking","hunter"}) do
                if n:find(w) then score = score + 2 end
            end
            local mentions = false
            for i=1, math.min(3, #args) do
                if args[i] == LocalPlayer or args[i] == LocalPlayer.Character then mentions = true; break end
            end
            cache[key] = score >= 4 and mentions
        end
        if cache[key] then return end
    end
    if SilentAimPistol and method == "FireServer" and n:find("fire") then
        local team = LocalPlayer.Team
        local survivor = not (team and team.Name:lower():find("killer"))
        if survivor then
            local char = LocalPlayer.Character
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            local tool = char and char:FindFirstChildOfClass("Tool")
            if not (myRoot and tool) then return oldNamecall(self, ...) end
            local firing = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or (UserInputService.TouchEnabled and getgenv().isMobileFiring)
            if not firing then return oldNamecall(self, ...) end
            local target = GetClosestSilentTarget()
            if target and target.Parent then
                local vel = target.AssemblyLinearVelocity or Vector3.zero
                if vel.Magnitude > 45 then vel = vel.Unit * 45 end
                local ping = 0.08
                pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()/1000 end)
                ping = math.clamp(ping, 0.05, 0.18)
                local predicted = target.Position + (vel * (0.11 + ping))
                local origin = workspace.CurrentCamera.CFrame.Position
                local dir = (predicted - origin).Unit * 1000
                for i,v in ipairs(args) do
                    if typeof(v) == "Vector3" then
                        args[i] = dir
                        break
                    end
                end
                task.spawn(function()
                    pcall(function()
                        workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, predicted)
                    end)
                end)
                return oldNamecall(self, unpack(args))
            end
        end
    end
    return oldNamecall(self, ...)
end))
end)
if not _hookOk then
    warn("[W424HUB] hookmetamethod tidak tersedia di executor ini â€” SelfHeal/SilentAim/AntiAura dinonaktifkan.")
    SelfHeal = false; SilentAimPistol = false; AntiFallDamage = false
end

task.spawn(function()
    while task.wait(0.15) do
        if not getgenv().QUANTUM_RUNNING then break end
        if not AutoAttack then continue end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar and myChar:FindFirstChild("Humanoid")
        if not myRoot or not myHum or myHum.Health <= 0 then continue end
        local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
        if not myTeam:find("killer") then continue end
        local isCarrying = GetGameValue(myChar, "Carrying") or GetGameValue(myChar, "IsCarrying")
        local isStunned = GetGameValue(myChar, "Stunned")
        if isCarrying or isStunned then continue end
        local targetFound = false
        local players = Players:GetPlayers()
        for i = 1, #players do
            local p = players[i]
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local enemyTeam = p.Team and p.Team.Name:lower() or ""
                if not enemyTeam:find("killer") then
                    local enemyChar = p.Character
                    local enemyHum = enemyChar:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        local isKnocked = GetGameValue(enemyChar, "Knocked")
                        local isHooked = GetGameValue(enemyChar, "IsHooked")
                        if not isKnocked and not isHooked then
                            local dist = (enemyChar.HumanoidRootPart.Position - myRoot.Position).Magnitude
                            local isEnemyRunning = enemyHum.MoveDirection.Magnitude > 0
                            local effectiveRange = isEnemyRunning and (AttackRange + 3) or AttackRange
                            if dist <= effectiveRange then
                                targetFound = true
                                break
                            end
                        end
                    end
                end
            end
        end
        local now = os.clock()
        if targetFound and (now - lastAttackStrike > 0.6) then
            lastAttackStrike = now
            if not SearchedAttackRemote then
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local attacks = remotes and (remotes:FindFirstChild("Attacks") or remotes:FindFirstChild("attacks") or remotes:FindFirstChild("Attack"))
                if attacks then
                    CachedBasicAttack = attacks:FindFirstChild("BasicAttack") or attacks:FindFirstChild("basicattack")
                end
                SearchedAttackRemote = true
            end
            if CachedBasicAttack then
                CachedBasicAttack:FireServer(false)
                task.wait(0.05)
                CachedBasicAttack:FireServer(true)
            end
        end
    end
end)

task.spawn(function()
    local killerStunStates = {}
    while task.wait(0.2) do
        if not getgenv().QUANTUM_RUNNING then break end
        if NotifyStun then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    local teamName = p.Team and p.Team.Name:lower() or ""
                    if teamName:find("killer") and p.Character then
                        local kChar = p.Character
                        local stunVal = GetGameValue(kChar, "Stunned") or GetGameValue(kChar, "IsStunned")
                        local isStunned = stunVal == true or (type(stunVal) == "number" and stunVal > 0)
                        if isStunned and not killerStunStates[p.UserId] then
                            print("[W424hub] KILLER STUNNED! " .. p.Name .. " berhasil stunned!!")
                        end
                        killerStunStates[p.UserId] = isStunned
                    end
                end
            end)
        else
            if next(killerStunStates) ~= nil then table.clear(killerStunStates) end
        end
    end
end)

t_insert(getgenv().QUANTUM_CONNECTIONS, RunService.RenderStepped:Connect(function(deltaTime)
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChild("Humanoid")
    local camera = workspace.CurrentCamera
    if not myRoot or not myHum then return end
    if myHum.Health <= 0 then return end
    if getgenv().MoonwalkEnabled then
        if myHum.AutoRotate then myHum.AutoRotate = false end
        local look = camera.CFrame.LookVector
        local targetYaw = math.deg(math.atan2(look.X, look.Z)) + 180
        local diff = ((targetYaw - (CurrentMoonwalkYaw or 0) + 180) % 360) - 180
        CurrentMoonwalkYaw = (CurrentMoonwalkYaw or 0) + (diff * (0.22 * math.clamp(deltaTime * 60, 0, 3)))
        local moving = myHum.MoveDirection.Magnitude > 0.01
        local sway = 0
        if moving then
            sway = math.sin(time() * (getgenv().MoonwalkZigzagSpeed or 11)) * (getgenv().MoonwalkZigzagAmount or 48)
        end
        CurrentMoonwalkSway = (CurrentMoonwalkSway or 0) + ((sway - (CurrentMoonwalkSway or 0)) * 0.38)
        myRoot.CFrame = CFrame.new(myRoot.Position) * CFrame.Angles(0, math.rad(CurrentMoonwalkYaw + CurrentMoonwalkSway), 0)
        if moving then
            myHum:Move(myHum.MoveDirection * (getgenv().MoonwalkBoostPower or 1.08), false)
        end
    else
        if not myHum.AutoRotate then myHum.AutoRotate = true end
    end
    if Aimbot then
        local now = time()
        if now - lastRenderCheck > 0.25 then
            cachedIsCarrying = GetGameValue(myChar, "Carrying") or GetGameValue(myChar, "IsCarrying") or false
            lastRenderCheck = now
        end
        if not cachedIsCarrying then
            if now - LastTargetCheck > 0.12 then
                CachedTarget = GetClosestPlayer(CachedTarget)
                LastTargetCheck = now
            end
            if CachedTarget and (not CachedTarget.Parent or not CachedTarget:IsDescendantOf(workspace)) then
                CachedTarget = nil
            end
            local target = CachedTarget
            if target and target.Parent then
                local firing = (getgenv().AimbotTrigger or "Hold to Lock") == "Auto Lock (Always)"
                if not firing then
                    firing = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or getgenv().isMobileFiring == true
                end
                if firing then
                    local targetPos = target.Position
                    local smooth = math.clamp(deltaTime * (tonumber(getgenv().AimbotSmoothness) or 8), 0.08, 0.28)
                    camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, targetPos), smooth)
                end
            end
        else
            CachedTarget = nil
        end
    end
end))

RunService:BindToRenderStep("SmoothFOV", Enum.RenderPriority.Camera.Value + 1, function()
    if CustomCameraFOV and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = CameraFOVValue end
end)

t_insert(getgenv().QUANTUM_CONNECTIONS, RunService.Heartbeat:Connect(function(dt)
    if not getgenv().QUANTUM_RUNNING then return end
    local now = os.clock()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myHum or not myRoot then return end
    local function IsStatusActive(val)
        return val == true or (type(val) == "number" and val > 0)
    end
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
    local isKiller = myTeam:find("killer") ~= nil
    if now - LastESPRefresh > 0.35 then
        LastESPRefresh = now
        pcall(function() RefreshESP() end)
    end
    closestKillerDist = 999
    local isKillerRunning = false
    local players = Players:GetPlayers()
    for i = 1, #players do
        local p = players[i]
        if p ~= LocalPlayer and p.Character then
            local enemyChar = p.Character
            local eRoot = enemyChar:FindFirstChild("HumanoidRootPart")
            if eRoot then
                local teamName = p.Team and p.Team.Name:lower() or ""
                if string.find(teamName, "killer") then
                    local dist = (eRoot.Position - myRoot.Position).Magnitude
                    if dist < closestKillerDist then
                        closestKillerDist = dist
                        local eHum = enemyChar:FindFirstChildOfClass("Humanoid")
                        if eHum and eHum.MoveDirection.Magnitude > 0 then
                            isKillerRunning = true
                        end
                    end
                    if HitboxExpander then
                        local targetSize = v3(HitboxSize, HitboxSize, HitboxSize)
                        if eRoot.Size ~= targetSize then
                            pcall(function()
                                eRoot.Size = targetSize
                                eRoot.Transparency = 0.9
                                eRoot.Material = Enum.Material.ForceField
                                eRoot.Color = Color3.fromRGB(255,0,0)
                                eRoot.Massless = false
                                eRoot.CanCollide = false
                            end)
                        end
                    else
                        if m_round(eRoot.Size.X) ~= 2 then
                            pcall(function()
                                eRoot.Size = v3(2,2,1)
                                eRoot.Transparency = 1
                                eRoot.Material = Enum.Material.Plastic
                                eRoot.Massless = false
                                eRoot.CanCollide = false
                            end)
                        end
                    end
                end
            end
        end
    end
    pcall(function()
        UpdateWarningMark(myRoot, closestKillerDist)
        UpdateParryRing()
    end)
    if AutoParry then
        pcall(function() TriggerParryDagger() end)
    end
    if not SearchedHBRemotes then
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            CachedHBRemotes.DisplayBlood = remotes:FindFirstChild("DisplayBlood", true) or remotes:FindFirstChild("BloodEvent", true)
            CachedHBRemotes.FallDamage = remotes:FindFirstChild("FallDamage", true)
            CachedHBRemotes.HealEvent = remotes:FindFirstChild("HealEvent", true) or remotes:FindFirstChild("RequestHeal", true) or remotes:FindFirstChild("ReviveEvent", true)
        end
        SearchedHBRemotes = true
    end
    local isDoingCriticalAction = false
    for _, track in ipairs(myHum:GetPlayingAnimationTracks()) do
        if track.Animation then
            local animName = track.Animation.Name:lower()
            if animName:find("hook") or animName:find("grab") or animName:find("pickup") or animName:find("place") then
                isDoingCriticalAction = true
                break
            end
        end
    end
    if not isKiller and myHum.Health > 0 then
        local isImmobilized = IsStatusActive(GetGameValue(myChar, "IsHooked")) or IsStatusActive(GetGameValue(myChar, "Carried")) or myChar:GetAttribute("IsHooked") or myChar:GetAttribute("Carried") or myChar:GetAttribute("Grabbed")
        if not isImmobilized and not isDoingCriticalAction and myHum.MoveDirection.Magnitude > 0 then
            local baseTargetSpeed = 17
            local currentWalkSpeed = myHum.WalkSpeed
            local desiredSpeed = currentWalkSpeed
            if NoSlowdown and currentWalkSpeed < baseTargetSpeed then desiredSpeed = baseTargetSpeed end
            if SpeedBoost then
                local percentValue = tonumber(BoostSpeed) or 0
                percentValue = math.clamp(percentValue, 0, 150)
                desiredSpeed = desiredSpeed + (desiredSpeed * (percentValue / 100))
            end
            local speedDifference = desiredSpeed - currentWalkSpeed
            if speedDifference > 0 then
                local cframeOffset = myHum.MoveDirection * (speedDifference * dt)
                pcall(function() myRoot.CFrame = myRoot.CFrame + cframeOffset end)
            end
        end
    end
end))

getgenv().AIFinalTarget = nil
task.spawn(function()
    while task.wait(0.4) do
        if not getgenv().QUANTUM_RUNNING then break end
        if not AutoFarmBot then
            getgenv().CachedWaypoints = nil
            getgenv().AIFinalTarget = nil
            continue
        end
        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            if not myRoot or not myHum or myHum.Health <= 0 then return end
            local team = LocalPlayer.Team and LocalPlayer.Team.Name:lower() or ""
            if team:find("killer") then return end
            local function IsImmobilized()
                if GetGameValue(myChar, "IsHooked") or myChar:GetAttribute("IsHooked") then return true end
                if GetGameValue(myChar, "Carried") or GetGameValue(myChar, "Grabbed") or myChar:GetAttribute("Carried") then return true end
                return false
            end
            if IsImmobilized() then
                getgenv().CachedWaypoints = nil
                getgenv().AIFinalTarget = nil
                return
            end
            local myPos = myRoot.Position
            local closestKillerDist = 999
            local killerRoot = nil
            local injuredTeammate = nil
            local shortestMateDist = 90
            local players = Players:GetPlayers()
            for _, p in ipairs(players) do
                if p ~= LocalPlayer and p.Character then
                    local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if eRoot then
                        local eTeam = p.Team and p.Team.Name:lower() or ""
                        local dist = (eRoot.Position - myPos).Magnitude
                        if eTeam:find("killer") then
                            if dist < closestKillerDist then
                                closestKillerDist = dist
                                killerRoot = eRoot
                            end
                        else
                            local isKnocked = GetGameValue(p.Character, "Knocked")
                            local eHum = p.Character:FindFirstChild("Humanoid")
                            local isInjured = eHum and eHum.Health < eHum.MaxHealth
                            if (isKnocked or isInjured) and dist < shortestMateDist then
                                shortestMateDist = dist
                                injuredTeammate = p.Character
                            end
                        end
                    end
                end
            end
            local completedGens = 0
            local shortestGenDist = 9999
            local bestGenTarget = nil
            if CachedMapObjects and CachedMapObjects.Generators then
                for _, gen in ipairs(CachedMapObjects.Generators) do
                    local progress = GetGameValue(gen, "RepairProgress") or GetGameValue(gen, "Progress") or 0
                    if progress >= 100 then
                        completedGens = completedGens + 1
                    else
                        local genPos = gen:GetPivot().Position
                        local dist = (genPos - myPos).Magnitude
                        if dist < shortestGenDist then
                            shortestGenDist = dist
                            bestGenTarget = genPos
                        end
                    end
                end
            end
            local targetPos = nil
            local actionState = "Idle"
            if closestKillerDist <= 70 and killerRoot then
                local maxDistFromKiller = 0
                local bestEscapeTarget = nil
                local killerPos = killerRoot.Position
                local function checkSafeSpot(spot)
                    local spotPos = spot:GetPivot().Position
                    local distFromKiller = (spotPos - killerPos).Magnitude
                    if distFromKiller > maxDistFromKiller then
                        maxDistFromKiller = distFromKiller
                        bestEscapeTarget = spotPos
                    end
                end
                if CachedMapObjects.Generators then for _, g in ipairs(CachedMapObjects.Generators) do checkSafeSpot(g) end end
                if CachedMapObjects.Gates then for _, g in ipairs(CachedMapObjects.Gates) do checkSafeSpot(g) end end
                if bestEscapeTarget then
                    targetPos = bestEscapeTarget
                else
                    local runDir = (myPos - killerPos).Unit
                    targetPos = myPos + (runDir * 50)
                end
                actionState = "Evading"
            elseif injuredTeammate then
                targetPos = injuredTeammate.HumanoidRootPart.Position
                actionState = "Healing"
                if shortestMateDist <= 12 then
                    if not SearchHealRemote then
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        CachedHealEvent = remotes and (remotes:FindFirstChild("HealEvent", true) or remotes:FindFirstChild("RequestHeal", true) or remotes:FindFirstChild("ReviveEvent", true))
                        SearchHealRemote = true
                    end
                    if CachedHealEvent then
                        pcall(function() CachedHealEvent:FireServer(injuredTeammate, 100) end)
                        pcall(function() CachedHealEvent:FireServer(injuredTeammate, true) end)
                    end
                    getgenv().CachedWaypoints = nil
                    getgenv().AIFinalTarget = nil
                    if (myHum.WalkToPoint - myPos).Magnitude > 1 then myHum:MoveTo(myPos) end
                    return
                end
            elseif completedGens < 5 and bestGenTarget then
                targetPos = bestGenTarget
                actionState = "Repairing"
            elseif completedGens >= 5 then
                if CachedMapObjects and CachedMapObjects.Gates then
                    local shortestGate = 9999
                    for _, gate in ipairs(CachedMapObjects.Gates) do
                        local gatePos = gate:GetPivot().Position
                        local dist = (gatePos - myPos).Magnitude
                        if dist < shortestGate then
                            shortestGate = dist
                            targetPos = gatePos
                        end
                    end
                end
                actionState = "Escaping"
            end
            if getgenv().LastAIState ~= actionState then
                getgenv().LastAIState = actionState
                print("[W424hub] AI State: " .. string.upper(actionState))
            end
            getgenv().AIFinalTarget = targetPos
            if targetPos then
                local now = os.clock()
                local lastPathCalc = getgenv().LastPathCalc or 0
                local lastTargetPos = getgenv().LastTargetPos or v3()
                if (targetPos - lastTargetPos).Magnitude > 5 or (now - lastPathCalc > 1.5) then
                    getgenv().LastPathCalc = now
                    getgenv().LastTargetPos = targetPos
                    task.spawn(function()
                        pcall(function()
                            local path = PathfindingService:CreatePath({AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 4})
                            path:ComputeAsync(myPos, targetPos)
                            if path.Status == Enum.PathStatus.Success then
                                getgenv().CachedWaypoints = path:GetWaypoints()
                                getgenv().CurrentWaypointIdx = 2
                            else
                                getgenv().CachedWaypoints = nil
                            end
                        end)
                    end)
                end
            else
                getgenv().CachedWaypoints = nil
                if (myHum.WalkToPoint - myPos).Magnitude > 1 then myHum:MoveTo(myPos) end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if not getgenv().QUANTUM_RUNNING then break end
        if not AutoFarmBot then continue end
        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            if not myRoot or not myHum or myHum.Health <= 0 then return end
            local waypoints = getgenv().CachedWaypoints
            local idx = getgenv().CurrentWaypointIdx
            local myPos = myRoot.Position
            if waypoints and idx and idx <= #waypoints then
                local nextPoint = waypoints[idx]
                local distToWaypoint = (v3(nextPoint.Position.X, myPos.Y, nextPoint.Position.Z) - myPos).Magnitude
                if distToWaypoint < 4.5 then
                    getgenv().CurrentWaypointIdx = idx + 1
                    if getgenv().CurrentWaypointIdx <= #waypoints then
                        nextPoint = waypoints[getgenv().CurrentWaypointIdx]
                    end
                end
                if nextPoint then
                    myHum:MoveTo(nextPoint.Position)
                    if nextPoint.Action == Enum.PathWaypointAction.Jump then
                        myHum.Jump = true
                    end
                end
            elseif getgenv().AIFinalTarget then
                myHum:MoveTo(getgenv().AIFinalTarget)
            end
            local nowTime = os.clock()
            local lastBotPos = getgenv().LastBotPos or myPos
            local lastBotTime = getgenv().LastBotTime or nowTime
            if getgenv().AIFinalTarget then
                if (myPos - lastBotPos).Magnitude < 0.5 then
                    if nowTime - lastBotTime > 1.0 then
                        myHum.Jump = true
                        myRoot.CFrame = myRoot.CFrame * cnew(math.random(-2, 2), 0, math.random(1, 3))
                        getgenv().LastBotTime = nowTime + 0.5
                    end
                else
                    getgenv().LastBotPos = myPos
                    getgenv().LastBotTime = nowTime
                end
            end
        end)
    end
end)

t_insert(getgenv().QUANTUM_CONNECTIONS, LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and SpeedBoost then
        local baseSpeed = 17
        local percentValue = tonumber(BoostSpeed) or 0
        hum.WalkSpeed = baseSpeed + (baseSpeed * (percentValue / 100))
    end
end))

t_insert(getgenv().QUANTUM_CONNECTIONS, Players.PlayerRemoving:Connect(function(player)
    SilentTarget = nil
    ResetScope()
    if ESP_PlayerCache and ESP_PlayerCache[player.UserId] then ESP_PlayerCache[player.UserId] = nil end
    if player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local tag = root:FindFirstChild("TagESP")
            if tag then tag:Destroy() end
        end
    end
end))

-- ============================================================
--  FINAL
-- ============================================================
Window:Notify({
    Title = "Welcome to W424hub HUB!",
    Description = "God-AI Systems Initialized.\nðŸ’» PC User: Press [Keybind K] to open/hide the UI.",
    Duration = 8,
    Icon = "Sparkles"
})

print("âœ… W424hub HUB Full Loaded!")