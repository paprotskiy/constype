package.path = package.path .. ";../?.lua"
local example = require("app.topics.example")
local term = require("app.ui.tty.tty")
local topic = require("app.lexic.topic")
local signal = require("posix.signal")
local fs = require("app.io.fileSystem.file")
local cjson = require("cjson")

signal.signal(signal.SIGINT, function()
   term.ClearScreen()
   os.exit(0)
end)

local topicObj = topic.NewTopic(example)
local enc = cjson.encode(topicObj)
fs.WriteFile("/pers/topic.json", enc)
