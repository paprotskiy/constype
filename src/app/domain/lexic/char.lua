local digest = require("hashings.sha256")
local period = require("app.time.period")

local overlay_statuses = {
	null = "not-overlayed",
	succ = "successfully-overlayed",
	fail = "failed-to-overlay",
	fixed = "overlay-fixed",

	in_rate = function(self, status)
		return status == self.null or status == self.succ or status == self.fail or status == self.fixed
	end,

	compare_statuses = function(self, status1, status2)
		if not self:in_rate(status1) then
			error("status1 is corrupted")
		end
		if not self:in_rate(status2) then
			error("status2 is corrupted")
		end

		return status1 == status2
	end,
}

local function pattern_for_match(same, prev_status)
	local is_bool = same == true or same == false
	assert(is_bool, "same must be bool, actually " .. tostring(same), 2)
	assert(overlay_statuses:in_rate(prev_status), "unknown overlay type: " .. tostring(prev_status), 2)

	return {
		__same = same,
		__prev_status = prev_status,

		hash = function(self)
			local str = tostring(self.__same) .. "~" .. tostring(self.__prev_status)
			return digest:new(str):hexdigest()
		end,
	}
end

local status_switches = {
	[pattern_for_match(true, overlay_statuses.null):hash()] = overlay_statuses.succ,
	[pattern_for_match(true, overlay_statuses.succ):hash()] = overlay_statuses.succ,
	[pattern_for_match(true, overlay_statuses.fail):hash()] = overlay_statuses.fixed,
	[pattern_for_match(true, overlay_statuses.fixed):hash()] = overlay_statuses.fixed,
	[pattern_for_match(false, overlay_statuses.null):hash()] = overlay_statuses.fail,
	[pattern_for_match(false, overlay_statuses.succ):hash()] = overlay_statuses.fail,
	[pattern_for_match(false, overlay_statuses.fail):hash()] = overlay_statuses.fail,
	[pattern_for_match(false, overlay_statuses.fixed):hash()] = overlay_statuses.fail,
}

return {
	-- todo cover with tests
	new = function(char, ticker)
		return {
			__base = char,
			__overlay = nil,
			__overlay_status = overlay_statuses.null,
			__ticker = ticker,
			__ok_overlaying_time = period.new(0),
			__bad_overlaying_time = period.new(0),
		}
	end,

	statuses = function()
		-- todo extract to deepCopy package?
		local res = {}
		for k, v in pairs(overlay_statuses) do
			res[k] = v
		end
		return res
	end,

	compare_statuses = function(status1, status2)
		return overlay_statuses:compare_statuses(status1, status2)
	end,

	compare_char_status = function(self, char, status)
		return self.compare_statuses(char.__overlay_status, status)
	end,

	overlay = function(char, overlay_char)
		if overlay_char ~= nil and overlay_char:len() ~= 1 then
			error("overlay_char must be one symbol string")
		end

		char.__overlay = overlay_char

		local same_values = char.__base == char.__overlay
		local prevState = char.__overlay_status
		local curr = pattern_for_match(same_values, prevState)

		local new_status = status_switches[curr:hash()]
		if new_status == nil then
			error("unknown pattern for match")
		end

		char.__overlay_status = new_status

		if char.__ticker == nil then
			return
		end

		local interval = char.__ticker:click_stop_watch()
		if new_status == overlay_statuses.succ or new_status == overlay_statuses.fixed then
			char.__ok_overlaying_time = char.__ok_overlaying_time:add(interval)
		else
			char.__bad_overlaying_time = char.__bad_overlaying_time:add(interval)
		end
	end,

	display = function(char)
		local val = char.__base
		if char.__overlay ~= nil then
			val = char.__overlay
		end

		return {
			value = val,
			status = char.__overlay_status,
		}
	end,

	extract_status = function(char)
		return char.__overlay_status
	end,

	timing = function(char)
		return {
			ok = char.__ok_overlaying_time,
			bad = char.__bad_overlaying_time,
		}
	end,
}
