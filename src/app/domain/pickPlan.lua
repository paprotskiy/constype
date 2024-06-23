local subquery = require("utils.query")

return {
	__plans = nil,

	New = function(self, storage)
		local plans = storage.GetPlans()

		self.__plans = subquery.SortTable(plans, function(a, b)
			return a.Title > b.Title
		end)

		return self
	end,

	List = function(self)
		return self.__plans
	end,
}
