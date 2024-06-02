local startController = require("app.controllers.start")
local byeController = require("app.controllers.bye")
local exerciseController = require("app.controllers.exercise")
local exerciseReportController = require("app.controllers.exerciseReport")

-- controllers with persistent state
-- local startControllerImpl
-- local exerciseControllerImpl
local baseControllerFactory = function(cfg, signalStream, storage)
	return {
		__signalStream = nil,
		__currentController = nil,

		Close = function(self)
			if self.__currentController ~= nil then
				self.__currentController:Close()
			end
			self.__currentController = nil
		end,

		__switchAndRun = function(self, controllerConstructor, ...)
			local arg = { ... }

			local controller = controllerConstructor(self, table.unpack(arg))
			self.__currentController = controller

			controller:Load()

			while self.__currentController == controller do
				local atomicSignal = signalStream()
				local action = controller:HandleSignal(atomicSignal)
				action(controller, atomicSignal)
			end

			controller:Close()
		end,

		--

		Start = function(self)
			self:__switchAndRun(startController.New, storage)
		end,

		Exercise = function(self, topicData)
			self:__switchAndRun(exerciseController.New, cfg.TerminalColors, topicData)
		end,

		ExerciseReport = function(self, topicData, topicWalkthrough)
			self:__switchAndRun(exerciseReportController.New, cfg.TerminalColors, storage, topicData, topicWalkthrough)
		end,

		Bye = function(_, stuffForShuttingDown)
			local controller = byeController.New()
			controller:Load()
			stuffForShuttingDown()
			controller:Close()
		end,
	}
end

return {
	New = baseControllerFactory,
}
