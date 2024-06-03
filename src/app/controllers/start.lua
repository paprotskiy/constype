local viewMain = require("app.ui.view.start")
local domainMain = require("app.domain.main")

local mainController = function(baseControllerInvoke, storage)
	local planId = "43ac17df-0532-4180-a997-c0850c6dd0b4"

	return {
		Load = function()
			viewMain:Load()
		end,

		Close = function()
			viewMain:Close()
		end,

		HandleSignal = function(self, atomicSignal)
			local action = self[atomicSignal]

			if action == nil then
				return self.Default
			end
			return action
		end,

		Default = function(_, signalChar) end,

		-- todo make esc const
		[string.char(27)] = function(_, signalChar)
			baseControllerInvoke:Close()
		end,
		--  todo make backspace const
		[string.char(127)] = function(_, signalChar)
			baseControllerInvoke:Close()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, signalChar)
			local topicData = domainMain:FirstUnfinished(storage, planId)
			baseControllerInvoke:Exercise(topicData)
		end,
	}
end

return {
	New = mainController,
}
