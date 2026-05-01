local Tracker = {}

local Types = require(script.Parent.Types)

local function createBase(id: string, metadata: { [string]: any }?): Types.BaseTrackerHandle
	local BaseTracker = {
		Id = id,
		Status = "Active" :: Types.VigilTrackerStatus,
		Metadata = metadata or {},
	}

	function BaseTracker.SetStatus(status: Types.VigilTrackerStatus)
		BaseTracker.Status = status
	end

	return BaseTracker
end

function Tracker.Boolean(id: string, state: boolean?, metadata: any?): Types.BooleanTrackerHandle
	local BooleanTracker = createBase(id, metadata) :: any

	BooleanTracker.Type = "Boolean"
	BooleanTracker.Progress = if state ~= nil then state else false

	function BooleanTracker.Update(state: boolean)
		BooleanTracker.Progress = state
	end

	return BooleanTracker
end

function Tracker.Stages(id: string, stages: { [string]: boolean }?, metadata: any?): Types.StagesTrackerHandle
	local StagesTracker = createBase(id, metadata) :: any

	StagesTracker.Type = "Stages"
	StagesTracker.Progress = stages or {}

	function StagesTracker.WriteStage(Stage: string, State: boolean)
		StagesTracker.Progress[Stage] = State
	end

	function StagesTracker.AddStage(Stage: string, InitialState: boolean)
		if StagesTracker.Progress[Stage] == nil then
			StagesTracker.Progress[Stage] = InitialState
		end
	end

	function StagesTracker.SetStage(Stage: string, State: boolean)
		StagesTracker.Progress[Stage] = State
	end

	function StagesTracker.RemoveStage(Stage: string)
		StagesTracker.Progress[Stage] = nil
	end

	function StagesTracker.GetStage(Stage: string): boolean?
		return StagesTracker.Progress[Stage]
	end

	function StagesTracker.GetAllStages(): boolean?
		local allComplete = true
		local count = 0
		for _, state in pairs(StagesTracker.Progress) do
			count += 1
			if not state then
				allComplete = false
				break
			end
		end
		return if count > 0 then allComplete else nil
	end

	function StagesTracker.GetRawProgress()
		return StagesTracker.Progress
	end

	return StagesTracker
end

function Tracker.Numeric(id: string, goal: number, current: number?, metadata: any?): Types.NumericTrackerHandle
	local NumericTracker = createBase(id, metadata) :: any

	NumericTracker.Type = "Numeric"
	NumericTracker.Progress = {
		Current = current or 0,
		Goal = goal,
	}

	function NumericTracker.WriteProgress(current: number)
		NumericTracker.Progress.Current = current
	end

	function NumericTracker.AddProgress(amount: number)
		NumericTracker.Progress.Current += amount
	end

	function NumericTracker.SubtractProgress(amount: number)
		NumericTracker.Progress.Current -= amount
	end

	function NumericTracker.SetGoal(goal: number)
		NumericTracker.Progress.Goal = goal
	end

	function NumericTracker.GetProgress()
		return NumericTracker.Progress
	end

	function NumericTracker.GetProgressRatio(): number
		if NumericTracker.Progress.Goal == 0 then return 0 end
		return NumericTracker.Progress.Current / NumericTracker.Progress.Goal
	end

	function NumericTracker.GetProgressPercent(): number
		return NumericTracker.GetProgressRatio() * 100
	end

	function NumericTracker.GetRawProgress()
		return NumericTracker.Progress
	end

	return NumericTracker
end

return Tracker
