local customAssert = require("utils.assert")
local subquery = require("utils.subquery")
local overlayableChar = require("app.lexic.char")

local tokenToSubtokens
tokenToSubtokens = function(charedText, nestingLevel, parent, primitive, ...)
	local subTokenSplitters = { ... }

	-- customAssert(#subTokenSplitters > 0, "subtoken splitters are not specified", 2)

	if #subTokenSplitters == 0 then
		return primitive(charedText)
	end

	local splitted = subquery.SplitByIndex(subTokenSplitters)
	local subTexts = splitted.left[1](charedText)
	local currentToken = {}
	local subTokens = {}
	for _, subText in pairs(subTexts) do
		table.insert(subTokens, tokenToSubtokens(subText, nestingLevel + 1, currentToken, splitted.right))
	end

	return {
		__parent = parent,
		__subTokens = subTokens,
	}
end

return {
	NewTopic = function(rawText, splitters)
		local data = {}
		for letter in rawText:gmatch(".") do
			table.insert(data, char.New(letter))
		end

		return {
			__current = 1,
			__data = data,

			Done = function(self)
				assert(self.__current <= #self.__data, "overlaying surpasses initial text")
				return self.__current == #self.__data
			end,

			Overlay = function(self, ch)
				if self:Done() then
					return
				end

				local current = self.__data[self.__current]
				char.Overlay(current, ch)

				self.__current = self.__current + 1
			end,

			Undo = function(self)
				if self.__current == 1 then
					return
				end

				local current = self.__data[self.__current]
				char.Overlay(current, nil)

				self.__current = self.__current - 1
			end,
		}
	end,

	ToWords = function(rawText)
		--
	end,

	NewTopic = function(rawText, width)
		local words = {}
		for word in rawText:gmatch("%S+") do
			table.insert(words, word)
		end
	end,
}
