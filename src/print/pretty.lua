local prettyPrint
prettyPrint = function(val, intendance)
	intendance = intendance or ""

	if type(val) == "table" then
		local fields = ""
		for k, v in pairs(val) do
			local newIntendance = intendance .. "\t"
			local subprint = prettyPrint(v, newIntendance)
			fields = fields .. newIntendance .. '"' .. k .. '": ' .. subprint .. "\n" -- todo make prettier
		end
		return "{\n" .. fields .. intendance .. "}"
	else
		return tostring(val)
	end
end

return {
	PrettyPrint = prettyPrint,
}
