package.path = package.path .. ";../?.lua"
local core = require("tests.scaffold.scaffold")
local equal = require("utils.equal.deepEqual")
local AAA = require("tests.scaffold.AAA")
local char = require("app.domain.lexic.char")
local charset = require("app.domain.lexic.charset")
local lines = require("app.domain.lexic.lines")

local charStatuses = {
	Nil = char.Statuses().Nil,
	Succ = char.Statuses().Succ,
	Fail = char.Statuses().Fail,
	Fixed = char.Statuses().Fixed,
}

local function overlayableCharComparator(expectedOutput, expectedErr, actualOutput, actualErr)
	if actualErr ~= nil then
		return core.NewTestErr("error not expected, but got " .. actualErr)
	end

	local ignoredFields = {
		"__okOverlayingTime",
		"__badOverlayingTime",
	}
	local errMsg = equal.DeepEqualIgnoreFuncsAndFields(expectedOutput, actualOutput, table.unpack(ignoredFields))

	if errMsg == nil then
		return nil
	end

	return core.NewTestErr(errMsg)
end

return {
	core.NewTest("check all statuses copied successfully", function()
		local sut = char.Statuses

		local actual = sut()

		if actual.Nil ~= "not-overlayed" then
			return core.NewTestErr("nil type not found")
		end
		if actual.Succ ~= "successfully-overlayed" then
			return core.NewTestErr("Succ type not found")
		end
		if actual.Fail ~= "failed-to-overlay" then
			return core.NewTestErr("Fail type not found")
		end
		if actual.Fixed ~= "overlay-fixed" then
			return core.NewTestErr("Fixed type not found")
		end

		return nil
	end),

	core.NewTest(
		"check status comparation",
		AAA.NewForSUT(char.CompareStatuses)
		:AssertSutWithParams(charStatuses.Nil, charStatuses.Nil)
		:Equal(true)
		:AssertSutWithParams(charStatuses.Succ, charStatuses.Succ)
		:Equal(true)
		:AssertSutWithParams(charStatuses.Fail, charStatuses.Fail)
		:Equal(true)
		:AssertSutWithParams(charStatuses.Fixed, charStatuses.Fixed)
		:Equal(true)
		:AssertSutWithParams(charStatuses.Nil, charStatuses.Succ)
		:Equal(false)
		:AssertSutWithParams(charStatuses.Succ, charStatuses.Fail)
		:Equal(false)
		:AssertSutWithParams(charStatuses.Fail, charStatuses.Fixed)
		:Equal(false)
		:AssertSutWithParams(charStatuses.Nil, "not-overlayed")
		:Equal(true)
		:AssertSutWithParams(charStatuses.Nil, "non-existing-status")
		:ThrowsError()
		:AssertSutWithParams("non-existing-status", charStatuses.Nil)
		:ThrowsError()
		:AssertSutWithParams("non-existing-status1", "non-existing-status2")
		:ThrowsError()
		:Build()
	),

	core.NewTest("check char's status comparation", function()
		local sut = char.CompareCharStatus

		local sets = {
			{
				Char = char.New("x"),
				Status = charStatuses.Nil,
				ValuesAreTheSame = true,
			},
		}

		for idx, set in pairs(sets) do
			local compareRes = sut(char, set.Char, set.Status)
			if compareRes ~= set.ValuesAreTheSame then
				return core.NewTestErr("wrong output: expected")
			end
		end

		return nil
	end),

	-- standard test pattern: AAA (Arrange Act Assert)
	core.NewTest("check statuses check after overlays", function()
		local sut = char.New("x") -- sut = SystemUnderTest
		local sets = {
			{
				Overlay = "x", -- error -- x
				PreStatus = charStatuses.Nil,
				PostStatus = charStatuses.Succ,
			},
			{
				Overlay = "y",
				PreStatus = charStatuses.Succ,
				PostStatus = charStatuses.Fail,
			},
			{
				Overlay = "x",
				PreStatus = charStatuses.Fail,
				PostStatus = charStatuses.Fixed,
			},
			{
				Overlay = "x",
				PreStatus = charStatuses.Fixed,
				PostStatus = charStatuses.Fixed,
			},
			{
				Overlay = nil,
				PreStatus = charStatuses.Fixed,
				PostStatus = charStatuses.Fail,
			},
			{
				Overlay = "x",
				PreStatus = charStatuses.Fail,
				PostStatus = charStatuses.Fixed,
			},
		}

		for idx, set in pairs(sets) do
			if not char:CompareCharStatus(sut, set.PreStatus) then
				return core.NewTestErr("PreStatus wrong for checkup #" .. tostring(idx))
			end

			char.Overlay(sut, set.Overlay)

			if not char:CompareCharStatus(sut, set.PostStatus) then
				return core.NewTestErr("PreStatus wrong for checkup #" .. tostring(idx))
			end
		end

		return nil
	end),

	core.NewTest("check char values depending on it's status", function()
		local sets = {
			{
				Char = char.New("x"),
				OutputValue = "x",
				ValuesAreTheSame = true,
			},
			{
				Char = char.New("y"),
				OutputValue = "y",
				ValuesAreTheSame = true,
			},
			{
				Char = char.New("y"),
				OutputValue = "x",
				ValuesAreTheSame = false,
			},
			{
				Char = char.New("x"),
				OutputValue = "y",
				ValuesAreTheSame = false,
			},
		}

		for idx, set in pairs(sets) do
			local compareRes = char.Display(set.Char).Value == set.OutputValue

			if set.ValuesAreTheSame ~= compareRes then
				return core.NewTestErr("PreStatus wrong for checkup #" .. tostring(idx))
			end
		end
	end),

	core.NewTest(
		"check test parsing to char sequence",
		AAA
		.NewForSUT(charset.NewCharset)
		:AssertSutWithParams("a bB\nc") --
		:Equal({
			{ __base = "a",  __overlayStatus = charStatuses.Nil },
			{ __base = " ",  __overlayStatus = charStatuses.Nil },
			{ __base = "b",  __overlayStatus = charStatuses.Nil },
			{ __base = "B",  __overlayStatus = charStatuses.Nil },
			{ __base = "\n", __overlayStatus = charStatuses.Nil },
			{
				__base = "c",
				__overlayStatus = charStatuses.Nil,
			},
		}, overlayableCharComparator)
		:Build()
	),

	core.NewTest(
		"split chared text to words",
		AAA
		.NewForSUT(charset.SplitToWords)
		:AssertSutWithParams(charset.NewCharset(""))
		:Equal({}, AAA.TableComparator)
		:AssertSutWithParams(charset.NewCharset("word word2,.!"))
		:Equal({
			{
				{ __base = "w", __overlayStatus = charStatuses.Nil },
				{ __base = "o", __overlayStatus = charStatuses.Nil },
				{ __base = "r", __overlayStatus = charStatuses.Nil },
				{ __base = "d", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = " ", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = "w", __overlayStatus = charStatuses.Nil },
				{ __base = "o", __overlayStatus = charStatuses.Nil },
				{ __base = "r", __overlayStatus = charStatuses.Nil },
				{ __base = "d", __overlayStatus = charStatuses.Nil },
				{ __base = "2", __overlayStatus = charStatuses.Nil },
				{ __base = ",", __overlayStatus = charStatuses.Nil },
				{ __base = ".", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = "!", __overlayStatus = charStatuses.Nil },
			},
		}, overlayableCharComparator)
		:AssertSutWithParams(charset.NewCharset(" 234\n 098!")) --
		:Equal({
			{
				{ __base = " ", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = "2", __overlayStatus = charStatuses.Nil },
				{ __base = "3", __overlayStatus = charStatuses.Nil },
				{ __base = "4", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = "\n", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = " ", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = "0", __overlayStatus = charStatuses.Nil },
				{ __base = "9", __overlayStatus = charStatuses.Nil },
				{ __base = "8", __overlayStatus = charStatuses.Nil },
			},
			{
				{ __base = "!", __overlayStatus = charStatuses.Nil },
			},
		}, overlayableCharComparator)
		:Build()
	),

	core.NewTest("build new line", function()
		local line = lines.NewLine()
		local sut = function(additionalWord)
			for _, v in pairs(additionalWord) do
				line:Append(v)
			end
			return line
		end

		return AAA.NewForSUT(sut)
			 :AssertSutWithParams(charset.NewCharset("hello"))
			 :Equal({
				 __chars = {
					 { __base = "h", __overlayStatus = charStatuses.Nil },
					 { __base = "e", __overlayStatus = charStatuses.Nil },
					 { __base = "l", __overlayStatus = charStatuses.Nil },
					 { __base = "l", __overlayStatus = charStatuses.Nil },
					 { __base = "o", __overlayStatus = charStatuses.Nil },
				 },
			 }, overlayableCharComparator)
			 :Exec()
	end),

	core.NewTest("split to lines", function()
		local buildWordLine = function(text)
			local line = lines.NewLine()
			for letter in text:gmatch(".") do
				line:Append(char.New(letter))
			end
			return line
		end

		return AAA.NewForSUT(lines.ResizeLines)
			 :AssertSutWithParams(25, charset.SplitToWords, lines.NewLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split to lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(5, charset.SplitToWords, lines.NewLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split"),
				 buildWordLine(" to "),
				 buildWordLine("lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(6, charset.SplitToWords, lines.NewLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split "),
				 buildWordLine("to "),
				 buildWordLine("lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(1, charset.SplitToWords, lines.NewLine, {
				 buildWordLine("split to lines"),
			 })
			 :Equal({
				 buildWordLine("split"),
				 buildWordLine(" "),
				 buildWordLine("to"),
				 buildWordLine(" "),
				 buildWordLine("lines"),
			 }, AAA.TableComparator)
			 :AssertSutWithParams(0, charset.SplitToWords, lines.NewLine, {
				 buildWordLine("split to lines"),
			 })
			 :ThrowsError()
			 :Exec()
	end),
}
