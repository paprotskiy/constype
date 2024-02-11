package.path = package.path .. ";../?.lua"
local pp = require("utils.print.pretty")

local function printBriefReportToTerminal(report)
	print(pp.PrettyPrint(report))
end

local function printVerboseReportToTerminal(reportRecords)
	local namedReports = {}
	for _, r in pairs(reportRecords) do
		if not r.ok then
			local msg = string.format('"%s": %s', r.testName, r.errMessage)
			table.insert(namedReports, msg)
		end
	end

	if #namedReports > 0 then
		print(pp.PrettyPrint(namedReports))
	end
end

return {
    brief = printBriefReportToTerminal,
    verbose = printVerboseReportToTerminal
}