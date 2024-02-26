local baseController = require("app.controllers.base")
local viewMain = require("app.ui.view.main")

local mainController = function(controllerInvoke)
	return {
		Load = function()
			viewMain:Load()
		end,

		Close = function() end,

		HandleSignal = function(self, atomicSignal)
			local action = self[atomicSignal]
			if action == nil then
				action = self.Default
			end

			return function(atomicSignal)
				action(self, atomicSignal)
			end
		end,

		-- todo make esc const
		[string.char(27)] = function(self)
			controllerInvoke:Close()
		end,
		--  todo make backspace const
		[string.char(127)] = function(self) end,
		--  todo make enter const
		[string.char(10)] = function(self) end,

		Default = function(self, signalChar)
			viewMain.Print(signalChar)
		end,
	}
end

return function(signalStream)
	baseController:Start(signalStream, mainController)
end
