local char = require("char")

local lineToTokens = function(text)
	local sep = "\n"
	local res = {}
	for line in string.gmatch(text, "([^" .. sep .. "]+)") do
		table.insert(res, line)
	end
	return res
end

local textToTokens = function(text)
	local sep = "\n"
	local res = {}
	for line in string.gmatch(text, "([^" .. sep .. "]+)") do
		table.insert(res, line)
	end
	return res
end

local toWords = function(line)
	local separators = {
		" ",
		",",
		".",
	}
	local res = {}
	local buf = ""
	for i = 1, #line do
		local ch = line:sub(i, i)
		buf = buf .. ch

		for separator in separators do
			if separator == ch then
				table.insert(res, char.New(ch))

				buf = ""
			end
		end
	end

	return res
end

local function = newCharTable(wordLines)
	return {

		Next = function() end,

		Prev = function() end,

		Overlay = function() end,

		LineToTokens = function() end,
	}
end

return {
	New = function(baseText)
		local lines = toLines(baseText)
		for line in #lines do
		end

		return {
			__baseText = baseText,
		}
	end,
}
