local storage = require("app.storage.storage")
local modelExcercise = require("app.model.excercise")

local backspaceCode = 127
local enterCode = 10

return {
   __view = nil,
   __model = nil,

   New = function(self, topic, view, viewParser)
      self.__view = view
      self.__model = modelExcercise.New(topic)
      os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")

      return {
         Execute = function()
            -- todo move
            self.__view.ClearScreen()
            self.__view.PrintWithNoCursorShift(topic)
            io.flush()
            self.__view.Jump(1, 1)
            io.flush()
            -- todo move

            while not self.__model:Done() do
               local ch = self.__view.EventDriver()
               local byte = string.byte(ch)
               if byte == backspaceCode then
                  self.__model:Undo()
               else
                  self.__model:Overlay(ch)
               end

               -- self.__view.PrintWithNoCursorShift(self.__model.__data)
               -- io.flush()
            end

            -- serialize
         end,
      }
   end,
}
