local customAssert = require("utils.assert")
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

local function joinTables(main, aux)
	customAssert(type(main) == "table", "first element must be the table", 2)
	customAssert(type(aux) == "table", "second element must be the table", 2)

	local res = {}
	for k, v in pairs(main) do
		res[k] = v
	end

	for k, v in pairs(aux) do
		if type(k) == "number" then
			table.insert(res, v)
		elseif type(k) == "string" and res[k] == nil then
			res[k] = v
		end
	end

	return res
end

local subquery = {
	SplitByIndex = splitByIndex,
	JoinTables = joinTables,
}

return subquery
