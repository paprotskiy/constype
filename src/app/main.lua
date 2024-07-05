package.path = package.path .. ";../?.lua"
local tty = require("app.ui.tty.tty")
local cfg = require("app.cfg.config")
local signal = require("posix.signal")
local baseController = require("app.controllers.base")

local function getStorage()
   local connBuilder = require("app.repo.conn")
   local repoBuilder = require("app.repo.repo")
   local conn = connBuilder.pg_connection()
   local repo = repoBuilder.new(conn)
   return repo
end
local storage = getStorage()

local baseControllerInstance = baseController.new(cfg, tty.event_driver, storage, function()
   os.execute("sleep 0.5")
end)

signal.signal(signal.SIGINT, function()
   baseControllerInstance:bye()
   os.exit(0)
end)

baseControllerInstance:start()