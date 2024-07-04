local view = require("app.ui.view.pickPlan")
local model = require("app.domain.pickPlan")

local pick_plan_controller = function(base_controller_invoke, cfg, storage)
	local plan_list = model:new(storage)

	return {
		load = function()
			local plans = plan_list:list()

			-- todo DTO layer required
			local keyval = {}
			for _, v in ipairs(plans) do
				table.insert(keyval, {
					Key = v.Id,
					value = v.title,
				})
			end

			view:load(cfg, keyval)
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

		default = function(_, signal_char) end,

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
			base_controller_invoke:pick_topic(curr.Key)
		end,
	}
end

return {
	new = pick_plan_controller,
}
