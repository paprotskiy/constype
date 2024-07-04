local subquery = require("utils.query")

return {
	__plans = nil,

	new = function(self, storage)
		local plans = storage.get_plans()

		self.__plans = subquery.sort_table(plans, function(a, b)
			return a.title > b.title
		end)

		return self
	end,

	list = function(self)
		return self.__plans
	end,
}
