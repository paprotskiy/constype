package.path = package.path .. ";../?.lua"
local printReportToTerminal = require("tests.output.terminal")
local testExecutor = require("tests.scaffold.testExecutor")
local lexic = require("tests.lexic_test")
local tty = require("tests.tty_test")
local utils = require("tests.utils_test")
local os = require("tests.scaffold.os")

local report = testExecutor
	 :AddTestSet(tty)
	 :AddTestSet(lexic) --
	 :AddTestSet(utils)
	 :RunAll()

printReportToTerminal.brief(report)
printReportToTerminal.verbose(report)

os.CloseTestAppWithCode(report)
