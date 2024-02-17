local char = require("app.lexic.char")

return {
	NewTopic = function(rawText, charParser)
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
}
