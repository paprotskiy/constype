local prettyPrint
prettyPrint = function(val, intendance, offset)
	intendance = intendance or ""
	offset = offset or "\t"

	if type(val) == "table" then
		local fields = ""
		for k, v in pairs(val) do
			local newIntendance = intendance .. offset
			local subprint = prettyPrint(v, newIntendance)
			local index = v.Idx or ""
			fields = fields .. newIntendance .. '[' .. k .. ']: ' .. index ..  subprint .. "\n" -- todo make prettier
		end
		return "{\n" .. fields .. intendance .. "}"
	else
		return tostring(val)
	end
end

local prettyPrintTestsHelper
prettyPrintTestsHelper = function(val)
	local fields = {}
	for k, v in pairs(val) do
		fields[k] = v.test_name .. ": ".."\n" .. "\t" .. v.Error .."\n"
	end
	return fields
end

local prettyPrintTests
prettyPrintTests = function(value, intendance, offset)
	local val =  prettyPrintTestsHelper(value)
	intendance = intendance or ""
	offset = offset or "\t"
	if type(val) == "table" then
		local fields = ""
		for k, v in pairs(val) do
			local newIntendance = intendance .. offset
			local subprint = prettyPrint(v, newIntendance)
			fields = fields .. newIntendance .. '[' .. k .. '] ' ..  subprint .. "\n"
		end
		return "{\n" .. fields .. intendance .. "}"
	else
		return tostring(val)
	end
end



return {
	PrettyPrint = prettyPrint,
	PrettyPrintTests = prettyPrintTests
}
