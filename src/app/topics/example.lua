package.path = package.path .. ";../?.lua"
local file = require("src.io.fileSystem.file")

local relativePath = "./src/text.txt"
local rows = file.ReadFile(relativePath)

print(#rows)

local wholeText = ""
for _, v in pairs(rows) do
	wholeText = wholeText .. "\n" .. tostring(v)
end

return wholeText
