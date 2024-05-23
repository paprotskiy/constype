local equal = require("utils.equal.deepEqual")
local core = require("tests.scaffold.scaffold")
local AAA = require("tests.scaffold.AAA")
local subquery = require("utils.subquery")

return {

	core.NewTest("check subquery (table splitting by index)", function()
		return AAA.NewForSUT(subquery.SplitByIndex)
			:AssertSutWithParams({}, 1)
			:Equal({
				left = {},
				right = {},
			}, AAA.TableComparator)
			:AssertSutWithParams({ 1, 2, 3 }, 1)
			:Equal({
				left = {},
				right = { 1, 2, 3 },
			}, AAA.TableComparator)
			:AssertSutWithParams({ 1, 2, 3 }, 2)
			:Equal({
				left = { 1 },
				right = { 2, 3 },
			}, AAA.TableComparator)
			:AssertSutWithParams({ 1, 2, 3 }, 3)
			:Equal({
				left = { 1, 2 },
				right = { 3 },
			}, AAA.TableComparator)
			:AssertSutWithParams({ 1, 2, 3 }, 4)
			:Equal({
				left = { 1, 2, 3 },
				right = {},
			}, AAA.TableComparator)
			:AssertSutWithParams({ 1, 2, 3 }, 100)
			:Equal({
				left = { 1, 2, 3 },
				right = {},
			}, AAA.TableComparator)
			:Exec()
	end),

	core.NewTest("check table extending", function()
		return AAA.NewForSUT(subquery.JoinTables)
			:AssertSutWithParams({}, {})
			:Equal({}, AAA.TableComparator)
			:AssertSutWithParams({ 1, 2, 3 }, {})
			:Equal({ 1, 2, 3 }, AAA.TableComparator)
			:AssertSutWithParams({}, { 1, 2, 3 })
			:Equal({ 1, 2, 3 }, AAA.TableComparator)
			:AssertSutWithParams({ 1, 2 }, { 3, 4 })
			:Equal({ 1, 2, 3, 4 }, AAA.TableComparator)
			:AssertSutWithParams({ 1, "abc" }, { "abc", 2 })
			:Equal({ 1, "abc", "abc", 2 }, AAA.TableComparator)
			:AssertSutWithParams({ X = "main" }, { 1, 2 })
			:Equal({ 1, 2, X = "main" }, AAA.TableComparator)
			:AssertSutWithParams({ X = "main" }, { 1, 2 })
			:Equal({ 1, X = "main", 2 }, AAA.TableComparator)
			:AssertSutWithParams({
				X = "main1",
				Y = "main2",
			}, {
				XAUX = "aux1",
				Y = "aux2",
			})
			:Equal({
				X = "main1",
				Y = "main2",
				XAUX = "aux1",
			}, AAA.TableComparator)
			:Exec()
	end),

	core.NewTest("check deepEqual function", function()
		return AAA
			.NewForSUT(equal.DeepEqualIgnoreFuncs)
			:AssertSutWithParams(nil, nil)
			:Equal(nil)
			:AssertSutWithParams("a", "a")
			:Equal(nil)
			:AssertSutWithParams(true, true)
			:Equal(nil)
			:AssertSutWithParams(1, 1)
			:Equal(nil)
			:AssertSutWithParams(1, "1")
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(1.2, 1.20)
			:Equal(nil)
			:AssertSutWithParams(1, 1.0)
			:Equal(nil)
			:AssertSutWithParams(false, 0)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(false, "false")
			:Equal("(nested) types mismatch")
			:AssertSutWithParams({}, nil)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams("", nil)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(0, nil)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(false, nil)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(nil, function() end)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(function() end, nil)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(function() end, {})
			:Equal("(nested) types mismatch")
			:AssertSutWithParams({}, function() end)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams({}, {})
			:Equal(nil)
			:AssertSutWithParams({ 1 }, { 1 })
			:Equal(nil)
			:AssertSutWithParams({ 1 }, { "1" })
			:Equal("[1]:(nested) types mismatch")
			:AssertSutWithParams({ 1 }, 1)
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(
				{ "q", 1 }, --
				{ 1, "q" }
			)
			:Equal("[1]:(nested) types mismatch")
			:AssertSutWithParams(
				{ Two = "q", One = 1 }, --
				{ One = 1, Two = "q" }
			)
			:Equal(nil)
			:AssertSutWithParams(
				{ One = 1, Two = "q", Three = true }, --
				{ One = 1, Two = "q" }
			)
			:Equal('table sizes ("3" and "2") mismatch')
			:AssertSutWithParams(
				{ One = 1, Two = "q" }, --
				{ One = 1, Two = "q", Three = true }
			)
			:Equal('table sizes ("2" and "3") mismatch')
			:AssertSutWithParams(
				{ One = 1, Two = "q", Three = function() end }, --
				{ One = 1, Two = "q" }
			)
			:Equal(nil)
			:AssertSutWithParams(
				{ One = 1, Two = "q" }, --
				{ One = 1, Two = "q", Three = function() end }
			)
			:Equal(nil)
			:AssertSutWithParams(
				{ One = 1, Two = "q" }, --
				{ Three = function() end, One = 1, Two = "q" }
			)
			:Equal(nil)
			-- todo buggy behavior on next 3 tests!!
			:AssertSutWithParams(
				{ Val = " ", { 1, { 2, function() end } } }, --
				{ Val = " ", { 1, { 2 } } }
			)
			:Equal(nil) -- !!! todo fix
			:AssertSutWithParams(
				{ Val = " ", { 1, { 2 } } }, --
				{ Val = " ", { 1, { 2, function() end } } }
			)
			:Equal(nil) -- !!! todo fix
			:AssertSutWithParams(
				{ Val = " ", { 1, { 2 } } }, --
				{ Val = " ", { 1, { function() end, 2 } } }
			)
			:Equal("[1]:[2]:[1]:(nested) types mismatch")
			:AssertSutWithParams(
				{ 1, "q", "!", " ", nil, "a" }, -- todo buddy
				{ 1, "q", "!", " ", function() end, "a" } -- todo buggy
			)
			:Equal(nil)
			-- todo buggy behavior on previous 3 tests!!
			:AssertSutWithParams(
				{ 1, "q", " ", { 1, "\n", { 1, 2, "a" } }, "!" }, --
				{ 1, "q", " ", { 1, "\n", { 1, 2, "a" } }, "!" }
			)
			:Equal(nil)
			:AssertSutWithParams(
				{ 1, "q", "!", " ", { 1, "\n", { 1, 2, "a" } } }, --
				{ 1, "q", "!", { 1, "\n", { 1, 2, "a" } }, " " }
			)
			:Equal("[4]:(nested) types mismatch")
			:AssertSutWithParams(
				{ 1, 2, "!", " ", "a" }, --
				{ 1, "q", "!", " ", "a" }
			)
			:Equal("[2]:(nested) types mismatch")
			:Exec()
	end),
}
