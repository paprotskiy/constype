local view = require("app.ui.view.exerciseReport")
local model = require("app.domain.exerciseReport")

local function design_post_handle_of_report(cfg, report)
	local greenWrap = view.wrap_text_to_color(cfg.succ, cfg.default)
	local redWrap = view.wrap_text_to_color(cfg.fail, cfg.default)

	return {
		good = {
			value = report.good,
			style_wrap = nil,
		},

		fixed = {
			value = report.fixed,
			style_wrap = function(txt)
				if report.fixed == 0 and report.errors == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		errors = {
			value = report.errors,
			style_wrap = function(txt)
				if report.errors == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		time_total = {
			value = report.time_total,
			style_wrap = nil,
		},

		time_lost_on_errors = {
			value = report.time_lost_on_errors,
			style_wrap = function(txt)
				if report.time_lost_on_errors == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		errors_ratio = {
			value = tostring(report.errors_ratio * 100) .. "%",
			style_wrap = function(txt)
				if report.errors_ratio == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},

		wasted_time_ratio = {
			value = tostring(report.wasted_time_ratio * 100) .. "%",
			style_wrap = function(txt)
				if report.wasted_time_ratio == 0 then
					return greenWrap(txt)
				end
				return redWrap(txt)
			end,
		},
	}
end

local exercise_report_controller = function(
	 base_controller_invoke,
	 cfg,
	 storage,
	 topic_data,
	 topic_walkthrough,
	 plan_id
)
	local report = model.build_report(cfg.thresholds, storage, topic_data, topic_walkthrough)
	local styledReport = design_post_handle_of_report(cfg.terminal_colors, report)

	return {
		load = function()
			view:load(styledReport)
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
			base_controller_invoke:pick_plan()
		end,

		-- todo make esc const
		[string.char(27)] = function(_, _)
			base_controller_invoke:pick_plan()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _)
			base_controller_invoke:pick_topic(plan_id)
		end,
	}
end

return {
	new = exercise_report_controller,
}
