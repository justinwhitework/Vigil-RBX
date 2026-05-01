--TESTS CREATED WITH THE USE OF GENERATIVE AI
--THE MAIN LIBRARY, VIGIL, WAS NOT!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vigil = require(ReplicatedStorage.Vigil)

local function log(testName, passed, message)
    if passed then
        print(`[PASSED] {testName}`)
    else
        warn(`[FAILED] {testName}: {message}`)
    end
end

local function mockPlayer(name, id)
    return {
        Name = name or "TestPlayer",
        UserId = id or 1,
        ClassName = "Player"
    } :: any
end

print("--- Vigil Test ---")

-- Scenario 1: Re-mounting and Persistence
do
    local p1 = mockPlayer("Satoshi", 101)
    local h1 = Vigil.Mount({ Player = p1 })
    local quest = Vigil.Boolean("InitialQuest")
    h1.SetTracker("q1", quest)

    local h2 = Vigil.Mount({ Player = p1 })
    log("Re-mounting returns same instance", h1 == h2, "Instances differed")
    log("Persistence of trackers", h2.GetTracker("q1") == quest, "Tracker lost after re-mount")
end

-- Scenario 2: Multiple Trackers & Management
do
    local p2 = mockPlayer("Vitalik", 102)
    local h = Vigil.Mount({ Player = p2 })
    
    local t1 = Vigil.Boolean("B")
    local t2 = Vigil.Numeric("N", 10)
    local t3 = Vigil.Stages("S")
    
    h.SetTracker("bool", t1)
    h.SetTracker("num", t2)
    h.SetTracker("stage", t3)
    
    log("Multi-tracker count", #table.create(0) == 0, "Checking registry size...") -- ActiveTrackers is a dict
    local count = 0
    for _ in pairs(h.ActiveTrackers) do count += 1 end
    log("Multi-tracker count", count == 3, "Wrong number of trackers")
    
    h.RemoveTracker("bool")
    log("RemoveTracker logic", h.GetTracker("bool") == nil, "Failed to remove tracker")
end

-- Scenario 3: Complex Stages Flow
do
    local p3 = mockPlayer("Charles", 103)
    local h = Vigil.Mount({ Player = p3 })
    local tracker = Vigil.Stages("Quest", { Step1 = false })
    
    tracker.AddStage("Step2", false)
    log("Stages AddStage", tracker.GetStage("Step2") == false, "AddStage failed")
    
    tracker.WriteStage("Step1", true)
    log("Stages Progress 1/2", tracker.GetAllStages() == false, "GetAllStages incorrect")
    
    tracker.SetStage("Step2", true)
    log("Stages Progress 2/2", tracker.GetAllStages() == true, "GetAllStages incorrect")
    
    tracker.RemoveStage("Step1")
    log("Stages Remove", tracker.GetStage("Step1") == nil, "RemoveStage failed")
end

-- Scenario 4: Numeric Boundaries
do
    local p4 = mockPlayer("Gavin", 104)
    local h = Vigil.Mount({ Player = p4 })
    local tracker = Vigil.Numeric("GoalShift", 100)
    
    tracker.AddProgress(50)
    log("Numeric Halfway", tracker.GetProgressRatio() == 0.5, "Ratio incorrect")
    
    tracker.SetGoal(200)
    log("Numeric Goal Change", tracker.GetProgressPercent() == 25, "Percent incorrect after goal change")
    
    tracker.SubtractProgress(25)
    log("Numeric Subtract", tracker.GetProgress().Current == 25, "Subtract failed")
    
    local zeroGoal = Vigil.Numeric("Zero", 0)
    log("Numeric Zero Goal Safety", zeroGoal.GetProgressRatio() == 0, "Ratio failed on zero goal")
end

-- Scenario 5: Independent Dismounts
do
    local p1 = mockPlayer("User1", 201)
    local p2 = mockPlayer("User2", 202)
    
    local h1 = Vigil.Mount({ Player = p1 })
    local h2 = Vigil.Mount({ Player = p2 })
    
    local t1 = Vigil.Boolean("T1")
    h1.SetTracker("T1", t1)
    
    h2.Dismount()
    log("Independent Dismount (p1 safe)", Vigil.Get(p1) ~= nil, "P1 accidentally dismounted")
    log("Independent Dismount (p2 cleared)", Vigil.Get(p2) == nil, "P2 failed to dismount")
    log("P1 Tracker Status", t1.Status == "Active", "P1 tracker affected by P2 dismount")
end

print("--- All Vigil Tests Completed ---")
