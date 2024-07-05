local view = require("app.ui.view.planReport")

local plan_report_controller = function(base_controller_invoke, cfg, wholeplan_report)
	return {
		load = function()
			view:load()
		end,

		close = function()
			view:close()
		end,

		handle_signal = function(self, atomic_signal)
			local action = self[atomic_signal]

			if action == nil then
				return self.default
			end
			return action
		end,

		default = function(_, _) end,

		--  todo make backspace const
		[string.char(127)] = function(_, _)
			base_controller_invoke:bye()
		end,

		-- todo make esc const
		[string.char(27)] = function(_, _)
			base_controller_invoke:bye()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _)
			base_controller_invoke:pick_plan()
		end,
	}
end

return {
	new = plan_report_controller,
}
