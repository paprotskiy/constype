package.path = package.path .. ";../../?.lua"
local luaterm = require("term")

local function clearScreen()
	luaterm.clear()
	luaterm.cursor.jump(1, 1)
	io.flush()
end

local function clearRestOfLine()
	luaterm.cleareol()
	io.flush()
end

return {
	ClearScreen = clearScreen,
	ClearLine = clearRestOfLine,

	EraseLast = function(eraseChar)
		luaterm.cursor.goleft(1)
		io.flush()
		io.write(eraseChar)
		io.flush()
		luaterm.cursor.goleft(1)
		io.flush()
	end,

	EventDriver = function()
		return io.read(1)
	end,

	Print = function(text)
		io.write(text)
		io.flush()
	end,

	Jump = function(x, y)
		luaterm.cursor.jump(x, y)
		io.flush()
	end,

	ParseTtySizeOutput = function(input)
		local parts = {}

		for str in string.gmatch(input, "([^ ]+)") do
			table.insert(parts, str)
		end

		if #parts ~= 2 then
			error(string.format("wrong input composition: contains %s parts, expected %s", #parts, 2))
		end

		local maxX = tonumber(parts[1])
		local maxY = tonumber(parts[2])

		if maxX == nil or maxY == nil or maxX <= 0 or maxY <= 0 then
			error(string.format('failed to parse "%s" to number pair', input))
		end

		return {
			MaxX = maxX,
			MaxY = maxY,
		}
	end,

	WinSize = function(self)
		for _ = 1, 10, 1 do
			local file = assert(io.popen("stty size", "r"))
			local output = file:read("*all")

			local size = nil
			local _, err = pcall(function()
				size = self.ParseTtySizeOutput(output)
				io.flush()
			end)

			if err == nil and size ~= nil then
				return {
					MaxX = size.MaxX,
					MaxY = size.MaxY,
				}
			end
		end

		error("failed to get terminal's winsize")
	end,

	Mode = function(self, text)
		self.ClearScreen()

		os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
		while true do
			local whole = {}
			for i = 1, 10, 1 do
				local rune = io.read(1)
				table.insert(whole, string.byte(rune))
				-- whole = whole .. rune
				-- local char = string.byte()
				-- io.flush()
				-- self.WinSize()
				luaterm.cursor.goleft(1)
				io.write("\n")
				io.write(string.byte(rune))
				io.flush()
			end

			for k, v in pairs(whole) do
				print()
				print(v)
			end
		end
		os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	end,
}
