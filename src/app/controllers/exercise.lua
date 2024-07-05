local overlayable_char = require("app.domain.lexic.char")
local view = require("app.ui.view.exercise")
local model = require("app.domain.exercise")

local map_statusToColors = {}
local function init_text_color(cfg)
	map_statusToColors[overlayable_char.statuses().null] = view.wrap_text_to_color(cfg.default, cfg.default)
	map_statusToColors[overlayable_char.statuses().succ] = view.wrap_text_to_color(cfg.succ, cfg.default)
	map_statusToColors[overlayable_char.statuses().fail] = view.wrap_text_to_color(cfg.fail, cfg.default)
	map_statusToColors[overlayable_char.statuses().fixed] = view.wrap_text_to_color(cfg.fixed, cfg.default)
end

local function convert_symbol_dto(update)
	local res = {}

	if update == nil then
		return res
	end

	local wrapper = map_statusToColors[update.status]

	local val = update.value
	local failed = overlayable_char.compare_statuses(update.status, overlayable_char.statuses().fail)
	local fixed = overlayable_char.compare_statuses(update.status, overlayable_char.statuses().fixed)
	if val == " " and (failed or fixed) then
		val = "·"
	end

	table.insert(res, {
		x = update.position.char_num,
		y = update.position.line_num,
		data = wrapper(val),
	})
	table.insert(res, {
		x = update.jump.char_num,
		y = update.jump.line_num,
		data = "",
	})

	return res
end

local exercise_controller = function(base_controller_invoke, cfg, plan_id, topic_data)
	init_text_color(cfg)

	local winsize = view:current_winsize()
	local exercise = model:new(topic_data.Topic, winsize.max_x)

	return {
		load = function()
			-- todo leaking abstraction - connection via plain text
			view:load(exercise:plain_text())
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

		default = function(_, signal_char)
			local domain_dto = exercise:type_symbol(signal_char)
			local view_dto = convert_symbol_dto(domain_dto)
			view:refresh(view_dto)

			if exercise:done() then
				local topic_walkthrough = exercise:get_topic()
				base_controller_invoke:exercise_report(topic_data, topic_walkthrough, plan_id)
				return
			end
		end,

		--  todo make backspace const
		[string.char(127)] = function(_, _)
			local domain_dto = exercise:erase_symbol()
			local view_dto = convert_symbol_dto(domain_dto)
			view:refresh(view_dto)
		end,

		-- todo make esc const
		[string.char(27)] = function(_, signal_char)
			base_controller_invoke:pick_plan()
		end,

		--  todo make enter const
		[string.char(10)] = function(_, _) end,
	}
end

return {
	new = exercise_controller,
}
