package.path = package.path .. ";../?.lua"
local testExecutor = require("tests.scaffold.testExecutor")
local char = require("tests.char_test")
local printReportToTerminal = require("tests.output.terminal")
local os = require("tests.os")

local report = testExecutor
	:Add(char.Statuses)
	:Add(char.StatusComparation)
	:Add(char.CharStatusComparation)
	:Add(char.StatusSwitching)
	:Add(char.OutputDependingOnStatus)
	:Add(char.TstAAA)
	:RunAll()

printReportToTerminal.brief(report)
printReportToTerminal.verbose(report)

os.CloseTestAppWithCode(report)
