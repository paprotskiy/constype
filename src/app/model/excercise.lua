local overlayableChar = require("app.lexic.char")
local topic = require("app.lexic.topic")
local charset = require("app.lexic.charset")

return {
   New = function(text)
      local wordSplitter = charset.SplitToWords

      return {
         __charedTopic = topic:New(text, wordSplitter),

         Done = function(self)
            local lastChar = self.__charedTopic:LastChar()
            return lastChar:CompareCharStatus(overlayableChar:Statuses().Nil)
         end,

         Command = function(symbol) end,
      }
   end,
}
