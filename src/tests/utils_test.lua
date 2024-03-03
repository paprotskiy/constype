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
		AAA.NewForSUT(equal.DeepEqualIgnoreFuncs)
			:AssertSutWithParams(nil, nil)
			:Equal(nil)			
			:AssertSutWithParams(
				{1, "q", "!", " ", {1, "\n", {1, 2, "a"}}},
				{1, "q", "!", " ", {1, "\n", {1, 2, "a"}}})
			:Equal(nil)
			:AssertSutWithParams(
				{1, "q", "!", " ", {1, ",", {1, 2, "a", function ()	end}}},
				{1, "q", "!", " ", {1, ",", {1, 2, "a"}}})
			:Equal(nil)
			:AssertSutWithParams(
				{1, "q", "!", " ", function ()	end},
				{1, "q", "!", " "})
			:Equal(nil)
			:AssertSutWithParams(
				{1, "q", "!", " "},
				{1, "q", "!", " ", function ()	end})
			:Equal(nil)
			:AssertSutWithParams(
				{1, "q", "!", " ", nil, "a"},
				{1, "q", "!", " ", function ()	end, "a"})
			:Equal(nil)
			:AssertSutWithParams(
				nil,
				{1, "q", "!", " ", {1, "\n", {1, 2, "a"}}})
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(
				{1, "q", "!", " ", nil, "a"},
				{1, "q", "!", " ", "a", nil})
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(
				{1, "q", "!", " ", function() end, "a"},
				{1, "q", "!", " ", "a",            nil})
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(
				{true, "q", "!", " ", "a"},
				{1, "q", "!", " ", "a"})
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(
				{{1}, "q", "!", " ", "a"},
				{ 1,  "q", "!", " ", "a"})
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(
				{1,  2 , "!", " ", "a"},
				{1, "q", "!", " ", "a"})
			:Equal("(nested) types mismatch")
			:AssertSutWithParams(
				{1, "q", "!", " ", nil, "a"},
				{1, "q", "!", " ", function ()	end})
			:Equal('table sizes ("5" and "4") mismatch')
			:AssertSutWithParams(
				{{function() end}, "q", "!", " ", "a"},
				{ function() end,  "q", "!", " ", "a"})
			:Equal('table sizes ("5" and "4") mismatch')
			:AssertSutWithParams(
				{1, "Q", "!", " ", nil, "a"},
				{1, "q", "!", " ", function ()	end, "a"})
			:Equal('(nested) values mismatch: "Q" and "q"')			
			:Build()
	),
}
