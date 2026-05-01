local Players = game:GetService("Players")
local Mount = {}

local Types = require(script.Parent.Types)

local Cache: { [Player]: Types.VigilInstance } = {}

function Mount.Get(player: Player): Types.VigilInstance?
	return Cache[player]
end

function Mount.MountPlayer(options: Types.VigilMountOptions): Types.VigilInstance
    local VigilInstance: Types.VigilInstance = {
		Player = options.Player,
		ActiveTrackers = {},
	}

	if Cache[VigilInstance.Player] then
		return Cache[VigilInstance.Player]
	end

	function VigilInstance.SetTracker(id: string, tracker: Types.TrackerHandle)
		VigilInstance.ActiveTrackers[id] = tracker
	end

	function VigilInstance.GetTracker(id: string): Types.TrackerHandle?
		return VigilInstance.ActiveTrackers[id]
	end

	function VigilInstance.RemoveTracker(id: string)
		VigilInstance.ActiveTrackers[id] = nil
	end

    function VigilInstance.Dismount()
        Cache[VigilInstance.Player] = nil
        for i,v in pairs(VigilInstance.ActiveTrackers) do
            v.SetStatus("Abandoned")
        end
    end

	-- Optional Auto-Dismount
	if options.AutoDismount then
		local connection
		connection = Players.PlayerRemoving:Connect(function(leavingPlayer)
			if leavingPlayer == VigilInstance.Player then
				VigilInstance.Dismount()
                connection:Disconnect()
			end
		end)
	end

	Cache[VigilInstance.Player] = VigilInstance
	return VigilInstance
end

return Mount