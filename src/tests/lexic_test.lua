package.path = package.path .. ";../?.lua"
local core = require("tests.scaffold.scaffold")
local equal = require("utils.equal.deepEqual")
local AAA = require("tests.scaffold.AAA")
local char = require("app.domain.lexic.char")
local charset = require("app.domain.lexic.charset")
local lines = require("app.domain.lexic.lines")

local charstatuses = {
	null = char.statuses().null,
	succ = char.statuses().succ,
	fail = char.statuses().fail,
	fixed = char.statuses().fixed,
}

local function overlayable_charComparator(expectedOutput, expectedErr, actualOutput, actualErr)
	if actualErr ~= nil then
		return core.newTestErr("error not expected, but got " .. actualErr)
	end

	local ignoredFields = {
		"__ok_overlaying_time",
		"__bad_overlaying_time",
	}
	local errMsg = equal.DeepEqualIgnoreFuncsAndFields(expectedOutput, actualOutput, table.unpack(ignoredFields))

	if errMsg == nil then
		return nil
	end

	return core.newTestErr(errMsg)
end

return {
	core.newTest("check all statuses copied successfully", function()
		local sut = char.statuses

		local actual = sut()

		if actual.null ~= "not-overlayed" then
			return core.newTestErr("nil type not found")
		end
		if actual.succ ~= "successfully-overlayed" then
			return core.newTestErr("succ type not found")
		end
		if actual.fail ~= "failed-to-overlay" then
			return core.newTestErr("fail type not found")
		end
		if actual.fixed ~= "overlay-fixed" then
			return core.newTestErr("fixed type not found")
		end

		return nil
	end),

	core.newTest(
		"check status comparation",
		AAA.newForSUT(char.compare_statuses)
		:AssertSutWithParams(charstatuses.null, charstatuses.null)
		:Equal(true)
		:AssertSutWithParams(charstatuses.succ, charstatuses.succ)
		:Equal(true)
		:AssertSutWithParams(charstatuses.fail, charstatuses.fail)
		:Equal(true)
		:AssertSutWithParams(charstatuses.fixed, charstatuses.fixed)
		:Equal(true)
		:AssertSutWithParams(charstatuses.null, charstatuses.succ)
		:Equal(false)
		:AssertSutWithParams(charstatuses.succ, charstatuses.fail)
		:Equal(false)
		:AssertSutWithParams(charstatuses.fail, charstatuses.fixed)
		:Equal(false)
		:AssertSutWithParams(charstatuses.null, "not-overlayed")
		:Equal(true)
		:AssertSutWithParams(charstatuses.null, "non-existing-status")
		:ThrowsError()
		:AssertSutWithParams("non-existing-status", charstatuses.null)
		:ThrowsError()
		:AssertSutWithParams("non-existing-status1", "non-existing-status2")
		:ThrowsError()
		:Build()
	),

	core.newTest("check char's status comparation", function()
		local sut = char.compare_char_status

		local sets = {
			{
				char = char.new("x"),
				status = charstatuses.null,
				values_are_the_same = true,
			},
		}

		for idx, set in pairs(sets) do
			local compareRes = sut(char, set.char, set.status)
			if compareRes ~= set.values_are_the_same then
				return core.newTestErr("wrong output: expected")
			end
		end

		return nil
	end),

	-- standard test pattern: AAA (Arrange Act Assert)
	core.newTest("check statuses check after overlays", function()
		local sut = char.new("x") -- sut = SystemUnderTest
		local sets = {
			{
				overlay = "x", -- error -- x
				pre_status = charstatuses.null,
				post_status = charstatuses.succ,
			},
			{
				overlay = "y",
				pre_status = charstatuses.succ,
				post_status = charstatuses.fail,
			},
			{
				overlay = "x",
				pre_status = charstatuses.fail,
				post_status = charstatuses.fixed,
			},
			{
				overlay = "x",
				pre_status = charstatuses.fixed,
				post_status = charstatuses.fixed,
			},
			{
				overlay = nil,
				pre_status = charstatuses.fixed,
				post_status = charstatuses.fail,
			},
			{
				overlay = "x",
				pre_status = charstatuses.fail,
				post_status = charstatuses.fixed,
			},
		}

		for idx, set in pairs(sets) do
			if not char:compare_char_status(sut, set.pre_status) then
				return core.newTestErr("pre_status wrong for checkup #" .. tostring(idx))
			end

			char.overlay(sut, set.overlay)

			if not char:compare_char_status(sut, set.post_status) then
				return core.newTestErr("pre_status wrong for checkup #" .. tostring(idx))
			end
		end

		return nil
	end),

	core.newTest("check char values depending on it's status", function()
		local sets = {
			{
				char = char.new("x"),
				output_value = "x",
				values_are_the_same = true,
			},
			{
				char = char.new("y"),
				output_value = "y",
				values_are_the_same = true,
			},
			{
				char = char.new("y"),
				output_value = "x",
				values_are_the_same = false,
			},
			{
				char = char.new("x"),
				output_value = "y",
				values_are_the_same = false,
			},
		}

		for idx, set in pairs(sets) do
			local compareRes = char.display(set.char).value == set.output_value

			if set.values_are_the_same ~= compareRes then
				return core.newTestErr("pre_status wrong for checkup #" .. tostring(idx))
			end
		end
	end),

	core.newTest(
		"check test parsing to char sequence",
		AAA
		.newForSUT(charset.new_charset)
		:AssertSutWithParams("a bB\nc") --
		:Equal({
			{ __base = "a",  __overlay_status = charstatuses.null },
			{ __base = " ",  __overlay_status = charstatuses.null },
			{ __base = "b",  __overlay_status = charstatuses.null },
			{ __base = "B",  __overlay_status = charstatuses.null },
			{ __base = "\n", __overlay_status = charstatuses.null },
			{
				__base = "c",
				__overlay_status = charstatuses.null,
			},
		}, overlayable_charComparator)
		:Build()
	),

	core.newTest(
		"split chared text to words",
		AAA
		.newForSUT(charset.split_to_words)
		:AssertSutWithParams(charset.new_charset(""))
		:Equal({}, AAA.TableComparator)
		:AssertSutWithParams(charset.new_charset("word word2,.!"))
		:Equal({
			{
				{ __base = "w", __overlay_status = charstatuses.null },
				{ __base = "o", __overlay_status = charstatuses.null },
				{ __base = "r", __overlay_status = charstatuses.null },
				{ __base = "d", __overlay_status = charstatuses.null },
			},
			{
				{ __base = " ", __overlay_status = charstatuses.null },
			},
			{
				{ __base = "w", __overlay_status = charstatuses.null },
				{ __base = "o", __overlay_status = charstatuses.null },
				{ __base = "r", __overlay_status = charstatuses.null },
				{ __base = "d", __overlay_status = charstatuses.null },
				{ __base = "2", __overlay_status = charstatuses.null },
				{ __base = ",", __overlay_status = charstatuses.null },
				{ __base = ".", __overlay_status = charstatuses.null },
			},
			{
				{ __base = "!", __overlay_status = charstatuses.null },
			},
		}, overlayable_charComparator)
		:AssertSutWithParams(charset.new_charset(" 234\n 098!")) --
		:Equal({
			{
				{ __base = " ", __overlay_status = charstatuses.null },
			},
			{
				{ __base = "2", __overlay_status = charstatuses.null },
				{ __base = "3", __overlay_status = charstatuses.null },
				{ __base = "4", __overlay_status = charstatuses.null },
			},
			{
				{ __base = "\n", __overlay_status = charstatuses.null },
			},
			{
				{ __base = " ", __overlay_status = charstatuses.null },
			},
			{
				{ __base = "0", __overlay_status = charstatuses.null },
				{ __base = "9", __overlay_status = charstatuses.null },
				{ __base = "8", __overlay_status = charstatuses.null },
			},
			{
				{ __base = "!", __overlay_status = charstatuses.null },
			},
		}, overlayable_charComparator)
		:Build()
	),

	core.newTest("build new line", function()
		local line = lines.newLine()
		local sut = function(additionalWord)
			for _, v in pairs(additionalWord) do
				line:append(v)
			end
			return line
		end

		return AAA.newForSUT(sut)
			 :AssertSutWithParams(charset.new_charset("hello"))
			 :Equal({
				 __chars = {
					 { __base = "h", __overlay_status = charstatuses.null },
					 { __base = "e", __overlay_status = charstatuses.null },
					 { __base = "l", __overlay_status = charstatuses.null },
					 { __base = "l", __overlay_status = charstatuses.null },
					 { __base = "o", __overlay_status = charstatuses.null },
				 },
			 }, overlayable_charComparator)
			 :Exec()
	end),

	core.newTest("split to lines", function()
		local buildWordLine = function(text)
			local line = lines.newLine()
			for letter in text:gmatch(".") do
				line:append(char.new(letter))
			end
			return line
		end

		return AAA.newForSUT(lines.resize_lines)
			 :AssertSutWithParams(25, charset.split_to_words, lines.newLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split to lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(5, charset.split_to_words, lines.newLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split"),
				 buildWordLine(" to "),
				 buildWordLine("lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(6, charset.split_to_words, lines.newLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split "),
				 buildWordLine("to "),
				 buildWordLine("lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(1, charset.split_to_words, lines.newLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split"),
				 buildWordLine(" "),
				 buildWordLine("to"),
				 buildWordLine(" "),
				 buildWordLine("lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(0, charset.split_to_words, lines.newLine, {
				 buildWordLine("split to lines"),
			 })
			 :ThrowsError()
			 :Exec()
	end),
}
