local function pretty_print(val, intendance, offset)
	intendance = intendance or ""
	offset = offset or "\t"

	if type(val) == "table" then
		local fields = ""
		for k, v in pairs(val) do
			local newIntendance = intendance .. offset
			local subprint = pretty_print(v, newIntendance)
			fields = fields .. newIntendance .. "[" .. k .. "]: " .. subprint .. "\n" -- todo make prettier
		end
		return "{\n" .. fields .. intendance .. "}"
	else
		return tostring(val)
	end
end

return {
	pretty_print = pretty_print,
}
