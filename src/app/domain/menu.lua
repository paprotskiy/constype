local subquery = require("utils.query")

return {
	__list = nil,

	New = function(self)
		self.__list = {
            {Title = "pick-plan"},
            {Title = "import-as-plan"}
        }

		return self
	end,

	List = function(self)
		return self.__list
	end,
}
