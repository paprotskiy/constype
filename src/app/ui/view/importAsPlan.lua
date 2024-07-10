local tty = require("app.ui.tty.tty")

return {
	close = function()
		tty.clear_screen()
		os.execute("tput cnorm")
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	load = function()
		os.execute("tput civis")
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")

		tty.clear_screen()

		local msg = "Will be implemented later"
		local winsize = tty:wins_size()
		local offset_x = (winsize.max_x - #msg) // 2
		local offset_y = winsize.max_y // 2

		tty.jump(offset_x, offset_y)
		tty.print(msg)
	end,
}
