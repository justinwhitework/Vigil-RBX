# Vigil

Vigil is a headless mission tracking system for Roblox. it manages the flow of missions and quests while remaining agnostic of your game's mechanics or UI.

## Getting Started

### Installation
Vigil is built with **Argon** but does not require it to be used.

### Mounting a Player
The "Harness" (VigilInstance) is the core session for a player. Mounting a player creates this harness and caches it.

```lua
local Vigil = require(path.to.Vigil)

local harness = Vigil.Mount({
    Player = somePlayer,
    AutoDismount = true 
})
```

## Tracker Types

Vigil provides three specialized tracker types to handle different mission logic.

### 1. Boolean Tracker
Perfect for simple "Talk to NPC" or "Visit Location" objectives.

```lua
local quest = Vigil.Boolean("TalkToKing", false)
harness.SetTracker("KingQuest", quest)

-- Update state
quest.Update(true)
```

### 2. Stages Tracker
Used for objectives with multiple sub-steps (e.g., "Find the 3 artifacts").

```lua
local quest = Vigil.Stages("ArtifactHunt", {
    ["Red Key"] = false,
    ["Blue Key"] = false
})

-- Update a specific stage
quest.SetStage("Red Key", true)

-- Check if all are done
if quest.GetAllStages() then
    print("All items found!")
end
```

### 3. Numeric Tracker
Best for "Kill X enemies" or "Collect X Gold".

```lua
local quest = Vigil.Numeric("Slayer", 10) -- ID, Goal

-- Progress tracking
quest.AddProgress(1)

print(quest.GetProgressPercent()) -- 10
print(quest.GetProgressRatio()) -- 0.1
```

### Comming Soon :
* Tracker Templating :
    * Trackers can be defined ahead of time and built 'factory style' from the template.
* Serialization :
    * The ability to store/recover a harness state from JSON or a Table
* Declarative Style Rules :
    * The ability to define rules that automatically progress or modify trackers (e.g. "Kill 10 Goblins to complete 'Slayer'")

## 🛠 API Reference

### Vigil
- `Vigil.Mount(options)`: Creates/Gets a harness for a player.
- `Vigil.Get(player)`: Retrieves an existing harness.
- `Vigil.Boolean(id, state?, metadata?)`: Factory for boolean trackers.
- `Vigil.Stages(id, stages?, metadata?)`: Factory for stages trackers.
- `Vigil.Numeric(id, goal, current?, metadata?)`: Factory for numeric trackers.

### VigilInstance (Harness)
- `SetTracker(id, tracker)`: Assigns a tracker to the player.
- `GetTracker(id)`: Retrieves a tracker by ID.
- `RemoveTracker(id)`: Removes a tracker.
- `Dismount()`: Manually cleans up the session and marks trackers as "Abandoned".

---
*Vigil was built for high-performance mission tracking with a focus on developer experience.*
