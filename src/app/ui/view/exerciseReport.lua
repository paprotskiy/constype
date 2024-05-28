local tty = require("app.ui.tty.tty")
local elementCross = require("app.ui.view.elements.cross")

local function splitBySubstring(str, substr)
	local parts = {}
	local pattern = "(.-)" .. substr
	local lastIndex = 1

	for part in str:gmatch(pattern) do
		parts[#parts + 1] = part
		lastIndex = lastIndex + #part + #substr
	end

	parts[#parts + 1] = str:sub(lastIndex)

	return parts
end

local function drawStats(report)
	local template = {
		"╔══════════════════════════════════════════════════╗",
		"║ -----------------  Statistics  ----------------- ║",
		"╠══════════════════════════════════════════════════╣",
		"║ ┌───────────────────────────────┬──────────────┐ ║",
		"║ │             Correct symbol(s) │ $1           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │           Corrected symbol(s) │ $2           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │       Missed Errors symbol(s) │ $3           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │           TimeTotal second(s) │ $4           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │        LostOnErrors second(s) │ $5           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │                  Errors ratio │ $6           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │             Wasted time ratio │ $7           │ ║",
		"║ └───────────────────────────────┴──────────────┘ ║",
		"╚══════════════════════════════════════════════════╝",
	}

	local function replace(pattern, replacement)
		for idx, row in pairs(template) do
			local value = tostring(replacement.Value)

			while utf8.len(value) ~= utf8.len(pattern) do
				if utf8.len(value) > utf8.len(pattern) then
					pattern = pattern .. " "
				else
					value = value .. " "
				end
			end

			if replacement.StyleWrap ~= nil then
				value = replacement.StyleWrap(value)
			end

			local parts = splitBySubstring(row, pattern)
			template[idx] = table.concat(parts, value)
		end
	end

	replace("$1", report.Good)
	replace("$2", report.Fixed)
	replace("$3", report.Errors)
	replace("$4", report.TimeTotal)
	replace("$5", report.TimeLostOnErrors)
	replace("$6", report.ErrorsRatio)
	replace("$7", report.WastedTimeRatio)

	return template
end

return {
	Close = function()
		tty.ClearScreen()
		tty.Jump(1, 1)
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function(_, report)
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.ClearScreen()

		local winsize = tty:WinSize()

		local drawedStats = drawStats(report)
		local offseted = elementCross.offsetRowPool(drawedStats, winsize)

		for _, row in pairs(offseted) do
			tty.Jump(row.X, row.Y)
			tty.Print(row.line)
		end
	end,

	WrapTextToColor = function(colorIdx, defaultIdx)
		return function(text)
			return tty.PrintWithColor(colorIdx, defaultIdx, text)
		end
	end,
}
