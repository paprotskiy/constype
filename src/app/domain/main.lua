local text = require("app.topics.example")

return {
	FirstUnfinished = function(self, storage, planId)
		local firstUnfinished = storage.GetFirstUnfinishedTopic(planId)
		return firstUnfinished
	end,
}
