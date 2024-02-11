package.path = package.path .. ";../?.lua"
local topic = require("app.topics.example")
-- local lexic = require("app.lexic.char")
local term = require("app.term")
local signal = require("posix.signal")

signal.signal(signal.SIGINT, function()
   term.ClearScreen()
   os.exit(0)
end)

term.Mode1(topic)
