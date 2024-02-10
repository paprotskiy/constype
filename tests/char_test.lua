local core = require("tests.scaffold.scaffold")
local AAA = require("tests.scaffold.AAA")
local char = require("src.lexic.char")

local charStatuses = {
	Nil = char.Statuses().Nil,
	Succ = char.Statuses().Succ,
	Fail = char.Statuses().Fail,
	Fixed = char.Statuses().Fixed,
}

return {
	Statuses = core.NewTest("check all statuses copied successfully", function()
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

	StatusComparation = core.NewTest("check status comparation", function()
		local sut = char.CompareStatuses

		local sets = {
			{
				Status1 = charStatuses.Nil,
				Status2 = charStatuses.Nil,
				ValuesAreTheSame = true,
			},
			{
				Status1 = charStatuses.Succ,
				Status2 = charStatuses.Succ,
				ValuesAreTheSame = true,
			},
			{
				Status1 = charStatuses.Fail,
				Status2 = charStatuses.Fail,
				ValuesAreTheSame = true,
			},
			{
				Status1 = charStatuses.Fixed,
				Status2 = charStatuses.Fixed,
				ValuesAreTheSame = true,
			},
			{
				Status1 = charStatuses.Nil,
				Status2 = charStatuses.Succ,
				ValuesAreTheSame = false,
			},
			{
				Status1 = charStatuses.Succ,
				Status2 = charStatuses.Fail,
				ValuesAreTheSame = false,
			},
			{
				Status1 = charStatuses.Fail,
				Status2 = charStatuses.Fixed,
				ValuesAreTheSame = false, --error --false
			},
			-- todo add corrupted status
		}

		for idx, set in pairs(sets) do
			local compareRes = sut(set.Status1, set.Status2)
			if compareRes ~= set.ValuesAreTheSame then
				return core.NewTestErr("wrong output: expected")
			end
		end

		return nil
	end),

	StatusComparationFluent = core.NewTest("check status comparation FLUENT", function()
		return AAA.NewForSUT(char.CompareStatuses)
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
			 :Exec()
	end),

	CharStatusComparation = core.NewTest("check char's status comparation", function()
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
	StatusSwitching = core.NewTest("check statuses check after overlays", function()
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

	OutputDependingOnStatus = core.NewTest("check char values depending on it's status", function()
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

		return nil
	end),
}
