local equal = require("utils.equal.deepEqual")
local core = require("tests.scaffold.scaffold")
local AAA = require("tests.scaffold.AAA")
local subquery = require("utils.subquery")

return {

	core.NewTest(
		"check subquery (table splitting by index)",
		AAA.NewForSUT(subquery.SplitByIndex)
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
		:Build()
	),

	core.NewTest(
		"check deepEqual function",
		AAA
		.NewForSUT(equal.DeepEqualIgnoreFuncs)
		-- :AssertSutWithParams(nil, nil)
		-- :Equal(nil)
		-- :AssertSutWithParams("a", "a")
		-- :Equal(nil)
		-- :AssertSutWithParams(true, true)
		-- :Equal(nil)
		-- :AssertSutWithParams(1, 1)
		-- :Equal(nil)
		-- :AssertSutWithParams(1.2, 1.20)
		-- :Equal(nil)
		-- :AssertSutWithParams(1, 1.0)
		-- :Equal(nil)
		-- :AssertSutWithParams(false, 0)
		-- :Equal("(nested) types mismatch")
		-- :AssertSutWithParams(false, "false")
		-- :Equal("(nested) types mismatch")
		-- :AssertSutWithParams({}, nil)
		-- :Equal("(nested) types mismatch")
		-- :AssertSutWithParams("", nil)
		-- :Equal("(nested) types mismatch")
		-- :AssertSutWithParams(0, nil)
		-- :Equal("(nested) types mismatch")
		-- :AssertSutWithParams(false, nil)
		-- :Equal("(nested) types mismatch")
		--
		-- todo func comparison vs nested func comparison?
		:AssertSutWithParams(
			nil,
			function() end
		)
		:Equal(nil)
		:AssertSutWithParams(function() end, nil)
		:Equal(nil)
		-- todo func comparison vs nested func comparison?
		--
		:AssertSutWithParams(function() end, {})
		:Equal("(nested) types mismatch")
		:AssertSutWithParams({}, function() end)
		:Equal("(nested) types mismatch")
		:AssertSutWithParams({}, nil)
		:Equal("(nested) types mismatch")
		:AssertSutWithParams({}, {})
		:Equal(nil)
		:AssertSutWithParams({ 1 }, { 1 })
		:Equal(nil)
		:AssertSutWithParams({ 1 }, { "1" })
		:Equal("(nested) types mismatch")
		:AssertSutWithParams({ 1 }, 1)
		:Equal("(nested) types mismatch")
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
		:Equal(nil)                -- !!! todo fix
		:AssertSutWithParams(
			{ Val = " ", { 1, { 2 } } }, --
			{ Val = " ", { 1, { 2, function() end } } }
		)
		:Equal(nil)                -- !!! todo fix
		:AssertSutWithParams(
			{ Val = " ", { 1, { 2 } } }, --
			{ Val = " ", { 1, { function() end, 2 } } }
		)
		:Equal("(nested) types mismatch") -- !!! todo fix
		-- todo buggy behavior on previous 3 tests!!
		:AssertSutWithParams(
			{ 1, "q", " ", { 1, "\n", { 1, 2, "a" } }, "!" }, --
			{ 1, "q", " ", { 1, "\n", { 1, 2, "a" } }, "!" }
		)
		:Equal(nil)
		:AssertSutWithParams(
			{ 1, "q", "!", " ", { 1, "\n", { 1, 2, "a" } } }, --
			{ 1, "q", "!", " ", { 1, "\n", { 2, 1, "a" } } }
		)
		:Equal('(nested) values mismatch: "1" and "2"') -- todo more specifics needed
		:AssertSutWithParams(
			{ 1, "q", "!", " ", { 1, "\n", { 1, 2, "a" } } }, --
			{ 1, "q", "!", { 1, "\n", { 1, 2, "a" } }, " " }
		)
		:Equal("(nested) types mismatch")       -- todo more specifics needed
		:AssertSutWithParams(
			{ 1, "q", "!", " ", nil, "a" },      -- todo buddy
			{ 1, "q", "!", " ", function() end, "a" } -- todo buggy
		)
		:Equal(nil)
		:AssertSutWithParams(
			{ 1, 2, "!", " ", "a" }, --
			{ 1, "q", "!", " ", "a" }
		)
		:Equal("(nested) types mismatch")
		:Build()
	),
}
