return {
	first_unfinished = function(_, storage, plan_id)
		local res = storage.get_first_unfinished_topic(plan_id)
		return res
	end,
}
