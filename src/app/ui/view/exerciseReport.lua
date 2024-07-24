local tty = require("app.ui.tty.tty")
local element_cross = require("app.ui.view.standardComponents.cross")

local function split_by_substring(str, substr)
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

local function draw_stats(report)
	local template = {
		"╔══════════════════════════════════════════════════╗",
		"║ -----------------  Statistics  ----------------- ║",
		"╠══════════════════════════════════════════════════╣",
		"║ ┌───────────────────────────────┬──────────────┐ ║",
		"║ │             Correct symbol(s) │ $1           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │           Corrected symbol(s) │ $2           │ ║",
		"║ ├───────────────────────────────┼──────────────┤ ║",
		"║ │         Incorrected symbol(s) │ $3           │ ║",
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
			local value = tostring(replacement.value)

			while utf8.len(value) ~= utf8.len(pattern) do
				if utf8.len(value) > utf8.len(pattern) then
					pattern = pattern .. " "
				else
					value = value .. " "
				end
			end

			if replacement.style_wrap ~= nil then
				value = replacement.style_wrap(value)
			end

			local parts = split_by_substring(row, pattern)
			template[idx] = table.concat(parts, value)
		end
	end

	replace("$1", report.good)
	replace("$2", report.fixed)
	replace("$3", report.errors)
	replace("$4", report.time_total)
	replace("$5", report.time_lost_on_errors)
	replace("$6", report.errors_ratio)
	replace("$7", report.wasted_time_ratio)

	return template
end

return {
	close = function()
		tty.clear_screen()
		tty.jump(1, 1)
		os.execute("tput cnorm")
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	load = function(_, report)
		os.execute("tput civis")
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.clear_screen()

		local winsize = tty:wins_size()

		local drawedStats = draw_stats(report)
		local offseted = element_cross.offset_row_pool(drawedStats, winsize)

		for _, row in pairs(offseted) do
			tty.jump(row.X, row.Y)
			tty.print(row.line)
		end
	end,

	wrap_text_to_color = function(color_idx, default_idx)
		return function(text)
			return tty.print_with_color(color_idx, default_idx, text)
		end
	end,
}
