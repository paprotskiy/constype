package.path = package.path .. ";../?.lua"
local file = require("app.io.fileSystem.file")

local relativePath = "../../text.txt"
local rows = file.ReadFile(relativePath)

return table.concat(rows, "\n")
