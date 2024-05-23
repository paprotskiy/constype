local customAssert = require("utils.assert")

local errs = {}
local function readEnv(key)
   local val = os.getenv(key)
   if #val == 0 then
      table.insert(errs, 'env "' .. key .. '" not found')
      return nil
   end

   return val
end

local function fillEnvs()
   local config = {
      TerminalColors = {
         Default = readEnv("COLOR_DEFAULT_IDX"),
         Succ = readEnv("COLOR_SUCC_IDX"),
         Fail = readEnv("COLOR_FAIL_IDX"),
         Fixed = readEnv("COLOR_FIXED_IDX"),
      },
   }

   customAssert(#errs == 0, table.concat(errs, "\n"))
   return config
end

return fillEnvs()
