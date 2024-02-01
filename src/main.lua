package.path = package.path .. ";../?.lua"
local topic = require("src.topics.example")
local lexic = require("src.lexic.char")

local text = topic
print(text)
