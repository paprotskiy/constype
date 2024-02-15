local equal = require("utils.equal.deepEqual")
local core = require("tests.scaffold.scaffold")
local AAA = require("tests.scaffold.AAA")
local tty = require("app.ui.tty.tty")

return {
	core.NewTest(
		'check "tty size" command output parsing',
		AAA.NewForSUT(tty.ParseTtySizeOutput)
			:AssertSutWithParams("1 2")
			:Equal({
				MaxX = 1,
				MaxY = 2,
			}, AAA.TableComparator)
			:AssertSutWithParams(" 1   2 ")
			:Equal({
				MaxX = 1,
				MaxY = 2,
			}, AAA.TableComparator)
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
