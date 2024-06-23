local tty = require("app.ui.tty.tty")

local substitutionForSkipped = "..."

local function prepareSubSet(rawList, topIdx, currIdx, bottIdx)
   local res = {}
   for idx = topIdx, bottIdx, 1 do
      table.insert(res, rawList[idx])
   end

   if topIdx ~= 1 then
      res[1] = substitutionForSkipped
   end
   if bottIdx ~= #rawList then
      res[#res] = substitutionForSkipped
   end

   return res, currIdx - topIdx + 1
end

local function shouldBreak(rawList, topIdx, bottIdx, maxSize)
   local onLimits = bottIdx - topIdx >= maxSize

   local onTop = topIdx == 1
   local onBott = bottIdx == #rawList
   local bothBorders = onTop and onBott

   return onLimits or bothBorders
end

local function extendContext(rawList, currIdx, maxSize)
   local topIdx, bottIdx = currIdx, currIdx

   while true do
      if shouldBreak(rawList, topIdx, bottIdx, maxSize) then
         break
      end

      if topIdx > 1 then
         topIdx = topIdx - 1
      end

      if shouldBreak(rawList, topIdx, bottIdx, maxSize) then
         break
      end

      if bottIdx < #rawList then
         bottIdx = bottIdx + 1
      end
   end

   return prepareSubSet(rawList, topIdx, currIdx, bottIdx)
end

return {
   NewTrimmedList = function(colorActive, colorDefault, rawList, maxSize)
      local currIdx = 1

      return {
         PickNext = function()
            if currIdx < #rawList then
               currIdx = currIdx + 1
            end
         end,

         PickPrev = function()
            if currIdx > 1 then
               currIdx = currIdx - 1
            end
         end,

         ToLines = function()
            local lines = {}
            local list, newCurrIdx = extendContext(rawList, currIdx, maxSize)

            for idx, v in ipairs(list) do
               if idx == newCurrIdx then
                  table.insert(lines, tty.PrintWithColor(colorActive, colorDefault, v.Value))
               else
                  table.insert(lines, tty.PrintWithColor(colorDefault, colorDefault, v.Value))
               end
            end

            return lines
         end,

         GetCurrent = function()
            return rawList[currIdx]
         end,
      }
   end,
}
