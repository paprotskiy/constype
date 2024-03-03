local function tableSize(t)
	local count = 0
	for k, v in pairs(t) do
		count = count + 1
	end
	return count
end

local function tableSizeWithoutFunc(t)
	local count = 0
	for k, v in pairs(t) do
		if type(v) ~= "function" then
			count = count + 1
		end
	end
	return count
end

local deepEqualIgnoreFuncs
deepEqualIgnoreFuncs = function(a, b)
	local comparedTypesAreFuncOrNil = (type(a) == "function" or type(a) == "nil")
		 and (type(b) == "function" or type(b) == "nil")
	if not comparedTypesAreFuncOrNil and type(a) ~= type(b) then
		return string.format("(nested) types mismatch")
	end

	if type(a) == "function" then
		return nil
	elseif type(a) == "table" then
		-- local sizeA, sizeB = tableSize(a), tableSize(b)
		-- todo
		local sizeA, sizeB = tableSizeWithoutFunc(a), tableSizeWithoutFunc(b)
		if sizeA ~= sizeB then
			return string.format('table sizes ("%s" and "%s") mismatch', sizeA, sizeB)
		end
		for key in pairs(a) do
			local res = deepEqualIgnoreFuncs(a[key], b[key])
			if res ~= nil then
				return res
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
