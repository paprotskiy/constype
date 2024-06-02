package.path = package.path .. ";../?.lua"
local file = require("app.io.fileSystem.file")
local relativePath = "../../texts/book"
local rows = file.ReadFileLines(relativePath)

local function endsWithSymbol(str, symb)
   return str:sub(- #symb) == symb
end

-- for i, part in ipairs(paragraphs) do
--    local path = "../../texts/parts/" .. printNumbersWithSameLength(i) .. ".txt"
--    print(path)
--    file.WriteFile(path, part)
-- end

return {
   SplitTextToTopics = function(text)
      local par = ""
      local paragraphs = {}
      for _, part in ipairs(rows) do
         par = par .. part .. "\n"
         if endsWithSymbol(part, ".") then
            table.insert(paragraphs, par)
            par = ""
         elseif not endsWithSymbol(part, " ") then
            par = par .. " "
         end
      end

      return paragraphs
   end,
}
