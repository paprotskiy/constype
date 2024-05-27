-- local customAssert = require("utils.assert")
local overlayableChar = require("app.domain.lexic.char")
local topic = require("app.domain.lexic.topic")
local charset = require("app.domain.lexic.charset")
local char = require("app.domain.lexic.char")

local function rewriteAndMove(val, position, nextPosition)
	-- customAssert(type(val) == "string", "val must be a string", 2)
	-- customAssert(#val == 1, "val length must be 1", 2)
	return {
		Position = position,
		Value = char.Display(val).Value,
		Status = char.ExtractStatus(val),
		Jump = nextPosition,
	}
end

return {
	New = function(_, text, textWidth)
		-- todo move to text picker
		text = (text):gsub("\n", "")
		text = (text):gsub("\r", "")
		-- todo move to text picker
		local charedText = charset.NewCharset(text)
		local newTopic = topic:New(charedText, charset.SplitToWords)

		newTopic:ResizeLines(textWidth)

		return {
			__charedTopic = newTopic,

			PlainText = function(self)
				local lines = self.__charedTopic:GetLines()

				local strLines = {}
				for _, line in pairs(lines) do
					local row = ""
					for _, c in pairs(line:AllChars()) do
						row = row .. char.Display(c).Value
					end
					table.insert(strLines, row)
				end

				return table.concat(strLines, "\n")
			end,

			Done = function(self)
				local lastChar = self.__charedTopic:LastChar()
				local succ = char:CompareCharStatus(lastChar, overlayableChar:Statuses().Succ)
				local fixed = char:CompareCharStatus(lastChar, overlayableChar:Statuses().Fixed)
				return succ or fixed
			end,

			EraseSymbol = function(self)
				local prev = self.__charedTopic:GetPrev()
				if prev == nil then
					return nil
				end

				if self.__onLastSymbol then
					self.__onLastSymbol = false
				else
					self.__charedTopic:Move(prev)
				end

				local curr = self.__charedTopic:GetCurrent()
				self.__charedTopic:Overlay(nil, curr)

				local ch = self.__charedTopic:Char(curr)

				return rewriteAndMove(ch, curr, prev)
			end,

			TypeSymbol = function(self, symbol)
				local curr = self.__charedTopic:GetCurrent()
				self.__charedTopic:Overlay(symbol, curr)
				local ch = self.__charedTopic:Char(curr)

				local jump = self.__charedTopic:GetNext()
				if jump == nil then
					jump = curr
					self.__onLastSymbol = true
				else
					self.__charedTopic:Move(jump)
				end

				return rewriteAndMove(ch, curr, jump)
			end,

			GetTopic = function(self)
				return self.__charedTopic
			end,
		}
	end,
}
