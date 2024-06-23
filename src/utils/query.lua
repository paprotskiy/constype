local customAssert = require("utils.assert")

local function splitByIndex(arr, idx)
	local left, right = {}, {}
	for i = 1, #arr, 1 do
		if i < idx then
			table.insert(left, arr[i])
		else
			table.insert(right, arr[i])
		end
	end

	return {
		left = left,
		right = right,
	}
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

local function deepCopy(orig)
	if type(orig) == "table" then
		local copy = {}
		for key, value in next, orig, nil do
			copy[deepCopy(key)] = deepCopy(value)
		end

		return copy
	end

	return orig
end

local function sortTable(t, compareFunc)
	local res = deepCopy(t)

	for i = 1, #res - 1, 1 do
		for j = i + 1, #res, 1 do
			if compareFunc(res[i], res[j]) then
				res[i], res[j] = res[j], res[i]
			end
		end
	end

	return res
end

local subquery = {
	SplitByIndex = splitByIndex,
	JoinTables = joinTables,
	SortTable = sortTable,
}

return subquery
