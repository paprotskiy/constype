local view = require("app.ui.view.menu")

local menu_controller = function(base_controller_invoke, cfg)
	local screen_mapping = {
		[1] = {
			name = "Pick Plan",
			call = function()
				base_controller_invoke:pick_plan()
			end,
		},
		[2] = {
			name = "Import as Plan",
			call = function()
				base_controller_invoke:import_as_plan()
			end,
		},
	}

	return {
		load = function()
			view:load(cfg, screen_mapping)
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

		default = function(_, signalChar) end,

		["j"] = function(_, _)
			view:pick_next()
		end,

		["k"] = function(_, _)
			view:pick_prev()
		end,

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
			local curr_idx = view:get_current()
			screen_mapping[curr_idx].call()
		end,
	}
end

return {
	new = menu_controller,
}
