local startController = require("app.controllers.start")
local byeController = require("app.controllers.bye")
local pickPlanController = require("app.controllers.pickPlan")
local pickTopicController = require("app.controllers.pickTopic")
local exerciseController = require("app.controllers.exercise")
local exerciseReportController = require("app.controllers.exerciseReport")
local planReportController = require("app.controllers.planReport")

-- controllers with persistent state
-- local startControllerImpl
-- local exerciseControllerImpl
local baseControllerFactory = function(cfg, signalStream, storage, stuffForShuttingDown)
	return {
		__currentController = nil,

		Close = function(self)
			if self.__currentController ~= nil then
				self.__currentController:Close()
			end
			self.__currentController = nil
		end,

		__switchAndRun = function(self, controllerConstructor, ...)
			local arg = { ... }
			self:Close() -- for guaranteed shutdown of previous controller

			local controller = controllerConstructor(self, table.unpack(arg))
			self.__currentController = controller

			controller:Load()

			while self.__currentController == controller do
				local atomicSignal = signalStream()
				local action = controller:HandleSignal(atomicSignal)
				action(controller, atomicSignal)
			end

			-- controller:Close()
		end,

		--

		Start = function(self)
			self:__switchAndRun(startController.New, storage)
		end,

		PickPlan = function(self)
			self:__switchAndRun(pickPlanController.New, cfg.TerminalColors, storage)
		end,

		PickTopic = function(self, planId)
			self:__switchAndRun(pickTopicController.New, storage, planId)
		end,

		Exercise = function(self, planId, topicData)
			self:__switchAndRun(exerciseController.New, cfg.TerminalColors, planId, topicData)
		end,

		ExerciseReport = function(self, topicData, topicWalkthrough, planId)
			self:__switchAndRun(exerciseReportController.New, cfg, storage, topicData, topicWalkthrough, planId)
		end,

		PlanReport = function(self, wholePlanReport)
			self:__switchAndRun(planReportController.New, cfg, wholePlanReport)
		end,

		Bye = function(self)
			self:__switchAndRun(byeController.New, stuffForShuttingDown)
		end,
	}
end

return {
	New = baseControllerFactory,
}
