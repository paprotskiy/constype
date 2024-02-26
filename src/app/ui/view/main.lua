local tty = require("app.ui.tty.tty")

return {
	Close = function()
		tty.ClearScreen()
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function()
		tty.ClearScreen()
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		print()
		print()
		print("                    MAIN")
		print()
		print()
		tty.Jump(1, 1)
	end,

	Jump = function(x, y)
		tty.Jump(x, y)
	end,

	Print = function(txt)
		tty.Print(txt)
	end,
}
