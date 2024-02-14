local function file_exists(file)
   local f = io.open(file, "rb")
   if f then
      f:close()
   end
   return f ~= nil
end

local function lines_from(file)
   if not file_exists(file) then
      return {}
   end
   local lines = {}
   for line in io.lines(file) do
      lines[#lines + 1] = line
   end
   return lines
end

return {
   ReadFile = function(filePath)
      return lines_from(filePath)
   end,

   WriteFile = function(filePath, data)
      local file = io.open(filePath, "w")
      file:write(data)
      file:flush()
      file:close()
   end,
}
