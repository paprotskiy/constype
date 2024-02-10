package.path = package.path .. ";../?.lua"
-- local tty = require("src.ui.tty.line")
local tty = require("app.ui.tty.line")

local inSkippedDiapason = function(i)
	return 50 < i and i < 85
end

local test = function()
	for i = 0, 110, 1 do
		if not inSkippedDiapason(i) then
			tty:PrintText("color: " .. i, i)
			print()
		end
	end
end
test()
