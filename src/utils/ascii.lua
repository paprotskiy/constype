local iconv = require("iconv")

local function simple(text)
	local ascii_text = ""
	for i = 1, #text do
		local char_code = text:byte(i)
		if char_code < 128 then
			-- ASCII characters, keep as is
			ascii_text = ascii_text .. string.char(char_code)
		else
			-- Non-ASCII characters, transliterate or remove
			-- add custom transliteration logic as needed
			-- Here, we're simply removing non-ASCII characters
			ascii_text = ascii_text .. "?"
		end
	end
	return ascii_text
end

return {
	unicode_to_ascii = simple,
}
