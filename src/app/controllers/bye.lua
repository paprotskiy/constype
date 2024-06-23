local viewMain = require("app.ui.view.bye")

local byeController = function(baseControllerInvoke, stuffForShuttingDown)
	return {
		Load = function(_)
			baseControllerInvoke:Close()
			viewMain:Load()
			stuffForShuttingDown()
			viewMain:Close()
		end,

		Close = function()
			viewMain:Close()
		end,

		HandleSignal = function(_, signalChar) end,
	}
end

return {
	New = byeController,
}
