package.path = package.path .. ";../../?.lua"
local luaterm = require("term")

return {
	clear_screen = function()
		luaterm.clear()
		luaterm.cursor.jump(1, 1)
		io.flush()
	end,

	event_driver = function()
		return io.read(1)
	end,

	print = function(text)
		io.write(text)
		io.flush()
	end,

	jump = function(x, y)
		luaterm.cursor.jump(y, x)
		io.flush()
	end,

	parse_tty_size_output = function(input)
		local parts = {}

		for str in string.gmatch(input, "([^ ]+)") do
			table.insert(parts, str)
		end

		if #parts ~= 2 then
			error(string.format("wrong input composition: contains %s parts, expected %s", #parts, 2))
		end

		local max_x = tonumber(parts[2])
		local max_y = tonumber(parts[1])

		if max_x == nil or max_y == nil or max_x <= 0 or max_y <= 0 then
			error(string.format('failed to parse "%s" to number pair', input))
		end

		return {
			max_x = max_x,
			max_y = max_y,
		}
	end,

	wins_size = function(self)
		for _ = 1, 10, 1 do
			local file = assert(io.popen("stty size", "r"))
			local output = file:read("*all")

			local size = nil
			local _, err = pcall(function()
				size = self.parse_tty_size_output(output)
				io.flush()
			end)

			if err == nil and size ~= nil then
				return {
					max_x = size.max_x,
					max_y = size.max_y,
				}
			end
		end

		error("failed to get terminal's winsize")
	end,

	print_with_color = function(color_idx, default_idx, text)
		local prefix = "\27[" .. color_idx .. "m"
		local postfix = "\27[" .. default_idx .. "m"
		return prefix .. text .. postfix
	end,

	-- todo proper testing required
	drop_color_wrap = function(text)
		local ansi_escape_pattern = "\27%[[%d;]*m"
		return text:gsub(ansi_escape_pattern, "")
	end,
}
