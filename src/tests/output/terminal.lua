package.path = package.path .. ";../?.lua"
local pp = require("utils.print.pretty")

local function print_brief_report_to_terminal(report)
	local total = #report
	local okCount = 0
	local failed = {}
	for _, r in pairs(report) do
		if r.ok then
			okCount = okCount + 1
		else
			table.insert(failed, r)
		end
	end

	if total ~= okCount + #failed then
		error(string.format("classification is broken (total: %s, ok: %s, failed: %s)", total, okCount, #failed))
	end

	if total == okCount then
		print("\27[32mok\27[0m")
		return
	end

	for _, v in pairs(failed) do
		local label = "\27[31mfailed\27[0m"
		print(string.format("%s %s", label, v.testName))
	end
end

local function print_verbose_report_to_terminal(reportRecords)
	local named_reports = {}
	for _, r in pairs(reportRecords) do
		if not r.ok then
			local msg = string.format('"%s": %s', r.testName, r.errMessage)
			table.insert(named_reports, msg)
		end
	end

	if #named_reports > 0 then
		print(pp.pretty_print(named_reports))
	end
end

return {
	brief = print_brief_report_to_terminal,
	verbose = print_verbose_report_to_terminal,
}
