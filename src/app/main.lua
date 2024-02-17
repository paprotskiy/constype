package.path = package.path .. ";../?.lua"
local example = require("app.topics.example")
local term = require("app.ui.tty.tty")
local topic = require("app.lexic.topic")
local signal = require("posix.signal")
local storage = require("app.storage.storage")
local pp = require("utils.print.pretty")
local excercise = require("app.controllers.excercise")

signal.signal(signal.SIGINT, function()
   term.ClearScreen()
   os.exit(0)
end)

-- local obj = topic.NewTopic(example)
-- local obj = storage.Deserialize()

-- term:Mode()

local ex = excercise:New(example, term, nil)
ex:Execute()
