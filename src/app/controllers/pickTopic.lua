local overlayable_char = require("app.domain.lexic.char")
local view = require("app.ui.view.pickTopic")
local model = require("app.domain.pickTopic")
local pp = require("utils.print.pretty")

local function pick_topic_controller(base_controller_invoke, storage, plan_id)
	return {
		load = function()
			view:load()
			local topic_data = model:first_unfinished(storage, plan_id)
			if topic_data == nil then
				base_controller_invoke:plan_report(plan_id)
				return
			end

			base_controller_invoke:exercise(plan_id, topic_data)
		end,

		close = function()
			view:close()
		end,
	}
end

return {
	new = pick_topic_controller,
}
