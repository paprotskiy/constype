package.path = package.path .. ";../?.lua"
local file = require("app.io.fileSystem.file")
local relativePath = "../../texts/book"
local rows = file.ReadFile(relativePath)

local function printNumbersWithSameLength(num)
   local max_length = 4
   local num_str = tostring(num)
   local zeros_to_add = max_length - #num_str
   local padded_num_str = string.rep("0", zeros_to_add) .. num_str
   return padded_num_str
end

local function endsWithSymbol(str, symb)
   return str:sub(- #symb) == symb
end

local par = ""
local paragraphs = {}
for i, part in ipairs(rows) do
   par = par .. part .. "\n"
   if endsWithSymbol(part, ".") then
      table.insert(paragraphs, par)
      par = ""
   elseif not endsWithSymbol(part, " ") then
      par = par .. " "
   end
end

for i, part in ipairs(paragraphs) do
   local path = "../../texts/parts/" .. printNumbersWithSameLength(i) .. ".txt"
   print(path)
   file.WriteFile(path, part)
end
