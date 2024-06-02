local tty = require("app.ui.tty.tty")

return {
	Close = function()
		tty.ClearScreen()
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function()
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")

		tty.ClearScreen()

		local msg = "For Start Press Enter"
		local winsize = tty:WinSize()
		local offsetX = winsize.MaxX // 2
		local offsetY = (winsize.MaxY - #msg) // 2

		tty.Jump(offsetY, offsetX)
		tty.Print(msg)
	end,

	Jump = function(x, y)
		tty.Jump(x, y)
	end,

	Print = function(txt)
		tty.Print(txt)
	end,
}
