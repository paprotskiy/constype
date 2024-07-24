local tty = require("app.ui.tty.tty")
local element_cross = require("app.ui.view.standardComponents.cross")

local function draw_stats()
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
	close = function()
		tty.clear_screen()
		tty.jump(1, 1)
		os.execute("tput cnorm")
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	load = function()
		os.execute("tput civis")
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.clear_screen()

		local winsize = tty:wins_size()

		local drawedStats = draw_stats()
		local offseted = element_cross.offset_row_pool(drawedStats, winsize)

		for _, row in pairs(offseted) do
			tty.jump(row.X, row.Y)
			tty.print(row.line)
		end
	end,

	-- wrap_text_to_color = function(color_idx, default_idx)
	-- 	return function(text)
	-- 		return tty.print_with_color(color_idx, default_idx, text)
	-- 	end
	-- end,
}
