local mainController = require("app.controllers.main")
local aux1Controller = require("app.controllers.aux")
local aux2Controller = require("app.controllers.aux2")

local mainControllerImpl = nil
local aux1ControllerImpl = nil
local aux2ControllerImpl = nil
local baseControllerFactory = function(signalStream)
	return {
		__signalStream = nil,
		__currentController = nil,

		Close = function(self)
			self.__currentController:Close()
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

		Start = function(self)
			mainControllerImpl = mainController.New
			self:__switchAndRun(mainControllerImpl)
		end,

		Aux = function(self)
			aux1ControllerImpl = aux1Controller.New
			self:__switchAndRun(aux1ControllerImpl)
		end,

		Aux2 = function(self)
			aux2ControllerImpl = aux2Controller.New
			self:__switchAndRun(aux2ControllerImpl)
		end,
	}
end

return {
	New = baseControllerFactory,
}
