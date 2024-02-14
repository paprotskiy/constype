package.path = package.path .. ";../?.lua"
local topic = require("app.topics.example")
local term = require("app.term.luaterm")
-- local lexic = require("app.lexic.char")
local signal = require("posix.signal")

signal.signal(signal.SIGINT, function()
   term.ClearScreen()
   os.exit(0)
end)
