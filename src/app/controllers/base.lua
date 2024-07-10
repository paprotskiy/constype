local start_controller = require("app.controllers.start")
local bye_controller = require("app.controllers.bye")
local pick_plan_controller = require("app.controllers.pickPlan")
local pick_topic_controller = require("app.controllers.pickTopic")
local exercise_controller = require("app.controllers.exercise")
local exercise_report_controller = require("app.controllers.exerciseReport")
local plan_report_controller = require("app.controllers.planReport")
local menu_controller = require("app.controllers.menu")
local import_as_plan_controller = require("app.controllers.importAsPlan")

-- controllers with persistent state
-- local startControllerImpl
-- local exerciseControllerImpl
local base_controller_factory = function(cfg, signal_stream, storage, stuff_for_shutting_down)
	return {
		__current_controller = nil,

		close = function(self)
			if self.__current_controller ~= nil then
				self.__current_controller:close()
			end
			self.__current_controller = nil
		end,

		__switch_and_run = function(self, controller_constructor, ...)
			local arg = { ... }
			self:close() -- for guaranteed shutdown of previous controller

			local controller = controller_constructor(self, table.unpack(arg))
			self.__current_controller = controller

			controller:load()

			while self.__current_controller == controller do
				local atomic_signal = signal_stream()
				local action = controller:handle_signal(atomic_signal)
				action(controller, atomic_signal)
			end
		end,

		--

		start = function(self)
			self:__switch_and_run(start_controller.new, storage)
		end,

		menu = function(self)
			self:__switch_and_run(menu_controller.new, cfg.terminal_colors)
		end,

		import_as_plan = function(self)
			self:__switch_and_run(import_as_plan_controller.new, cfg.terminal_colors, storage)
		end,

		pick_plan = function(self)
			self:__switch_and_run(pick_plan_controller.new, cfg.terminal_colors, storage)
		end,

		pick_topic = function(self, plan_id)
			self:__switch_and_run(pick_topic_controller.new, storage, plan_id)
		end,

		exercise = function(self, plan_id, topic_data)
			self:__switch_and_run(exercise_controller.new, cfg.terminal_colors, plan_id, topic_data)
		end,

		exercise_report = function(self, topic_data, topic_walkthrough, plan_id)
			self:__switch_and_run(exercise_report_controller.new, cfg, storage, topic_data, topic_walkthrough, plan_id)
		end,

		plan_report = function(self, wholeplan_report)
			self:__switch_and_run(plan_report_controller.new, cfg, wholeplan_report)
		end,

		bye = function(self)
			self:__switch_and_run(bye_controller.new, stuff_for_shutting_down)
		end,
	}
end

return {
	new = base_controller_factory,
}
