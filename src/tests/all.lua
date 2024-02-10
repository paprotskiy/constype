package.path = package.path .. ";../?.lua"
local testExecutor = require("tests.scaffold.testExecutor")
local pp = require("utils.print.pretty")
local char = require("tests.char_test")
local os = require("tests.os")

local report = testExecutor
	:Add(char.Statuses)
	:Add(char.StatusComparation)
	:Add(char.CharStatusComparation)
	:Add(char.StatusSwitching)
	:Add(char.OutputDependingOnStatus)
	:Add(char.TstAAA)
	:RunAll()

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

printBriefReportToTerminal(report)
printVerboseReportToTerminal(report)

os.CloseTestAppWithCode(report)
