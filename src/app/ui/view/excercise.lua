local tty = require("app.ui.tty.tty")

return {
	Close = function()
		tty.ClearScreen()
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function()
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")

		tty.ClearScreen()

		local winsize = tty:WinSize()
		local offsetY = winsize.MaxY // 2
		local offsetX = winsize.MaxX // 2

		tty.Jump(offsetX, offsetY)
		tty.Print("Kinda excercise")
	end,

	Jump = function(x, y)
		tty.Jump(x, y)
	end,

	Print = function(txt)
		tty.Print(txt)
	end,
}
