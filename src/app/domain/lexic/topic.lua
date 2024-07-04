local custom_assert = require("utils.assert")
local overlayable_char = require("app.domain.lexic.char")
local lines = require("app.domain.lexic.lines")

local function new_position(lineNum, charNum)
	custom_assert(type(lineNum) == "number", "lineNum must be a number", 2)
	custom_assert(type(charNum) == "number", "charNum must be a number", 2)
	custom_assert(lineNum > 0, "lineNum must be a more or equal to 1", 2)
	custom_assert(charNum > 0, "charNum must be a more or equal to 1", 2)

	return {
		line_num = lineNum,
		char_num = charNum,
	}
end

return {
	__lines = {},
	__position = nil,
	__split_to_words = nil,
	__totalLen = 0,

	new = function(self, chared_text, split_to_words)
		custom_assert(self ~= nil, "self is not specified", 2)
		custom_assert(split_to_words ~= nil, "split_to_words is not specified", 2)
		custom_assert(chared_text ~= nil, "chared_text is not specified", 2)
		custom_assert(#chared_text > 0, "chared_text must be not empty", 2)

		self.__totalLen = #chared_text
		self.__position = new_position(1, 1)
		self.__split_to_words = split_to_words

		local line = lines.newLine()
		line:append_all(chared_text)
		self.__lines = { line }
		self.resize_lines(self, self.__totalLen + 1)

		return self
	end,

	resize_lines = function(self, width)
		self.__lines = self.export_resized_lines(self, width)
	end,

	export_resized_lines = function(self, width)
		return lines.resize_lines(width, self.__split_to_words, lines.newLine, self.__lines)
	end,

	export_as_single_line = function(self)
		return self.export_resized_lines(self, self.__totalLen + 1)[1]
	end,

	get_lines = function(self)
		return self.__lines
	end,

	move = function(self, position)
		self.__position = position
	end,

	get_current = function(self)
		local p = self.__position
		return new_position(p.line_num, p.char_num)
	end,

	get_prev = function(self)
		local p = self.__position

		if p.line_num == 1 and p.char_num == 1 then
			return nil
		end

		if p.char_num == 1 then
			local newline_num = p.line_num - 1
			local newchar_num = self.__lines[newline_num]:length()
			return new_position(newline_num, newchar_num)
		end

		return new_position(p.line_num, p.char_num - 1)
	end,

	get_next = function(self)
		local p = self.__position
		local last_idx_for_curr_line = self.__lines[p.line_num]:length() == p.char_num
		local last_line = p.line_num == #self.__lines
		if last_line and last_idx_for_curr_line then
			return nil
		end

		if last_idx_for_curr_line then
			return new_position(p.line_num + 1, 1)
		end

		return new_position(p.line_num, p.char_num + 1)
	end,

	overlay = function(self, char, position)
		local line_idx = position.line_num
		local charIdx = position.char_num
		local origin_char = self.__lines[line_idx].__chars[charIdx]
		overlayable_char.overlay(origin_char, char)
		self.__lines[line_idx].__chars[charIdx] = origin_char
	end,

	char = function(self, position)
		return self.__lines[position.line_num].__chars[position.char_num]
	end,

	last_char = function(self)
		local last_line_idx = #self.__lines
		local last_line = self.__lines[last_line_idx]

		local last_charIdx = last_line:length()
		local last_char = last_line:all_chars()[last_charIdx]

		return last_char
	end,
}
