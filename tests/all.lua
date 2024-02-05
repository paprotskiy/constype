package.path = package.path .. ";../?.lua"
local testExecutor = require("tests.scaffold.testExecutor")
local char = require("tests.char_test")

testExecutor
	 :Add(char.Statuses)
	 :Add(char.StatusComparation)
	 :Add(char.StatusSwitching)
	 :Add(char.OutputDependingOnStatus)
	 :RunAll()
