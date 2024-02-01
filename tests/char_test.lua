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
}
