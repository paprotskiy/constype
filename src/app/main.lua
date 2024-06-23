package.path = package.path .. ";../?.lua"
local tty = require("app.ui.tty.tty")
local cfg = require("app.cfg.config")
local signal = require("posix.signal")
local baseController = require("app.controllers.base")

local function getStorage()
   local connBuilder = require("app.repo.conn")
   local repoBuilder = require("app.repo.repo")
   local conn = connBuilder.PgConnection()
   local repo = repoBuilder.New(conn)
   return repo
end
local storage = getStorage()

local baseControllerInstance = baseController.New(cfg, tty.EventDriver, storage, function()
   os.execute("sleep 0.5")
end)

signal.signal(signal.SIGINT, function()
   baseControllerInstance:Bye()
   os.exit(0)
end)

baseControllerInstance:Start()