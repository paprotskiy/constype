local tty = require("app.ui.tty.tty")
local elementCross = require("app.ui.view.standardComponents.cross")

local function drawStats()
	local template = {
		"╔══════════════════════════════════════════════════╗",
		"║  ------------ Whole Plan Statistics -----------  ║",
		"╠══════════════════════════════════════════════════╣",
		"║             will be implemented later            ║",
		"╚══════════════════════════════════════════════════╝",
	}

	return template
end

return {
	Close = function()
		tty.ClearScreen()
		tty.Jump(1, 1)
		os.execute("tput cnorm")
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function()
		os.execute("tput civis")
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.ClearScreen()

		local winsize = tty:WinSize()

		local drawedStats = drawStats()
		local offseted = elementCross.OffsetRowPool(drawedStats, winsize)

		for _, row in pairs(offseted) do
			tty.Jump(row.X, row.Y)
			tty.Print(row.line)
		end
	end,

	-- WrapTextToColor = function(colorIdx, defaultIdx)
	-- 	return function(text)
	-- 		return tty.PrintWithColor(colorIdx, defaultIdx, text)
	-- 	end
	-- end,
}
