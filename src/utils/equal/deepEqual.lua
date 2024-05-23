local function tableSizeWithoutFunc(t)
	local count = 0
	for k, v in pairs(t) do
		if type(v) ~= "function" then
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

local function funcInTheTable(a, b)
	local typeFunc = "function"
	local typeNil = "nil"

	local bothFuncs = type(a) == typeFunc and type(b) == typeFunc
	local firstFunc = type(a) == typeFunc and type(b) == typeNil
	local secondFunc = type(a) == typeNil and type(b) == typeFunc

	return bothFuncs or firstFunc or secondFunc
end

local deepEqualIgnoreFuncs
deepEqualIgnoreFuncs = function(a, b)
	if type(a) ~= type(b) then
		return string.format("(nested) types mismatch")
	end

	if type(a) == "table" then
		local sizeA, sizeB = tableSizeWithoutFunc(a), tableSizeWithoutFunc(b)
		if sizeA ~= sizeB then
			return string.format('table sizes ("%s" and "%s") mismatch', sizeA, sizeB)
		end

		local allKeys = {}
		appendTableOfKeys(a, allKeys)
		appendTableOfKeys(b, allKeys)
		for key, _ in pairs(allKeys) do
			if not funcInTheTable(a[key], b[key]) then
				local res = deepEqualIgnoreFuncs(a[key], b[key])
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
	DeepEqualIgnoreFuncs = deepEqualIgnoreFuncs,
}
