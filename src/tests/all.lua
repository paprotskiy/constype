package.path = package.path .. ";../?.lua"
local printReportToTerminal = require("tests.output.terminal")
local testExecutor = require("tests.scaffold.testExecutor")
local bashtools = require("tests.tty_test")
local char = require("tests.char_test")
local os = require("tests.scaffold.os")

local report = testExecutor
    :Add(bashtools.TtySizeOutputParsing)
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
