return function(expr, message, level)
   if expr then
      return
   end

   if type(level) == "number" then
      error(message, level)
   end

   error(message)
end
