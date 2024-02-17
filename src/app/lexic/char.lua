local digest = require("hashings.sha256")

local overlayStatuses = {
	Nil = "not-overlayed", --error overlayed
	Succ = "successfully-overlayed",
	Fail = "failed-to-overlay",
	Fixed = "overlay-fixed",

	InRate = function(self, status)
		return status == self.Nil or status == self.Succ or status == self.Fail or status == self.Fixed
	end,

	CompareStatuses = function(self, status1, status2)
		if not self:InRate(status1) then
			error("status1 is corrupted")
		end
		if not self:InRate(status2) then
			error("status2 is corrupted")
		end

		return status1 == status2
	end,
}

local function patternForMatch(same, prevStatus)
	local isBool = same == true or same == false
	assert(isBool, "same must be bool, actually " .. tostring(same), 2)
	assert(overlayStatuses:InRate(prevStatus), "unknown overlay type: " .. tostring(prevStatus), 2)

	return {
		__same = same,
		__prevStatus = prevStatus,

		Hash = function(self)
			local str = tostring(self.__same) .. "~" .. tostring(self.__prevStatus)
			return digest:new(str):hexdigest()
		end,
	}
end

local statusSwitches = {
	[patternForMatch(true, overlayStatuses.Nil):Hash()] = overlayStatuses.Succ,
	[patternForMatch(true, overlayStatuses.Succ):Hash()] = overlayStatuses.Succ,
	[patternForMatch(true, overlayStatuses.Fail):Hash()] = overlayStatuses.Fixed,
	[patternForMatch(true, overlayStatuses.Fixed):Hash()] = overlayStatuses.Fixed,
	[patternForMatch(false, overlayStatuses.Nil):Hash()] = overlayStatuses.Fail,
	[patternForMatch(false, overlayStatuses.Succ):Hash()] = overlayStatuses.Fail,
	[patternForMatch(false, overlayStatuses.Fail):Hash()] = overlayStatuses.Fail,
	[patternForMatch(false, overlayStatuses.Fixed):Hash()] = overlayStatuses.Fail,
}

return {
	-- todo cover with tests
	New = function(char)
		return {
			__base = char,
			__overlay = nil,
			__overlayStatus = overlayStatuses.Nil,
		}
	end,

	Statuses = function()
		-- todo extract to deepCopy package?
		local res = {}
		for k, v in pairs(overlayStatuses) do
			res[k] = v
		end
		return res
	end,

	CompareStatuses = function(status1, status2)
		return overlayStatuses:CompareStatuses(status1, status2)
	end,

	CompareCharStatus = function(self, char, status)
		return self.CompareStatuses(char.__overlayStatus, status)
	end,

	Overlay = function(char, overlayChar)
		if overlayChar ~= nil and overlayChar:len() ~= 1 then
			error("overlayChar must be one symbol string")
		end

		char.__overlay = overlayChar

		local sameValues = char.__base == char.__overlay
		local prevState = char.__overlayStatus
		local curr = patternForMatch(sameValues, prevState)

		local newStatus = statusSwitches[curr:Hash()]
		if newStatus == nil then
			error("unknown pattern for match")
		end

		char.__overlayStatus = newStatus
	end,

	Display = function(char)
		local val = char.__base
		if char.__overlay ~= nil then
			val = char.__overlay
		end

		return {
			Value = val,
			Status = char.__overlayStatus,
		}
	end,
}
