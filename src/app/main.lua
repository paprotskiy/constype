package.path = package.path .. ";../?.lua"
local example = require("app.topics.example")
local tty = require("app.ui.tty.tty")
local topic = require("app.lexic.topic")
local signal = require("posix.signal")
local storage = require("app.storage.storage")
local pp = require("utils.print.pretty")
local excercise = require("app.controllers.excercise")
local mainController = require("app.controllers.main")
local fs = require("app.io.fileSystem.file")

signal.signal(signal.SIGINT, function()
	term.ClearScreen()
	os.exit(0)
end)

mainController(tty.EventDriver)
