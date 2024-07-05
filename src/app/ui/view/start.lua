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

		local msg = "For Start Press Enter"
		local winsize = tty:wins_size()
		local offsetX = (winsize.max_x - #msg) // 2
		local offsetY = winsize.max_y // 2

		tty.jump(offsetX, offsetY)
		tty.print(msg)
	end,

	jump = function(x, y)
		tty.jump(x, y)
	end,

	print = function(txt)
		tty.print(txt)
	end,
}
