-- [[ H&T HUB SOURCE CODE - BY HỮU HIỀN K12 ]] --
-- [[ PHIÊN BẢN FULL SEA 2 - KHÔNG RÚT GỌN ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================= HỆ THỐNG BIẾN TOÀN CỤC =================
getgenv().AutoFarmLevel = false
getgenv().AutoClicker = false
getgenv().AutoHaki = false
getgenv().AutoEquip = false
getgenv().AutoBoss = false
getgenv().AutoChest = false
getgenv().ESPMobs = false
getgenv().TweenSpeed = 250
getgenv().SelectWeapon = "Melee"
getgenv().SelectBoss = "Diamond"

-- ================= HÀM TRỢ NĂNG (CORE LOGIC) =================

-- Kiểm tra nhiệm vụ Sea 2 dựa trên Level
local function CheckQuest()
    local lvl = game.Players.LocalPlayer.Data.Level.Value
    if lvl >= 700 and lvl < 775 then
        return {"Raider [Lv. 700]", "Area1Quest", 1, CFrame.new(-424, 73, 1836), CFrame.new(-500, 75, 2000)}
    elseif lvl >= 775 and lvl < 875 then
        return {"Mercenary [Lv. 775]", "Area2Quest", 1, CFrame.new(635, 73, 915), CFrame.new(500, 75, 1000)}
    elseif lvl >= 875 and lvl < 950 then
        return {"Swan Pirate [Lv. 875]", "Area2Quest", 2, CFrame.new(635, 73, 915), CFrame.new(900, 100, 1100)}
    elseif lvl >= 950 and lvl < 1000 then
        return {"Factory Staff [Lv. 950]", "Area3Quest", 1, CFrame.new(-1022, 13, 1131), CFrame.new(-1020, 15, 1200)}
    else
        return {"Raider [Lv. 700]", "Area1Quest", 1, CFrame.new(-424, 73, 1836), CFrame.new(-500, 75, 2000)}
    end
end

-- Hàm tự động trang bị vũ khí theo ToolTip
local function EquipWeapon()
    if getgenv().AutoEquip then
        pcall(function()
            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v.ToolTip == getgenv().SelectWeapon then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                end
            end
        end)
    end
end

-- Hàm di chuyển Tween (Bay) mượt mà
local function Tween(Target)
    if not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local Distance = (Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local TweenServ = game:GetService("TweenService")
    local Info = TweenInfo.new(Distance / getgenv().TweenSpeed, Enum.EasingStyle.Linear)
    local TweenObj = TweenServ:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, Info, {CFrame = Target})
    
    -- Chống rơi và giữ nhân vật ổn định khi đang bay
    if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("HT_Velocity") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "HT_Velocity"
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    end
    
    TweenObj:Play()
    return TweenObj
end

-- ================= KHỞI TẠO GIAO DIỆN RAYFIELD =================

local Window = Rayfield:CreateWindow({
   Name = "H&T Hub by Hữu Hiền k12",
   LoadingTitle = "Đang kết nối Server H&T...",
   LoadingSubtitle = "Chào mừng Hữu Hiền",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HT_Hub_Config",
      FileName = "HT_Save"
   },
   KeySystem = false
})

-- Tạo các Tab đã thiết kế
local TabFarm = Window:CreateTab("🏠 Farm", 4483362458)
local TabNhiemVu = Window:CreateTab("⚔️ Nhiệm Vụ", 4483362458)
local TabKhac = Window:CreateTab("⚙️ Khác", 4483362458)

-- ================= TAB FARM LOGIC =================

TabFarm:CreateSection("Cài Đặt Vũ Khí & Hỗ Trợ")

TabFarm:CreateDropdown({
    Name = "Chọn Vũ Khí",
    Options = {"Melee", "Sword", "Gun", "Fruit"},
    CurrentOption = {"Melee"},
    Callback = function(Option) getgenv().SelectWeapon = Option[1] end,
})

TabFarm:CreateToggle({
    Name = "Tự Động Trang Bị (Auto Equip)",
    CurrentValue = false,
    Callback = function(Value) getgenv().AutoEquip = Value end,
})

TabFarm:CreateToggle({
    Name = "Tự Động Bật Haki (Auto Haki)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoHaki = Value
        spawn(function()
            while getgenv().AutoHaki do
                task.wait(1)
                if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end,
})

TabFarm:CreateSection("Cày Cấp (Sea 2)")

TabFarm:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoFarmLevel = Value
        spawn(function()
            while getgenv().AutoFarmLevel do
                task.wait()
                local q = CheckQuest()
                -- Nhận nhiệm vụ nếu chưa có
                if not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                    Tween(q[4])
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q[2], q[3])
                else
                    -- Đánh quái nhiệm vụ
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == q[1] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                EquipWeapon()
                                Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                            until not getgenv().AutoFarmLevel or v.Humanoid.Health <= 0 or not v.Parent
                        end
                    end
                    -- Di chuyển tới vị trí quái spawn
                    Tween(q[5])
                end
            end
        end)
    end,
})

TabFarm:CreateSection("Săn Boss Sea 2")

TabFarm:CreateDropdown({
    Name = "Chọn Boss",
    Options = {"Diamond", "Jeremy", "Fajita", "Don Swan"},
    CurrentOption = {"Diamond"},
    Callback = function(Option) getgenv().SelectBoss = Option[1] end,
})

TabFarm:CreateToggle({
    Name = "Auto Farm Boss Được Chọn",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoBoss = Value
        spawn(function()
            while getgenv().AutoBoss do
                task.wait(1)
                local b = game:GetService("Workspace").Enemies:FindFirstChild(getgenv().SelectBoss)
                if b and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
                    repeat
                        task.wait()
                        EquipWeapon()
                        Tween(b.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                    until not getgenv().AutoBoss or b.Humanoid.Health <= 0
                end
            end
        end)
    end,
})

-- ================= TAB KHÁC =================

TabKhac:CreateSection("Tính Năng Bổ Trợ")

TabKhac:CreateToggle({
    Name = "Auto Gom Rương (Collect Chests)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoChest = Value
        spawn(function()
            while getgenv().AutoChest do
                task.wait()
                for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                    if v.Name:find("Chest") then
                        Tween(v.CFrame)
                        task.wait(0.3)
                    end
                end
            end
        end)
    end,
})

TabKhac:CreateToggle({
    Name = "Hiện Vị Trí Quái (ESP Mobs)",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().ESPMobs = Value
        spawn(function()
            while getgenv().ESPMobs do
                task.wait(1)
                for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("HT_ESP") then
                        local b = Instance.new("BillboardGui", v)
                        b.Name = "HT_ESP"
                        b.AlwaysOnTop = true
                        b.Size = UDim2.new(0, 100, 0, 50)
                        local t = Instance.new("TextLabel", b)
                        t.Text = v.Name
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.BackgroundTransparency = 1
                        t.TextColor3 = Color3.new(1, 0, 0)
                        t.TextScaled = true
                    end
                end
            end
        end)
    end,
})

TabKhac:CreateSlider({
    Name = "Tốc Độ Bay (Tween Speed)",
    Range = {100, 500},
    Increment = 10,
    CurrentValue = 250,
    Callback = function(Value) getgenv().TweenSpeed = Value end,
})

Rayfield:Notify({Title = "H&T Hub", Content = "Script đã sẵn sàng cho Hữu Hiền!", Duration = 5})
