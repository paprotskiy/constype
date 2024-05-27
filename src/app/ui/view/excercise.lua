local tty = require("app.ui.tty.tty")

return {
	Close = function()
		tty.ClearScreen()
		tty.Jump(1, 1)
		os.execute("stty echo -cbreak </dev/tty >/dev/tty 2>&1")
	end,

	Load = function(_, text)
		os.execute("stty -echo cbreak </dev/tty >/dev/tty 2>&1")
		tty.ClearScreen()

		tty.Jump(1, 1)
		tty.Print(text)
		tty.Jump(1, 1)
	end,

	Jump = function(x, y)
		tty.Jump(x, y)
	end,

	Print = function(data)
		tty.Print(data)
	end,

	CurrentWinsize = function()
		local ws = tty:WinSize()
		return {
			MaxX = ws.MaxX,
			MaxY = ws.MaxY,
		}
	end,

	-- todo maybe should not be moved automatically
	Refresh = function(_, tokens)
		for _, v in pairs(tokens) do
			tty.Jump(v.x, v.y)
			tty.Print(v.data)
		end
	end,

	WrapTextToColor = function(colorIdx, defaultIdx)
		return function(text)
			return tty.PrintWithColor(colorIdx, defaultIdx, text)
		end
	end,
}
