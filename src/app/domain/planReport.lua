-- local topic = require("app.domain.lexic.topic")
local cjson = require("cjson")
local char = require("app.domain.lexic.char")
local period = require("app.time.period")

local function set_precision(value, num_of_symbols_after_dot)
	local integer_part = math.floor(value)
	local fractional_part = value - integer_part

	local k = 10 ^ num_of_symbols_after_dot
	local after_comma = math.floor(fractional_part * k) / k
	return integer_part + after_comma
end

local function bad_ration(good, bad)
	return 1 - good / (good + bad)
end

local function table_copy_without_functions(data)
	local res = {}
	for k, v in pairs(data) do
		if type(v) == "table" then
			res[k] = table_copy_without_functions(v)
		elseif type(v) ~= "function" then
			res[k] = v
		end
	end
	return res
end

return {
	build_report = function(cfg_threshold, storage, topic_data, topic_walkthrough)
		local errs_threshold = cfg_threshold.errs
		local fixed_threshold = cfg_threshold.fixed

		local chars = topic_walkthrough:export_as_single_line():all_chars()
		local statuses = char.statuses()

		local good = 0
		local fixed = 0
		local bad = 0
		local good_timing = period.new(0)
		local err_timing = period.new(0)
		for _, ch in pairs(chars) do
			local timing = char.timing(ch)
			good_timing:add(timing.ok)
			err_timing:add(timing.bad)

			if char:compare_char_status(ch, statuses.succ) then
				good = good + 1
			elseif char:compare_char_status(ch, statuses.fixed) then
				fixed = fixed + 1
			else
				bad = bad + 1
			end
		end

		local err_ratio = 1
		local wasted_time_ratio = 1
		if bad <= errs_threshold then
			err_ratio = bad_ration(good, fixed + bad)
			wasted_time_ratio = bad_ration(good_timing:milliseconds(), err_timing:milliseconds())
		end
		local time_total_ms = period.new(0):add(good_timing):add(err_timing):milliseconds()
		local time_lost_on_errors_ms = err_timing:milliseconds()

		local save_to_storage = function()
			local walkthrough_without_funcs = table_copy_without_functions(topic_walkthrough)
			local json = cjson.encode(walkthrough_without_funcs)
			local topic_id = topic_data.topic_id
			local end_time = os.time()
			local start_time = end_time - time_total_ms / 1000
			local success = (fixed + bad) / (fixed + bad + good) <= fixed_threshold
			storage.save_training_run(topic_id, start_time, end_time, success, json)
		end
		save_to_storage()

		return {
			good = good,
			fixed = fixed,
			errors = bad,
			time_total = set_precision(time_total_ms / 1000, 2),
			time_lost_on_errors = set_precision(time_lost_on_errors_ms / 1000, 2),
			errors_ratio = set_precision(err_ratio, 3),
			wasted_time_ratio = set_precision(wasted_time_ratio, 3),
		}
	end,
}
