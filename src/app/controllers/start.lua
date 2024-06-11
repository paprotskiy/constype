local viewMain = require("app.ui.view.start")
local domainMain = require("app.domain.main")

local mainController = function(baseControllerInvoke, storage)
	local planId = "7dd6477d-be04-4fb9-92cd-70935ae09ba3"

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
