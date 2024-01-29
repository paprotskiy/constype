local digest = require("hashings.sha256")

local overlayStatuses = {
	Nil = "not-overlayed",
	Succ = "successfully-overlayed",
	Fail = "failed-to-overlay",
	Fixed = "overlay-fixed",

	InRate = function(self, idx)
		return idx == self.Nil or idx == self.Succ or idx == self.Fail or idx == self.Fixed
	end,
}

local function patternForMatch(same, prevStatus)
	local isBool = same == true or same == false
	if not isBool then
		error("same must be bool, actually " .. tostring(same))
	end

	if not overlayStatuses:InRate(prevStatus) then
		error("unknown overlay type: " .. tostring(prevStatus))
	end

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
	New = function(char)
		return {
			__base = char,
			__overlay = nil,
			__overlayStatus = overlayStatuses.Nil,
		}
	end,

	Overlay = function(char, overlayChar)
		if overlayChar:len() ~= 1 then
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
		if char.__overlay ~= nil then
			return char.__overlay
		end

		return char.__base
	end,
}
