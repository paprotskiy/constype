package.path = package.path .. ";../?.lua"
local topic = require("app.topics.example")
local lexic = require("app.lexic.char")

local text = topic
print(text)
