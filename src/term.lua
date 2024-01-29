local cons = require("plterm")

print([[
row 1
row 2
row 3
row 4
]])
cons.golc(1, 1)

while true do
	-- cons.setrawmode()
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
	local char = string.byte(io.read(1))
	io.write(char)
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
end
