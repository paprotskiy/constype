package.path = package.path .. ";../?.lua"
local tty = require("app.ui.tty.tty")
local cfg = require("app.cfg.config")
local signal = require("posix.signal")
local baseController = require("app.controllers.base")

local baseControllerInstance = baseController.New(cfg, tty.EventDriver)

local function terminate()
   baseControllerInstance:Bye(function()
      os.execute("sleep 0.5")
   end)

   os.exit(0)
end

signal.signal(signal.SIGINT, terminate)

baseControllerInstance:Start()

terminate()
