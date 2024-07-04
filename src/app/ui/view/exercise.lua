local tty = require("app.ui.tty.tty")

return {
	close = function()
		tty.clear_screen()
		tty.jump(1, 1)
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	load = function(_, text)
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.clear_screen()

		tty.jump(1, 1)
		tty.print(text)
		tty.jump(1, 1)
	end,

	jump = function(x, y)
		tty.jump(x, y)
	end,

	print = function(data)
		tty.print(data)
	end,

	current_winsize = function()
		local ws = tty:wins_size()
		return {
			max_x = ws.max_x,
			max_y = ws.max_y,
		}
	end,

	-- todo maybe should not be moved automatically
	refresh = function(_, tokens)
		for _, v in pairs(tokens) do
			tty.jump(v.x, v.y)
			tty.print(v.data)
		end
	end,

	wrap_text_to_color = function(color_idx, default_idx)
		return function(text)
			return tty.print_with_color(color_idx, default_idx, text)
		end
	end,
}
