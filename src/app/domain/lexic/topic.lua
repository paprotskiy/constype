local customAssert = require("utils.assert")
local overlayableChar = require("app.domain.lexic.char")
local lines = require("app.domain.lexic.lines")

function NewPosition(lineNum, charNum)
	customAssert(type(lineNum) == "number", "lineNum must be a number", 2)
	customAssert(type(charNum) == "number", "charNum must be a number", 2)
	customAssert(lineNum > 0, "lineNum must be a more or equal to 1", 2)
	customAssert(charNum > 0, "charNum must be a more or equal to 1", 2)

	return {
		LineNum = lineNum,
		CharNum = charNum,
	}
end

return {
	__lines = {},
	__position = nil,
	__splitToWords = nil,
	__totalLen = 0,

	New = function(self, charedText, splitToWords)
		customAssert(self ~= nil, "self is not specified", 2)
		customAssert(splitToWords ~= nil, "splitToWords is not specified", 2)
		customAssert(charedText ~= nil, "charedText is not specified", 2)
		customAssert(#charedText > 0, "charedText must be not empty", 2)

		self.__totalLen = #charedText
		self.__position = NewPosition(1, 1)
		self.__splitToWords = splitToWords

		local line = lines.NewLine()
		line:AppendAll(charedText)
		self.__lines = { line }
		self.ResizeLines(self, self.__totalLen + 1)

		return self
	end,

	ResizeLines = function(self, width)
		self.__lines = self.ExportResizedLines(self, width)
	end,

	ExportResizedLines = function(self, width)
		return lines.ResizeLines(width, self.__splitToWords, lines.NewLine, self.__lines)
	end,

	ExportAsSingleLine = function(self)
		return self.ExportResizedLines(self, self.__totalLen + 1)[1]
	end,

	GetLines = function(self)
		return self.__lines
	end,

	Move = function(self, position)
		self.__position = position
	end,

	GetCurrent = function(self)
		local p = self.__position
		return NewPosition(p.LineNum, p.CharNum)
	end,

	GetPrev = function(self)
		local p = self.__position

		if p.LineNum == 1 and p.CharNum == 1 then
			return nil
		end

		if p.CharNum == 1 then
			local newLineNum = p.LineNum - 1
			local newCharNum = self.__lines[newLineNum]:Length()
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

	Overlay = function(self, char, position)
		local lineIdx = position.LineNum
		local charIdx = position.CharNum
		local originChar = self.__lines[lineIdx].__chars[charIdx]
		overlayableChar.Overlay(originChar, char)
		self.__lines[lineIdx].__chars[charIdx] = originChar
	end,

	Char = function(self, position)
		return self.__lines[position.LineNum].__chars[position.CharNum]
	end,

	LastChar = function(self)
		local lastLineIdx = #self.__lines
		local lastLine = self.__lines[lastLineIdx]

		local lastCharIdx = lastLine:Length()
		local lastChar = lastLine:AllChars()[lastCharIdx]

		return lastChar
	end,
}
