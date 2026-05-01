--UI DEMO CREATED WITH THE USE OF GENERATIVE AI
--THE MAIN LIBRARY, VIGIL, WAS NOT!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Ensure Vigil is available
local Vigil = require(ReplicatedStorage:WaitForChild("Vigil"))
local player = Players.LocalPlayer

-- UI Construction
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "VigilTestGui"
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(1, -340, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 80)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Test Tracker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = MainFrame

UIListLayout.Parent = MainFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

UIPadding.Parent = MainFrame
UIPadding.PaddingBottom = UDim.new(0, 15)
UIPadding.PaddingLeft = UDim.new(0, 15)
UIPadding.PaddingRight = UDim.new(0, 15)
UIPadding.PaddingTop = UDim.new(0, 5)

-- Component Factory
local function createTrackerCard(name, typeName)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 70)
    card.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    card.BorderSizePixel = 0
    card.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamMedium
    title.Text = name
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 25)
    status.Position = UDim2.new(0, 10, 0, 35)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.Text = "Status..."
    status.TextColor3 = Color3.fromRGB(150, 150, 180)
    status.TextSize = 12
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = card

    local typeLabel = Instance.new("TextLabel")
    typeLabel.Size = UDim2.new(0, 60, 0, 18)
    typeLabel.Position = UDim2.new(1, -70, 0, 10)
    typeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    typeLabel.Font = Enum.Font.GothamBold
    typeLabel.Text = typeName:upper()
    typeLabel.TextColor3 = Color3.new(1,1,1)
    typeLabel.TextSize = 9
    typeLabel.Parent = card
    Instance.new("UICorner", typeLabel).CornerRadius = UDim.new(0, 4)

    return card, status
end

-- Initialize Vigil
local harness = Vigil.Mount({ Player = player })

-- 1. Boolean
local boolCard, boolStatus = createTrackerCard("Main Objective", "Boolean")
local boolT = Vigil.Boolean("Objective1", false)
harness.SetTracker("bool", boolT)

-- 2. Stages
local stageCard, stageStatus = createTrackerCard("Scavenger Hunt", "Stages")
local stageT = Vigil.Stages("Stages1", { ["Find Map"] = false, ["Find Key"] = false, ["Open Chest"] = false })
harness.SetTracker("stages", stageT)

-- 3. Numeric
local numCard, numStatus = createTrackerCard("Slayer Quest", "Numeric")
local numT = Vigil.Numeric("Numeric1", 10, 0)
harness.SetTracker("num", numT)

-- Update Function
local function refresh()
    boolStatus.Text = if boolT.Progress then "COMPLETE" else "INCOMPLETE"
    boolStatus.TextColor3 = if boolT.Progress then Color3.fromRGB(100, 255, 100) else Color3.fromRGB(255, 100, 100)
    
    local done = 0
    local total = 0
    for _, v in pairs(stageT.Progress) do
        total += 1
        if v then done += 1 end
    end
    stageStatus.Text = `Steps Completed: {done} / {total}`
    
    numStatus.Text = `Kills: {numT.Progress.Current} / {numT.Progress.Goal} ({math.floor(numT.GetProgressPercent())}%) ({numT.GetProgressRatio()})`
end

-- Controls
local ControlBtn = Instance.new("TextButton")
ControlBtn.Size = UDim2.new(1, 0, 0, 45)
ControlBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 255)
ControlBtn.Font = Enum.Font.GothamBold
ControlBtn.Text = "SIMULATE PROGRESS"
ControlBtn.TextColor3 = Color3.new(1, 1, 1)
ControlBtn.TextSize = 14
ControlBtn.Parent = MainFrame
Instance.new("UICorner", ControlBtn).CornerRadius = UDim.new(0, 8)

ControlBtn.Activated:Connect(function()
    if not boolT.Progress then
        boolT.Update(true)
    elseif not stageT.GetStage("Find Map") then
        stageT.SetStage("Find Map", true)
    elseif not stageT.GetStage("Find Key") then
        stageT.SetStage("Find Key", true)
    elseif not stageT.GetStage("Open Chest") then
        stageT.SetStage("Open Chest", true)
    elseif numT.Progress.Current < numT.Progress.Goal then
        numT.AddProgress(1)
    else
        -- Reset all
        boolT.Update(false)
        stageT.SetStage("Find Map", false)
        stageT.SetStage("Find Key", false)
        stageT.SetStage("Open Chest", false)
        numT.WriteProgress(0)
    end
    refresh()
end)

refresh()
print("Vigil Test UI Loaded.")
