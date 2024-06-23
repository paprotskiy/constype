local tty = require("app.ui.tty.tty")

return {
	Close = function()
		tty.ClearScreen()
		os.execute("tput cnorm")
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function()
		os.execute("tput civis")
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")

		tty.ClearScreen()

		local msg = "shutting down"
		local winsize = tty:WinSize()
		local offsetX = (winsize.MaxX - #msg) // 2
		local offsetY = winsize.MaxY // 2

		tty.Jump(offsetX, offsetY)
		tty.Print(msg)
	end,
}
