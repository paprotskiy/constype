package.path = package.path .. ";../../?.lua"
local core = require("tests.scaffold.scaffold")
local pp = require("src.print.pretty")

return {
   tests = {},

   Add = function(self, testFunc)
      local key = testFunc.name
      self.tests[key] = testFunc

      return self
   end,

   RunAll = function(self)
      print("run all tests:")

      local failed = {}
      for key, test in pairs(self.tests) do
         local res = test.exec()
         local err = core.GetTestErrMessage(res, true)
         if err ~= nil then
            table.insert(failed, {
               test_name = key,
               Error = err,
            })
         end
         print(res == nil, test.name)
      end

      if #failed > 0 then
         print("failed " .. tostring(#failed) .. " test(s):")
         print(pp.PrettyPrintTests(failed))
      end

      return self
   end,
}
