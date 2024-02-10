return {
	CloseTestAppWithCode = function(report)
		local total = #report
		local okCount = 0
		local failCount = 0
		for _, r in pairs(report) do
			if r.ok then
				okCount = okCount + 1
			else
				failCount = failCount + 1
			end
		end

		if total ~= okCount + failCount then
			os.exit(2)
		end

		if failCount ~= 0 then
			os.exit(1)
		end

		os.exit(0)
	end,
}
