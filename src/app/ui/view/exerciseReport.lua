local tty = require("app.ui.tty.tty")

return {
	Close = function()
		tty.ClearScreen()
		tty.Jump(1, 1)
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function(_, report)
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.ClearScreen()

		local winsize = tty:WinSize()
		local offsetX = winsize.MaxX // 2
		local offsetY = winsize.MaxY // 3

		tty.Jump(offsetY, offsetX)
		tty.Print(report.Good)

		tty.Jump(offsetY, offsetX + 1)
		tty.Print(report.Errors)

		tty.Jump(offsetY, offsetX + 2)
		tty.Print(report.TimeTotal)

		tty.Jump(offsetY, offsetX + 3)
		tty.Print(report.TimeLostOnErrors)
	end,
}
