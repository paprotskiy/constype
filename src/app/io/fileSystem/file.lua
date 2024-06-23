local function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

local function lines_from(file)
	assert(file_exists(file), "file " .. file .. " does not exist")

	local lines = {}
	for line in io.lines(file) do
		table.insert(lines, line)
	end
	return lines
end

local function toFile(modifier, filePath, data)
	local f = io.open(filePath, modifier)

	assert(f ~= nil, "failed to open file")

	f:write(data)
	f:flush()
	f:close()
end

return {
	ReadFileLines = function(filePath)
		return lines_from(filePath)
	end,

	ReadFile = function(filePath)
		local lines = lines_from(filePath)
		return table.concat(lines, "\n")
	end,

	WriteFile = function(filePath, data)
		toFile("w", filePath, data)
	end,

	AppendFile = function(filePath, data)
		toFile("w", filePath, data)
	end,
}
