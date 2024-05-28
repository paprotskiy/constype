-- local topic = require("app.domain.lexic.topic")
local char = require("app.domain.lexic.char")
local period = require("app.time.period")

local function badRatio(good, bad)
	local ratio = 1 - good / (good + bad)

	local integerPart = math.floor(ratio)
	local fractionalPart = ratio - integerPart
	local firstThreeDigits = math.floor(fractionalPart * 100) / 100
	return integerPart + firstThreeDigits
end

return {
	BuildReport = function(topic)
		local chars = topic:ExportAsSingleLine():AllChars()
		local statuses = char.Statuses()

		local good = 0
		local fixed = 0
		local bad = 0
		local goodTiming = period.New(0)
		local errTiming = period.New(0)
		for idx, ch in pairs(chars) do
			local timing = char.Timing(ch)
			goodTiming:Add(timing.Ok)
			errTiming:Add(timing.Bad)

			if char:CompareCharStatus(ch, statuses.Succ) then
				good = good + 1
			elseif char:CompareCharStatus(ch, statuses.Fixed) then
				fixed = fixed + 1
			else
				bad = bad + 1
			end
		end

		local errRatio = 1
		local wastedTimeRatio = 1
		if bad == 0 then
			errRatio = badRatio(good, fixed + bad)
			wastedTimeRatio = badRatio(goodTiming:Milliseconds(), errTiming:Milliseconds())
		end

		return {
			Good = good,
			Fixed = fixed,
			Errors = bad,
			TimeTotal = period.New(0):Add(goodTiming):Add(errTiming):Milliseconds() / 1000,
			TimeLostOnErrors = errTiming:Milliseconds() / 1000,
			ErrorsRatio = errRatio,
			WastedTimeRatio = wastedTimeRatio,
		}
	end,
}
