local customAssert = require("utils.assert")

return {
	ResizeLines = function(width, splitToWords, newLineBuilder, lines)
		customAssert(width > 0, "width must be positive value", 2)
		local all = {}

		for _, line in pairs(lines) do
			customAssert(line.AllChars ~= nil, "line must implement :AllChars", 2)
			for _, char in pairs(line:AllChars()) do
				table.insert(all, char)
			end
		end

		local words = splitToWords(all)
		local resized = {}
		local line = newLineBuilder()
		for _, word in pairs(words) do
			local lineNotEmpty = line:Length() > 0
			local additionOverflowsLine = line:Length() + #word > width
			if lineNotEmpty and additionOverflowsLine then
				table.insert(resized, line)
				line = newLineBuilder()
			end

			for _, v in pairs(word) do
				line:Append(v)
			end
		end
		if line:Length() > 0 then
			table.insert(resized, line)
		end

		return resized
	end,

	NewLine = function()
		return {
			__chars = {},

			Length = function(self)
				return #self.__chars
			end,

			Append = function(self, ch)
				customAssert(ch.__base ~= nil, "__base not found in char", 2)
				customAssert(ch.__overlayStatus ~= nil, "__overlayStatus not found in char", 2)

				table.insert(self.__chars, ch)
			end,

			AppendAll = function(self, chars)
				for _, v in pairs(chars) do
					self:Append(v)
				end
			end,

			AllChars = function(self)
				return self.__chars
			end,
		}
	end,
}
