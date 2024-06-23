local tty = require("app.ui.tty.tty")

-- todo testing needed
local function centerRowPool(winsize, twoDimTable)
	local heigth = #twoDimTable
	local width = 0
	for _, row in pairs(twoDimTable) do
		local unwrapped = tty.DropColorWrap(row)
		local len = utf8.len(unwrapped)
		if len > width then
			width = len
		end
	end

	return {
		OffsetX = (winsize.MaxX - width) // 2,
		OffsetY = (winsize.MaxY - heigth) * 3 // 7,
	}
end

local function offsetRowPool(lines, winsize)
	local offset = centerRowPool(winsize, lines)
	local res = {}

	for idx = 1, winsize.MaxY, 1 do
		table.insert(res, {
			X = winsize.MaxX // 2,
			Y = idx,
			line = "│",
		})
	end

	for idx = 1, winsize.MaxX, 1 do
		table.insert(res, {
			X = idx,
			Y = offset.OffsetY + #lines // 2 + 1,
			line = "─",
		})
	end

	for idx, raw in pairs(lines) do
		table.insert(res, {
			X = offset.OffsetX,
			Y = offset.OffsetY + idx,
			line = raw,
		})
	end

	return res
end

return {
	OffsetRowPool = offsetRowPool,
}
