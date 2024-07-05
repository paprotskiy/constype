local function tableContainsElement(t, elem)
	for _, v in pairs(t) do
		if v == elem then
			return true
		end
	end
	return false
end

local function tableSizeWithoutFuncAndFields(targetTable, ...)
	local args = { ... }

	local count = 0
	for k, v in pairs(targetTable) do
		local in_ignore_list = tableContainsElement(args, k)
		if (not in_ignore_list) and type(v) ~= "function" then
			count = count + 1
		end
	end
	return count
end

local function appendTableOfKeys(targetTable, keys)
	assert(keys ~= nil, "keys table must be not empty")

	for k, _ in pairs(targetTable) do
		keys[k] = k
	end

	return keys
end

local function deleteKeysFromTable(targetTable, ...)
	local arg = { ... }

	for _, k in pairs(arg) do
		targetTable[k] = nil
	end

	return targetTable
end

local function funcInTheTable(a, b)
	local type_func = "function"
	local typenil = "nil"

	local bothFuncs = type(a) == type_func and type(b) == type_func
	local firstFunc = type(a) == type_func and type(b) == typenil
	local secondFunc = type(a) == typenil and type(b) == type_func

	return bothFuncs or firstFunc or secondFunc
end

local deepEqualIgnoreFuncsAndFields
deepEqualIgnoreFuncsAndFields = function(a, b, ...)
	local arg = { ... }
	if type(a) ~= type(b) then
		return string.format("(nested) types mismatch")
	end

	if type(a) == "table" then
		local sizeA = tableSizeWithoutFuncAndFields(a, table.unpack(arg))
		local sizeB = tableSizeWithoutFuncAndFields(b, table.unpack(arg))
		if sizeA ~= sizeB then
			return string.format('table sizes ("%s" and "%s") mismatch', sizeA, sizeB)
		end

		local allKeys = {}
		appendTableOfKeys(a, allKeys)
		appendTableOfKeys(b, allKeys)
		allKeys = deleteKeysFromTable(allKeys, table.unpack(arg))

		for key, _ in pairs(allKeys) do
			if not funcInTheTable(a[key], b[key]) then
				local res = deepEqualIgnoreFuncsAndFields(a[key], b[key], table.unpack(arg))
				if res ~= nil then
					return string.format("[%s]:%s", key, res)
				end
			end
		end
		return nil
	else
		if a == b then
			return nil
		end
		return string.format('(nested) values mismatch: "%s" and "%s"', a, b)
	end
end

return {
	DeepEqualIgnoreFuncs = function(a, b)
		return deepEqualIgnoreFuncsAndFields(a, b)
	end,

	DeepEqualIgnoreFuncsAndFields = deepEqualIgnoreFuncsAndFields,
}
