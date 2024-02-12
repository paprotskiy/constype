package.path = package.path .. ";../?.lua"
local topic = require("app.topics.example")
-- local lexic = require("app.lexic.char")
local signal = require("posix.signal")

signal.signal(signal.SIGINT, function()
   -- term.ClearScreen()
   os.exit(0)
end)

require("app.term.luaterm"):Mode(topic)
-- require("app.term.plterm").Mode(topic)
--
