local function divide(dividend, divisor)
   local quotient = dividend // divisor
   local remainder = dividend % divisor

   return quotient, remainder
end

return {
   new = function(ms)
      return {
         __ms = ms,

         add = function(self, addition)
            self.__ms = self.__ms + addition:milliseconds()
            return self
         end,

         milliseconds = function(self)
            return divide(self.__ms, 1)
         end,

         seconds = function(self)
            return divide(self.__ms, 1000)
         end,

         minutes = function(self)
            return divide(self.__ms, 1000 * 60)
         end,

         hours = function(self)
            return divide(self.__ms, 1000 * 60 * 60)
         end,
      }
   end,
}
