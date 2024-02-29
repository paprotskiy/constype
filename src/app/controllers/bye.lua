local viewMain = require("app.ui.view.bye")

local mainController = function(baseControllerInvoke)
	return {
		Load = function()
			viewMain:Load()
		end,

		Close = function()
			viewMain:Close()
		end,

		HandleSignal = function(_, signalChar) end,
	}
end

return {
	New = mainController,
}
