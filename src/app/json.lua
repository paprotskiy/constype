local cjson = require("cjson")
local text = '{"a":1.34,"b":1.34}'
local enc = cjson.encode({
   ["a"] = 1.34,
   ["b"] = 1.34,
})
print(enc)
local obj = cjson.decode(text)
print(obj)
