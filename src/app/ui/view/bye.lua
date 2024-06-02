local tty = require("app.ui.tty.tty")

return {
	Close = function()
		tty.ClearScreen()
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function()
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")

		tty.ClearScreen()

		local msg = "shutting down"
		local winsize = tty:WinSize()
		local offsetX = winsize.MaxX // 2
		local offsetY = (winsize.MaxY - #msg) // 2

		tty.Jump(offsetY, offsetX)
		tty.Print(msg)
	end,
}
