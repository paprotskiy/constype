local fs = require("app.io.fileSystem.file")
local cjson = require("cjson")
local storage = "/pers/topic.json"

return {
   Serialize = function(obj)
      local enc = cjson.encode(obj)
      fs.WriteFile(storage, enc)
   end,

   Deserialize = function()
      local lines = fs.ReadFileLines(storage)
      local line = table.concat(lines, "")
      if #line == 0 then
         return nil
      end
      return cjson.decode(line)
   end,
}
