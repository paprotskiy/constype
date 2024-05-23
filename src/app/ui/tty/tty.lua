package.path = package.path .. ";../../?.lua"
local luaterm = require("term")

return {
	ClearScreen = function()
		luaterm.clear()
		luaterm.cursor.jump(1, 1)
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
		luaterm.cursor.jump(y, x)
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

	PrintWithColor = function(colorIdx, defaultIdx, text)
		local prefix = "\27[" .. colorIdx .. "m"
		local postfix = "\27[" .. defaultIdx .. "m"
		return prefix .. text .. postfix
	end,
}
