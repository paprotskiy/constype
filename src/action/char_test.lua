local char = require("char")

package.path = package.path .. ";../?.lua"
local pp = require("print.pretty")

local x = char.New("x")
print(pp.PrettyPrint(x))

char.Overlay(x, "x")
print(pp.PrettyPrint(x))

char.Overlay(x, "y")
print(pp.PrettyPrint(x))

char.Overlay(x, "x")
print(pp.PrettyPrint(x))

char.Overlay(x, "x")
print(pp.PrettyPrint(x))
