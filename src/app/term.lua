-- local plterm = require("plterm")
local luaterm = require("term")

-- print([[
-- row 1
-- row 2
-- row 3
-- row 4
-- ]])
-- plterm.golc(1, 1)

return {
	ClearScreen = function()
		luaterm.clear()
		io.flush()
	end,
	-- Mode1 = function(text)
	-- 	print("")
	--
	-- 	while true do
	-- 		-- plterm.setrawmode()
	-- 		os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
	-- 		local char = string.byte(io.read(1))
	-- 		io.write(char)
	-- 		os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	-- 	end
	-- end,

	Mode1 = function(text)
		luaterm.clear()
		luaterm.cursor.jump(1, 1)
		io.flush()
		io.write(text)
		luaterm.cursor.jump(1, 1)
		io.flush()
		-- print("some text2")
		-- print("some text3")

		-- luaterm.cursor.jump(1, 1)
		-- print("some text1")
		-- print(luaterm.isatty(io.stdout))

		for i = 1, 10, 1 do
			-- plterm.setrawmode()
			os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")

			local char = string.byte(io.read(1))

			print(char)
			os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
		end

		print()
		print()
	end,

	-- Mode2 = function(text)
	-- 	plterm.reset()
	-- 	plterm.golc(1, 1)
	-- 	io.flush()
	-- 	io.write("text: \n")
	-- 	io.write(text)
	-- 	plterm.golc(1, 1)
	-- 	io.flush()
	-- 	-- local colors = luaterm.colors
	-- 	-- io.write(colors.red .. "h" .. colors.reset)
	-- 	-- io.write(colors.red .. "h" .. colors.reset)
	-- 	-- io.write(colors.red .. "h" .. colors.reset)
	-- 	-- io.write(colors.red .. "h" .. colors.reset)
	-- 	-- io.flush()
	-- 	--
	-- 	-- -- plterm.getscrlc()
	-- 	-- plterm.outf("plterm.out\n")
	--
	-- 	local str = ""
	-- 	for i = 1, 10, 1 do
	-- 		-- os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
	-- 		-- local char = io.read(1)
	--
	-- 		plterm.outf("plterm.out\n")
	-- 		local iterator = plterm.rawinput()
	-- 		local char = iterator()
	-- 		str = str .. char
	--
	-- 		-- io.write(char)
	-- 		-- plterm.right(1)
	--
	-- 		-- os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	-- 	end
	--
	-- 	print()
	-- 	print()
	-- 	print(str)
	-- end,
}
