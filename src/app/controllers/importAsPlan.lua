local view = require("app.ui.view.importAsPlan")

local import_as_plan_controller = function(base_controller_invoke)

	return {
		load = function()
			view.load()
		end,

		close = function()
			view.close()
		end,

		handle_signal = function(self, atomic_signal)
			local action = self[atomic_signal]

			if action == nil then
				return self.default
			end
			return action
		end,

		default = function(_, signalChar) end,

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
			base_controller_invoke:menu()
		end,
	}
end

return {
	new = import_as_plan_controller,
}
