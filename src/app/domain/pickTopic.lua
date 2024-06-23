return {
	FirstUnfinished = function(_, storage, planId)
		local firstUnfinished = storage.GetFirstUnfinishedTopic(planId)
		return firstUnfinished
	end,
}
