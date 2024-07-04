local view_bye = require("app.ui.view.bye")

local bye_controller = function(base_controller_invoke, stuff_for_shutting_down)
	return {
		load = function(_)
			base_controller_invoke:close()
			view_bye:load()
			stuff_for_shutting_down()
			view_bye:close()
		end,

		close = function()
			view_bye:close()
		end,

		handle_signal = function(_, signal_char) end,
	}
end

return {
	new = bye_controller,
}
