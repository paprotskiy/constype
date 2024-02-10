return {
	tests = {},

	Add = function(self, testFunc)
		local key = tostring(testFunc)
		self.tests[key] = testFunc

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
