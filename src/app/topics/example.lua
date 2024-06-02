package.path = package.path .. ";../?.lua"
local file = require("app.io.fileSystem.file")

local relativePath = "../../texts/parts/0064.txt"
local rows = file.ReadFileLines(relativePath)

return table.concat(rows, "\n")
