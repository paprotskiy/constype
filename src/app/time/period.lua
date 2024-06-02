local function divide(dividend, divisor)
   local quotient = dividend // divisor
   local remainder = dividend % divisor

   return quotient, remainder
end

return {
   New = function(ms)
      return {
         __ms = ms,

         Add = function(self, addition)
            self.__ms = self.__ms + addition:Milliseconds()
            return self
         end,

         Milliseconds = function(self)
            return divide(self.__ms, 1)
         end,

         Seconds = function(self)
            return divide(self.__ms, 1000)
         end,

         Minutes = function(self)
            return divide(self.__ms, 1000 * 60)
         end,

         Hours = function(self)
            return divide(self.__ms, 1000 * 60 * 60)
         end,
      }
   end,
}
