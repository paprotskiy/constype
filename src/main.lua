package.path = package.path .. ";../?.lua"
local topics = require("src.topics.example")
local lexic = require("src.lexic.char")

local text = topics
print(text)
