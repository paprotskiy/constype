local view_main = require("app.ui.view.start")

local start_controller = function(base_controller_invoke)
	return {
		load = function()
			view_main:load()
		end,

		close = function()
			view_main:close()
		end,

		handle_signal = function(self, atomic_signal)
			local action = self[atomic_signal]

			if action == nil then
				return self.default
			end
			return action
		end,

		default = function(_, signal_char) end,

		-- todo make esc const
		[string.char(27)] = function(_, signal_char)
			base_controller_invoke:bye()
		end,

		--  todo make backspace const
		[string.char(127)] = function(_, signal_char)
			base_controller_invoke:bye()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, signal_char)
			base_controller_invoke:pick_plan()
		end,
	}
end

return {
	new = start_controller,
}
