local view = require("app.ui.view.planReport")

local planReportController = function(baseControllerInvoke, cfg, wholePlanReport)
	return {
		Load = function()
			view:Load()
		end,

		Close = function()
			view:Close()
		end,

		HandleSignal = function(self, atomicSignal)
			local action = self[atomicSignal]

			if action == nil then
				return self.Default
			end
			return action
		end,

		Default = function(_, _) end,

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
			baseControllerInvoke:PickPlan()
		end,
	}
end

return {
	New = planReportController,
}
