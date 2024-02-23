local customAssert = require("utils.assert")
local overlayableChar = require("app.lexic.char")

function NewLine(chars)
	return {
		__chars = chars,

		Length = function(self)
			return #self.__chars
		end,

		Append = function(self, additionalChars)
			for _, ch in additionalChars do
				table.insert(self.__chars, ch)
			end
		end,
	}
end

function ResizeLines(lines, width, splitToWords)
	local all = {}
	for _, line in pairs(lines) do
		for _, char in pairs(line.AllChars()) do
			table.insert(all, char)
		end
	end

	local words = splitToWords(all)
	local resized = {}
	local line = NewLine({})
	for _, word in pairs(words) do
		if line.Length() + #word < width then
			line:Append(word)
		else
			table.insert(resized, line)
			line = NewLine({})
		end
	end

	return resized
end

function NewPosition(lineNum, charNum)
	customAssert(type(lineNum) == "number", "lineNum must be a number", 2)
	customAssert(type(charNum) == "number", "charNum must be a number", 2)
	customAssert(lineNum < 1, "lineNum must be a more or equal to 1", 2)
	customAssert(charNum < 1, "charNum must be a more or equal to 1", 2)

	return {
		LineNum = lineNum,
		CharNum = charNum,
	}
end

return {
	Topic = {
		__lines = {},

		__position = nil,
		__currLineNum = -1,
		__currCharNum = -1,
		__splitToWords = nil,

		New = function(self, charedText, splitToWords)
			customAssert(self ~= nil, "self is not specified", 2)
			customAssert(splitToWords ~= nil, "splitToWords is not specified", 2)
			customAssert(charedText ~= nil, "charedText is not specified", 2)
			customAssert(#charedText > 0, "charedText must be not empty", 2)

			self.__splitToWords = splitToWords
			self.ResizeLines(self, #charedText + 1)
			self.__position = NewPosition(1, 1)

			return self
		end,

		ResizeLines = function(self, width)
			self.__lines = ResizeLines(self.__lines, width, self.__splitToWords)
		end,

		-- GetLine = function(self, lineNum)
		-- 	return self.__lines[lineNum]
		-- end,

		WordUnderCursor = function()
			-- search left border of token
			-- search right border of token
			error("implement me")
			return {}
		end,

		Move = function(self, LineNum, CharNum)
			if self.Closed() then
				error("cannot make move - topic is closed")
			end

			error("implement me")
		end,

		GetPrev = function(self)
			local p = self.__position

			if p.LineNum == 1 and p.CharNum == 1 then
				return nil
			end

			if p.CharNum == 1 then
				local newLineNum = p.LineNum - 1
				local newCharNum = self.__lines[p.LineNum]:Length()
				return NewPosition(newLineNum, newCharNum)
			end

			return NewPosition(p.LineNum, p.CharNum - 1)
		end,

		GetNext = function(self)
			local p = self.__position
			local lastIdxForCurrLine = self.__lines[p.LineNum]:Length() == p.CharNum
			local lastLine = p.LineNum == #self.__lines
			if lastLine and lastIdxForCurrLine then
				return nil
			end

			if lastIdxForCurrLine then
				return NewPosition(p.LineNum + 1, 1)
			end

			return NewPosition(p.LineNum, p.CharNum + 1)
		end,

		MoveNext = function(self)
			local position = self.GetNext()
			if position == nil then
				return nil
			end

			self.Move(self, position.LineNum, position.CharNum)
			return position
		end,

		Overlay = function(self, char)
			local lineIdx = self.__currLineNum
			local charIdx = self.__currCharNum
			local originChar = self.__lines[lineIdx].__char[charIdx]
			overlayableChar.Overlay(originChar, char)
		end,

		-- OverlayByCoord = function(self, lineNum, charNum, char)
		-- 	self.Move(self, lineNum, charNum)
		-- 	local originChar = self.__lines[lineNum].__char[charNum]
		-- 	overlayableChar.Overlay(originChar, char)
		-- end,

		OverlayNext = function(self, char)
			local position = self.MoveNext()
			self.Overlay(self, position.LineNum, position.CharNum, char)

			return self.Closed()
		end,

		-- todo tests needed
		LastChar = function(self)
			local lastLineIdx = #self.__lines
			local lastLine = self.__lines[lastLineIdx]

			local lastCharIdx = #lastLine
			local lastChar = lastLine[lastCharIdx]

			return lastChar
		end,
	},
}
