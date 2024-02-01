package.path = package.path .. ";../?.lua"
local core = require("tests.scaffold.scaffold")
local char = require("tests.char_test")
local pp = require("src.print.pretty")

local tests = {}
local testExecutor = {
	Add = function(self, testFunc)
		local name = testFunc.name
		tests[name] = testFunc.exec

		return self
	end,

	RunAll = function(self)
		print("run all tests:")

		local failed = {}
		for k, v in pairs(tests) do
			local res = v()
			local err = core.GetTestErrMessage(res, true)
			if err ~= nil then
				table.insert(failed, {
					Idx = k,
					Error = err,
				})
			end
			print(k, res == nil)
		end

		if #failed > 0 then
			print("failed " .. tostring(#failed) .. " test(s):")
			print(pp.PrettyPrint(failed))
		end

		return self
	end,
}

testExecutor
	:Add(char.CheckStatuses) -- commment for preventing autoformatter from linearizing
	:Add(char.CheckStatusSwitching)
	:RunAll()
