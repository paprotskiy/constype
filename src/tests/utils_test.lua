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
}
