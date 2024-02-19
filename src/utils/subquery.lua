local pp = require("utils.print.pretty")

local function splitByIndex(arr, idx)
	local left, right = {}, {}
	for i = 1, #arr, 1 do
		if i < idx then
			table.insert(left, arr[i])
		else
			table.insert(right, arr[i])
		end
	end
	local res = {
		left = left,
		right = right,
	}

	return res
end

local subquery = {
	SplitByIndex = splitByIndex,
}

return subquery
