package.path = package.path .. ";../../?.lua"
local luaterm = require("term")
local pp = require("utils.print.pretty")

local function clearScreen()
   luaterm.clear()
   luaterm.cursor.jump(1, 1)
   io.flush()
end

local function clearRestOfLine()
   luaterm.cleareol()
   io.flush()
end

return {
   ClearScreen = clearScreen,
   ClearLine = clearRestOfLine,

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

      if maxX == nil or maxY == nil or maxX <= 0 or maxY <= 0 then
         error(string.format('failed to parse "%s" to number pair', input))
      end

      return {
         MaxX = maxX,
         MaxY = maxY,
      }
   end,

   WinSize = function(self)
      for j = 1, 10, 1 do
         local file = assert(io.popen("stty size", "r"))
         local output = file:read("*all")

         local size = nil
         local _, err = pcall(function()
            size = self.ParseTtySizeOutput(output)
            io.flush()
         end)

         if err == nil and size ~= nil then
            return {
               MaxX = size.MaxX,
               MaxY = size.MaxY,
            }
         end
      end

      error("failed to get terminal's winsize")
   end,

   Mode = function(self, text)
      self.ClearScreen()

      os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
      while true do
         local whole = ""
         for i = 1, 20, 1 do
            local rune = io.read(1)
            whole = whole .. rune
            -- local char = string.byte()
            -- io.flush()
            -- self.WinSize()
            luaterm.cursor.goleft(1)
            io.write()
            io.flush()
         end
         io.write("\n" .. whole .. "++\n\n\n")
         -- io.flush()
      end
      os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
   end,

   NextWrittenChar = function()
      return {
         Char = string.byte(io.read(1)),
      }
   end,

   MoveCaret = function(coord)
      luaterm.cursor.jump(coord.X, coord.Y)
   end,
}
