local subquery = require("utils.query")

return {
	__list = nil,

	new = function(self)
		self.__list = {
            {title = "pick-plan"},
            {title = "import-as-plan"}
        }

		return self
	end,

	list = function(self)
		return self.__list
	end,
}
