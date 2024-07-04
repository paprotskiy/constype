local overlayable_char = require("app.domain.lexic.char")

local alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
local digits = "0123456789"
local signsIncludedInWords = '-".,'
local all = alphabet .. digits .. signsIncludedInWords

local function new_charset(rawText, stopWatch)
	local res = {}

	for letter in rawText:gmatch(".") do
		table.insert(res, overlayable_char.new(letter, stopWatch))
	end

	return res
end

local function rune_is_letter(rune)
	for letter in all:gmatch(".") do
		if rune == letter then
			return true
		end
	end

	return false
end

local function split_to_words(chared_text)
	if #chared_text == 0 then
		return {}
	end

	local res = {}
	local word = {}

	for _, rune in pairs(chared_text) do
		if rune_is_letter(rune.__base) then
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
	new_charset = new_charset,
	split_to_words = split_to_words,
}
