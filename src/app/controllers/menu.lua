local view = require("app.ui.view.menu")

local menu_controller = function(base_controller_invoke, cfg)
	local screen_mapping = {
		{
			name = "Pick Plan",
			call = function()
				base_controller_invoke:pick_plan()
			end,
		},
		{
			name = "Import as Plan",
			call = function()
				base_controller_invoke:import_as_plan()
			end,
		},
	}

	return {
		load = function()
			-- todo DTO layer required
			local val = {}
			for _, v in ipairs(screen_mapping) do
				table.insert(val, {
					value = v.name,
				})
			end

			view:load(cfg, val)
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
			local curr = view:get_current()
			for _, v in ipairs(screen_mapping) do
				if v.name == curr.value then
					v.call()
					return
				end
			end
		end,
	}
end

return {
	new = menu_controller,
}
