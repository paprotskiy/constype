local overChar = require("char")

return {
   TokenTypes = {
      Word = "word",
      Separator = "separator",
      Utility = "utility",
   },

   __newToken = function(type, chars)
      return {
         __overlayedChars = chars,
         __type = type,

         Length = function(self)
            return #self.__overlayedChars
         end,

         Chars = function(self)
            return self.__overlayedChars
         end,
      }
   end,

   NewWord = function(self, word)
      local buf = {}
      for i = 1, #word do
         local ch = word:sub(i, i)
         table.insert(buf, overChar.New(ch))
      end

      if #buf == 0 then
         error("empty words are not allowed")
      end

      return self.newToken(self.TokenTypes.Word, buf)
   end,

   NewSeparator = function(self, symbol)
      return self.newToken(self.TokenTypes.Separator, {
         overChar.New(symbol),
      })
   end,
}
