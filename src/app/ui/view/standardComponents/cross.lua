local tty = require("app.ui.tty.tty")

-- todo testing needed
local function center_row_pool(winsize, two_dim_table)
	local heigth = #two_dim_table
	local width = 0
	for _, row in pairs(two_dim_table) do
		local unwrapped = tty.drop_color_wrap(row)
		local len = utf8.len(unwrapped)
		if len > width then
			width = len
		end
	end

	return {
		offset_x = (winsize.max_x - width) // 2,
		offset_y = (winsize.max_y - heigth) * 3 // 7,
	}
end

local function offset_row_pool(lines, winsize)
	local offset = center_row_pool(winsize, lines)
	local res = {}

	for idx = 1, winsize.max_y, 1 do
		table.insert(res, {
			X = winsize.max_x // 2,
			Y = idx,
			line = "│",
		})
	end

	for idx = 1, winsize.max_x, 1 do
		table.insert(res, {
			X = idx,
			Y = offset.offset_y + #lines // 2 + 1,
			line = "─",
		})
	end

	for idx, raw in pairs(lines) do
		table.insert(res, {
			X = offset.offset_x,
			Y = offset.offset_y + idx,
			line = raw,
		})
	end

	return res
end

return {
	offset_row_pool = offset_row_pool,
}
