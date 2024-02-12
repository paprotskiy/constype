return {
   ParseTtySizeOutput = function(input)
      local parts = {}

      for str in string.gmatch(input, "([^ ]+)") do
         table.insert(parts, str)
      end

      if #parts ~= 2 then
         error(string.format("wrong input composition: contains %s parts, expected %s", #parts, 2))
      end

      local maxX = tonumber(parts[1])
      local maxY = tonumber(parts[2])

      if maxX == nil or maxY == nil or maxX < 0 or maxY < 0 then
         error(string.format('failed to parse "%s" to number pair', input))
      end

      return {
         MaxX = maxX,
         MaxY = maxY,
      }
   end,
}
