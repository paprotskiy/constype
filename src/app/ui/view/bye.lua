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
		local offsetY = (winsize.MaxY - #msg) // 2
		local offsetX = winsize.MaxX // 2

		tty.Jump(offsetX, offsetY)
		tty.Print(msg)
	end,
}
