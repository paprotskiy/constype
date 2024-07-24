local view = require("app.ui.view.importAsPlan")
local model = require("app.domain.importAsPlan")

local import_as_plan_controller = function(base_controller_invoke, cfg)
	local dir = "../../../persistent"
	local files_list = model.get_list(dir)

	return {
		load = function()
			local val = {}
			for _, v in ipairs(files_list) do
				table.insert(val, {
					value = v.rendered,
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
			base_controller_invoke:menu()
		end,

		-- todo make esc const
		[string.char(27)] = function(_, _)
			base_controller_invoke:bye()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _)
			-- local curr = view:get_current()
			-- for _, v in pairs(files_list) do
			-- 	if v.name == curr.value then
			-- 		v.call()
			-- 		return
			-- 	end
			-- end
		end,
	}
end

return {
	new = import_as_plan_controller,
}
