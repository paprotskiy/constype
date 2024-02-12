package.path = package.path .. ";../../?.lua"
local bashtools = require("term.bashtools")
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

   WinSize = function()
      for j = 1, 10, 1 do
         local file = assert(io.popen("stty size", "r"))
         local output = file:read("*all")

         local size = nil
         local _, err = pcall(function()
            size = bashtools.ParseTtySizeOutput(output)
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
      luaterm.cursor.jump(1, 1)
      clearScreen()
      luaterm.cursor.jump(1, 1)
      -- io.write(text)
      luaterm.cursor.jump(1, 1)
      io.flush()

      while true do
         os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
         local char = string.byte(io.read(1))
         io.flush()
         luaterm.cursor.goleft(1)
         io.write(" ")
         io.flush()
         os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
      end
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
