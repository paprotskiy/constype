local fs = require("app.io.fileSystem.file")
local cjson = require("cjson")
local storage = "/pers/topic.json"

return {
   serialize = function(obj)
      local enc = cjson.encode(obj)
      fs.write_file(storage, enc)
   end,

   deserialize = function()
      local lines = fs.read_file_lines(storage)
      local line = table.concat(lines, "")
      if #line == 0 then
         return nil
      end
      return cjson.decode(line)
   end,
}
