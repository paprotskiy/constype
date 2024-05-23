local startController = require("app.controllers.start")
local byeController = require("app.controllers.bye")
local excerciseController = require("app.controllers.excercise")

-- controllers with persistent state
-- local startControllerImpl
-- local excerciseControllerImpl
local baseControllerFactory = function(cfg, signalStream)
	return {
		__signalStream = nil,
		__currentController = nil,

		Close = function(self)
			if self.__currentController ~= nil then
				self.__currentController:Close()
			end
			self.__currentController = nil
		end,

		__switchAndRun = function(self, childController, ...)
			local arg = { ... }

			local controller = childController(self, table.unpack(arg))
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
			local startControllerImpl = startController.New
			self:__switchAndRun(startControllerImpl)
		end,

		Excercise = function(self, text)
			local excerciseControllerImpl = excerciseController.New
			self:__switchAndRun(excerciseControllerImpl, cfg.TerminalColors, text)
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
