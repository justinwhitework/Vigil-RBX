local Types = {}

export type VigilTrackerType = "Boolean" | "Stages" | "Numeric"
export type VigilTrackerStatus = "Active" | "Completed" | "Failed" | "Abandoned"

export type BaseTrackerHandle = {
    Id: string,
    Status: VigilTrackerStatus,
    
    SetStatus: (status: VigilTrackerStatus) -> ()
}

export type BooleanTrackerHandle = BaseTrackerHandle & {
    Type: "Boolean",
    Progress: boolean,
    Update: (state: boolean) -> (),
}

export type StagesTrackerHandle = BaseTrackerHandle & {
    Type: "Stages",
    Progress: { [string]: boolean },

    WriteStage: (Stage: string, State: boolean) -> (),
    AddStage: (Stage: string, InitialState: boolean) -> (),
    SetStage: (Stage: string, State: boolean) -> (),
    RemoveStage: (Stage: string) -> (),

    GetStage: (Stage: string) -> boolean?,
    GetAllStages: () -> boolean?,
    GetRawProgress: () -> { [string]: boolean },
}

export type NumericTrackerHandle = BaseTrackerHandle & {
    Type: "Numeric",
    Progress: { Current: number, Goal: number },

    WriteProgress: (current: number) -> (),
    AddProgress: (amount: number) -> (),
    SubtractProgress: (amount: number) -> (),

    SetGoal: (goal: number) -> (),

    GetProgress: () -> { Current: number, Goal: number },
    GetProgressRatio: () -> number,
    GetProgressPercent: () -> number,
    
    GetRawProgress: () -> { Current: number, Goal: number },
}

export type TrackerHandle = BooleanTrackerHandle | StagesTrackerHandle | NumericTrackerHandle

export type VigilInstance = {
    Player: Player,
    ActiveTrackers: { [string]: TrackerHandle },
    
    SetTracker: (id: string, tracker: TrackerHandle) -> (),
    GetTracker: (id: string) -> TrackerHandle?,
    RemoveTracker: (id: string) -> (),

    Dismount: () -> ()
}

export type VigilMountOptions = {
    Player: Player,
    AutoDismount: boolean?,
}

return Types