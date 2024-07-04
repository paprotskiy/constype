local view = require("app.ui.view.importAsPlan")

local importAsPlanController = function(baseControllerInvoke)

	return {
		Load = function()
			view.Load()
		end,

		Close = function()
			view.Close()
		end,

		HandleSignal = function(self, atomicSignal)
			local action = self[atomicSignal]

			if action == nil then
				return self.Default
			end
			return action
		end,

		Default = function(_, signalChar) end,

		--  todo make backspace const
		[string.char(127)] = function(_, _)
			baseControllerInvoke:Bye()
		end,

		-- todo make esc const
		[string.char(27)] = function(_, _)
			baseControllerInvoke:Bye()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _)
			baseControllerInvoke:Menu()
		end,
	}
end

return {
	New = importAsPlanController,
}
