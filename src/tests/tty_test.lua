local equal = require("utils.equal.deepEqual")
local core = require("tests.scaffold.scaffold")
local AAA = require("tests.scaffold.AAA")
local tty = require("app.ui.tty.tty")

return {
	core.newTest(
		'check "tty size" command output parsing',
		AAA.newForSUT(tty.parse_tty_size_output)
		:AssertSutWithParams("1 2")
		:Equal({
			max_x = 2,
			max_y = 1,
		}, AAA.TableComparator)
		:AssertSutWithParams(" 1   2 ")
		:Equal({
			max_x = 2,
			max_y = 1,
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
