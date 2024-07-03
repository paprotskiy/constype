local viewMain = require("app.ui.view.start")

local mainController = function(baseControllerInvoke)
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
			baseControllerInvoke:Bye()
		end,
		--  todo make backspace const
		[string.char(127)] = function(_, signalChar)
			baseControllerInvoke:Bye()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, signalChar)
			baseControllerInvoke:Menu()
		end,
	}
end

return {
	New = mainController,
}
