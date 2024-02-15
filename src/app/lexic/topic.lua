local char = require("app.lexic.char")

return {
	NewTopic = function(rawText)
		local res = {}
		for letter in rawText:gmatch(".") do
			table.insert(res, char.New(letter))
		end

		return res
	end,
}
