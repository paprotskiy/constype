return {
	tests = {},

	AddTest = function(self, testFunc)
		local key = tostring(testFunc)
		self.tests[key] = testFunc

		return self
	end,

	AddTestSet = function(self, testFuncTable)
		for _, testFunc in pairs(testFuncTable) do
			local key = tostring(testFunc)
			self.tests[key] = testFunc
		end

		return self
	end,

	RunAll = function(self)
		local results = {}

		for _, test in pairs(self.tests) do
			local res = test.exec()

			local errMessage = nil
			if res ~= nil then
				errMessage = res.ErrMessage
			end

			table.insert(results, {
				testName = test.name,
				ok = res == nil,
				errMessage = errMessage,
			})
		end

		return results
	end,
}
