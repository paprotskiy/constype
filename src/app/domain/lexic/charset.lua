local overlayableChar = require("app.domain.lexic.char")
local pp = require("utils.print.pretty")

local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
local digits = "0123456789"
local signsIncludedInWords = '-".,'
local all = alphabet .. digits .. signsIncludedInWords

local function newCharset(rawText)
	local res = {}

	for letter in rawText:gmatch(".") do
		table.insert(res, overlayableChar.New(letter))
	end

	return res
end

local function runeIsLetter(rune)
	for letter in all:gmatch(".") do
		if rune == letter then
			return true
		end
	end

	return false
end

local function splitToWords(charedText)
	if #charedText == 0 then
		return {}
	end

	local res = {}
	local word = {}

	for _, rune in pairs(charedText) do
		if runeIsLetter(rune.__base) then
			table.insert(word, rune)
		else
			if #word > 0 then
				table.insert(res, word)
				word = {}
			end
			table.insert(res, { rune })
		end
	end

	if #word > 0 then
		table.insert(res, word)
	end

	return res
end

return {
	NewCharset = newCharset,
	SplitToWords = splitToWords,
}
