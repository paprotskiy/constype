local custom_assert = require("utils.assert")

return {
	resize_lines = function(width, split_to_words, new_line_builder, lines)
		custom_assert(width > 0, "width must be positive value", 2)
		local all = {}

		for _, line in pairs(lines) do
			custom_assert(line.all_chars ~= nil, "line must implement :all_chars", 2)
			for _, char in pairs(line:all_chars()) do
				table.insert(all, char)
			end
		end

		local words = split_to_words(all)
		local resized = {}
		local line = new_line_builder()
		for _, word in pairs(words) do
			local line_not_empty = line:length() > 0
			local addition_overflows_line = line:length() + #word > width
			if line_not_empty and addition_overflows_line then
				table.insert(resized, line)
				line = new_line_builder()
			end

			for _, v in pairs(word) do
				line:append(v)
			end
		end
		if line:length() > 0 then
			table.insert(resized, line)
		end

		return resized
	end,

	newLine = function()
		return {
			__chars = {},

			length = function(self)
				return #self.__chars
			end,

			append = function(self, ch)
				custom_assert(ch.__base ~= nil, "__base not found in char", 2)
				custom_assert(ch.__overlay_status ~= nil, "__overlay_status not found in char", 2)

				table.insert(self.__chars, ch)
			end,

			append_all = function(self, chars)
				for _, v in pairs(chars) do
					self:append(v)
				end
			end,

			all_chars = function(self)
				return self.__chars
			end,
		}
	end,
}
