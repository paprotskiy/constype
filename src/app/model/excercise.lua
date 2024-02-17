local topic = require("app.lexic.topic")

return {
   New = function(text)
      return topic.NewTopic(text)
      -- local topic = topic.NewTopic(text)
      -- return {
      --    Undo
      -- }
   end,
}
