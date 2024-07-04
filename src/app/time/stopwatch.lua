local socket = require("socket")
local period = require("app.time.period")

-- todo threadsafe welcomed
return {
   new = function()
      return {
         __currTime = nil,

         click_stop_watch = function(self)
            local curr = socket.gettime() * 1000

            local res = 0
            if self.__currTime ~= nil then
               res = curr - self.__currTime
            end

            self.__currTime = curr
            return period.new(res)
         end,
      }
   end,
}
