local pp = require("utils.print.pretty")

-- todo testing needed
local function centerRowPool(winsize, twoDimTable)
	local heigth = #twoDimTable
	local width = 0
	for _, row in pairs(twoDimTable) do
		local len = utf8.len(row)
		if len > width then
			width = len
		end
	end

	return {

		OffsetY = (winsize.MaxX - heigth) // 3,
		OffsetX = (winsize.MaxY - width) // 2,
	}
end

local function offsetRowPool(lines, winsize)
	local offset = centerRowPool(winsize, lines)
	local res = {}

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
	offsetRowPool = offsetRowPool,
}
