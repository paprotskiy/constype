local equal = require("utils.equal.deepEqual")
local core = require("tests.scaffold.scaffold")
local AAA = require("tests.scaffold.AAA")
local tty = require("app.ui.tty.tty")

local function tableComparator(expectedOutput, expectedErr, actualOutput, actualErr)
   if actualErr ~= nil then
      return core.NewTestErr("error not expected, but got " .. actualErr)
   end

   local errMsg = equal.DeepEqualIgnoreFuncs(expectedOutput, actualOutput)

   if errMsg == nil then
      return nil
   end

   return core.NewTestErr(errMsg)
end

return {
   TtySizeOutputParsing = core.NewTest(
      'check "tty size" command output parsing',
      AAA.NewForSUT(tty.ParseTtySizeOutput)
      :AssertSutWithParams("1 2")
      :Equal({
         MaxX = 1,
         MaxY = 2,
      }, tableComparator)
      :AssertSutWithParams(" 1   2 ")
      :Equal({
         MaxX = 1,
         MaxY = 2,
      }, tableComparator)
      :AssertSutWithParams("")
      :ThrowsError()
      :AssertSutWithParams("0 1")
      :ThrowsError()
      :AssertSutWithParams("1 0")
      :ThrowsError()
      :AssertSutWithParams("-5 2")
      :ThrowsError()
      :AssertSutWithParams("5 -2")
      :ThrowsError()
      :Build()
   ),
}
