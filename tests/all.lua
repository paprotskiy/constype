package.path = package.path .. ";../?.lua"
local testExecutor = require("tests.scaffold.testExecutor")
local char = require("tests.char_test")

testExecutor
    :Add(char.Statuses)
    :Add(char.StatusComparation)
    :Add(char.CharStatusComparation)
    :Add(char.StatusSwitching)
    :Add(char.OutputDependingOnStatus)
    :RunAll()
