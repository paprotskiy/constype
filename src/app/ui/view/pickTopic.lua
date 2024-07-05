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

		local msg = "picking the first unfinished topic in plan"
		local winsize = tty:wins_size()
		local offsetX = winsize.max_x // 2
		local offsetY = (winsize.max_y - #msg) // 2

		tty.jump(offsetX, offsetY)
		tty.print(msg)
	end,
}
