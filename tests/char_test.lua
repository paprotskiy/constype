package.path = package.path .. ";../?.lua"
local core = require("tests.scaffold.scaffold")
local char = require("src.lexic.char")

return {
	CheckStatuses = core.NewTest("check all statuses copied successfully", function()
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

	CheckStatusOnCreating = core.NewTest("check statuses check after overlays", function()
		local sut = char.New("x")

		local sets = {
			{
				Overlay = "x",
				Expected = char.Statuses(),
			},
		}

		local actual = char.Overlay(sut, "x")

		return nil
	end),

	CheckStatusSwitching = core.NewTest("check statuses check after overlays", function()
		local statuses = {
			Nil = char.Statuses().Nil,
			Succ = char.Statuses().Succ,
			Fail = char.Statuses().Fail,
			Fixed = char.Statuses().Fixed,
		}

		local sut = char.New("x")
		local sets = {
			{
				Overlay = "x",
				PreStatus = statuses.Nil,
				PostStatus = statuses.Succ,
			},
			{
				Overlay = "y",
				PreStatus = statuses.Succ,
				PostStatus = statuses.Fail,
			},
			{
				Overlay = "x",
				PreStatus = statuses.Fail,
				PostStatus = statuses.Fixed,
			},
			{
				Overlay = "x",
				PreStatus = statuses.Fixed,
				PostStatus = statuses.Fixed,
			},
		}

		for idx, set in pairs(sets) do
			if char.Display(sut).Status ~= set.PreStatus then
				return core.NewTestErr("PreStatus wrong for checkup #" .. tostring(idx))
			end

			char.Overlay(sut, set.Overlay)

			if char.Display(sut).Status ~= set.PostStatus then
				return core.NewTestErr("PreStatus wrong for checkup #" .. tostring(idx))
			end
		end

		return nil
	end),
}
