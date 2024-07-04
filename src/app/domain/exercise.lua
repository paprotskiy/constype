-- local custom_assert = require("utils.assert")
local overlayable_char = require("app.domain.lexic.char")
local topic = require("app.domain.lexic.topic")
local charset = require("app.domain.lexic.charset")
local char = require("app.domain.lexic.char")
local stopwatch = require("app.time.stopwatch")

local function rewrite_and_move(val, position, next_position)
	-- custom_assert(type(val) == "string", "val must be a string", 2)
	-- custom_assert(#val == 1, "val length must be 1", 2)
	return {
		position = position,
		value = char.display(val).value,
		status = char.extract_status(val),
		jump = next_position,
	}
end

return {
	new = function(_, text, text_width)
		local chared_text = charset.new_charset(text, stopwatch.new())
		local new_topic = topic:new(chared_text, charset.split_to_words)

		new_topic:resize_lines(text_width)

		return {
			__chared_topic = new_topic,

			plain_text = function(self)
				local lines = self.__chared_topic:get_lines()

				local strLines = {}
				for _, line in pairs(lines) do
					local row = ""
					for _, c in pairs(line:all_chars()) do
						row = row .. char.display(c).value
					end
					table.insert(strLines, row)
				end

				return table.concat(strLines, "\n")
			end,

			done = function(self)
				local last_char = self.__chared_topic:last_char()
				local succ = char:compare_char_status(last_char, overlayable_char:statuses().succ)
				local fixed = char:compare_char_status(last_char, overlayable_char:statuses().fixed)
				return succ or fixed
			end,

			erase_symbol = function(self)
				local prev = self.__chared_topic:get_prev()
				if prev == nil then
					return nil
				end

				if self.__on_last_symbol then
					self.__on_last_symbol = false
				else
					self.__chared_topic:move(prev)
				end

				local curr = self.__chared_topic:get_current()
				self.__chared_topic:overlay(nil, curr)

				local ch = self.__chared_topic:char(curr)

				return rewrite_and_move(ch, curr, prev)
			end,

			type_symbol = function(self, symbol)
				local curr = self.__chared_topic:get_current()
				self.__chared_topic:overlay(symbol, curr)
				local ch = self.__chared_topic:char(curr)

				local jump = self.__chared_topic:get_next()
				if jump == nil then
					jump = curr
					self.__on_last_symbol = true
				else
					self.__chared_topic:move(jump)
				end

				return rewrite_and_move(ch, curr, jump)
			end,

			get_topic = function(self)
				return self.__chared_topic
			end,
		}
	end,
}
