package.path = package.path .. ";../?.lua"
local tty = require("app.ui.tty.tty")
local signal = require("posix.signal")
local baseController = require("app.controllers.base")

local baseControllerInstance = baseController.New(tty.EventDriver)

local function terminate()
	baseControllerInstance:Bye(function()
		os.execute("sleep 0.5")
	end)

	os.exit(0)
end

signal.signal(signal.SIGINT, terminate)
baseControllerInstance:Start()
terminate()
