package.path = package.path .. ";../?.lua"
local file = require("src.io.file")
local path = "text.txt"

local rows = file.ReadFile(path)
print(#rows)
for k, v in pairs(file.ReadFile(path)) do
   print("line[" .. k .. "]", v)
end
