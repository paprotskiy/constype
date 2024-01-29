-- PLAN:
--
-- print out any text serialized from file as set of chars
-- overlay it on terminal
-- overlay it via serialization (save to file)
--

local cons = require("plterm")

_G.str = ""

print([[
qqqqqqqqqqqqqqqqqqqq
aaaaaaaaaaaaaaaaaaaa
zzzzzzzzzzzzzzzzzzzz
]])

cons.golc(1, 1)
while true do
	-- os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
	-- local char = io.read(1)

	local iterator = cons.rawinput()
	local char = iterator()

	-- io.write(char)
	-- cons.right(1)

	-- os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
end
